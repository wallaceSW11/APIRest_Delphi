unit Models.CadastroBase;

interface

uses
  System.SysUtils;

type
  TCadastroBase = class
  private
    FId: string;
  protected
    constructor Create();
  public
    property Id: string read FId write FId;
  end;

implementation

{ TCadastroBase }

constructor TCadastroBase.Create;
var
  lGuid: TGuid;
begin
  CreateGUID(lGuid);
  Self.Id := GUIDToString(lGuid).Replace('{', EmptyStr).Replace('}', EmptyStr);
end;
end.
