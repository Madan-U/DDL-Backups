-- Object: PROCEDURE dbo.Rpt_StampDuty_New_Report_Det
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE Proc Rpt_StampDuty_New_Report_Det (@Start_Date Varchar(11), @End_Date Varchar(11), @State Varchar(50))    
As    
    
Select S2.Sett_Type,           
TAMT = sum(Case when BillFlag in (2,3) Then tradeqty * Marketrate Else 0 End),              
DAMT = sum(Case when BillFlag in (1,4,5) Then tradeqty * Marketrate Else 0 End),
CTSTAMP = sum(Case when BillFlag in (2,3) Then Broker_CHRG Else 0 End),              
CDSTAMP = sum(Case when BillFlag in (1,4,5) Then Broker_CHRG Else 0 End),
ATSTAMP = Convert(Numeric(18,4),0),              
ADSTAMP = Convert(Numeric(18,4),0),
Totamt = Sum(tradeqty * marketrate), Cl_Type, L_State           
Into #StampDuty From settlement, Client2, Client1, sett_mst s2           
where settlement.sett_no = s2.sett_no And settlement.sett_type = s2.sett_type          
and s2.end_date >= @Start_Date and s2.end_date <= @End_Date + ' 23:59:59'          
And trade_no not like '%C%' and settlement.party_code = Client2.party_code               
and Client1.Cl_code = Client2.Cl_code               
and auctionpart not like 'F%' And auctionpart not like 'A%'              
And TradeQty > 0    
And L_State Like @State  
group by S2.Sett_Type, Cl_Type, L_State            
            
Insert Into #StampDuty          
select S2.Sett_Type,          
TAMT = 0,              
DAMT = sum(TRADEQTY * ISettlement.Dummy1),
CTSTAMP = 0,              
CDSTAMP = sum(Broker_CHRG),
ATSTAMP = Convert(Numeric(18,4),0),              
ADSTAMP = Convert(Numeric(18,4),0),
Totamt = Sum(tradeqty * Isettlement.dummy1),Cl_Type,L_State           
from isettlement ,Client2, Client1, sett_mst s2           
where isettlement.sett_no = s2.sett_no And isettlement.sett_type = s2.sett_type          
and s2.end_date >= @Start_Date and s2.end_date <= @End_Date + ' 23:59:59'          
And trade_no not like '%C%' and isettlement.party_code = Client2.party_code               
and Client1.Cl_code = Client2.Cl_code               
and auctionpart not like 'F%'  and auctionpart not like 'A%'              
And TradeQty > 0     
And L_State Like @State  
group by S2.Sett_Type, Cl_Type, L_State              
          
Insert Into #StampDuty          
Select S2.Sett_Type,          
TAMT = sum(Case when BillFlag in (2,3) Then tradeqty * Marketrate Else 0 End),              
DAMT = sum(Case when BillFlag in (1,4,5) Then tradeqty * Marketrate Else 0 End),
CTSTAMP = sum(Case when BillFlag in (2,3) Then Broker_CHRG Else 0 End),              
CDSTAMP = sum(Case when BillFlag in (1,4,5) Then Broker_CHRG Else 0 End),
ATSTAMP = Convert(Numeric(18,4),0),              
ADSTAMP = Convert(Numeric(18,4),0),            
Totamt = Sum(tradeqty * marketrate), Cl_Type, L_State           
From History, Client2, Client1, sett_mst s2           
where History.sett_no = s2.sett_no And History.sett_type = s2.sett_type          
and s2.end_date >= @Start_Date and s2.end_date <= @End_Date + ' 23:59:59'          
And trade_no not like '%C%' and History.party_code = Client2.party_code              
and Client1.Cl_code = Client2.Cl_code               
and auctionpart not like 'F%'  and auctionpart not like 'A%'              
And TradeQty > 0     
And L_State Like @State  
group by S2.Sett_Type, Cl_Type, L_State              
          
Insert Into #StampDuty          
select S2.Sett_Type,          
TAMT = 0,              
DAMT = sum(TRADEQTY * IHistory.Dummy1),
CTSTAMP = 0,              
CDSTAMP = sum(Broker_CHRG),
ATSTAMP = Convert(Numeric(18,4),0),              
ADSTAMP = Convert(Numeric(18,4),0),             
Totamt = Sum(tradeqty * IHistory.dummy1),Cl_Type,L_State           
from IHistory ,Client2, Client1, sett_mst s2           
where IHistory.sett_no = s2.sett_no And IHistory.sett_type = s2.sett_type          
and s2.end_date >= @Start_Date and s2.end_date <= @End_Date + ' 23:59:59'          
And trade_no not like '%C%' and IHistory.party_code = Client2.party_code               
and Client1.Cl_code = Client2.Cl_code               
and auctionpart not like 'F%'  and auctionpart not like 'A%'              
And TradeQty > 0     
And L_State Like @State  
group by S2.Sett_Type, Cl_Type, L_State          

