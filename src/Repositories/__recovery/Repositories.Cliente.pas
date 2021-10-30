unit Repositories.Cliente;

interface

uses
  System.SysUtils,
  Models.Cliente,
  System.Generics.Collections,
  Data.DB,
  Data.Win.ADODB,
  Contexto.Conexao.Interfaces,
  Contexto.Query;

type
  TRepositoryCliente = class
  private
    FConexao: IConexao;
    FQuery: IQuery;
    FCliente: TCliente;
    FDataSet: TDataSet;

  public
    function ObterClientes(): TObjectList<TCliente>;
    function ObterClientePorIdentificador(const pIdentificadorCliente: string): TCliente;
    function CriarCliente(const pCliente: TCliente): TCliente;
    function AtualizarCliente(const pCliente: TCliente): TCliente;
    function ExcluirCliente(const pIdentificadorCliente: string): Boolean;
  constructor Create( );
  destructor Destroy; override;
  end;

implementation

{ TRepositoryCliente }

function TRepositoryCliente.AtualizarCliente(const pCliente: TCliente): TCliente;
begin

end;

constructor TRepositoryCliente.Create;
begin
  FQuery := TQuery.NovaInstancia();
  FCliente := TCliente.Create();
  FDataSet := TDataSet.Create(nil);
end;

function TRepositoryCliente.CriarCliente(const pCliente: TCliente): TCliente;
begin

end;

destructor TRepositoryCliente.Destroy;
begin
  FCliente.Free();

  inherited;
end;

function TRepositoryCliente.ExcluirCliente(const pIdentificadorCliente: string): Boolean;
begin

end;

function TRepositoryCliente.ObterClientePorIdentificador(const pIdentificadorCliente: string): TCliente;
const
  SELECT_CLIENTE_IDENTIFICADOR = 'Select Id, Nome, DataNascimento, Documento From Cliente Where Id=''%s''';
begin
  FDataSet := FQuery.Query(Format(SELECT_CLIENTE_IDENTIFICADOR, [pIdentificadorCliente]));

  if (FDataSet.RecordCount = 0) then
    Exit(nil);

  FCliente.Id := FDataSet.FieldByName('Id').AsString;
  FCliente.Nome := FDataSet.FieldByName('Nome').AsString;
  FCliente.DataNascimento := FDataSet.FieldByName('DataNascimento').AsDateTime;
  FCliente.Documento := FDataSet.FieldByName('Documento').AsString;
  Result := FCliente;
end;

function TRepositoryCliente.ObterClientes(): TObjectList<TCliente>;
begin

end;

end.
