-- Object: PROCEDURE dbo.Rpt_clientturnover
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE proc Rpt_ClientTurnover      
(@StatusId Varchar(15), @StatusName Varchar(25),@SettType varchar(2), @SettNo_From varchar (7),@SettNo_To varchar (7), @Sauda_DateFrom Varchar(11),@Sauda_DateTo Varchar(11),@FromParty_code Varchar(10) ,@ToParty_code Varchar(10), @Branch Varchar(10),      

@Sub_broker Varchar(10), @ShowValue varchar(1) , @Amount numeric(10))      
      
as      
      
if len(@Sauda_DateFrom) = 0       
Begin      
select @Sauda_DateFrom = 'Apr  1 1998'  
End      
if len(@Sauda_DateTo) = 0       
Begin      
select @Sauda_DateTo = Left(GetDate(),11)  
End      
      
if len(@SettNo_From) = 0       
Begin      
 Select @SettNo_From='0'      
End       
  
if len(@SettNo_To) = 0       
Begin      
 Select @SettNo_To='9999999'      
End     
  
if len(@FromParty_code) = 0       
Begin      
 Select @FromParty_code='0', @ToParty_code = 'zzzzz'
End       

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
select * into #cmbillvalan from cmbillvalan      
where sett_no between @SettNo_From and @SettNo_To      
and sett_type = @SettType 
And Party_code between @FromParty_Code And  @ToParty_Code      
and Sauda_date >= @Sauda_DateFrom + ' 00:00'       
and Sauda_date <= @Sauda_DateTo + ' 23:59'       
and (pqtytrd > 0 or sqtytrd > 0 or pqtydel > 0 or sqtydel > 0)      
and TradeType not in ( 'SCF','ICF','IR' )      

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED        
Select Sett_No, Sett_Type, Party_Code,Sauda_Date, TurnOver = Sum(TrdAmt)       
Into #CMBillValanTurn From #cmbillvalan    
Group By Sett_No, Sett_Type, Party_Code, Sauda_Date      

SELECT PARTY_CODE, long_name,l_address1,l_address2,l_address3, isnull(pan_gir_no,'') pan_gir_no INTO #CLIENT
FROM CLIENT1 C1, CLIENT2 C2
WHERE C1.CL_CODE = C2.CL_CODE
And Party_code between @FromParty_Code And  @ToParty_Code      
AND @StatusName =         
                  (case         
                        when @StatusId = 'BRANCH' then c1.branch_cd        
                        when @StatusId = 'SUBBROKER' then c1.sub_broker        
                        when @StatusId = 'Trader' then c1.Trader        
                        when @StatusId = 'Family' then c1.Family        
                        when @StatusId = 'Area' then c1.Area        
                        when @StatusId = 'Region' then c1.Region        
                        when @StatusId = 'Client' then c2.party_code        
                  else         
                        'BROKER'        
                  End)          
 And C1.Branch_Cd = (Case When @Branch = 'ALL' Then Branch_Cd Else @Branch End) 
 AND EXISTS (SELECT PARTY_CODE FROM #CMBillValanTurn WHERE #CMBillValanTurn.PARTY_CODE = C2.PARTY_CODE)

if @ShowValue='L'      
Begin      
      
 Select S.Party_code, S.Scrip_Cd,Scrip_Name,long_name,l_address1,l_address2,l_address3, isnull(pan_gir_no,'') pan_gir_no,      
 PQtyTrd= sum(PQtyTrd+PQtyDel),      
 SQtyTrd = sum(SQtyTrd+SQtyDel),      
 PAmtTrd=isnull(sum(PAmtTrd+PAmtDel),0),      
 SAmtTrd=isnull(sum(SAmtTrd+SAmtDel),0),      
 Turnover =  isnull(sum(TrdAmt),0) ,      
 Brokerage = sum(PBroktrd + SBroktrd+SBrokDel+PBrokDel),      
 S.Sett_No, S.Sett_Type , s.contractno     
 into #tmpClientTurnover1      
 From #cmbillvalan S, #client c1, #CMBillValanTurn T      
 Where s.party_code = c1.party_code      
 And S.Party_Code = T.Party_Code      
 And S.Sauda_Date = T.Sauda_Date      
 And S.Sett_No = T.Sett_No      
 And S.Sett_Type = T.Sett_Type    
     
 group by S.Party_code, S.Scrip_Cd,Scrip_Name,long_name,l_address1,l_address2,l_address3, pan_gir_no,S.Sett_No, S.Sett_Type,TurnOver, s.contractno      
 having TurnOver <= @Amount      
       
 select * from #tmpClientTurnover1 where TurnOver <= @Amount order by party_code,scrip_cd  
End      
      
      
if @ShowValue='G'      
Begin      
  print (@Amount)    
 Select S.Party_code, S.Scrip_Cd,Scrip_Name,long_name,l_address1,l_address2,l_address3, isnull(pan_gir_no,'') pan_gir_no,      
 PQtyTrd= sum(PQtyTrd+PQtyDel),      
 SQtyTrd = sum(SQtyTrd+SQtyDel),      
 PAmtTrd=isnull(sum(PAmtTrd+PAmtDel),0),      
 SAmtTrd=isnull(sum(SAmtTrd+SAmtDel),0),      
 Turnover =  isnull(sum(TrdAmt),0) ,      
 Brokerage = sum(PBroktrd + SBroktrd+SBrokDel+PBrokDel),      
 S.Sett_No, S.Sett_Type, s.contractno      
 into #tmpClientTurnover      
 From #cmbillvalan S, #client c1, #CMBillValanTurn T      
 Where s.party_code = c1.party_code      
 And S.Party_Code = T.Party_Code      
 And S.Sauda_Date = T.Sauda_Date      
 And S.Sett_No = T.Sett_No      
 And S.Sett_Type = T.Sett_Type     
 group by S.Party_code, S.Scrip_Cd,Scrip_Name,long_name,l_address1,l_address2,l_address3, pan_gir_no,S.Sett_No, S.Sett_Type,TurnOver, s.contractno      
 having TurnOver >= @Amount      
       
 select * from #tmpClientTurnover where TurnOver >= @Amount   order by party_code,scrip_cd      
     
End

GO
