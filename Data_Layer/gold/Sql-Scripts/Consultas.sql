-- Consulta: Análise de Acidentes por Área Urbana vs Rural
SELECT 
    u.dec_urbano AS "Area",
    COUNT(f.ide_acidente) AS "Total de Acidentes",
    SUM(CASE WHEN s.dec_severidade = 'Fatal' THEN 1 ELSE 0 END) AS "Qtd Fatais",
    SUM(CASE WHEN s.dec_severidade = 'Sério' THEN 1 ELSE 0 END) AS "Qtd Serios",
    SUM(CASE WHEN s.dec_severidade = 'Leve'  THEN 1 ELSE 0 END) AS "Qtd Leves",
    ROUND((SUM(CASE WHEN s.dec_severidade = 'Fatal' THEN 1.0 ELSE 0 END) / COUNT(f.ide_acidente)) * 100, 2) AS "Pct Fatal",
    ROUND((SUM(CASE WHEN s.dec_severidade = 'Sério' THEN 1.0 ELSE 0 END) / COUNT(f.ide_acidente)) * 100, 2) AS "Pct Serio",
    ROUND((SUM(CASE WHEN s.dec_severidade = 'Leve'  THEN 1.0 ELSE 0 END) / COUNT(f.ide_acidente)) * 100, 2) AS "Pct Leve"
FROM dw_gold.fat_acidente f
    JOIN dw_gold.dim_urbano u ON f.fok_urbano = u.suk_urbano
    JOIN dw_gold.dim_severidade s ON f.fok_severidade = s.suk_severidade
WHERE u.dec_urbano IN ('Urbano', 'Rural') 
GROUP BY u.dec_urbano
ORDER BY "Pct Fatal" DESC;

-- Consulta: Análise de Acidentes por Tipo de Via e Iluminação
SELECT 
    v.dec_tipo_via AS "Tipo de Via",
    l.dec_luz AS "Iluminacao",
    COUNT(f.ide_acidente) AS "Total de Acidentes",
    SUM(CASE WHEN s.dec_severidade = 'Fatal' THEN 1 ELSE 0 END) AS "Acidentes Fatais",
    ROUND(
        (SUM(CASE WHEN s.dec_severidade = 'Fatal' THEN 1.0 ELSE 0 END) / COUNT(f.ide_acidente)) * 100, 
    2) AS "Taxa de Letalidade (%)"
FROM dw_gold.fat_acidente f
    JOIN dw_gold.dim_tipo_via v ON f.fok_tipo_via = v.suk_tipo_via
    JOIN dw_gold.dim_luz l ON f.fok_luz = l.suk_luz
    JOIN dw_gold.dim_severidade s ON f.fok_severidade = s.suk_severidade
GROUP BY 
    v.dec_tipo_via, 
    l.dec_luz
ORDER BY 
    "Taxa de Letalidade (%)" DESC
LIMIT 15;

-- Consulta: Análise de Acidentes por Limite de Velocidade
SELECT 
    fa.val_limite_velocidade AS "Limite de Velocidade",
    COUNT(fa.ide_acidente) AS "Total de Acidentes",
    SUM(CASE WHEN ds.dec_severidade = 'Fatal' THEN 1 ELSE 0 END) AS "Qtd Fatais",
    ROUND((SUM(CASE WHEN ds.dec_severidade = 'Fatal' THEN 1.0 ELSE 0 END) / COUNT(fa.ide_acidente)) * 100, 2) AS "Taxa de Letalidade",
    ROUND((SUM(CASE WHEN ds.dec_severidade IN ('Fatal', 'Sério') THEN 1.0 ELSE 0 END) / COUNT(fa.ide_acidente)) * 100, 2) AS "Risco Grave ou Fatal"
FROM dw_gold.fat_acidente fa
JOIN dw_gold.dim_severidade ds ON fa.fok_severidade = ds.suk_severidade
WHERE fa.val_limite_velocidade > 0 
GROUP BY fa.val_limite_velocidade
ORDER BY "Taxa de Letalidade" DESC;

