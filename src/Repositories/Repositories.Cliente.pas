unit Repositories.Cliente;

interface

uses
  System.SysUtils,
  Models.Cliente,
  System.Generics.Collections,
  Data.DB,
  Data.Win.ADODB,
  Contexto.Conexao.Interfaces,
  Repositories.Interfaces,
  Contexto.Query,
  System.StrUtils;

type
  TRepositoryCliente = class(TInterfacedObject, IRepositoryCliente)
  private
    FQuery: IQuery;
    FCliente: TCliente;
    FClientes: TObjectList<TCliente>;
    FDataSet: TDataSet;
    constructor Create();
  public
    function ObterClientes(): TObjectList<TCliente>;
    function ObterClientePorIdentificador(const pIdentificadorCliente: string): TCliente;
    function CriarCliente(const pCliente: TCliente): TCliente;
    function AtualizarCliente(const pIdentificadorCliente: string; const pCliente: TCliente): TCliente;
    function ClienteExiste(const pIdentificadorCliente: string): Boolean;
    procedure ExcluirCliente(const pIdentificadorCliente: string);
    class function NovaInstancia(): IRepositoryCliente;
    destructor Destroy(); override;
  end;

implementation

{ TRepositoryCliente }

function TRepositoryCliente.AtualizarCliente(const pIdentificadorCliente: string; const pCliente: TCliente): TCliente;
const
  UPDATE_CLIENTE = 'Update Cliente Set Nome=''%s'', DataNascimento=''%s'', Documento=''%s'' Where id=''%s''';
begin
  FQuery.Exec(Format(UPDATE_CLIENTE, [
    pCliente.Nome, DateToStr(pCliente.DataNascimento), pCliente.Documento, pIdentificadorCliente]));
  Result := pCliente;
end;

function TRepositoryCliente.ClienteExiste(const pIdentificadorCliente: string): Boolean;
begin
  FCliente := ObterClientePorIdentificador(pIdentificadorCliente);
  Result := Assigned(FCliente);
end;

constructor TRepositoryCliente.Create();
begin

  FQuery := TQuery.NovaInstancia();
  FCliente := TCliente.Create();
  FClientes := TObjectList<TCliente>.Create(True);
end;

function TRepositoryCliente.CriarCliente(const pCliente: TCliente): TCliente;
const
  INSERIR_CLIENTE =
                   'Insert Into'
    + sLineBreak + '  Cliente ('
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
  FQuery.Exec(Format(INSERIR_CLIENTE, [pCliente.Id, pCliente.Nome, DateToStr(pCliente.DataNascimento), pCliente.Documento]));
  Result := pCliente;
end;

destructor TRepositoryCliente.Destroy();
begin
  inherited;
end;

procedure TRepositoryCliente.ExcluirCliente(const pIdentificadorCliente: string);
const
  EXCLUIR_CLIENTE = 'Delete From Cliente Where id=''%s''';
begin
  FQuery.Exec(Format(EXCLUIR_CLIENTE, [pIdentificadorCliente]));
end;

class function TRepositoryCliente.NovaInstancia: IRepositoryCliente;
begin
  Result := Self.Create();
end;

function TRepositoryCliente.ObterClientePorIdentificador(const pIdentificadorCliente: string): TCliente;
const
  SELECT_CLIENTE_IDENTIFICADOR = 'Select Id, Nome, DataNascimento, Documento From Cliente Where Id=''%s''';
begin
  FDataSet := FQuery.Query(Format(SELECT_CLIENTE_IDENTIFICADOR, [pIdentificadorCliente]));

  if (FDataSet.RecordCount = 0) then
    Exit(nil);

  FCliente := TCliente.Create(
    FDataSet.FieldByName('Nome').AsString,
    FDataSet.FieldByName('DataNascimento').AsDateTime,
    FDataSet.FieldByName('Documento').AsString,
    FDataSet.FieldByName('Id').AsString);
  Result := FCliente;
end;

function TRepositoryCliente.ObterClientes(): TObjectList<TCliente>;
const
  SELECT_CLIENTE_IDENTIFICADOR = 'Select Id, Nome, DataNascimento, Documento From Cliente';
var
  lCliente: TCliente;
begin
  FDataSet := FQuery.Query(SELECT_CLIENTE_IDENTIFICADOR);

  if (FDataSet.RecordCount = 0) then
    Exit(nil);

  FClientes.Clear();
  FDataSet.First();

  while (not FDataSet.Eof) do
  begin
    lCliente := TCliente.Create(
      FDataSet.FieldByName('Nome').AsString,
      FDataSet.FieldByName('DataNascimento').AsDateTime,
      FDataSet.FieldByName('Documento').AsString,
      FDataSet.FieldByName('id').AsString);

    FClientes.Add(lCliente);
    FDataSet.Next();
  end;

  Result := FClientes;
end;

end.
