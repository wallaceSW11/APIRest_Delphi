unit Repositories.Interfaces;

interface

uses
  Models.Cliente,
  Models.Produto,
  Models.Venda,
  Models.ItensVendidos,
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

  IRepositoryVenda = interface
    function ObterVendas(): TObjectList<TVenda>;
    function ObterVendaPorIdentificador(const pIdentificadorVenda: string): TVenda;
    function CriarVenda(const pVenda: TVenda): TVenda;
    function AtualizarVenda(const pIdentificadorVenda: string; const pVenda: TVenda): TVenda;
    function VendaExiste(const pIdentificadorVenda: string): Boolean;
    procedure ExcluirVenda(const pIdentificadorVenda: string);
  end;

  IRepositoryItensVendidos = interface
    function ObterListaItensVendidos(): TObjectList<TItensVendidos>;
    function ObterItensVendidosPorIdentificador(const pIdentificadorItensVendidos: string): TItensVendidos;
    function CriarItensVendidos(const pItensVendidos: TItensVendidos): TItensVendidos;
    function AtualizarItensVendidos(const pIdentificadorItensVendidos: string; const pItensVendidos: TItensVendidos): TItensVendidos;
    function ItensVendidosExiste(const pIdentificadorItensVendidos: string): Boolean;
    procedure ExcluirItensVendidos(const pIdentificadorItensVendidos: string);
  end;

implementation

end.
