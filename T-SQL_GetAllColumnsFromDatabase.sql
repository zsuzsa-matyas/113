-- Description: Getting details about columns from all tables in a database 
-- Parameters:
--		@databaseName: The name of the database from which the columns will be listed

-- Example for usage:
--		EXEC GetAllColumnsFromDatabase 'AdventureWorks2012'

-- Author: zsuzsa-matyas
CREATE PROCEDURE GetAllColumnsFromDatabase
@databaseName nvarchar(255)
AS

-- Variable needed for building a dynamic sql query
DECLARE @sqlQuery nvarchar(max);

-- Building the query using the @databaseName variable
SET @sqlQuery = 'SELECT t.name AS TableName, ' +
	'SCHEMA_NAME(t.schema_id) AS SchemaName, ' +
	'c.name AS ColumnName, ' +
	'typ.name AS ColumnType, ' +
	'c.is_nullable AS IsNullable ' +
'FROM ' + @databaseName +'.sys.tables AS t ' +
'INNER JOIN ' + @databaseName +'.sys.columns c ' + 
	'ON t.OBJECT_ID = c.OBJECT_ID  ' +
'INNER JOIN ' + @databaseName +'.sys.types typ  ' +
	'ON typ.system_type_id = c.system_type_id ' +
'ORDER BY t.name, c.column_id';

-- Executing the query and return the result set  
EXEC (@sqlQuery);




