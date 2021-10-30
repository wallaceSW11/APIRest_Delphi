unit Models.Venda;

interface

uses
  Models.CadastroBase,
  Models.Cliente;

type
  TVenda = class(TCadastroBase)
  private
    FDataVenda: TDateTime;
    FCliente: TCliente;
  public
    property DataVenda: TDateTime read FDataVenda write FDataVenda;
    property Cliente: TCliente read FCliente write FCliente;
    constructor Create(); overload;
    constructor Create( const pClient: TCliente); overload;
  end;

implementation

{ TVenda }

constructor TVenda.Create(const pClient: TCliente);
begin
  inherited Create();
  Self.Cliente := pClient;
end;

constructor TVenda.Create();
begin
  inherited Create();

end;

end.
