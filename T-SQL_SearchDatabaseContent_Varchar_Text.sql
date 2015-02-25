-- Description: Searching for a specific string in database. 
-- Returning a list of schemas, tables and columns where the string was found.
-- Parameters:
--		@databaseName: The name of the database from which the columns will be listed
--		@textToSearch: The text to be found in the database

-- Example for usage:
--		EXEC SearchDatabaseContent_Varchar_Text 'AdventureWorks2012', 'London'

-- Author: zsuzsa-matyas

CREATE PROCEDURE SearchDatabaseContent_Varchar_Text
@databaseName nvarchar(255),
@textToSearch nvarchar(255)
AS

-- declaring all the variables
DECLARE @maxID int;
DECLARE @counter int;
DECLARE @currentSchemaName nvarchar(255);
DECLARE @currentTableName nvarchar(255);
DECLARE @currentColumnName nvarchar(255);
DECLARE @sqlQuery nvarchar(max);

-- creating a temporary table for storing all the table and column names
SET @sqlQuery = 'IF (EXISTS (SELECT * ' + 
'FROM INFORMATION_SCHEMA.TABLES ' +
'WHERE TABLE_NAME = ''TempTableAndColumns'')) ' +
'DROP TABLE TempTableAndColumns; ';

-- executing the dynamic query
EXEC (@sqlQuery);

CREATE TABLE TempTableAndColumns(
	ID int identity(1,1), 
	SchemaName nvarchar(255),
	TableName nvarchar(255), 
	ColumnName nvarchar(255),
	Found int null);

-- getting all the column and table names from the database
-- filtering out columns having other data type then nvarchar/varhchar/text
SET @sqlQuery = 'INSERT INTO TempTableAndColumns(SchemaName, TableName, ColumnName) ' +
'SELECT T.TABLE_SCHEMA AS SchemaName, ' +
'	T.TABLE_NAME AS TableName, ' +
'	COL.COLUMN_NAME AS ColumnName ' +
'FROM INFORMATION_SCHEMA.COLUMNS COL ' +
'INNER JOIN INFORMATION_SCHEMA.TABLES T ' +
'ON T.TABLE_CATALOG = COL.TABLE_CATALOG ' +
'AND T.TABLE_SCHEMA = COL.TABLE_SCHEMA ' +
'AND T.TABLE_NAME = COL.TABLE_NAME ' +
'WHERE T.TABLE_TYPE = ''BASE TABLE'' ' +
'AND COL.DATA_TYPE IN (''nvarchar'', ''varchar'', ''text'', ''ntext'');';

-- executing the dynamic query
EXEC (@sqlQuery);

-- storing the last id into a variable
SELECT @maxID = ID FROM TempTableAndColumns;

-- setting the counter to point to the first item
SET @counter = 1;

-- looping through all items
WHILE (@counter <= @maxID)
BEGIN

-- getting the schema, table and column for the current item
SELECT @currentSchemaName = SchemaName,
	@currentTableName = TableName,
	@currentColumnName = ColumnName
FROM TempTableAndColumns
WHERE ID = @counter;

-- checking if the content is in this column
SET @sqlQuery = 'DECLARE @returnValue int; '+
	'SELECT @returnValue = COUNT(*) FROM [' + @currentSchemaName + '].[' + @currentTableName + ']' +
	' WHERE [' + @currentColumnName + '] = ''' + @textToSearch + '''' +
	' OR [' + @currentColumnName + '] LIKE ''%' + @textToSearch + '%''' +
	' OR [' + @currentColumnName + '] LIKE ''' + @textToSearch + '%''' +
	' OR [' + @currentColumnName + '] LIKE ''%' + @textToSearch + ''';' +	
-- if the result is found, updating the Found column
	'IF @returnValue > 0 UPDATE TempTableAndColumns SET Found = 1 ' +
	'WHERE SchemaName = ''' + @currentSchemaName +
	''' AND TableName = ''' + @currentTableName +
	''' AND ColumnName = '''+ @currentColumnName + ''';' ;

-- executing the dynamic query
EXEC (@sqlQuery);


SET @counter = @counter + 1;

END;

-- showing results at the end, if any
SELECT SchemaName, TableName, ColumnName 
FROM TempTableAndColumns 
WHERE Found = 1;