-- Object: PROCEDURE dbo.sp_fixlogins
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sp_fixlogins    Script Date: 3/17/01 9:56:11 PM ******/

/****** Object:  Stored Procedure dbo.sp_fixlogins    Script Date: 3/21/01 12:50:31 PM ******/

/****** Object:  Stored Procedure dbo.sp_fixlogins    Script Date: 20-Mar-01 11:39:09 PM ******/

/****** Object:  Stored Procedure dbo.sp_fixlogins    Script Date: 2/5/01 12:06:28 PM ******/

/****** Object:  Stored Procedure dbo.sp_fixlogins    Script Date: 12/27/00 8:59:03 PM ******/

/****** Object:  Stored Procedure dbo.sp_fixlogins    Script Date: 12/18/99 8:24:05 AM ******/
CREATE procedure sp_fixlogins (
@server varchar(30) = NULL, 
@dbname varchar(30) = NULL, 
@pwd varchar(30) = NULL)
as
/*Stored procedure is used to fix sysuser/sysalternate/syslogin mismatch
after a database is dumped--copy--loaded from one server to another.
Basic execution as follows:
1. Stored procedure is run from target target db on target server after dump-copy-load
2. Using sql dmo, login information from the source server is extracted into temporary tables
3. The temporary tables with login information from source server are used to synch the
logins on the target server 
4. Logins are added to target server for any database users who don't already have logins
5. The sysusers table is synched on the target server, such that the suid in sysusers
matches the suid in syslogins.
6. The sysalternates table is synched on the target server such that the same users
are aliased on target server compared to source server
7. The database owner is changed on target server to match the database owner on source server
8. Xp_grantlogin stored procedure is used to grant integrated access to any NT groups associated
with the database 
 */ 
BEGIN
DECLARE @password varchar(255),
  @column1 varchar(255),
  @column2 varchar(255),
  @column3 varchar(255),
  @Query varchar(255),
  @GetColumnString varchar(255),
  @result varchar(255),
  @object int,
  @object_b int,
  @jRows int,
  @iColumns int,
  @rows int,
  @columns int,
  @hr int,
                @login_name varchar(255),
                @cmdstr varchar(255),
  @group varchar(255),
  @target_server varchar(30),
  @priv varchar(30) 
IF @server is null 
  BEGIN
    PRINT 'Invalid syntax.  Usage: sp_fixlogins <server>,<database>,<sa pwd(optional)>  
    WHERE server and database refer to the database being copied from'
    GOTO server_done
  END
IF @dbname is null
  BEGIN
    PRINT 'Invalid syntax.  Usage: sp_fixlogins <server>,<database>,<sa pwd(optional)>  
    WHERE server and database refer to the database being copied FROM'
    GOTO server_done
  END
IF db_name() = 'master'
  BEGIN
     PRINT 'Cant run from master db.  Must run from user db which
     you loaded to'
     goto server_done
  END 
/* SQL DMO commands to connect to source server */
EXEC @hr = sp_OACreate 'SQLOLE.SQLServer', @object OUT
EXEC @hr = sp_OASetProperty @object, 'LoginTimeout', 10
EXEC @hr = sp_OASetProperty @object, 'QueryTimeout', 10
IF @pwd IS NOT NULL
 EXEC @hr = sp_OAMethod @object, 'Connect', NULL, @server, sa, @pwd
ELSE
 EXEC @hr = sp_OAMethod @object, 'Connect', NULL, @server
IF @hr <> 0
BEGIN
   
    PRINT 'Error connecting to server...Try adding the SA password for
    the Source server as a third parameter'
    return -1
