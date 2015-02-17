-- Description: Getting details about columns from all tables in a database 
-- Parameters:
-- 		@databaseName: The name of the database from which the columns will be listed

-- Example for usage:
-- 		CALL GetAllColumnsFromDatabase ('sakila')

-- Author: zsuzsa-matyas

DROP PROCEDURE IF EXISTS GetAllColumnsFromDatabase;
DELIMITER //
CREATE PROCEDURE GetAllColumnsFromDatabase (IN databaseName text)
BEGIN

-- Building the dynamic query using the 'databaseName' variable
SET @sqlQuery = 'SELECT table_name AS TableName, ';
SET @sqlQuery = CONCAT(@sqlQuery, 'column_name AS ColumnName, ');
SET @sqlQuery = CONCAT(@sqlQuery, 'column_type AS ColumnType, ');
SET @sqlQuery = CONCAT(@sqlQuery, 'is_nullable AS IsNullable ');
SET @sqlQuery = CONCAT(@sqlQuery, 'FROM information_schema.columns ');
SET @sqlQuery = CONCAT(@sqlQuery, 'WHERE table_schema = ''');
SET @sqlQuery = CONCAT(@sqlQuery, databaseName);
SET @sqlQuery = CONCAT(@sqlQuery, ''' ORDER BY table_name, column_name');

-- Executing the query and return the result set  
PREPARE stmt FROM @sqlQuery;
EXECUTE stmt ;
DEALLOCATE PREPARE stmt;
    
END //
DELIMITER ;


