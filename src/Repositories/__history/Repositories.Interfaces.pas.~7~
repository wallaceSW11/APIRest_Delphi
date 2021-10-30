unit Repositories.Interfaces;

interface

uses
  Models.Cliente,
  System.Generics.Collections;

type
  IRepositoryCliente = interface
    function ObterClientes(): TObjectList<TCliente>;
    function ObterClientePorIdentificador(const pIdentificadorCliente: string): TCliente;
    function CriarCliente(const pCliente: TCliente): TCliente;
    function AtualizarCliente(const pIdentificadorCliente: string; const pCliente: TCliente): TCliente;
    function ClienteExiste(const pIdentificadorCliente: string): Boolean;
    procedure ExcluirCliente(const pIdentificadorCliente: string);
  end;

implementation

end.