END
SELECT  @jRows=1, @iColumns=1
SELECT @query = 'Databases("'+@dbname +'")'+'.EXECuteWithResults'
CREATE table #srcdb_sysalternates ( Name varchar(30) NULL, SUID varchar(30) )
CREATE table #srcdb_sysusers ( Name varchar(30) NULL, SUID varchar(30) )
CREATE table #srcdb_combine_users ( Name varchar(30) NULL, SUID varchar(30) )
CREATE table #srcdb_syslogins (name varchar(30) null, password varchar(30) null)
CREATE table #srcdb_altsuid ( Name varchar(30) NULL, SUID varchar(30) )
CREATE table #srcdb_dbo_login ( Name varchar(30) NULL, SUID varchar(30) )
CREATE table #srcdb_dbowner ( Name varchar(30) null, Suid varchar(30) )
CREATE table #srcdb_defaultdb (Name varchar(30) null, dbname varchar(30) )
CREATE table #target_loginconfig (Name varchar(30) null, config_value varchar(30) null)
CREATE table #source_logininfo (group_name varchar(50) null, privilege 
             varchar(30) null,mapped_name varchar(50) null)
CREATE table #target_logininfo (group_name varchar(30) null,type varchar(30) null,
             privilege varchar(30) null, mapped_name varchar(30) null, permission
             varchar(30) null)
/*This block of code below gets the name and suid of each person aliased in sysalternates from 
the source server and puts into #srcdb_sysalternates.  Note since sysalternates has no name 
column, need to join with syslogins to get name  */
DECLARE @tempstr varchar(255)
SELECT @tempstr = 'SELECT name =l.name,suid=a.suid FROM sysalternates a, master..syslogins l 
       WHERE a.suid = l.suid'
EXEC @hr = sp_OAMethod @object, @query, @object_b OUT, @tempstr
EXEC @hr = sp_OAGetProperty @object_b, 'rows', @rows OUT
EXEC @hr = sp_OAGetProperty @object_b, 'columns', @columns OUT
WHILE(@jRows <= @rows)
BEGIN
 SELECT @iColumns = 1
 WHILE(@iColumns <= @Columns)
 BEGIN
  SELECT @GetColumnString = 'GetColumnString(' + rtrim(convert(varchar(5),@jRows))
         + ', ' + rtrim(convert(varchar(5),@iColumns)) + ')'
                EXEC @hr = sp_OAGetProperty @object_b, @GetColumnString, @result OUT
  
                IF(@iColumns = 1) 
    BEGIN
   SELECT @column1 = @result
    END
  IF(@iColumns = 2) 
    BEGIN
   SELECT @column2 = @result
    END
  SELECT @iColumns = @iColumns + 1
 END
 INSERT INTO #srcdb_sysalternates
 SELECT @column1, @column2
 SELECT @jRows = @jRows + 1
END
/*This block of code below gets the name and suid of each person represented in the altsuid column
 in sysalternates from the source server and puts into #srcdb_altsuid.  Note since  sysalternates has no name column, need to join with syslogins to get name  */
SELECT  @jRows=1, @iColumns=1
SELECT  @tempstr = 'SELECT name =l.name,suid=a.altsuid FROM sysalternates
        a, master..syslogins l WHERE a.altsuid = l.suid'
EXEC    @hr = sp_OAMethod @object, @query, @object_b OUT, @tempstr
EXEC @hr = sp_OAGetProperty @object_b, 'rows', @rows OUT
EXEC @hr = sp_OAGetProperty @object_b, 'columns', @columns OUT
WHILE(@jRows <= @rows)
BEGIN
 SELECT @iColumns = 1
 WHILE(@iColumns <= @Columns)
 BEGIN
  SELECT @GetColumnString = 'GetColumnString(' + rtrim(convert(varchar(5),@jRows))
  + ', ' + rtrim(convert(varchar(5),@iColumns)) + ')'
  EXEC @hr = sp_OAGetProperty @object_b, @GetColumnString, @result OUT
  
  IF(@iColumns = 1) 
    BEGIN
   SELECT @column1 = @result
    END
  IF(@iColumns = 2) 
    BEGIN
   SELECT @column2 = @result
    END
  SELECT @iColumns = @iColumns + 1
 END
      INSERT INTO #srcdb_altsuid
 SELECT @column1, @column2
  SELECT @jRows = @jRows + 1
