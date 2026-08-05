create extension if not exists pgcrypto;

create table if not exists cliente (
	id uuid primary key default gen_random_uuid(),
	nome varchar(100) not null,
	endereco varchar(100),
	contato varchar(25) not null
);
create table if not exists veiculo (
	id uuid primary key default gen_random_uuid(),
	placa varchar(20) not null,
	modelo varchar(50) not null,
	marca varchar(50) not null,
	ano int not null,
	cor varchar(50) not null,
	cliente_id uuid not null,
	constraint fk_cliente_veiculo foreign key(cliente_id) references cliente(id)
);
create table if not exists ordem_servico (
	id uuid primary key default gen_random_uuid(),
	data_abertura timestamp default(now()),
	data_conclusao_previsto varchar(50) not null,
	data_conclusao_real varchar(50),
	status varchar(50) default 'Aberto',
	veiculo_id uuid,
	constraint chk_status check(status in ('Aberto', 'Em andamento', 'Aguardando peça', 'Concluido', 'Cancelado')),
	constraint fk_veiculo_ordem foreign key(veiculo_id) references veiculo(id)
);
create table if not exists catalogo (
	id uuid primary key default gen_random_uuid(),
	nome varchar(100) not null,
	tempo_estimado varchar(100) not null,
	valor_mao_obra numeric(10,2) not null
);
create table if not exists servico_realizado (
	id uuid primary key default gen_random_uuid(),
	ordem_servico_id uuid,
	catalogo_id uuid,
	valor_mao_obra numeric(10,2),
	constraint fk_ordem_realizado foreign key(ordem_servico_id) references ordem_servico(id),
	constraint fk_catalogo_servico foreign key(catalogo_id) references catalogo(id)
);
create table if not exists fornecedor (
	id uuid primary key default gen_random_uuid(),
	nome varchar(100) not null,
	endereco varchar(100) not null,
	contato varchar(100) not null
);
create table if not exists peca (
	id uuid primary key default gen_random_uuid(),
	nome varchar(100) not null,
	quantidade int not null,
	preco_atual numeric(10,2) not null,
	fornecedor_id uuid,
	constraint fk_fornecedor_peca foreign key (fornecedor_id) references fornecedor(id)
	
);
create table if not exists pecas_ordem (
	id uuid primary key default gen_random_uuid(),
	peca_id uuid,
	ordem_servico_id uuid,
	quantidade int not null,
	preco numeric(10,2) not null,
	constraint fk_pecas foreign key (peca_id) references peca(id),
	constraint fk_ordem_pecas foreign key (ordem_servico_id) references ordem_servico(id)
);
create table if not exists mecanico (
	id uuid primary key default gen_random_uuid(),
	nome varchar(100) not null,
	mecanico_supervisor_id uuid,
	constraint fk_mecanico_supervisor foreign key (mecanico_supervisor_id) references mecanico(id)
);
create table if not exists especialidade (
	id uuid primary key default gen_random_uuid(),
	nome varchar(100) not null
);
create table if not exists mecanico_especialidade (
	id uuid primary key default gen_random_uuid(),
	mecanico_id uuid,
	especialidade_id uuid,
	constraint fk_mecanico_especialidade foreign key (mecanico_id) references mecanico(id),
	constraint fk_especialidade_mecanico foreign key (especialidade_id) references especialidade(id)
);
create table if not exists mecanico_ordem (
	id uuid primary key default gen_random_uuid(),
	mecanico_id uuid,
	ordem_servico_id uuid,
	constraint fk_mecanico_ordem foreign key (mecanico_id) references mecanico(id),
	constraint fk_ordem_mecanico foreign key (ordem_servico_id) references ordem_servico(id)
);
create table if not exists avaliacao (
	id uuid primary key default gen_random_uuid(),
	nota int not null,
	comentario varchar(255),
	ordem_servico_id uuid not null unique,
	constraint chk_nota check(nota in (1,2,3,4,5)),
	constraint fk_ordem_avaliacao foreign key (ordem_servico_id) references ordem_servico(id)
);