CREATE DATABASE task_manager;
USE task_manager;

-- =========================
-- ORGANIZACAO
-- =========================
CREATE TABLE organizacao (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome_fantasia VARCHAR(255) NOT NULL,
    cnpj VARCHAR(20) UNIQUE NOT NULL,
    email_contato VARCHAR(255)
);

-- =========================
-- PERFIL
-- =========================
CREATE TABLE perfil (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL
);

INSERT INTO perfil (nome) VALUES ('Admin'), ('Colaborador');

-- =========================
-- USUARIO
-- =========================
CREATE TABLE usuario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_ativo BOOLEAN DEFAULT TRUE,
    perfil_id INT,
    cargo VARCHAR(100),
    data_desativacao TIMESTAMP NULL,
	organizacao_id INT,

	FOREIGN KEY (organizacao_id) REFERENCES organizacao(id),
    FOREIGN KEY (perfil_id) REFERENCES perfil(id)
);

-- =========================
-- CLIENTE
-- =========================
CREATE TABLE cliente (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email_contato VARCHAR(255),
    telefone VARCHAR(20),
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_ativo BOOLEAN DEFAULT TRUE,
    data_desativacao TIMESTAMP NULL
);

-- =========================
-- PROJETO
-- =========================
CREATE TABLE projeto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT,

    nome VARCHAR(255) NOT NULL,
    descricao TEXT,

    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_inicio TIMESTAMP,
    data_fim TIMESTAMP,
    cor VARCHAR(20),
    risco VARCHAR(255) NULL,

    FOREIGN KEY (cliente_id) REFERENCES cliente(id)
);

-- =========================
-- USUARIOS DO PROJETO (N:N)
-- =========================
CREATE TABLE projeto_usuario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    projeto_id INT,
    usuario_id INT,
    papel ENUM('Admin', 'Colaborador') DEFAULT 'Colaborador',

    FOREIGN KEY (projeto_id) REFERENCES projeto(id),
    FOREIGN KEY (usuario_id) REFERENCES usuario(id)
);

-- =========================
-- SPRINT
-- =========================
CREATE TABLE sprint (
    id INT AUTO_INCREMENT PRIMARY KEY,
    projeto_id INT,
    nome VARCHAR(100),
    data_inicio TIMESTAMP,
    data_fim TIMESTAMP,
    status ENUM('Planejada', 'Em andamento', 'Finalizada') DEFAULT 'Planejada',

    FOREIGN KEY (projeto_id) REFERENCES projeto(id)
);

-- =========================
-- CRONOGRAMA
-- =========================
CREATE TABLE cronograma (
    id INT AUTO_INCREMENT PRIMARY KEY,
    projeto_id INT,
    data_inicio TIMESTAMP,
    data_fim TIMESTAMP,

    FOREIGN KEY (projeto_id) REFERENCES projeto(id)
);

-- =========================
-- STATUS
-- =========================
CREATE TABLE status_tarefa (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL
);

INSERT INTO status_tarefa (nome) VALUES 
('To Do'), ('In Progress'), ('Done');

-- =========================
-- PRIORIDADE
-- =========================
CREATE TABLE prioridade (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50)
);

INSERT INTO prioridade (nome) VALUES 
('Baixa'), ('Média'), ('Alta');

-- =========================
-- TAREFA
-- =========================
CREATE TABLE tarefa (
    id INT AUTO_INCREMENT PRIMARY KEY,
    projeto_id INT,
    cronograma_id INT,
    sprint_id INT,

    criado_por INT,
    atribuido_para INT,

    nome VARCHAR(255) NOT NULL,
    descricao TEXT,

    prazo TIMESTAMP,
    story_points INT,

    status_id INT,
    prioridade_id INT,

    is_subtarefa BOOLEAN DEFAULT FALSE,
    tarefa_pai_id INT NULL,

    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_conclusao TIMESTAMP NULL,

    FOREIGN KEY (projeto_id) REFERENCES projeto(id),
    FOREIGN KEY (cronograma_id) REFERENCES cronograma(id),
    FOREIGN KEY (sprint_id) REFERENCES sprint(id),
    FOREIGN KEY (criado_por) REFERENCES usuario(id),
    FOREIGN KEY (atribuido_para) REFERENCES usuario(id),
    FOREIGN KEY (status_id) REFERENCES status_tarefa(id),
    FOREIGN KEY (prioridade_id) REFERENCES prioridade(id),
    FOREIGN KEY (tarefa_pai_id) REFERENCES tarefa(id)
);

