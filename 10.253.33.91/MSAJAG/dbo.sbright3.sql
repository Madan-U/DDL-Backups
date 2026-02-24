-- Object: PROCEDURE dbo.sbright3
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbright3    Script Date: 3/17/01 9:56:08 PM ******/

/****** Object:  Stored Procedure dbo.sbright3    Script Date: 3/21/01 12:50:28 PM ******/

/****** Object:  Stored Procedure dbo.sbright3    Script Date: 20-Mar-01 11:39:07 PM ******/

/****** Object:  Stored Procedure dbo.sbright3    Script Date: 2/5/01 12:06:26 PM ******/

/****** Object:  Stored Procedure dbo.sbright3    Script Date: 12/27/00 8:59:01 PM ******/

CREATE PROCEDURE 
sbright3
@id varchar(10)
AS
 select distinct sett_no 
from history 
where party_code =@id
group by sett_no

GO
