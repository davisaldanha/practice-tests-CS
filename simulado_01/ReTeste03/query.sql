--1v;
select nome,nome_produto,quantidade, (quantidade * preco_unitario) as valor_total from itens_pedido as ip 
inner join produtos as p on ip.id_produto = p.id_produto
inner join pedidos as pe on ip.id_pedido = pe.id_pedido
inner join clientes as c on pe.id_cliente = c.id_cliente
where status = 'Concluído' order by nome asc;

--3v
select p.nome_produto, p.preco, p.id_categoria from produtos as p where p.preco > (select avg(preco) from produtos p2 
where p2.id_categoria = p.id_categoria) order by id_produto asc

--7v
select f.nome, f.cargo, s.nome as nome_supervisor from funcionarios as f 
left join funcionarios as s on s.id_funcionario = f.id_supervisor

--8v
select p.nome_produto from avaliacoes as a right join produtos as p on a.id_produto = p.id_produto
where id_avaliacao is null order by p.id_produto asc