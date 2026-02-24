-- Object: PROCEDURE dbo.Spx_Delete_SCHEME_MAPPING_CI
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


-- exec Spx_Delete_SCHEME_MAPPING_CI 'A123,B123,sdf234'
CREATE proc Spx_Delete_SCHEME_MAPPING_CI
(
 @KYC_Party_Code varchar(max)
)

As
begin
 
  Create table #KYC_Application(Party_Code varchar(12))    
  
 Insert into #KYC_Application(Party_Code)    
  Select items from dbo.Ci_Split(@KYC_Party_Code,',')     
 
 delete from SCHEME_MAPPING_CI where  SP_Party_Code
 in
 (
  Select Party_Code from #KYC_Application
 )

 
end

GO
