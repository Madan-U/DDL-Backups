-- Object: PROCEDURE citrus_usr.PR_UPDATE_BATCH_RESET
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

 

CREATE  PROCEDURE [citrus_usr].[PR_UPDATE_BATCH_RESET] 
(  
@BOID VARCHAR(20),
@BATCHNO VARCHAR(20)  
)  
AS   


BEGIN   

update DP_ACCT_MSTR set dpam_batch_no = Null where dpam_batch_no = @BATCHNO and DPAM_SBA_NO = @BOID
and DPAM_SBA_NO = DPAM_ACCT_NO  and DPAM_STAM_CD <> 'ACTIVE'

END

GO
