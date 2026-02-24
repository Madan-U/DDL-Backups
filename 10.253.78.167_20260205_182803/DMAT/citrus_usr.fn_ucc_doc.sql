-- Object: FUNCTION citrus_usr.fn_ucc_doc
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_ucc_doc] (@pa_dpam_id    NUMERIC  
                          ,@pa_accd_cd    VARCHAR(20)  
                          ,@pa_exch       CHAR(20)    
                          )  
RETURNS VARCHAR(8000)  
AS  
BEGIN  
--  
  DECLARE @l_accd_accdocm_cd      VARCHAR(22)  
        , @l_accd_doc_path        VARCHAR(8000)  
  --        
  SELECT DISTINCT @l_accd_doc_path     = accd_doc_path  
  FROM   account_documents  
       , account_document_mstr   
  WHERE  accdocm_cd       = @pa_accd_cd  
  and    accd_accdocm_doc_id   = accdocm_doc_id  
  AND    accd_clisba_id        = @pa_dpam_id  
  AND    accd_deleted_ind      = 1  
  --  
  RETURN ISNULL(CONVERT(VARCHAR(8000), @l_accd_doc_path),'')  
           
   
 --RETURN ISNULL(CONVERT(VARCHAR(50), @l_entp_value),'')    
--  
END

GO
