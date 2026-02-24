-- Object: PROCEDURE dbo.DELHOLDINGASONDATE_Settno
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROC [dbo].[DELHOLDINGASONDATE_Settno]            
(                                
      @Sett_No Varchar(7),    
      @Sett_Type Varchar(2),     
      @IsIn Varchar(12)            
)                                 
AS            
Select SETT_NO = D.Sett_No, SETT_TYPE = D.Sett_Type,   
Party_Code, Scrip_CD, D.SERIES, CertNo, Qty=Sum(Qty), CLTDPID  
From DelTrans_Report D  
Where Sett_No = @Sett_No    
And Sett_Type = @Sett_Type  
And Filler2 = 1            
And DrCr = 'C'            
And CertNo = @IsIn            
And ( Reason Like 'EARLY%' or Filler1 Like 'EARLY%' )  
AND BDPTYPE = 'CDSL'  
Group by D.Sett_No, D.Sett_Type, Party_Code, Scrip_CD, D.SERIES, CertNo, CLTDPID

GO
