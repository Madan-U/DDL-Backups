-- Object: PROCEDURE citrus_usr.pr_Select_Update_POAType
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------




CREATE PROCEDURE [citrus_usr].[pr_Select_Update_POAType] --'1203320002506009','SELECT',''
@PA_DPAM_SBA_NO VARCHAR(100), 
@PA_ACTION VARCHAR(20), 
@PA_UPD_POA_TYPE VARCHAR(300)    
AS      
BEGIN 


IF @PA_ACTION ='SELECT'
  select isnull(DPPD_POA_TYPE,'')DPPD_POA_TYPE
  ,isnull(DPPD_FNAME,'')DPPD_FNAME
  ,isnull(dppd_master_id,'')dppd_master_id
  from DP_POA_DTLS, dp_acct_mstr
  where dpam_id = DPPD_DPAM_ID
  and dpam_sba_no = @PA_DPAM_SBA_NO
  and DPPD_DELETED_IND = 1
  and DPAM_DELETED_IND = 1
 and dppd_master_id = '2203320100000010'
  and dpam_stam_cd = 'ACTIVE'

ELSE IF @PA_ACTION ='UPDATE'
IF isnull(@PA_DPAM_SBA_NO,'')<>'' 
BEGIN
  UPDATE T SET  DPPD_POA_TYPE = @PA_UPD_POA_TYPE 
  FROM  DP_POA_DTLS T , dp_acct_mstr D                     
  where dpam_sba_no = @PA_DPAM_SBA_NO 
  and dpam_id = DPPD_DPAM_ID
  and DPPD_DELETED_IND = 1  
  and DPAM_DELETED_IND = 1
  and dppd_master_id = '2203320100000010'
END

if @PA_ACTION ='POATYPE_LISTING'
begin
	SELECT BITRM_CHILD_CD,BITRM_CHILD_CD as BITRM_VALUES
	FROM   BITMAP_REF_MSTR 
	WHERE  BITRM_PARENT_CD = 'POA_TYPE'
	AND    BITRM_DELETED_IND = 1 
end

IF @PA_ACTION ='ACCOUNT_VALIDATION'
begin
	select case when LTRIM(RTRIM(ISNULL(DPAM_SBA_NO,''))) = '' then 'NO' ELSE 'YES' END AS validateAcctId FROM DP_ACCT_MSTR
	WHERE DPAM_SBA_NO = @PA_DPAM_SBA_NO
	AND DPAM_STAM_CD = 'ACTIVE'
	AND DPAM_DELETED_IND = '1'

end

END

GO
