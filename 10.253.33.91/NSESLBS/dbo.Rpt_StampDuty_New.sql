-- Object: PROCEDURE dbo.Rpt_StampDuty_New
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE  Proc Rpt_StampDuty_New (@Start_Date Varchar(11), @End_Date Varchar(11))      
As

Select S2.Sett_Type,       
Ptqty = Sum(Case when sell_buy = 1 And BillFlag in (2,3) Then tradeqty Else 0 End),          
Stqty = sum(Case when sell_buy = 2 And BillFlag in (2,3) Then tradeqty Else 0 End) ,          
PtaMt = sum(Case when sell_buy = 1 And BillFlag in (2,3) Then tradeqty * Marketrate Else 0 End),          
Stamt = sum(Case when sell_buy = 2 And BillFlag in (2,3) Then tradeqty * Marketrate Else 0 End),          
Pdqty = Sum(Case when sell_buy = 1 And BillFlag in (1,4,5) Then tradeqty Else 0 End),          
Sdqty = sum(Case when sell_buy = 2 And BillFlag in (1,4,5) Then tradeqty Else 0 End) ,          
PdaMt = sum(Case when sell_buy = 1 And BillFlag in (1,4,5) Then tradeqty * Marketrate Else 0 End),          
Sdamt = sum(Case when sell_buy = 2 And BillFlag in (1,4,5) Then tradeqty * Marketrate Else 0 End),          
Totamt = Sum(tradeqty * marketrate), Cl_Type, L_State       
Into #StampDuty From settlement, Client2, Client1, sett_mst s2       
where settlement.sett_no = s2.sett_no And settlement.sett_type = s2.sett_type      
and s2.end_date >= @Start_Date and s2.end_date <= @End_Date + ' 23:59:59'      
And trade_no not like '%C%' and settlement.party_code = Client2.party_code           
and Client1.Cl_code = Client2.Cl_code           
and auctionpart not like 'F%'  and auctionpart not like 'A%'          
And TradeQty > 0          
group by S2.Sett_Type, Cl_Type, L_State        
        
Insert Into #StampDuty      
select S2.Sett_Type,      
Ptqty = 0,          
Stqty = 0,          
PtaMt = 0,          
Stamt = 0,          
Pdqty = Sum(Case when sell_buy = 1 Then tradeqty Else 0 End),          
Sdqty = sum(Case when sell_buy = 2 Then tradeqty Else 0 End) ,          
PdaMt = sum(Case when sell_buy = 1 Then tradeqty * ISettlement.Dummy1 Else 0 End),          
Sdamt = sum(Case when sell_buy = 2 Then tradeqty * ISettlement.Dummy1 Else 0 End),          
Totamt = Sum(tradeqty * Isettlement.dummy1),Cl_Type,L_State       
from isettlement ,Client2, Client1, sett_mst s2       
where isettlement.sett_no = s2.sett_no And isettlement.sett_type = s2.sett_type      
and s2.end_date >= @Start_Date and s2.end_date <= @End_Date + ' 23:59:59'      
And trade_no not like '%C%' and isettlement.party_code = Client2.party_code           
and Client1.Cl_code = Client2.Cl_code           
and auctionpart not like 'F%'  and auctionpart not like 'A%'          
And TradeQty > 0          
group by S2.Sett_Type, Cl_Type, L_State          
      
Insert Into #StampDuty      
Select S2.Sett_Type,      
Ptqty = Sum(Case when sell_buy = 1 And BillFlag in (2,3) Then tradeqty Else 0 End),          
Stqty = sum(Case when sell_buy = 2 And BillFlag in (2,3) Then tradeqty Else 0 End) ,          
PtaMt = sum(Case when sell_buy = 1 And BillFlag in (2,3) Then tradeqty * Marketrate Else 0 End),          
Stamt = sum(Case when sell_buy = 2 And BillFlag in (2,3) Then tradeqty * Marketrate Else 0 End),          
Pdqty = Sum(Case when sell_buy = 1 And BillFlag in (1,4,5) Then tradeqty Else 0 End),          
Sdqty = sum(Case when sell_buy = 2 And BillFlag in (1,4,5) Then tradeqty Else 0 End) ,          
PdaMt = sum(Case when sell_buy = 1 And BillFlag in (1,4,5) Then tradeqty * Marketrate Else 0 End),          
Sdamt = sum(Case when sell_buy = 2 And BillFlag in (1,4,5) Then tradeqty * Marketrate Else 0 End),          
Totamt = Sum(tradeqty * marketrate), Cl_Type, L_State       
From History, Client2, Client1, sett_mst s2       
where History.sett_no = s2.sett_no And History.sett_type = s2.sett_type      
and s2.end_date >= @Start_Date and s2.end_date <= @End_Date + ' 23:59:59'      
And trade_no not like '%C%' and History.party_code = Client2.party_code           
and Client1.Cl_code = Client2.Cl_code           
and auctionpart not like 'F%'  and auctionpart not like 'A%'          
And TradeQty > 0          
group by S2.Sett_Type, Cl_Type, L_State          
      
