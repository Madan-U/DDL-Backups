-- Object: PROCEDURE dbo.AfterContCursor
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE procedure    
 [dbo].[AfterContCursor]    
 (    
  @orderno varchar(16),    
  @tradeno varchar (20),    
  @partycd VARCHAR(10),    
  @scripcd VARCHAR(10),    
  @tdate varchar(11),    
  @mkrate FLOAT,    
  @sellbuy varchar(2),    
  @sett_type varchar(2),    
  @tmark varchar (2),    
  @flag INT,    
  @Memcode varchar(15),    
  @TerminalId as varchar(10),    
  @ToParty as Varchar(10),    
  @TQty Int,    
  @StatusName VarChar(50) = 'BROKER',    
  @FromWhere VarChar(50) = 'NOLOG'  
 )    
    
as    
    
Declare    
@@ContractNo Varchar(7),    
@@Cont Cursor,    
@@CNo Cursor,    
@@TNo Cursor,    
@@ttradeno Varchar(20),    
@@trade_no Varchar(20),    
@@Xtradeno Varchar(20),    
@@tradeqty int,    
@@marketrate money,    
@@netrate money,    
@@TFlag Int,    
@@getStyle As cursor,    
@@Dcontno As Int,    
@@YContno As Int,    
@@Style As Int,    
@@ContStyle As varchar(2),    
@@Sett_no  As varchar(10),    
@@TempContractno As Int,    
@@MyQty As Int  
  
Set NoCount On    
    
Select @Tdate = Ltrim(Rtrim(@Tdate))    
If Len(@Tdate) = 10    
Begin    
          Select @Tdate = STUFF(@Tdate, 4, 1,'  ')    
End    
    
Set @@Myqty = @Tqty    
    
Select @@ContStyle = Inscont  from Client1,client2   
Where client2.party_code = @toparty and client1.cl_code = client2.cl_code    
Select Top 1 @@Sett_no  = Sett_No from settlement  
Where settlement.party_code = @partycd  
and sauda_date Like  @TDate +'%'  
and sett_type like @sett_type  
And Scrip_CD Like @ScripCd   
  
Select @@Style = Style from owner    
    
--Select @@Contstyle    
--Select @@Sett_no    
--Select @@Style    
    
Set @@Cno = Cursor For    
        select TOP 1 contractno = client1.cl_type from settlement,client2,client1    
        where settlement.party_code = @Toparty and settlement.party_code = client2.party_code    
        and client1.cl_code = client2.cl_code    
Open @@CNo    
    
    
Fetch Next from @@CNo into @@ContractNo    
    
If @@Contractno = 'PRO'    
   Begin    
             Close @@Cno    
             Deallocate @@Cno    
             select @@Contractno =  '0000000'    
             Insert into errorlog Values (Getdate(), '  In AfterContcursor  PRO section ',  @@ContractNo + '     ' +@Tradeno + '   '+ @Partycd + '      ' +@Scripcd +'   ' +@Tdate + '   ' +Convert(Varchar,@Mkrate) + '    ' +  @Sellbuy  +  '   ' + @Sett_type +'   '+ @@Sett_no ,' ' + Convert(Varchar,@Flag) + '     ' + @Memcode + '   ' +@ToParty  + '    ' +  Convert(Varchar,@Tqty),'  ')        
   End  
