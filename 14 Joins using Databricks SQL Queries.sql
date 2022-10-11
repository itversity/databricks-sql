SHOW DATABASES;

USE lms_silver; SHOW tables;

DROP TABLE IF EXISTS lms_silver.users;

DROP TABLE IF EXISTS lms_silver.courses;

DROP TABLE IF EXISTS lms_silver.course_enrolments;

CREATE TABLE IF NOT EXISTS lms_silver.users (
    user_id INT,
    user_fname STRING,
    user_lname STRING
);

CREATE TABLE IF NOT EXISTS lms_silver.courses (
    course_id INT,
    course_title STRING,
    course_price FLOAT
);

CREATE TABLE IF NOT EXISTS lms_silver.course_enrolments (
    enrolment_id INT,
    user_id INT,
    course_id INT,
    sale_date DATE,
    amount_paid FLOAT
);

USE lms_silver; SHOW tables;

INSERT INTO lms_silver.users
VALUES
    (1, 'Scott', 'Tiger'),
    (2, 'John', 'Clarke'),
    (3, 'Mickey', 'Mouse'),
    (4, 'Donald', 'Duck');
    
SELECT * FROM lms_silver.users;

INSERT INTO lms_silver.courses
VALUES
    (1, 'Python', 400.0),
    (2, 'Spark', 800.0),
    (3, 'AWS', 800.0);
    
SELECT * FROM lms_silver.courses;

INSERT INTO lms_silver.course_enrolments
VALUES
    (1, 1, 2, '2022-01-15', 600.0),
    (2, 2, 3, '2022-01-21', 800.0),
    (3, 2, 2, '2022-02-05', 600.0),
    (4, 1, 3, '2022-02-16', 600.0),
    (5, 3, 3, '2022-01-31', 800.0),
    (6, 5, 4, '2022-01-21', 400.0);
    
SELECT * FROM lms_silver.course_enrolments;

-- Different types of JOINS
-- Inner Join
-- Left or Right Outer Join
-- A Full Outer Join B => A LEFT OUTER JOIN B UNION A RIGHT OUTER JOIN B
-- Cartesian Product

-- Inner Join between users and course_enrolments
SELECT *
FROM lms_silver.users AS u
    INNER JOIN lms_silver.course_enrolments AS ce
        ON u.user_id = ce.user_id
ORDER BY u.user_id;

SELECT *
FROM lms_silver.users AS u, lms_silver.course_enrolments AS ce
WHERE u.user_id = ce.user_id
ORDER BY u.user_id;

SELECT ce.enrolment_id, ce.user_id, ce.course_id,
    c.course_title, c.course_price, ce.sale_date, ce.amount_paid
FROM lms_silver.courses AS c 
    JOIN lms_silver.course_enrolments AS ce
        ON c.course_id = ce.course_id
ORDER BY ce.enrolment_id;

SELECT ce.enrolment_id,
    u.*,
    c.*,
    ce.sale_date,
    ce.amount_paid,
    c.course_price - ce.amount_paid AS outstanding_amount
FROM lms_silver.courses AS c
    JOIN lms_silver.course_enrolments AS ce
        ON c.course_id = ce.course_id
    JOIN lms_silver.users AS u
        ON u.user_id = ce.user_id
ORDER BY ce.enrolment_id;


SELECT u.*,
    sum(c.course_price - ce.amount_paid) AS outstanding_amount
FROM lms_silver.courses AS c
    JOIN lms_silver.course_enrolments AS ce
        ON c.course_id = ce.course_id
    JOIN lms_silver.users AS u
        ON u.user_id = ce.user_id
GROUP BY u.user_id, u.user_fname, u.user_lname
ORDER BY u.user_id;


SELECT u.*,
    ce.enrolment_id,
    ce.course_id,
    ce.sale_date,
    ce.amount_paid
FROM lms_silver.users AS u
    LEFT OUTER JOIN lms_silver.course_enrolments AS ce
        ON u.user_id = ce.user_id
ORDER BY u.user_id, ce.enrolment_id;

SELECT u.*,
    ce.enrolment_id,
    ce.course_id,
    ce.sale_date,
    ce.amount_paid
FROM lms_silver.users AS u
    LEFT OUTER JOIN lms_silver.course_enrolments AS ce
        ON u.user_id = ce.user_id
ORDER BY u.user_id, ce.enrolment_id;

SELECT u.*,
    ce.enrolment_id,
    ce.course_id,
    ce.sale_date,
    ce.amount_paid
FROM lms_silver.course_enrolments AS ce
    RIGHT OUTER JOIN lms_silver.users AS u
        ON u.user_id = ce.user_id
ORDER BY u.user_id, ce.enrolment_id;

