-- Object: PROCEDURE dbo.Proc_NSEBSE_Combine
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc [dbo].[Proc_NSEBSE_Combine] (@FROMDATE Varchar(11), @TODATE Varchar(11))      
As                    
Delete From NSEBSEValan                     
Where Sauda_Date >= @FROMDATE AND SAUDA_DATE <= @TODATE + ' 23:59:59'      
  
Insert into NSEBSEValan                     
Select C.Sett_No, C.Sett_Type, C.Billno, C.Contractno, C.Party_Code, C.Party_Name, C.Scrip_Cd, C.Series,                     
C.Scrip_Name, C.Isin, C.Sauda_Date, C.Pqtytrd, C.Pamttrd, C.Pqtydel, C.Pamtdel, C.Sqtytrd, C.Samttrd,                     
C.Sqtydel, C.Samtdel, C.Pbroktrd, C.Sbroktrd, C.Pbrokdel, C.Sbrokdel, C.Family, C.Family_Name, C.Terminal_Id,                     
C.Clienttype, C.Tradetype, C.Trader, C.Sub_Broker, C.Branch_Cd, O.MemberCode, C.Pamt, C.Samt, C.Prate, C.Srate,                     
C.Trdamt, C.Delamt, C.Serinex, Service_Tax = C.Service_Tax - Exservice_Tax, C.Exservice_Tax, C.Turn_Tax, C.Sebi_Tax, C.Ins_Chrg, C.Broker_Chrg,                     
C.Other_Chrg, C.Region, C.Start_Date, C.End_Date, Update_Date=left(GetDate(),11), C.Status_Name, C.Exchange, C.Segment,                     
O.Membercode, C.Companyname, SBU='', RelMGR='', Grp='', Dummy4=0, dummy5=0, C.Area, ExchgCode=Scrip_Cd                     
From CMBillValan C, Sett_Mst S, Owner O                    
Where C.Sett_No = S.Sett_No                    
And C.Sett_Type = S.Sett_Type                    
AND s.Start_Date >= @FROMDATE AND s.Start_Date <= @TODATE + ' 23:59:59'      
And TradeType IN ('S', 'I')          
                    
Insert into NSEBSEValan                     
Select C.Sett_No, C.Sett_Type, C.Billno, C.Contractno, C.Party_Code, C.Party_Name, C.Scrip_Cd, C.Series,                     
C.Scrip_Name, C.Isin, C.Sauda_Date, C.Pqtytrd, C.Pamttrd, C.Pqtydel, C.Pamtdel, C.Sqtytrd, C.Samttrd,                     
C.Sqtydel, C.Samtdel, C.Pbroktrd, C.Sbroktrd, C.Pbrokdel, C.Sbrokdel, C.Family, C.Family_Name, C.Terminal_Id,                     
C.Clienttype, C.Tradetype, C.Trader, C.Sub_Broker, C.Branch_Cd, O.MemberCode, C.Pamt, C.Samt, C.Prate, C.Srate,                     
C.Trdamt, C.Delamt, C.Serinex, Service_Tax = C.Service_Tax - Exservice_Tax, C.Exservice_Tax, C.Turn_Tax, C.Sebi_Tax, C.Ins_Chrg, C.Broker_Chrg,                     
C.Other_Chrg, C.Region, C.Start_Date, C.End_Date, Update_Date=left(GetDate(),11), C.Status_Name, C.Exchange, C.Segment,                     
O.Membercode, C.Companyname, SBU='', RelMGR='', Grp='', Dummy4=0, dummy5=0, C.Area, ExchgCode=Scrip_Cd                     
From BSEDB.DBO.CMBillValan C, BSEDB.DBO.Owner O                    
Where Sauda_Date >= @FROMDATE AND SAUDA_DATE <= @TODATE + ' 23:59:59'      
And TradeType IN ('S', 'I')          
          
