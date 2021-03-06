unit Repositories.ItensVendidos;

interface

uses
  System.SysUtils,
  Models.ItensVendidos,
  Models.Venda,
  Models.Produto,
  Models.Cliente,
  System.Generics.Collections,
  Data.DB,
  Data.Win.ADODB,
  Contexto.Conexao.Interfaces,
  Repositories.Interfaces,
  Contexto.Query,
  System.StrUtils,
  Helper.NumberHelper;

type
  TRepositoryItensVendidos = class(TInterfacedObject, IRepositoryItensVendidos)
  private
    FQuery: IQuery;
    FItensVendidos: TItensVendidos;
    FListaItensVendidos: TObjectList<TItensVendidos>;
    FDataSet: TDataSet;
    constructor Create();
    procedure PreencherItensVendidos(pItensVendidos: TItensVendidos = nil);
  public
    function ObterListaItensVendidos(): TObjectList<TItensVendidos>;
    function ObterItensVendidosPorIdentificador(const pIdentificadorItensVendidos: string): TItensVendidos;
    function CriarItensVendidos(const pItensVendidos: TItensVendidos): TItensVendidos;
    function AtualizarItensVendidos(const pIdentificadorItensVendidos: string; const pItensVendidos: TItensVendidos): TItensVendidos;
    function ItensVendidosExiste(const pIdentificadorItensVendidos: string): Boolean;
    procedure ExcluirItensVendidos(const pIdentificadorItensVendidos: string);
    class function NovaInstancia(): IRepositoryItensVendidos;
    destructor Destroy(); override;
  end;

implementation

{ TRepositoryItensVendidos }

function TRepositoryItensVendidos.AtualizarItensVendidos(const pIdentificadorItensVendidos: string; const pItensVendidos: TItensVendidos): TItensVendidos;
const
  UPDATE_ITENSVENDIDOS = 'Update ItensVendidos Set Produto=''%s'', Venda=''%s'', Quantidade=''%s'' Where id=''%s''';
begin
  FQuery.Exec(Format(UPDATE_ITENSVENDIDOS, [
    pItensVendidos.Produto.Id, pItensVendidos.Venda.Id, pItensVendidos.Quantidade.FormatoBancoDeDados(), pIdentificadorItensVendidos]));
  Result := pItensVendidos;
end;

function TRepositoryItensVendidos.ItensVendidosExiste(const pIdentificadorItensVendidos: string): Boolean;
begin
  FItensVendidos := ObterItensVendidosPorIdentificador(pIdentificadorItensVendidos);
  Result := Assigned(FItensVendidos);
end;

constructor TRepositoryItensVendidos.Create();
begin
  FQuery := TQuery.NovaInstancia();
  FItensVendidos := TItensVendidos.Create();
  FListaItensVendidos := TObjectList<TItensVendidos>.Create(True);
end;

function TRepositoryItensVendidos.CriarItensVendidos(const pItensVendidos: TItensVendidos): TItensVendidos;
const
  INSERIR_ItensVendidos =
                   'Insert Into'
    + sLineBreak + '  ItensVendidos ('
    + sLineBreak + '  Id,'
    + sLineBreak + '  Produto,'
    + sLineBreak + '  Venda,'
    + sLineBreak + '  Quantidade)'
    + sLineBreak + 'Values ('
    + sLineBreak + '  ''%s'','
    + sLineBreak + '  ''%s'','
    + sLineBreak + '  ''%s'','
    + sLineBreak + '  ''%s'')';
begin
  FQuery.Exec(Format(INSERIR_ItensVendidos, [
    pItensVendidos.Id, pItensVendidos.Produto.Id, pItensVendidos.Venda.Id, pItensVendidos.Quantidade.FormatoBancoDeDados()]));
  Result := pItensVendidos;
end;

destructor TRepositoryItensVendidos.Destroy();
begin
  inherited;
end;

procedure TRepositoryItensVendidos.ExcluirItensVendidos(const pIdentificadorItensVendidos: string);
const
  EXCLUIR_ItensVendidos = 'Delete From ItensVendidos Where id=''%s''';
begin
  FQuery.Exec(Format(EXCLUIR_ItensVendidos, [pIdentificadorItensVendidos]));
end;

class function TRepositoryItensVendidos.NovaInstancia: IRepositoryItensVendidos;
begin
  Result := Self.Create();
end;

