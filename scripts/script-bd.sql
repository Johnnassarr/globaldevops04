-- =============================================================================
-- Script de Criação do Banco de Dados - EcoTask
-- =============================================================================
-- Este script consolida todas as migrações do Flyway
-- RM: 556221
-- =============================================================================

-- -----------------------------------------------------------------------------
-- TABELA: usuario
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS usuario (
    id SERIAL PRIMARY KEY,
    username VARCHAR(30) NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR NOT NULL,
    role TEXT NOT NULL
);

-- -----------------------------------------------------------------------------
-- TABELA: categoria_sustentabilidade
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS categoria_sustentabilidade (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    descricao TEXT,
    nivel_impacto VARCHAR(50)
);

-- -----------------------------------------------------------------------------
-- TABELA: missao_sustentavel
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS missao_sustentavel (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    descricao TEXT NOT NULL,
    data_inicio DATE NOT NULL,
    data_fim DATE NOT NULL,
    ativa BOOLEAN DEFAULT TRUE
);

-- -----------------------------------------------------------------------------
-- TABELA: tarefa
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tarefa (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    descricao TEXT NOT NULL,
    completado BOOLEAN DEFAULT FALSE,
    data_criacao DATE NOT NULL,
    points INT DEFAULT 10 CHECK (points >= 0),

    missao_id BIGINT,
    categoria_id BIGINT,
    usuario_id BIGINT,

    CONSTRAINT fk_tarefa_missao
        FOREIGN KEY (missao_id)
        REFERENCES missao_sustentavel (id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,

    CONSTRAINT fk_tarefa_categoria
        FOREIGN KEY (categoria_id)
        REFERENCES categoria_sustentabilidade (id)
        ON DELETE SET NULL
        ON UPDATE CASCADE,

    CONSTRAINT fk_tarefa_usuario
        FOREIGN KEY (usuario_id)
        REFERENCES usuario (id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- -----------------------------------------------------------------------------
-- TABELA: recompensa
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS recompensa (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    descricao TEXT NOT NULL,
    pontos_requiridos INT NOT NULL DEFAULT 10,
    ativado BOOLEAN DEFAULT TRUE
);

-- =============================================================================
-- DADOS INICIAIS
-- =============================================================================

-- Usuários iniciais
INSERT INTO usuario (username, email, password, role) VALUES
('admin', 'admin@tarefasustentavel.com', '123456', 'ADMIN'),
('felipe', 'felipe@tarefasustentavel.com', '123456', 'USER')
ON CONFLICT (email) DO NOTHING;

-- Categorias de Sustentabilidade
INSERT INTO categoria_sustentabilidade (nome, descricao, nivel_impacto) VALUES
('Reciclagem', 'Categoria voltada à separação e reaproveitamento de materiais recicláveis.', 'ALTO'),
('Economia de Energia', 'Incentivo a práticas que reduzem o consumo elétrico no ambiente de trabalho.', 'MEDIO'),
('Consumo Consciente', 'Promoção de hábitos de compra sustentáveis e redução de desperdício.', 'BAIXO')
ON CONFLICT DO NOTHING;

-- Missões Sustentáveis
INSERT INTO missao_sustentavel (nome, descricao, data_inicio, data_fim, ativa) VALUES
('Missão Verde Semanal', 'Complete tarefas de reciclagem e consumo consciente durante a semana.', CURRENT_DATE, CURRENT_DATE + INTERVAL '7 days', TRUE),
('Energia Limpa', 'Desafie-se a reduzir o consumo de energia elétrica no ambiente doméstico.', CURRENT_DATE, CURRENT_DATE + INTERVAL '10 days', TRUE),
('Consumo Inteligente', 'Adote hábitos mais sustentáveis e evite desperdícios no dia a dia.', CURRENT_DATE, CURRENT_DATE + INTERVAL '5 days', TRUE)
ON CONFLICT DO NOTHING;

-- Tarefas sustentáveis (ligadas às missões e categorias)
INSERT INTO tarefa (titulo, descricao, completado, data_criacao, points, categoria_id, usuario_id, missao_id)
VALUES
('Separar o lixo reciclável', 'Organize os resíduos recicláveis corretamente.', FALSE, CURRENT_DATE, 10, 1, 2, 1),
('Desligar luzes ao sair', 'Apague as luzes e aparelhos quando não estiverem em uso.', TRUE, CURRENT_DATE, 15, 2, 2, 2),
('Usar caneca reutilizável', 'Evite copos descartáveis e use uma caneca própria.', FALSE, CURRENT_DATE, 5, 3, 2, 3),
('Iniciar coleta seletiva', 'Monte um sistema de separação de lixo em casa ou no trabalho.', FALSE, CURRENT_DATE, 12, 1, 2, 1),
('Evitar uso de ar-condicionado', 'Tente usar ventilação natural quando possível.', FALSE, CURRENT_DATE, 20, 2, 2, 2)
ON CONFLICT DO NOTHING;

-- Recompensas
INSERT INTO recompensa (nome, descricao, pontos_requiridos, ativado) VALUES
('Certificado Verde', 'Reconhecimento simbólico por práticas sustentáveis consistentes.', 50, TRUE),
('Dia de Folga Sustentável', 'Um dia de descanso adicional por participação contínua em tarefas sustentáveis.', 100, TRUE),
('Guerreiro Eco', 'Complete 15 tarefas sustentáveis na semana.', 150, TRUE),
('Guardião da Natureza', 'Conclua todas as missões mensais com sucesso.', 200, TRUE)
ON CONFLICT DO NOTHING;

-- =============================================================================
-- FIM DO SCRIPT
-- =============================================================================

