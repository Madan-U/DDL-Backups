-- Object: VIEW dbo.Vw_Acc_Curr_Bal_test
-- Server: 10.253.33.231 | DB: inhouse
--------------------------------------------------

CREATE VIEW [dbo].[Vw_Acc_Curr_Bal_test]    
    
AS    
    
SELECT * FROM  DMAT.CITRUS_USR.Vw_Acc_Curr_Bal_Test WITH(NOLOCK)

GO
