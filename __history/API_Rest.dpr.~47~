program API_Rest;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  Horse.Jhonson,
  Horse.GBSwagger,
  Rest.JSON,
  System.JSON,
  Horse.HandleException,
  Models.Cliente in 'src\Models\Models.Cliente.pas',
  Models.Produto in 'src\Models\Models.Produto.pas',
  Models.Venda in 'src\Models\Models.Venda.pas',
  Models.ItensVendidos in 'src\Models\Models.ItensVendidos.pas',
  Controllers.Cliente in 'src\Controllers\Controllers.Cliente.pas',
  Repositories.Cliente in 'src\Repositories\Repositories.Cliente.pas',
  Models.CadastroBase in 'src\Models\Models.CadastroBase.pas',
  Contexto.Conexao in 'src\Contexto\Contexto.Conexao.pas',
  Contexto.Conexao.Interfaces in 'src\Contexto\Contexto.Conexao.Interfaces.pas',
  Contexto.Query in 'src\Contexto\Contexto.Query.pas',
  Repositories.Interfaces in 'src\Repositories\Repositories.Interfaces.pas',
  Controllers.Interfaces in 'src\Controllers\Controllers.Interfaces.pas',
  Repositories.Produto in 'src\Repositories\Repositories.Produto.pas',
  Controllers.Produto in 'src\Controllers\Controllers.Produto.pas',
  Repositories.Venda in 'src\Repositories\Repositories.Venda.pas',
  Controllers.Venda in 'src\Controllers\Controllers.Venda.pas',
  Repositories.ItensVendidos in 'src\Repositories\Repositories.ItensVendidos.pas',
  Controllers.ItensVendidos in 'src\Controllers\Controllers.ItensVendidos.pas',
  Helper.NumberHelper in 'src\Helper\Helper.NumberHelper.pas';

var
  FControllerCliente: IControllerCliente;
  FControllerProduto: IControllerProduto;
  FControllerVenda: IControllerVenda;
  FControllerItensVendidos: IControllerItensVendidos;
begin
  ReportMemoryLeaksOnShutdown := True;
  //IsConsole:= False;

  THorse
    .Use(Jhonson)
    .Use(HorseSwagger)
    .Use(HandleException);

  FControllerCliente := TControllerCliente.NovaInstancia();
  FControllerProduto := TControllerProduto.NovaInstancia();
  FControllerVenda := TControllerVenda.NovaInstancia();
  FControllerItensVendidos := TControllerItensVendidos.NovaInstancia();

  FControllerCliente.Routes();
  FControllerProduto.Routes();
  FControllerVenda.Routes();
  FControllerItensVendidos.Routes();

  THorse.Listen(9000);
end.
