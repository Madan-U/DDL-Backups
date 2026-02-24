-- Object: PROCEDURE dbo.brchpass
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.brchpass    Script Date: 3/17/01 9:55:45 PM ******/

/****** Object:  Stored Procedure dbo.brchpass    Script Date: 3/21/01 12:50:01 PM ******/

/****** Object:  Stored Procedure dbo.brchpass    Script Date: 20-Mar-01 11:38:44 PM ******/

/****** Object:  Stored Procedure dbo.brchpass    Script Date: 2/5/01 12:06:07 PM ******/

/****** Object:  Stored Procedure dbo.brchpass    Script Date: 12/27/00 8:59:06 PM ******/

CREATE PROCEDURE brchpass
@br varchar(3)
AS
select password 
from bradmin 
where branch_cd = @br

GO
