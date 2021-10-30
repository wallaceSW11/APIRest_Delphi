unit Repositories.Interfaces;

interface

uses
  Models.Cliente,
  Models.Produto,
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

  IRepositoryProduto = interface
    function ObterProdutos(): TObjectList<TProduto>;
    function ObterProdutoPorIdentificador(const pIdentificadorProduto: string): TProduto;
    function CriarProduto(const pProduto: TProduto): TProduto;
    function AtualizarProduto(const pIdentificadorProduto: string; const pProduto: TProduto): TProduto;
    function ProdutoExiste(const pIdentificadorProduto: string): Boolean;
    procedure ExcluirProduto(const pIdentificadorProduto: string);
  end;

implementation

end.
