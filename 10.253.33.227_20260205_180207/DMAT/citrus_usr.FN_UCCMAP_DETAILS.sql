-- Object: FUNCTION citrus_usr.FN_UCCMAP_DETAILS
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--arathi
CREATE  FUNCTION [citrus_usr].[FN_UCCMAP_DETAILS] (@PA_BOID VARCHAR(17),@PA_MSN VARCHAR(18))
RETURNS VARCHAR(800)
AS
BEGIN
DECLARE @L VARCHAR(800),@PA_TMCODE VARCHAR(20)
SELECT  @PA_TMCODE=CONVERT(VARCHAR,BITRM_BIT_LOCATION) FROM BITMAP_REF_MSTR WHERE BITRM_PARENT_CD='TM_CODE_DEF'
IF LEFT(@PA_BOID,1)='N' 
BEGIN
SELECT @L=
--'<Xchg>' + isnull(ltrim(rtrim(CONVERT(CHAR(2),PLDTC_EXID))),'') + '</Xchg>'
--+ '<Ucc>' + isnull(ltrim(rtrim(CONVERT(CHAR(11),PLDTC_UCC))) ,'')+ '</Ucc>'
--+ '<Seg>' +isnull( case when ltrim(rtrim(CONVERT(CHAR(2),PLDTC_SEGID)))='01' then 'CM' 
--when ltrim(rtrim(CONVERT(CHAR(2),PLDTC_SEGID)))='02' then 'FO' 
--when ltrim(rtrim(CONVERT(CHAR(2),PLDTC_SEGID)))='03' then 'CD' 
--when ltrim(rtrim(CONVERT(CHAR(2),PLDTC_SEGID)))='04' then 'DT' 
--when ltrim(rtrim(CONVERT(CHAR(2),PLDTC_SEGID)))='05' then 'CO' 
--when ltrim(rtrim(CONVERT(CHAR(2),PLDTC_SEGID)))='06' then 'SB' 
--else ltrim(rtrim(CONVERT(CHAR(2),PLDTC_SEGID))) end ,'')
-- + '</Seg>'
----+ '<Clr>' + CASE WHEN PLDTCM_EXID='12' THEN '11' ELSE '10' END + '</Clr>'
--+ '<Clr>' +isnull( CASE WHEN PLDTC_EXID='01' THEN '11' WHEN PLDTC_EXID='02' THEN '10' WHEN PLDTC_EXID='12' THEN '11' WHEN PLDTC_EXID='11' THEN '10' ELSE PLDTC_EXID END,'') + '</Clr>'
--+ '<Mmb>' +isnull( ltrim(rtrim(CONVERT(CHAR(8),PLDTC_CMID ))),'') + '</Mmb>'
--+ '<TM>' + isnull(ltrim(rtrim(CONVERT(CHAR(12),PLDTC_TMCMID))),'')  + '</TM>'
--+ '<EntIdntfr>' + isnull(ltrim(rtrim(CONVERT(CHAR(2),PLDTC_EID))),'')  + '</EntIdntfr>'
--+ '<MarPsn>' + '' + '</MarPsn>'
--+ '<Rsn>' + convert(varchar,PLDTCM_REASON) + '</Rsn>'
 '<Rsn>' + isnull(case when convert(varchar(100),PLDTC_REASON_CODE)='Collateral -Debt issuance by Co./Grp Co.' then '1'
                 when convert(varchar(100),PLDTC_REASON_CODE)='Collateral for loan by Company/Group Co.' then '2'
				 when convert(varchar(100),PLDTC_REASON_CODE)='Collateral for loan by the Third Party' then '3'
				 when convert(varchar(100),PLDTC_REASON_CODE)='Margin Pledge/MTF for Exchange Trade' then '4'
				 when convert(varchar(100),PLDTC_REASON_CODE)='Personal use by promoters and PACs' then '5'
				 when convert(varchar(100),PLDTC_REASON_CODE)='COLLATERAL FOR SELF LOAN' then '6' 
				  else '' end,'')
