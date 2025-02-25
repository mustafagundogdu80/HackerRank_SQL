-- https://www.hackerrank.com/challenges/15-days-of-learning-sql/problem
WITH dayly_procecess_hackers AS(
  	SELECT submission_date, hacker_id
  	FROM submissions
  	GROUP BY submission_date, hacker_id
)
SELECT 
    sb.submission_date,
    (
        SELECT COUNT(hacker_id)
        FROM Hackers AS sub1_h
        WHERE sub1_h.hacker_id IN(
            SELECT dph.hacker_id
            FROM dayly_procecess_hackers AS dph
            WHERE dph.submission_date BETWEEN DATE '2016-03-01' AND sb.submission_date
            GROUP BY dph.hacker_id
            HAVING COUNT(dph.submission_date) = (sb.submission_date - DATE '2016-03-01' )+ 1
        )
    ) AS daily_active_hackers,
    (
        SELECT sub2_sb.hacker_id
        FROM submissions AS sub2_sb 
        WHERE sub2_sb.submission_date = sb.submission_date
        GROUP BY sub2_sb.hacker_id
        ORDER BY COUNT(sub2_sb.submission_id) DESC, sub2_sb.hacker_id
        LIMIT 1
    ) AS max_hacker_id,
    (
        SELECT sub3_h.name
        FROM Submissions AS sub3_sb, Hackers AS sub3_h 
        WHERE sub3_sb.hacker_id = sub3_h.hacker_id AND sub3_sb.submission_date = sb.submission_date
        GROUP BY sub3_h.hacker_id, sub3_h.name
        ORDER BY COUNT(sub3_sb.submission_id) DESC, sub3_h.hacker_id
        LIMIT 1
    ) AS hacker_name
 
FROM submissions AS sb
WHERE sb.submission_date BETWEEN DATE '2016-03-01' AND DATE '2016-03-15'
GROUP BY sb.submission_date
ORDER BY sb.submission_date;
