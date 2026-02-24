-- Object: PROCEDURE dbo.NSESettBrokEditIns
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE procedure    
 NSESettBrokEditIns    
 (    
  @sett_no varchar(7),    
  @sett_type varchar(2),    
  @tparty varchar(10),    
  @tscrip_cd varchar(12),    
  @tseries varchar(3),    
  @tdate varchar(11),    
  @Sell_buy varchar(1),    
  @partipantCode varchar(15),    
  @Orderno varchar(16),    
  @contractno varchar(7),    
  @Trade_no varchar(14),    
  @Mrate numeric(18,6),    
  @BrokRage numeric(18,6),    
  @NetRate numeric(18,6),    
  @BrokNetFlag Int,    
  @Valper int,    
  @StatusName VarChar(50),    
  @FromWhere VarChar(50)    
 )    
    
as    
    
Select @Tdate = Ltrim(Rtrim(@Tdate))    
If Len(@Tdate) = 10    
Begin    
          Select @Tdate = STUFF(@Tdate, 4, 1,'  ')    
End    
    
    
Select @Tparty = Ltrim(Rtrim(@Tparty))    
Select @Tscrip_cd = Ltrim(Rtrim(@TScrip_cd))    
    
    
/*    
 BrokNetFlag = 0 Update Brokerage    
 BrokNetFlag = 1 Update NetRate    
*/    
    