END
/*This block of code gets the name of the logins on  source server which link to the
sysuser suid column, and puts contents into #srcdb_sysusers.  Note since it is possible
for database user to have different name in syslogins and sysusers, want to get name from
syslogins for all sysusers, so we can recreate logins on target server later.  
Don't want to include group names and dbo login, so restrict suid > 1*/
SELECT  @jRows=1, @iColumns=1
SELECT  @tempstr = 'SELECT l.name,l.suid FROM sysusers s, master..syslogins l
where l.suid = s.suid  and s.suid > 1'
EXEC    @hr = sp_OAMethod @object, @query, @object_b OUT, @tempstr
EXEC    @hr = sp_OAGetProperty @object_b, 'rows', @rows OUT
EXEC    @hr = sp_OAGetProperty @object_b, 'columns', @columns OUT
WHILE(@jRows <= @rows)
BEGIN
 SELECT @iColumns = 1
 WHILE(@iColumns <= @Columns)
 BEGIN
  SELECT @GetColumnString = 'GetColumnString(' + rtrim(convert(varchar(5),@jRows))
  + ', ' + rtrim(convert(varchar(5),@iColumns)) + ')'
  EXEC @hr = sp_OAGetProperty @object_b, @GetColumnString, @result OUT
  IF(@iColumns = 1) 
    BEGIN
   SELECT @column1 = @result
    END
  IF(@iColumns = 2) 
    BEGIN
   SELECT @column2 = @result
    END
   SELECT @iColumns = @iColumns + 1
 END
 INSERT INTO #srcdb_sysusers
 SELECT @column1, @column2
 SELECT @jRows = @jRows + 1
END
/* The tables #srcdb_sysalternates and #srcdb_sysusers are combined into one #srcdb_combine_users.  This is used to later check to make sure that all of the database users have logins in master..syslogins                */
INSERT INTO #srcdb_combine_users SELECT * FROM #srcdb_sysalternates union  SELECT
* FROM #srcdb_sysusers
INSERT INTO #srcdb_combine_users SELECT distinct * FROM #srcdb_altsuid
/*The next section retrieves the database owner from target server by querying the suid column
in sysdatabases and puts results into #srcdb_dbowner*/
SELECT  @jRows=1, @iColumns=1
SELECT  @tempstr = 'SELECT l.name,l.suid FROM master..syslogins l, master..sysdatabases s
         WHERE s.suid = l.suid and s.name ='+ '"' + @dbname + '"'
EXEC @hr = sp_OAMethod @object, @query, @object_b OUT, @tempstr
EXEC @hr = sp_OAGetProperty @object_b, 'rows', @rows OUT
EXEC @hr = sp_OAGetProperty @object_b, 'columns', @columns OUT
WHILE(@jRows <= @rows)
BEGIN
 SELECT @iColumns = 1
 WHILE(@iColumns <= @Columns)
 BEGIN
  SELECT @GetColumnString = 'GetColumnString(' + rtrim(convert(varchar(5),@jRows)) + ', ' +   rtrim(convert(varchar(5),@iColumns)) + ')'
  EXEC @hr = sp_OAGetProperty @object_b, @GetColumnString, @result OUT
  IF(@iColumns = 1) 
    BEGIN
   SELECT @column1 = @result
    END
  IF(@iColumns = 2) 
    BEGIN
   SELECT @column2 = @result
    END
  SELECT @iColumns = @iColumns + 1
 END
 INSERT INTO #srcdb_dbowner
 SELECT @column1, @column2
 SELECT @jRows = @jRows + 1
END
/* The next section retrieves the login name in syslogins from target server which links to the dbo in sysusers, and puts results into the #srcdb_dbo_login table */
SELECT  @jRows=1, @iColumns=1
SELECT  @tempstr = 'SELECT l.name,l.suid FROM master..syslogins l, sysusers s
        WHERE s.suid = l.suid and s.name = "dbo"'
EXEC @hr = sp_OAMethod @object, @query, @object_b OUT, @tempstr
EXEC @hr = sp_OAGetProperty @object_b, 'rows', @rows OUT
EXEC @hr = sp_OAGetProperty @object_b, 'columns', @columns OUT
WHILE(@jRows <= @rows)
BEGIN
 SELECT @iColumns = 1
 WHILE(@iColumns <= @Columns)
 BEGIN
  SELECT @GetColumnString = 'GetColumnString(' + rtrim(convert(varchar(5),@jRows))
  + ', ' + rtrim(convert(varchar(5),@iColumns)) + ')'
  EXEC @hr = sp_OAGetProperty @object_b, @GetColumnString, @result OUT
  
  IF(@iColumns = 1) 
    BEGIN
      SELECT @column1 = @result
    END
  IF(@iColumns = 2) 
    BEGIN
      SELECT @column2 = @result
    END
  SELECT @iColumns = @iColumns + 1
 END
 INSERT INTO #srcdb_dbo_login
 SELECT @column1, @column2
 SELECT @jRows = @jRows + 1
