CREATE SCHEMA IF NOT EXISTS dw_gold;

-- Dimensão Data
DROP TABLE IF EXISTS dw_gold.dim_data CASCADE;
CREATE TABLE dw_gold.dim_data (
    suk_data INT PRIMARY KEY,
    ide_data INT,
    data_completa DATE,
    val_ano INT,
    val_mes INT,
    val_dia_mes INT,
    dec_dia_semana VARCHAR(20),
    flag_fim_de_semana CHAR(1)
);

-- Dimensão Tempo (Hora)
DROP TABLE IF EXISTS dw_gold.dim_tempo CASCADE;
CREATE TABLE dw_gold.dim_tempo (
    suk_tempo INT PRIMARY KEY,
    ide_tempo INT,
    hora_completa VARCHAR(5),
    val_hora_dia INT,
    dec_periodo_dia VARCHAR(20)
);

-- Dimensão Severidade
DROP TABLE IF EXISTS dw_gold.dim_severidade CASCADE;
CREATE TABLE dw_gold.dim_severidade (
    suk_severidade INT PRIMARY KEY,
    ide_severidade INT,
    dec_severidade VARCHAR(50)
);

-- Dimensão Clima
DROP TABLE IF EXISTS dw_gold.dim_clima CASCADE;
CREATE TABLE dw_gold.dim_clima (
    suk_clima INT PRIMARY KEY,
    ide_clima INT,
    dec_clima VARCHAR(100)
);

-- Dimensão Condição da Pista
DROP TABLE IF EXISTS dw_gold.dim_pista CASCADE;
CREATE TABLE dw_gold.dim_pista (
    suk_pista INT PRIMARY KEY,
    ide_pista INT,
    dec_pista VARCHAR(100)
);

-- Dimensão Condição de Luz
DROP TABLE IF EXISTS dw_gold.dim_luz CASCADE;
CREATE TABLE dw_gold.dim_luz (
    suk_luz INT PRIMARY KEY,
    ide_luz INT,
    dec_luz VARCHAR(100)
);

-- Dimensão Área
DROP TABLE IF EXISTS dw_gold.dim_urbano CASCADE;
CREATE TABLE dw_gold.dim_urbano (
    suk_urbano INT PRIMARY KEY,
    ide_urbano INT,
    dec_urbano VARCHAR(50)
);

-- Dimensão Tipo de Via
DROP TABLE IF EXISTS dw_gold.dim_tipo_via CASCADE;
CREATE TABLE dw_gold.dim_tipo_via (
    suk_tipo_via INT PRIMARY KEY,
    ide_tipo_via INT,
    dec_tipo_via VARCHAR(100)
);

-- Dimensão Detalhe do Cruzamento
DROP TABLE IF EXISTS dw_gold.dim_cruzamento CASCADE;
CREATE TABLE dw_gold.dim_cruzamento (
    suk_cruzamento INT PRIMARY KEY,
    ide_cruzamento INT,
    dec_cruzamento VARCHAR(100)
);

-- Dimensão Controle do Cruzamento
DROP TABLE IF EXISTS dw_gold.dim_controle_cruz CASCADE;
CREATE TABLE dw_gold.dim_controle_cruz (
    suk_controle_cruz INT PRIMARY KEY,
    ide_controle_cruz INT,
    dec_controle_cruz VARCHAR(100)
);

-- Dimensão Física Pedestre
DROP TABLE IF EXISTS dw_gold.dim_ped_fisico CASCADE;
CREATE TABLE dw_gold.dim_ped_fisico (
    suk_ped_fisico INT PRIMARY KEY,
    ide_ped_fisico INT,
    dec_ped_fisico VARCHAR(150)
);

-- Dimensão Condições Especiais
DROP TABLE IF EXISTS dw_gold.dim_cod_esp CASCADE;
CREATE TABLE dw_gold.dim_cod_esp (
    suk_cod_esp INT PRIMARY KEY,
    ide_cod_esp INT,
    dec_cod_esp VARCHAR(150)
);

