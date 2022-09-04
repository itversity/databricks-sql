SHOW DATABASES;

DROP TABLE IF EXISTS lms_silver.users;
CREATE TABLE IF NOT EXISTS lms_silver.users (
  user_id INT,
  user_first_name STRING,
  user_last_name STRING,
  user_email STRING
) USING DELTA;

DESCRIBE FORMATTED lms_silver.users;

DROP TABLE IF EXISTS lms_silver.users;
CREATE TABLE IF NOT EXISTS lms_silver.users (
  user_id INT,
  user_first_name STRING,
  user_last_name STRING,
  user_email STRING
) USING DELTA
LOCATION 'dbfs:/user/hive/warehouse/lms_silver.db/users';

DESCRIBE FORMATTED lms_silver.users;

-- DML Operations => CRUD Operations
-- DML - Data Manipulation Language
-- CRUD - Create, Read, Update, Delete

INSERT INTO lms_silver.users
VALUES (1, 'Scott', 'Tiger', 'stiger@gmail.com');

INSERT INTO lms_silver.users
VALUES (2, 'Donald', NULL, NULL);

INSERT INTO lms_silver.users (user_id, user_last_name, user_email, user_first_name)
VALUES (3, NULL, NULL, 'Joe');

TRUNCATE TABLE lms_silver.users;

INSERT INTO lms_silver.users
VALUES 
    (1, 'Scott', 'Tiger', 'stiger@gmail.com'),
    (2, 'Donald', NULL, NULL),
    (3, 'Joe', NULL, NULL);
    
INSERT INTO lms_silver.users (user_id, user_last_name, user_email, user_first_name) 
VALUES 
    (1, 'Tiger', 'stiger@gmail.com', 'Scott'),
    (2, NULL, NULL, 'Donald'),
    (3, NULL, NULL, 'Joe');

UPDATE lms_silver.users 
SET user_last_name = 'Duck'
WHERE user_id = 2;

UPDATE lms_silver.users 
SET user_last_name = 'Duck', user_email = 'dduck@gmail.com'
WHERE user_id = 2;

UPDATE lms_silver.users 
SET user_last_name = 'LNU'
WHERE user_last_name IS NULL;

DELETE FROM lms_silver.users
WHERE user_id = 1;

DELETE FROM lms_silver.users
WHERE user_email IS NULL;

TRUNCATE TABLE lms_silver.users;

SELECT * FROM lms_silver.users;

DROP TABLE lms_silver.users;