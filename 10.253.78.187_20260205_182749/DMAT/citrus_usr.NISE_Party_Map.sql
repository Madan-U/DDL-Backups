-- Object: PROCEDURE citrus_usr.NISE_Party_Map
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------


CREATE Proc [citrus_usr].[NISE_Party_Map]
as

begin tran
Update T set NISE_PARTY_CODE=DPAM_BBO_CODE from DP_ACCT_MStr D ,TBL_CLIENT_MASTER T where DPAM_BBO_CODE is not null 
and nise_party_code is null and client_code =DPAM_SBA_NO
--and  DPAM_CREATED_DT >='2021-04-01'   

Update T set CM_BLSAVINGCD=DPAM_BBO_CODE from DP_ACCT_MStr D ,Synergy_Client_Master T where DPAM_BBO_CODE is not null 
and t.CM_BLSAVINGCD is null and CM_CD =DPAM_SBA_NO
--and  DPAM_CREATED_DT >='2021-04-01'    


 UPDATE T SET POA_VER = '2' FROM TBL_CLIENT_MASTER T (Nolock), TBL_CLIENT_POA P  (Nolock)  
				WHERE T.CLIENT_CODE=P.CLIENT_CODE AND HOLDER_INDI =1    
				AND ISNULL(POA_VER,'')= '' AND POA_STATUS ='A'  AND STATUS ='ACTIVE'    
				AND MASTER_POA ='2203320100000010'  AND POA_DATE_FROM >='2021-06-01'   

				commit

GO
