SHOW DATABASES;

USE lms_silver; SHOW TABLES;

USE lms_bronze; SHOW TABLES;

CREATE DATABASE IF NOT EXISTS lms_silver;

DROP TABLE IF EXISTS lms_silver.instructors;
CREATE TABLE IF NOT EXISTS lms_silver.instructors (
    instructor_id INT,
    instructor_name STRING,
    bl_created_ts TIMESTAMP,
    sl_updated_ts TIMESTAMP
);

DROP TABLE IF EXISTS lms_bronze.course_catalog;
CREATE TABLE IF NOT EXISTS lms_bronze.course_catalog (
    table_name STRING,
    record STRING,
    bl_created_ts TIMESTAMP
);

SELECT input_file_name(), table_name, record
FROM JSON.`dbfs:/FileStore/lms_dl/course_catalog` AS course_catalog;

COPY INTO lms_bronze.course_catalog
FROM (
    SELECT table_name,
        record,
        current_timestamp AS bl_created_ts
    FROM 'dbfs:/FileStore/lms_dl/course_catalog'
) FILEFORMAT = JSON
FILES = ('part-00000.json')
COPY_OPTIONS ('force' = 'true');

SELECT * FROM lms_bronze.course_catalog;

INSERT INTO lms_silver.instructors
SELECT record.*,
    bl_created_ts,
    current_timestamp AS sl_updated_ts
FROM (
    SELECT from_json(record, 'struct<instructor_id:INT, instructor_name:STRING>') AS record,
        bl_created_ts
    FROM lms_bronze.course_catalog
    WHERE table_name = 'instructors'
);

SELECT * FROM lms_silver.instructors;

SELECT input_file_name(), table_name, record
FROM JSON.`dbfs:/FileStore/lms_dl/course_catalog` AS course_catalog;

COPY INTO lms_bronze.course_catalog
FROM (
    SELECT table_name,
        record,
        current_timestamp AS bl_created_ts
    FROM 'dbfs:/FileStore/lms_dl/course_catalog'
) FILEFORMAT = JSON
FILES = ('part-00001.json');

SELECT * 
FROM lms_bronze.course_catalog
WHERE table_name = 'instructors'
ORDER BY bl_created_ts;

SELECT max(bl_created_ts) FROM lms_bronze.course_catalog;

SELECT record.*,
    bl_created_ts
FROM (
    SELECT from_json(record, 'struct<instructor_id:INT, instructor_name:STRING>') AS record,
        bl_created_ts
    FROM lms_bronze.course_catalog
    WHERE table_name = 'instructors'
        AND bl_created_ts >= (SELECT max(bl_created_ts) FROM lms_bronze.course_catalog)
);

-- MERGE INTO <table_name>
--     USING <source_data_expression>
--         ON <join_condition>
--     WHEN MATCHED THEN 
--         UPDATE SET 
--             tgt_col1 = src_col1, 
--             tgt_col2 = src_col2
--     WHEN NOT MATCHED THEN 
--         INSERT ()
--         VALUES

WITH course_catalog_cte AS (
    SELECT record.*,
        bl_created_ts,
        current_timestamp AS sl_updated_ts
    FROM (
        SELECT from_json(record, 'struct<instructor_id:INT, instructor_name:STRING>') AS record,
            bl_created_ts
        FROM lms_bronze.course_catalog
        WHERE table_name = 'instructors'
            AND bl_created_ts >= (SELECT max(bl_created_ts) FROM lms_bronze.course_catalog)
    )
) SELECT * FROM course_catalog_cte;

WITH course_catalog_cte AS (
    SELECT record.*,
        bl_created_ts,
        current_timestamp AS sl_updated_ts
    FROM (
        SELECT from_json(record, 'struct<instructor_id:INT, instructor_name:STRING>') AS record,
            bl_created_ts
        FROM lms_bronze.course_catalog
        WHERE table_name = 'instructors'
            AND bl_created_ts >= (SELECT max(bl_created_ts) FROM lms_bronze.course_catalog)
    )
) MERGE INTO lms_silver.instructors AS i
    USING course_catalog_cte AS cc
        ON i.instructor_id = cc.instructor_id
    WHEN MATCHED THEN UPDATE SET *
    WHEN NOT MATCHED THEN INSERT *;
    
SELECT * FROM lms_silver.instructors;

WITH course_catalog_cte AS (
    SELECT record.*,
        bl_created_ts,
        current_timestamp AS sl_updated_ts
    FROM (
        SELECT from_json(record, 'struct<instructor_id:INT, instructor_name:STRING>') AS record,
            bl_created_ts
        FROM lms_bronze.course_catalog
        WHERE table_name = 'instructors'
            AND bl_created_ts >= (SELECT max(bl_created_ts) FROM lms_bronze.course_catalog)
    )
) MERGE INTO lms_silver.instructors AS i
    USING course_catalog_cte AS cc
        ON i.instructor_id = cc.instructor_id
    WHEN MATCHED THEN 
        UPDATE SET
            i.instructor_name = cc.instructor_name,
            i.bl_created_ts = cc.bl_created_ts,
            i.sl_updated_ts = cc.sl_updated_ts
    WHEN NOT MATCHED THEN 
        INSERT 
            (instructor_id, instructor_name, bl_created_ts, sl_updated_ts)
        VALUES
            (cc.instructor_id, cc.instructor_name, cc.bl_created_ts, cc.sl_updated_ts);
            
SELECT * FROM lms_bronze.course_catalog
WHERE table_name = 'courses'
ORDER BY bl_created_ts;