Insert into NSEBSEValan                     
Select C.Sett_No, C.Sett_Type, C.Billno, C.Contractno, C.Party_Code, C.Party_Name, C.Scrip_Cd, C.Series,                     
C.Scrip_Name, C.Isin, C.Sauda_Date, Pqtytrd=0, Pamttrd=0, Pqtydel=0, Pamtdel=0, Sqtytrd=0, Samttrd=0,                     
Sqtydel=0, Samtdel=0, C.Pbroktrd, C.Sbroktrd, C.Pbrokdel, C.Sbrokdel, C.Family, C.Family_Name, C.Terminal_Id,                     
C.Clienttype, C.Tradetype, C.Trader, C.Sub_Broker, C.Branch_Cd, O.MemberCode, Pamt=0, Samt=0, Prate=0, Srate=0,                     
Trdamt=0, Delamt=0, C.Serinex, Service_Tax = C.Service_Tax - Exservice_Tax, C.Exservice_Tax, Turn_Tax=0, Sebi_Tax=0, Ins_Chrg=0, Broker_Chrg=0,                     
Other_Chrg=0, C.Region, C.Start_Date, C.End_Date, Update_Date=left(GetDate(),11), C.Status_Name, C.Exchange, C.Segment,                     
O.Membercode, C.Companyname, SBU='', RelMGR='', Grp='', Dummy4=0, dummy5=0, C.Area, ExchgCode=Scrip_Cd                     
From BSEDB.DBO.CMBillValan C, BSEDB.DBO.Owner O                    
Where Sauda_Date >= @FROMDATE AND SAUDA_DATE <= @TODATE + ' 23:59:59'          
And TradeType not IN ('S', 'I')          
and C.Pbroktrd + C.Sbroktrd + C.Pbrokdel + C.Sbrokdel > 0           
          
Update NSEBSEValan Set Scrip_Cd = M.Scrip_Cd, Series = M.Series                    
From MultiIsIn M Where M.IsIn = NSEBSEValan.IsIn                    
And Valid = 1 And Exchange = 'BSE'                     
AND Sauda_Date >= @FROMDATE AND SAUDA_DATE <= @TODATE + ' 23:59:59'                   
    
Insert into NSEBSEValan                  
select Sett_No='',Sett_Type='',Billno,Contractno,Party_Code,Party_Name,Symbol,'',                  
Scrip_Name=RTrim(Symbol)+'-'+RTrim(Inst_Type)+'-'+Left(ExpiryDate,11)+'-'+RTrim(Option_Type)+'-'+RTrim(Convert(Varchar,Strike_Price)),                  
Isin,Sauda_Date,Pqtytrd=PQty,Pamttrd=Pamt,Pqtydel=0,Pamtdel=0,                  
Sqtytrd=SQty,Samttrd=SAmt,Sqtydel=0,Samtdel=0,Pbroktrd=PBrokAmt,                  
Sbroktrd=SBrokAmt,Pbrokdel=0,Sbrokdel=0,Family,FamilyName,                  
Terminal_Id,Client_type,Tradetype,Trader,Sub_Broker,                  
Branch_Code,Participantcode,Pamt,Samt,Prate,Srate,                  
Trdamt=(Case When inst_type LIKE 'OPT%'                   
                     AND auctionpart <> 'CA'                   
                     AND auctionpart <> 'EA'                  
                Then ((pqty*prate)+(sqty*srate))                   
  When inst_type LIKE 'FUT%' AND auctionpart <> 'CA'                   
  Then ((pqty*prate)+(sqty*srate))                   
   When inst_type LIKE 'OPT%'                   
                     AND auctionpart <> 'CA'                   
                     AND auctionpart = 'EA'                  
                Then ((pqty*strike_price)+(sqty*strike_price))                   
  Else 0                   
           End),                  
Delamt=0,InexSerflag,Service_Tax = Service_Tax - Exser_Tax,Exser_Tax,Turn_Tax,Sebi_Tax,Ins_Chrg,Broker_Note,                  
Other_Chrg,Region,Sauda_Date,Sauda_Date,UpdateDate=left(GetDate(),11),StatusName,Exchange,Segment,                  
Membertype,Companyname,SBU='', RelMGR='', Grp='',Dummy4=0, dummy5=0,                  
Area=Region,CommonCode=Symbol                  
from nsefo.DBO.FoBillValan                  
Where Sauda_Date >= @FROMDATE AND SAUDA_DATE <= @TODATE + ' 23:59:59'                  
And TradeType = 'BT'

GO
