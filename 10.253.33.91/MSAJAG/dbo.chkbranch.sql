-- Object: PROCEDURE dbo.chkbranch
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.chkbranch    Script Date: 3/17/01 9:55:48 PM ******/

/****** Object:  Stored Procedure dbo.chkbranch    Script Date: 3/21/01 12:50:04 PM ******/

/****** Object:  Stored Procedure dbo.chkbranch    Script Date: 20-Mar-01 11:38:47 PM ******/

/****** Object:  Stored Procedure dbo.chkbranch    Script Date: 2/5/01 12:06:10 PM ******/

/****** Object:  Stored Procedure dbo.chkbranch    Script Date: 12/27/00 8:58:47 PM ******/

/****** Object:  Stored Procedure dbo.chkbranch    Script Date: 12/18/99 8:24:07 AM ******/
create procedure chkbranch
@br_cd varchar(10),
@name varchar(30) OUTPUT
as
Select "Record Duplicated" from branches where 
 branch_cd like @br_cd

GO
