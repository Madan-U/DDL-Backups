-- Object: PROCEDURE dbo.Rpt_StampDuty_New_Report_pratham
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

  
--EXEC Rpt_StampDuty_New_Report_pratham 'sep  1 2015','sep 30 2015','%'  
   
   
  CREATE Proc Rpt_StampDuty_New_Report_pratham (@Start_Date Varchar(11), @End_Date Varchar(11), @State Varchar(50))                  
As                  
                
Select S2.Sett_Type,settlement.Party_Code,settlement.sett_no, settlement.SAUDA_DATE , 
SUM(BROKER_CHRG)AS STAMPDUTY,                     
Ptqty = Sum(Case when sell_buy = 1 And BillFlag in (2,3) Then tradeqty Else 0 End),                            
Stqty = sum(Case when sell_buy = 2 And BillFlag in (2,3) Then tradeqty Else 0 End) ,                            
PtaMt = sum(Case when sell_buy = 1 And BillFlag in (2,3) Then tradeqty * Marketrate Else 0 End),                            
Stamt = sum(Case when sell_buy = 2 And BillFlag in (2,3) Then tradeqty * Marketrate Else 0 End),                            
Pdqty = Sum(Case when sell_buy = 1 And BillFlag in (1,4,5) Then tradeqty Else 0 End),                            
Sdqty = sum(Case when sell_buy = 2 And BillFlag in (1,4,5) Then tradeqty Else 0 End) ,                            
PdaMt = sum(Case when sell_buy = 1 And BillFlag in (1,4,5) Then tradeqty * Marketrate Else 0 End),                            
Sdamt = sum(Case when sell_buy = 2 And BillFlag in (1,4,5) Then tradeqty * Marketrate Else 0 End),                            
Totamt = Sum(tradeqty * marketrate), Cl_Type, L_State                         
Into #StampDuty From settlement(NOLOCK), Client2(NOLOCK), V_STATE_STAMP(NOLOCK), sett_mst s2      (NOLOCK)                   
where settlement.sett_no = s2.sett_no And settlement.sett_type = s2.sett_type                        
and s2.end_date >= @Start_Date and s2.end_date <= @End_Date + ' 23:59:59'                        
And trade_no not like '%C%' and settlement.party_code = Client2.party_code                             
and V_STATE_STAMP.Cl_code = Client2.Cl_code                             
--and auctionpart not like 'F%'         
and auctionpart NOT IN  ('FC','FL')        
And auctionpart not like 'A%'                            
And TradeQty > 0                  
And L_State Like @State                
group by S2.Sett_Type, Cl_Type, L_State  ,settlement.Party_Code,settlement.sett_no  ,settlement.SAUDA_DATE                        
                          
Insert Into #StampDuty                        
select S2.Sett_Type,
    
isettlement.Party_Code,isettlement.sett_no,isettlement.SAUDA_DATE , 
SUM(BROKER_CHRG)AS STAMPDUTY,                    
Ptqty = 0,                            
Stqty = 0,                            
PtaMt = 0,                            
Stamt = 0,                            
Pdqty = Sum(Case when sell_buy = 1 Then tradeqty Else 0 End),                            
Sdqty = sum(Case when sell_buy = 2 Then tradeqty Else 0 End) ,                            
PdaMt = sum(Case when sell_buy = 1 Then tradeqty * ISettlement.Dummy1 Else 0 End),                            
Sdamt = sum(Case when sell_buy = 2 Then tradeqty * ISettlement.Dummy1 Else 0 End),                            
Totamt = Sum(tradeqty * Isettlement.dummy1),Cl_Type,L_State                         
from isettlement (NOLOCK) ,Client2(NOLOCK), V_STATE_STAMP(NOLOCK), sett_mst s2(NOLOCK)                         
where isettlement.sett_no = s2.sett_no And isettlement.sett_type = s2.sett_type                        
and s2.end_date >= @Start_Date and s2.end_date <= @End_Date + ' 23:59:59'                        
And trade_no not like '%C%' and isettlement.party_code = Client2.party_code                             
and V_STATE_STAMP.Cl_code = Client2.Cl_code                             
--and auctionpart not like 'F%'         
and auctionpart NOT IN  ('FC','FL')        
 and auctionpart not like 'A%'                            
And TradeQty > 0                   
And L_State Like @State                
group by S2.Sett_Type, Cl_Type, L_State ,isettlement.Party_Code,isettlement.sett_no ,isettlement.SAUDA_DATE                           
                        