if @BroknetFlag = 0    
Begin    
Update ISettlement set Tmark = Tmark,    
       BrokApplied =(Case when ISettlement.status = 'N'    
        then 0    
        else (Case When @ValPer = 0    
          Then  @BrokRage    
      /*(floor((Abs(@BrokRage)*power(10,CT.Round_To)+CT.RoFig + CT.Errnum)/    
                      (CT.RoFig + CT.Nozero))*(CT.RoFig +CT.Nozero))/power(10,CT.Round_To) */    
    
          Else    
      (floor((Abs(@BrokRage*MarketRate/100)*power(10,CT.Round_To)+CT.RoFig + CT.Errnum)/    
                     (CT.RoFig + CT.Nozero))*(CT.RoFig +CT.Nozero))/power(10,CT.Round_To)    
          End )    
                End),    
       NetRate = (Case when ISettlement.status = 'N'    
         then ISettlement.MARKETRATE    
                     else (Case When Sell_Buy = 1    
              Then ( Case  When @ValPer = 0    
                       Then MarketRate + @BrokRage    
       /*(floor((Abs(MarketRate + @BrokRage)*power(10,CT.Round_To)+CT.RoFig + CT.Errnum)/    
                               (CT.RoFig + CT.Nozero))*(CT.RoFig +CT.Nozero))/power(10,CT.Round_To) */    
                             Else    
       (floor((Abs(MarketRate + (@BrokRage*MarketRate/100))*power(10,CT.Round_To)+CT.RoFig + CT.Errnum)/    
                                 (CT.RoFig + CT.Nozero))*(CT.RoFig +CT.Nozero))/power(10,CT.Round_To)    
             End)    
              Else ( Case  When @ValPer = 0    
                       Then MarketRate - @BrokRage    
       /*(floor((Abs(MarketRate - @BrokRage)*power(10,CT.Round_To)+CT.RoFig + CT.Errnum)/    
                               (CT.RoFig + CT.Nozero))*(CT.RoFig +CT.Nozero))/power(10,CT.Round_To) */    
                             Else    
       (floor((Abs(MarketRate - (@BrokRage*MarketRate/100))*power(10,CT.Round_To)+CT.RoFig + CT.Errnum)/    
                                 (CT.RoFig + CT.Nozero))*(CT.RoFig +CT.Nozero))/power(10,CT.Round_To)    
             End)    
    End)    
            End),    
       Amount = TradeQty*(Case when ISettlement.status = 'N'    
           then ISettlement.MARKETRATE    
                      else (Case When Sell_Buy = 1    
               Then ( Case  When @ValPer = 0    
                        Then MarketRate + @BrokRage    
        /*(floor((Abs(MarketRate + @BrokRage)*power(10,CT.Round_To)+CT.RoFig + CT.Errnum)/    
                                (CT.RoFig + CT.Nozero))*(CT.RoFig +CT.Nozero))/power(10,CT.Round_To) */    
                              Else    
        (floor((Abs(MarketRate + (@BrokRage*MarketRate/100))*power(10,CT.Round_To)+CT.RoFig + CT.Errnum)/    
                                  (CT.RoFig + CT.Nozero))*(CT.RoFig +CT.Nozero))/power(10,CT.Round_To)    
              End)    
               Else ( Case  When @ValPer = 0    
                        Then MarketRate - @BrokRage    
        /*(floor((Abs(MarketRate - @BrokRage)*power(10,CT.Round_To)+CT.RoFig + CT.Errnum)/    
                                (CT.RoFig + CT.Nozero))*(CT.RoFig +CT.Nozero))/power(10,CT.Round_To) */    
                              Else    
        (floor((Abs(MarketRate - (@BrokRage*MarketRate/100))*power(10,CT.Round_To)+CT.RoFig + CT.Errnum)/    
                                  (CT.RoFig + CT.Nozero))*(CT.RoFig +CT.Nozero))/power(10,CT.Round_To)    
              End)    
     End)    
             End),    
       Service_Tax = (Case when ISettlement.status = 'N'    
         then 0    
      Else (Case When @Valper = 0    
           Then ((floor((((floor((Abs(@BrokRage)*power(10,CT.Round_To)+CT.RoFig+CT.Errnum)/    
        (CT.RoFig + CT.Nozero))*(CT.RoFig +CT.Nozero))/power(10,CT.Round_To)*ISettlement.Tradeqty*Globals.service_tax)/    
                (CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax) END)*power(10,CT.Round_To)+CT.RoFig + CT.Errnum ) /    
                                                               (CT.RoFig + CT.Nozero))*(CT.RoFig +CT.Nozero))/power(10,CT.Round_To))    
           Else ((floor((((floor((Abs(@BrokRage*Marketrate/100)*power(10,CT.Round_To)+CT.RoFig+CT.Errnum)/    
        (CT.RoFig + CT.Nozero))*(CT.RoFig +CT.Nozero))/power(10,CT.Round_To)*ISettlement.Tradeqty*Globals.service_tax)/    
                (CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax) END)*power(10,CT.Round_To)+CT.RoFig + CT.Errnum ) /    
                                                               (CT.RoFig + CT.Nozero))*(CT.RoFig +CT.Nozero))/power(10,CT.Round_To))    
              End )    
        End),    
       Trade_amount = ISettlement.Tradeqty * ISettlement.MarketRate,    
       NBrokApp = (Case when ISettlement.status = 'N'    
        then 0    
        else (Case When @ValPer = 0    
          Then  @BrokRage    
      /*(floor((Abs(@BrokRage)*power(10,CT.Round_To)+CT.RoFig + CT.Errnum)/    
                      (CT.RoFig + CT.Nozero))*(CT.RoFig +CT.Nozero))/power(10,CT.Round_To) */    
    
          Else    
      (floor((Abs(@BrokRage*MarketRate/100)*power(10,CT.Round_To)+CT.RoFig + CT.Errnum)/    
                     (CT.RoFig + CT.Nozero))*(CT.RoFig +CT.Nozero))/power(10,CT.Round_To)    
          End )    
                End),    
       N_NetRate = (Case when ISettlement.status = 'N'    
         then ISettlement.MARKETRATE    
                     else (Case When Sell_Buy = 1    
              Then ( Case  When @ValPer = 0    
                       Then MarketRate + @BrokRage    
       /*(floor((Abs(MarketRate + @BrokRage)*power(10,CT.Round_To)+CT.RoFig + CT.Errnum)/    
                               (CT.RoFig + CT.Nozero))*(CT.RoFig +CT.Nozero))/power(10,CT.Round_To) */    
                             Else    
       (floor((Abs(MarketRate + (@BrokRage*MarketRate/100))*power(10,CT.Round_To)+CT.RoFig + CT.Errnum)/    
                                 (CT.RoFig + CT.Nozero))*(CT.RoFig +CT.Nozero))/power(10,CT.Round_To)    
             End)    
              Else ( Case  When @ValPer = 0    
                       Then MarketRate - @BrokRage    
       /*(floor((Abs(MarketRate - @BrokRage)*power(10,CT.Round_To)+CT.RoFig + CT.Errnum)/    
                               (CT.RoFig + CT.Nozero))*(CT.RoFig +CT.Nozero))/power(10,CT.Round_To) */    
                             Else    
       (floor((Abs(MarketRate - (@BrokRage*MarketRate/100))*power(10,CT.Round_To)+CT.RoFig + CT.Errnum)/                                   (CT.RoFig + CT.Nozero))*(CT.RoFig +CT.Nozero))/power(10,broktable.  
round_to)    
             End)    
    End)    
            End),    
       NSertax = (Case when ISettlement.status = 'N'    
         then 0    
      Else (Case When @Valper = 0    
           Then ((floor((((floor((Abs(@BrokRage)*power(10,CT.Round_To)+CT.RoFig+CT.Errnum)/    
        (CT.RoFig + CT.Nozero))*(CT.RoFig +CT.Nozero))/power(10,CT.Round_To)*ISettlement.Tradeqty*Globals.service_tax)/    
                (CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax) END)*power(10,CT.Round_To)+CT.RoFig + CT.Errnum ) /    
                                                               (CT.RoFig + CT.Nozero))*(CT.RoFig +CT.Nozero))/power(10,CT.Round_To))    
           Else ((floor((((floor((Abs(@BrokRage*Marketrate/100)*power(10,CT.Round_To)+CT.RoFig+CT.Errnum)/    
        (CT.RoFig + CT.Nozero))*(CT.RoFig +CT.Nozero))/power(10,CT.Round_To)*ISettlement.Tradeqty*Globals.service_tax)/    
                (CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax) END)*power(10,CT.Round_To)+CT.RoFig + CT.Errnum ) /    
                                                               (CT.RoFig + CT.Nozero))*(CT.RoFig +CT.Nozero))/power(10,CT.Round_To))    
              End )    
        End),    
      Status = 'E'    
      FROM BrokTable BrokTable,Client2 client2, globals,client1 client1 , Scrip1, Scrip2 , ClientBrok_Scheme B, ClientTaxes_New CT  
      WHERE ISettlement.Party_Code = Client2.Party_code    
 And client1.cl_code=client2.cl_code    
 And Scrip1.series = scrip2.series    
 and scrip1.co_code = scrip2.co_code    
 and scrip2.Scrip_Cd = ISettlement.Scrip_Cd    
 And ISettlement.series = scrip2.series    
 And B.Party_Code = CT.Party_Code  
 And B.Party_Code = client2.Party_Code  
 And CT.Trans_Cat = 'DEL'  
 And ISettlement.Sauda_Date Between FromDate And ToDate  
 And B.Trade_Type = 'INS'  
 And B.Scheme_Type = 'DEL'  
 And ISettlement.Sauda_Date Between From_Date And To_Date  
 And Broktable.Table_no = B.TABLE_NO    
 And    
 Broktable.Line_no = (Select min(line_no) from broktable where    
               table_no = B.TABLE_NO )    
  and ISettlement.party_code = @tparty    
  and ISettlement.sauda_date like @tdate + '%'    
  and ISettlement.scrip_cd Like @tscrip_cd    
  and ISettlement.Series like @tSeries    
  and ISettlement.tradeqty > 0    
  And ISettlement.Sett_type = @Sett_type    
  And ISettlement.Sett_no = @Sett_no    
  And ISettlement.Sell_buy = @Sell_Buy    
  And partipantcode = @partipantcode    
  And MarketRate = (Case When @MRate > 0 Then @MRate Else MarketRate End)    
  And Order_no like @OrderNo    
  And Trade_no like @Trade_No    
  And ContractNo Like @ContractNo    
  and ISettlement.Sauda_date > year_start_dt    
  and ISettlement.Sauda_date < year_end_dt    
