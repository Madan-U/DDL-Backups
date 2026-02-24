-- Object: PROCEDURE dbo.Insproc_07022020
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Procedure [dbo].[Insproc]  @Settno  Varchar (7) , @Sett_Type Char(3)  As      
      
Exec Delpositionup  @Settno, @Sett_Type, '', ''        
Delete From  msajag.dbo.Deliveryclt Where Sett_No = @Settno And Sett_Type =  @Sett_Type        
      
--Delete From Deliveryclt_Report Where Sett_No = @Settno And Sett_Type =  @Sett_Type        
    
Insert Into msajag.dbo.Deliveryclt       
Select  Sett_No , Sett_Type , Scrip_Cd , Series , Party_Code, Sum(Pqty) 'Tradeqty', Inout = 'O', 'Ho' , Partipantcode  ,''    
From Delpos Where Sett_No = @Settno And Sett_Type =  @Sett_Type       
Group By Sett_No , Sett_Type , Scrip_Cd , Series , Party_Code, Partipantcode      
Having Sum(Pqty) > 0      
      
Insert Into msajag.dbo.Deliveryclt       
Select  Sett_No , Sett_Type , Scrip_Cd , Series , Party_Code, Sum(Sqty) 'Tradeqty', Inout = 'I', 'Ho' , Partipantcode   ,''       
From Delpos Where Sett_No = @Settno And Sett_Type =  @Sett_Type      
Group By Sett_No , Sett_Type , Scrip_Cd , Series , Party_Code, Partipantcode      
Having Sum(Sqty) > 0

GO
