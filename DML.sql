/* Dados de exemplo */

INSERT INTO cliente (nome, cpf, email, senha, telefone) VALUES ('Maria Silva',  '12345678901', 'maria@email.com', 'hash_senha_1', '74999990001');
INSERT INTO cliente (nome, cpf, email, senha, telefone) VALUES ('João Pereira', '23456789012', 'joao@email.com',  'hash_senha_2', '74999990002');
INSERT INTO cliente (nome, cpf, email, senha, telefone) VALUES ('Ana Souza',    '34567890123', 'ana@email.com',   'hash_senha_3', '74999990003');
INSERT INTO cliente (nome, cpf, email, senha, telefone) VALUES ('Carlos Henrique',  '45678901234', 'carlos@email.com',  'hash_senha_4',  '74999990004');
INSERT INTO cliente (nome, cpf, email, senha, telefone) VALUES ('Fernanda Lima',    '56789012345', 'fernanda@email.com','hash_senha_5',  '74999990005');
INSERT INTO cliente (nome, cpf, email, senha, telefone) VALUES ('Ricardo Alves',    '67890123456', 'ricardo@email.com', 'hash_senha_6',  '74999990006');
INSERT INTO cliente (nome, cpf, email, senha, telefone) VALUES ('Juliana Rocha',    '78901234567', 'juliana@email.com', 'hash_senha_7',  '74999990007');
INSERT INTO cliente (nome, cpf, email, senha, telefone) VALUES ('Pedro Martins',    '89012345678', 'pedro@email.com',   'hash_senha_8',  '74999990008');
INSERT INTO cliente (nome, cpf, email, senha, telefone) VALUES ('Camila Duarte',    '90123456789', 'camila@email.com',  'hash_senha_9',  '74999990009');
INSERT INTO cliente (nome, cpf, email, senha, telefone) VALUES ('Lucas Oliveira',   '11223344556', 'lucas@email.com',   'hash_senha_10', '74999990010');
INSERT INTO cliente (nome, cpf, email, senha, telefone) VALUES ('Patrícia Gomes',   '22334455667', 'patricia@email.com','hash_senha_11', '74999990011');


INSERT INTO endereco (id_cliente, logradouro, numero, complemento, bairro, cidade, uf, cep) VALUES (1, 'Rua das Acácias',   '123', 'Apto 101', 'Centro',       'Petrolina', 'PE', '56300000');
INSERT INTO endereco (id_cliente, logradouro, numero, complemento, bairro, cidade, uf, cep) VALUES (1, 'Av. das Palmeiras', '456', NULL,       'Areia Branca', 'Petrolina', 'PE', '56310000');
INSERT INTO endereco (id_cliente, logradouro, numero, complemento, bairro, cidade, uf, cep) VALUES (2, 'Rua dos Ipês',      '78',  NULL,       'Vila Eduardo', 'Petrolina', 'PE', '56320000');
INSERT INTO endereco (id_cliente, logradouro, numero, complemento, bairro, cidade, uf, cep) VALUES (3, 'Rua do Sol',        '999', 'Casa B',   'Cohab',        'Juazeiro',  'BA', '48900000');
INSERT INTO endereco (id_cliente, logradouro, numero, complemento, bairro, cidade, uf, cep) VALUES (4, 'Rua A', '10', NULL, 'Centro', 'Petrolina', 'PE', '56305000');
INSERT INTO endereco (id_cliente, logradouro, numero, complemento, bairro, cidade, uf, cep) VALUES (5, 'Av. Brasil', '250', 'Casa', 'Atrás da Banca', 'Juazeiro', 'BA', '48905000');
INSERT INTO endereco (id_cliente, logradouro, numero, complemento, bairro, cidade, uf, cep) VALUES (6, 'Rua do Comércio', '89', NULL, 'Centro', 'Recife', 'PE', '50000000');
INSERT INTO endereco (id_cliente, logradouro, numero, complemento, bairro, cidade, uf, cep) VALUES (7, 'Travessa das Flores', '45', 'Bloco B', 'Jardim Amazonas', 'Salvador', 'BA', '40000000');
INSERT INTO endereco (id_cliente, logradouro, numero, complemento, bairro, cidade, uf, cep) VALUES (8, 'Rua Projetada', '777', NULL, 'São José', 'Petrolina', 'PE', '56330000');
INSERT INTO endereco (id_cliente, logradouro, numero, complemento, bairro, cidade, uf, cep) VALUES (9, 'Rua da Paz', '31', NULL, 'Centro', 'Sobradinho', 'BA', '48925000');
INSERT INTO endereco (id_cliente, logradouro, numero, complemento, bairro, cidade, uf, cep) VALUES (10, 'Av. Sete de Setembro', '1900', 'Apto 504', 'Centro', 'Juazeiro', 'BA', '48903000');
INSERT INTO endereco (id_cliente, logradouro, numero, complemento, bairro, cidade, uf, cep) VALUES (11, 'Rua da Aurora', '550', NULL, 'Boa Vista', 'Recife', 'PE', '50050000');

