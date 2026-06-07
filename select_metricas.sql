-- KPI 1: Contagem por status de projeto agrupado por squad e sprint
SELECT
    squad_id_x              AS squad,
    sprint_atual            AS sprint,
    project_name            AS projeto,
    categoria               AS tipo_tarefa,
    COUNT(CASE WHEN status_projeto = 'Concluído'   THEN 1 END) AS concluidas,
    COUNT(CASE WHEN status_projeto = 'Em andamento' THEN 1 END) AS em_andamento,
    COUNT(CASE WHEN status_projeto = 'Atrasado'    THEN 1 END) AS atrasadas
FROM wide_table_tasks_analytics
GROUP BY squad_id_x, sprint_atual, project_name, categoria
ORDER BY atrasadas DESC;

-- KPI 2: Story Points em aberto x tempo médio por Story Point
SELECT
    project_name,
    sprint_atual,
    SUM(CASE WHEN status_projeto != 'Concluído' THEN story_points ELSE 0 END) AS story_points_abertos,
    AVG(task_actual_time_minutes * 1.0 / NULLIF(story_points, 0))              AS minutos_por_story_point,
    SUM(CASE WHEN status_projeto != 'Concluído' THEN story_points ELSE 0 END)
        * AVG(task_actual_time_minutes * 1.0 / NULLIF(story_points, 0)) / 60   AS horas_estimadas_conclusao
FROM wide_table_tasks_analytics
GROUP BY project_name, sprint_atual
ORDER BY horas_estimadas_conclusao DESC;


-- KPI 3: Tarefas não concluídas ordenadas por prazo mais próximo
SELECT
    project_name,
    squad_id_x          AS squad,
    sprint_atual        AS sprint,
    user_name           AS responsavel,
    cargo,
    task_type_name      AS tarefa,
    categoria,
    task_due_date       AS prazo,
    task_actual_start_date AS inicio,
    status_projeto      AS status
FROM wide_table_tasks_analytics
WHERE status_projeto NOT IN ('Concluído')
ORDER BY task_due_date ASC
LIMIT 50;


-- KPI 4: Projeto com maior número de tarefas atrasadas
SELECT
    project_name,
    squad_id_x                                          AS squad,
    COUNT(*)                                            AS total_tarefas,
    COUNT(CASE WHEN status_projeto = 'Atrasado' THEN 1 END) AS tarefas_atrasadas,
    ROUND(
        COUNT(CASE WHEN status_projeto = 'Atrasado' THEN 1 END) * 100.0 / COUNT(*), 1
    )                                                   AS pct_atrasado
FROM wide_table_tasks_analytics
GROUP BY project_name, squad_id_x
ORDER BY tarefas_atrasadas DESC
LIMIT 1;


-- KPI 5: Usuários com menos tarefas atribuídas (mais disponíveis)
SELECT
    user_name,
    cargo,
    squad_id_x                  AS squad,
    nivel,
    COUNT(*)                    AS tarefas_atribuidas,
    SUM(task_actual_time_minutes) AS minutos_trabalhados,
    ROUND(SUM(task_actual_time_minutes) / 60.0, 1) AS horas_trabalhadas
FROM wide_table_tasks_analytics
WHERE status != 'Inativo'
GROUP BY user_name, cargo, squad_id_x, nivel
ORDER BY tarefas_atribuidas ASC;