-- Description: Get random N rows of a query 
-- Parameters:
--		@numberOfRows: Number of random rows returned
--		@sqlQuery: The SQL query to be executed 

-- Author: zsuzsa-matyas
-- Date: 26.10.2013

-- Example for usage:
--		EXEC GetRandomNRows 7, 'SELECT AddressId, AddressLine1, AddressLine2 FROM AdventureWorks2012.Person.Address' 

CREATE PROCEDURE [dbo].[GetRandomNRows] 
	@numberOfRows int, 
	@sqlQuery nvarchar(max)
AS

-- Exception handling
IF @numberOfRows < 1 
BEGIN
	SELECT 'Unaccepted value for numberOfRows' AS 'Error';
	RETURN;
END;

-- Handling the simple SELECT case  
IF CHARINDEX('DISTINCT', @sqlQuery) = 0 
BEGIN

	SET @sqlQuery = REPLACE(@sqlQuery, 'SELECT', 
						'SELECT TOP ' + CAST(@numberOfRows AS nvarchar(100)) + ' '); 

END

-- Handling the SELECT DISTINCT case  
-- SELECT DISTINCT works only if the random number is selected as a column in the result set  
ELSE
BEGIN

	SET @sqlQuery = REPLACE(@sqlQuery, 'SELECT DISTINCT', 
						'SELECT DISTINCT TOP ' + CAST(@numberOfRows AS nvarchar(100)) + ' '); 
	SET @sqlQuery = REPLACE(@sqlQuery, 'FROM', ', NEWID() AS RandomId FROM '); 

END

-- Ordering based on the random ID  
SET @sqlQuery = @sqlQuery + ' ORDER BY NEWID()';

-- Execute the query and return the result set  
EXEC(@sqlQuery);

GO


