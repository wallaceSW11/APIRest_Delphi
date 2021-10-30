unit Models.Cliente;

interface

uses
  Models.CadastroBase;

type
  TCliente = class (TCadastroBase)
  private
    FDataNascimento: TDateTime;
    FDocumento: string;
    FNome: string;
  public
    property Nome: string read FNome write FNome;
    property DataNascimento: TDateTime read FDataNascimento write FDataNascimento;
    property Documento: string read FDocumento write FDocumento;
  constructor Create(); overload;
  constructor Create(const pNome: string; const pDataNascimento: TDateTime; const pDocumento: string); overload;

  end;

implementation

{ TCliente }

constructor TCliente.Create(const pNome: string;
  const pDataNascimento: TDateTime; const pDocumento: string);
begin
  inherited Create();

  Self.Nome := pNome;
  Self.DataNascimento := pDataNascimento;
  Self.Documento := pDocumento;
end;

constructor TCliente.Create();
begin
  inherited Create();

end;

end.