-- =========================
-- TAG
-- =========================
CREATE TABLE tag (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

-- =========================
-- TAREFA_TAG (N:N)
-- =========================
CREATE TABLE tarefa_tag (
    tarefa_id INT,
    tag_id INT,
    PRIMARY KEY (tarefa_id, tag_id),

    FOREIGN KEY (tarefa_id) REFERENCES tarefa(id),
    FOREIGN KEY (tag_id) REFERENCES tag(id)
);

-- =========================
-- ANEXOS
-- =========================
CREATE TABLE anexo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tarefa_id INT,
    nome_arquivo VARCHAR(255),
    caminho_arquivo TEXT,
    data_upload TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (tarefa_id) REFERENCES tarefa(id)
);

-- =========================
-- COMENTARIOS
-- =========================
CREATE TABLE comentario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tarefa_id INT,
    usuario_id INT,
    conteudo TEXT,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (tarefa_id) REFERENCES tarefa(id),
    FOREIGN KEY (usuario_id) REFERENCES usuario(id)
);

-- =========================
-- HISTORICO (AUDIT LOG)
-- =========================
CREATE TABLE historico_tarefa (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tarefa_id INT,
    usuario_id INT,
    campo_alterado VARCHAR(100),
    valor_antigo TEXT,
    valor_novo TEXT,
    data_alteracao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (tarefa_id) REFERENCES tarefa(id),
    FOREIGN KEY (usuario_id) REFERENCES usuario(id)
);

-- =========================
-- ORGANIZAÇÃO
-- =========================
INSERT INTO organizacao (nome_fantasia, cnpj, email_contato) VALUES
('TechNova Soluções', '12.345.678/0001-90', 'contato@technova.com.br'),
('Inova Digital', '23.456.789/0001-01', 'contato@inovadigital.com.br'),
('BlueSoft Tecnologia', '34.567.890/0001-12', 'contato@bluesoft.com.br');

-- =========================
-- USUÁRIO
-- perfil_id:
-- 1 = Admin
-- 2 = Colaborador
-- =========================
INSERT INTO usuario 
(nome, email, is_ativo, perfil_id, cargo, data_desativacao, organizacao_id) 
VALUES
-- TechNova Soluções
('Ana Carolina Souza', 'ana.souza@email.com', TRUE, 1, 'Gerente de Projetos', NULL, 1),
('Bruno Henrique Lima', 'bruno.lima@email.com', TRUE, 2, 'Desenvolvedor Backend', NULL, 1),
('Camila Oliveira Santos', 'camila.santos@email.com', TRUE, 2, 'Desenvolvedora Frontend', NULL, 1),
('Daniel Martins', 'daniel.martins@email.com', TRUE, 2, 'QA Engineer', NULL, 1),

-- Inova Digital
('Eduardo Ferreira', 'eduardo.ferreira@email.com', TRUE, 1, 'Tech Lead', NULL, 2),
('Fernanda Alves', 'fernanda.alves@email.com', TRUE, 2, 'UX/UI Designer', NULL, 2),
('Gabriel Rocha', 'gabriel.rocha@email.com', TRUE, 2, 'Desenvolvedor Full Stack', NULL, 2),

-- BlueSoft Tecnologia
('Helena Costa', 'helena.costa@email.com', FALSE, 2, 'Analista de Negócios', '2026-08-15 10:30:00', 3);