End    
    
if @BroknetFlag = 1    
Begin    
    
    
Update ISettlement set Tmark = Tmark,    
       BrokApplied =(Case when ISettlement.status = 'N'    
        then 0    
        else (Case When Sell_Buy = 1    
         Then @NetRate-MarketRate    
         Else MarketRate-@NetRate    
    End )    
    /*(floor((Abs(@NetRate-MarketRate)*power(10,CT.Round_To)+CT.RoFig + CT.Errnum)/    
                 (CT.RoFig + CT.Nozero))*(CT.RoFig +CT.Nozero))/power(10,CT.Round_To)*/    
             End),    
       NetRate = (Case when ISettlement.status = 'N'    
         then ISettlement.MARKETRATE    
                else @NetRate    
       /*(floor((Abs(@NetRate)*power(10,CT.Round_To)+CT.RoFig + CT.Errnum)/    
              (CT.RoFig + CT.Nozero))*(CT.RoFig +CT.Nozero))/power(10,CT.Round_To)*/    
    End),    
       Amount = TradeQty*(Case when ISettlement.status = 'N'    
                 Then ISettlement.MARKETRATE    
                        else @NetRate    
        /*(floor((Abs(@NetRate)*power(10,CT.Round_To)+CT.RoFig + CT.Errnum)/    
                      (CT.RoFig + CT.Nozero))*(CT.RoFig +CT.Nozero))/power(10,CT.Round_To)*/    
          End),    
       Service_Tax = (Case when ISettlement.status = 'N'    
         then 0    
         else ((floor((((floor((Abs(@NetRate-MarketRate)*power(10,CT.Round_To)+CT.RoFig+CT.Errnum)/    
          (CT.RoFig + CT.Nozero))*(CT.RoFig +CT.Nozero))/power(10,CT.Round_To)*ISettlement.Tradeqty*Globals.service_tax)/    
    (CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax) END)*power(10,CT.Round_To)+CT.RoFig + CT.Errnum ) /    
                                (CT.RoFig + CT.Nozero))*(CT.RoFig +CT.Nozero))/power(10,CT.Round_To))    
        End),    
       Trade_amount = ISettlement.Tradeqty * ISettlement.MarketRate,    
       NBrokApp =   (Case when ISettlement.status = 'N'    
        then 0    
        else (Case When Sell_Buy = 1    
         Then @NetRate-MarketRate    
         Else MarketRate-@NetRate    
    End )    
    /*(floor((Abs(@NetRate-MarketRate)*power(10,CT.Round_To)+CT.RoFig + CT.Errnum)/    
                 (CT.RoFig + CT.Nozero))*(CT.RoFig +CT.Nozero))/power(10,CT.Round_To)*/    
             End),    
       N_NetRate = (Case when ISettlement.status = 'N'    
         then ISettlement.MARKETRATE    
                else @NetRate    
       /*(floor((Abs(@NetRate)*power(10,CT.Round_To)+CT.RoFig + CT.Errnum)/    
              (CT.RoFig + CT.Nozero))*(CT.RoFig +CT.Nozero))/power(10,CT.Round_To)*/    
      End),    
       NSerTax = (Case when ISettlement.status = 'N'    
          then 0    
      else ((floor((((floor((Abs(@NetRate-MarketRate)*power(10,CT.Round_To)+CT.RoFig+CT.Errnum)/    
          (CT.RoFig + CT.Nozero))*(CT.RoFig +CT.Nozero))/power(10,CT.Round_To)*ISettlement.Tradeqty*Globals.service_tax)/    
    (CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax) END)*power(10,CT.Round_To)+CT.RoFig + CT.Errnum ) /    
                                (CT.RoFig + CT.Nozero))*(CT.RoFig +CT.Nozero))/power(10,CT.Round_To))    
     End),    
      Status = 'E'    
      FROM BrokTable BrokTable,Client2 client2, globals,client1 client1 , Scrip1, Scrip2, ClientBrok_Scheme B, ClientTaxes_New  CT  
      WHERE ISettlement.Party_Code = Client2.Party_code    
  and    
 client1.cl_code=client2.cl_code And    
 Scrip1.series = scrip2.series    
 and scrip1.co_code = scrip2.co_code    
 and scrip2.Scrip_Cd = ISettlement.Scrip_Cd    
 And ISettlement.series = scrip2.series    
 And B.Party_Code = CT.Party_Code  
 And B.Party_Code = client2.Party_Code  
 And CT.Trans_Cat = 'DEL'  
 And ISettlement.Sauda_Date Between FromDate And ToDate  
 And B.Trade_Type = 'INS'  
 And B.Scheme_Type = 'DEL'  
 And ISettlement.Sauda_Date Between From_Date And To_Date  
 And Broktable.Table_no = B.TABLE_NO    
 And    
 Broktable.Line_no = (Select min(line_no) from broktable where    
                      table_no = B.TABLE_NO )    
  and ISettlement.party_code = @tparty    
  and ISettlement.sauda_date like @tdate + '%'    
  and ISettlement.scrip_cd Like @tscrip_cd    
  and ISettlement.Series like @tSeries    
  and ISettlement.tradeqty > 0    
  And ISettlement.Sett_type Like @Sett_type    
  And ISettlement.Sett_no Like @Sett_no    
  And ISettlement.Sell_buy = @Sell_Buy    
  And partipantcode = @partipantcode    
  And MarketRate = (Case When @MRate > 0 Then @MRate Else MarketRate End)    
  And Order_no Like  @OrderNo    
  And Trade_no like @Trade_No    
  And ContractNo Like @ContractNo    
  and ISettlement.Sauda_date > year_start_dt    
  and ISettlement.Sauda_date < year_end_dt    