+ '</Rsn>'
+ '<Poa>' + case when isnull(PLDTC_REASON_CODE,'')<>'' then isnull(convert(varchar(16),MasterPOAId),'') else ''  end + '</Poa>'

FROM cdsl_pledge_dtls ,dp_acct_mstr left outer join dps8_pc5 on DPAM_SBA_NO=boid and TypeOfTrans in ('','1')  WHERE pldtc_id=@PA_MSN
and PLDTC_DPAM_ID=dpam_id  
END
ELSE
BEGIN
SELECT @L=
'<Xchg>' + isnull(ltrim(rtrim(CONVERT(CHAR(2),PLDTCM_EXID))),'') + '</Xchg>'
+ '<Ucc>' + isnull(ltrim(rtrim(CONVERT(CHAR(11),PLDTCM_UCC))) ,'')+ '</Ucc>'
+ '<Seg>' +isnull( case when ltrim(rtrim(CONVERT(CHAR(2),PLDTCM_SEGID)))='01' then 'CM' 
when ltrim(rtrim(CONVERT(CHAR(2),PLDTCM_SEGID)))='02' then 'FO' 
when ltrim(rtrim(CONVERT(CHAR(2),PLDTCM_SEGID)))='03' then 'CD' 
when ltrim(rtrim(CONVERT(CHAR(2),PLDTCM_SEGID)))='04' then 'DT' 
when ltrim(rtrim(CONVERT(CHAR(2),PLDTCM_SEGID)))='05' then 'CO' 
when ltrim(rtrim(CONVERT(CHAR(2),PLDTCM_SEGID)))='06' then 'SB' 
else ltrim(rtrim(CONVERT(CHAR(2),PLDTCM_SEGID))) end ,'')
 + '</Seg>'
--+ '<Clr>' + CASE WHEN PLDTCM_EXID='12' THEN '11' ELSE '10' END + '</Clr>'
+ '<Clr>' +isnull( CASE WHEN PLDTCM_EXID='01' THEN '11' WHEN PLDTCM_EXID='02' THEN '10' WHEN PLDTCM_EXID='12' THEN '11' WHEN PLDTCM_EXID='11' THEN '10' ELSE PLDTCM_EXID END,'') + '</Clr>'
+ '<Mmb>' +isnull( ltrim(rtrim(CONVERT(CHAR(8),PLDTCM_CMID ))),'') + '</Mmb>'
+ '<TM>' + isnull(ltrim(rtrim(CONVERT(CHAR(12),PLDTCM_TMCMID))),'')  + '</TM>'
+ '<EntIdntfr>' + isnull(ltrim(rtrim(CONVERT(CHAR(2),PLDTCM_EID))),'')  + '</EntIdntfr>'
+ '<MarPsn>' + '' + '</MarPsn>'
--+ '<Rsn>' + convert(varchar,PLDTCM_REASON) + '</Rsn>'
+ '<Rsn>' + isnull(case when convert(varchar(100),PLDTCM_REASON_CODE)='Collateral -Debt issuance by Co./Grp Co.' then '1'
                 when convert(varchar(100),PLDTCM_REASON_CODE)='Collateral for loan by Company/Group Co.' then '2'
				 when convert(varchar(100),PLDTCM_REASON_CODE)='Collateral for loan by the Third Party' then '3'
				 when convert(varchar(100),PLDTCM_REASON_CODE)='Margin Pledge/MTF for Exchange Trade' then '4'
				 when convert(varchar(100),PLDTCM_REASON_CODE)='Personal use by promoters and PACs' then '5' else '' end,'')
+ '</Rsn>'
+ '<Poa>' + isnull(convert(varchar(16),MasterPOAId),'') + '</Poa>'

FROM cdsl_marginpledge_dtls ,dp_acct_mstr,dps8_pc5  WHERE pldtcm_id=@PA_MSN
and PLDTCM_DPAM_ID=dpam_id and DPAM_SBA_NO=boid and TypeOfTrans in ('','1')
END
--BOID='1205560000000085' AND TM_CODE=@PA_TMCODE
RETURN @L
END

GO
