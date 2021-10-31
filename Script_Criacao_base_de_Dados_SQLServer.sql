Create Database apirest

USE apirest

GO

CREATE TABLE Cliente(
	id nvarchar(40) NOT NULL PRIMARY KEY,
	Nome nvarchar(200) NOT NULL,
	DataNascimento date NULL,
	Documento nvarchar(20) NULL)
GO

CREATE TABLE Produto(
	id nvarchar(40) NOT NULL PRIMARY KEY,
	Nome nvarchar(200) NOT NULL,
	Valor float NOT NULL) 
GO

CREATE TABLE Venda(
	id nvarchar(40) NOT NULL PRIMARY KEY,
	DataVenda date NOT NULL,
	Cliente nvarchar(200) NOT NULL)
GO

CREATE TABLE ItensVendidos(
	id nvarchar(40) NOT NULL PRIMARY KEY,
	Produto nvarchar(40) NOT NULL,
	Venda nvarchar(40) NOT NULL,
	Quantidade decimal(18, 3) NOT NULL)
GO


