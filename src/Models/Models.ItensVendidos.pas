unit Models.ItensVendidos;

interface

uses
  Models.Produto, Models.Venda;

type
  TItensVendidos = class
  private
    FProduto: TProduto;
    FVenda: TVenda;
  public
    property Produto: TProduto read FProduto write FProduto;
    property Venda: TVenda read FVenda write FVenda;
  end;


implementation

end.