INSERT INTO categoria (nome, descricao) VALUES ('Eletrônicos', 'Aparelhos eletrônicos em geral');
INSERT INTO categoria (nome, descricao) VALUES ('Informática', 'Computadores, periféricos e acessórios');
INSERT INTO categoria (nome, descricao) VALUES ('Áudio',       'Fones, caixas de som e equipamentos de áudio');
INSERT INTO categoria (nome, descricao) VALUES ('Livros',      'Livros físicos e digitais');
INSERT INTO categoria (nome, descricao) VALUES ('Games', 'Consoles e acessórios gamer');
INSERT INTO categoria (nome, descricao) VALUES ('Smartphones', 'Celulares e acessórios');
INSERT INTO categoria (nome, descricao) VALUES ('Periféricos', 'Teclados, mouses e webcams');
INSERT INTO categoria (nome, descricao) VALUES ('Casa Inteligente', 'Automação residencial');

INSERT INTO produto (nome, descricao, preco, estoque) VALUES ('Notebook Acer Aspire 5',   'Notebook 15.6", i5, 8GB RAM, 256GB SSD',    3499.90, 15);
INSERT INTO produto (nome, descricao, preco, estoque) VALUES ('Fone Bluetooth JBL T520',  'Fone over-ear com cancelamento de ruído',    349.90, 50);
INSERT INTO produto (nome, descricao, preco, estoque) VALUES ('Mouse Logitech MX Master', 'Mouse sem fio ergonômico',                   599.00, 30);
INSERT INTO produto (nome, descricao, preco, estoque) VALUES ('Livro: Banco de Dados',    'Sistemas de banco de dados - Elmasri',       189.50, 20);
INSERT INTO produto (nome, descricao, preco, estoque) VALUES ('Teclado Mecânico Redragon', 'Teclado RGB switch blue', 249.90, 40);
INSERT INTO produto (nome, descricao, preco, estoque) VALUES ('Monitor LG UltraWide 29', 'Monitor IPS Full HD UltraWide', 1299.90, 12);
INSERT INTO produto (nome, descricao, preco, estoque) VALUES ('Smartphone Samsung Galaxy S24', '256GB, 8GB RAM', 4999.00, 18);
INSERT INTO produto (nome, descricao, preco, estoque) VALUES ('Echo Dot 5ª Geração', 'Assistente virtual Alexa', 379.90, 35);
INSERT INTO produto (nome, descricao, preco, estoque) VALUES ('PlayStation 5', 'Console Sony PS5 Slim', 4299.90, 10);
INSERT INTO produto (nome, descricao, preco, estoque) VALUES ('Webcam Logitech C920', 'Webcam Full HD para streaming', 459.00, 22);
INSERT INTO produto (nome, descricao, preco, estoque) VALUES ('SSD Kingston 1TB NVMe', 'SSD alta velocidade PCIe 4.0', 549.90, 28);
INSERT INTO produto (nome, descricao, preco, estoque) VALUES ('Cadeira Gamer XT Racer', 'Cadeira ergonômica reclinável', 1399.90, 9);
INSERT INTO produto (nome, descricao, preco, estoque) VALUES ('Livro: Clean Code', 'Livro de Robert C. Martin', 149.90, 25);
INSERT INTO produto (nome, descricao, preco, estoque) VALUES ('Mousepad Gamer RGB', 'Mousepad grande com iluminação', 89.90, 60);

