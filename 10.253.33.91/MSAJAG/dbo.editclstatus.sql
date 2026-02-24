-- Object: PROCEDURE dbo.editclstatus
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.editclstatus    Script Date: 3/17/01 9:55:51 PM ******/

/****** Object:  Stored Procedure dbo.editclstatus    Script Date: 3/21/01 12:50:07 PM ******/

/****** Object:  Stored Procedure dbo.editclstatus    Script Date: 20-Mar-01 11:38:49 PM ******/

/****** Object:  Stored Procedure dbo.editclstatus    Script Date: 2/5/01 12:06:12 PM ******/

/****** Object:  Stored Procedure dbo.editclstatus    Script Date: 12/27/00 8:58:49 PM ******/

/****** Object:  Stored Procedure dbo.editclstatus    Script Date: 12/18/99 8:24:09 AM ******/
create procedure editclstatus @Cl_status Varchar(3), @Description VarChar(30) As
update clientstatus 
Set
cl_status = @Cl_status,
Description = @Description  
where
 cl_status = @Cl_status
print " Completed successfully"

GO
