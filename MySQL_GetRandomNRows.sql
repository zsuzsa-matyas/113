-- Description: Get random N rows of a query 
-- Parameters:
-- 		numberOfRows: Number of random rows returned
-- 		sqlQuery: The SQL query to be executed 

-- Example for usage:
-- 		CALL GetRandomNRows (0, 'SELECT * FROM sakila.address')

-- Author: zsuzsa-matyas

DROP PROCEDURE IF EXISTS GetRandomNRows;
DELIMITER //
CREATE PROCEDURE GetRandomNRows (IN numberOfRows int, IN sqlQuery text)
BEGIN

IF numberOfRows > 0 THEN

	-- Ordering based on the random ID  
	SET @sqlFinalQuery = CONCAT(sqlQuery, ' ORDER BY RAND()');
	
    -- Limiting by the numberOfRows parameter 
	SET @sqlFinalQuery = CONCAT(@sqlFinalQuery, ' LIMIT ');
	SET @sqlFinalQuery = CONCAT(@sqlFinalQuery, numberOfRows);

	-- Execute the query and return the result set  
	PREPARE stmt FROM @sqlFinalQuery;
	EXECUTE stmt ;
	DEALLOCATE PREPARE stmt;

ELSE 
	
	-- Exception handling
    SELECT 'Unaccepted value for numberOfRows' AS 'Error';

END IF;

END //
DELIMITER ;