Insert Into #StampDuty      
select S2.Sett_Type,      
Ptqty = 0,          
Stqty = 0,          
PtaMt = 0,          
Stamt = 0,          
Pdqty = Sum(Case when sell_buy = 1 Then tradeqty Else 0 End),          
Sdqty = sum(Case when sell_buy = 2 Then tradeqty Else 0 End) ,          
PdaMt = sum(Case when sell_buy = 1 Then tradeqty * IHistory.Dummy1 Else 0 End),          
Sdamt = sum(Case when sell_buy = 2 Then tradeqty * IHistory.Dummy1 Else 0 End),          
Totamt = Sum(tradeqty * IHistory.dummy1),Cl_Type,L_State       
from IHistory ,Client2, Client1, sett_mst s2       
where IHistory.sett_no = s2.sett_no And IHistory.sett_type = s2.sett_type      
and s2.end_date >= @Start_Date and s2.end_date <= @End_Date + ' 23:59:59'      
And trade_no not like '%C%' and IHistory.party_code = Client2.party_code           
and Client1.Cl_code = Client2.Cl_code           
and auctionpart not like 'F%'  and auctionpart not like 'A%'          
And TradeQty > 0          
group by S2.Sett_Type, Cl_Type, L_State      
      
      
Select         
DelAmount = convert(numeric(18,4), Sum(Case When Sett_Type in ('W', 'C')       
        Then PDAmt+SDAmt+PTAmt+STAmt      
        Else PDAmt+SDAmt       
   End)),      
TrdAmount = convert(numeric(18,4), Abs(Sum(Case When Sett_Type in ('W', 'C')       
        Then 0      
        Else STAmt + PTAmt       
   End))),      
TotalAmt = convert(numeric(18,4), sum(totamt)),      
Cl_Type, L_State      
Into #StampDuty_Report      
From #StampDuty Where L_State = 'MAHARASHTRA'      
Group by Cl_Type, L_State      
      
Insert Into #StampDuty_Report      
Select         
DelAmount = Sum(Case When Sett_Type in ('W', 'C')       
        Then PDAmt+SDAmt+PTAmt+STAmt      
        Else PDAmt+SDAmt       
   End),      
TrdAmount = Abs(Sum(Case When Sett_Type in ('W', 'C')       
        Then 0      
        Else STAmt + PTAmt       
   End)),      
TotalAmt = sum(totamt),      
Cl_Type, L_State = Owner.State      
From #StampDuty, Owner Where Not Exists (Select State From State_Master Where State = L_State )      
Group by Cl_Type, Owner.State      
      
Insert Into #StampDuty_Report      
Select         
DelAmount = Sum(Case When Sett_Type in ('W', 'C')       
        Then PDAmt+SDAmt+PTAmt+STAmt      
        Else PDAmt+SDAmt       
   End),      
TrdAmount = Abs(Sum(Case When Sett_Type in ('W', 'C')       
        Then 0      
        Else STAmt + PTAmt       
   End)),      
TotalAmt = sum(totamt),      
Cl_Type, L_State = 'OTHER'      
From #StampDuty Where Exists (Select State From State_Master Where State = L_State)      
And L_State <> 'MAHARASHTRA'
Group by Cl_Type, L_State
      
