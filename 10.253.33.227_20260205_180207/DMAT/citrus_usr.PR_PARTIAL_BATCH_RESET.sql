-- Object: PROCEDURE citrus_usr.PR_PARTIAL_BATCH_RESET
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------



CREATE PROCEDURE [citrus_usr].[PR_PARTIAL_BATCH_RESET] --3,76,'MANUAL'
(  
@DPAM_ID INTEGER,
@PA_BATCHNO VARCHAR(20),  
@PA_RESETTYPE  VARCHAR(6),
@Formno VARCHAR(20)    
--@PA_ERRMSG     VARCHAR(8000) OUTPUT    
)  
AS   


BEGIN   
  
IF @PA_RESETTYPE='MANUAL'  
BEGIN	
IF @Formno <> ''
	select  DPAM_SBA_NO,DPAM_SBA_NAME,dpam_batch_no  from DP_ACCT_MSTR   where  dpam_batch_no = @PA_BATCHNO and DPAM_ACCT_NO = @Formno and DPAM_EXCSM_ID = @DPAM_ID
	and DPAM_SBA_NO = DPAM_ACCT_NO  and DPAM_STAM_CD <> 'ACTIVE'
Else

 select  DPAM_SBA_NO,DPAM_SBA_NAME,dpam_batch_no  from DP_ACCT_MSTR   where  dpam_batch_no = @PA_BATCHNO  and DPAM_EXCSM_ID = @DPAM_ID
 and DPAM_SBA_NO = DPAM_ACCT_NO  and DPAM_STAM_CD <> 'ACTIVE'
END  
ELSE IF  @PA_RESETTYPE='AUTO'
  BEGIN		
 select  DPAM_SBA_NO,DPAM_SBA_NAME,dpam_batch_no  from DP_ACCT_MSTR   where  dpam_batch_no = @PA_BATCHNO  and DPAM_EXCSM_ID = @DPAM_ID
 and DPAM_SBA_NO = DPAM_ACCT_NO  and DPAM_STAM_CD <> 'ACTIVE'
END 
  
  

END

GO
