-- Object: PROCEDURE dbo.brupdate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brupdate    Script Date: 3/17/01 9:55:48 PM ******/

/****** Object:  Stored Procedure dbo.brupdate    Script Date: 3/21/01 12:50:04 PM ******/

/****** Object:  Stored Procedure dbo.brupdate    Script Date: 20-Mar-01 11:38:47 PM ******/

/****** Object:  Stored Procedure dbo.brupdate    Script Date: 2/5/01 12:06:10 PM ******/

/****** Object:  Stored Procedure dbo.brupdate    Script Date: 12/27/00 8:59:06 PM ******/

CREATE PROCEDURE brupdate
@br varchar(3),
@newpsw varchar(15)
AS
update bradmin 
set password = @newpsw
 where branch_cd = @br

GO
