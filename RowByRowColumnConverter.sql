-- e.g. if you need to convert all the rows in a column row by row from VARCHAR to DATETIME, and throw an exception for an error row to find and fix that row

DECLARE @rowID INT;
DECLARE @dateStr VARCHAR(100);

DECLARE staging_cursor CURSOR FOR
SELECT 
       [tableRowID],
       [dateString]
FROM [SourceDB].[dbo].[SourceTable]

OPEN staging_cursor;
-- Perform the first fetch and store the values in variables.
-- Note: The variables are in the same order as the columns
-- in the SELECT statement.

FETCH NEXT FROM staging_cursor 
INTO 
       @rowID,
       @dateStr

       if @dateStr is not null
       begin try
              update [SourceDB].[dbo].[SourceTable] set [NewDate] = CONVERT(datetime, @dateStr, 103) where [tableRowID] = @rowID
       end try

       BEGIN CATCH

              --Get Error Description
              PRINT ERROR_MESSAGE()
              SELECT @rowID
              SELECT @dateStr

              CLOSE staging_cursor;

              DEALLOCATE staging_cursor; 

              RETURN 
       END CATCH

-- Check @@FETCH_STATUS to see if there are any more rows to fetch.
WHILE @@FETCH_STATUS = 0
BEGIN

       -- This is executed as long as the previous fetch succeeds
       FETCH NEXT FROM staging_cursor 
       INTO 
              @rowID,
              @dateStr

       if @dateStr is not null
       begin try
              update [SourceDB].[dbo].[SourceTable] set [NewDate] = CONVERT(datetime, @dateStr, 103) where [tableRowID] = @rowID
       end try

       BEGIN CATCH

              --Get Error Description
              PRINT ERROR_MESSAGE()
              SELECT @rowID
              SELECT @dateStr

              CLOSE staging_cursor;

              DEALLOCATE staging_cursor; 

              RETURN 
       END CATCH
END

CLOSE staging_cursor;

DEALLOCATE staging_cursor; 