Select       
TotTurn              = Sum(TotalAmt),      
TotTurnOtherState    = Sum(Case When L_State <> 'MAHARASHTRA' Then TotalAmt Else 0 End),      
TotTurnMahState      = Sum(Case When L_State = 'MAHARASHTRA' Then TotalAmt Else 0 End),      
TotTurnMahPro        = Pradnya.DBO.RoundedToThousand(Sum(Case When L_State = 'MAHARASHTRA' And Cl_Type = 'PRO' Then TotalAmt Else 0 End)),      
TotTurnMahProStamp   = Pradnya.DBO.RoundedToThousand(Sum(Case When L_State = 'MAHARASHTRA' And Cl_Type = 'PRO' Then TotalAmt Else 0 End))*.001/100,      
TotTurnMahTrd        = Pradnya.DBO.RoundedToThousand(Sum(Case When L_State = 'MAHARASHTRA' And Cl_Type <> 'PRO' Then TrdAmount Else 0 End)),      
TotTurnMahTrdStamp   = Pradnya.DBO.RoundedToThousand(Sum(Case When L_State = 'MAHARASHTRA' And Cl_Type <> 'PRO' Then TrdAmount Else 0 End))*.002/100,      
TotTurnMahDel        = Pradnya.DBO.RoundedToThousand(Sum(Case When L_State = 'MAHARASHTRA' And Cl_Type <> 'PRO' Then DelAmount Else 0 End)),      
TotTurnMahDelStamp   = Pradnya.DBO.RoundedToThousand(Sum(Case When L_State = 'MAHARASHTRA' And Cl_Type <> 'PRO' Then DelAmount Else 0 End))*.01/100,      
TotalMahStamp        = Pradnya.DBO.RoundedToThousand(Sum(Case When L_State = 'MAHARASHTRA' And Cl_Type = 'PRO' Then TotalAmt Else 0 End))*.001/100      
                     + Pradnya.DBO.RoundedToThousand(Sum(Case When L_State = 'MAHARASHTRA' And Cl_Type <> 'PRO' Then TrdAmount Else 0 End))*.002/100      
                     + Pradnya.DBO.RoundedToThousand(Sum(Case When L_State = 'MAHARASHTRA' And Cl_Type <> 'PRO' Then DelAmount Else 0 End))*.01/100,      
TotTurnOthTrd        = Pradnya.DBO.RoundedToThousand(Sum(Case When L_State <> 'MAHARASHTRA' Then TrdAmount Else 0 End)),      
TotTurnOthTrdStamp   = Pradnya.DBO.RoundedToThousand(Sum(Case When L_State <> 'MAHARASHTRA' Then TrdAmount Else 0 End))*.002/100,      
TotTurnOthDel        = Pradnya.DBO.RoundedToThousand(Sum(Case When L_State <> 'MAHARASHTRA' Then DelAmount Else 0 End)),      
TotTurnOthDelStamp   = Pradnya.DBO.RoundedToThousand(Sum(Case When L_State <> 'MAHARASHTRA' Then DelAmount Else 0 End))*.01/100,      
TotalOthStamp        = Pradnya.DBO.RoundedToThousand(Sum(Case When L_State <> 'MAHARASHTRA' Then TrdAmount Else 0 End))*.002/100      
                     + Pradnya.DBO.RoundedToThousand(Sum(Case When L_State <> 'MAHARASHTRA' Then DelAmount Else 0 End))*.01/100,      
TotalStamp           = Pradnya.DBO.RoundedToThousand(Sum(Case When L_State = 'MAHARASHTRA' And Cl_Type = 'PRO' Then TotalAmt Else 0 End))*.001/100      
                     + Pradnya.DBO.RoundedToThousand(Sum(Case When L_State = 'MAHARASHTRA' And Cl_Type <> 'PRO' Then TrdAmount Else 0 End))*.002/100      
                     + Pradnya.DBO.RoundedToThousand(Sum(Case When L_State = 'MAHARASHTRA' And Cl_Type <> 'PRO' Then DelAmount Else 0 End))*.01/100      
                     + Pradnya.DBO.RoundedToThousand(Sum(Case When L_State <> 'MAHARASHTRA' Then TrdAmount Else 0 End))*.002/100      
                     + Pradnya.DBO.RoundedToThousand(Sum(Case When L_State <> 'MAHARASHTRA' Then DelAmount Else 0 End))*.01/100,      
TotTurnMahTrd_B      = Pradnya.DBO.RoundedToThousand(Sum(Case When L_State = 'MAHARASHTRA' Then TrdAmount Else 0 End)),      
TotTurnMahTrdStamp_B = Pradnya.DBO.RoundedToThousand(Sum(Case When L_State = 'MAHARASHTRA' Then TrdAmount Else 0 End))*.002/100,      
TotTurnMahDel_B      = Pradnya.DBO.RoundedToThousand(Sum(Case When L_State = 'MAHARASHTRA' Then DelAmount Else 0 End)),      
TotTurnMahDelStamp_B = Pradnya.DBO.RoundedToThousand(Sum(Case When L_State = 'MAHARASHTRA' Then DelAmount Else 0 End))*.01/100,      
TotalMahStamp_B      = Pradnya.DBO.RoundedToThousand(Sum(Case When L_State = 'MAHARASHTRA' Then TrdAmount Else 0 End))*.002/100      
                     + Pradnya.DBO.RoundedToThousand(Sum(Case When L_State = 'MAHARASHTRA' Then DelAmount Else 0 End))*.01/100      
From #StampDuty_Report      
      
Drop Table #StampDuty_Report      
Drop Table #StampDuty

GO
