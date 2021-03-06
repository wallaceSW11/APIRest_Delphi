unit Contexto.Conexao.Interfaces;

interface

uses
  Data.DB,
  Data.Win.ADODB;

type
  IConexao = interface
    ['{EA1DA372-9D8A-4A57-90E7-7B9331CDE82F}']
    function Conexao(): TADOConnection;
  end;

  IQuery = interface
    ['{D15FD4B4-670C-4E7A-A52A-E6FAC02DDE76}']
    function Query(const pComandoSQL: string): TDataSet;
    procedure Exec(const pComandoSQL: string);
  end;

implementation

end.
