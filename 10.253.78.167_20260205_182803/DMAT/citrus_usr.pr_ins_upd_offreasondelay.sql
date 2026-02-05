-- Object: PROCEDURE citrus_usr.pr_ins_upd_offreasondelay
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------


create PROCEDURE  [citrus_usr].[pr_ins_upd_offreasondelay]( 
									@PA_ID  VARCHAR(800)                          
                                   ,@PA_ACTION         VARCHAR(100)     
								   ,@PA_RMKS         VARCHAR(100)   
                                   ,@PA_REF_CUR        VARCHAR(8000) OUT                          
                                  )                          
AS                        
/*                        
*********************************************************************************                        
 SYSTEM         : DP                        
 MODULE NAME    : PR_SELECT_MSTR                        
 DESCRIPTION    : THIS PROCEDURE WILL CONTAIN THE SELECT SAVE QUERIES FOR NSDL PAY DETAILS TABLES                        
 COPYRIGHT(C)   : MARKETPLACE TECHNOLOGIES                         
 VERSION HISTORY: 1.0                        
 VERS.  AUTHOR            DATE          REASON                        
 -----  -------------     ------------  --------------------------------------------------                        
 1.0    LATESH P WANI            26-SEP-2025   VERSION.                        
-----------------------------------------------------------------------------------*/                        
BEGIN                        
--     

--DECLARE @BOID VARCHAR(16)
--SELECT @BOID = DPAM_SBA_NO from dptdc_mak,DP_ACCT_MSTR with(nolock) where (dptdc_id=@pa_id or dptdc_dtls_id=@pa_id) and DPTDC_DELETED_IND in (-1,0,4,6) AND DPAM_ID=DPTDC_DPAM_ID

DECLARE @L_AMT TABLE(AMT VARCHAR(1000))



DECLARE @L_SDRATE VARCHAR(10),@L_SDCALC VARCHAR(20)

,@L_OS VARCHAR,@L_TRATM_ID NUMERIC,@L_FIN_ID NUMERIC,@L_LEDGERTBL VARCHAR(100),@L_SQL VARCHAR(800)


IF (@PA_ACTION='SELECT')
BEGIN
SELECT *,TBLOMR_REMARKS as txtreadel FROM TBL_OFFMARKETREASON WHERE TBLOMR_SLIPNO=@PA_ID AND TBLOMR_DELETED_IND=1
END

IF (@PA_ACTION='INS')
BEGIN
DELETE FROM TBL_OFFMARKETREASON WHERE TBLOMR_SLIPNO=@PA_ID AND TBLOMR_DELETED_IND=1
INSERT INTO TBL_OFFMARKETREASON
SELECT @PA_ID,@PA_RMKS,'MIG',GETDATE(),'MIG',GETDATE(),1

END

 END

GO
