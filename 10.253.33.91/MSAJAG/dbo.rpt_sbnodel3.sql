-- Object: PROCEDURE dbo.rpt_sbnodel3
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_sbnodel3    Script Date: 04/27/2001 4:32:49 PM ******/

/****** Object:  Stored Procedure dbo.rpt_sbnodel3    Script Date: 3/21/01 12:50:23 PM ******/

/****** Object:  Stored Procedure dbo.rpt_sbnodel3    Script Date: 20-Mar-01 11:39:03 PM ******/

/****** Object:  Stored Procedure dbo.rpt_sbnodel3    Script Date: 2/5/01 12:06:23 PM ******/

/****** Object:  Stored Procedure dbo.rpt_sbnodel3    Script Date: 12/27/00 8:58:58 PM ******/

/** REPORT : NODELIVERY
FILE :DISPINFO.ASP **/
CREATE PROCEDURE rpt_sbnodel3
@SETTNO VARCHAR(7),
@SETTYPE VARCHAR(3)
AS
SELECT SRNO ,SCRIP_CD,SERIES,SETT_NO,SETT_TYPE,
START_DATE=LEFT(CONVERT(VARCHAR,START_DATE,109),11),
END_DATE=LEFT(CONVERT(VARCHAR,END_DATE,109),11),SETTLED_IN 
FROM NODEL
WHERE SETT_NO=@SETTNO AND SETT_TYPE=@SETTYPE

GO
