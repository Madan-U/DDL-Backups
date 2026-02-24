-- Object: PROCEDURE dbo.Angel_Rpt_StampDuty_New_Report
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE  Proc Angel_Rpt_StampDuty_New_Report (@Start_Date Varchar(11), @End_Date Varchar(11), @State Varchar(50))            
As          
      
      
set @Start_Date = convert(datetime,@Start_Date,103)      
set @End_Date = convert(datetime,@End_Date,103)      
        
            
Select S2.sett_No,S2.Sett_Type,                   
Ptqty = Sum(Case when sell_buy = 1 And BillFlag in (2,3) Then tradeqty Else 0 End),                      
Stqty = sum(Case when sell_buy = 2 And BillFlag in (2,3) Then tradeqty Else 0 End) ,                      
PtaMt = sum(Case when sell_buy = 1 And BillFlag in (2,3) Then tradeqty * Marketrate Else 0 End),                      
Stamt = sum(Case when sell_buy = 2 And BillFlag in (2,3) Then tradeqty * Marketrate Else 0 End),                      
Pdqty = Sum(Case when sell_buy = 1 And BillFlag in (1,4,5) Then tradeqty Else 0 End),                      
Sdqty = sum(Case when sell_buy = 2 And BillFlag in (1,4,5) Then tradeqty Else 0 End) ,                      
PdaMt = sum(Case when sell_buy = 1 And BillFlag in (1,4,5) Then tradeqty * Marketrate Else 0 End),                      
Sdamt = sum(Case when sell_buy = 2 And BillFlag in (1,4,5) Then tradeqty * Marketrate Else 0 End),                      
Totamt = Sum(Broker_Chrg),--Sum(tradeqty * marketrate),    
Cl_Type, L_State                   
Into #StampDuty From settlement, Client2, V_Client1 Client1, sett_mst s2                   
where settlement.sett_no = s2.sett_no And settlement.sett_type = s2.sett_type                  
and s2.end_date >= @Start_Date and s2.end_date <= @End_Date + ' 23:59:59'                  
And trade_no not like '%C%' and settlement.party_code = Client2.party_code                       
and Client1.Cl_code = Client2.Cl_code                       
--and auctionpart not like 'F%' 
and auctionpart not IN ('FC','FL')
And auctionpart not like 'A%'                      
And TradeQty > 0            
And L_State Like @State          
group by S2.Sett_Type, Cl_Type, L_State,S2.sett_No                    
                    
Insert Into #StampDuty                  
select S2.sett_No,S2.Sett_Type,                  
Ptqty = 0,                      
Stqty = 0,                      
PtaMt = 0,                      
Stamt = 0,                      
Pdqty = Sum(Case when sell_buy = 1 Then tradeqty Else 0 End),                      
Sdqty = sum(Case when sell_buy = 2 Then tradeqty Else 0 End) ,                      
PdaMt = sum(Case when sell_buy = 1 Then tradeqty * ISettlement.Dummy1 Else 0 End),                      
Sdamt = sum(Case when sell_buy = 2 Then tradeqty * ISettlement.Dummy1 Else 0 End),                      
Totamt =Sum(Broker_Chrg),-- Sum(tradeqty * Isettlement.dummy1),    
Cl_Type,L_State                   
from isettlement ,Client2, V_Client1 Client1, sett_mst s2                   
where isettlement.sett_no = s2.sett_no And isettlement.sett_type = s2.sett_type                  
and s2.end_date >= @Start_Date and s2.end_date <= @End_Date + ' 23:59:59'                  
And trade_no not like '%C%' and isettlement.party_code = Client2.party_code                       
and Client1.Cl_code = Client2.Cl_code                       
--and auctionpart not like 'F%' 
and auctionpart not IN ('FC','FL')
and auctionpart not like 'A%'                      
And TradeQty > 0             
And L_State Like @State          
group by S2.Sett_Type, Cl_Type, L_State,S2.sett_No                      
                  
Insert Into #StampDuty                  
Select S2.sett_No,S2.Sett_Type,                  
Ptqty = Sum(Case when sell_buy = 1 And BillFlag in (2,3) Then tradeqty Else 0 End),                      
Stqty = sum(Case when sell_buy = 2 And BillFlag in (2,3) Then tradeqty Else 0 End) ,                      
PtaMt = sum(Case when sell_buy = 1 And BillFlag in (2,3) Then tradeqty * Marketrate Else 0 End),                      
Stamt = sum(Case when sell_buy = 2 And BillFlag in (2,3) Then tradeqty * Marketrate Else 0 End),                      
Pdqty = Sum(Case when sell_buy = 1 And BillFlag in (1,4,5) Then tradeqty Else 0 End),                      
Sdqty = sum(Case when sell_buy = 2 And BillFlag in (1,4,5) Then tradeqty Else 0 End) ,                      
PdaMt = sum(Case when sell_buy = 1 And BillFlag in (1,4,5) Then tradeqty * Marketrate Else 0 End),                      
Sdamt = sum(Case when sell_buy = 2 And BillFlag in (1,4,5) Then tradeqty * Marketrate Else 0 End),                      
Totamt = Sum(Broker_Chrg),--Sum(tradeqty * marketrate),     
Cl_Type, L_State                   
From History, Client2, V_Client1 Client1, sett_mst s2                   
where History.sett_no = s2.sett_no And History.sett_type = s2.sett_type                  
and s2.end_date >= @Start_Date and s2.end_date <= @End_Date + ' 23:59:59'                  
And trade_no not like '%C%' and History.party_code = Client2.party_code                       
and Client1.Cl_code = Client2.Cl_code                       
--and auctionpart not like 'F%' 
and auctionpart not IN ('FC','FL')
and auctionpart not like 'A%'                      
And TradeQty > 0             
And L_State Like @State          
group by S2.Sett_Type, Cl_Type, L_State,S2.sett_No                      
                  
Insert Into #StampDuty                  
select S2.sett_No,S2.Sett_Type,                  
Ptqty = 0,                      
Stqty = 0,                      
PtaMt = 0,                      
Stamt = 0,                      
Pdqty = Sum(Case when sell_buy = 1 Then tradeqty Else 0 End),                      
Sdqty = sum(Case when sell_buy = 2 Then tradeqty Else 0 End) ,                      
PdaMt = sum(Case when sell_buy = 1 Then tradeqty * IHistory.Dummy1 Else 0 End),                      
Sdamt = sum(Case when sell_buy = 2 Then tradeqty * IHistory.Dummy1 Else 0 End),                      
Totamt = Sum(Broker_Chrg),--Sum(tradeqty * IHistory.dummy1),    
Cl_Type,L_State                   
from IHistory ,Client2, V_Client1 Client1, sett_mst s2                   
where IHistory.sett_no = s2.sett_no And IHistory.sett_type = s2.sett_type                  
and s2.end_date >= @Start_Date and s2.end_date <= @End_Date + ' 23:59:59'                  
And trade_no not like '%C%' and IHistory.party_code = Client2.party_code                       
and Client1.Cl_code = Client2.Cl_code                       
--and auctionpart not like 'F%' 
and auctionpart not IN ('FC','FL')
and auctionpart not like 'A%'                      
And TradeQty > 0             
And L_State Like @State          
group by S2.Sett_Type, Cl_Type, L_State,S2.sett_No                  
        
truncate table Angel_StampDuty_Report                            
                  
insert into Angel_StampDuty_Report                  
Select sett_No,sett_type,L_State,                    
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
From #StampDuty            
Group by L_State,sett_No,sett_type

GO
