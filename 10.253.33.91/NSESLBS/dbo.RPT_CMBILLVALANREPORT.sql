-- Object: PROCEDURE dbo.RPT_CMBILLVALANREPORT
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROC [dbo].[RPT_CMBILLVALANREPORT]   
(@STATUSID VARCHAR(25), @STATUSNAME VARCHAR(25),  
 @FROM_DATE VARCHAR(11), @TO_DATE VARCHAR(11),  
 @FROMPARTY VARCHAR(10), @TOPARTY VARCHAR(10))  
AS  
  
-- EXEC RPT_CMBILLVALANREPORT 'BROKER', 'BROKER', 'JAN  1 2005', 'JAN  1 2008', '0', 'ZZZ'  
  
Select Party_Code, Party_Name, Sauda_Date, Branch_Cd, Trader, PQtyTrd, SQtyTrd, PQtyDel, SQtyDel,   
Pbroktrd, Sbroktrd, Pbrokdel, Sbrokdel, Service_Tax, Ins_Chrg, Turn_Tax, Broker_Chrg, TradeType, TrdAmt, DelAmt,  
Exchange   
into #CMBillValan From CMBillValan C  
Where Sauda_Date Between @From_Date And @To_Date + ' 23:59:59'  
And Party_Code Between @FromParty And @ToParty  
And @StatusName =               
                  (case               
                        when @StatusId = 'BRANCH' then branch_cd              
                        when @StatusId = 'SUBBROKER' then sub_broker              
                        when @StatusId = 'Trader' then Trader              
                        when @StatusId = 'Family' then Family              
                        when @StatusId = 'Area' then Area              
                        when @StatusId = 'Region' then Region              
                        when @StatusId = 'Client' then party_code              
                  else               
                        'BROKER'              
                  End)  
And Party_Code In (  
Select Party_Code From ClientTaxes_New C1  
Where Sauda_Date Between FromDate And ToDate  
And C1.Party_Code Between @FromParty And @ToParty  
AND C.PARTY_CODE = C1.PARTY_CODE  
And (insurance_chrg = 0 or broker_note = 0 or turnover_tax = 0))  
  
Insert into #CMBillValan   
Select Party_Code, Party_Name, Sauda_Date, Branch_Cd, Trader, PQtyTrd, SQtyTrd, PQtyDel, SQtyDel,   
Pbroktrd, Sbroktrd, Pbrokdel, Sbrokdel, Service_Tax, Ins_Chrg, Turn_Tax, Broker_Chrg, TradeType, TrdAmt, DelAmt,  
Exchange   
From BSEDB.DBO.CMBillValan C  
Where Sauda_Date Between @From_Date And @To_Date + ' 23:59:59'  
And Party_Code Between @FromParty And @ToParty  
And @StatusName =               
                  (case               
                        when @StatusId = 'BRANCH' then branch_cd              
                        when @StatusId = 'SUBBROKER' then sub_broker              
                        when @StatusId = 'Trader' then Trader              
                        when @StatusId = 'Family' then Family              
                        when @StatusId = 'Area' then Area              
                        when @StatusId = 'Region' then Region              
                        when @StatusId = 'Client' then party_code              
                  else               
                        'BROKER'              
                  End)  
And Party_Code In (  
Select Party_Code From BSEDB.DBO.ClientTaxes_New C1  
Where Sauda_Date Between FromDate And ToDate  
And C1.Party_Code Between @FromParty And @ToParty  
AND C.PARTY_CODE = C1.PARTY_CODE  
And (insurance_chrg = 0 or broker_note = 0 or turnover_tax = 0))  
  
Update #cmBillvalan set ins_chrg = (Case When ins_chrg = 0 Then   
          (Case When SQtyTrd > 0   
             Then (SQtyTrd * (TrdAmt/(PQtyTrd+SQtyTrd+PQtyDel+SQtyDel)))*TRDSTT/100  
             Else 0   
           End)   
               +   (Case When (PQtyDel+SQtyDel) > 0   
                      Then ((PQtyDel+SQtyDel) * (TrdAmt/(PQtyTrd+SQtyTrd+PQtyDel+SQtyDel)))*DELSTT/100  
                   Else 0   
                    End)  
         Else 0   
         End),  
Turn_Tax = (Case When Turn_Tax = 0   
     Then (TrdAmt-DelAmt)*TRDTURN_TAX/100 + DelAmt*DELTurn_Tax/100  
     Else 0  
   End),  
broker_chrg = (Case When broker_chrg = 0   
     Then (TrdAmt-DelAmt)*TrdStamp_duty/100 + DelAmt*DelStamp_duty/100  
     Else 0  
      End)  
From Taxes_New T  
Where Sauda_Date Between From_Date And To_Date  
And tradetype in ('S', 'I')   
And (PQtyTrd+SQtyTrd+PQtyDel+SQtyDel) > 0   
And #CMBILLVALAN.Exchange = T.Exchange  
  
Update #cmBillvalan set   
service_tax = (Case When #cmBillvalan.Service_Tax = 0   
        Then (pbroktrd+sbroktrd+pbrokdel+sbrokdel  
       +(Case When TurnOver_Ac > 0 Then Turn_Tax Else 0 End)  
       +(Case When Broker_Note_Ac > 0 Then broker_chrg Else 0 End))*g.service_tax/100  
     else 0  
      End)  
from globals G  
Where Sauda_Date Between Year_Start_Dt And Year_End_Dt  
  
select party_Code, party_name,   
NSETurn = Sum(Case When Exchange = 'NSE' and tradetype in ('S', 'I')  
       Then TrdAmt   
       Else 0   
     End),  
BSETurn = Sum(Case When Exchange = 'BSE' and tradetype in ('S', 'I')  
       Then TrdAmt   
       Else 0   
     End),  
TotalTurn = Sum(Case When tradetype in ('S', 'I') Then TrdAmt Else 0 End),  
NSEBrok=sum(Case When Exchange = 'NSE' Then pbroktrd+sbroktrd+pbrokdel+sbrokdel Else 0 End),  
BSEBrok=sum(Case When Exchange = 'BSE' Then pbroktrd+sbroktrd+pbrokdel+sbrokdel Else 0 End),  
TotalBrok=sum(pbroktrd+sbroktrd+pbrokdel+sbrokdel),  
stt=sum(ins_chrg),  
stampduty=sum(broker_chrg),  
turn_tax = sum(turn_tax),  
service_tax = sum(service_tax),  
TotalChrg = sum(ins_chrg+broker_chrg+turn_tax+service_tax),  
branch_cd, trader  
from #cmBillvalan  
group by party_Code, party_name, branch_cd, trader  
order by party_Code, branch_cd, trader

GO