-- =========================
-- CLIENTE
-- =========================

INSERT INTO cliente 
(nome, email_contato, telefone, is_ativo, data_desativacao) 
VALUES
('Empresa Alpha Tecnologia', 'contato@alpha.com.br', '(11) 99999-1111', TRUE, NULL),
('Mercado Fácil', 'contato@mercadofacil.com.br', '(11) 98888-2222', TRUE, NULL),
('StartUp Solutions', 'contato@startupsolutions.com.br', '(11) 97777-3333', TRUE, NULL),
('Grupo Financeiro Brasil', 'contato@gfb.com.br', '(11) 96666-4444', FALSE, '2026-07-20 15:00:00');


-- =========================
-- PROJETO
-- =========================
INSERT INTO projeto
(
    cliente_id,
    nome,
    descricao,
    data_inicio,
    data_fim,
    cor,
    risco
)
VALUES
(
    1,
    'Portal Corporativo',
    'Desenvolvimento de um novo portal corporativo para gerenciamento de clientes.',
    '2026-07-01 09:00:00',
    '2026-08-20 18:00:00',
    '#FF5733',
    NULL
),
(
    1,
    'Aplicativo Mobile',
    'Aplicativo mobile para acompanhamento de pedidos e notificações.',
    '2026-07-15 09:00:00',
    '2026-08-30 18:00:00',
    '#3498DB',
    NULL
),
(
    2,
    'E-commerce Mercado Fácil',
    'Desenvolvimento da plataforma de vendas online.',
    '2026-06-10 09:00:00',
    '2026-07-30 18:00:00',
    '#2ECC71',
    NULL
),
(
    3,
    'Sistema de Gestão',
    'Sistema interno para gerenciamento de tarefas e equipes.',
    '2026-08-01 09:00:00',
    '2026-09-15 18:00:00',
    '#9B59B6',
    NULL
);

-- =========================
-- PROJETO_USUARIO
-- =========================

INSERT INTO projeto_usuario 
(projeto_id, usuario_id, papel) 
VALUES
-- Portal Corporativo
(1, 1, 'Admin'),
(1, 2, 'Colaborador'),
(1, 3, 'Colaborador'),
(1, 4, 'Colaborador'),

-- Aplicativo Mobile
(2, 5, 'Admin'),
(2, 6, 'Colaborador'),
(2, 7, 'Colaborador'),
(2, 4, 'Colaborador'),

-- E-commerce
(3, 1, 'Admin'),
(3, 2, 'Colaborador'),
(3, 7, 'Colaborador'),
(3, 6, 'Colaborador'),

-- Sistema de Gestão
(4, 5, 'Admin'),
(4, 3, 'Colaborador'),
(4, 4, 'Colaborador'),
(4, 7, 'Colaborador');


-- =========================
-- SPRINT
-- =========================

INSERT INTO sprint 
(projeto_id, nome, data_inicio, data_fim, status) 
VALUES
(1, 'Sprint 01 - Estrutura', '2026-07-01 09:00:00', '2026-07-14 18:00:00', 'Finalizada'),
(1, 'Sprint 02 - Funcionalidades', '2026-07-15 09:00:00', '2026-07-28 18:00:00', 'Finalizada'),
(1, 'Sprint 03 - Melhorias', '2026-07-29 09:00:00', '2026-08-12 18:00:00', 'Em andamento'),

(2, 'Sprint 01 - Mobile', '2026-07-15 09:00:00', '2026-07-29 18:00:00', 'Finalizada'),
(2, 'Sprint 02 - Integração', '2026-07-30 09:00:00', '2026-08-13 18:00:00', 'Em andamento'),

(3, 'Sprint 01 - E-commerce', '2026-06-10 09:00:00', '2026-06-24 18:00:00', 'Finalizada'),
(3, 'Sprint 02 - Checkout', '2026-06-25 09:00:00', '2026-07-09 18:00:00', 'Finalizada'),
(3, 'Sprint 03 - Pagamento', '2026-07-10 09:00:00', '2026-07-24 18:00:00', 'Finalizada'),

