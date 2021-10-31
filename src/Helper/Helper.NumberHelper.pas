unit Helper.NumberHelper;

interface

uses
  System.SysUtils;

type
  TCurrency_Helper = record helper for Currency
    function FormatoBancoDeDados(): string;
  end;

  TDouble_Helper = record helper for Double
    function FormatoBancoDeDados(): string;
  end;

implementation

{ TCurrency_Helper }

function TCurrency_Helper.FormatoBancoDeDados: string;
begin
  Result := FloatToStr(Self).Replace('.', EmptyStr).Replace(',', '.');
end;

{ TDouble_Helper }

function TDouble_Helper.FormatoBancoDeDados: string;
begin
  Result := FloatToStr(Self).Replace('.', EmptyStr).Replace(',', '.');
end;

end.
