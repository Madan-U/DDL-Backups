-- Object: PROCEDURE citrus_usr.pr_select_Tpin
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------


--Exec pr_upd_dp '10|*~|NSDL|*~|12033300|*~|1203330000009190|*~|430001|*~|1234|*~|0001|*~|*|~*10|*~|NSDL|*~|12033300|*~|1203330000009191|*~|430002|*~|1234|*~|0002|*~|*|~*','HO','*|~*','|*~|',''  
create PROCEDURE [citrus_usr].[pr_select_Tpin](@pa_cd varchar(800)
                         ,@pa_ref_cur       varchar(8000) OUTPUT  
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
Select * from TPIN_RESPONSE_MSTR where TPM_BATCHNO=@pa_cd
--    
END

GO
