-- Object: PROCEDURE dbo.connect_time
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.connect_time    Script Date: 3/17/01 9:55:49 PM ******/

/****** Object:  Stored Procedure dbo.connect_time    Script Date: 3/21/01 12:50:05 PM ******/

/****** Object:  Stored Procedure dbo.connect_time    Script Date: 20-Mar-01 11:38:48 PM ******/

/****** Object:  Stored Procedure dbo.connect_time    Script Date: 2/5/01 12:06:11 PM ******/

/****** Object:  Stored Procedure dbo.connect_time    Script Date: 12/27/00 8:58:48 PM ******/

/****** Object:  Stored Procedure dbo.connect_time    Script Date: 12/18/99 8:24:08 AM ******/
CREATE PROCEDURE connect_time
@secsym char(10),
@ty  char(2),
@desc  char(30),
@seccode char(6),
@secisin char(12)
AS
update sarika set SECSYM =@secsym,TY = @ty, DESCRIPTIO=@desc ,SECCODE=@seccode, SECISIN=@secisin where seccode = @seccode

GO
