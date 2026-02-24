-- Object: PROCEDURE dbo.selsettmst
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.selsettmst    Script Date: 3/17/01 9:56:10 PM ******/

/****** Object:  Stored Procedure dbo.selsettmst    Script Date: 3/21/01 12:50:29 PM ******/

/****** Object:  Stored Procedure dbo.selsettmst    Script Date: 20-Mar-01 11:39:08 PM ******/

/****** Object:  Stored Procedure dbo.selsettmst    Script Date: 2/5/01 12:06:27 PM ******/

/****** Object:  Stored Procedure dbo.selsettmst    Script Date: 12/27/00 8:59:03 PM ******/

/****** Object:  Stored Procedure dbo.selsettmst    Script Date: 12/18/99 8:24:05 AM ******/
create procedure selsettmst 
@setttype varchar(30) 
as 
select * from sett_mst where sett_type like @setttype 
order by exchange, sett_type

GO