Else If @@Contractno = 'NRI'  
Begin    
 Select @@Contractno = NULL  
 Select TOP 1 @@Contractno = (Case when client1.cl_type = 'PRO' then '0000000' else contractno end ) 
 From Settlement,Client2,Client1    
 Where settlement.party_code = client2.party_code    
 and client1.cl_code = client2.cl_code    
 and sauda_date Like  @TDate +'%'    
 and sett_type like @sett_type    
 And Scrip_Cd = @ScripCd  
 And Sell_Buy = @Sellbuy 
 AND CLIENT2.PARENTCODE IN (SELECT PARENTCODE FROM CLIENT2 WHERE PARTY_CODE = @Toparty) 
 
 If ( @@ContractNo Is Null  )    
 Begin    
  If @@Style = 0    
  Begin    
  Select @@ContractNo = Isnull(Max(Contractno)+1,'0000001') From Settlement    
  Where sauda_date Like  @TDate +'%'    
  and sett_type like @sett_type    
  Select @@TempContractNo = Isnull(Max(Contractno)+1,'0000001') From ISettlement    
  Where sauda_date Like  @TDate +'%'    
  And sett_type like @sett_type    
  If @@TempContractno > @@Contractno    
  Begin    
   Set @@Contractno = @@TempContractno    
  End    
 End    
 Else    
  If @@style = 1    
  Begin    
   Select @@ContractNo = Contractno + 1  From Contgen    
   Where @Tdate + ' 00:00:01' >= Start_Date and @Tdate + ' 00:00:01' <= End_Date    
  End    
  If @@Contractno > 0    
  Begin    
   Update ContGen set ContractNo = @@ContractNo where @tdate + ' 00:00:01' >= Start_Date and @tdate + ' 00:00:01' <= End_Date    
  End  
 End    
End     
Else    
Begin  
 Select @@Contractno = NULL  
 Select TOP 1 @@Contractno = (Case when client1.cl_type = 'PRO' then '0000000' else contractno end ) From Settlement,Client2,Client1    
 Where settlement.party_code = client2.party_code    
 and client1.cl_code = client2.cl_code    
 and sauda_date Like  @TDate +'%'    
 and sett_type like @sett_type
 AND CLIENT2.PARENTCODE IN (SELECT PARENTCODE FROM CLIENT2 WHERE PARTY_CODE = @Toparty) 

 If ( @@ContractNo Is Null  )    
 Begin    
  If @@Style = 0    
  Begin    
  Select @@ContractNo = Isnull(Max(Contractno)+1,'0000001') From Settlement    
  Where sauda_date Like  @TDate +'%'    
  and sett_type like @sett_type    
  Select @@TempContractNo = Isnull(Max(Contractno)+1,'0000001') From ISettlement    
  Where sauda_date Like  @TDate +'%'    
  And sett_type like @sett_type    
  If @@TempContractno > @@Contractno    
  Begin    
   Set @@Contractno = @@TempContractno    
  End    
 End    
 Else    
  If @@style = 1    
  Begin    
   Select @@ContractNo = Contractno + 1  From Contgen    
   Where @Tdate + ' 00:00:01' >= Start_Date and @Tdate + ' 00:00:01' <= End_Date    
  End    
  If @@Contractno > 0    
  Begin    
   Update ContGen set ContractNo = @@ContractNo where @tdate + ' 00:00:01' >= Start_Date and @tdate + ' 00:00:01' <= End_Date    
  End  
 End    
End  
  
Select @@Contractno = STUFF('0000000', 8 - Len(@@Contractno), Len(@@Contractno), @@Contractno)    
  
If @@Error < > 0    
Insert into errorlog Values (Getdate(), '  In AfterContcursor  Error Occured in section Get Contract Number  ', @OrderNo + '     ' +@Tradeno + '   '+ @Partycd + '      ' +@Scripcd +'   ' +@Tdate + '   ' +Convert(Varchar,@Mkrate) + '    ' +  @Sellbuy  +  '   ' + @Sett_type +'   '+ @@Sett_no ,' ' + Convert(Varchar,@Flag) + '     ' + @Memcode + '   ' +@ToParty  + '    ' +  Convert(Varchar,@Tqty),'  ')    
  
