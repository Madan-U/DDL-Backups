-- Object: FUNCTION citrus_usr.FN_UCCMAP_DETAILS_UCCDIS
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------




CREATE   FUNCTION [citrus_usr].[FN_UCCMAP_DETAILS_UCCDIS] (@PA_BOID VARCHAR(16),@PA_MSN VARCHAR(18))
RETURNS VARCHAR(800)
AS
BEGIN
DECLARE @L VARCHAR(800),@PA_TMCODE VARCHAR(20)

SELECT @L=
--+ '<EntIdntfr>' + 'TM'  + '</EntIdntfr>'
+ '<EntIdntfr>' + CASE WHEN DPTDC_COUNTER_CMBP_ID LIKE 'IN6%' THEN 'CP'ELSE  'TM' END  + '</EntIdntfr>'
+ '<Ucc>' + isnull(ltrim(rtrim(CONVERT(CHAR(11),DPTDC_UCC))),'') + '</Ucc>'
+ '<Seg>' + case when isnull(dptdc_ucc,'')='' then '' else isnull(ltrim(rtrim(CONVERT(CHAR(2),DPTDC_SEGID))),'') end + '</Seg>'
+ '<Ucmid>' + isnull(ltrim(rtrim(CONVERT(CHAR(8),DPTDC_CMID ))),'') + '</Ucmid>'
+ '<TM>' + case when DPTDC_COUNTER_CMBP_ID='IN568177'  then 'CP' 
 when DPTDC_COUNTER_CMBP_ID='IN568177'  then 'CP' else isnull(ltrim(rtrim(CONVERT(CHAR(12),DPTDC_TMCMID))),'')  end  + '</TM>'
--+ '<Uexid>' + CASE WHEN DPTDC_EXID='01' THEN '11' WHEN DPTDC_EXID='02' THEN '10' WHEN DPTDC_EXID='12' THEN '11' WHEN DPTDC_EXID='11' THEN '10' ELSE DPTDC_EXID END + '</Uexid>'
+ '<Uexid>' +  case when ISNULL(dptdc_ucc,'')='' then '' else  DPTDC_EXID  end + '</Uexid>'
+ '<EPidntfr>' +  case when DPTDC_COUNTER_CMBP_ID='IN609492'  then 'Y' else '' end   + '</EPidntfr>'

+ '<CuspaTxn>' + IsNull(DPTDC_CUSPA_FLG,'') + '</CuspaTxn>'
+ '<CuspaID>' + case when IsNull(DPTDC_CUSPA_FLG,'')='Y' then isnull(DPTDC_CUSPA_CMBP_DPID,'') + isnull(DPTDC_CUSPA_CLTID,'') else '' End + '</CuspaID>'

FROM DP_TRX_DTLS_CDSL,dp_acct_mstr WHERE dpam_id=DPTDC_DPAM_ID and DPAM_DELETED_IND=1 and  DPAM_SBA_NO=@PA_BOID
and convert(varchar,DPTDC_ID)=@PA_MSN
RETURN @L
END

--+'<PldgIdntfr>MP</PldgIdntfr>'

GO