function TRepositoryItensVendidos.ObterItensVendidosPorIdentificador(const pIdentificadorItensVendidos: string): TItensVendidos;
const
  SELECT_ITENSVENDIDOS_IDENTIFICADOR =
                   'Select'
    + sLineBreak + '  P.Id as IdProduto,'
    + sLineBreak + '  P.Nome as NomeProduto,'
    + sLineBreak + '  P.Valor,'
    + sLineBreak + '  I.Id as IdItensVendidos,'
    + sLineBreak + '  I.Quantidade,'
    + sLineBreak + '  V.Id as IdVenda,'
    + sLineBreak + '  V.DataVenda,'
    + sLineBreak + '  C.Id as IdCliente,'
    + sLineBreak + '  C.Nome as NomeCliente,'
    + sLineBreak + '  C.DataNascimento,'
    + sLineBreak + '  C.Documento'
    + sLineBreak + 'From'
    + sLineBreak + '  ItensVendidos I Inner Join Produto P on (P.id = I.Produto)'
    + sLineBreak + '                  Inner Join Venda V on (V.id = I.Venda)'
    + sLineBreak + '                  Inner Join Cliente C on (C.id = V.Cliente)'
    + sLineBreak + 'Where'
    + sLineBreak + '  (I.id = ''%s'')';
begin
  FDataSet := FQuery.Query(Format(SELECT_ITENSVENDIDOS_IDENTIFICADOR, [pIdentificadorItensVendidos]));

  if (FDataSet.RecordCount = 0) then
    Exit(nil);

  PreencherItensVendidos();
  Result := FItensVendidos;
end;

procedure TRepositoryItensVendidos.PreencherItensVendidos(pItensVendidos: TItensVendidos);
var
  lProduto: TProduto;
  lCliente: TCliente;
  lVenda: TVenda;
begin
  lProduto := TProduto.Create(
    FDataSet.FieldByName('NomeProduto').AsString,
    FDataSet.FieldByName('Valor').AsFloat,
    FDataSet.FieldByName('IdProduto').AsString);

  lCliente := TCliente.Create(
    FDataSet.FieldByName('NomeCliente').AsString,
    FDataSet.FieldByName('DataNascimento').AsDateTime,
    FDataSet.FieldByName('Documento').AsString,
    FDataSet.FieldByName('IdCliente').AsString);

  lVenda := TVenda.Create(
    FDataSet.FieldByName('DataVenda').AsDateTime,
    lCliente,
    FDataSet.FieldByName('IdVenda').AsString);

  if (pItensVendidos = nil) then
  begin
    FItensVendidos := TItensVendidos.Create();
    FItensVendidos.Produto := lProduto;
    FItensVendidos.Venda := lVenda;
    FItensVendidos.Quantidade := FDataSet.FieldByName('Quantidade').AsFloat;
    FItensVendidos.Id := FDataSet.FieldByName('IdItensVendidos').AsString;
    Exit();
  end;

  pItensVendidos.Produto := lProduto;
  pItensVendidos.Venda := lVenda;
  pItensVendidos.Quantidade := FDataSet.FieldByName('Quantidade').AsFloat;
  pItensVendidos.Id := FDataSet.FieldByName('IdItensVendidos').AsString;
end;


function TRepositoryItensVendidos.ObterListaItensVendidos(): TObjectList<TItensVendidos>;
const
  SELECT_ITENSVENDIDOS =
                   'Select'
    + sLineBreak + '  P.Id as IdProduto,'
    + sLineBreak + '  P.Nome as NomeProduto,'
    + sLineBreak + '  P.Valor,'
    + sLineBreak + '  I.Id as IdItensVendidos,'
    + sLineBreak + '  I.Quantidade,'
    + sLineBreak + '  V.Id as IdVenda,'
    + sLineBreak + '  V.DataVenda,'
    + sLineBreak + '  C.Id as IdCliente,'
    + sLineBreak + '  C.Nome as NomeCliente,'
    + sLineBreak + '  C.DataNascimento,'
    + sLineBreak + '  C.Documento'
    + sLineBreak + 'From'
    + sLineBreak + '  ItensVendidos I Inner Join Produto P on (P.id = I.Produto)'
    + sLineBreak + '                  Inner Join Venda V on (V.id = I.Venda)'
    + sLineBreak + '                  Inner Join Cliente C on (C.id = V.Cliente)';
var
  lItensVendidos: TItensVendidos;
begin
  FDataSet := FQuery.Query(SELECT_ITENSVENDIDOS);

  if (FDataSet.RecordCount = 0) then
    Exit(nil);

  FListaItensVendidos.Clear();
  FDataSet.First();

  while (not FDataSet.Eof) do
  begin
    lItensVendidos := TItensVendidos.Create();
    PreencherItensVendidos(lItensVendidos);
    FListaItensVendidos.Add(lItensVendidos);
    FDataSet.Next();
  end;

  Result := FListaItensVendidos;
end;

end.

