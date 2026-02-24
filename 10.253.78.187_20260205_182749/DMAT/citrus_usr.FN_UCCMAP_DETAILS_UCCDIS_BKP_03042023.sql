-- Object: FUNCTION citrus_usr.FN_UCCMAP_DETAILS_UCCDIS_BKP_03042023
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------





CREATE  FUNCTION [citrus_usr].[FN_UCCMAP_DETAILS_UCCDIS_BKP_03042023] (@PA_BOID VARCHAR(16),@PA_MSN VARCHAR(18))
RETURNS VARCHAR(800)
AS
BEGIN
DECLARE @L VARCHAR(800),@PA_TMCODE VARCHAR(20)

SELECT @L=
+ '<EntIdntfr>' + 'TM'  + '</EntIdntfr>'
+ '<Ucc>' + isnull(ltrim(rtrim(CONVERT(CHAR(11),DPTDC_UCC))),'') + '</Ucc>'
+ '<Seg>' + isnull(ltrim(rtrim(CONVERT(CHAR(2),DPTDC_SEGID))),'') + '</Seg>'
+ '<Ucmid>' + isnull(ltrim(rtrim(CONVERT(CHAR(8),DPTDC_CMID ))),'') + '</Ucmid>'
+ '<TM>' + isnull(ltrim(rtrim(CONVERT(CHAR(12),DPTDC_TMCMID))),'')  + '</TM>'
--+ '<Uexid>' + CASE WHEN DPTDC_EXID='01' THEN '11' WHEN DPTDC_EXID='02' THEN '10' WHEN DPTDC_EXID='12' THEN '11' WHEN DPTDC_EXID='11' THEN '10' ELSE DPTDC_EXID END + '</Uexid>'
+ '<Uexid>' + isnull(DPTDC_EXID,'') + '</Uexid>'
FROM DP_TRX_DTLS_CDSL,dp_acct_mstr WHERE dpam_id=DPTDC_DPAM_ID and DPAM_DELETED_IND=1 and  DPAM_SBA_NO=@PA_BOID
and DPTDC_ID=@PA_MSN
RETURN @L
END

--+'<PldgIdntfr>MP</PldgIdntfr>'

GO
