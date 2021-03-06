unit Controllers.Cliente;

interface

uses
  Models.Cliente,
  System.Generics.Collections,
  System.SysUtils,
  Horse,
  Horse.Commons,
  Horse.GBSwagger,
  System.JSON,
  REST.Json,
  Repositories.Cliente,
  Repositories.Interfaces,
  Controllers.Interfaces;

type
  TControllerCliente = class(TInterfacedObject, IControllerCliente)
  private
    FRepositorioCliente: IRepositoryCliente;
    FCliente: TCliente;
    FClientes: TObjectList<TCliente>;
    constructor Create();
  public
    function ClienteExiste(Res: THorseResponse; const pIdentificadorCliente: string): Boolean;
    procedure ListarClientePorId(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure ListarClientes(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure CriarCliente(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure AtualizarCliente(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure ExcluirCliente(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure Routes();
    class function NovaInstancia(): IControllerCliente;
    destructor Destroy(); override;
  end;

implementation

{ TControllerCliente }

procedure TControllerCliente.AtualizarCliente(Req: THorseRequest; Res: THorseResponse; Next: TProc);
const
  FALHA_AO_ATUALIZAR_CLIENTE = 'Falha ao atualizar cliente.';
begin
  if (not ClienteExiste(Res, Req.Params['id'])) then
    Exit();

  FCliente := FRepositorioCliente.AtualizarCliente(
    Req.Params['id'], TJson.JsonToObject<TCliente>(Req.Body<TJSONObject>));

  if (Assigned(FCliente)) then
    Res.Send<TJsonObject>(TJson.ObjectToJsonObject(FCliente)).Status(THTTPStatus.Ok)
  else
    Res.Send(FALHA_AO_ATUALIZAR_CLIENTE).Status(THTTPStatus.BadRequest);
end;

function TControllerCliente.ClienteExiste(Res: THorseResponse; const pIdentificadorCliente: string): Boolean;
const
  CLIENTE_NAO_LOCALIZADO = 'N?o foi localizado o cliente com o id "%s"';
begin
  Result := True;

  if (not FRepositorioCliente.ClienteExiste(pIdentificadorCliente)) then
  begin
    Res.Send(Format(CLIENTE_NAO_LOCALIZADO, [pIdentificadorCliente])).Status(THTTPStatus.NotFound);
    Result := False;
  end;
end;

constructor TControllerCliente.Create();
begin
  FRepositorioCliente := TRepositoryCliente.NovaInstancia();
  FCliente := TCliente.Create();
  FClientes := TObjectList<TCliente>.Create();
end;

procedure TControllerCliente.CriarCliente(Req: THorseRequest; Res: THorseResponse; Next: TProc);
const
  FALHA_AO_CRIAR_CLIENTE = 'Falha ao criar o cliente.';
  NOME_CLIENTE_NAO_INFORMADO = 'O nome do cliente n?o foi informado.';
begin
  FCliente := TJson.JsonToObject<TCliente>(Req.Body<TJSONObject>);

  if (FCliente.Nome.Trim().IsEmpty()) then
  begin
    Res.Send(NOME_CLIENTE_NAO_INFORMADO).Status(THTTPStatus.BadRequest);
    Exit();
  end;

  FCliente := FRepositorioCliente.CriarCliente(FCliente);

  if (Assigned(FCliente)) then
    Res.Send<TJsonObject>(TJson.ObjectToJsonObject(FCliente)).Status(THTTPStatus.Created)
  else
    Res.Send(FALHA_AO_CRIAR_CLIENTE).Status(THTTPStatus.BadRequest);
end;

destructor TControllerCliente.Destroy;
begin
  FCliente.Free();
  FClientes.Free();
  inherited;
end;

procedure TControllerCliente.ExcluirCliente(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  if (not ClienteExiste(Res, Req.Params['id'])) then
    Exit();

  FRepositorioCliente.ExcluirCliente(Req.Params['id']);
  Res.Send('').Status(THTTPStatus.NoContent);
end;

procedure TControllerCliente.ListarClientePorId(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  if (not ClienteExiste(Res, Req.Params['id'])) then
    Exit();

  FCliente := FRepositorioCliente.ObterClientePorIdentificador(Req.Params['id']);
  Res.Send<TJsonObject>(TJson.ObjectToJsonObject(FCliente)).Status(THTTPStatus.OK);
end;

procedure TControllerCliente.ListarClientes(Req: THorseRequest; Res: THorseResponse; Next: TProc);
const
  CLIENTES_NAO_ENCONTRADOS = 'Nenhum cliente foi encontrado.';
var
  lCliente: TCliente;
  lJsonArray: TJsonarray;
  lJsonObject: TJsonObject;
begin
  FClientes := FRepositorioCliente.ObterClientes();

  if (not (Assigned(FClientes))) then
  begin
    Res.Send(CLIENTES_NAO_ENCONTRADOS).Status(THTTPStatus.NotFound);
    Exit();
  end;

  lJsonArray := TJSONArray.Create;

  for lCliente in FClientes do
  begin
    lJsonObject := TJson.ObjectToJsonObject(lCliente);
    lJsonArray.AddElement(lJsonObject);
  end;

  Res.Send<TJSONArray>(lJsonArray);
end;

class function TControllerCliente.NovaInstancia(): IControllerCliente;
begin
  Result := Self.Create();
end;

procedure TControllerCliente.Routes();
begin
  THorse.Get('/cliente/', ListarClientes);
  THorse.Get('/cliente/:id', ListarClientePorId);
  THorse.Post('/cliente/', CriarCliente);
  THorse.PUT('/cliente/:id', AtualizarCliente);
  THorse.Delete('cliente/:id', ExcluirCliente);

  Swagger
    .Path('cliente/{id}')
      .Tag('Cliente')
      .GET('Obter cliente pelo identificador', 'Visualizar os dados do cliente')
        .AddResponse(200, 'successful operation')
          .Schema(TCliente)
          .IsArray(False)
        .&End
        .AddResponse(400, 'Bad Request').&End
        .AddResponse(404, 'Not Found').&End
      .&End
      .Tag('Cliente')
      .PUT('Atualizar cliente', 'Atualizar o cadastro do cliente')
        .AddResponse(200, 'successful operation')
          .Schema(TCliente)
          .IsArray(False)
        .&End
        .AddResponse(400, 'Bad Request').&End
        .AddResponse(404, 'Not Found').&End
      .&End
      .Tag('Cliente')
      .DELETE('Excluir cliente', 'Excluir o cadastro do clientes')
        .AddResponse(204, 'No Content')
          .Schema(TCliente)
          .IsArray(False)
        .&End
        .AddResponse(400, 'Bad Request').&End
        .AddResponse(404, 'Not Found').&End
      .&End
    .&End
    .Path('cliente')
      .Tag('Cliente')
      .GET('Obter clientes', 'Listar todos os clientes')
        .AddResponse(200, 'successful operation')
          .Schema(TCliente)
          .IsArray(True)
        .&End
        .AddResponse(400, 'Bad Request').&End
        .AddResponse(404, 'Not Found').&End
        .&End
      .Tag('Cliente')
      .POST('Cadastrar cliente', 'Cadastrar p cliente')
        .AddParamBody('Dados do cliente')
          .Schema(TCliente)
        .&End
        .AddResponse(202, 'Created')
          .Schema(TCliente)
          .IsArray(True)
        .&End
        .AddResponse(400, 'Bad Request').&End
        .AddResponse(404, 'Not Found').&End
      .&End
    .&End
end;

end.
