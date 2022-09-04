SHOW DATABASES;

DROP TABLE IF EXISTS lms_bronze.users;

CREATE TABLE IF NOT EXISTS lms_bronze.users (
    user_id INT,
    user_fname STRING,
    user_lname STRING,
    last_op CHAR(1)
);

INSERT INTO lms_bronze.users VALUES
    (1, 'Scott', 'Tiger', 'I'),
    (2, 'Joe', 'Clarke', 'I'),
    (3, 'Mickey', 'Mouse', 'I');

DROP TABLE IF EXISTS lms_silver.users;
CREATE TABLE IF NOT EXISTS lms_silver.users (
    user_id INT,
    user_fname STRING,
    user_lname STRING,
    last_op CHAR(1)
);

USE lms_bronze; SHOW tables;
USE lms_silver; SHOW tables;

SELECT * FROM lms_bronze.users;

MERGE INTO lms_silver.users AS lsu
    USING lms_bronze.users AS lbu
        ON lsu.user_id = lbu.user_id
    WHEN MATCHED AND lbu.last_op = 'U' THEN
        UPDATE SET *
    WHEN MATCHED AND lbu.last_op = 'D' THEN
        DELETE
    WHEN NOT MATCHED THEN
        INSERT *;
        
SELECT * FROM lms_silver.users;

INSERT INTO lms_bronze.users VALUES
    (4, 'Donald', 'Duck', 'I');
    
UPDATE lms_bronze.users
SET user_lname = 'Presley',
    last_op = 'U'
WHERE user_id = 2;

UPDATE lms_bronze.users
SET last_op = 'D'
WHERE user_id = 3;

SELECT * FROM lms_bronze.users;

MERGE INTO lms_silver.users AS lsu
    USING lms_bronze.users AS lbu
        ON lsu.user_id = lbu.user_id
    WHEN MATCHED AND lbu.last_op = 'U' THEN
        UPDATE SET *
    WHEN MATCHED AND lbu.last_op = 'D' THEN
        DELETE
    WHEN NOT MATCHED THEN
        INSERT *;

SELECT * FROM lms_silver.users;

-- Merge with additional timestamp column 
DROP TABLE IF EXISTS lms_bronze.users;

CREATE TABLE IF NOT EXISTS lms_bronze.users (
    user_id INT,
    user_fname STRING,
    user_lname STRING,
    last_op CHAR(1),
    bl_updated_ts TIMESTAMP
);

INSERT INTO lms_bronze.users VALUES
    (1, 'Scott', 'Tiger', 'I', current_timestamp),
    (2, 'Joe', 'Clarke', 'I', current_timestamp),
    (3, 'Mickey', 'Mouse', 'I', current_timestamp);

DROP TABLE IF EXISTS lms_silver.users;
CREATE TABLE IF NOT EXISTS lms_silver.users (
    user_id INT,
    user_fname STRING,
    user_lname STRING,
    last_op CHAR(1),
    bl_updated_ts TIMESTAMP,
    sl_updated_ts TIMESTAMP
);

USE lms_bronze; SHOW tables;
USE lms_silver; SHOW tables;

SELECT * FROM lms_bronze.users;

WITH bl_users_cte AS (
    SELECT * FROM lms_bronze.users
    WHERE bl_updated_ts >= (SELECT max(bl_updated_ts) FROM lms_bronze.users)
)
MERGE INTO lms_silver.users AS lsu
    USING bl_users_cte AS lbu
        ON lsu.user_id = lbu.user_id
    WHEN MATCHED AND lbu.last_op = 'U' THEN
        UPDATE SET
            lsu.user_fname = lbu.user_fname,
            lsu.user_lname = lbu.user_lname,
            lsu.last_op = lbu.last_op,
            lsu.bl_updated_ts = lbu.bl_updated_ts,
            lsu.sl_updated_ts = current_timestamp
    WHEN MATCHED AND lbu.last_op = 'D' THEN
        DELETE
    WHEN NOT MATCHED THEN
        INSERT
            (user_id, user_fname, user_lname, last_op, bl_updated_ts, sl_updated_ts)
        VALUES
            (lbu.user_id, lbu.user_fname, lbu.user_lname, lbu.last_op, lbu.bl_updated_ts, current_timestamp);

WITH s_users_cte AS (
    SELECT 4 AS user_id, 'Donald' AS user_fname, 
        'Duck' AS user_lname, 'I' AS last_op, current_timestamp AS bl_updated_ts
    UNION ALL 
    SELECT 2 AS user_id, 'Joe' AS user_fname,
        'Presley' AS user_lname, 'U' AS last_op, current_timestamp AS bl_updated_ts
    UNION ALL
    SELECT 3 AS user_id, 'Mickey' AS user_fname,
        'Mouse' AS user_lname, 'D' AS last_op, current_timestamp AS bl_updated_ts
) MERGE INTO lms_bronze.users AS lbu
    USING s_users_cte AS suc
        ON suc.user_id = lbu.user_id
    WHEN MATCHED THEN
        UPDATE SET *
    WHEN NOT MATCHED THEN
        INSERT *;
        
SELECT * FROM lms_bronze.users;

WITH bl_users_cte AS (
    SELECT * FROM lms_bronze.users
    WHERE bl_updated_ts >= (SELECT max(bl_updated_ts) FROM lms_bronze.users)
)
MERGE INTO lms_silver.users AS lsu
    USING bl_users_cte AS lbu
        ON lsu.user_id = lbu.user_id
    WHEN MATCHED AND lbu.last_op = 'U' THEN
        UPDATE SET
            lsu.user_fname = lbu.user_fname,
            lsu.user_lname = lbu.user_lname,
            lsu.last_op = lbu.last_op,
            lsu.bl_updated_ts = lbu.bl_updated_ts,
            lsu.sl_updated_ts = current_timestamp
    WHEN MATCHED AND lbu.last_op = 'D' THEN
        DELETE
    WHEN NOT MATCHED THEN
        INSERT
            (user_id, user_fname, user_lname, last_op, bl_updated_ts, sl_updated_ts)
        VALUES
            (lbu.user_id, lbu.user_fname, lbu.user_lname, lbu.last_op, lbu.bl_updated_ts, current_timestamp);
            
SELECT * FROM lms_silver.users;