END
/* The next section  retrieves the login name and default database for all logins on source server
and puts results into the #srcdb_defaultdb table.  Later used to add default database
for any logins which needed to be added to target server */ 
SELECT  @jRows=1, @iColumns=1
SELECT @tempstr = 'SELECT l.name,l.dbname FROM master..syslogins l'
EXEC @hr = sp_OAMethod @object, @query, @object_b OUT, @tempstr
EXEC @hr = sp_OAGetProperty @object_b, 'rows', @rows OUT
EXEC @hr = sp_OAGetProperty @object_b, 'columns', @columns OUT
WHILE(@jRows <= @rows)
BEGIN
 SELECT @iColumns = 1
 WHILE(@iColumns <= @Columns)
 BEGIN
  SELECT @GetColumnString = 'GetColumnString(' + rtrim(convert(varchar(5),@jRows))
                       + ', ' + rtrim(convert(varchar(5),@iColumns)) + ')'
  EXEC @hr = sp_OAGetProperty @object_b, @GetColumnString, @result OUT
  IF(@iColumns = 1) 
  BEGIN
   SELECT @column1 = @result
  END
  IF(@iColumns = 2) 
  BEGIN
   SELECT @column2 = @result
  END
  SELECT @iColumns = @iColumns + 1
 END
 INSERT INTO #srcdb_defaultdb
 SELECT @column1, @column2
 SELECT @jRows = @jRows + 1
