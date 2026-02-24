-- Object: PROCEDURE dbo.rpt_conamarnewscripmar
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




/****** Object:  Stored Procedure dbo.rpt_conamarnewscripmar    Script Date: 04/21/2001 6:05:18 PM ******/

/* report : albm margin
    file :
    created by mousami on  29/03/2001
*/
/* displays new scrip margin for a particular scrip for a particular settlement*/

CREATE PROCEDURE rpt_conamarnewscripmar

@settno varchar(7),
@settype varchar(3),
@scripcd varchar(12)

AS


SELECT distinct SCRIP_CD,SERIES = (CASE WHEN SETT_TYPE = 'L' THEN 'EQ' ELSE 'BE' END ),
ADDMAR = ABS(ISNULL(( SELECT AddMargin FROM MARGIN2 
WHERE SETT_TYPE = S.SETT_TYPE AND SCRIP_CD = S.SCRIP_CD 
and SETT_NO= ( SELECT MIN(SETT_NO) FROM SETT_MST WHERE SETT_NO > S.SETT_NO AND SETT_TYPE = S.SETT_TYPE)  ),0))
FROM ALBMPARTYPOS S 
WHERE SETT_NO =@settno
AND SETT_TYPE =@settype
and scrip_cd=@scripcd

GO
