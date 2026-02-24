-- Object: PROCEDURE dbo.Usp_Update_Client_IT
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Proc [dbo].[Usp_Update_Client_IT](@PanNo as varchar(10),@partycode as varchar(15))              
as              
set XACT_ABORT on    
                   
begin tran           
Update Client_details set pan_gir_no = @panNo where Party_code = @partycode         
Update ABVSKYCMIS.kyc.dbo.hist_Ucc_Mismatch set Pan_no = @panNo where Party_code = @partycode         
commit

GO
