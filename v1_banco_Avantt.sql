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