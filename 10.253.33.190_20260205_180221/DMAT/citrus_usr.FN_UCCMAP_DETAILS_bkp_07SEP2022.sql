-- Object: FUNCTION citrus_usr.FN_UCCMAP_DETAILS_bkp_07SEP2022
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------



Create   FUNCTION [citrus_usr].[FN_UCCMAP_DETAILS_bkp_07SEP2022] (@PA_BOID VARCHAR(16),@PA_MSN VARCHAR(18))
RETURNS VARCHAR(800)
AS
BEGIN
DECLARE @L VARCHAR(800),@PA_TMCODE VARCHAR(20)
SELECT  @PA_TMCODE=CONVERT(VARCHAR,BITRM_BIT_LOCATION) FROM BITMAP_REF_MSTR WHERE BITRM_PARENT_CD='TM_CODE_DEF'
SELECT @L=
'<Xchg>' + case when ltrim(rtrim(CONVERT(CHAR(2),PLDTCM_EXID)))='01' then '12' when ltrim(rtrim(CONVERT(CHAR(2),PLDTCM_EXID)))='02' then '11' when ltrim(rtrim(CONVERT(CHAR(2),PLDTCM_EXID)))='03' then '29' else  ltrim(rtrim(CONVERT(CHAR(2),PLDTCM_EXID))) end     + '</Xchg>'
+ '<Ucc>' + ltrim(rtrim(CONVERT(CHAR(11),PLDTCM_UCC))) + '</Ucc>'
+ '<Seg>' + case when ltrim(rtrim(CONVERT(CHAR(2),PLDTCM_SEGID)))='01' then 'CM' 
when ltrim(rtrim(CONVERT(CHAR(2),PLDTCM_SEGID)))='02' then 'CD' 
when ltrim(rtrim(CONVERT(CHAR(2),PLDTCM_SEGID)))='03' then 'DT' 
when ltrim(rtrim(CONVERT(CHAR(2),PLDTCM_SEGID)))='04' then 'CO' 
when ltrim(rtrim(CONVERT(CHAR(2),PLDTCM_SEGID)))='05' then 'SB' 
else ltrim(rtrim(CONVERT(CHAR(2),PLDTCM_SEGID))) end 
 + '</Seg>'
+ '<Clr>' + CASE WHEN PLDTCM_EXID='11' THEN '10' WHEN PLDTCM_EXID='12' THEN '11' ELSE PLDTCM_EXID END + '</Clr>'
+ '<Mmb>' + ltrim(rtrim(CONVERT(CHAR(8),PLDTCM_CMID ))) + '</Mmb>'
+ '<TM>' + ltrim(rtrim(CONVERT(CHAR(12),PLDTCM_TMCMID)))  + '</TM>'
+ '<EntIdntfr>' + 'TM'  + '</EntIdntfr>'
--+ '<MarPsn>' + '' + '</MarPsn>'
FROM cdsl_marginpledge_dtls WHERE pldtcm_id=@PA_MSN
--BOID='1205560000000085' AND TM_CODE=@PA_TMCODE
RETURN @L
END

GO
