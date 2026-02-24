-- Object: VIEW citrus_usr.NXT_DP_CLIENT_INFO
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE VIEW NXT_DP_CLIENT_INFO   
AS  
SELECT T.NISE_PARTY_CODE AS CLIENT_ID,FIRST_HOLD_NAME,T.CLIENT_CODE  AS DPID ,POA_VER,ACTIVE_DATE,BROM_DESC AMC_SCHEME,  
DP_LEDGER =Actual_amount, accrual_CHARGES=Accrual_bal , account_status=STATUS, Client_Sub_Type=SUB_TYPE,  
Date_of_Birth=BO_DOB,Nominee= ISNULL(LTRIM(RTRIM(NAME)),'')+' '+ISNULL(LTRIM(RTRIM(MiddleName)),'') +' '+ISNULL(LTRIM(RTRIM(SearchName)),'')  
FROM TBL_CLIENT_MASTER T  
LEFT OUTER JOIN  
vw_get_next_amcdt A ON T.CLIENT_CODE=A.Client_code  
LEFT OUTER JOIN Nominee ON BOID=T.CLIENT_CODE   
LEFT OUTER JOIN citrus_usr.Vw_Acc_Curr_Bal  B ON B.CLIENT_CODE =T.CLIENT_CODE

GO
