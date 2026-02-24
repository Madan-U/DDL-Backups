-- Object: PROCEDURE dbo.rpt_conamaralbmnewmargin
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_conamaralbmnewmargin    Script Date: 04/21/2001 6:05:18 PM ******/


/* report : consolidated albmmargin
    file : listclientscrip.asp
    finds  new margin for a scrip of a client
*/

CREATE PROCEDURE rpt_conamaralbmnewmargin

@settno varchar(7),
@settype varchar(3),
@partycode varchar(10),
@scripcd varchar(12)

AS

SELECT SETT_NO ,SETT_TYPE,PARTY_CODE,SCRIP_CD,SERIES = (CASE WHEN SETT_TYPE = 'L' THEN 'EQ' ELSE 'BE' END ),
fIXMARGIN = ABS((ISNULL(( SELECT fixmargin FROM MARGIN1 WHERE SETT_NO= ( SELECT MIN(SETT_NO) FROM SETT_MST WHERE SETT_NO > S.SETT_NO AND SETT_TYPE = S.SETT_TYPE) 
AND SETT_TYPE = S.SETT_TYPE ),0)*(SUM(PQTY)-SUM(SQTY))/100 ))  , 
ADDMAR = ABS(ISNULL(( SELECT AddMargin*(SUM(PQTY)-SUM(SQTY))/100 FROM MARGIN2 
WHERE SETT_TYPE = S.SETT_TYPE AND SCRIP_CD = S.SCRIP_CD and SETT_NO= ( SELECT MIN(SETT_NO) FROM SETT_MST WHERE SETT_NO > S.SETT_NO AND SETT_TYPE = S.SETT_TYPE)  ),0))
FROM ALBMPARTYPOS S 
WHERE SETT_NO =@settno
AND SETT_TYPE = @settype
AND PARTY_CODE = @PARTYCODE
and scrip_cd=@scripcd
GROUP BY SETT_NO ,SETT_TYPE,PARTY_CODE,SCRIP_CD,SERIES
order by party_code

GO
