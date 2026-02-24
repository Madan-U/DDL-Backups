-- Object: PROCEDURE dbo.USP_GetClientDRFDPAccountDetails
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

  
CREATE PROCEDURE USP_GetClientDRFDPAccountDetails @ClientDPId VARCHAR(50)=''  
AS  
BEGIN  
INSERT INTO [172.31.16.94].DMAT.dbo.ClientDRFDPAccountDetails  
select NISE_PARTY_CODE,CLIENT_CODE 'ClientDPId' from [citrus_usr].TBL_CLIENT_MASTER WITH(NOLOCK) 
--where isnull(CLIENT_CODE,'')=@ClientDPId  
WHERE ISNULL(CLIENT_CODE,'') like '%'+@ClientDPId+''   
END

GO
