-- Object: PROCEDURE citrus_usr.PR_BULK_IMPORT_SOH
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--PR_BULK_IMPORT_SOH '','HO','','c:\BulkInsDbfolder\SOH\273008hold.flt','*|~*','|*~|',''
CREATE PROCEDURE [citrus_usr].[PR_BULK_IMPORT_SOH]
(    @pa_exch          VARCHAR(20)  
	,@pa_login_name    VARCHAR(20)  
	,@pa_mode          VARCHAR(10)  																																
	,@pa_db_source     VARCHAR(250)  
	,@rowdelimiter     CHAR(4) =     '*|~*'    
	,@coldelimiter     CHAR(4) =     '|*~|'    
	,@pa_errmsg        VARCHAR(8000) output  
)																																			   
AS
BEGIN

DELETE FROM TMP_SOH_SOURCE
DECLARE @@SSQL VARCHAR(8000)
,@@DP_ID VARCHAR(8)
,@@TRX_DT DATETIME
SET @@SSQL = 'BULK INSERT TMP_SOH_SOURCE FROM ''' + @pa_db_source +  ''' WITH
                 (
                   FIELDTERMINATOR=''\n'',
                   ROWTERMINATOR = ''\n''  
                 )'
EXEC(@@SSQL)
UPDATE TMP_SOH_SOURCE SET VALUE = LTRIM(RTRIM(VALUE))

TRUNCATE TABLE TMP_SOH_MSTR

SELECT TOP 1 @@DP_ID =   SUBSTRING(VALUE,3,8),@@TRX_DT = CONVERT(DATETIME,(SUBSTRING(VALUE,15,2) + '/' + SUBSTRING(VALUE,17,2) + '/' + SUBSTRING(VALUE,11,4))) FROM TMP_SOH_SOURCE WHERE VALUE LIKE '01%'


INSERT INTO TMP_SOH_MSTR
(
TMPSOH_DP_ID,
TMPSOH_TRANX_DT,
TMPSOH_BR_CD,
TMPSOH_BENF_ACCT_NO,
TMPSOH_BENF_CAT,
TMPSOH_ISIN,
TMPSOH_BENF_ACCT_TYP,
TMPSOH_BENF_ACCT_POS,
TMPSOH_CC_ID,
TMPSOH_MKT_TYPE,
TMPSOH_SETM_NO,
TMPSOH_BLK_LOCK_FLG,
TMPSOH_BLK_LOCK_CD,
TMPSOH_LOCK_REL_DT,
TMPSOH_FILLER
)
SELECT @@DP_ID
      ,@@TRX_DT
      ,SUBSTRING(value,12,6)
      ,SUBSTRING(value,18,8)
      ,SUBSTRING(value,26,2)
      ,SUBSTRING(value,28,12)
      ,SUBSTRING(value,40,2)
      ,ABS(SUBSTRING(value,42,15))/1000
      ,SUBSTRING(value,57,8)
      ,SUBSTRING(value,65,2)
      ,SUBSTRING(value,67,7)
      ,SUBSTRING(value,74,1)
      ,SUBSTRING(value,75,2)
      ,SUBSTRING(value,77,8)
      ,SUBSTRING(value,85,14)
FROM TMP_SOH_SOURCE WHERE VALUE NOT LIKE '01%'

SET @@DP_ID=''
SET @@TRX_DT=''
END

GO