(4, 'Sprint 01 - MVP', '2026-08-01 09:00:00', '2026-08-15 18:00:00', 'Finalizada'),
(4, 'Sprint 02 - Relatórios', '2026-08-16 09:00:00', '2026-08-30 18:00:00', 'Em andamento');


-- =========================
-- CRONOGRAMA
-- =========================

INSERT INTO cronograma 
(projeto_id, data_inicio, data_fim) 
VALUES
(1, '2026-07-01 09:00:00', '2026-08-20 18:00:00'),
(2, '2026-07-15 09:00:00', '2026-08-30 18:00:00'),
(3, '2026-06-10 09:00:00', '2026-07-30 18:00:00'),
(4, '2026-08-01 09:00:00', '2026-09-15 18:00:00');


-- =========================
-- TAG
-- =========================

INSERT INTO tag (nome) VALUES
('Backend'),
('Frontend'),
('Bug'),
('Melhoria'),
('Urgente'),
('Documentação'),
('Banco de Dados'),
('API'),
('Design'),
('Testes');


-- =========================
-- TAREFAS
-- status_id:
-- 1 = To Do
-- 2 = In Progress
-- 3 = Done
--
-- prioridade_id:
-- 1 = Baixa
-- 2 = Média
-- 3 = Alta
-- =========================

INSERT INTO tarefa
(
    projeto_id,
    cronograma_id,
    sprint_id,
    criado_por,
    atribuido_para,
    nome,
    descricao,
    prazo,
    story_points,
    status_id,
    prioridade_id,
    is_subtarefa,
    tarefa_pai_id,
    data_conclusao
)
VALUES

-- ==========================================
-- PROJETO 1 - PORTAL CORPORATIVO
-- ==========================================

(
    1, 1, 3,
    1, 2,
    'Criar API de autenticação',
    'Implementar autenticação utilizando JWT.',
    '2026-08-10 18:00:00',
    8,
    3, 3,
    FALSE, NULL,
    '2026-08-09 16:30:00'
),

(
    1, 1, 3,
    1, 3,
    'Criar tela de login',
    'Desenvolver interface de login do portal.',
    '2026-08-11 18:00:00',
    5,
    3, 2,
    FALSE, NULL,
    '2026-08-10 14:20:00'
),

(
    1, 1, 3,
    1, 4,
    'Testar autenticação',
    'Criar testes funcionais para o fluxo de login.',
    '2026-08-12 18:00:00',
    3,
    2, 2,
    FALSE, NULL,
    NULL
),

(
    1, 2, 3,
    2, 2,
    'Corrigir validação de senha',
    'Corrigir regra de validação da senha no backend.',
    '2026-08-15 18:00:00',
    3,
    1, 3,
    FALSE, NULL,
    NULL
),

(
    1, 2, 3,
    1, 3,
    'Atualizar documentação da API',
    'Documentar endpoints utilizando Swagger.',
    '2026-08-18 18:00:00',
    2,
    1, 1,
    FALSE, NULL,
    NULL
),


-- ==========================================
-- PROJETO 2 - APLICATIVO MOBILE
-- ==========================================

(
    2, 2, 5,
    5, 7,
    'Implementar notificações push',
    'Criar serviço responsável pelo envio de notificações.',
    '2026-08-12 18:00:00',
    8,
    2, 3,
    FALSE, NULL,
    NULL
),

(
    2, 2, 5,
    5, 6,
    'Criar tela de pedidos',
    'Criar tela para visualização dos pedidos do cliente.',
    '2026-08-15 18:00:00',
    5,
    2, 2,
    FALSE, NULL,
    NULL
),

(
    2, 2, 5,
    5, 4,
    'Testar fluxo de pedidos',
    'Realizar testes no fluxo completo de pedidos.',
    '2026-08-18 18:00:00',
    3,
    1, 2,
    FALSE, NULL,
    NULL
),


