-- Object: FUNCTION citrus_usr.FN_UCCMAP_DETAILS_MR
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------


--arathi
CREATE  FUNCTION [citrus_usr].[FN_UCCMAP_DETAILS_MR] (@PA_BOID VARCHAR(16),@PA_MSN VARCHAR(18))
RETURNS VARCHAR(800)
AS
BEGIN
DECLARE @L VARCHAR(800),@PA_TMCODE VARCHAR(20)
SELECT  @PA_TMCODE=CONVERT(VARCHAR,BITRM_BIT_LOCATION) FROM BITMAP_REF_MSTR WHERE BITRM_PARENT_CD='TM_CODE_DEF'
SELECT @L=
'<Xchg>' + ltrim(rtrim(CONVERT(CHAR(2),PLDTCM_EXID))) + '</Xchg>'
+ '<Ucc>' + ltrim(rtrim(CONVERT(CHAR(11),PLDTCM_UCC))) + '</Ucc>'
+ '<Seg>' + case when ltrim(rtrim(CONVERT(CHAR(2),PLDTCM_SEGID)))='01' then 'CM' 
when ltrim(rtrim(CONVERT(CHAR(2),PLDTCM_SEGID)))='02' then 'FO' 
when ltrim(rtrim(CONVERT(CHAR(2),PLDTCM_SEGID)))='03' then 'CD' 
when ltrim(rtrim(CONVERT(CHAR(2),PLDTCM_SEGID)))='04' then 'DT' 
when ltrim(rtrim(CONVERT(CHAR(2),PLDTCM_SEGID)))='05' then 'CO' 
when ltrim(rtrim(CONVERT(CHAR(2),PLDTCM_SEGID)))='06' then 'SB' 
else ltrim(rtrim(CONVERT(CHAR(2),PLDTCM_SEGID))) end 
 + '</Seg>'
--+ '<Clr>' + CASE WHEN PLDTCM_EXID='12' THEN '11' ELSE '10' END + '</Clr>'
+ '<Clr>' + CASE WHEN PLDTCM_EXID='01' THEN '11' WHEN PLDTCM_EXID='02' THEN '10' WHEN PLDTCM_EXID='12' THEN '11' WHEN PLDTCM_EXID='11' THEN '10' ELSE PLDTCM_EXID END + '</Clr>'
+ '<Mmb>' + ltrim(rtrim(CONVERT(CHAR(8),PLDTCM_CMID ))) + '</Mmb>'
+ '<TM>' + ltrim(rtrim(CONVERT(CHAR(12),PLDTCM_TMCMID)))  + '</TM>'
+ '<EntIdntfr>' + ltrim(rtrim(CONVERT(CHAR(2),PLDTCM_EID)))  + '</EntIdntfr>'
+ '<MarPsn>' + ltrim(rtrim(CONVERT(CHAR(8),PLDTCM_PSN))) + '</MarPsn>'
FROM cdsl_marginpledge_dtls WHERE pldtcm_id=@PA_MSN
--BOID='1205560000000085' AND TM_CODE=@PA_TMCODE
RETURN @L
END

GO
