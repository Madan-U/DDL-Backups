-- Object: PROCEDURE dbo.Usp_Update_ClientDet
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Proc [dbo].[Usp_Update_ClientDet](@clientcode as varchar(15),@clientname as varchar(50),@PanNo as varchar(10),@val as varchar(5))      
as      
  
set nocount on  
set  XACT_ABORT on  
    
begin tran    
update Client_details set addemailid = @clientname,pan_gir_no = @PanNo where party_code = @clientcode    
if @val = 'Pan'
begin
	delete from Intranet.risk.dbo.hist_Pan_MismatchReport where Party_code = @clientcode    
end
else
begin 
	delete from ABVSKYCMIS.kyc.dbo.hist_Ucc_Mismatch where Party_code = @clientcode    
end
commit    
  
set nocount off

GO
