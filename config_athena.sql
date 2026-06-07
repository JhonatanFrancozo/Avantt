CREATE EXTERNAL TABLE tarefas.wide_table_tasks (
    project STRING,
    total_tarefas INT,
    total_minutos DOUBLE,
    projetos_atrasados INT,
    data_processamento STRING
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION 's3://grupo01-gold-672656967070/tasks_gold/'
TBLPROPERTIES ('skip.header.line.count'='1');