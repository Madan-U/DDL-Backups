-- Object: PROCEDURE dbo.databases
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.databases    Script Date: 3/17/01 9:55:50 PM ******/

/****** Object:  Stored Procedure dbo.databases    Script Date: 3/21/01 12:50:06 PM ******/

/****** Object:  Stored Procedure dbo.databases    Script Date: 20-Mar-01 11:38:48 PM ******/

/****** Object:  Stored Procedure dbo.databases    Script Date: 2/5/01 12:06:11 PM ******/

/****** Object:  Stored Procedure dbo.databases    Script Date: 12/27/00 8:58:48 PM ******/

create proc databases (@DATABASE VARCHAR(10))
as
	set nocount on
	declare @name sysname
	declare @SQL  nvarchar(600)

	/* Use temporary table to sum up database size w/o using group by */
	create table #databases (
				  DATABASE_NAME sysname NOT NULL,
				  size int NOT NULL)

	declare c1 cursor for 
		select name from master.dbo.sysdatabases

	open c1
	fetch c1 into @name

	while @@fetch_status >= 0
	begin
		select @SQL = 'insert into #databases
				select N'''+ @name + ''', sum(size) from '
				+ QuoteName(@name) + '.dbo.sysfiles'
		/* Insert row for each database */
		execute (@SQL)
		fetch c1 into @name
	end
	deallocate c1

	select	
		DATABASE_NAME,
		DATABASE_SIZE = size*8,/* Convert from 8192 byte pages to K */
		REMARKS = convert(varchar(254),null)	/* Remarks are NULL */
	from #databases WHERE DATABASE_NAME LIKE @dATABASE 
	order by 1

GO
