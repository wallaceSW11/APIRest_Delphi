program API_Rest;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  FastMMMemLeakMonitor,
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
  Contexto.Query in 'src\Contexto\Contexto.Query.pas';

var
  lControllerCliente: TControllerCliente;
begin
  ReportMemoryLeaksOnShutdown := True;
//  IsConsole:= False;
  THorse.Use(Jhonson());
  lControllerCliente := TControllerCliente.Create();
  lControllerCliente.Routes();
  THorse.Listen(9000);
end.