-- Consulta: Análise de Veículos Acidentados por Tipo de Propulsão e Faixa Etária
SELECT 
    dp.dec_propulsao AS "Tipo de Propulsão",
    CASE 
        WHEN fv.val_idade_veiculo BETWEEN 0 AND 5 THEN '01. Novo (0-5 anos)'
        WHEN fv.val_idade_veiculo BETWEEN 6 AND 10 THEN '02. Médio (6-10 anos)'
        WHEN fv.val_idade_veiculo BETWEEN 11 AND 15 THEN '03. Velho (11-15 anos)'
        ELSE '04. Muito Velho (16+ anos)' 
    END AS "Faixa Etária Veículo",
    COUNT(fv.ide_veiculo) AS "Qtd Veículos Acidentados",
    ROUND(
        (COUNT(fv.ide_veiculo) * 100.0 / SUM(COUNT(fv.ide_veiculo)) OVER ()), 
    4) AS "Pct do Total Geral"

FROM dw_gold.fat_veiculo fv
JOIN dw_gold.dim_propulsao dp ON fv.fok_propulsao = dp.suk_propulsao
WHERE fv.val_idade_veiculo >= 0 
GROUP BY 1, 2
ORDER BY 1, 2;

-- Consulta: Análise de Acidentes por Dia da Semana e Hora do Dia
SELECT 
    CASE 
        WHEN dd.dec_dia_semana = 'Sunday' THEN 'Domingo'
        WHEN dd.dec_dia_semana = 'Monday' THEN 'Segunda-feira'
        WHEN dd.dec_dia_semana = 'Tuesday' THEN 'Terça-feira'
        WHEN dd.dec_dia_semana = 'Wednesday' THEN 'Quarta-feira'
        WHEN dd.dec_dia_semana = 'Thursday' THEN 'Quinta-feira'
        WHEN dd.dec_dia_semana = 'Friday' THEN 'Sexta-feira'
        WHEN dd.dec_dia_semana = 'Saturday' THEN 'Sábado'
        ELSE dd.dec_dia_semana 
    END AS "Dia da Semana",
    dt.val_hora_dia || 'h' AS "Hora do Dia",
    COUNT(fa.ide_acidente) AS "Total de Acidentes"
FROM dw_gold.fat_acidente fa
    JOIN dw_gold.dim_data dd ON fa.fok_data = dd.suk_data
    JOIN dw_gold.dim_tempo dt ON fa.fok_tempo = dt.suk_tempo
GROUP BY 
    dd.dec_dia_semana, 
    dt.val_hora_dia
ORDER BY 
    "Total de Acidentes" DESC
LIMIT 10;

-- Consulta: Top 15 Dias do Ano com Mais Acidentes
SELECT 
    TO_CHAR(dd.data_completa, 'DD/MM') AS "Data (Dia/Mês)",   
    dd.val_dia_mes AS "Dia",
    dd.val_mes AS "Mês",
    
    COUNT(fa.ide_acidente) AS "Total Histórico de Acidentes",   
    ROUND(COUNT(fa.ide_acidente) / COUNT(DISTINCT dd.val_ano)::numeric, 1) AS "Média por Dia"
FROM dw_gold.fat_acidente fa
JOIN dw_gold.dim_data dd ON fa.fok_data = dd.suk_data
GROUP BY 
    dd.val_mes, 
    dd.val_dia_mes,
    TO_CHAR(dd.data_completa, 'DD/MM')
ORDER BY 
    "Total Histórico de Acidentes" DESC
LIMIT 15;

-- Consulta: Análise de Envolvimentos em Acidentes por Sexo e Faixa Etária do Motorista
SELECT 
    ds.dec_sexo AS "Sexo do Motorista",
    df.dec_faixa_etaria AS "Faixa Etária",
    COUNT(fv.ide_veiculo) AS "Qtd Envolvimentos",
    ROUND(
        (COUNT(fv.ide_veiculo) * 100.0 / SUM(COUNT(fv.ide_veiculo)) OVER ()), 
    2) AS "% do Total"
FROM dw_gold.fat_veiculo fv
    JOIN dw_gold.dim_sexo ds ON fv.fok_sexo_motorista = ds.suk_sexo
    JOIN dw_gold.dim_faixa_etaria df ON fv.fok_faixa_etaria_mot = df.suk_faixa_etaria
