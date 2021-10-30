unit Models.Produto;

interface

uses
  Models.CadastroBase;

type
  TProduto = class (TCadastroBase)
  private
    FValor: Currency;
    FNome: string;
  public
    property Nome: string read FNome write FNome;
    property Valor: Currency read FValor write FValor;
    constructor Create(); overload;
    constructor Create(const pNome: string; const pValor: Currency); overload;
  end;


implementation

{ TProduto }

constructor TProduto.Create(const pNome: string; const pValor: Currency);
begin
  Self.Nome := pNome;
  Self.Valor := pValor;
end;

constructor TProduto.Create();
begin

end;

end.
