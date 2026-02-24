-- Object: PROCEDURE dbo.edclienttype
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.edclienttype    Script Date: 3/17/01 9:55:50 PM ******/

/****** Object:  Stored Procedure dbo.edclienttype    Script Date: 3/21/01 12:50:07 PM ******/

/****** Object:  Stored Procedure dbo.edclienttype    Script Date: 20-Mar-01 11:38:49 PM ******/

/****** Object:  Stored Procedure dbo.edclienttype    Script Date: 2/5/01 12:06:12 PM ******/

/****** Object:  Stored Procedure dbo.edclienttype    Script Date: 12/27/00 8:58:49 PM ******/

/****** Object:  Stored Procedure dbo.edclienttype    Script Date: 12/18/99 8:24:08 AM ******/
create procedure edclienttype
@cl_type varchar(3),
@Description varchar(25),
@code varchar(3) OUTPUT ,
@desc varchar(30) OUTPUT AS
update clienttype
Set 
cl_type = @cl_type,
description = @description
where 
  cl_type = @cl_type
Select * from clienttype where cl_type like @cl_type

GO
