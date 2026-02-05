-- Object: PROCEDURE citrus_usr.spPOAStatus_new
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

create proc spPOAStatus_new (  
@partyCode as varchar(20)  
)  
as  
SELECT NISE_PARTY_CODE 'PARTY_CODE',T.CLIENT_CODE 'DP_ID',STATUS ACCOUNT_STATUS,(CASE WHEN ISNULL(POA_VER,'')IN (1,2) THEN 'YES' ELSE 'NO' END) AS POA_STATUS
 FROM Tbl_Client_Master t
 LEFT OUTER JOIN 
 TBL_CLIENT_POA P ON T.CLIENT_CODE=P.CLIENT_CODE AND MASTER_POA ='2203320000000014' AND POA_STATUS ='A'
 AND HOLDER_INDI ='1'
 WHERE NISE_PARTY_CODE=@partyCode

GO
