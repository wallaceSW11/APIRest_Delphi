unit Repositories.ItemVenda;

interface

uses
  System.SysUtils,
  Models.ItemVenda,
  System.Generics.Collections,
  Data.DB,
  Data.Win.ADODB,
  Contexto.Conexao.Interfaces,
  Repositories.Interfaces,
  Contexto.Query,
  System.StrUtils;

type
  TRepositoryItemVenda = class(TInterfacedObject, IRepositoryItemVenda)
  private
    FQuery: IQuery;
    FItemVenda: TItemVenda;
    FItemVendas: TObjectList<TItemVenda>;
    FDataSet: TDataSet;
    constructor Create();
  public
    function ObterItemVendas(): TObjectList<TItemVenda>;
    function ObterItemVendaPorIdentificador(const pIdentificadorItemVenda: string): TItemVenda;
    function CriarItemVenda(const pItemVenda: TItemVenda): TItemVenda;
    function AtualizarItemVenda(const pIdentificadorItemVenda: string; const pItemVenda: TItemVenda): TItemVenda;
    function ItemVendaExiste(const pIdentificadorItemVenda: string): Boolean;
    procedure ExcluirItemVenda(const pIdentificadorItemVenda: string);
    class function NovaInstancia(): IRepositoryItemVenda;
    destructor Destroy(); override;
  end;

implementation

{ TRepositoryItemVenda }

function TRepositoryItemVenda.AtualizarItemVenda(const pIdentificadorItemVenda: string; const pItemVenda: TItemVenda): TItemVenda;
const
  UPDATE_ItemVenda = 'Update ItemVenda Set Nome=''%s'', DataNascimento=''%s'', Documento=''%s'' Where id=''%s''';
begin
  FQuery.Exec(Format(UPDATE_ItemVenda, [
    pItemVenda.Nome, DateToStr(pItemVenda.DataNascimento), pItemVenda.Documento, pIdentificadorItemVenda]));
  Result := pItemVenda;
end;

function TRepositoryItemVenda.ItemVendaExiste(const pIdentificadorItemVenda: string): Boolean;
begin
  FItemVenda := ObterItemVendaPorIdentificador(pIdentificadorItemVenda);
  Result := Assigned(FItemVenda);
end;

constructor TRepositoryItemVenda.Create();
begin

  FQuery := TQuery.NovaInstancia();
  FItemVenda := TItemVenda.Create();
  FItemVendas := TObjectList<TItemVenda>.Create(True);
end;

function TRepositoryItemVenda.CriarItemVenda(const pItemVenda: TItemVenda): TItemVenda;
const
  INSERIR_ItemVenda =
                   'Insert Into'
    + sLineBreak + '  ItemVenda ('
    + sLineBreak + '  Id,'
    + sLineBreak + '  Nome,'
    + sLineBreak + '  DataNascimento,'
    + sLineBreak + '  Documento)'
    + sLineBreak + 'Values ('
    + sLineBreak + '  ''%s'','
    + sLineBreak + '  ''%s'','
    + sLineBreak + '  ''%s'','
    + sLineBreak + '  ''%s'')';
begin
  FQuery.Exec(Format(INSERIR_ItemVenda, [pItemVenda.Id, pItemVenda.Nome, DateToStr(pItemVenda.DataNascimento), pItemVenda.Documento]));
  Result := pItemVenda;
end;

destructor TRepositoryItemVenda.Destroy();
begin
  inherited;
end;

procedure TRepositoryItemVenda.ExcluirItemVenda(const pIdentificadorItemVenda: string);
const
  EXCLUIR_ItemVenda = 'Delete From ItemVenda Where id=''%s''';
begin
  FQuery.Exec(Format(EXCLUIR_ItemVenda, [pIdentificadorItemVenda]));
end;

class function TRepositoryItemVenda.NovaInstancia: IRepositoryItemVenda;
begin
  Result := Self.Create();
end;

function TRepositoryItemVenda.ObterItemVendaPorIdentificador(const pIdentificadorItemVenda: string): TItemVenda;
const
  SELECT_ItemVenda_IDENTIFICADOR = 'Select Id, Nome, DataNascimento, Documento From ItemVenda Where Id=''%s''';
begin
  FDataSet := FQuery.Query(Format(SELECT_ItemVenda_IDENTIFICADOR, [pIdentificadorItemVenda]));

  if (FDataSet.RecordCount = 0) then
    Exit(nil);

  FItemVenda := TItemVenda.Create(
    FDataSet.FieldByName('Nome').AsString,
    FDataSet.FieldByName('DataNascimento').AsDateTime,
    FDataSet.FieldByName('Documento').AsString,
    FDataSet.FieldByName('Id').AsString);
  Result := FItemVenda;
end;

function TRepositoryItemVenda.ObterItemVendas(): TObjectList<TItemVenda>;
const
  SELECT_ItemVenda_IDENTIFICADOR = 'Select Id, Nome, DataNascimento, Documento From ItemVenda';
var
  lItemVenda: TItemVenda;
begin
  FDataSet := FQuery.Query(SELECT_ItemVenda_IDENTIFICADOR);

  if (FDataSet.RecordCount = 0) then
    Exit(nil);

  FItemVendas.Clear();
  FDataSet.First();

  while (not FDataSet.Eof) do
  begin
    lItemVenda := TItemVenda.Create(
      FDataSet.FieldByName('Nome').AsString,
      FDataSet.FieldByName('DataNascimento').AsDateTime,
      FDataSet.FieldByName('Documento').AsString,
      FDataSet.FieldByName('id').AsString);

    FItemVendas.Add(lItemVenda);
    FDataSet.Next();
  end;

  Result := FItemVendas;
end;

end.