UPDATE #StampDuty SET 
ATSTAMP = (CASE WHEN CL_TYPE = 'PRO'
		THEN TAMT * PROSTAMPDUTY / 100
		ELSE TAMT * TRDSTAMPDUTY / 100
	   END),
ADSTAMP = (CASE WHEN CL_TYPE = 'PRO'
		THEN DAMT * PROSTAMPDUTY / 100
		ELSE DAMT * DELSTAMPDUTY / 100
	   END)
FROM STATE_MASTER
WHERE L_STATE = STATE

UPDATE #StampDuty SET 
ATSTAMP = (CASE WHEN CL_TYPE = 'PRO'
		THEN TAMT * PROSTAMPDUTY / 100
		ELSE TAMT * TRDSTAMPDUTY / 100
	   END),
ADSTAMP = (CASE WHEN CL_TYPE = 'PRO'
		THEN DAMT * PROSTAMPDUTY / 100
		ELSE DAMT * DELSTAMPDUTY / 100
	   END)
FROM STATE_MASTER
WHERE STATE = 'MAHARASHTRA'
AND L_STATE NOT IN (SELECT STATE FROM STATE_MASTER)

Select L_State,            
ProDelAmount = convert(numeric(18,4),   
  Sum(Case When Cl_Type = 'PRO'   
    Then (Case When Sett_Type in ('W', 'C')           
                 Then DAMT + TAMT         
                 Else DAMT
          End)   
            Else 0  
      End)),          
ProTrdAmount = convert(numeric(18,4),   
  Sum(Case When Cl_Type = 'PRO'   
    Then (Case When Sett_Type in ('W', 'C')           
                 Then 0  
                 Else TAMT
          End)   
            Else 0  
      End)),          
NrmDelAmount = convert(numeric(18,4),   
  Sum(Case When Cl_Type <> 'PRO'   
    Then (Case When Sett_Type in ('W', 'C')           
                 Then DAMT + TAMT         
                 Else DAMT     
          End)   
            Else 0  
      End)),          
NrmTrdAmount = convert(numeric(18,4),   
  Sum(Case When Cl_Type <> 'PRO'   
    Then (Case When Sett_Type in ('W', 'C')           
                 Then 0  
                 Else TAMT
          End)   
            Else 0  
      End)),  

ProCDSTAMP = convert(numeric(18,4),   
  Sum(Case When Cl_Type = 'PRO'   
    Then (Case When Sett_Type in ('W', 'C')           
                 Then CDSTAMP + CTSTAMP         
                 Else CDSTAMP
          End)   
            Else 0  
      End)),          
ProCTSTAMP = convert(numeric(18,4),   
  Sum(Case When Cl_Type = 'PRO'   
    Then (Case When Sett_Type in ('W', 'C')           
                 Then 0  
                 Else CTSTAMP
          End)   
            Else 0  
      End)),          
NRMCDSTAMP = convert(numeric(18,4),   
  Sum(Case When Cl_Type <> 'PRO'   
    Then (Case When Sett_Type in ('W', 'C')           
                 Then CDSTAMP + CTSTAMP         
                 Else CDSTAMP     
          End)   
            Else 0  
      End)),          
NRMCTSTAMP = convert(numeric(18,4),   
  Sum(Case When Cl_Type <> 'PRO'   
    Then (Case When Sett_Type in ('W', 'C')           
                 Then 0  
                 Else CTSTAMP
          End)   
            Else 0  
      End)), 

ProADSTAMP = convert(numeric(18,4),   
  Sum(Case When Cl_Type = 'PRO'   
    Then (Case When Sett_Type in ('W', 'C')           
                 Then ADSTAMP + ATSTAMP         
                 Else ADSTAMP
          End)   
            Else 0  
      End)),          
ProATSTAMP = convert(numeric(18,4),   
  Sum(Case When Cl_Type = 'PRO'   
    Then (Case When Sett_Type in ('W', 'C')           
                 Then 0  
                 Else ATSTAMP
          End)   
            Else 0  
      End)),          
NRMADSTAMP = convert(numeric(18,4),   
  Sum(Case When Cl_Type <> 'PRO'   
    Then (Case When Sett_Type in ('W', 'C')           
                 Then ADSTAMP + ATSTAMP         
                 Else ADSTAMP     
          End)   
            Else 0  
      End)),          
NRMATSTAMP = convert(numeric(18,4),   
  Sum(Case When Cl_Type <> 'PRO'   
    Then (Case When Sett_Type in ('W', 'C')           
                 Then 0  
                 Else ATSTAMP
          End)   
            Else 0  
      End)),

TotalAmt = convert(numeric(18,4), sum(totamt))       
Into #StampDuty_Report          
From #StampDuty    
Group by L_State  
  
Select *, TOTALSTAMP = (ProADSTAMP+ProATSTAMP+NRMADSTAMP+NRMATSTAMP) From #StampDuty_Report          
Order by L_State

GO
