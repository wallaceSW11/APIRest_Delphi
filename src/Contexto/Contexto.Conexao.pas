unit Contexto.Conexao;

interface

uses
  Contexto.Conexao.Interfaces,
  Data.Win.ADODB,
  System.SysUtils,
  Winapi.ActiveX;

type
  TConexao = class(TInterfacedObject, IConexao)
  private
    FConnection: TADOConnection;
  constructor Create( );
  public
    class function NovaInstancia(): IConexao;
    destructor Destroy; override;
    function Conexao(): TADOConnection;
  end;

implementation

{ TConexao }

function TConexao.Conexao: TADOConnection;
begin
  FConnection.ConnectionString :=
    'Provider=MSOLEDBSQL.1;Persist Security Info=False;'+
    'Data Source=PCWallzin\sqlexpress; Initial Catalog=apirest; User ID=sa; Password=senhas; '+
    'Initial File Name="";Server SPN="";Authentication="";Access Token=""';

  try
    FConnection.Connected := True;
  except
    on E: Exception do
      Writeln('erro ao conectar : ' + e.Message);
  end;

  Result := FConnection;
end;

constructor TConexao.Create;
begin
  CoInitialize(nil);
  FConnection := TADOConnection.Create(nil);
end;

destructor TConexao.Destroy;
begin
  FConnection.Close();
  FConnection.Free();
  inherited;
end;

class function TConexao.NovaInstancia(): IConexao;
begin
  Result := Self.Create();
end;

end.
