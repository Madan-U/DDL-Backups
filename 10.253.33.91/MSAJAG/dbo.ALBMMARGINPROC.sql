-- Object: PROCEDURE dbo.ALBMMARGINPROC
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.ALBMMARGINPROC    Script Date: 3/17/01 9:55:43 PM ******/

/****** Object:  Stored Procedure dbo.ALBMMARGINPROC    Script Date: 3/21/01 12:49:59 PM ******/

/****** Object:  Stored Procedure dbo.ALBMMARGINPROC    Script Date: 20-Mar-01 11:38:41 PM ******/

/****** Object:  Stored Procedure dbo.ALBMMARGINPROC    Script Date: 2/5/01 12:06:06 PM ******/

/****** Object:  Stored Procedure dbo.ALBMMARGINPROC    Script Date: 12/27/00 8:58:42 PM ******/

CREATE PROC ALBMMARGINPROC (@SETT_NO VARCHAR(7),@SETT_TYPE VARCHAR(2), @PARTY VARCHAR(10)) AS
SELECT fIXMARGIN = isnull( SUM(fIXMARGIN ),0) ,ADDMAR = isnull(SUM(ADDMAR),0)
FROM ALBMMARGIN WHERE SETT_NO = @SETT_NO AND SETT_tYPE = @SETT_TYPE
AND PARTY_CODE = @PARTY

GO
