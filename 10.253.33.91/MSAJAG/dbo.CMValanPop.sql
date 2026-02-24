-- Object: PROCEDURE dbo.CMValanPop
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Proc CMValanPop As  
Declare   
@@Sett_No Varchar(7),  
@@Sett_Type Varchar(2),  
@@SettCur Cursor   
Set @@SettCur = Cursor For  
 Select Distinct Sett_No,Sett_Type From Settlement   
 Where Sauda_date >= 'APR  1 2005' And Sauda_date <= 'MAR 31 2007 23:59:59'
 And Sett_Type = 'A'  
 Order By Sett_No,Sett_Type  
Open @@SettCur   
Fetch Next From @@SettCur into @@Sett_No,@@Sett_Type  
While @@Fetch_Status = 0   
Begin  
 Exec NseCMValan @@Sett_No,@@Sett_Type,'','','','','Broker'  
 Fetch Next From @@SettCur into @@Sett_No,@@Sett_Type  
End  
Close @@SettCur  
DeAllocate @@SettCur

GO
