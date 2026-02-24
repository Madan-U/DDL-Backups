-- Object: PROCEDURE dbo.sbchangepsw
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbchangepsw    Script Date: 3/17/01 9:56:06 PM ******/

/****** Object:  Stored Procedure dbo.sbchangepsw    Script Date: 3/21/01 12:50:25 PM ******/

/****** Object:  Stored Procedure dbo.sbchangepsw    Script Date: 20-Mar-01 11:39:04 PM ******/

/****** Object:  Stored Procedure dbo.sbchangepsw    Script Date: 2/5/01 12:06:24 PM ******/

/****** Object:  Stored Procedure dbo.sbchangepsw    Script Date: 12/27/00 8:59:14 PM ******/

CREATE PROCEDURE sbchangepsw
@subbrok varchar(15) 
AS
select password 
from subbrokadmin 
where subbrokname = @subbrok

GO
