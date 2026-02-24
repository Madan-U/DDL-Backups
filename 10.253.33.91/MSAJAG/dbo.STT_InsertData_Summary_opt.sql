-- Object: PROCEDURE dbo.STT_InsertData_Summary_opt
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




create Proc [dbo].[STT_InsertData_Summary_opt]  
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
	--And Sauda_Date Like @Sauda_Date + '%'    
	And   Sauda_Date >=@Sauda_Date And Sauda_Date <=@Sauda_Date + ' 23:59'    
	And Party_Code >= @FromParty       
	And Party_Code <= @ToParty      

DELETE FROM STT_CLIENTDETAIL_NEW  
WHERE RECTYPE = 20   
--AND SAUDA_DATE LIKE @SAUDA_DATE + '%'  
And   Sauda_Date >=@Sauda_Date And Sauda_Date <=@Sauda_Date + ' 23:59' 
AND PARTY_CODE IN (SELECT PARTY_CODE FROM COMBINE_SETTLEMENT
				  WHERE STT_CLIENTDETAIL_NEW.PARTY_CODE = COMBINE_SETTLEMENT.PARTY_CODE )


/* Normal Clients Start here */    
 Insert Into STT_ClientDetail_NEW      
 Select   
  20,  
  EXCHG, 
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
  TotalSTT=Round(Sum(TotalSTT),0)    
 From   
  STT_ClientDetail_NEW (nolock)  
 Where   
 RecType = 30     
 --And Sauda_Date Like @Sauda_Date + '%'   
 And   Sauda_Date >=@Sauda_Date And Sauda_Date <=@Sauda_Date + ' 23:59'  
 And Party_Code >= @FromParty     
 And Party_Code <= @ToParty  
 AND Exchg = 'BSE'
 Group By EXCHG, Party_Code, Left(Convert(Varchar,Sauda_Date,109),11)

 Insert Into STT_ClientDetail_NEW      
 Select   
  20,  
  EXCHG=MAX(EXCHG), 
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
  TOTALSTT= ROUND(SUM(TOTALSTT),0) - ROUND(SUM(CASE WHEN EXCHG = 'BSE' THEN TOTALSTT ELSE 0 END),0)
 From   
  STT_ClientDetail_NEW (nolock)  
 Where   
 RecType = 30     
-- And Sauda_Date Like @Sauda_Date + '%'  
And   Sauda_Date >=@Sauda_Date And Sauda_Date <=@Sauda_Date + ' 23:59'   
 And Party_Code >= @FromParty     
 And Party_Code <= @ToParty  
 Group By Party_Code, Left(Convert(Varchar,Sauda_Date,109),11)
 having ROUND(SUM(TOTALSTT),0) - ROUND(SUM(CASE WHEN EXCHG = 'BSE' THEN TOTALSTT ELSE 0 END),0) > 0 
 		      				        
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
		--And Sauda_Date Like @Sauda_Date + '%'      
		And   Sauda_Date >=@Sauda_Date And Sauda_Date <=@Sauda_Date + ' 23:59' 
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
