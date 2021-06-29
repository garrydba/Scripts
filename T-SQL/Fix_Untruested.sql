DECLARE @schemaName varchar(5)
		,@tableName varchar(40)
		,@objectName varchar(100)
		,@execStat nvarchar(1500)

DECLARE	update_untrusted CURSOR
FOR 
SELECT s.name AS SchemaName,  o.name AS TableName , i.name AS keyname
from sys.foreign_keys i
INNER JOIN sys.objects o ON i.parent_object_id = o.object_id
INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
WHERE i.is_not_trusted = 1 AND i.is_not_for_replication = 0

UNION

SELECT s.name AS SchemaName,  o.name AS TableName , i.name AS keyname
from sys.check_constraints i
INNER JOIN sys.objects o ON i.parent_object_id = o.object_id
INNER JOIN sys.schemas s ON o.schema_id = s.schema_id
WHERE i.is_not_trusted = 1 AND i.is_not_for_replication = 0 AND i.is_disabled = 0

OPEN update_untrusted	

FETCH NEXT FROM update_untrusted INTO
	@schemaName, @tableName, @objectName

WHILE @@FETCH_STATUS = 0
BEGIN

SET @execStat = 'ALTER TABLE '+@schemaName +'.'+ @tableName	+' WITH CHECK CHECK CONSTRAINT '+@objectName
--PRINT @execStat
EXEC sp_executesql @execStat

FETCH NEXT FROM update_untrusted INTO
	@schemaName, @tableName, @objectName

END
CLOSE update_untrusted
DEALLOCATE	update_untrusted