END
/* The dbo in sysusers and the database owner in sysdatabases for the db, are special cases
not covered up to this point.  The #srcdb_dbo_login table contains the name and suid of person in syslogins
whose suid maps to dbo in sysusers.  Almost always is sa.  
The database owner in sysdatabases is set from the suid column in sysdatabases.  This should
be the same as the dbo in sysusers.  But, not always.  So, created a separate table, #srcdb_dbowner
to contain name and suid of person who owns db in sysdatabases.  Need to insert these into the
#srcdb_combine_users table so that they later have their logins added below when #srcdb_combine_users is compared to syslogins on destination server */
IF (SELECT count(*) FROM #srcdb_dbo_login d WHERE d.name in (SELECT c.name FROM 
   #srcdb_combine_users c )) = 0 
   INSERT INTO #srcdb_combine_users SELECT distinct * FROM #srcdb_dbo_login
IF (SELECT count(*) FROM #srcdb_dbowner d WHERE d.name in (SELECT c.name FROM 
 #srcdb_combine_users c )) = 0 
      INSERT INTO #srcdb_combine_users SELECT distinct * FROM #srcdb_dbowner
/* The next section gets the name and password from the syslogins table on the source server and
puts results into #srcdb_syslogins.  This is used later to add logins on target server for any 
database users in the #srcdb_combine_users table above who don't have sql logins.  */
SELECT  @jRows=1, @iColumns=1
SELECT  @tempstr = 'SELECT name,password FROM master..syslogins'
EXEC    @hr = sp_OAMethod @object, @query, @object_b OUT, @tempstr
EXEC    @hr = sp_OAGetProperty @object_b, 'rows', @rows OUT
EXEC    @hr = sp_OAGetProperty @object_b, 'columns', @columns OUT
WHILE(@jRows <= @rows)
BEGIN
 SELECT @iColumns = 1
 WHILE(@iColumns <= @Columns)
 BEGIN
  SELECT @GetColumnString = 'GetColumnString(' + rtrim(convert(varchar(5),@jRows))
         + ', ' + rtrim(convert(varchar(5),@iColumns)) + ')'
  EXEC @hr = sp_OAGetProperty @object_b, @GetColumnString, @result OUT
  IF(@iColumns = 1) 
    BEGIN
   SELECT @column1 = @result
    END
  IF(@iColumns = 2) 
    BEGIN
   SELECT @column2 = @result
    END
  SELECT @iColumns = @iColumns + 1
 END
 INSERT INTO #srcdb_syslogins
 SELECT @column1, @column2
 SELECT @jRows = @jRows + 1
END
/*Modify the #srcdb_syslogins table to only contain database users in the #srcdb_combine_users table
(sysusers and sysalternates combined) */
DELETE FROM #srcdb_syslogins WHERE name not in (SELECT name FROM #srcdb_combine_users)
/*Now that #srcdb_syslogins only has database users, modify it further such that it only
contains database users who don't already have logins to the server  */
DELETE FROM #srcdb_syslogins WHERE name in (SELECT name FROM master..syslogins)
/* CREATE a cursor to FETCH each user in #srcdb_syslogins and do a sp_addlogin with parameters of
@dbname, name, and null(password) so, that logins can be added to the target server for any database
users who don't already have server logins.  The password parameter is not useful at this point
since it is already encrypted.  i.e. adding an encrypted password as a parameter to sp_addlogin
only causes sql server to try encrypt an encrypted password.  It is fixed below by updating syslogins
directly.  */
SELECT 'Verifying that all database users have logins on target server....'
DECLARE namelist cursor
FOR SELECT name,password FROM #srcdb_syslogins
OPEN namelist
FETCH next FROM namelist INTO @login_name,@password
WHILE (@@FETCH_status <> -1)
BEGIN
  SELECT 'sp_addlogin ' + @login_name +','+ 'null'+',' + @dbname    
  EXEC   sp_addlogin @login_name,null,@dbname
  FETCH next FROM namelist INTO @login_name,@password
END
    
CLOSE namelist
DEALLOCATE namelist
IF (SELECT COUNT(*) FROM #srcdb_syslogins) > 0
  SELECT  'Bringing over passwords for each login which was added through the sp_addlogin procedure...'
/* The password needs to be updated directly since it is already brought over from source
server as encrypted.    */
EXEC SP_CONFIGURE 'allow updates',1
     RECONFIGURE with override
EXEC ('UPDATE master..syslogins  SET password = #srcdb_syslogins.password 
     FROM master..syslogins,#srcdb_syslogins WHERE master..syslogins.name
     = #srcdb_syslogins.name')
SELECT 'Synching up sysusers table.....'
/* sysusers needs to be updated so that suid maps to suid of same user in syslogins.  Note the
last part of 'where' clause restricting sysusers suid > 1 is necessary because in rare
cases, users have added logins in syslogins named 'dbo'.  Don't want to synch suid in sysusers
to this server login.    */
EXEC('UPDATE sysusers SET s.suid = l.suid FROM sysusers s, master..syslogins l, #srcdb_sysusers d 
     WHERE d.name = l.name and convert(varchar(30),s.suid) = d.suid and s.suid>1')
SELECT 'Synching up sysalternates table....'
/* sysalternates updated so that same users are aliased as on originating server.  Since
sysalternates has no name column, need to refer to the #srcdb_sysalternates table which was created
earlier which has the name and suid of the people aliased on source server */
 EXEC('UPDATE sysalternates SET a.suid = l.suid FROM sysalternates a, master..syslogins l,
#srcdb_sysalternates d WHERE a.suid = convert(smallint,d.suid) and d.name= l.name') 
 EXEC('UPDATE sysalternates SET a.altsuid = l.suid FROM sysalternates a, master..syslogins l,
#srcdb_altsuid d WHERE a.altsuid = convert(smallint,d.suid) and d.name= l.name') 
/* DBO needs to be updated separately because dbo user id in sysusers
does not map to same user name in syslogins, unlike other entries in sysusers */
EXEC('UPDATE sysusers SET s.suid = l.suid FROM sysusers s, master..syslogins l,
    #srcdb_dbo_login d WHERE d.suid = convert(varchar(30),s.suid) and d.name = l.name
    and d.suid != "1"')
  
/* INSERT below updates database owner to be the dbowner as source database */
SELECT 'Verifying that the database owner on target server matches source server...'
IF (SELECT count(*) FROM #srcdb_dbowner d WHERE d.name  in (SELECT l.name FROM master..syslogins l,
 master..sysdatabases s WHERE s.name =@dbname and s.suid = l.suid) ) = 0
BEGIN
  SELECT @tempstr = 'sp_changedbowner ' +  name FROM #srcdb_dbowner 
  SELECT @tempstr = @tempstr + ' ,true'
  SELECT @tempstr
  EXEC (@tempstr)
END
/* Update default database for all database users on target server.  If the default database exists
on target server, modify default database to match default database from source server.  Otherwise,
don't change.  */
EXEC ('UPDATE master..syslogins SET l.dbname = d.dbname FROM #srcdb_defaultdb d, master..syslogins l, #srcdb_combine_users c
WHERE l.name = d.name and c.name = d.name and d.dbname in (SELECT s.name FROM master..sysdatabases s)')
EXEC sp_configure 'allow updates',0
reconfigure with override 
SELECT 'Verifying that NT Groups associated with Database on source server have been granted access to target server...'
/*  Now Need to grant integrated access for all database groups using xp_grantlogin */
/*  xp_logininfo stored proc first checks to see if db groups have integrated access*/
SELECT  @jRows=1, @iColumns=1
SELECT @tempstr = 'master..xp_logininfo'
EXEC @hr = sp_OAMethod @object, @query, @object_b OUT, @tempstr
EXEC @hr = sp_OAGetProperty @object_b, 'rows', @rows OUT
EXEC @hr = sp_OAGetProperty @object_b, 'columns', @columns OUT
WHILE(@jRows <= @rows)
BEGIN
 SELECT @iColumns = 1
 WHILE(@iColumns <= @Columns)
 BEGIN
  SELECT @GetColumnString = 'GetColumnString(' + rtrim(convert(varchar(5),@jRows))
                       + ', ' + rtrim(convert(varchar(5),@iColumns)) + ')'
  EXEC @hr = sp_OAGetProperty @object_b, @GetColumnString, @result OUT
  IF(@iColumns = 1) 
  BEGIN
   SELECT @column1 = @result
  END
  IF(@iColumns = 3) 
  BEGIN
   SELECT @column2 = @result
  END
  IF(@iColumns = 4) 
  BEGIN
   SELECT @column3 = @result
  END
  SELECT @iColumns = @iColumns + 1
 END
 INSERT INTO #source_logininfo
 SELECT @column1, @column2, @column3
 SELECT @jRows = @jRows + 1
END
/* Use xp_loginconfig to determine security mode on Target server*/  
/* IF integrated or mixed security grant integrated logins to all integrated
   groups with access to database  */
INSERT INTO #target_loginconfig execute master..xp_loginconfig
IF (SELECT count(*) FROM #target_loginconfig WHERE config_value in('mixed','integrated') ) > 0
  BEGIN
    INSERT INTO #target_logininfo EXEC master..xp_logininfo
    DELETE FROM #source_logininfo  WHERE group_name in 
                (SELECT group_name FROM #target_logininfo)
   
DECLARE grouplist cursor
for SELECT t.group_name,t.privilege FROM sysusers s,#source_logininfo t 
   WHERE t.mapped_name = s.name and s.suid <-10000 
OPEN grouplist
FETCH next FROM grouplist INTO @group, @priv
WHILE (@@FETCH_status <> -1)
  BEGIN
    SELECT  'xp_grantlogin ' + @group +','+ @priv  
    EXEC   master..xp_grantlogin @group, @priv   
    FETCH next FROM grouplist INTO @group,@priv
  END
CLOSE grouplist
DEALLOCATE grouplist
END
-- Destroy the object
EXEC @hr = sp_OADestroy @object
drop table #srcdb_sysalternates
drop table #srcdb_sysusers
drop table #srcdb_combine_users
drop table #srcdb_altsuid
drop table #srcdb_dbo_login
drop table #srcdb_dbowner
drop table #srcdb_defaultdb
drop table #target_loginconfig
drop table #source_logininfo
drop table #target_logininfo
server_done:
END

GO
