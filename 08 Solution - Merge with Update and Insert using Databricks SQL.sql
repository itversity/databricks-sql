-- Create Table
DROP TABLE IF EXISTS lms_silver.courses;
CREATE TABLE IF NOT EXISTS lms_silver.courses (
    course_id INT,
    instructor_id INT,
    course_title STRING,
    bl_created_ts TIMESTAMP,
    sl_updated_ts TIMESTAMP
);

-- Insert Statement with Query
INSERT INTO lms_silver.courses
SELECT record.*,
    bl_created_ts,
    current_timestamp AS sl_updated_ts
FROM (
    SELECT from_json(record, 'struct<course_id:INT, instructor_id:INT, course_title:STRING>') AS record,
        bl_created_ts
    FROM lms_bronze.course_catalog
    WHERE table_name = 'courses'
);

-- Make sure that data from part-00001.json is copied to lms_bronze.course_catalog table
WITH course_catalog_cte AS (
    SELECT record.*,
        bl_created_ts,
        current_timestamp AS sl_updated_ts
    FROM (
        SELECT from_json(record, 'struct<course_id:INT, instructor_id:INT, course_title:STRING>') AS record,
            bl_created_ts
        FROM lms_bronze.course_catalog
        WHERE table_name = 'courses'
            AND bl_created_ts >= (SELECT max(bl_created_ts) FROM lms_bronze.course_catalog)
    )
) MERGE INTO lms_silver.courses AS i
    USING course_catalog_cte AS cc
        ON i.course_id = cc.course_id
    WHEN MATCHED THEN 
        UPDATE SET *
    WHEN NOT MATCHED THEN 
        INSERT *;
        

-- Validation
SELECT * FROM lms_bronze.course_catalog
WHERE table_name = 'courses'
ORDER BY bl_created_ts;

SELECT * FROM lms_silver.courses;