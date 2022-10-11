--  Basic Validations of Udemy Reviews

SELECT count(*) FROM udemy.udemy_reviews;

SELECT DISTINCT `Course Name`
FROM udemy.udemy_reviews;

SELECT * FROM udemy.udemy_reviews
WHERE `Timestamp` IS NULL;

SELECT DISTINCT `Course Name`
FROM udemy.udemy_reviews
WHERE `Timestamp` IS NOT NULL
ORDER BY 1;

SELECT DISTINCT `Rating`
FROM udemy.udemy_reviews
WHERE `Timestamp` IS NOT NULL
ORDER BY 1;

SELECT `Rating`,
    COUNT(*) `Rating Count`
FROM udemy.udemy_reviews
WHERE `Timestamp` IS NOT NULL
GROUP BY 1
ORDER BY 1;

SELECT DISTINCT YEAR(`Timestamp`) AS `Review Year`
FROM udemy.udemy_reviews
WHERE `Timestamp` IS NOT NULL
ORDER BY 1;

SELECT YEAR(`Timestamp`) AS `Review Year`,
    COUNT(*) AS `Rating Count`
FROM udemy.udemy_reviews
WHERE `Timestamp` IS NOT NULL
GROUP BY 1
ORDER BY 1;

SELECT `Course Name`,
    COUNT(*) AS `Rating Count`
FROM udemy.udemy_reviews
WHERE `Timestamp` IS NOT NULL
GROUP BY 1
ORDER BY 1;

-- Course Review Count by Month

SELECT DATE_FORMAT(`Timestamp`, 'yyyy-MM') AS `Review Month`,
    `Course Name`,
    COUNT(*) AS `Review Count`
FROM udemy.udemy_reviews
WHERE `Timestamp` IS NOT NULL
    AND YEAR(`Timestamp`) = {{ Review Year }}
GROUP BY 1, 2
ORDER BY 1, 2;

-- Course Review Summary

SELECT COUNT(*) AS `Total Review Count`,
    COUNT(DISTINCT `Course Name`) AS `Course Count`,
    COUNT_IF(`Comment` IS NOT NULL) AS `Comment Count`
FROM udemy_reviews
WHERE `Timestamp` IS NOT NULL
  AND YEAR(`Timestamp`) = {{ Review Count }}
 
