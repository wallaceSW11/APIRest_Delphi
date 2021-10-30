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

implementation

end.