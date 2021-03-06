unit Repositories.Venda;

interface

uses
  System.SysUtils,
  Models.Venda,
  Models.Cliente,
  Models.Produto,
  System.Generics.Collections,
  Data.DB,
  Data.Win.ADODB,
  Contexto.Conexao.Interfaces,
  Repositories.Interfaces,
  Repositories.Cliente,
  Contexto.Query,
  System.StrUtils;

type
  TRepositoryVenda = class(TInterfacedObject, IRepositoryVenda)
  private
    FQuery: IQuery;
    FVenda: TVenda;
    FCliente: TCliente;
    FVendas: TObjectList<TVenda>;
    FDataSet: TDataSet;
    FRepositorioCliente: IRepositoryCliente;
    constructor Create();
  public
    function ObterVendas(): TObjectList<TVenda>;
    function ObterVendaPorIdentificador(const pIdentificadorVenda: string): TVenda;
    function CriarVenda(const pVenda: TVenda): TVenda;
    function AtualizarVenda(const pIdentificadorVenda: string; const pVenda: TVenda): TVenda;
    function VendaExiste(const pIdentificadorVenda: string): Boolean;
    procedure ExcluirVenda(const pIdentificadorVenda: string);
    class function NovaInstancia(): IRepositoryVenda;
    destructor Destroy(); override;
  end;

implementation

{ TRepositoryVenda }

function TRepositoryVenda.AtualizarVenda(const pIdentificadorVenda: string; const pVenda: TVenda): TVenda;
const
  UPDATE_VENDA = 'Update Venda Set DataVenda=''%s'', Cliente=''%s'' Where id=''%s''';
begin
  FQuery.Exec(Format(UPDATE_VENDA, [
    DateToStr(pVenda.DataVenda), pVenda.Cliente.Id, pIdentificadorVenda]));
  Result := pVenda;
end;

function TRepositoryVenda.VendaExiste(const pIdentificadorVenda: string): Boolean;
begin
  FVenda := ObterVendaPorIdentificador(pIdentificadorVenda);
  Result := Assigned(FVenda);
end;

constructor TRepositoryVenda.Create();
begin
  FQuery := TQuery.NovaInstancia();
  FVenda := TVenda.Create();
  FVendas := TObjectList<TVenda>.Create(True);
  FRepositorioCliente := TRepositoryCliente.NovaInstancia();
end;

function TRepositoryVenda.CriarVenda(const pVenda: TVenda): TVenda;
const
  INSERIR_VENDA =
                   'Insert Into'
    + sLineBreak + '  Venda ('
    + sLineBreak + '  Id,'
    + sLineBreak + '  DataVenda,'
    + sLineBreak + '  Cliente)'
    + sLineBreak + 'Values ('
    + sLineBreak + '  ''%s'','
    + sLineBreak + '  ''%s'','
    + sLineBreak + '  ''%s'')';
begin
  FQuery.Exec(Format(INSERIR_VENDA, [pVenda.Id, DateToStr(pVenda.DataVenda), pVenda.Cliente.Id]));
  Result := pVenda;
end;

destructor TRepositoryVenda.Destroy();
begin
  inherited;
end;

procedure TRepositoryVenda.ExcluirVenda(const pIdentificadorVenda: string);
const
  EXCLUIR_VENDA = 'Delete From Venda Where id=''%s''';
begin
  FQuery.Exec(Format(EXCLUIR_VENDA, [pIdentificadorVenda]));
end;

class function TRepositoryVenda.NovaInstancia: IRepositoryVenda;
begin
  Result := Self.Create();
end;

function TRepositoryVenda.ObterVendaPorIdentificador(const pIdentificadorVenda: string): TVenda;
const
  SELECT_Venda_IDENTIFICADOR = 'Select Id, DataVenda, Cliente From Venda Where Id=''%s''';
  SELECT_CLIENTE = 'Select Nome From Cliente Where id=''%''';
begin
  FDataSet := FQuery.Query(Format(SELECT_Venda_IDENTIFICADOR, [pIdentificadorVenda]));

  if (FDataSet.RecordCount = 0) then
    Exit(nil);

  FCliente := FRepositorioCliente.ObterClientePorIdentificador(FDataSet.FieldByName('Cliente').AsString);

  FVenda := TVenda.Create(
    FDataSet.FieldByName('DataVenda').AsDateTime,
    FCliente,
    FDataSet.FieldByName('id').AsString);
  Result := FVenda;
end;

function TRepositoryVenda.ObterVendas(): TObjectList<TVenda>;
const
  SELECT_VENDA_IDENTIFICADOR = 'Select Id, DataVenda, Cliente From Venda';
var
  lVenda: TVenda;
begin
  FDataSet := FQuery.Query(SELECT_VENDA_IDENTIFICADOR);

  if (FDataSet.RecordCount = 0) then
    Exit(nil);

  FCliente := FRepositorioCliente.ObterClientePorIdentificador(FDataSet.FieldByName('Cliente').AsString);

  FVendas.Clear();
  FDataSet.First();

  while (not FDataSet.Eof) do
  begin
    lVenda := TVenda.Create(
      FDataSet.FieldByName('DataVenda').AsDateTime,
      FCliente,
      FDataSet.FieldByName('id').AsString);

    FVendas.Add(lVenda);
    FDataSet.Next();
  end;

  Result := FVendas;
end;

end.
