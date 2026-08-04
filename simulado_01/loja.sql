select nome, nome_produto, quantidade, (quantidade * preco_unitario) as valor_total from itens_pedido as i
inner join produtos as p on i.id_produto = p.id_produto
inner join pedidos as pe on i.id_pedido = pe.id_pedido
inner join clientes as c on pe.id_cliente = c.id_cliente
where status = 'Concluido'