-- Dimensão Perigos na Pista
DROP TABLE IF EXISTS dw_gold.dim_perigos CASCADE;
CREATE TABLE dw_gold.dim_perigos (
    suk_perigos INT PRIMARY KEY,
    ide_perigos INT,
    dec_perigos VARCHAR(150)
);

-- Dimensão Tipo de Veículo
DROP TABLE IF EXISTS dw_gold.dim_tipo_veiculo CASCADE;
CREATE TABLE dw_gold.dim_tipo_veiculo (
    suk_tipo_veiculo INT PRIMARY KEY,
    ide_tipo_veiculo INT,
    dec_tipo_veiculo VARCHAR(100)
);

-- Dimensão Manobra do Veículo
DROP TABLE IF EXISTS dw_gold.dim_manobra CASCADE;
CREATE TABLE dw_gold.dim_manobra (
    suk_manobra INT PRIMARY KEY,
    ide_manobra INT,
    dec_manobra VARCHAR(100)
);

-- Dimensão Localização do Veículo
DROP TABLE IF EXISTS dw_gold.dim_local_veic CASCADE;
CREATE TABLE dw_gold.dim_local_veic (
    suk_local_veic INT PRIMARY KEY,
    ide_local_veic INT,
    dec_local_veic VARCHAR(150)
);

-- Dimensão Propulsão
DROP TABLE IF EXISTS dw_gold.dim_propulsao CASCADE;
CREATE TABLE dw_gold.dim_propulsao (
    suk_propulsao INT PRIMARY KEY,
    ide_propulsao INT,
    dec_propulsao VARCHAR(50)
);

-- Dimensão Volante
DROP TABLE IF EXISTS dw_gold.dim_volante CASCADE;
CREATE TABLE dw_gold.dim_volante (
    suk_volante INT PRIMARY KEY,
    ide_volante INT,
    dec_volante VARCHAR(50)
);

-- Dimensão Sexo
DROP TABLE IF EXISTS dw_gold.dim_sexo CASCADE;
CREATE TABLE dw_gold.dim_sexo (
    suk_sexo INT PRIMARY KEY,
    ide_sexo INT,
    dec_sexo VARCHAR(50)
);

-- Dimensão Faixa Etária
DROP TABLE IF EXISTS dw_gold.dim_faixa_etaria CASCADE;
CREATE TABLE dw_gold.dim_faixa_etaria (
    suk_faixa_etaria INT PRIMARY KEY,
    ide_faixa_etaria INT,
    dec_faixa_etaria VARCHAR(50)
);

-- Dimensão Classe da Vítima
DROP TABLE IF EXISTS dw_gold.dim_classe_vit CASCADE;
CREATE TABLE dw_gold.dim_classe_vit (
    suk_classe_vit INT PRIMARY KEY,
    ide_classe_vit INT,
    dec_classe_vit VARCHAR(50)
);

-- Dimensão Tipo de Vítima
DROP TABLE IF EXISTS dw_gold.dim_tipo_vit CASCADE;
CREATE TABLE dw_gold.dim_tipo_vit (
    suk_tipo_vit INT PRIMARY KEY,
    ide_tipo_vit INT,
    dec_tipo_vit VARCHAR(100)
);

-- Dimensão Movimento do Pedestre
DROP TABLE IF EXISTS dw_gold.dim_mov_ped CASCADE;
CREATE TABLE dw_gold.dim_mov_ped (
    suk_mov_ped INT PRIMARY KEY,
    ide_mov_ped INT,
    dec_mov_ped VARCHAR(150)
);

-- Dimensão Passageiro Carro
DROP TABLE IF EXISTS dw_gold.dim_pass_carro CASCADE;
CREATE TABLE dw_gold.dim_pass_carro (
    suk_pass_carro INT PRIMARY KEY,
    ide_pass_carro INT,
    dec_pass_carro VARCHAR(100)
);

-- Dimensão Passageiro Ônibus
DROP TABLE IF EXISTS dw_gold.dim_pass_bus CASCADE;
CREATE TABLE dw_gold.dim_pass_bus (
    suk_pass_bus INT PRIMARY KEY,
    ide_pass_bus INT,
    dec_pass_bus VARCHAR(100)
);


