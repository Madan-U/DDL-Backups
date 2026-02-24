-- Object: PROCEDURE dbo.STT_InsertData_Summary_1507201
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

 CREATE Proc STT_InsertData_Summary    
(      
@Sett_Type Varchar(2),       
@Sauda_Date Varchar(11),       
@FromParty Varchar(10),       
@ToParty Varchar(10)      
)       
      
As         
        
      
Delete From STT_ClientDetail       
Where       
 RecType = 20         
 And Sauda_Date >= convert(datetime,@Sauda_Date,110)  
 And Sauda_Date <= convert(datetime,@Sauda_Date,110)+'23:59:00.000'   
 And Party_Code >= @FromParty         
 And Party_Code <= @ToParty        
        
 /* Normal Clients Start here */        
Insert Into STT_ClientDetail         
Select       
 20,       
 '',       
 '',       
 '',       
 Party_Code,       
 '',       
 '',         
 Sauda_Date=Left(Convert(Varchar,Sauda_Date,109),11),        
 Branch_Id=Party_Code,        
 PDelPrice=0,        
 PQtyDel=0,        
 PAmtDel=0,        
 PSTTDel=0,        
 SDelPrice=0,        
 SQtyDel=0,        
 SAmtDel=0,        
 SSTTDel=0,        
 STrdPrice=0,        
 SQtyTrd=0,        
 SAmtTrd=0,        
 SSTTTrd=0,        
 TotalSTT=Sum(TotalSTT)        
From   
 (    
 Select     
  Party_Code,     
  Sauda_Date,     
  Sett_Type,     
  Branch_Id,     
  TotalSTT = Round(Sum(TotalSTT),0)    
 From       
  STT_ClientDetail with(index(sttidx),nolock)  
 Where       
  RecType = 30     
  And Sauda_Date >= convert(datetime,@Sauda_Date,110)  
  And Sauda_Date <= convert(datetime,@Sauda_Date,110)+'23:59:00.000'  
  And Party_Code >= @FromParty         
  And Party_Code <= @ToParty     
 Group By    
  Party_Code,     
  Sauda_Date,     
  Sett_Type,     
  Branch_Id   
 ) A    
Group By     
 Party_Code,     
 Sauda_Date,     
 Sett_Type,     
 Branch_Id

GO
