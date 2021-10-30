unit Contexto.Query;

interface

uses
  Contexto.Conexao.Interfaces,
  Contexto.Conexao,
  Data.Win.ADODB,
  Data.DB,
  System.SysUtils;

type
  TQuery = class(TInterfacedObject, IQuery)
  private
    FConexao: IConexao;
    FQuery: TADOQuery;
    constructor Create( );
    destructor Destroy; override;
  public
    function Query(const pComandoSQL: string): TDataSet;
    procedure Exec(const pComandoSQL: string);
    class function NovaInstancia(): IQuery;

  end;

implementation

{ TQuery }

constructor TQuery.Create();
begin
  FConexao := TConexao.NovaInstancia();
  FQuery := TADOQuery.Create(nil);
  FQuery.Connection := FConexao.Conexao();
end;

destructor TQuery.Destroy;
begin
  FQuery.Connection.Close();
  FQuery.Free();
  inherited;
end;

procedure TQuery.Exec(const pComandoSQL: string);
begin
  FQuery.Close();
  FQuery.SQL.Clear();
  FQuery.SQL.Add(pComandoSQL);

  try
    FQuery.ExecSQL();
  except
    on E: Exception do
      Writeln('Falha ao executar o comando: ' + E.Message);
  end;
end;

class function TQuery.NovaInstancia: IQuery;
begin
  Result := Self.Create();
end;

function TQuery.Query(const pComandoSQL: string): TDataSet;
begin
  Result := nil;

  FQuery.Close();
  FQuery.SQL.Clear();
  FQuery.SQL.Add(pComandoSQL);

  try
    FQuery.Open();
  except
    on E: Exception do
      Writeln('Falha ao realizar a consulta: ' + E.Message);
  end;

  Result := FQuery;
end;

end.
