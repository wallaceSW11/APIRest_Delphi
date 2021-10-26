unit Controllers.Cliente;

interface

uses
  Models.Cliente,
  System.SysUtils,
  System.Generics.Collections;

type
  TControllerCliente = class
  public
    function ObterCliente(const pNome: string): TCliente;
    function ObterClientes(): TObjectList<TCliente>;
  end;

implementation

{ TControllerCliente }

function TControllerCliente.ObterCliente(const pNome: string): TCliente;
begin

end;

function TControllerCliente.ObterClientes(): TObjectList<TCliente>;
var
  lCliente: TCliente;
begin
  Result := TObjectList<TCliente>.Create();

  lCliente := TCliente.Create();
  lCliente.Nome := 'Wallace Ferreira';
  lCliente.DataNascimento := StrToDate('1989-09-11');
  lCliente.Documento := '12345678977';
  Result.Add(lCliente);
  lCliente.Free();

  lCliente := TCliente.Create();
  lCliente.Nome := 'Wallace Ferreira';
  lCliente.DataNascimento := StrToDate('1989-09-11');
  lCliente.Documento := '12345678977';
  Result.Add(lCliente);
  lCliente.Free;




end;

end.