--- FATO 1: ACIDENTE
DROP TABLE IF EXISTS dw_gold.fat_acidente CASCADE;
CREATE TABLE dw_gold.fat_acidente (
    -- Chave Primária
    ide_acidente VARCHAR(13) PRIMARY KEY,
    
    -- Métricas (Valores)
    val_qtd_veiculos INT,
    val_qtd_vitimas INT,
    val_longitude DOUBLE PRECISION,
    val_latitude DOUBLE PRECISION,
    val_limite_velocidade INT,
    
    -- Chaves Estrangeiras (FKs)
    fok_data INT REFERENCES dw_gold.dim_data(suk_data),
    fok_tempo INT REFERENCES dw_gold.dim_tempo(suk_tempo),
    fok_severidade INT REFERENCES dw_gold.dim_severidade(suk_severidade),
    fok_urbano INT REFERENCES dw_gold.dim_urbano(suk_urbano),
    fok_clima INT REFERENCES dw_gold.dim_clima(suk_clima),
    fok_pista INT REFERENCES dw_gold.dim_pista(suk_pista),
    fok_luz INT REFERENCES dw_gold.dim_luz(suk_luz),
    fok_tipo_via INT REFERENCES dw_gold.dim_tipo_via(suk_tipo_via),
    fok_cruzamento INT REFERENCES dw_gold.dim_cruzamento(suk_cruzamento),
    fok_controle_cruz INT REFERENCES dw_gold.dim_controle_cruz(suk_controle_cruz),
    fok_ped_fisico INT REFERENCES dw_gold.dim_ped_fisico(suk_ped_fisico),
    fok_cod_esp INT REFERENCES dw_gold.dim_cod_esp(suk_cod_esp),
    fok_perigos INT REFERENCES dw_gold.dim_perigos(suk_perigos)
);

-- FATO 2: VEÍCULO
DROP TABLE IF EXISTS dw_gold.fat_veiculo CASCADE;
CREATE TABLE dw_gold.fat_veiculo (
    ide_acidente VARCHAR(13),
    ide_veiculo INT, 
    val_idade_motorista INT,
    val_idade_veiculo INT,   
    fok_tipo_veiculo INT REFERENCES dw_gold.dim_tipo_veiculo(suk_tipo_veiculo),
    fok_manobra INT REFERENCES dw_gold.dim_manobra(suk_manobra),
    fok_local_veic INT REFERENCES dw_gold.dim_local_veic(suk_local_veic),
    fok_propulsao INT REFERENCES dw_gold.dim_propulsao(suk_propulsao),
    fok_volante INT REFERENCES dw_gold.dim_volante(suk_volante),
    fok_sexo_motorista INT REFERENCES dw_gold.dim_sexo(suk_sexo),
    fok_faixa_etaria_mot INT REFERENCES dw_gold.dim_faixa_etaria(suk_faixa_etaria),
    
    PRIMARY KEY (ide_acidente, ide_veiculo)
);

-- FATO 3: VÍTIMA
DROP TABLE IF EXISTS dw_gold.fat_vitima CASCADE;
CREATE TABLE dw_gold.fat_vitima (
    ide_acidente VARCHAR(13),
    ide_veiculo INT,
    ide_vitima INT,
    val_idade_vitima INT,
    fok_classe_vitima INT REFERENCES dw_gold.dim_classe_vit(suk_classe_vit),
    fok_tipo_vitima INT REFERENCES dw_gold.dim_tipo_vit(suk_tipo_vit),
    fok_severidade_vitima INT REFERENCES dw_gold.dim_severidade(suk_severidade),
    fok_sexo_vitima INT REFERENCES dw_gold.dim_sexo(suk_sexo),
    fok_faixa_etaria_vit INT REFERENCES dw_gold.dim_faixa_etaria(suk_faixa_etaria),
    fok_mov_pedestre INT REFERENCES dw_gold.dim_mov_ped(suk_mov_ped),
    fok_pass_carro INT REFERENCES dw_gold.dim_pass_carro(suk_pass_carro),
    fok_pass_bus INT REFERENCES dw_gold.dim_pass_bus(suk_pass_bus),
    
    PRIMARY KEY (ide_acidente, ide_veiculo, ide_vitima)
);