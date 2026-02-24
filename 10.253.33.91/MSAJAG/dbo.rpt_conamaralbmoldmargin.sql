-- Object: PROCEDURE dbo.rpt_conamaralbmoldmargin
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_conamaralbmoldmargin    Script Date: 04/21/2001 6:05:18 PM ******/





/****** Object:  Stored Procedure dbo.rpt_albmoldmargin    Script Date: 2/5/01 12:06:15 PM ******/

/****** Object:  Stored Procedure dbo.rpt_albmoldmargin    Script Date: 12/27/00 8:58:53 PM ******/



CREATE PROCEDURE rpt_conamaralbmoldmargin

@settno varchar(7),
@settype varchar(3),
@partycode varchar(10),
@scripcd varchar(12)


AS

SELECT SETT_NO ,SETT_TYPE,PARTY_CODE,SCRIP_CD,
SERIES = (CASE WHEN SETT_TYPE = 'L' THEN 'EQ' ELSE 'BE' END ),
fIXMARGIN = ABS((ISNULL(( SELECT fixmargin FROM MARGIN1 WHERE SETT_NO=S.SETT_NO AND SETT_TYPE = S.SETT_TYPE ),0)*(SUM(PQTY)-SUM(SQTY))/100 ))  , 
ADDMAR = ABS(ISNULL(( SELECT AddMargin*(SUM(PQTY)-SUM(SQTY))/100 FROM MARGIN2 WHERE SETT_TYPE = S.SETT_TYPE AND SCRIP_CD = S.SCRIP_CD and sett_no =S.sett_no ),0))
FROM ALBMPOS S 
WHERE SETT_NO = @settno
AND SETT_TYPE = @settype
and party_code = @partycode
and scrip_cd=@scripcd
GROUP BY SETT_NO ,SETT_TYPE,PARTY_CODE,SCRIP_CD
order by party_code

GO
