SHOW DATABASES;

SELECT table_name, record
FROM JSON.`dbfs:/FileStore/lms_dl/course_catalog`;

USE lms_bronze; SHOW TABLES;

DROP TABLE IF EXISTS lms_bronze.course_catalog;

CREATE TABLE IF NOT EXISTS lms_bronze.course_catalog (
    table_name STRING,
    record STRING
);

SELECT * FROM lms_bronze.course_catalog;

SELECT input_file_name() AS input_file_name, table_name, record
FROM JSON.`dbfs:/FileStore/lms_dl/course_catalog`;

-- Run twice, Data will not be copied twice as details about processed files are tracked

COPY INTO lms_bronze.course_catalog
FROM 'dbfs:/FileStore/lms_dl/course_catalog'
FILEFORMAT = JSON
FILES = ('part-00000.json');

SELECT * FROM lms_bronze.course_catalog;

TRUNCATE TABLE lms_bronze.course_catalog;

COPY INTO lms_bronze.course_catalog
FROM 'dbfs:/FileStore/lms_dl/course_catalog'
FILEFORMAT = JSON
FILES = ('part-00000.json', 'part-00001.json');

SELECT * FROM lms_bronze.course_catalog;

TRUNCATE TABLE lms_bronze.course_catalog;

COPY INTO lms_bronze.course_catalog
FROM 'dbfs:/FileStore/lms_dl/course_catalog'
FILEFORMAT = JSON
PATTERN = 'part-0000[0-9].json'
COPY_OPTIONS ('force' = 'true');

SELECT * FROM lms_bronze.course_catalog;

DROP TABLE IF EXISTS lms_bronze.course_catalog;

CREATE TABLE IF NOT EXISTS lms_bronze.course_catalog (
    table_name STRING,
    record STRING,
    created_ts TIMESTAMP
);

SELECT * FROM lms_bronze.course_catalog;
    

SELECT input_file_name() AS input_file_name, 
    table_name, 
    record,
    current_timestamp() AS created_ts
FROM JSON.`dbfs:/FileStore/lms_dl/course_catalog`;

COPY INTO lms_bronze.course_catalog
FROM (
    SELECT table_name,
        record,
        current_timestamp() AS created_ts
    FROM 'dbfs:/FileStore/lms_dl/course_catalog'
) FILEFORMAT = JSON
PATTERN = 'part-0000[0-9].json';

SELECT * FROM lms_bronze.course_catalog;

WITH icte AS (
    SELECT table_name,
        from_json(record, 'struct<instructor_id:INT, instructor_name:STRING>') AS record
    FROM lms_bronze.course_catalog
    WHERE table_name = 'instructors'
) SELECT table_name, record.* FROM icte;
