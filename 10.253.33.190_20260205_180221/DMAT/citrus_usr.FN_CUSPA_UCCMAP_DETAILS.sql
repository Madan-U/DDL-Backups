-- Object: FUNCTION citrus_usr.FN_CUSPA_UCCMAP_DETAILS
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------



CREATE  FUNCTION [citrus_usr].[FN_CUSPA_UCCMAP_DETAILS] (@PA_BOID VARCHAR(16),@PA_MSN VARCHAR(18))
RETURNS VARCHAR(800)
AS
BEGIN
DECLARE @L VARCHAR(800),@PA_TMCODE VARCHAR(20)

SELECT @L=
CASE WHEN isnull(PLDTC_CUSPA_FLG,'')='Y' THEN
'<CuspaTxn>' + IsNull(PLDTC_CUSPA_FLG,'') + '</CuspaTxn>'
+'<Ctgry>' + IsNull(PLDTC_CUSPA_TRX_CTGRY,'') + '</Ctgry>'
+'<EPAcct>' + IsNull(PLDTC_CUSPA_EPI,'') + '</EPAcct>'
+'<Sttlm>' + IsNull(PLDTC_CUSPA_SETTLEMENTID,'') + '</Sttlm>'
+'<Brkr>' + IsNull(PLDTC_CUSPA_CMBP_DPID,'') + '</Brkr>'
--+'<Xchg>' + IsNull(PLDTC_EXID,'') + '</Xchg>'
+'<Xchg>' + isnull( CASE WHEN PLDTC_EXID='01' THEN '12' WHEN PLDTC_EXID='02' THEN '11' WHEN PLDTC_EXID='12' THEN '11' WHEN PLDTC_EXID='11' THEN '10' ELSE PLDTC_EXID END,'') + '</Xchg>'
+'<Ucc>' + IsNull(PLDTC_UCC,'') + '</Ucc>'
--+'<Seg>' + IsNull(PLDTC_SEGID,'') + '</Seg>'
+ '<Seg>' +isnull( case when ltrim(rtrim(CONVERT(CHAR(2),PLDTC_SEGID)))='01' then 'CM' 
when ltrim(rtrim(CONVERT(CHAR(2),PLDTC_SEGID)))='02' then 'FO' 
when ltrim(rtrim(CONVERT(CHAR(2),PLDTC_SEGID)))='03' then 'CD' 
when ltrim(rtrim(CONVERT(CHAR(2),PLDTC_SEGID)))='04' then 'DT' 
when ltrim(rtrim(CONVERT(CHAR(2),PLDTC_SEGID)))='05' then 'CO' 
when ltrim(rtrim(CONVERT(CHAR(2),PLDTC_SEGID)))='06' then 'SB' 
else ltrim(rtrim(CONVERT(CHAR(2),PLDTC_SEGID))) end ,'')
 + '</Seg>'
+'<Clr>' + IsNull(PLDTC_CMID,'') + '</Clr>'
+'<Mmb>' + IsNull(PLDTC_CUSPA_FLG,'') + '</Mmb>'
+'<Tm>' + IsNull(PLDTC_TMCMID,'') + '</Tm>'
+'<EntIdntfr>' + IsNull(PLDTC_EID,'') + '</EntIdntfr>'
ELSE
'<CuspaTxn>' + 'N' + '</CuspaTxn>'
END
FROM cdsl_pledge_dtls,dp_acct_mstr WHERE dpam_id=PLDTC_DPAM_ID and DPAM_DELETED_IND=1 and  DPAM_SBA_NO=@PA_BOID
and PLDTC_ID=@PA_MSN

RETURN @L
END

GO
