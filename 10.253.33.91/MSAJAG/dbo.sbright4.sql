-- Object: PROCEDURE dbo.sbright4
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbright4    Script Date: 3/17/01 9:56:08 PM ******/

/****** Object:  Stored Procedure dbo.sbright4    Script Date: 3/21/01 12:50:28 PM ******/

/****** Object:  Stored Procedure dbo.sbright4    Script Date: 20-Mar-01 11:39:07 PM ******/

/****** Object:  Stored Procedure dbo.sbright4    Script Date: 2/5/01 12:06:26 PM ******/

/****** Object:  Stored Procedure dbo.sbright4    Script Date: 12/27/00 8:59:01 PM ******/

CREATE procedure 
 sbright4
@id varchar(10)
AS
select distinct sett_type 
from history 
where party_code = @id

GO
