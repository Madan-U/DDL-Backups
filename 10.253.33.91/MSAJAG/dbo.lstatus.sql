-- Object: PROCEDURE dbo.lstatus
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.lstatus    Script Date: 3/17/01 9:55:53 PM ******/

/****** Object:  Stored Procedure dbo.lstatus    Script Date: 3/21/01 12:50:09 PM ******/

/****** Object:  Stored Procedure dbo.lstatus    Script Date: 20-Mar-01 11:38:51 PM ******/

/****** Object:  Stored Procedure dbo.lstatus    Script Date: 2/5/01 12:06:14 PM ******/

/****** Object:  Stored Procedure dbo.lstatus    Script Date: 12/27/00 8:58:51 PM ******/

/****** Object:  Stored Procedure dbo.lstatus    Script Date: 12/18/99 8:24:05 AM ******/
create procedure lstatus @Cl_status Varchar(3), @Description VarChar(30), @var1 varchar(30) output As
if @cl_status=null
begin print " Completed successfully, @variable "
return
end

GO
