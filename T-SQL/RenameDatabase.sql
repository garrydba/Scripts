USE master
GO

declare @currentDBName varchar(20)
		,@newDBName varchar(20)
        ,@alterDB nvarchar(500)

set @currentDBName='CURRENT_NAME'
set @newDBName='NEW_NAME'

set @alterDB='ALTER DATABASE ['+@currentDBName+'] SET SINGLE_USER WITH ROLLBACK IMMEDIATE'
print @alterDB
EXECUTE sp_executesql @alterDB

set @alterDB = 'ALTER DATABASE ['+@currentDBName+'] MODIFY NAME = ['+@newDBName+']'
print @alterDB
EXECUTE sp_executesql @alterDB

set @alterDB = 'ALTER DATABASE ['+@newDBName+'] SET MULTI_USER'
print @alterDB
EXECUTE sp_executesql @alterDB