Insert Into #StampDuty                        
Select S2.Sett_Type,  
HISTORY.Party_Code,HISTORY.sett_no,  HISTORY.SAUDA_DATE  ,
SUM(BROKER_CHRG)AS STAMPDUTY,                      
Ptqty = Sum(Case when sell_buy = 1 And BillFlag in (2,3) Then tradeqty Else 0 End),                            
Stqty = sum(Case when sell_buy = 2 And BillFlag in (2,3) Then tradeqty Else 0 End) ,                            
PtaMt = sum(Case when sell_buy = 1 And BillFlag in (2,3) Then tradeqty * Marketrate Else 0 End),                            
Stamt = sum(Case when sell_buy = 2 And BillFlag in (2,3) Then tradeqty * Marketrate Else 0 End),          
Pdqty = Sum(Case when sell_buy = 1 And BillFlag in (1,4,5) Then tradeqty Else 0 End),             
Sdqty = sum(Case when sell_buy = 2 And BillFlag in (1,4,5) Then tradeqty Else 0 End) ,             
PdaMt = sum(Case when sell_buy = 1 And BillFlag in (1,4,5) Then tradeqty * Marketrate Else 0 End),                            
Sdamt = sum(Case when sell_buy = 2 And BillFlag in (1,4,5) Then tradeqty * Marketrate Else 0 End),                            
Totamt = Sum(tradeqty * marketrate), Cl_Type, L_State                         
From HISTORY(NOLOCK), Client2(NOLOCK), V_STATE_STAMP(NOLOCK), sett_mst s2 (NOLOCK)                        
where HISTORY.sett_no = s2.sett_no And HISTORY.sett_type = s2.sett_type                        
and s2.end_date >= @Start_Date and s2.end_date <= @End_Date + ' 23:59:59'                        
And trade_no not like '%C%' and HISTORY.party_code = Client2.party_code                             
and V_STATE_STAMP.Cl_code = Client2.Cl_code       
--  and auctionpart not like 'F%'                           
and auctionpart NOT IN  ('FC','FL')        
 and auctionpart not like 'A%'                            
And TradeQty > 0                   
And L_State Like @State                
group by S2.Sett_Type, Cl_Type, L_State  ,HISTORY.Party_Code,HISTORY.sett_no, HISTORY.SAUDA_DATE                            
                        
Insert Into #StampDuty                        
select S2.Sett_Type,    
IHistory.Party_Code,IHistory.sett_no,  IHistory.SAUDA_DATE  ,  
SUM(BROKER_CHRG)AS STAMPDUTY,                      
Ptqty = 0,                            
Stqty = 0,                            
PtaMt = 0,                            
Stamt = 0,                            
Pdqty = Sum(Case when sell_buy = 1 Then tradeqty Else 0 End),                            
Sdqty = sum(Case when sell_buy = 2 Then tradeqty Else 0 End) ,                            
PdaMt = sum(Case when sell_buy = 1 Then tradeqty * IHistory.Dummy1 Else 0 End),                            
Sdamt = sum(Case when sell_buy = 2 Then tradeqty * IHistory.Dummy1 Else 0 End),                            
Totamt = Sum(tradeqty * IHistory.dummy1),Cl_Type,L_State                         
from IHistory(NOLOCK) ,Client2(NOLOCK), V_STATE_STAMP(NOLOCK), sett_mst s2(NOLOCK)                         
where IHistory.sett_no = s2.sett_no And IHistory.sett_type = s2.sett_type                        
and s2.end_date >= @Start_Date and s2.end_date <= @End_Date + ' 23:59:59'                        
And trade_no not like '%C%' and IHistory.party_code = Client2.party_code                             
and V_STATE_STAMP.Cl_code = Client2.Cl_code                             
and auctionpart NOT IN  ('FC','FL')        
--and auctionpart not like 'F%'          
and auctionpart not like 'A%'                            
And TradeQty > 0                   
And L_State Like @State                
group by S2.Sett_Type, Cl_Type, L_State,IHistory.Party_Code,IHistory.sett_no, IHistory.SAUDA_DATE      
    
                 
                        
                        
Select L_State,Party_Code, sett_no,sett_type,SAUDA_DATE,  STAMPDUTY,                       
ProDelAmount = convert(numeric(18,4),                 
  Sum(Case When Cl_Type = 'PRO'                 
    Then (Case When Sett_Type in ('W', 'C')                         
                 Then PDAmt+SDAmt+PTAmt+STAmt                        
                 Else PDAmt+SDAmt                         
          End)                 
            Else 0                
      End)),                        
ProTrdAmount = convert(numeric(18,4),   
  Sum(Case When Cl_Type = 'PRO'                 
    Then (Case When Sett_Type in ('W', 'C')                         
                 Then 0                
                 Else PTAmt+STAmt                
          End)                 
            Else 0                
      End)),                        
NrmDelAmount = convert(numeric(18,4),                 
  Sum(Case When Cl_Type <> 'PRO'                 
    Then (Case When Sett_Type in ('W', 'C')                         
                 Then PDAmt+SDAmt+PTAmt+STAmt                        
                 Else PDAmt+SDAmt                         
          End)                 
            Else 0                
      End)),                        
NrmTrdAmount = convert(numeric(18,4),                 
  Sum(Case When Cl_Type <> 'PRO'                 
    Then (Case When Sett_Type in ('W', 'C')                         
                 Then 0                
                 Else PTAmt+STAmt                
          End)                 
            Else 0                
      End)),                        
TotalAmt = convert(numeric(18,4), sum(totamt))                     
Into #StampDuty_Report                        
From #StampDuty                  
Group by L_State,Party_Code, sett_no,sett_type ,SAUDA_DATE  ,STAMPDUTY             
                
Select * From #StampDuty_Report                        
Order by L_State

GO
