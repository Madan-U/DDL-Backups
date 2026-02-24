-- Object: PROCEDURE dbo.rpt_proc_NSE_ClientWise_new
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_proc_NSE_ClientWise_new    Script Date: 2/26/2005 5:56:23 PM ******/      
/****** Object:  Stored Procedure dbo.rpt_proc_BSE_ClientWise    Script Date: Jan 09 2003 11:19:33 AM ******/          
          
CREATE  PROCEDURE rpt_proc_NSE_ClientWise_new          
 @DateFrom Varchar(50),          
 @DateTo Varchar(50),          
 @SettNoFrom Varchar(15),          
 @SettNoTo Varchar(15),          
 @ScripFrom Varchar(10),          
 @ScripTo Varchar(10),          
 @PartyFrom Varchar(10),          
 @PartyTo Varchar(10)          
AS          
  
  
If @SettNoFrom = ''  
Begin     
   Set @SettNoFrom = '000000'  
End  
  
If @SettNoTo = ''  
Begin     
   Set @SettNoTo = '999999'  
End  
  
If @ScripFrom = ''  
Begin     
   Set @ScripFrom = '0'  
End  
  
If @ScripTo = ''  
Begin     
   Set @ScripTo = 'Z'  
End  
  
If @PartyFrom = ''  
Begin     
   Set @PartyFrom = '0'  
End  
  
If @PartyTo = ''  
Begin     
   Set @PartyTo = 'Z'  
End  
  
  
          
SELECT          
                    
  Distinct (C.sett_no) ,          
  C.scrip_cd,          
  scrip_name,          
  C.party_code,          
  C.party_name,          
  SUM(pqtytrd+pqtydel) AS GrossPurchaseQty,          
  SUM(prate) / (CASE WHEN SUM(pqtytrd + pqtydel) > 0 THEN SUM(pqtytrd + pqtydel) ELSE 1 END) AS GrossPurchaseRate,          
  SUM(sqtytrd+sqtydel) AS GrossSellQty,          
  SUM(srate) / (CASE WHEN SUM(sqtytrd + sqtydel) > 0 THEN SUM(sqtytrd + sqtydel) ELSE 1 END) AS GrossSellRate,          
  SUM(pqtytrd+pqtydel) - SUM(sqtytrd+sqtydel) AS NetPurchSell,          
  SUM((Case When TradeType <> 'N' Then pqtytrd+pqtydel Else 0 End )) - SUM((Case When TradeType <> 'N' Then sqtytrd+sqtydel Else 0 End)) AS RecvDeliQty,          
  IsNull(Qty,0) + SUM((Case When TradeType = 'I' Then pqtytrd+pqtydel Else 0 End )) - SUM((Case When TradeType = 'I' Then sqtytrd+sqtydel Else 0 End)) AS ActualQty,          
  SUM((Case When TradeType <> 'N' Then pqtytrd+pqtydel Else 0 End )) - SUM((Case When TradeType <> 'N' Then sqtytrd+sqtydel Else 0 End)) - IsNull(Qty,0) -           
  SUM((Case When TradeType = 'I' Then pqtytrd+pqtydel Else 0 End )) + SUM((Case When TradeType = 'I' Then sqtytrd+sqtydel Else 0 End)) AS AuctionQty,          
  SUM((Case When TradeType = 'N' Then pqtytrd+pqtydel Else 0 End )) AS CumPurch,          
  SUM((Case When TradeType = 'N' Then sqtytrd+sqtydel Else 0 End)) AS CumSell,          
  SUM((Case When TradeType = 'N' Then pqtytrd+pqtydel Else 0 End )) - SUM((Case When TradeType = 'N' Then sqtytrd+sqtydel Else 0 End)) AS CumNet,          
  0 AS OtherInfo,          
  AddrLine1=L_Address1,          
  AddrLine2=L_Address2,          
  AddrLine3=L_Address3,          
  AddrCity=L_City,          
  AddrState=L_State,          
  AddrZIP=L_Zip,          
  C4.BankId,          
  C4.CltDpID,          
  BankName,          
  SubBrokerName=sb.Name,          
  Director='',--C5.directorname,          
  SabiNo=C1.fd_code
          
 FROM          
  cmbillvalan C LEFT OUTER JOIN rpt_deltransexeParty D          
  ON (C.sett_no = D.sett_No And C.sett_Type = D.sett_type And C.scrip_cd = D.scrip_cd And C.series = D.series And C.Party_Code = D.Party_Code),          
  Client1 C1, Client2 C2 Left Outer Join (Select Party_Code,C4.BankId,C4.CltDpId,B.BankName,DefDp,Depository From Client4 C4 Left Outer Join Bank B           
  ON (B.BankId = C4.BankId) ) C4          
  On (C2.Party_Code = C4.Party_Code AND (Depository='NSDL' OR Depository='CDSL') And DefDp = 1)          
        LEFT OUTER JOIN Client5 C5 ON C2.cl_code = C5.cl_code , subbrokers sb          
                  
 WHERE          
            
  C1.Cl_Code = C2.Cl_Code AND          
  C2.Party_Code = C.Party_Code AND          
  C1.Sub_Broker = sb.Sub_Broker AND          
  TradeType <> 'IR'          
  AND sauda_date >= @DateFrom + ' 00:00:00'    
  AND sauda_date <= @DateTo + ' 23:59:59'    
  AND C.sett_no  >= @SettNoFrom   
  AND C.sett_no  <= @SettNoTo    
  AND C.scrip_cd >= @ScripFrom   
  AND C.scrip_cd <= @ScripTo    
  AND C.party_code >= @PartyFrom   
  AND C.party_code <= @PartyTo    
          
 GROUP BY          
  C.sett_no,          
  C.scrip_cd,          
  scrip_name,          
  C.party_code,          
  party_name,          
  qty,          
  L_Address1,          
  L_Address2,          
  L_Address3,          
  L_City,          
  L_State,          
  L_Zip,          
  C4.BankId,          
  C4.CltDpID,          
  BankName,          
  sb.Name,          
  --C5.directorname,          
  C1.fd_code      
          
 ORDER BY          
  party_name,          
  scrip_name,          
  C.sett_no

GO