IF @FLAG =1    
BEGIN    
Set @@Cont = Cursor For    
       Select trade_no ,tradeqty,marketrate,netrate    
       from settlement where /*  billno = 0  */    
       Sett_no = @@Sett_no    
       and party_code like @partycd    
       and scrip_cd like  @scripcd    
       and sauda_date like @TDate +'%'    
       and marketrate = @mkrate    
       and sell_buy like @sellbuy    
       and tradeqty <> 0    
       and sett_type like @sett_type    
       and trade_no like @tradeno    
       and order_no like @orderno    
       and tmark like @tmark +'%'    
       and partipantcode = @Memcode    
       and user_id like @TerminalId    
       order by tradeqty desc    
END    
Else    
BEGIN    
Set @@Cont = Cursor For    
       Select trade_no ,tradeqty,marketrate,netrate    
       from settlement where  /* billno = 0 */    
       Sett_no = @@Sett_no    
       and party_code like @partycd    
       and scrip_cd like  @scripcd    
       and sauda_date like @TDate +'%'    
       and sell_buy like @sellbuy    
       and sett_type like @sett_type    
       and trade_no like @tradeno    
       and order_no like @orderno    
       and tmark like @tmark +'%'    
       and tradeqty <> 0    
       and partipantcode = @Memcode    
       and user_id like @TerminalId    
       order by tradeqty desc    
END    
Open @@Cont    
Fetch Next from @@Cont Into @@trade_no ,@@tradeqty,@@marketrate,@@netrate    
    
