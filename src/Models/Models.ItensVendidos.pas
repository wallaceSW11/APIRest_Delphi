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
    FQuantidade: Double;
  public
    property Produto: TProduto read FProduto write FProduto;
    property Venda: TVenda read FVenda write FVenda;
    property Quantidade: Double read FQuantidade write FQuantidade;
    constructor Create(); overload;
    constructor Create(const pProduto: TProduto; const pVenda: TVenda;
      const pQuantidade: Double; const pId: string = ''); overload;
  end;


implementation

{ TItensVendidos }

constructor TItensVendidos.Create(const pProduto: TProduto; const pVenda: TVenda;
  const pQuantidade: Double; const pId: string);
begin
  inherited Create();
  Self.Produto := pProduto;
  Self.Venda := pVenda;
end;

constructor TItensVendidos.Create();
begin
  inherited Create();

end;

end.
