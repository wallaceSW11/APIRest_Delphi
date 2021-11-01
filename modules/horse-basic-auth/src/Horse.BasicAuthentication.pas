unit Horse.BasicAuthentication;

{$IF DEFINED(FPC)}
  {$MODE DELPHI}{$H+}
{$ENDIF}

interface

uses
  {$IF DEFINED(FPC)}
    SysUtils, base64, Classes,
  {$ELSE}
    System.SysUtils, System.NetEncoding, System.Classes,
  {$ENDIF}
  Horse, Horse.Commons;

const
  AUTHORIZATION = 'authorization';

type
  THorseBasicAuthentication = {$IF NOT DEFINED(FPC)} reference to {$ENDIF} function(const AUsername, APassword: string): Boolean;

procedure Middleware(Req: THorseRequest; Res: THorseResponse; Next: {$IF DEFINED(FPC)} TNextProc {$ELSE} TProc {$ENDIF} );
function HorseBasicAuthentication(const AAuthenticate: THorseBasicAuthentication; const AHeader: string = AUTHORIZATION; const ARealmMessage: string = 'Enter credentials'): THorseCallback;

implementation

var
  Header: string;
  RealmMessage: string;
  Authenticate: THorseBasicAuthentication;

function HorseBasicAuthentication(const AAuthenticate: THorseBasicAuthentication; const AHeader: string = AUTHORIZATION; const ARealmMessage: string = 'Enter credentials'): THorseCallback;
begin
  Header := AHeader;
  RealmMessage := ARealmMessage;
  Authenticate := AAuthenticate;
  Result := Middleware;
end;

procedure Middleware(Req: THorseRequest; Res: THorseResponse; Next: {$IF DEFINED(FPC)} TNextProc {$ELSE} TProc {$ENDIF});
const
  BASIC_AUTH = 'basic ';
var
  LBasicAuthenticationEncode: string;
  LBase64String: string;
  LBasicAuthenticationDecode: TStringList;
  LIsAuthenticated: Boolean;
begin
  LBasicAuthenticationEncode := Req.Headers[Header];
  if LBasicAuthenticationEncode.Trim.IsEmpty and not Req.Query.TryGetValue(Header, LBasicAuthenticationEncode) then
  begin
    Res.Send('Authorization not found').Status(THTTPStatus.Unauthorized).RawWebResponse
    {$IF DEFINED(FPC)}
      .WWWAuthenticate := Format('Basic realm=%s', [RealmMessage]);
    {$ELSE}
      .Realm := RealmMessage;
    {$ENDIF}
    raise EHorseCallbackInterrupted.Create;
  end;
  if not LBasicAuthenticationEncode.ToLower.StartsWith(BASIC_AUTH) then
  begin
    Res.Send('Invalid authorization type').Status(THTTPStatus.Unauthorized);
    raise EHorseCallbackInterrupted.Create;
  end;
  LBasicAuthenticationDecode := TStringList.Create;
  try
    LBasicAuthenticationDecode.Delimiter := ':';
    LBasicAuthenticationDecode.StrictDelimiter := True;
    LBase64String := LBasicAuthenticationEncode.Replace(BASIC_AUTH, '', [rfIgnoreCase]);
    LBasicAuthenticationDecode.DelimitedText := {$IF DEFINED(FPC)}DecodeStringBase64(LBase64String){$ELSE}TBase64Encoding.Base64.Decode(LBase64String){$ENDIF};
    try
      LIsAuthenticated := Authenticate(LBasicAuthenticationDecode.Strings[0], LBasicAuthenticationDecode.Strings[1]);
    except
      on E: exception do
      begin
        Res.Send(E.Message).Status(THTTPStatus.InternalServerError);
        raise EHorseCallbackInterrupted.Create;
      end;
    end;
  finally
    LBasicAuthenticationDecode.Free;
  end;
  if not LIsAuthenticated then
  begin
    Res.Send('Unauthorized').Status(THTTPStatus.Unauthorized);
    raise EHorseCallbackInterrupted.Create;
  end;
  Next();
end;

end.
