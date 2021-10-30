unit Repositories.Cliente;

interface

uses
  System.SysUtils,
  Models.Cliente,
  System.Generics.Collections,
  Data.DB,
  Data.Win.ADODB,
  Contexto.Conexao.Interfaces,
  Contexto.Conexao;

type
  TRepositoryCliente = class
  private
    FConexao: IConexao;
    FQuery: TADOQuery;
    FCliente: TCliente;

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
  FConexao := TConexao.NovaInstancia();
  FQuery := TADOQuery.Create(nil);
  FQuery.Connection := FConexao.Conexao();
  FCliente := TCliente.Create();
end;

function TRepositoryCliente.CriarCliente(const pCliente: TCliente): TCliente;
begin

end;

destructor TRepositoryCliente.Destroy;
begin
  FQuery.Connection.Close();
  FQuery.Free();
  FCliente.Free();

  inherited;
end;

function TRepositoryCliente.ExcluirCliente(const pIdentificadorCliente: string): Boolean;
begin

end;

function TRepositoryCliente.ObterClientePorIdentificador(const pIdentificadorCliente: string): TCliente;
var
  lCliente: TCliente;  
begin
  

  FQuery.Close();
  FQuery.SQL.Add('Select * From Clientes');

  try
    FQuery.Open();
  except 
    on E: Exception do
      Writeln('Erro ao realizar a consulta: ' + E.Message);
  end;
  

  FCliente.Id := FQuery.FieldByName('Id').AsString;
  FCliente.Nome := FQuery.FieldByName('Nome').AsString;
  FCliente.DataNascimento := FQuery.FieldByName('DataNascimento').AsDateTime;
  FCliente.Documento := FQuery.FieldByName('Documento').AsString;

//   := TCliente.Create(FQuery.FieldByName('Nome').AsString, StrToDate('11/09/1989'), '12345678999');

  Result := FCliente;
end;

function TRepositoryCliente.ObterClientes: TObjectList<TCliente>;
begin

end;

end.