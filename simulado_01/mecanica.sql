create extension if not exists pgcrypto;

create table if not exists cliente (
	id uuid primary key default gen_random_uuid(),
	nome varchar(100) not null,
	contato varchar(100) not null,
	endereco varchar(100)
);
create table if not exists veiculo (
	id uuid primary key default gen_random_uuid(),
	modelo varchar(50) not null,
	marca varchar(50) not null,
	ano int not null,
	cor varchar(25) not null,
	cliente_id uuid,
	constraint fk_cliente_veiculo foreign key (cliente_id) references cliente(id)
);
create table if not exists ordem_servico (
	id uuid primary key default gen_random_uuid(),
	data_abertura timestamp default(now()),
	data_conclusao_prevista timestamp not null,
	data_conclusao_real timestamp,
	status varchar(30) default 'Aberta',
	veiculo_id uuid,
	constraint fk_veiculo_ordem foreign key (veiculo_id) references veiculo(id),
	constraint chk_status check (status in ('Aberta', 'Em Andamento', 'Aguardando Peça', 'Concluida', 'Cancelada'))
);
create table if not exists servico (
	id uuid primary key default gen_random_uuid(),
	nome varchar(100) not null,
	tempo_estimado timestamp not null,
	valor_mao_obra numeric(10,2) not null
);
create table if not exists servico_realizado (
	id uuid primary key default gen_random_uuid(),
	ordem_servico_id uuid,
	servico_id uuid,
	constraint fk_ordem_realizado foreign key (ordem_servico_id) references ordem_servico(id),
	constraint fk_servico_realizado foreign key (servico_id) references servico(id)
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
create table if not exists mecanico (
	id uuid primary key default gen_random_uuid(),
	nome varchar(100),
	mecanico_responsavel_id uuid
);
create table if not exists especialidade (
	id uuid primary key default gen_random_uuid(),
	nome varchar(100) not null
);
create table if not exists especialidade_mecanico (
	id uuid primary key default gen_random_uuid(),
	especialidade_id uuid,
	mecanico_id uuid,
	constraint fk_especialidade foreign key (especialidade_id) references especialidade(id),
	constraint fk_mecanico_especialidade foreign key (mecanico_id) references mecanico(id)
);
create table if not exists ordem_mecanico (
	id uuid primary key default gen_random_uuid(),
	ordem_servico_id uuid,
	mecanico_id uuid,
	constraint fk_ordem_id foreign key (ordem_servico_id) references ordem_servico(id),
	constraint fk_mecanico_ordem foreign key (mecanico_id) references mecanico(id)
);
create table if not exists avaliacao (
	id uuid primary key default gen_random_uuid(),
	nota int not null,
	comentario varchar(255),
	ordem_servico_id uuid,
	constraint fk_ordem_avaliacao foreign key (ordem_servico_id) references ordem_servico(id),
	constraint chk_nota check (nota in (1,2,3,4,5))
);