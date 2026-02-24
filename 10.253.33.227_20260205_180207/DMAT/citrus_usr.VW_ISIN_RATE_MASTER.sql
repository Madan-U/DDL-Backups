-- Object: VIEW citrus_usr.VW_ISIN_RATE_MASTER
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE  VIEW [citrus_usr].[VW_ISIN_RATE_MASTER]
AS
SELECT CLOPM_DT RATE_DATE	
,CLOPM_ISIN_CD ISIN	
,convert(money,CLOPM_CDSL_RT ) CLOSE_PRICE	
,clopm_exch EXCH_CODE								
FROM CLOSING_PRICE_MSTR_CDSL 
--WHERE clopm_exch NOT IN ('AMFIMF','BSE')

GO
