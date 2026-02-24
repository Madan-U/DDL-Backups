-- Object: PROCEDURE dbo.spPOAStatus
-- Server: 10.253.33.231 | DB: DMAT
--------------------------------------------------


CREATE proc [dbo].[spPOAStatus] (  

@partyCode as varchar(20)  

)  

as  

--return 0



SELECT NISE_PARTY_CODE 'PARTY_CODE',CLIENT_CODE 'DP_ID',STATUS,POA_VER

 FROM Tbl_Client_Master(nolock) WHERE NISE_PARTY_CODE=@partyCode

GO