End  
  
Update ISettlement Set Brokapplied = (Case When client2.Sertaxmethod = 1 Then BrokApplied Else   
Round(Brokapplied*100/(100 + Globals.service_tax),4) End ),  
Service_Tax = (Case When client2.Sertaxmethod = 1 Then 0 Else ( TradeQty * BrokApplied ) - ( Tradeqty * Round(Brokapplied*100/(100 + Globals.service_tax),4)) End) ,    
NBrokapp = (Case When client2.Sertaxmethod = 1 Then NBrokapp Else Round(Brokapplied*100/(100 + Globals.service_tax),4) End),  
NSerTax = (Case When client2.Sertaxmethod = 1 Then 0 Else ( TradeQty * BrokApplied) - ( Tradeqty * Round(Brokapplied*100/(100 + Globals.service_tax),4)) End),    
NetRate = (Case When client2.Sertaxmethod = 1 Then NetRate Else (Case When Sell_buy = 1 Then MarketRate + Round(Brokapplied*100/(100 + Globals.service_tax),4) Else MarketRate - Round(Brokapplied*100/(100 + Globals.service_tax),4) End) End),    
N_NetRate = (Case When client2.Sertaxmethod = 1 Then N_NetRate Else (Case When Sell_buy = 1 Then MarketRate + Round(Brokapplied*100/(100 + Globals.service_tax),4) Else MarketRate - Round(Brokapplied*100/(100 + Globals.service_tax),4) End) End),    
Amount = TradeQty*(Case When Sell_buy = 1 Then MarketRate + Round(Brokapplied*100/(100 + Globals.service_tax),4) Else MarketRate - Round(Brokapplied*100/(100 + Globals.service_tax),4) End)    
From Client1 C1, Client2 client2 , Globals    
Where C1.Cl_Code = client2.Cl_Code And client2.Party_Code = ISettlement.Party_Code    
And client2.Service_Chrg = 1 And ISettlement.party_code = @tparty    
and ISettlement.sauda_date like @tdate + '%'    
and ISettlement.scrip_cd Like @tscrip_cd    
and ISettlement.Series like @tSeries    
and ISettlement.tradeqty > 0    
And ISettlement.Sett_type Like @Sett_type    
And ISettlement.Sett_no Like @Sett_no    
And ISettlement.Sell_buy = @Sell_Buy    
And Partipantcode = @partipantcode    
And MarketRate = (Case When @MRate > 0 Then @MRate Else MarketRate End)    
And Order_no like @OrderNo    
And Trade_no like @Trade_No    
And ContractNo Like @ContractNo    
And Status = 'E'    
and ISettlement.Sauda_date > year_start_dt    
and ISettlement.Sauda_date < year_end_dt    
    
