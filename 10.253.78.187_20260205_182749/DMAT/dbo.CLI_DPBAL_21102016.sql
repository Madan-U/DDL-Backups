-- Object: PROCEDURE dbo.CLI_DPBAL_21102016
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE PROC CLI_DPBAL (@CLTCODE VARCHAR(10))  
AS  
SELECT PARTY_CODE,V.CLIENT_CODE,'0' AS AMC_DUE,'NA' AS AMCDATE,Actual_amount AS DP_LEDGER,  
Accrual_bal   
FROM  tbl_client_master t,  
citrus_usr.Vw_Acc_Curr_Bal   v  
where T.client_code= V.CLIENT_CODE   
AND NISE_PARTY_CODE = @CLTCODE

GO
