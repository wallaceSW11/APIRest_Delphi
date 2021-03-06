unit Repositories.Produto;

interface

uses
  System.SysUtils,
  Models.Produto,
  System.Generics.Collections,
  Data.DB,
  Data.Win.ADODB,
  Contexto.Conexao.Interfaces,
  Repositories.Interfaces,
  Contexto.Query,
  System.StrUtils,
  Helper.NumberHelper;

type
  TRepositoryProduto = class(TInterfacedObject, IRepositoryProduto)
  private
    FQuery: IQuery;
    FProduto: TProduto;
    FProdutos: TObjectList<TProduto>;
    FDataSet: TDataSet;
    constructor Create();
  public
    function ObterProdutos(): TObjectList<TProduto>;
    function ObterProdutoPorIdentificador(const pIdentificadorProduto: string): TProduto;
    function CriarProduto(const pProduto: TProduto): TProduto;
    function AtualizarProduto(const pIdentificadorProduto: string; const pProduto: TProduto): TProduto;
    function ProdutoExiste(const pIdentificadorProduto: string): Boolean;
    procedure ExcluirProduto(const pIdentificadorProduto: string);
    class function NovaInstancia(): IRepositoryProduto;
    destructor Destroy(); override;
  end;

implementation

{ TRepositoryProduto }

function TRepositoryProduto.AtualizarProduto(const pIdentificadorProduto: string; const pProduto: TProduto): TProduto;
const
  UPDATE_Produto = 'Update Produto Set Nome=''%s'', Valor=''%s'' Where id=''%s''';
begin
  FQuery.Exec(Format(UPDATE_Produto, [
    pProduto.Nome, pProduto.Valor.FormatoBancoDeDados(), pIdentificadorProduto]));
  Result := pProduto;
end;

function TRepositoryProduto.ProdutoExiste(const pIdentificadorProduto: string): Boolean;
begin
  FProduto := ObterProdutoPorIdentificador(pIdentificadorProduto);
  Result := Assigned(FProduto);
end;

constructor TRepositoryProduto.Create();
begin
  FQuery := TQuery.NovaInstancia();
  FProduto := TProduto.Create();
  FProdutos := TObjectList<TProduto>.Create(True);
end;

function TRepositoryProduto.CriarProduto(const pProduto: TProduto): TProduto;
const
  INSERIR_PRODUTO =
                   'Insert Into'
    + sLineBreak + '  Produto ('
    + sLineBreak + '  Id,'
    + sLineBreak + '  Nome,'
    + sLineBreak + '  Valor)'
    + sLineBreak + 'Values ('
    + sLineBreak + '  ''%s'','
    + sLineBreak + '  ''%s'','
    + sLineBreak + '  ''%s'')';
begin
  FQuery.Exec(Format(INSERIR_PRODUTO, [pProduto.Id, pProduto.Nome, pProduto.Valor.FormatoBancoDeDados()]));
  Result := pProduto;
end;

destructor TRepositoryProduto.Destroy();
begin
  inherited;
end;

procedure TRepositoryProduto.ExcluirProduto(const pIdentificadorProduto: string);
const
  EXCLUIR_Produto = 'Delete From Produto Where id=''%s''';
begin
  FQuery.Exec(Format(EXCLUIR_Produto, [pIdentificadorProduto]));
end;

class function TRepositoryProduto.NovaInstancia: IRepositoryProduto;
begin
  Result := Self.Create();
end;

function TRepositoryProduto.ObterProdutoPorIdentificador(const pIdentificadorProduto: string): TProduto;
const
  SELECT_Produto_IDENTIFICADOR = 'Select Id, Nome, Valor From Produto Where Id=''%s''';
begin
  FDataSet := FQuery.Query(Format(SELECT_Produto_IDENTIFICADOR, [pIdentificadorProduto]));

  if (FDataSet.RecordCount = 0) then
    Exit(nil);

  FProduto := TProduto.Create(
    FDataSet.FieldByName('Nome').AsString,
    FDataSet.FieldByName('Valor').AsFloat,
    FDataSet.FieldByName('id').AsString);
  Result := FProduto;
end;

function TRepositoryProduto.ObterProdutos(): TObjectList<TProduto>;
const
  SELECT_PRODUTO_IDENTIFICADOR = 'Select Id, Nome, Valor From Produto';
var
  lProduto: TProduto;
begin
  FDataSet := FQuery.Query(SELECT_PRODUTO_IDENTIFICADOR);

  if (FDataSet.RecordCount = 0) then
    Exit(nil);

  FProdutos.Clear();
  FDataSet.First();

  while (not FDataSet.Eof) do
  begin
    lProduto := TProduto.Create(
      FDataSet.FieldByName('Nome').AsString,
      FDataSet.FieldByName('Valor').AsFloat,
      FDataSet.FieldByName('id').AsString);

    FProdutos.Add(lProduto);
    FDataSet.Next();
  end;

  Result := FProdutos;
end;

end.
