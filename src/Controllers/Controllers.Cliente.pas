unit Controllers.Cliente;

interface

uses
  Models.Cliente,
  System.Generics.Collections,
  System.SysUtils,
  Horse,
  Horse.Commons,
  System.JSON,
  REST.Json;

type
  TControllerCliente = class
  public
    procedure ListarClientePorId(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure ListarClientes(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure Routes();

  end;

implementation

{ TControllerCliente }



procedure TControllerCliente.ListarClientePorId(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  lCliente: TCliente;
begin
  lCliente := TCliente.Create('wallace', StrToDate('11/09/1989'), '12345678999');

  Res.Send<TJsonObject>(TJson.ObjectToJsonObject(lCliente)).Status(THTTPStatus.OK);
end;

procedure TControllerCliente.ListarClientes(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  lCliente, loutro: TCliente;
  lClientes, l2: TObjectList<TCliente>;
  lLista: TJsonarray;
  lObj: TJsonObject;
begin
  lClientes := TObjectList<TCliente>.Create();

  lCliente := TCliente.Create('wallace', StrToDate('11/09/1989'), '12345678999');
  lClientes.Add(lCliente);

  lCliente := TCliente.Create('ferreira', StrToDate('12/09/2019'), '12345678999');
  lClientes.Add(lCliente);
  
  lLista := TJSONArray.Create;

  for loutro in lClientes do
  begin
    lObj := TJson.ObjectToJsonObject(loutro);
    lLista.AddElement(lObj);    
  end;

  Res.Send<TJSONArray>(lLista);
end;

procedure TControllerCliente.Routes();
begin
  THorse.Get('/cliente/', ListarClientes);
  THorse.Get('/cliente/:id', ListarClientePorId);

end;

end.