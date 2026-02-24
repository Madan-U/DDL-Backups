-- Object: PROCEDURE dbo.login_script
-- Server: 10.253.33.91 | DB: DBA_Admin
--------------------------------------------------

create   procedure [login_script] @Login varchar(50)
AS
BEGIN
set nocount ON
declare @login_name varchar(100)
set @login_name=@Login

if not exists (select * from sys.server_principals where name = @login_name and type in ('G','U','S'))
BEGIN
PRINT 'please input valid login name'
RETURN
END

declare @login_sid varbinary(85)
select @login_sid = sid from sys.server_principals where name = @login_name

declare @maxid INTEGER

if object_id('tempdb..#db_users') is not NULL
DROP TABLE #db_users

select id=identity(int,1,1), sql_cmd = 'SELECT '''+name+''', * from ['+name+'].sys.database_principals' into #db_users from sys.sysdatabases
select @maxid = @@ROWCOUNT

iF exists (select * from sys.server_principals where type='S' and name = @login_name)
BEGIN
		DECLARE @PWD_varbinary varbinary(256)
		set @PWD_varbinary = CAST (LOGINPROPERTY(@login_name, 'PasswordHash') as varbinary (256))
		
		declare @SID_string varchar(514)
		declare @PWD_string varchar(514)
		
		EXEC master..sp_hexadecimal @PWD_varbinary, @PWD_string OUT
		EXEC master..sp_hexadecimal @login_sid, @SID_string OUT
END


DECLARE @login_sqlcmd varchar(1000)
set @login_sqlcmd = ''
select @login_sqlcmd = '-- LOGIN ['+@login_name+'] IS ' +case is_disabled 
when 1 then 'DISABLED' ELSE 'ENABLED' END FROM sys.server_principals where name = @login_name

iF exists (select * from sys.sql_logins where  name = @login_name)
BEGIN
select @login_sqlcmd = @login_sqlcmd+ char(10)+'CREATE LOIN '+ QUOTENAME(@login_name)+'
WITH PASSWORD = ' + @PWD_string + ' HASHED, SID = ' + @SID_string + ',
DEFAULT_DATABASE = [' +default_database_name+']' from sys.server_principals where name = @login_name

select @login_sqlcmd = @login_sqlcmd + ', CHECK_POLICY' + CASE is_policy_checked
when 0 then '=OFF' ELSE '=ON' END from sys.sql_logins where name = @login_name

select @login_sqlcmd = @login_sqlcmd + ', CHECK_EXPIRATION' + CASE is_policy_checked
when 0 then '=OFF' ELSE '=ON' END from sys.sql_logins where name = @login_name

select @login_sqlcmd = @login_sqlcmd+ char(10)+'ALTER LOGIN ['+@login_name+']
WITH DEFAULT_DATABASE = [' +default_database_name+']' from sys.server_principals where name = @login_name
END

ELSE
BEGIN
select @login_sqlcmd = @login_sqlcmd+ char(10)+'CREATE LOIN '+ QUOTENAME(@login_name)+'
 FROM WINDOWS WITH DEFAULT_DATABASE = [' +default_database_name+']' from sys.server_principals where name = @login_name
 
 END
 
 print @login_sqlcmd
 
 if object_id('tempdb..#srvrole') is not NULL
 drop table #srvrole
 
 CREATE TABLE #srvrole (ServerRole sysname, MemberName sysname, MemberSID varbinary (85))
 
 INSERT INTO #srvrole EXEC sp_helpsrvrolemember
 
 declare @login_srvrole varchar(1000)
 set @login_srvrole = ''
 if exists (select 1 from #srvrole where MemberName= @login_name)
 BEGIN
		select @login_srvrole = @login_srvrole + 'EXEC sp_addsrvrolemember '''+MemberName+''',
			'''+ServerRole+''''+CHAR(10) from #srvrole
			where MemberName=@login_name
			print @login_srvrole
END
ELSE 
BEGIN

print '-- **************LOGIN ['+@login_name+'] is not member of any server role ****************'
END

if object_id('tempdb..#alldb_users') is not NULL
drop table #alldb_users

select dbname = name,* into #alldb_users from [master].sys.database_principals where 1=2

declare @id int, @sqlcmd varchar(5000)
set @id=1
While @id < @maxid
BEGIN 
		select @sqlcmd= sql_cmd from #db_users where id = @id
		insert into #alldb_users exec (@sqlcmd)
		set @id = @id + 1
END

DELETE FROM #alldb_users where [sid] is NULL
DELETE FROM #alldb_users where sid <> @login_sid

 
 if object_id('tempdb..#dbrole') is not NULL
 drop table #dbrole
 
create table #dbrole(dbname varchar(100), dbrole varchar(100), dbrole_member varchar(100), sid varbinary(85), default_schema_name varchar(100), login_name varchar(100), db_principal_id int)

declare @dbrole_sqlcmd varchar(max)

set  @dbrole_sqlcmd =''

select @dbrole_sqlcmd = @dbrole_sqlcmd + 'select '''+dbname+''', c.name, b.name, b.sid, b.default_schema_name, d.name, b.principal_id as login_name
from ['+dbname+'].sys.database_role_members a 
inner join ['+dbname+'].sys.database_principals b on a.member_principal_id=b.principal_id
inner join ['+dbname+'].sys.database_principals c on a.role_principal_id=c.principal_id
left join sys.server_principals d on b.sid=d.sid
'
from #alldb_users

insert into #dbrole exec (@dbrole_sqlcmd)
delete from #dbrole where sid <> @login_sid
alter table #dbrole add ID int identity(1,1)

declare @counter int, @maxid2 int, @login_dbrole varchar(max)
select @maxid2=max(ID) from #dbrole
set @counter =1

if not exists (select * from #dbrole)
BEGIN 
 print '-- **************LOGIN ['+@login_name+'] is not member of any database level role ****************'
 RETURN
END
 
 WHILE @counter <= @maxid2
 BEGIN 
 select @login_dbrole = 'USE ['+dbname+']
 if not exists (select * from sys.database_principals where name = '''+dbrole_member+''')
 BEGIN
		create user ['+dbrole_member+'] for LOGIN ['+login_name+']'+ISNULL
			(' WITH DEFAULT_SCHEMA = ['+default_schema_name+']','')+'
			
END
ALTER USER ['+dbrole_member+'] with login = ['+login_name+']
exec sp_addrolemember '''+dbrole+''','''+dbrole_member+'''

' 
from #dbrole where ID = @counter
select @counter = @counter + 1
print @login_dbrole

END

END

GO
