program API_Rest;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Horse,
  Horse.Jhonson,
  Rest.JSON,
  System.JSON,
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
  Controllers.Venda in 'src\Controllers\Controllers.Venda.pas';

var
  FControllerCliente: IControllerCliente;
  FControllerProduto: IControllerProduto;
  FControllerVenda: IControllerVenda;
begin
  ReportMemoryLeaksOnShutdown := True;
  //IsConsole:= False;

  THorse.Use(Jhonson());
  FControllerCliente := TControllerCliente.NovaInstancia();
  FControllerCliente.Routes();
  FControllerProduto := TControllerProduto.NovaInstancia();
  FControllerProduto.Routes();
  FControllerVenda := TControllerVenda.NovaInstancia();
  FControllerVenda.Routes();
  THorse.Listen(9000);
end.
