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
  lCliente: TCliente;
  lClientes, l2: TObjectList<TCliente>;
  lLista: TJsonarray;
begin
  lClientes := TObjectList<TCliente>.Create();

  lCliente := TCliente.Create('wallace', StrToDate('11/09/1989'), '12345678999');
  lClientes.Add(lCliente);
  lCliente.Free();

  lCliente := TCliente.Create('ferreira', StrToDate('12/09/2019'), '12345678999');
  lClientes.Add(lCliente);
  lCliente.Free();

//  lLista := TJSONArray.Create;
//  lLista := TJson.JsonToObject<TCliente>(lClientes);



  //Res.Send<TJSONArray>(TJson.ObjectToJsonObject(lClientes));

//  Res.Send<TJsonObject>(TJson.ObjectToJsonObject(lClientes)).Status(THTTPStatus.OK);
end;

procedure TControllerCliente.Routes();
begin
  THorse.Get('/cliente/', ListarClientes);
  THorse.Get('/cliente/:id', ListarClientePorId);

end;

end.