WHERE ds.dec_sexo NOT IN ('Desconhecido', 'Ausente', 'Not known', 'Data missing or out of range')
  AND df.dec_faixa_etaria NOT IN ('Unknown', 'Data missing or out of range')
GROUP BY 
    ds.dec_sexo, 
    df.dec_faixa_etaria
ORDER BY 
    "Qtd Envolvimentos" DESC
LIMIT 15;

-- Consulta: Análise de Acidentes por Tipo de Via e Iluminação
SELECT 
    v.dec_tipo_via AS "Tipo de Via",
    l.dec_luz AS "Iluminacao",
    COUNT(f.ide_acidente) AS "Total de Acidentes",
    SUM(CASE WHEN s.dec_severidade = 'Fatal' THEN 1 ELSE 0 END) AS "Acidentes Fatais",
    ROUND(
        (SUM(CASE WHEN s.dec_severidade = 'Fatal' THEN 1.0 ELSE 0 END) / COUNT(f.ide_acidente)) * 100, 
    2) AS "Taxa de Letalidade (%)"
FROM dw_gold.fat_acidente f
    JOIN dw_gold.dim_tipo_via v ON f.fok_tipo_via = v.suk_tipo_via
    JOIN dw_gold.dim_luz l ON f.fok_luz = l.suk_luz
    JOIN dw_gold.dim_severidade s ON f.fok_severidade = s.suk_severidade
GROUP BY 
    v.dec_tipo_via, 
    l.dec_luz
ORDER BY 
    "Taxa de Letalidade (%)" DESC

-- Consulta: Análise de Acidentes por Condição Climática e Tipo de Estrada
SELECT 
    c.dec_clima AS "Condição Climática",
    v.dec_tipo_via AS "Tipo de Estrada",
    COUNT(f.ide_acidente) AS "Total de Acidentes",
    SUM(CASE WHEN s.dec_severidade = 'Fatal' THEN 1 ELSE 0 END) AS "Qtd Fatais",
    ROUND(
        (SUM(CASE WHEN s.dec_severidade = 'Fatal' THEN 1.0 ELSE 0 END) / COUNT(f.ide_acidente)) * 100, 
    2) AS "% Taxa de Letalidade"
FROM dw_gold.fat_acidente f
    JOIN dw_gold.dim_clima c ON f.fok_clima = c.suk_clima
    JOIN dw_gold.dim_tipo_via v ON f.fok_tipo_via = v.suk_tipo_via
    JOIN dw_gold.dim_severidade s ON f.fok_severidade = s.suk_severidade
WHERE c.dec_clima NOT IN ('Unknown', 'Data missing or out of range', 'Desconhecido', 'Ausente')
  AND v.dec_tipo_via NOT IN ('Unknown', 'Data missing or out of range', 'Desconhecido', 'Ausente')

GROUP BY 
    c.dec_clima, 
    v.dec_tipo_via
ORDER BY 
    c.dec_clima, 
    "% Taxa de Letalidade" DESC;


-- Consulta: Análise de Risco por Manobra do Veículo
SELECT 
    dm.dec_manobra AS "Manobra Realizada",
    COUNT(fv.ide_veiculo) AS "Total de Veículos",
    SUM(CASE WHEN ds.dec_severidade = 'Fatal' THEN 1 ELSE 0 END) AS "Veículos em Acidentes Fatais",
    ROUND(
        (SUM(CASE WHEN ds.dec_severidade = 'Fatal' THEN 1.0 ELSE 0 END) / COUNT(fv.ide_veiculo)) * 100, 
    2) AS "% Taxa de Letalidade"

FROM dw_gold.fat_veiculo fv
    JOIN dw_gold.dim_manobra dm ON fv.fok_manobra = dm.suk_manobra
    JOIN dw_gold.fat_acidente fa ON fv.ide_acidente = fa.ide_acidente
    JOIN dw_gold.dim_severidade ds ON fa.fok_severidade = ds.suk_severidade

WHERE dm.dec_manobra NOT IN ('Ausente', 'Data missing or out of range', 'Desconhecido')
GROUP BY 
    dm.dec_manobra
HAVING 
    COUNT(fv.ide_veiculo) > 100
ORDER BY 
    "% Taxa de Letalidade" DESC;