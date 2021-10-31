unit Models.ItensVendidos;

interface

uses
  Models.CadastroBase,
  Models.Produto,
  Models.Venda;

type
  TItensVendidos = class(TCadastroBase)
  private
    FProduto: TProduto;
    FVenda: TVenda;
  public
    property Produto: TProduto read FProduto write FProduto;
    property Venda: TVenda read FVenda write FVenda;
    constructor Create( ); overload;
    constructor Create(const pProduto: TProduto; const pVenda: TVenda); overload;
  end;


implementation

{ TItensVendidos }

constructor TItensVendidos.Create(const pProduto: TProduto;
  const pVenda: TVenda);
begin
  inherited Create();
  Self.Produto := pProduto;
  Self.Venda := pVenda;
end;

constructor TItensVendidos.Create;
begin
  inherited Create();

end;

end.
