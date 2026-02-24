-- Object: PROCEDURE dbo.edclstatus
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.edclstatus    Script Date: 3/17/01 9:55:50 PM ******/

/****** Object:  Stored Procedure dbo.edclstatus    Script Date: 3/21/01 12:50:07 PM ******/

/****** Object:  Stored Procedure dbo.edclstatus    Script Date: 20-Mar-01 11:38:49 PM ******/

/****** Object:  Stored Procedure dbo.edclstatus    Script Date: 2/5/01 12:06:12 PM ******/

/****** Object:  Stored Procedure dbo.edclstatus    Script Date: 12/27/00 8:58:49 PM ******/

/****** Object:  Stored Procedure dbo.edclstatus    Script Date: 12/18/99 8:24:09 AM ******/
create procedure edclstatus 
@cl_status varchar(30),
@description varchar(30),
@orig varchar(30) 
 AS
update clientstatus
Set 
cl_status = @cl_status,
description = @description
where 
  cl_status = @cl_status
return 1

GO
