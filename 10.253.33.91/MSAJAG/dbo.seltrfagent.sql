-- Object: PROCEDURE dbo.seltrfagent
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.seltrfagent    Script Date: 3/17/01 9:56:10 PM ******/

/****** Object:  Stored Procedure dbo.seltrfagent    Script Date: 3/21/01 12:50:30 PM ******/

/****** Object:  Stored Procedure dbo.seltrfagent    Script Date: 20-Mar-01 11:39:08 PM ******/

/****** Object:  Stored Procedure dbo.seltrfagent    Script Date: 2/5/01 12:06:27 PM ******/

/****** Object:  Stored Procedure dbo.seltrfagent    Script Date: 12/27/00 8:59:16 PM ******/

/****** Object:  Stored Procedure dbo.seltrfagent    Script Date: 12/18/99 8:24:11 AM ******/
create procedure seltrfagent
@name varchar(30) 
as
select * from transferagents where name like @name
order by name

GO
