-- Object: FUNCTION citrus_usr.FN_UCCMAP_DETAILS_EDIS
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------


CREATE  FUNCTION [citrus_usr].[FN_UCCMAP_DETAILS_EDIS] (@PA_BOID VARCHAR(16),@PA_MSN VARCHAR(18))
RETURNS VARCHAR(800)
AS
BEGIN
DECLARE @L VARCHAR(800),@PA_TMCODE VARCHAR(20)
--SELECT  @PA_TMCODE=CONVERT(VARCHAR,BITRM_BIT_LOCATION) FROM BITMAP_REF_MSTR WHERE BITRM_PARENT_CD='TM_CODE_DEF'
SELECT @L=
+ '<EntIdntfr>' + 'TM'  + '</EntIdntfr>'
+ '<Ucc>' + ltrim(rtrim(CONVERT(CHAR(11),CUDM_UCC))) + '</Ucc>'
--+ '<Seg>' + case when ltrim(rtrim(CONVERT(CHAR(2),PLDTCM_SEGID)))='01' then 'CM' 
--when ltrim(rtrim(CONVERT(CHAR(2),PLDTCM_SEGID)))='02' then 'FO' 
--when ltrim(rtrim(CONVERT(CHAR(2),PLDTCM_SEGID)))='03' then 'CD' 
--when ltrim(rtrim(CONVERT(CHAR(2),PLDTCM_SEGID)))='04' then 'DT' 
--when ltrim(rtrim(CONVERT(CHAR(2),PLDTCM_SEGID)))='05' then 'CO' 
--when ltrim(rtrim(CONVERT(CHAR(2),PLDTCM_SEGID)))='06' then 'SB' 
--else ltrim(rtrim(CONVERT(CHAR(2),PLDTCM_SEGID))) end 
-- + '</Seg>'
--+ '<Clr>' + CASE WHEN PLDTCM_EXID='12' THEN '11' ELSE '10' END + '</Clr>'
+ '<Seg>' + ltrim(rtrim(CONVERT(CHAR(2),CUDM_SEGID))) + '</Seg>'
+ '<Ucmid>' + ltrim(rtrim(CONVERT(CHAR(8),CUDM_CMID ))) + '</Ucmid>'
+ '<TM>' + ltrim(rtrim(CONVERT(CHAR(12),CUDM_TMCD)))  + '</TM>'
+ '<Uexid>' + CASE WHEN CUDM_EXID='01' THEN '11' WHEN CUDM_EXID='02' THEN '10' WHEN CUDM_EXID='12' THEN '11' WHEN CUDM_EXID='11' THEN '10' 
ELSE CUDM_EXID END + '</Uexid>'
FROM CDSL_UCC_DTLS_MSTR WHERE  CUDM_BOID=@PA_BOID
and CUDM_EXID='01'
and CUDM_SEGID='01'
RETURN @L
END

--+'<PldgIdntfr>MP</PldgIdntfr>'

GO
