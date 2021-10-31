unit Controllers.ItensVendidos;

interface

uses
  Models.ItensVendidos,
  System.Generics.Collections,
  System.SysUtils,
  Horse,
  Horse.Commons,
  Horse.GBSwagger,
  System.JSON,
  REST.Json,
  Repositories.ItensVendidos,
  Repositories.Interfaces,
  Repositories.Produto,
  Repositories.Venda,
  Controllers.Interfaces;

type
  TControllerItensVendidos = class(TInterfacedObject, IControllerItensVendidos)
  private
    FRepositorioItensVendidos: IRepositoryItensVendidos;
    FItensVendidos: TItensVendidos;
    FListaItensVendidos: TObjectList<TItensVendidos>;
    FRepositorioProduto: IRepositoryProduto;
    FRepositorioVenda: IRepositoryVenda;
    constructor Create();
    function ItensVendidosExiste(Res: THorseResponse; const pIdentificadorItensVendidos: string): Boolean;
  public
    procedure ListarItensVendidosPorId(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure ListarItensVendidoss(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure CriarItensVendidos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure AtualizarItensVendidos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure ExcluirItensVendidos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure Routes();
    class function NovaInstancia(): IControllerItensVendidos;
    destructor Destroy(); override;
  end;

implementation

{ TControllerItensVendidos }

procedure TControllerItensVendidos.AtualizarItensVendidos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
const
  FALHA_AO_ATUALIZAR_ItensVendidos = 'Falha ao atualizar os itens vendidos.';
begin
  if (not ItensVendidosExiste(Res, Req.Params['id'])) then
    Exit();

  FItensVendidos := FRepositorioItensVendidos.AtualizarItensVendidos(
    Req.Params['id'], TJson.JsonToObject<TItensVendidos>(Req.Body<TJSONObject>));

  if (Assigned(FItensVendidos)) then
    Res.Send<TJsonObject>(TJson.ObjectToJsonObject(FItensVendidos)).Status(THTTPStatus.Ok)
  else
    Res.Send(FALHA_AO_ATUALIZAR_ItensVendidos).Status(THTTPStatus.BadRequest);
end;

function TControllerItensVendidos.ItensVendidosExiste(Res: THorseResponse; const pIdentificadorItensVendidos: string): Boolean;
const
  ItensVendidos_NAO_LOCALIZADO = 'Não foi localizado o ItensVendidos com o id "%s"';
begin
  Result := True;

  if (not FRepositorioItensVendidos.ItensVendidosExiste(pIdentificadorItensVendidos)) then
  begin
    Res.Send(Format(ItensVendidos_NAO_LOCALIZADO, [pIdentificadorItensVendidos])).Status(THTTPStatus.NotFound);
    Result := False;
  end;
end;

constructor TControllerItensVendidos.Create();
begin
  FRepositorioItensVendidos := TRepositoryItensVendidos.NovaInstancia();
  FItensVendidos := TItensVendidos.Create();
  FListaItensVendidos := TObjectList<TItensVendidos>.Create();
  FRepositorioProduto := TRepositoryProduto.NovaInstancia();
  FRepositorioVenda := TRepositoryVenda.NovaInstancia();
end;

procedure TControllerItensVendidos.CriarItensVendidos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
const
  PRODUTO_NAO_LOCALIZADO = 'O produto informado no item vendido não foi localizado.';
  VENDA_NAO_LOCALIZADA = 'A venda informada no item vendido não foi localizada.';
begin
  FItensVendidos := TJson.JsonToObject<TItensVendidos>(Req.Body<TJSONObject>);

  if (not FRepositorioProduto.ProdutoExiste(FItensVendidos.Produto.Id)) then
  begin
    Res.Send(PRODUTO_NAO_LOCALIZADO).Status(THTTPStatus.NotFound);
    Exit();
  end;

  if (not FRepositorioVenda.VendaExiste(FItensVendidos.Venda.Id)) then
  begin
    Res.Send(VENDA_NAO_LOCALIZADA).Status(THTTPStatus.NotFound);
    Exit();
  end;

  FItensVendidos := FRepositorioItensVendidos.CriarItensVendidos(FItensVendidos);
  Res.Send<TJsonObject>(TJson.ObjectToJsonObject(FItensVendidos)).Status(THTTPStatus.Created)
end;

destructor TControllerItensVendidos.Destroy;
begin
  FItensVendidos.Free();
  FListaItensVendidos.Free();
  inherited;
end;

procedure TControllerItensVendidos.ExcluirItensVendidos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  if (not ItensVendidosExiste(Res, Req.Params['id'])) then
    Exit();

  FRepositorioItensVendidos.ExcluirItensVendidos(Req.Params['id']);
  Res.Send('').Status(THTTPStatus.NoContent);
end;

procedure TControllerItensVendidos.ListarItensVendidosPorId(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  if (not ItensVendidosExiste(Res, Req.Params['id'])) then
    Exit();

  FItensVendidos := FRepositorioItensVendidos.ObterItensVendidosPorIdentificador(Req.Params['id']);
  Res.Send<TJsonObject>(TJson.ObjectToJsonObject(FItensVendidos)).Status(THTTPStatus.OK);
end;

procedure TControllerItensVendidos.ListarItensVendidoss(Req: THorseRequest; Res: THorseResponse; Next: TProc);
const
  ItensVendidosS_NAO_ENCONTRADOS = 'Nenhum item vendido foi encontrado.';
var
  lItensVendidos: TItensVendidos;
  lJsonArray: TJsonarray;
  lJsonObject: TJsonObject;
begin
  FListaItensVendidos := FRepositorioItensVendidos.ObterItensVendidoss();

  if (not (Assigned(FListaItensVendidos))) then
  begin
    Res.Send(ItensVendidosS_NAO_ENCONTRADOS).Status(THTTPStatus.NotFound);
    Exit();
  end;

  lJsonArray := TJSONArray.Create;

  for lItensVendidos in FListaItensVendidos do
  begin
    lJsonObject := TJson.ObjectToJsonObject(lItensVendidos);
    lJsonArray.AddElement(lJsonObject);
  end;

  Res.Send<TJSONArray>(lJsonArray);
end;

class function TControllerItensVendidos.NovaInstancia(): IControllerItensVendidos;
begin
  Result := Self.Create();
end;

procedure TControllerItensVendidos.Routes();
begin
  THorse.Get('/itensvendidos/', ListarItensVendidoss);
  THorse.Get('/itensvendidos/:id', ListarItensVendidosPorId);
  THorse.Post('/itensvendidos/', CriarItensVendidos);
  THorse.PUT('/itensvendidos/:id', AtualizarItensVendidos);
  THorse.Delete('itensvendidos/:id', ExcluirItensVendidos);

  Swagger
    .Path('itensvendidos/{id}')
      .Tag('Itens vendidos')
      .GET('Obter itens vendidos pelo identificador', 'Visualizar os dados dos itens vendidos')
        .AddResponse(200, 'successful operation')
          .Schema(TItensVendidos)
          .IsArray(False)
        .&End
        .AddResponse(400, 'Bad Request').&End
        .AddResponse(404, 'Not Found').&End
      .&End
      .Tag('Itens vendidos')
      .PUT('Atualizar itens vendidos', 'Atualizar o cadastro dos itens vendidos')
        .AddResponse(200, 'successful operation')
          .Schema(TItensVendidos)
          .IsArray(False)
        .&End
        .AddResponse(400, 'Bad Request').&End
        .AddResponse(404, 'Not Found').&End
      .&End
      .Tag('Itens vendidos')
      .DELETE('Excluir itens vendidos', 'Excluir o cadastro dos itens vendidos')
        .AddResponse(204, 'No Content')
          .Schema(TItens vendidos)
          .IsArray(False)
        .&End
        .AddResponse(400, 'Bad Request').&End
        .AddResponse(404, 'Not Found').&End
      .&End
    .&End
    .Path('itens vendidos')
      .Tag('Itens vendidos')
      .GET('Obter itens vendidoss', 'Listar todos os itens vendidos')
        .AddResponse(200, 'successful operation')
          .Schema(TItens vendidos)
          .IsArray(True)
        .&End
        .AddResponse(400, 'Bad Request').&End
        .AddResponse(404, 'Not Found').&End
        .&End
      .Tag('Itens vendidos')
      .POST('Cadastrar itens vendidos', 'Cadastrar os itens vendidos')
        .AddParamBody('Dados do itens vendidos')
          .Schema(TItens vendidos)
        .&End
        .AddResponse(202, 'Created')
          .Schema(TItens vendidos)
          .IsArray(True)
        .&End
        .AddResponse(400, 'Bad Request').&End
        .AddResponse(404, 'Not Found').&End
      .&End
    .&End
end;

end.