SELECT u.*,
    coalesce(ce.amount_paid, 0) AS amount_paid
FROM lms_silver.users AS u
    LEFT OUTER JOIN lms_silver.course_enrolments AS ce
        ON u.user_id = ce.user_id
ORDER BY u.user_id, ce.enrolment_id;

SELECT u.*,
    sum(coalesce(amount_paid, 0.0)) AS revenue
FROM lms_silver.users AS u
    LEFT OUTER JOIN lms_silver.course_enrolments AS ce
        ON u.user_id = ce.user_id
GROUP BY u.user_id, u.user_fname, u.user_lname
ORDER BY u.user_id;

SELECT u.*,
    sum(coalesce(amount_paid, 0.0)) AS revenue,
    count_if(ce.user_id IS NOT NULL) AS enrolment_count
FROM lms_silver.users AS u
    LEFT OUTER JOIN lms_silver.course_enrolments AS ce
        ON u.user_id = ce.user_id
GROUP BY u.user_id, u.user_fname, u.user_lname
ORDER BY u.user_id;

SELECT ce.enrolment_id,
    ce.user_id,
    c.course_id,
    c.course_title,
    c.course_price,
    ce.sale_date,
    ce.amount_paid
FROM lms_silver.courses AS c
    LEFT OUTER JOIN lms_silver.course_enrolments AS ce
        ON c.course_id = ce.course_id
ORDER BY c.course_id;

SELECT c.*,
    sum(coalesce(ce.amount_paid, 0.0)) AS revenue,
    count_if(ce.course_id IS NOT NULL) AS enrolment_count
FROM lms_silver.courses AS c
    LEFT OUTER JOIN lms_silver.course_enrolments AS ce
        ON c.course_id = ce.course_id
GROUP BY c.course_id, c.course_title, c.course_price
ORDER BY c.course_id;

SELECT ce.enrolment_id,
    u.user_id,
    u.user_fname,
    u.user_lname,
    ce.course_id,
    ce.sale_date,
    ce.amount_paid
FROM lms_silver.users AS u
    LEFT OUTER JOIN lms_silver.course_enrolments AS ce
        ON u.user_id = ce.user_id
            AND date_format(ce.sale_date, 'yyyy-MM') = '2022-02'
ORDER BY u.user_id;

SELECT u.*,
    sum(coalesce(amount_paid, 0.0)) AS revenue,
    count_if(ce.user_id IS NOT NULL) AS enrolment_count
FROM lms_silver.users AS u
    LEFT OUTER JOIN lms_silver.course_enrolments AS ce
        ON u.user_id = ce.user_id
            AND date_format(ce.sale_date, 'yyyy-MM') = '2022-02'
GROUP BY u.user_id, u.user_fname, u.user_lname
ORDER BY u.user_id;

SELECT u.*,
    ce.enrolment_id,
    ce.course_id,
    ce.sale_date,
    ce.amount_paid
FROM lms_silver.users AS u
    LEFT OUTER JOIN lms_silver.course_enrolments AS ce
        ON u.user_id = ce.user_id
ORDER BY u.user_id, ce.enrolment_id;

SELECT u.*,
    ce.enrolment_id,
    ce.course_id,
    ce.sale_date,
    ce.amount_paid
FROM lms_silver.users AS u
    LEFT OUTER JOIN lms_silver.course_enrolments AS ce
        ON u.user_id = ce.user_id
ORDER BY u.user_id, ce.enrolment_id;

SELECT u.*,
    ce.enrolment_id,
    ce.course_id,
    ce.sale_date,
    ce.amount_paid
FROM lms_silver.users AS u
    LEFT OUTER JOIN lms_silver.course_enrolments AS ce
        ON u.user_id = ce.user_id
ORDER BY u.user_id, ce.enrolment_id;

SELECT u.*,
    ce.enrolment_id,
    ce.user_id AS enrolment_user_id,
    ce.course_id,
    ce.sale_date,
    ce.amount_paid
FROM lms_silver.users AS u
    RIGHT OUTER JOIN lms_silver.course_enrolments AS ce
        ON u.user_id = ce.user_id
ORDER BY u.user_id, ce.enrolment_id;

SELECT u.*,
    ce.enrolment_id,
    ce.user_id AS enrolment_user_id,
    ce.course_id,
    ce.sale_date,
    ce.amount_paid
FROM lms_silver.users AS u
    FULL OUTER JOIN lms_silver.course_enrolments AS ce
        ON u.user_id = ce.user_id
ORDER BY u.user_id, ce.enrolment_id;


SELECT u.*,
    c.*
FROM lms_silver.users AS u
    CROSS JOIN lms_silver.courses AS c
ORDER BY u.user_id;