INSERT INTO produto_categoria (id_produto, id_categoria) VALUES (1, 1);
INSERT INTO produto_categoria (id_produto, id_categoria) VALUES (1, 2);
INSERT INTO produto_categoria (id_produto, id_categoria) VALUES (2, 1);
INSERT INTO produto_categoria (id_produto, id_categoria) VALUES (2, 3);
INSERT INTO produto_categoria (id_produto, id_categoria) VALUES (3, 1);
INSERT INTO produto_categoria (id_produto, id_categoria) VALUES (3, 2);
INSERT INTO produto_categoria (id_produto, id_categoria) VALUES (4, 4);
INSERT INTO produto_categoria (id_produto, id_categoria) VALUES (5, 7);
INSERT INTO produto_categoria (id_produto, id_categoria) VALUES (6, 1);
INSERT INTO produto_categoria (id_produto, id_categoria) VALUES (6, 2);
INSERT INTO produto_categoria (id_produto, id_categoria) VALUES (7, 6);
INSERT INTO produto_categoria (id_produto, id_categoria) VALUES (8, 8);
INSERT INTO produto_categoria (id_produto, id_categoria) VALUES (9, 5);
INSERT INTO produto_categoria (id_produto, id_categoria) VALUES (10, 7);
INSERT INTO produto_categoria (id_produto, id_categoria) VALUES (11, 2);
INSERT INTO produto_categoria (id_produto, id_categoria) VALUES (11, 1);
INSERT INTO produto_categoria (id_produto, id_categoria) VALUES (12, 7);
INSERT INTO produto_categoria (id_produto, id_categoria) VALUES (13, 2);
INSERT INTO produto_categoria (id_produto, id_categoria) VALUES (14, 4);
INSERT INTO produto_categoria (id_produto, id_categoria) VALUES (14, 2);

INSERT INTO pedido (id_cliente, id_endereco, status, valor_total) VALUES (1, 1, 'pago',     3849.80);
INSERT INTO pedido (id_cliente, id_endereco, status, valor_total) VALUES (2, 3, 'enviado',   599.00);
INSERT INTO pedido (id_cliente, id_endereco, status, valor_total) VALUES (3, 4, 'pendente',  189.50);
INSERT INTO pedido (id_cliente, id_endereco, status, valor_total) VALUES (4, 5, 'pago', 1749.80);
INSERT INTO pedido (id_cliente, id_endereco, status, valor_total) VALUES (5, 6, 'entregue', 4999.00);
INSERT INTO pedido (id_cliente, id_endereco, status, valor_total) VALUES (6, 7, 'enviado', 4299.90);
INSERT INTO pedido (id_cliente, id_endereco, status, valor_total) VALUES (7, 8, 'cancelado', 379.90);
INSERT INTO pedido (id_cliente, id_endereco, status, valor_total) VALUES (8, 9, 'pago', 638.90);
INSERT INTO pedido (id_cliente, id_endereco, status, valor_total) VALUES (9, 10, 'pendente', 149.90);
INSERT INTO pedido (id_cliente, id_endereco, status, valor_total) VALUES (10, 11, 'pago', 5949.80);

INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario, subtotal) VALUES (1, 1, 1, 3499.90, 3499.90);
INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario, subtotal) VALUES (1, 2, 1,  349.90,  349.90);
INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario, subtotal) VALUES (2, 3, 1,  599.00,  599.00);
INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario, subtotal) VALUES (3, 4, 1,  189.50,  189.50);
INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario, subtotal) VALUES (4, 5, 1, 249.90, 249.90);
INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario, subtotal) VALUES (4, 12, 1, 1499.90, 1499.90);
INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario, subtotal) VALUES (5, 7, 1, 4999.00, 4999.00);
INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario, subtotal) VALUES (6, 9, 1, 4299.90, 4299.90);
INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario, subtotal) VALUES (7, 8, 1, 379.90, 379.90);
INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario, subtotal) VALUES (8, 10, 1, 459.00, 459.00);
INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario, subtotal) VALUES (8, 14, 2, 89.95, 179.90);
INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario, subtotal) VALUES (9, 13, 1, 149.90, 149.90);
INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario, subtotal) VALUES (10, 6, 1, 1299.90, 1299.90);
INSERT INTO item_pedido (id_pedido, id_produto, quantidade, preco_unitario, subtotal) VALUES (10, 7, 1, 4999.90, 4999.90);

INSERT INTO pagamento (id_pedido, forma_pagamento, valor, status) VALUES (1, 'cartao_credito', 3000.00, 'aprovado');
INSERT INTO pagamento (id_pedido, forma_pagamento, valor, status) VALUES (1, 'pix',             849.80, 'aprovado');
INSERT INTO pagamento (id_pedido, forma_pagamento, valor, status) VALUES (2, 'cartao_credito',  599.00, 'aprovado');
INSERT INTO pagamento (id_pedido, forma_pagamento, valor, status) VALUES (3, 'boleto',          189.50, 'pendente');
INSERT INTO pagamento (id_pedido, forma_pagamento, valor, status) VALUES (4, 'pix', 1749.80, 'aprovado');
INSERT INTO pagamento (id_pedido, forma_pagamento, valor, status) VALUES (5, 'cartao_credito', 4999.00, 'aprovado');
INSERT INTO pagamento (id_pedido, forma_pagamento, valor, status) VALUES (6, 'boleto', 4299.90, 'aprovado');
INSERT INTO pagamento (id_pedido, forma_pagamento, valor, status) VALUES (7, 'pix', 379.90, 'estornado');
INSERT INTO pagamento (id_pedido, forma_pagamento, valor, status) VALUES (8, 'cartao_debito', 638.90, 'aprovado');
INSERT INTO pagamento (id_pedido, forma_pagamento, valor, status) VALUES (9, 'boleto', 149.90, 'pendente');
INSERT INTO pagamento (id_pedido, forma_pagamento, valor, status) VALUES (10, 'cartao_credito', 5949.80, 'aprovado');

INSERT INTO avaliacao (id_item, nota, comentario) VALUES (1, 5, 'Excelente notebook, entrega rápida.');
INSERT INTO avaliacao (id_item, nota, comentario) VALUES (2, 4, 'Bom fone, mas a bateria poderia durar mais.');
INSERT INTO avaliacao (id_item, nota, comentario) VALUES (3, 5, 'Mouse excelente para produtividade.');
INSERT INTO avaliacao (id_item, nota, comentario) VALUES (5, 5, 'Celular muito rápido e câmera ótima.');
INSERT INTO avaliacao (id_item, nota, comentario) VALUES (6, 4, 'Console incrível, mas caro.');
INSERT INTO avaliacao (id_item, nota, comentario) VALUES (8, 5, 'Webcam perfeita para reuniões.');
INSERT INTO avaliacao (id_item, nota, comentario) VALUES (9, 4, 'Livro muito didático.');
INSERT INTO avaliacao (id_item, nota, comentario) VALUES (10, 5, 'Monitor excelente para trabalhar.');

COMMIT;