-- ==========================================
-- PROJETO 3 - E-COMMERCE
-- ==========================================

(
    3, 3, 8,
    1, 2,
    'Criar integração com gateway',
    'Integrar sistema com gateway de pagamento.',
    '2026-07-20 18:00:00',
    8,
    3, 3,
    FALSE, NULL,
    '2026-07-19 17:00:00'
),

(
    3, 3, 8,
    1, 7,
    'Implementar checkout',
    'Desenvolver fluxo completo de checkout.',
    '2026-07-22 18:00:00',
    13,
    3, 3,
    FALSE, NULL,
    '2026-07-21 15:00:00'
),

(
    3, 3, 8,
    1, 6,
    'Melhorar layout do checkout',
    'Ajustar experiência visual da página de checkout.',
    '2026-07-25 18:00:00',
    5,
    3, 2,
    FALSE, NULL,
    '2026-07-24 13:00:00'
),

(
    3, 3, 8,
    2, 4,
    'Testar pagamento',
    'Validar pagamentos aprovados, recusados e expirados.',
    '2026-07-27 18:00:00',
    5,
    2, 3,
    FALSE, NULL,
    NULL
),


-- ==========================================
-- PROJETO 4 - SISTEMA DE GESTÃO
-- ==========================================

(
    4, 4, 10,
    5, 3,
    'Criar dashboard',
    'Criar dashboard principal do sistema.',
    '2026-08-25 18:00:00',
    8,
    2, 2,
    FALSE, NULL,
    NULL
),

(
    4, 4, 10,
    5, 7,
    'Criar endpoint de relatórios',
    'Criar endpoint REST para consulta de relatórios.',
    '2026-08-27 18:00:00',
    5,
    2, 3,
    FALSE, NULL,
    NULL
),

(
    4, 4, 10,
    5, 4,
    'Validar relatórios',
    'Validar os dados apresentados nos relatórios.',
    '2026-08-29 18:00:00',
    3,
    1, 2,
    FALSE, NULL,
    NULL
);


-- =========================
-- SUBTAREFAS
-- =========================

INSERT INTO tarefa
(
    projeto_id,
    cronograma_id,
    sprint_id,
    criado_por,
    atribuido_para,
    nome,
    descricao,
    prazo,
    story_points,
    status_id,
    prioridade_id,
    is_subtarefa,
    tarefa_pai_id,
    data_conclusao
)
VALUES

(
    1, 1, 3,
    2, 2,
    'Criar entidade de usuário',
    'Criar entidade User no backend.',
    '2026-08-05 18:00:00',
    2,
    3, 2,
    TRUE, 1,
    '2026-08-04 16:00:00'
),

(
    1, 1, 3,
    2, 2,
    'Criar JWT Service',
    'Implementar serviço responsável pela criação dos tokens.',
    '2026-08-07 18:00:00',
    3,
    3, 3,
    TRUE, 1,
    '2026-08-07 17:30:00'
),

(
    1, 1, 3,
    1, 3,
    'Criar formulário de login',
    'Criar formulário com email e senha.',
    '2026-08-08 18:00:00',
    2,
    3, 2,
    TRUE, 2,
    '2026-08-08 14:00:00'
);


-- =========================
-- TAREFA_TAG
-- =========================

INSERT INTO tarefa_tag (tarefa_id, tag_id) VALUES
(1, 1),
(1, 8),
(2, 2),
(2, 9),
(3, 10),
(4, 1),
(4, 3),
(5, 6),
(6, 1),
(6, 8),
(7, 2),
(8, 10),
(9, 1),
(9, 8),
(10, 2),
(11, 9),
(12, 10),
(13, 2),
(14, 1),
(14, 8),
(15, 10);


-- =========================
-- ANEXOS
-- =========================

