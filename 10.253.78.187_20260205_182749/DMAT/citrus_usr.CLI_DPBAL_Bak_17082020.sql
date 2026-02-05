-- Object: PROCEDURE citrus_usr.CLI_DPBAL_Bak_17082020
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------


Create PROC [citrus_usr].[CLI_DPBAL_Bak_17082020] (@CLTCODE VARCHAR(10))   
AS   
SELECT PARTY_CODE,V.CLIENT_CODE,'0' AS AMC_DUE,'NA' AS AMCDATE,Actual_amount AS DP_LEDGER,   
Accrual_bal    
FROM  tbl_client_master t,   
citrus_usr.Vw_Acc_Curr_Bal   v   
where T.client_code= V.CLIENT_CODE    
AND NISE_PARTY_CODE = @CLTCODE   
--union  
--SELECT 'j45628','j45628','0' AS AMC_DUE,'NA' AS AMCDATE,0 AS DP_LEDGER,   
--'0'  
      
      
    --CLI_DPBAL 'RP61'

GO
