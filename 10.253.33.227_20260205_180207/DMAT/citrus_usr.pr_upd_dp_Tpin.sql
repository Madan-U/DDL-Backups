-- Object: PROCEDURE citrus_usr.pr_upd_dp_Tpin
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------


--Exec pr_upd_dp '10|*~|NSDL|*~|12033300|*~|1203330000009190|*~|430001|*~|1234|*~|0001|*~|*|~*10|*~|NSDL|*~|12033300|*~|1203330000009191|*~|430002|*~|1234|*~|0002|*~|*|~*','HO','*|~*','|*~|',''  
Create PROCEDURE [citrus_usr].[pr_upd_dp_Tpin](@pa_login_name   varchar(20)                       
                         ,@rowdelimiter    char(4)      = '*|~*'  
                         ,@coldelimiter    char(4)      = '|*~|'  
                         ,@pa_errmsg       varchar(8000) OUTPUT  
                         )  
AS  
/*  
********************************************************************************  
 SYSTEM         : DMAT  
 MODULE NAME    : pr_upd_dp_TPIN  
 DESCRIPTION    : THIS PROCEDURE WILL READ RESPONSE TPIN FILE
 COPYRIGHT(C)   : MARKETPLACE TECHNOLOGIES PVT. LTD.  
 VERSION HISTORY: 1.0  
 VERS.  AUTHOR            DATE          REASON  
 -----  -------------     ------------  ----------------------------------------  
 2.0    LATESH P WANI     25-MAY-2020   2.0.  
 -------------------------------------------------------------------------------  
********************************************************************************  
*/  
--  
BEGIN  
--    
INSERT INTO TPIN_RESPONSE_MSTR
SELECT *,@pa_login_name,GETDATE(),@pa_login_name,GETDATE(),1 FROM TMP_TPIN_RESPONSE O WHERE NOT EXISTS
(
SELECT 1 FROM TPIN_RESPONSE_MSTR I WHERE I.TPM_BATCHNO=O.TPM_BATCHNO
)

Select  top 1 @pa_errmsg =TPM_BATCHNO from TMP_TPIN_RESPONSE
--    
END

GO
