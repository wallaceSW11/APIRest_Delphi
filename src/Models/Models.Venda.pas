unit Models.Venda;

interface

uses
  Models.Cliente;

type
  TVenda = class
  private
    FDataVenda: TDateTime;
    FCliente: TCliente;
  public
    property DataVenda: TDateTime read FDataVenda write FDataVenda;
    property Cliente: TCliente read FCliente write FCliente;
  end;

implementation

end.
