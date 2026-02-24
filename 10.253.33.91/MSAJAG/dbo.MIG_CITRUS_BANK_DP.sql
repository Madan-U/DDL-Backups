-- Object: PROCEDURE dbo.MIG_CITRUS_BANK_DP
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

    
CREATE PROC [dbo].[MIG_CITRUS_BANK_DP]    
AS    
    
    
EXEC PR_MIG_CITRUS_MULTIBANK_UPD    
    
EXEC PR_MIG_CITRUS_MULTIDP_UPD    
  
EXEC ABVSCITRUS.CRMDB_A.DBO.PR_AUTO_DATA_POP_SCAN_PHY

GO
