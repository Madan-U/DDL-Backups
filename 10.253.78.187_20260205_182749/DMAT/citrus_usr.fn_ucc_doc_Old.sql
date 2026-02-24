-- Object: FUNCTION citrus_usr.fn_ucc_doc_Old
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------



create function [citrus_usr].[fn_ucc_doc_Old] (@pa_dpam_id    NUMERIC    
                          ,@pa_accd_cd    VARCHAR(20)    
                          ,@pa_exch       CHAR(20)      
                          )    
RETURNS VARCHAR(8000)    
AS    
BEGIN    
--    
  DECLARE @l_accd_accdocm_cd      VARCHAR(22)    
        , @l_accd_doc_path        VARCHAR(8000)   
        ,@l_ACCD_lst_upd_DT varchar(100) 
  --          
  --SELECT DISTINCT @l_accd_doc_path     = accd_doc_path    
  --FROM   account_documents    
  --     , account_document_mstr     
  --WHERE  accdocm_cd       = @pa_accd_cd    
  --and    accd_accdocm_doc_id   = accdocm_doc_id    
  --AND    accd_clisba_id        = @pa_dpam_id    
  --AND    accd_deleted_ind      = 1    
  
	SELECT DISTINCT top 2  @l_accd_doc_path=accd_doc_path   ,@l_ACCD_lst_upd_DT=ACCD_lst_upd_DT  
	FROM   ACCD_HST    
	, account_document_mstr     
	WHERE  accdocm_cd       = 'SIGN_BO'    
	and    accd_accdocm_doc_id   = accdocm_doc_id    
	AND    accd_clisba_id        = @pa_dpam_id    
	AND    accd_deleted_ind      = 1 
	--and ACCD_ACTION='E' 
	and ACCD_ACCDOCM_DOC_ID=12
	order by ACCD_lst_upd_DT desc,accd_doc_path    
  --    
  RETURN ISNULL(CONVERT(VARCHAR(8000), @l_accd_doc_path),'')    
             
           
--    
END

GO
