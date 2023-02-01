SELECT
	country,
	count(city) AS No_Of_Cities
FROM
	address
WHERE
	country NOT IN("USA", "MALAYSIA") 
GROUP BY
	country
LIMIT 2
;