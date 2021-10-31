unit Controllers.Produto;

interface

uses
  Models.Produto,
  System.Generics.Collections,
  System.SysUtils,
  Horse,
  Horse.Commons,
  Horse.GBSwagger,
  System.JSON,
  REST.Json,
  Repositories.Produto,
  Repositories.Interfaces,
  Controllers.Interfaces;

type
  TControllerProduto = class(TInterfacedObject, IControllerProduto)
  private
    FRepositorioProduto: IRepositoryProduto;
    FProduto: TProduto;
    FProdutos: TObjectList<TProduto>;
    constructor Create();
    function ProdutoExiste(Res: THorseResponse; const pIdentificadorProduto: string): Boolean;
  public
    procedure ListarProdutoPorId(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure ListarProdutos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure CriarProduto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure AtualizarProduto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure ExcluirProduto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure Routes();
    class function NovaInstancia(): IControllerProduto;
    destructor Destroy(); override;
  end;

implementation

{ TControllerProduto }

procedure TControllerProduto.AtualizarProduto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
const
  FALHA_AO_ATUALIZAR_PRODUTO = 'Falha ao atualizar o produto.';
begin
  if (not ProdutoExiste(Res, Req.Params['id'])) then
    Exit();

  FProduto := FRepositorioProduto.AtualizarProduto(
    Req.Params['id'], TJson.JsonToObject<TProduto>(Req.Body<TJSONObject>));

  if (Assigned(FProduto)) then
    Res.Send<TJsonObject>(TJson.ObjectToJsonObject(FProduto)).Status(THTTPStatus.Ok)
  else
    Res.Send(FALHA_AO_ATUALIZAR_PRODUTO).Status(THTTPStatus.BadRequest);
end;

function TControllerProduto.ProdutoExiste(Res: THorseResponse; const pIdentificadorProduto: string): Boolean;
const
  PRODUTO_NAO_LOCALIZADO = 'N�o foi localizado o produto com o id "%s"';
begin
  Result := True;

  if (not FRepositorioProduto.ProdutoExiste(pIdentificadorProduto)) then
  begin
    Res.Send(Format(PRODUTO_NAO_LOCALIZADO, [pIdentificadorProduto])).Status(THTTPStatus.NotFound);
    Result := False;
  end;
end;

constructor TControllerProduto.Create();
begin
  FRepositorioProduto := TRepositoryProduto.NovaInstancia();
  FProduto := TProduto.Create();
  FProdutos := TObjectList<TProduto>.Create();
end;

procedure TControllerProduto.CriarProduto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
const
  FALHA_AO_CRIAR_Produto = 'Falha ao criar o Produto.';
  NOME_PRODUTO_NAO_INFORMADO = 'O nome do produto n�o foi informado';
begin
  FProduto := TJson.JsonToObject<TProduto>(Req.Body<TJSONObject>);

  if (FProduto.Nome.Trim().IsEmpty()) then
  begin
    Res.Send(NOME_PRODUTO_NAO_INFORMADO).Status(THTTPStatus.BadRequest);
    Exit();
  end;

  FProduto := FRepositorioProduto.CriarProduto(FProduto);

  if (Assigned(FProduto)) then
    Res.Send<TJsonObject>(TJson.ObjectToJsonObject(FProduto)).Status(THTTPStatus.Created)
  else
    Res.Send(FALHA_AO_CRIAR_Produto).Status(THTTPStatus.BadRequest);
end;

destructor TControllerProduto.Destroy();
begin
  FProduto.Free();
  FProdutos.Free();
  inherited;
end;

procedure TControllerProduto.ExcluirProduto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  if (not ProdutoExiste(Res, Req.Params['id'])) then
    Exit();

  FRepositorioProduto.ExcluirProduto(Req.Params['id']);
  Res.Send('').Status(THTTPStatus.NoContent);
end;

procedure TControllerProduto.ListarProdutoPorId(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  if (not ProdutoExiste(Res, Req.Params['id'])) then
    Exit();

  FProduto := FRepositorioProduto.ObterProdutoPorIdentificador(Req.Params['id']);
  Res.Send<TJsonObject>(TJson.ObjectToJsonObject(FProduto)).Status(THTTPStatus.OK);
end;

procedure TControllerProduto.ListarProdutos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
const
  PRODUTOS_NAO_ENCONTRADOS = 'Nenhum Produto foi encontrado.';
var
  lProduto: TProduto;
  lJsonArray: TJsonarray;
  lJsonObject: TJsonObject;
begin
  FProdutos := FRepositorioProduto.ObterProdutos();

  if (not (Assigned(FProdutos))) then
  begin
    Res.Send(PRODUTOS_NAO_ENCONTRADOS).Status(THTTPStatus.NotFound);
    Exit();
  end;

  lJsonArray := TJSONArray.Create;

  for lProduto in FProdutos do
  begin
    lJsonObject := TJson.ObjectToJsonObject(lProduto);
    lJsonArray.AddElement(lJsonObject);
  end;

  Res.Send<TJSONArray>(lJsonArray);
end;

class function TControllerProduto.NovaInstancia(): IControllerProduto;
begin
  Result := Self.Create();
end;

procedure TControllerProduto.Routes();
begin
  THorse.Get('/produto/', ListarProdutos);
  THorse.Get('/produto/:id', ListarProdutoPorId);
  THorse.Post('/produto/', CriarProduto);
  THorse.PUT('/produto/:id', AtualizarProduto);
  THorse.Delete('produto/:id', ExcluirProduto);

  Swagger
    .Path('produto/{id}')
      .Tag('Produto')
      .GET('Obter produto pelo identificador', 'Visualizar os dados do produto')
        .AddResponse(200, 'successful operation')
          .Schema(TProduto)
          .IsArray(False)
        .&End
        .AddResponse(400, 'Bad Request').&End
        .AddResponse(404, 'Not Found').&End
      .&End
      .Tag('Produto')
      .PUT('Atualizar produto', 'Atualizar o cadastro do produto')
        .AddResponse(200, 'successful operation')
          .Schema(TProduto)
          .IsArray(False)
        .&End
        .AddResponse(400, 'Bad Request').&End
        .AddResponse(404, 'Not Found').&End
      .&End
      .Tag('Produto')
      .DELETE('Excluir produto', 'Excluir o cadastro do produtos')
        .AddResponse(204, 'No Content')
          .Schema(TProduto)
          .IsArray(False)
        .&End
        .AddResponse(400, 'Bad Request').&End
        .AddResponse(404, 'Not Found').&End
      .&End
    .&End
    .Path('produto')
      .Tag('Produto')
      .GET('Obter produtos', 'Listar todos os produtos')
        .AddResponse(200, 'successful operation')
          .Schema(TProduto)
          .IsArray(True)
        .&End
        .AddResponse(400, 'Bad Request').&End
        .AddResponse(404, 'Not Found').&End
        .&End
      .Tag('Produto')
      .POST('Cadastrar produto', 'Cadastrar o produto')
        .AddParamBody('Dados do produto')
          .Schema(TProduto)
        .&End
        .AddResponse(202, 'Created')
          .Schema(TProduto)
          .IsArray(True)
        .&End
        .AddResponse(400, 'Bad Request').&End
        .AddResponse(404, 'Not Found').&End
      .&End
    .&End
end;

end.
