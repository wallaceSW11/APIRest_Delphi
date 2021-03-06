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
    constructor Create(const pData: TDateTime; const pClient: TCliente; const pId: string = ''); overload;
  end;

implementation

{ TVenda }

constructor TVenda.Create(const pData: TDateTime; const pClient: TCliente; const pId: string);
begin
  inherited Create();
  Self.DataVenda := pData;
  Self.Cliente := pClient;
  Self.Id := pId;
end;

constructor TVenda.Create();
begin
  inherited Create();

end;

end.