While @@Fetch_Status = 0 and @TQty > 0    
begin    
        if @@TradeQty > @TQty    
        Begin    
      Select @@TTradeNo = 'R' + @@trade_no    
      Select @@TFlag = 1    
      Select @@XTradeNo = '0'    
      While  @@TFlag = 1    
      Begin    
    Set @@TNo = Cursor for    
    Select trade_no from settlement where trade_no like @@ttradeno    
        and sauda_date Like @TDate + '%' and scrip_cd = @scripcd and    
      sell_buy = @sellbuy and sett_type like @sett_type    
                  and sett_no = @@Sett_no    
    Open @@TNo    
    Fetch next from @@Tno into @@XTradeNo    
    if @@Fetch_Status = 0 and @@XTradeNo <> '0'    
                  Begin    
         Select @@TTRadeno = 'R' + @@XTradeNo    
         Select @@TFlag = 1    
                  End    
    Else    
   Select @@TFlag = 0    
      End    
        End    
        Else    
            Select @@TTradeNo = @@trade_no    
    
 if @@TradeQty = @TQty    
 Begin    
  
 Insert into Settlement select  
 @@contractno,0,@@ttradeno,@toparty,Scrip_Cd,user_id,@@TradeQty, AUCTIONPART, MarketType,  
 series,order_no,MarketRate, Sauda_date,Table_no, Line_No ,Val_perc, Normal,Day_puc,day_sales,  
 Sett_purch,Sett_sales,Sell_buy,settflag ,Brokapplied, NetRate,amount =  (@Tqty *@@NetRate) ,  
 Ins_chrg,turn_tax,other_chrg, sebi_tax,Broker_chrg,Service_tax,Trade_amount= (@tqty * @@MarketRate) ,  
 Billflag,sett_no,nbrokapp ,nsertax ,n_netrate ,sett_type,partipantcode,status,pro_cli,cpid,instrument,  
 bookType,branch_id, tmark ,scheme,dummy1 ,dummy2  from Settlement  
 where sett_type = @sett_type and trade_no = @@trade_no and scrip_cd = @scripcd    
 and sauda_date Like @TDate + '%'  and sell_buy =@sellbuy  and party_code = @partycd    
 and netrate= @@NetRate and tmark like @tmark and partipantcode = @Memcode and  Sett_no = @@Sett_no and Tradeqty =  @@tradeqty    
   
 --print '5-@@contractno:' + convert(varchar, @@contractno)  
   
 Update Settlement set tradeqty= 0,Normal = 0,Day_puc = 0,day_sales = 0,Sett_purch = 0,Sett_sales  = 0,  
 marketrate = 0,Brokapplied = 0,NetRate = 0,Amount = 0,Ins_chrg = 0,turn_tax = 0,other_chrg = 0,  
 sebi_tax = 0,Broker_chrg = 0,Service_tax = 0,Trade_amount = 0,NBrokApp = 0,NSerTax = 0,N_NetRate = 0  
 where sett_type = @sett_type and trade_no = @@trade_no and scrip_cd = @scripcd    
 and sauda_date Like @TDate + '%'  and sell_buy =@sellbuy  and party_code = @partycd    
 and netrate= @@NetRate and tmark like @tmark and partipantcode = @Memcode and  Sett_no = @@Sett_no and Tradeqty =  @@tradeqty    
   
 Select @TQty = 0    
 end    
 else if @@TradeQty > @TQty    
 Begin    
 Insert into settlement select    
 @@contractno,0,@@ttradeno,@toparty,Scrip_Cd,user_id,@tqty, AUCTIONPART, MarketType,    
 series,order_no,MarketRate, Sauda_date,Table_no, Line_No ,Val_perc, Normal,Day_puc,day_sales,    
 Sett_purch,Sett_sales,Sell_buy,settflag ,Brokapplied, NetRate,amount =  (@Tqty *@@NetRate) ,    
 Ins_chrg,turn_tax,other_chrg, sebi_tax,Broker_chrg,Service_tax,Trade_amount= (@tqty * @@MarketRate) ,    
 Billflag,sett_no,nbrokapp ,nsertax ,n_netrate ,sett_type,partipantcode,status,pro_cli,cpid,instrument,    
 bookType,branch_id,tmark ,scheme,dummy1,dummy2  from settlement    
 where sett_type = @sett_type and trade_no = @@trade_no and scrip_cd = @scripcd    
 and sauda_date Like @TDate + '%'  and sell_buy =@sellbuy  and party_code = @partycd    
 and netrate= @@NetRate and tmark like @tmark and partipantcode = @Memcode and  Sett_no = @@Sett_no    
 and Tradeqty =  @@tradeqty    
  
 update settlement set TradeQty = @@TradeQty - @TQty, Amount = (@@TradeQty - @TQty) * Marketrate    
 where sett_type = @sett_type and trade_no = @@trade_no and scrip_cd = @scripcd    
 and sauda_date Like @TDate + '%'  and sell_buy =@sellbuy  and party_code = @partycd    
 and netrate= @@NetRate and tmark like @tmark and partipantcode = @Memcode and  Sett_no = @@Sett_no    
 and Tradeqty =  @@tradeqty    
  
 Select @TQty = 0    
 end    
 else if @@TradeQty < @TQty    
 Begin    
  
   
 Insert into Settlement select  
 @@contractno,0,@@ttradeno,@toparty,Scrip_Cd,user_id,@@TradeQty, AUCTIONPART, MarketType,  
 series,order_no,MarketRate, Sauda_date,Table_no, Line_No ,Val_perc, Normal,Day_puc,day_sales,  
 Sett_purch,Sett_sales,Sell_buy,settflag ,Brokapplied, NetRate,amount =  (@@Tradeqty *@@NetRate) ,  
 Ins_chrg,turn_tax,other_chrg, sebi_tax,Broker_chrg,Service_tax,Trade_amount= (@tqty * @@MarketRate) ,  
 Billflag,sett_no,nbrokapp ,nsertax ,n_netrate ,sett_type,partipantcode,status,pro_cli,cpid,instrument,  
 bookType,branch_id, tmark ,scheme,dummy1  ,dummy2  from Settlement  
 where sett_type = @sett_type and trade_no = @@trade_no and scrip_cd = @scripcd    
 and sauda_date Like @TDate + '%'  and sell_buy =@sellbuy  and party_code = @partycd    
 and netrate= @@NetRate and tmark like @tmark and partipantcode = @Memcode and  Sett_no = @@Sett_no    
 and Tradeqty =  @@tradeqty    
   
 --print '7-@@contractno:' + convert(varchar, @@contractno)  
   
 update Settlement set tradeqty= 0,Normal = 0,Day_puc = 0,day_sales = 0,Sett_purch = 0,Sett_sales  = 0,                 marketrate = 0,Brokapplied = 0,NetRate = 0,Amount = 0,Ins_chrg = 0,turn_tax = 0,other_chrg = 0,  
 sebi_tax = 0,Broker_chrg = 0,Service_tax = 0,Trade_amount = 0,NBrokApp = 0,NSerTax = 0,N_NetRate = 0  
 where sett_type = @sett_type and trade_no = @@trade_no and scrip_cd = @scripcd    
 and sauda_date Like @TDate + '%'  and sell_buy =@sellbuy  and party_code = @partycd    
 and netrate= @@NetRate and tmark like @tmark and partipantcode = @Memcode and  Sett_no = @@Sett_no    
 and Tradeqty =  @@tradeqty    
   
  Select @TQty = @TQty - @@TradeQty    
 end    
 Fetch Next from @@Cont Into @@trade_no ,@@tradeqty,@@marketrate,@@netrate    
