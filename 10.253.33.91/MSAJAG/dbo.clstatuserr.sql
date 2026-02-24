-- Object: PROCEDURE dbo.clstatuserr
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.clstatuserr    Script Date: 3/17/01 9:55:49 PM ******/

/****** Object:  Stored Procedure dbo.clstatuserr    Script Date: 3/21/01 12:50:04 PM ******/

/****** Object:  Stored Procedure dbo.clstatuserr    Script Date: 20-Mar-01 11:38:47 PM ******/

/****** Object:  Stored Procedure dbo.clstatuserr    Script Date: 2/5/01 12:06:10 PM ******/

/****** Object:  Stored Procedure dbo.clstatuserr    Script Date: 12/27/00 8:58:47 PM ******/

/****** Object:  Stored Procedure dbo.clstatuserr    Script Date: 12/18/99 8:24:07 AM ******/
create procedure clstatuserr
@Cl_status Varchar(3), 
@Description VarChar(30),
@code varchar(30) OUTPUT 
As
update clientstatus 
Set
  cl_status = @Cl_status,
  Description = @Description  
  where
  cl_status = @Cl_status
 select cl_status from clientstatus where cl_status like @cl_status

GO
