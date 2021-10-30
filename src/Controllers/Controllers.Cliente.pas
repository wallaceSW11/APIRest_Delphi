unit Controllers.Cliente;

interface

uses
  Models.Cliente,
  System.Generics.Collections,
  System.SysUtils,
  Horse,
  Horse.Commons,
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
    function ClienteExiste(Res: THorseResponse; const pIdentificadorCliente: string): Boolean;
  public
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
  CLIENTE_NAO_LOCALIZADO = 'N�o foi localizado o cliente com o id "%s"';
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
begin
  FCliente := TJson.JsonToObject<TCliente>(Req.Body<TJSONObject>);
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
const
  ATUALIZADO_COM_SUCESSO = 'Atualizado com sucesso.';
begin
  if (not ClienteExiste(Res, Req.Params['id'])) then
    Exit();

  FRepositorioCliente.ExcluirCliente(Req.Params['id']);
  Res.Send(ATUALIZADO_COM_SUCESSO).Status(THTTPStatus.NoContent);
end;

procedure TControllerCliente.ListarClientePorId(Req: THorseRequest; Res: THorseResponse; Next: TProc);
const
  CLIENTE_NAO_ENCONTRADO = 'Cliente n�o encontrado com o id: "%s"';
begin
  FCliente := FRepositorioCliente.ObterClientePorIdentificador(Req.Params['id']);

  if (Assigned(FCliente)) then
    Res.Send<TJsonObject>(TJson.ObjectToJsonObject(FCliente)).Status(THTTPStatus.OK)
  else
    Res.Send(Format(CLIENTE_NAO_ENCONTRADO, [Req.Params['id']])).Status(THTTPStatus.NotFound);
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
end;

end.
