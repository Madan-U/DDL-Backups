-- Object: FUNCTION citrus_usr.fn_ucc_doc_mod
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------



create function [citrus_usr].[fn_ucc_doc_mod] (@pa_dpam_id    NUMERIC  
                          ,@pa_accd_cd    VARCHAR(20)  
                          ,@pa_exch       CHAR(20)    
                          ,@pa_formdt	  varchar(20)
                          ,@pa_todt		  varchar(20)
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
       , client_list_modified
       , dp_acct_mstr  
  WHERE  accdocm_cd       = @pa_accd_cd  
  and    accd_accdocm_doc_id   = accdocm_doc_id  
  AND    accd_clisba_id        = @pa_dpam_id  
  AND    accd_deleted_ind      = 1  
  AND    clic_mod_lst_upd_dt   BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_formdt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_todt,103),106)+' 23:59:59'   
  AND	 clic_mod_action in ('Signature') 
  and    clic_mod_deleted_ind = 1
  and    DPAM_SBA_NO = clic_mod_dpam_sba_no
  and    DPAM_ID = accd_clisba_id
  --  
  RETURN ISNULL(CONVERT(VARCHAR(8000), @l_accd_doc_path),'')  
           
   
 --RETURN ISNULL(CONVERT(VARCHAR(50), @l_entp_value),'')    
--  
END

GO
