-- Object: PROCEDURE dbo.rpt_conamarnewfixedmar
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_conamarnewfixedmar    Script Date: 04/21/2001 6:05:18 PM ******/

/*
REPORT	-	ALBM Margin
FILE		-	
CREATED BY	- 	Shyam
CREATE DATE	-	MAR 30 2001
FUNCTION	-	Determines NEW FIX MARGIN % For A Particular Settlement
*/

CREATE PROCEDURE rpt_conamarnewfixedmar
@settno varchar(7),
@settype varchar(3)

AS

SELECT distinct SETT_NO, SETT_TYPE,
fIXMARGIN = ABS((ISNULL((SELECT fixmargin FROM MARGIN1 WHERE SETT_NO= ( SELECT MIN(SETT_NO) FROM SETT_MST WHERE SETT_NO > S.SETT_NO AND SETT_TYPE = S.SETT_TYPE) 
AND SETT_TYPE = S.SETT_TYPE ),0)))
FROM ALBMPARTYPOS S 
WHERE SETT_NO = @settno
AND SETT_TYPE = @settype

GO
