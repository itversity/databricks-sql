SELECT * FROM lms_bronze.course_catalog;

SELECT DISTINCT table_name
FROM lms_bronze.course_catalog;

SELECT table_name, COUNT(*) AS record_count
FROM lms_bronze.course_catalog
GROUP BY 1;

DESCRIBE lms_bronze.course_catalog;

SELECT *
FROM lms_bronze.course_catalog
WHERE table_name = 'courses';

SELECT table_name, record
FROM lms_bronze.course_catalog
WHERE table_name = 'courses';

SELECT current_timestamp();

SELECT current_database();

SELECT current_date();

SELECT date_format('2022-08-15', 'yyyy-MM');

SELECT date_format(current_date(), 'yyyy-MM');

SELECT table_name, record FROM lms_bronze.course_catalog;

WITH icte AS 
(
    SELECT from_json(
        '{"instructor_id": 1, "instructor_name": "ITVersity, LLC"}', 
        'struct<instructor_id:INT, instructor_name:STRING>'
    ) AS record
)
SELECT record.* FROM icte;

WITH ccte AS 
(
    SELECT from_json(
        '{"course_id": 1, "instructor_id": 1, "course_title": "Mastering Python"}', 
        'struct<course_id:INT, instructor_id:INT, course_title:STRING>'
    ) AS record
)
SELECT record.* FROM ccte;

WITH instructors AS (
    SELECT table_name, 
        from_json(record, 'struct<instructor_id:INT, instructor_name:STRING>') AS record
    FROM lms_bronze.course_catalog
    WHERE table_name = 'instructors'
) SELECT table_name, record.* FROM instructors;

WITH courses AS (
    SELECT table_name, 
        from_json(record, 'struct<course_id:INT, instructor_id:INT, course_title:STRING>') AS record
    FROM lms_bronze.course_catalog
    WHERE table_name = 'courses'
) SELECT table_name, record.* FROM courses;

CREATE OR REPLACE VIEW lms_bronze.instructors_v
AS
SELECT table_name, 
    from_json(record, 'struct<instructor_id:INT, instructor_name:STRING>') AS record
FROM lms_bronze.course_catalog
WHERE table_name = 'instructors';

SELECT table_name, record.* FROM lms_bronze.instructors_v;

CREATE OR REPLACE VIEW lms_bronze.courses_v
AS
SELECT table_name, 
    from_json(record, 'struct<course_id:INT, instructor_id:INT, course_title:STRING>') AS record
FROM lms_bronze.course_catalog
WHERE table_name = 'courses';

SELECT table_name, record.* FROM lms_bronze.courses_v;

USE lms_bronze;
SHOW tables;

DESCRIBE lms_bronze.instructors_v;
