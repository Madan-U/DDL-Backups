-- Object: PROCEDURE dbo.ALL_SB_DETAILS_CLIENT_cODE
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

        
        
CREATE PROCEDURE [dbo].[ALL_SB_DETAILS_CLIENT_cODE]        
        
AS         
BEGIN         
select SBTAG,PARENTTAG,TRADENAME,SBNAME,CONSTITUTION,BRANCH,TAGGENERATEDDATE,panno,CONTACTPERSON,SBTYPE,IsActive,IsActiveDate       
     
 from [MIS].sb_comp.dbo. sb_brokerView_REPORT B with(nolock)        
         
 
         
 END

GO
