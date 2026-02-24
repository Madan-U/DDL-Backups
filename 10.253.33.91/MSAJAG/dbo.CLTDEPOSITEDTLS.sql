-- Object: PROCEDURE dbo.CLTDEPOSITEDTLS
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.CLTDEPOSITEDTLS    Script Date: 3/17/01 9:55:49 PM ******/

/****** Object:  Stored Procedure dbo.CLTDEPOSITEDTLS    Script Date: 3/21/01 12:50:04 PM ******/

/****** Object:  Stored Procedure dbo.CLTDEPOSITEDTLS    Script Date: 20-Mar-01 11:38:47 PM ******/

/****** Object:  Stored Procedure dbo.CLTDEPOSITEDTLS    Script Date: 2/5/01 12:06:10 PM ******/

/****** Object:  Stored Procedure dbo.CLTDEPOSITEDTLS    Script Date: 12/27/00 8:58:47 PM ******/

CREATE PROC CLTDEPOSITEDTLS (@SCRIP_CD VARCHAR(12),@PARTY_CODE VARCHAR(10)) AS
SELECT SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD,SERIES,QTY,INOUT FROM CERTINFO m
WHERE PARTY_CODE NOT IN (SELECT D.PARTY_CODE FROM AccessCltQtyChk C, DELIVERYCLT D
WHERE D.INOUT = 'I' AND C.INOUT = 'I' AND D.SETT_NO = C.SETT_NO AND D.SETT_TYPE = C.SETT_TYPE 
AND D.SCRIP_CD = C.SCRIP_CD AND D.SERIES = C.SERIES and d.scrip_cd = @Scrip_cd
and D.QTY >= C.QTY and c.sett_no = m.sett_no and c.sett_type = m.sett_Type and c.scrip_cd = m.scrip_cd and
c.series = m.series and c.party_code = m.party_code and c.inout = m.inout 
GROUP BY D.SETT_NO,D.SETT_TYPE,D.PARTY_CODE,D.SCRIP_CD,D.SERIES,D.QTY ) AND QTY > 0 AND INOUT = 'I' AND PARTY_CODE NOT LIKE 'NSE' 
AND PARTY_CODE LIKE @Party_Code and scrip_cd = @Scrip_Cd
ORDER BY SETT_NO,SETT_TYPE,PARTY_CODE,SCRIP_CD,SERIES

GO
