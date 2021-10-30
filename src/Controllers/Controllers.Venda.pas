unit Controllers.Venda;

interface

uses
  Models.Venda,
  System.Generics.Collections,
  System.SysUtils,
  Horse,
  Horse.Commons,
  System.JSON,
  REST.Json,
  Repositories.Venda,
  Repositories.Interfaces,
  Controllers.Interfaces;

type
  TControllerVenda = class(TInterfacedObject, IControllerVenda)
  private
    FRepositorioVenda: IRepositoryVenda;
    FVenda: TVenda;
    FVendas: TObjectList<TVenda>;
    constructor Create();
    function VendaExiste(Res: THorseResponse; const pIdentificadorVenda: string): Boolean;
  public
    procedure ListarVendaPorId(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure ListarVendas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure CriarVenda(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure AtualizarVenda(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure ExcluirVenda(Req: THorseRequest; Res: THorseResponse; Next: TProc);
    procedure Routes();
    class function NovaInstancia(): IControllerVenda;
    destructor Destroy(); override;
  end;

implementation

{ TControllerVenda }

procedure TControllerVenda.AtualizarVenda(Req: THorseRequest; Res: THorseResponse; Next: TProc);
const
  FALHA_AO_ATUALIZAR_VENDA = 'Falha ao atualizar a venda.';
begin
  if (not VendaExiste(Res, Req.Params['id'])) then
    Exit();

  FVenda := FRepositorioVenda.AtualizarVenda(
    Req.Params['id'], TJson.JsonToObject<TVenda>(Req.Body<TJSONObject>));

  if (Assigned(FVenda)) then
    Res.Send<TJsonObject>(TJson.ObjectToJsonObject(FVenda)).Status(THTTPStatus.Ok)
  else
    Res.Send(FALHA_AO_ATUALIZAR_VENDA).Status(THTTPStatus.BadRequest);
end;

function TControllerVenda.VendaExiste(Res: THorseResponse; const pIdentificadorVenda: string): Boolean;
const
  Venda_NAO_LOCALIZADO = 'N�o foi localizado a venda com o id "%s"';
begin
  Result := True;

  if (not FRepositorioVenda.VendaExiste(pIdentificadorVenda)) then
  begin
    Res.Send(Format(Venda_NAO_LOCALIZADO, [pIdentificadorVenda])).Status(THTTPStatus.NotFound);
    Result := False;
  end;
end;

constructor TControllerVenda.Create();
begin
  FRepositorioVenda := TRepositoryVenda.NovaInstancia();
  FVenda := TVenda.Create();
  FVendas := TObjectList<TVenda>.Create();
end;

procedure TControllerVenda.CriarVenda(Req: THorseRequest; Res: THorseResponse; Next: TProc);
const
  FALHA_AO_CRIAR_Venda = 'Falha ao criar a venda.';
begin
  FVenda := TJson.JsonToObject<TVenda>(Req.Body<TJSONObject>);
  FVenda := FRepositorioVenda.CriarVenda(FVenda);

  if (Assigned(FVenda)) then
    Res.Send<TJsonObject>(TJson.ObjectToJsonObject(FVenda)).Status(THTTPStatus.Created)
  else
    Res.Send(FALHA_AO_CRIAR_Venda).Status(THTTPStatus.BadRequest);
end;

destructor TControllerVenda.Destroy;
begin
  FVenda.Free();
  FVendas.Free();
  inherited;
end;

procedure TControllerVenda.ExcluirVenda(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  if (not VendaExiste(Res, Req.Params['id'])) then
    Exit();

  FRepositorioVenda.ExcluirVenda(Req.Params['id']);
  Res.Send('').Status(THTTPStatus.NoContent);
end;

procedure TControllerVenda.ListarVendaPorId(Req: THorseRequest; Res: THorseResponse; Next: TProc);
begin
  if (not VendaExiste(Res, Req.Params['id'])) then
    Exit();

  FVenda := FRepositorioVenda.ObterVendaPorIdentificador(Req.Params['id']);
  Res.Send<TJsonObject>(TJson.ObjectToJsonObject(FVenda)).Status(THTTPStatus.OK);
end;

procedure TControllerVenda.ListarVendas(Req: THorseRequest; Res: THorseResponse; Next: TProc);
const
  VendaS_NAO_ENCONTRADOS = 'Nenhum venda foi encontrada.';
var
  lVenda: TVenda;
  lJsonArray: TJsonarray;
  lJsonObject: TJsonObject;
begin
  FVendas := FRepositorioVenda.ObterVendas();

  if (not (Assigned(FVendas))) then
  begin
    Res.Send(VendaS_NAO_ENCONTRADOS).Status(THTTPStatus.NotFound);
    Exit();
  end;

  lJsonArray := TJSONArray.Create;

  for lVenda in FVendas do
  begin
    lJsonObject := TJson.ObjectToJsonObject(lVenda);
    lJsonArray.AddElement(lJsonObject);
  end;

  Res.Send<TJSONArray>(lJsonArray);
end;

class function TControllerVenda.NovaInstancia(): IControllerVenda;
begin
  Result := Self.Create();
end;

procedure TControllerVenda.Routes();
begin
  THorse.Get('/venda/', ListarVendas);
  THorse.Get('/venda/:id', ListarVendaPorId);
  THorse.Post('/venda/', CriarVenda);
  THorse.PUT('/venda/:id', AtualizarVenda);
  THorse.Delete('venda/:id', ExcluirVenda);
end;

end.