INSERT INTO anexo
(tarefa_id, nome_arquivo, caminho_arquivo)
VALUES
(1, 'arquitetura-auth.png', '/uploads/tarefas/1/arquitetura-auth.png'),
(1, 'jwt-config.json', '/uploads/tarefas/1/jwt-config.json'),
(2, 'tela-login.png', '/uploads/tarefas/2/tela-login.png'),
(5, 'swagger-api.pdf', '/uploads/tarefas/5/swagger-api.pdf'),
(6, 'push-notification.pdf', '/uploads/tarefas/6/push-notification.pdf'),
(10, 'checkout-layout.png', '/uploads/tarefas/10/checkout-layout.png'),
(14, 'dashboard-wireframe.png', '/uploads/tarefas/14/dashboard-wireframe.png');


-- =========================
-- COMENTÁRIOS
-- =========================

INSERT INTO comentario
(tarefa_id, usuario_id, conteudo)
VALUES
(1, 2, 'A autenticação JWT foi implementada. Falta apenas finalizar os testes.'),
(1, 1, 'Ótimo. Precisamos validar também o tempo de expiração do token.'),
(2, 3, 'A tela de login já está pronta para revisão.'),
(3, 4, 'Encontrei um problema na validação de senha com caracteres especiais.'),
(4, 2, 'A regra foi ajustada e enviada para homologação.'),
(6, 7, 'A integração com o serviço de notificações está em andamento.'),
(7, 6, 'A tela está pronta, aguardando integração com a API.'),
(9, 2, 'Gateway integrado com sucesso em ambiente de homologação.'),
(10, 7, 'Checkout finalizado. Precisamos apenas validar alguns cenários.'),
(11, 6, 'Realizei os ajustes de responsividade.'),
(12, 4, 'Os testes encontraram um erro no pagamento recusado.'),
(14, 3, 'Dashboard em desenvolvimento.'),
(15, 7, 'Endpoint já está disponível para testes.');


-- =========================
-- HISTÓRICO DE TAREFAS
-- =========================

INSERT INTO historico_tarefa
(
    tarefa_id,
    usuario_id,
    campo_alterado,
    valor_antigo,
    valor_novo
)
VALUES

(1, 2, 'status_id', '2', '3'),
(1, 2, 'prioridade_id', '2', '3'),

(2, 3, 'status_id', '2', '3'),

(3, 4, 'status_id', '1', '2'),

(4, 2, 'status_id', '3', '1'),

(6, 7, 'status_id', '1', '2'),

(7, 6, 'status_id', '1', '2'),

(9, 2, 'status_id', '2', '3'),
(9, 2, 'prioridade_id', '2', '3'),

(10, 7, 'status_id', '2', '3'),

(11, 6, 'status_id', '2', '3'),

(12, 4, 'status_id', '1', '2'),

(14, 3, 'status_id', '1', '2'),

(15, 7, 'status_id', '1', '2');

INSERT INTO projeto_usuario
(projeto_id, usuario_id, papel)
VALUES
-- Portal Corporativo
(1, 1, 'Admin'),
(1, 2, 'Colaborador'),
(1, 3, 'Colaborador'),
(1, 4, 'Colaborador'),

-- Aplicativo Mobile
(2, 5, 'Admin'),
(2, 6, 'Colaborador'),
(2, 7, 'Colaborador'),
(2, 4, 'Colaborador'),

-- E-commerce Mercado Fácil
(3, 1, 'Admin'),
(3, 2, 'Colaborador'),
(3, 7, 'Colaborador'),
(3, 6, 'Colaborador'),

-- Sistema de Gestão
(4, 5, 'Admin'),
(4, 3, 'Colaborador'),
(4, 4, 'Colaborador'),
(4, 7, 'Colaborador');



-----------

USE task_manager;

select * from usuario;
select * from projeto;
select * from sprint;
select * from tarefa;

update projeto set progresso = 50 where id = 1;
update sprint set progress = 50 where id = 11;

DESCRIBE sprint;
DESCRIBE tarefa;