if @@error = 0    
begin    
 insert into inst_log values    
 (    
  ltrim(rtrim(@tparty)), /*party_code*/    
  ltrim(rtrim(@tparty)), /*new_party_code*/    
  convert(datetime, ltrim(rtrim(@tdate))),  /*sauda_date*/    
  ltrim(rtrim(@sett_no)),  /*sett_no*/    
  ltrim(rtrim(@sett_type)),  /*sett_type*/    
  ltrim(rtrim(@tscrip_cd)), /*scrip_cd*/    
  ltrim(rtrim(@tseries)), /*series*/    
  ltrim(rtrim(@Orderno)),  /*order_no*/    
  ltrim(rtrim(@Trade_no)),  /*trade_no*/    
  ltrim(rtrim(@Sell_buy)), /*sell_buy*/    
  ltrim(rtrim(@contractno)), /*contract_no*/    
  ltrim(rtrim(@contractno)), /*new_contract_no*/    
  @BrokRage,  /*brokerage*/    
  @BrokRage,  /*new_brokerage*/    
  @Mrate,  /*market_rate*/    
  @Mrate,  /*new_market_rate*/    
  @NetRate,  /*net_rate*/    
  @NetRate,  /*new_net_rate*/    
  0,  /*qty*/    
  0,  /*new_qty*/    
  ltrim(rtrim(@partipantCode)),  /*participant_code*/    
  ltrim(rtrim(@partipantCode)),  /*new_participant_code*/    
  ltrim(rtrim(@StatusName)),  /*username*/    
  ltrim((@FromWhere)),  /*module*/    
  'NSESettBrokEditIns', /*called_from*/    
  getdate(), /*timestamp*/    
  ltrim(rtrim('')), /*extrafield3*/    
  ltrim(rtrim('')), /*extrafield4*/    
  ltrim(rtrim(''))  /*extrafield5*/    
 )    
end

GO
