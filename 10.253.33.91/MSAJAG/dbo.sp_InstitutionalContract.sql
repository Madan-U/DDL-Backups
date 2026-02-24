-- Object: PROCEDURE dbo.sp_InstitutionalContract
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

Create Proc sp_InstitutionalContract          
(@StatusId Varchar(15), @StatusName Varchar(25), @Sauda_Date Varchar(11), @Sett_No Varchar(7), @Sett_Type Varchar(2), @FromParty_code Varchar(10) ,@ToParty_code Varchar(10), @Branch Varchar(10), @Sub_broker Varchar(10),  
@FromCont Varchar(10), @ToCont varchar(10))          
  
As          
/*For Last Day of the Settlement or one Day Settlement Record */          
Select ContractNo, S.Party_code, Order_No='0000000000000000', TM='00000000', Trade_no='0000000000', Sauda_Date=Left(Convert(Varchar,Sauda_Date,109),11), S.Scrip_Cd, S.Series,          
ScripName = S1.Short_Name, SDT = Convert(Varchar,Sauda_date,103), Sell_Buy, Broker_Chrg =Sum(Broker_Chrg) , turn_tax=Sum(turn_tax),sebi_tax=Sum(sebi_tax), other_chrg=Sum(s.other_chrg),          
Ins_Chrg = Sum(Case When Insurance_Chrg = 1 Then Ins_chrg Else 0 End ),    
--Ins_Chrg = (Ins_chrg),    
NSerTax = Sum(Case When Service_chrg = 0 Then NSerTax Else 0 End ),          
  
fd_code,    
Mapidid = isnull(uc.mapidid,''),    
Sauda_Date1 = Left(Convert(Varchar,Sauda_date,109),11),          
PQty = sum(Case When Sell_Buy = 1 Then TradeQty Else 0 End),          
SQty = sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End),          
PRate = (Case When sum(Case When Sell_Buy = 1 Then TradeQty Else 0 End) > 0 Then           
  sum(Case When Sell_Buy = 1 Then MarketRate*TradeQty Else 0 End)/sum(Case When Sell_Buy = 1 Then TradeQty Else 0 End)          
        Else 0 End),          
SRate = (Case When sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End) > 0 Then           
  sum(Case When Sell_Buy = 2 Then MarketRate*TradeQty Else 0 End)/sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End)          
        Else 0 End),          
PBrok = (Case When sum(Case When Sell_Buy = 1 Then TradeQty Else 0 End) > 0 Then           
 sum(Case When Sell_Buy = 1           
       Then NBrokApp*TradeQty + (Case When Service_Chrg = 1           
                     Then NSertax          
                     Else 0           
            End)          
       Else 0 End ) / sum(Case When Sell_Buy = 1 Then TradeQty Else 0 End)             
 Else 0 End),          
SBrok = (Case When sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End) > 0 Then           
 sum(Case When Sell_Buy = 2           
       Then NBrokApp*TradeQty + (Case When Service_Chrg = 1           
                     Then NSertax          
                     Else 0           
            End)          
       Else 0 End ) / sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End)             
 Else 0 End),          
PNetRate = (Case When sum(Case When Sell_Buy = 1 Then TradeQty Else 0 End) > 0           
   Then Sum(Case When Sell_Buy = 1            
   Then N_NetRate*TradeQty +          
              (Case When Service_Chrg = 1           
        Then NSertax          
      Else 0           
        End)          
          Else 0           
            End)/ sum(Case When Sell_Buy = 1 Then TradeQty Else 0 End)          
    Else 0 End) ,          
SNetRate = (Case When sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End) > 0           
   Then Sum(Case When Sell_Buy = 2            
   Then N_NetRate*TradeQty -          
              (Case When Service_Chrg = 1           
        Then NSertax          
      Else 0           
        End)          
          Else 0           
          End)/ sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End)          
    Else 0 End) ,          
PAmt = Sum(Case When Sell_Buy = 1            
   Then N_NetRate*TradeQty +          
              (Case When Service_Chrg = 1           
        Then NSertax          
      Else 0           
        End)          
          Else 0           
            End),          
SAmt = Sum(Case When Sell_Buy = 2            
   Then N_NetRate*TradeQty -          
              (Case When Service_Chrg = 1           
        Then NSertax          
      Else 0           
        End)          
          Else 0           
            End),          
