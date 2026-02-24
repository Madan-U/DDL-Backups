-- Object: PROCEDURE dbo.SBNODEL3
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.SBNODEL3    Script Date: 3/17/01 9:56:08 PM ******/

/****** Object:  Stored Procedure dbo.SBNODEL3    Script Date: 3/21/01 12:50:27 PM ******/

/****** Object:  Stored Procedure dbo.SBNODEL3    Script Date: 20-Mar-01 11:39:06 PM ******/

/****** Object:  Stored Procedure dbo.SBNODEL3    Script Date: 2/5/01 12:06:26 PM ******/

/****** Object:  Stored Procedure dbo.SBNODEL3    Script Date: 12/27/00 8:59:01 PM ******/

CREATE PROCEDURE SBNODEL3
@sett_no varchar(7),
@sett_type varchar(3)
AS
SELECT SCRIP_CD,SERIES,
START_DATE=LEFT(CONVERT(VARCHAR,START_DATE,109),11),
END_DATE=LEFT(CONVERT(VARCHAR,END_DATE,109),11),SETTLED_IN 
FROM NODEL where sett_no = @sett_no and sett_Type = @sett_type
order by scrip_cd,series

GO