end    
    
If @@Error < > 0    
  
Insert into errorlog Values (Getdate(), '  In AfterContcursorins   Error Occured in section Actual Transfer  ', @OrderNo + '     ' +@Tradeno + '   '+ @Partycd + '      ' +@Scripcd +'   ' +@Tdate + '   ' +Convert(Varchar,@Mkrate) + '    ' +  @Sellbuy  +  '
   ' + @Sett_type +'   '+ @@Sett_no ,' ' + Convert(Varchar,@Flag) + '     ' + @Memcode + '   ' +@ToParty  + '    ' +  Convert(Varchar,@Tqty),'  ')    
    
If @StatusName <> 'NOLOG'  
Begin  
 If @@Error = 0    
 Begin    
 --Insert into contlogin values( 'SA',  @Partycd,@ToParty,@Scripcd, 'EQ', @@MyQty,@SellBuy, @Tdate,@@ContractNo, Getdate(), 0,@@TTradeNo)    
  insert into details Values  ( Left(convert(varchar,@Tdate,109),11),@@Sett_no,@sett_type,@ToParty,'S' )    
      
  insert into inst_log values    
  (    
   ltrim(rtrim(@partycd)), /*party_code*/    
   ltrim(rtrim(@ToParty)), /*new_party_code*/    
   convert(datetime, ltrim(rtrim(@tdate))),  /*sauda_date*/    
   ltrim(rtrim('')),  /*sett_no*/    
   ltrim(rtrim(@sett_type)),  /*sett_type*/    
   ltrim(rtrim(@scripcd)), /*scrip_cd*/    
   ltrim(rtrim('NSE')), /*series*/    
   ltrim(rtrim(@orderno)),  /*order_no*/    
   ltrim(rtrim(@tradeno)),  /*trade_no*/    
   ltrim(rtrim(@sellbuy)), /*sell_buy*/    
   ltrim(rtrim('')), /*contract_no*/    
   ltrim(rtrim('')), /*new_contract_no*/    
   0,  /*brokerage*/    
   0,  /*new_brokerage*/    
   @mkrate,  /*market_rate*/    
   @mkrate,  /*new_market_rate*/    
   0,  /*net_rate*/    
   0,  /*new_net_rate*/    
   @TQty,  /*qty*/    
   @TQty,  /*new_qty*/    
   ltrim(rtrim(@Memcode)),  /*participant_code*/    
   ltrim(rtrim(@Memcode)),  /*new_participant_code*/    
   ltrim(rtrim(@StatusName)),  /*username*/    
   ltrim((@FromWhere)),  /*module*/    
   'AfterContCursor', /*called_from*/    
   getdate(), /*timestamp*/    
   ltrim(rtrim('')), /*extrafield3*/    
   ltrim(rtrim('')), /*extrafield4*/    
   ltrim(rtrim(''))  /*extrafield5*/    
  )    
     
 End  
End

GO