Brokerage = Sum(TradeQty*NBrokApp+(Case When Service_Chrg = 1 Then NserTax Else 0 End)),          
--Broker_Chrg =(Case When BrokerNote = 1 Then Broker_Chrg Else 0 End ),    
--turn_tax =(Case When Turnover_tax = 1 Then turn_tax Else 0 End),    
--sebi_tax =(Case When Sebi_Turn_tax = 1 Then sebi_tax Else 0 End),    
--other_chrg =(Case When c2.Other_chrg = 1 Then f.other_chrg Else 0 End) ,     
--Ins_Chrg = (Case When Insurance_Chrg = 1 Then Sum(Ins_chrg) Else 0 End ),       
    
S.Sett_No, S.Sett_Type, TradeType = '  ',          
Tmark = 'D' ,          
/*To display the header part*/          
Partyname = c1.Long_name,          
c1.l_address1,c1.l_address2,c1.l_address3,          
c1.l_city,c1.l_zip, c2.service_chrg,c1.Branch_cd ,c1.sub_broker,c1.pan_gir_no, c2.bankid,          
c1.Off_Phone1,c1.Off_Phone2 Into #ContSett          
From iSettlement S, Sett_Mst M, Scrip1 S1, Scrip2 S2, client1 c1, --Client2 C2     
Client2 C2 left outer join ucc_client uc on C2.Cl_Code = uc.Party_Code          
Where Sauda_date <= @Sauda_Date + ' 23:59'           
And s.Party_code between @FromParty_Code And  @ToParty_Code  
And s.ContractNo >= @FromCont And s.ContractNo <= @ToCont          
And S.Sett_No = @Sett_No And S.Sett_Type = @Sett_Type          
And S.Sett_No = M.Sett_No And S.Sett_Type = M.Sett_Type          
And M.End_date Like @Sauda_Date + '%' And S1.Co_Code = S2.Co_Code          
And S2.Series = S1.Series And S2.Scrip_Cd = S.Scrip_CD And S2.Series = S.Series          
and c1.cl_code = c2.cl_code           
and s.party_code = c2.party_code          
and s.tradeqty > 0          
and Branch_cd Like (Case When @StatusId = 'branch' Then @statusname else '%' End)          
and Sub_broker Like (Case When @StatusId = 'subbroker' Then @statusname else '%' End)          
and Trader Like (Case When @StatusId = 'trader' Then @statusname else '%' End)          
and Family Like (Case When @StatusId = 'family' Then @statusname else '%' End)          
and C2.Party_Code Like (Case When @StatusId = 'client' Then @statusname else '%' End)          
and Branch_cd like @Branch          
and Sub_Broker like @Sub_Broker          
Group By ContractNo, S.Party_code, Left(Convert(Varchar,Sauda_Date,109),11), S.Scrip_Cd,S.Series,S1.Short_Name,          
Convert(Varchar,Sauda_date,103), Sell_Buy,S.Sett_No, S.Sett_Type, c1.Long_name,c1.l_address1,c1.l_address2,c1.l_address3,          
c1.l_city,c1.l_zip, c2.service_chrg,c1.Branch_cd ,c1.sub_broker,c1.pan_gir_no, c2.bankid,          
c1.Off_Phone1,c1.Off_Phone2,uc.mapidid, fd_code    
--S.Broker_Chrg, C2.BrokerNote, S.turn_tax ,  C2.Turnover_tax,S.sebi_tax, C2.Sebi_Turn_tax,    
--Ins_chrg --,C2.Insurance_Chrg    
          
Update #ContSett Set Order_No = S.Order_No, TM = Convert(Varchar,S.Sauda_Date,108), Trade_No = S.Trade_No          
From ISettlement S Where S.Sauda_Date Like @Sauda_Date + '%'          
And S.Scrip_cd = #ContSett.Scrip_CD          
And S.Series = #ContSett.Series          
And S.Party_Code = #ContSett.Party_Code          
And S.Sell_Buy = #ContSett.Sell_Buy          
And S.Sauda_Date = (Select Min(Sauda_Date) From ISettlement ISett          
Where ISett.Sauda_Date Like @Sauda_Date + '%'          
And S.Scrip_cd = ISett.Scrip_CD          
And S.Series = ISett.Series          
And S.Party_Code = ISett.Party_Code          
And S.Sell_Buy = ISett.Sell_Buy )          
          
Select * From #ContSett          
order by Branch_cd,Party_code,Partyname,ScripName, Sett_No, Sett_Type,Order_No, Trade_No

GO
