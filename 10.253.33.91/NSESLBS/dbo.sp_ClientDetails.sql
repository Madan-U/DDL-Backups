-- Object: PROCEDURE dbo.sp_ClientDetails
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE procedure [dbo].[sp_ClientDetails]         
(    
 @FromDate   Varchar(11) ,         
 @ToDate     Varchar(11) ,    
 @FromParty  Varchar(10) ,         
 @ToParty    Varchar(10) ,    
 @BrCode     varchar(10) ,    
 @ClientType   Varchar(3) ,    
 @Statusid   varchar(15) ,         
 @Statusname varchar(25) ,        
 @ClStatus     varchar(20) ,        
 @DpStatus     varchar(20) ,        
 @withTranDt Varchar(10),  
 @TradeFlag  varchar(9) = 'ALL'    
)    
AS        
    
IF  (LEN(@ToParty)=0)    
SET @ToParty = 'zzzzzzzzzz'    
    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    

Select Party_Code, Long_Name, Branch_Cd, Sub_broker, Trader,  
Status = (Case When InActive_From <= GetDate() Then 'Inactive' Else 'Active  ' End),   
convert(varchar(10),Active_date,103) as ActiveFrom ,   
convert(varchar(10),InActive_From,103) as InActiveFrom,
Approver, DpId = IsNull(dpid1,''),   
CltdpId = IsNull(CltdpId1,''), Depository = IsNull(Depository1,''),  
FirstDate = GetDate(), LastDate = GetDate()
into #CltReport From Client_Details C1, Client_Brok_Details C2   
Where C1.Cl_Code = C2.Cl_Code And Exchange = 'NSE' And Segment = 'CAPITAL'
AND C1.Branch_Cd Like (Case When @BrCode = '1' Then '%' Else @BrCode End)  
and InActive_From >= (Case When @ClStatus='ACTIVE' Then GetDate()+1 Else InActive_From End)  
And InActive_From <= (Case When @ClStatus='INACTIVE' Then GetDate() Else InActive_From End)  
And Active_date >= @FromDate And Active_date <= @Todate + ' 23:59'  
and Len(IsNull(dpid1,'')) >= (Case When @DpStatus='WITH' Then 1 Else 0 End)  
And Len(IsNull(dpid1,'')) <= (Case When @DpStatus='WITHOUT' Then 0 Else 16 End)  
         And @STATUSNAME =       
    (CASE       
     WHEN @STATUSID = 'BRANCH' THEN C1.BRANCH_CD      
     WHEN @STATUSID = 'SUBBROKER' THEN C1.SUB_BROKER      
     WHEN @STATUSID = 'TRADER' THEN C1.TRADER      
     WHEN @STATUSID = 'FAMILY' THEN C1.FAMILY      
     WHEN @STATUSID = 'AREA' THEN C1.AREA      
     WHEN @STATUSID = 'REGION' THEN C1.REGION      
     WHEN @STATUSID = 'CLIENT' THEN C1.PARTY_CODE      
     ELSE       
    'BROKER'      
    END)  
    

 If @withTranDt ='WITHTRANDT'    
 Begin    
        
  Create Table #ClientList    
  (    
   Party_Code Varchar(10),    
   MinTranDate VARCHAR(10),    
   MaxTranDate VARCHAR(10)    
  )    
  Insert Into #ClientList    
  Select  Party_Code,    
   MinTranDate=convert(varchar,Min(CONVERT(DATETIME,Sauda_Date)),103),    
   MaxTranDate=convert(varchar,Max(CONVERT(DATETIME,Sauda_Date)),103)     
  From Details     
  where party_code in (Select Party_Code From #CltReport)    
  Group by party_code    
  
  Update    
   #CltReport Set FirstDate = MinTranDate,LastDate=MaxTranDate    
  From      
   #ClientList    
  Where    
   #CltReport.Party_Code = #ClientList.Party_Code    
  
  Drop table #ClientList    
     
 End    
   
IF @TradeFlag = 'TRADED'   
 DELETE FROM #CltReport WHERE FirstDate = ''  
  
IF @TradeFlag = 'NOTTRADED'   
 DELETE FROM #CltReport WHERE FirstDate <> ''  
  
 Select     
  Party_Code,    
  Long_Name,     
  Branch_Cd,     
  Sub_broker,    
  Trader,     
  Status,        
  ActiveFrom,    
  InActiveFrom,     
  Approver,    
  DpId = Case When @DpStatus='WITHDP' Then DpId Else '' End,     
  CltdpId = Case When @DpStatus='WITHDP' Then CltDpId Else '' End,     
  Depository = Case When @DpStatus='WITHDP' Then Depository Else '' End,        
  FirstDate  = Case When @withTranDt ='WITHTRANDT'   
      Then FirstDate Else '' End,         
  LastDate = Case When @withTranDt ='WITHTRANDT' Then LastDate Else '' End      
 From    
  #CltReport      
 Order By    
  Branch_Cd, Long_Name         
     
 Drop Table #CltReport

GO
