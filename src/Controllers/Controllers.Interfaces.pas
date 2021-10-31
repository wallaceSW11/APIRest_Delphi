unit Controllers.Interfaces;

interface

uses
  Horse;

type
  IControllerCliente = interface
    ['{4A2017FD-E6DF-47CE-96B1-330233B9D45E}']
    procedure ListarClientePorId(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure ListarClientes(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure CriarCliente(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure AtualizarCliente(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure ExcluirCliente(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure Routes();
  end;

  IControllerProduto = interface
    ['{4A2017FD-E6DF-47CE-96B1-330233B9D45E}']
    procedure ListarProdutoPorId(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure ListarProdutos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure CriarProduto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure AtualizarProduto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure ExcluirProduto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure Routes();
  end;

  IControllerVenda = interface
    ['{4A2017FD-E6DF-47CE-96B1-330233B9D45E}']
    procedure ListarVendaPorId(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure ListarVendas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure CriarVenda(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure AtualizarVenda(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure ExcluirVenda(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure Routes();
  end;

  IControllerItensVendidos = interface
    ['{4A2017FD-E6DF-47CE-96B1-330233B9D45E}']
    procedure ListarItensVendidosPorId(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure ListarItensVendidoss(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure CriarItensVendidos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure AtualizarItensVendidos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure ExcluirItensVendidos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure Routes();
  end;

implementation

end.
