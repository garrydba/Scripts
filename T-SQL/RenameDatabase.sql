USE master
GO

declare @currentDBName varchar(50)
		,@newDBName varchar(50)
        ,@alterDB nvarchar(1500)

set @currentDBName='foo'
set @newDBName='bar'

set @alterDB='ALTER DATABASE ['+@currentDBName+'] SET SINGLE_USER WITH ROLLBACK IMMEDIATE'
print @alterDB
EXECUTE sp_executesql @alterDB

set @alterDB = 'ALTER DATABASE ['+@currentDBName+'] MODIFY NAME = ['+@newDBName+']'
print @alterDB
EXECUTE sp_executesql @alterDB

set @alterDB = 'ALTER DATABASE ['+@newDBName+'] SET MULTI_USER'
print @alterDB
EXECUTE sp_executesql @alterDB