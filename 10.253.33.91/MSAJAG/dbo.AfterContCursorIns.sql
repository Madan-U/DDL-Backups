-- Object: PROCEDURE dbo.AfterContCursorIns
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE procedure  
 [dbo].[AfterContCursorIns]  
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
  @StatusName VarChar(50),  
  @FromWhere VarChar(50)  
 )  
  
As  
  
Declare  
@@ContractNo Varchar(7),  
@@Cont Cursor,  
@@CNo Cursor,  
@@TNo Cursor,  
/* @@Ttrade_no Varchar(14), */  
@@trade_no Varchar(20),  
@@Xtradeno Varchar(20),  
@@tradeqty int,  
@@marketrate money,  
@@netrate money,  
@@TFlag Int,  
@@Sett_no Varchar(10),  
@@getStyle As cursor,  
@@Dcontno As Int,  
@@YContno As Int,  
@@Style As Int,  
@@ContStyle As varchar(2),  
@@SameParty As Char(1),  
@@MemberCode  as Varchar(10),  
@@Tempcontractno As Int,  
@@Myqty As Int,  
@@TTradeNo As Varchar(20)  
  
If Len(@Orderno) = 0  
Begin  
          Select @orderno = '%'  
End  
  
Set @@MyQty = @Tqty  
  
Select @Tdate = Ltrim(Rtrim(@Tdate))  
If Len(@Tdate) = 10  
Begin  
          Select @Tdate = STUFF(@Tdate, 4, 1,'  ')  
End  
  
If @Partycd =  @Toparty  
 Select @@Sameparty = 'Y'  
Else  
        Select @@Sameparty = 'N'  
  
  
  
Select Distinct @@Sett_no = Sett_no  from isettlement  
Where isettlement.party_code = @partycd
and sauda_date Like  @TDate +'%'  
and sett_type like @sett_type  
and scrip_cd Like @scripcd

Select @@ContStyle = Inscont  from Client1,client2  where client2.party_code = @toparty and client1.cl_code = client2.cl_code  
Select @@Style = Style, @@MemberCode = Membercode from Owner  
Select @@ContractNo =  (Case when client1.cl_type = 'PRO' then 'PRO'  end ) From client2,client1  
Where client2.party_code = @ToParty  
and client1.cl_code = client2.cl_code  
  
If @@Contractno = 'PRO'  
   Begin  
             Select @@Contractno =  '0000000'  
   End  
Else  
Begin  
        If  (@@ContStyle = 'O')  And (@Flag < 3 ) And ( @@Sameparty = 'N')  
        Begin  
         Select @@contractno = Contractno from isettlement  
         Where isettlement.party_code = @Toparty  
         and sauda_date Like  @TDate +'%'  
         and sett_type like @sett_type  
         and sett_no = @@Sett_no  
         and Order_no = @Orderno  
     if (  (@@ContractNo Is Null ) And (@@Contstyle = 'O'))  
         Begin  
                          If @@style = 0  
                          Begin  
     Select @@ContractNo = Isnull(max(contractno)+1,'0000001') from isettlement  
       Where sauda_date Like  @TDate +'%'  
       and sett_type like @sett_type  
                                   and sett_no = @@Sett_no  
                        Select @@TempContractNo = Isnull(max(contractno)+1,'0000001') from Settlement  
                                   Where sauda_date Like  @TDate +'%'  
                             and sett_type like @sett_type  
                                   and sett_no = @@Sett_no  
                                   If @@TempContractno > @@Contractno  
                                  Begin  
                                           Set @@Contractno = @@TempContractno  
                                  End  
                          End  
                          Else  
                          If @@Style = 1  
                          Begin  
                                  Select @@ContractNo = Contractno + 1  From Contgen  
                                  Where @tdate + ' 00:00:01' >= Start_Date and @tdate + ' 00:00:01' <= End_Date  
                         End  
                         If @@ContractNo > 0  
                         Begin  
                                   Update ContGen set ContractNo = @@ContractNo where @tdate + ' 00:00:01' >= Start_Date and @tdate + ' 00:00:01' <= End_Date  
                         End  
                End  
          End  
          If   (@@ContStyle = 'N') And (@Flag < 3)  And ( @@Sameparty = 'N')  
          Begin  
               Print 'In contstyle = N'  
     Select   @@Contractno =  contractno  from isettlement  
                    Where isettlement.party_code = @Toparty  
                    and sauda_date Like  @TDate +'%'  
                    and sett_type like @sett_type  
                    and sett_no = @@Sett_no  
  
                    If ( (@@ContractNo Is Null  ) And (@@ContStyle = 'N'))  
                    Begin  
                         Print 'in contstyle = N and contractno is null'  
                         If @@style = 0  
                               Begin  
                         Select @@ContractNo = Isnull(max(contractno)+1,'0000001') From Isettlement  
                                        Where Sauda_date Like  @TDate +'%'  
            and Sett_type like @Sett_type  
                                        and Sett_no = @@Sett_no  
                                Select @@TempContractNo = Isnull(max(contractno)+1,'0000001') from Settlement  
                                        Where sauda_date Like  @TDate +'%'  
                                        and sett_type like @sett_type  
                                       and sett_no = @@Sett_no  
                                       If @@TempContractno > @@Contractno  
                                       Begin  
                                                 Set @@Contractno = @@TempContractno  
                                       End  
  
                            End  
                            Else  
                            If @@Style = 1  
                            Begin  
                                      Select @@ContractNo = Contractno + 1  From Contgen  
          Where @tdate + ' 00:00:01'  >= Start_Date and @tdate + ' 00:00:01' <= End_Date  
                           End  
                         If @@ContractNo > 0  
                         Begin  
                              Print 'Going to update contgen in inscont = N and contractno = null'  
                                   Update ContGen set ContractNo = @@ContractNo where @tdate + ' 00:00:01' >= Start_Date and @tdate + ' 00:00:01' <= End_Date  
                         End  
  
                  End  
         End  
         If   ( @@Contstyle = 'S' ) And (@Flag < 3 )  And ( @@Sameparty = 'N')  
         Begin  
                   Select  @@ContractNo = Contractno   From Isettlement  
                   Where isettlement.party_code = @Toparty  
                    and sauda_date Like  @TDate +'%'  
                    and sett_type like @sett_type  
                    and sett_no = @@Sett_no  
                     and Scrip_cd = @scripcd  
                    If  (@@ContractNo Is Null ) And (@@Contstyle = 'S')  
                    Begin  
                               If @@style = 0  
                               Begin  
              Select @@ContractNo = Isnull(max(contractno)+1,'0000001') from Isettlement  
                                         Where sauda_date Like  @TDate +'%'  
              and sett_type like @sett_type  
                                          and sett_no = @@Sett_no  
                              Select @@TempContractNo = Isnull(max(contractno)+1,'0000001') from Settlement  
                                         Where sauda_date Like  @TDate +'%'  
                                         And sett_type like @sett_type  
                                         And sett_no = @@Sett_no  
  
                                         If @@TempContractno > @@Contractno  
                                         Begin  
                                                   Set @@Contractno = @@TempContractno  
                                          End  
  
                              End  
                              Else  
                              If @@Style = 1  
                              Begin  
                                        Select @@ContractNo = Contractno + 1  From Contgen  
            Where @tdate + ' 00:00:01'  >= Start_Date and @tdate + ' 00:00:01' <= End_Date  
                            End  
                         If @@ContractNo > 0  
                         Begin  
                             Update ContGen set ContractNo = @@ContractNo where @tdate + ' 00:00:01' >= Start_Date and @tdate + ' 00:00:01' <= End_Date  
                         End  
  
                    End  
       End  
If ((@@SameParty = 'Y')   And  (@Flag < 3))  
Begin  
         If @@Style = 0  
         Begin  
       Select @@ContractNo = Isnull(max(contractno)+1,'0000001') from isettlement  
                   Where sauda_date Like  @TDate +'%'  
      and sett_type like @sett_type  
                   and sett_no = @@Sett_no  
  
       Select @@TempContractNo = Isnull(max(contractno)+1,'0000001') from Settlement  
                   Where sauda_date Like  @TDate +'%'  
    and sett_type like @sett_type  
                   and sett_no = @@Sett_no  
                   If @@TempContractno > @@Contractno  
                   Begin  
                              Set @@Contractno = @@TempContractno  
                   End  
        End  
        Else  
        If @@Style = 1  
        Begin  
                  Select @@ContractNo = Contractno + 1  From Contgen  
   Where @tdate + ' 00:00:01'  >= Start_Date and @tdate + ' 00:00:01' <= End_Date  
          End  
                         If @@ContractNo > 0  
                         Begin  
                                   Update ContGen set ContractNo = @@ContractNo where @tdate + ' 00:00:01' >= Start_Date and @tdate + ' 00:00:01' <= End_Date  
                         End  
  
End  
  
/*  I have added  the following for making sure that I am doing the consolidation transfer  */  
  
If @@Error < > 0  
Insert into errorlog Values (Getdate(), 'In AfterContcursorins   Error Occured in section Institutional Trade Transfer  ', @OrderNo + '     ' +@Tradeno + '   '+ @Partycd + '      ' +@Scripcd +'   ' +@Tdate + '   ' +Convert(Varchar,@Mkrate) + '    ' +  @Sellbuy  +  '   ' + @Sett_type +'   '+ @@Sett_no ,' ' + Convert(Varchar,@Flag) + '     ' + @Memcode + '   ' +@ToParty  + '    ' +  Convert(Varchar,@Tqty),'  ')  
  
  
If ((@@SameParty = 'N')   And  (@Flag = 12)  And ( @Tradeno = '%' ) )  
Begin  
         If @@Style = 0  
         Begin  
       Select @@ContractNo = Isnull(max(contractno)+1,'0000001') from isettlement  
                   Where sauda_date Like  @TDate +'%'  
      and sett_type like @sett_type  
                   and sett_no = @@Sett_no  
  
       Select @@TempContractNo = Isnull(max(contractno)+1,'0000001') from Settlement  
                   Where sauda_date Like  @TDate +'%'  
      and sett_type like @sett_type  
                   and sett_no = @@Sett_no  
  
                   If @@TempContractno > @@Contractno  
                   Begin  
                             Set @@Contractno = @@TempContractno  
                   End  
        End  
        Else  
        If @@Style = 1  
        Begin  
                  Select @@ContractNo = Contractno + 1  From Contgen  
   Where @tdate + ' 00:00:01'  >= Start_Date and @tdate + ' 00:00:01' <= End_Date  
         End  
         If @@ContractNo > 0  
         Begin  
                   Update ContGen set ContractNo = @@ContractNo where @tdate + ' 00:00:01' >= Start_Date and @tdate + ' 00:00:01' <= End_Date  
         End  
End  
  
If ((@@SameParty = 'Y')   And  (@Flag = 12))  
Begin  
           If @@style = 0  
           Begin  
         Select @@ContractNo = Isnull(max(contractno)+1,'0000001') from Isettlement  
                     Where sauda_date Like  @TDate +'%'  
        and sett_type like @sett_type  
                     and sett_no = @@Sett_no  
          Select @@TempContractNo = Isnull(max(contractno)+1,'0000001') from Settlement  
                     Where sauda_date Like  @TDate +'%'  
         and sett_type like @sett_type  
                      and sett_no = @@Sett_no  
  
                      If @@TempContractno > @@Contractno  
                      Begin  
                                 Set @@Contractno = @@TempContractno  
                      End  
             End  
             Else  
             If @@Style = 1  
             Begin  
    Select @@ContractNo = Contractno + 1  from Contgen  
                        Where @tdate + ' 00:00:01'  >= Start_Date and @tdate + ' 00:00:01' <= End_Date  
             End  
             If @@ContractNo > 0  
             Begin  
                        Update ContGen set ContractNo = @@ContractNo where @tdate + ' 00:00:01' >= Start_Date and @tdate + ' 00:00:01' <= End_Date  
             End  
  
End  
/*  
If @@ContractNo > 0  
Begin  
          Update ContGen set ContractNo = @@ContractNo where @tdate + ' 00:00:01' >= Start_Date and @tdate + ' 00:00:01' <= End_Date  
End  
*/  
/*  Print 'Contractno is ' + convert(varchar,@@Contractno)      */  
  
Select @@Contractno = STUFF('0000000', 8 - Len(@@Contractno), Len(@@Contractno), @@Contractno)  
  
End  
/*  Print @@Contractno */  
  
If @@Error < > 0  
Insert into errorlog Values (Getdate(), '  In AfterContcursorins   Error Occured in section Consolidation  ', @OrderNo + '     ' +@Tradeno + '   '+ @Partycd + '      ' +@Scripcd +'   ' +@Tdate + '   ' +Convert(Varchar,@Mkrate) + '    ' +  @Sellbuy  +  '  
 ' + @Sett_type +'   '+ @@Sett_no ,' ' + Convert(Varchar,@Flag) + '     ' + @Memcode + '   ' +@ToParty  + '    ' +  Convert(Varchar,@Tqty),'  ')  
  
IF @FLAG =1  
BEGIN  
/* Print 'Flag 1'  */  
Set @@Cont = Cursor For  
       Select   trade_no ,tradeqty,marketrate,netrate  
       from isettlement where  /* billno = 0  */  
        Sett_no = @@Sett_no  
       and party_code like @partycd  
       and scrip_cd like  @scripcd  
       and sauda_date like @TDate +'%'  
       and marketrate = @mkrate  
       and sell_buy like @sellbuy  
       and tradeqty > 0  
       and sett_type like @sett_type  
       and trade_no like @tradeno  
       and order_no like @orderno  
       and partipantcode = @Memcode  
       and user_id like @TerminalId  
       and trade_no not like 'C%'  
       order by order_no,tradeqty desc  
END  
Else If  (  (@Flag = 2) Or (@Flag = 12)  )  
BEGIN  
/*  Print 'Flag = 2 ' */  
   Select @@Sett_no,@Partycd,@Scripcd,@Tdate,@Sellbuy,@sett_type,@tradeno,@orderno,@tmark,@memcode,@terminalid  
   Set @@Cont = Cursor For  
   Select trade_no ,tradeqty,marketrate,netrate  
   From isettlement where  /* billno = 0   */  
       Sett_no = @@Sett_no  
       and  party_code like @partycd  
       and scrip_cd like  @scripcd  
       and sauda_date like @TDate +'%'  
       and sell_buy =  @sellbuy  
       and sett_type like @sett_type  
       and trade_no like @tradeno  
       and order_no like @orderno  
       and tradeqty  > 0  
       and partipantcode = @Memcode  
       and user_id like @TerminalId  
       and trade_no not like 'C%'  
       order by Order_no,tradeqty desc  
END  
Else If @Flag = 3  
BEGIN  
/* Print 'Flag = 3 '  
   Select @Partycd,@Scripcd,@Tdate,@Sellbuy,@sett_type,@tradeno,@orderno,@tmark,@memcode,@terminalid */  
   Set @@Cont = Cursor For  
   Select trade_no ,tradeqty,marketrate,netrate  
   From isettlement where  
       Sett_no = @@Sett_no  
       and  party_code like @partycd  
       and scrip_cd like  @scripcd  
       and sauda_date like @TDate +'%'  
       and sell_buy =  @sellbuy  
       and sett_type like @sett_type  
       and trade_no like @tradeno  
       and order_no like @orderno  
       and tradeqty > 0  
       and partipantcode = @Memcode  
       and user_id like @TerminalId  
       order by Order_no,tradeqty desc  
END  
  
If @Flag = 4  
BEGIN  
Print 'Flag   =  4'  
/*   Select @Partycd,@Scripcd,@Tdate,@Sellbuy,@sett_type,@tradeno,@orderno,@tmark,@memcode,@terminalid */  
   Set @@Cont = Cursor For  
   Select trade_no ,tradeqty,marketrate,netrate  
   From Settlement where  
       Sett_no = @@Sett_no  
       and  party_code like @partycd  
       and scrip_cd like  @scripcd  
       and sauda_date like @TDate +'%'  
       and sell_buy =  @sellbuy  
       and sett_type like @sett_type  
       and trade_no like @tradeno  
       and order_no like @orderno  
       and tradeqty > 0  
       and partipantcode = @Memcode  
       and user_id like @TerminalId  
       order by Order_no,tradeqty desc  
END  
  
  
Open @@Cont  
  
Fetch Next from @@Cont Into @@trade_no ,@@tradeqty,@@marketrate,@@netrate  
  
select @@trade_no ,@@tradeqty,@@marketrate,@@netrate  
/* Party TO Party for Institutional Clients  */  
  
While ( (@@Fetch_Status = 0) And  (@Tqty > 0) and ( ( @Flag <  3 ) Or (@Flag = 12))  )  
Begin  
                   If  @@TradeQty > @TQty  
              Begin  
                        Select @@TTradeNo = 'R' + @@trade_no  
                        Select @@TFlag = 1  
                        Select @@XTradeNo = '0'  
                        While  @@TFlag = 1  
                        Begin  
                    Set @@TNo = Cursor for  
                    Select Trade_no From Isettlement Where Trade_no like @@ttradeno  
                    and sauda_date Like @TDate + '%' and scrip_cd = @scripcd and  
                      sell_buy =@sellbuy  /* and party_code = @partycd */ and sett_type like @sett_type  /* and participantcode = @Memcode */  
                    And Sett_No = @@Sett_no /* and Tradeqty =  @@tradeqty */  
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
  
      If @@TradeQty = @TQty  
      Begin  
  
                update Isettlement set Party_code = @ToParty ,Trade_no = @@TTradeNo ,Contractno = @@contractno  
      where sett_type = @sett_type and trade_no = @@trade_no and scrip_cd = @scripcd  
    and sauda_date Like @TDate + '%'  and sell_buy =@sellbuy  and party_code = @partycd  
    and netrate= @@NetRate and tmark like @tmark and partipantcode = @Memcode and  Sett_no = @@Sett_no  
                and Tradeqty =  @@tradeqty  
  
  
  Select @TQty = 0  
  
 end  
 else if @@TradeQty > @TQty  
 Begin  
                Insert into isettlement select  
  @@contractno,0, @@ttradeno,@toparty,Scrip_Cd,user_id,@tqty, AUCTIONPART, MarketType,  
    series,order_no, @@MarketRate , Sauda_date,Table_no, Line_No ,Val_perc, Normal,Day_puc,day_sales,  
    Sett_purch,Sett_sales,Sell_buy,settflag ,Brokapplied, NetRate,amount =  (@Tqty *@@NetRate) ,  
    Ins_chrg,turn_tax,other_chrg, sebi_tax,Broker_chrg,Service_tax,Trade_amount= (@tqty * @@MarketRate) ,  
     Billflag,sett_no,nbrokapp ,nsertax ,n_netrate ,sett_type,partipantcode,status,pro_cli,cpid,instrument,  
    bookType,branch_id,tmark ,scheme,dummy1,dummy2  from isettlement  
  where sett_type = @sett_type and trade_no = @@trade_no and scrip_cd = @scripcd  
    and sauda_date Like @TDate + '%'  and sell_buy =@sellbuy  and party_code = @partycd  
    and netrate= @@NetRate and  partipantcode = @Memcode And Sett_no = @@Sett_no  
                                and Tradeqty =  @@tradeqty  
                                update isettlement set TradeQty = @@TradeQty - @TQty, Amount = (@@TradeQty - @TQty) * Marketrate  
      where sett_type = @sett_type and trade_no = @@trade_no and scrip_cd = @scripcd  
    and sauda_date Like @TDate + '%'  and sell_buy =@sellbuy  and party_code = @partycd  
    and netrate= @@NetRate and  partipantcode = @Memcode And Sett_no = @@Sett_no  
                                and Tradeqty =  @@tradeqty  
  Select @TQty = 0  
 end  
 else if @@TradeQty < @TQty  
 Begin  
  
               update Isettlement set Party_code = @ToParty ,Trade_no = @@TTradeNo ,Contractno = @@contractno  
      where sett_type = @sett_type and trade_no = @@trade_no and scrip_cd = @scripcd  
    and sauda_date Like @TDate + '%'  and sell_buy =@sellbuy  and party_code = @partycd  
    and netrate= @@NetRate and tmark like @tmark and partipantcode = @Memcode and  Sett_no = @@Sett_no  
                and Tradeqty =  @@tradeqty  
  
  Select @TQty = @TQty - @@TradeQty  
 end  
 Fetch Next from @@Cont Into @@trade_no ,@@tradeqty,@@marketrate,@@netrate  
end  
  
  
  
If ( (  (@Flag =12)   Or ( @Flag = 2) Or (@Flag = 1) ) And (@MkRate > 0))  
Begin  
           Update Isettlement set MArketrate = @Mkrate,Trade_amount = (Tradeqty * @Mkrate) ,Dummy2 = 1  where  
           Party_code = @Toparty  
           And  
           Sett_type = @Sett_type  
           and scrip_cd like  @scripcd  
           and sauda_date like @TDate +'%'  
           and sell_buy =  @sellbuy  
           And Sett_no = @@Sett_no  
           And COntractno = @@Contractno  
End  
/*    Following Routine does the partial rejection of Orders  Flag =  3       */  
  
While @@Fetch_Status = 0 and @TQty > 0 and @Flag = 3  
begin  
Select @@TTradeNo = 'R' + @@trade_no  
 Select @@TFlag = 1  
 Select @@XTradeNo = '0'  
 while  @@TFlag = 1  
 Begin  
  Set @@TNo = Cursor for  
  select trade_no from settlement where trade_no like @@ttradeno  
      and sauda_date Like @TDate + '%' and scrip_cd = @scripcd and  
    sell_buy =@sellbuy  and party_code = @partycd and sett_type like @sett_type  and partipantcode = @Memcode  
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
 if @@TradeQty = @TQty  
 Begin  
               /*                       Print ' In Tradeqty = Tqty'  */  
  Insert into Settlement select  
  @@contractno,0,@@ttradeno,@toparty,Scrip_Cd,user_id,@@TradeQty, AUCTIONPART, MarketType,  
    series,order_no,MarketRate, Sauda_date,Table_no, Line_No ,Val_perc, Normal,Day_puc,day_sales,  
    Sett_purch,Sett_sales,Sell_buy,settflag ,Brokapplied, NetRate,amount =  (@Tqty *@@NetRate) ,  
    Ins_chrg,turn_tax,other_chrg, sebi_tax,Broker_chrg,Service_tax,Trade_amount= (@tqty * @@MarketRate) ,  
     Billflag,sett_no,nbrokapp ,nsertax ,n_netrate ,sett_type,@@Membercode,status,pro_cli,cpid,instrument,  
    bookType,branch_id, tmark ,scheme,0 ,dummy2  from isettlement  
  where sett_type = @sett_type and trade_no = @@trade_no and scrip_cd = @scripcd  
    and sauda_date Like @TDate + '%'  and sell_buy =@sellbuy  and party_code = @partycd  
    and netrate= @@NetRate  and  partipantcode = @Memcode And Sett_no = @@Sett_no  
  
       Update isettlement set tradeqty= 0,Normal = 0,Day_puc = 0,day_sales = 0,Sett_purch = 0,Sett_sales  = 0,  
                                marketrate = 0,Brokapplied = 0,NetRate = 0,Amount = 0,Ins_chrg = 0,turn_tax = 0,other_chrg = 0,  
      sebi_tax = 0,Broker_chrg = 0,Service_tax = 0,Trade_amount = 0,NBrokApp = 0,NSerTax = 0,N_NetRate = 0  
      where sett_type = @sett_type and trade_no = @@trade_no and scrip_cd = @scripcd  
    and sauda_date Like @TDate + '%'  and sell_buy =@sellbuy  and party_code = @partycd  
    and netrate= @@NetRate and   partipantcode = @Memcode And Sett_no = @@Sett_no  
  Select @TQty = 0  
 end  
 else if @@TradeQty > @TQty  
 Begin  
                                /*      Print ' In Tradeqty > Tqty'  */  
  Insert into Settlement select  
  @@contractno,0,@@ttradeno,@toparty,Scrip_Cd,user_id,@tqty, AUCTIONPART, MarketType,  
    series,order_no,MarketRate, Sauda_date,Table_no, Line_No ,Val_perc, Normal,Day_puc,day_sales,  
    Sett_purch,Sett_sales,Sell_buy,settflag ,Brokapplied, NetRate,amount =  (@Tqty *@@NetRate) ,  
    Ins_chrg,turn_tax,other_chrg, sebi_tax,Broker_chrg,Service_tax,Trade_amount= (@tqty * @@MarketRate) ,  
     Billflag,sett_no,nbrokapp ,nsertax ,n_netrate ,sett_type,@@Membercode,status,pro_cli,cpid,instrument,  
    bookType,branch_id,tmark ,scheme, 0 ,dummy2  from isettlement  
  where sett_type = @sett_type and trade_no = @@trade_no and scrip_cd = @scripcd  
    and sauda_date Like @TDate + '%'  and sell_buy =@sellbuy  and party_code = @partycd  
    and netrate= @@NetRate and   partipantcode = @Memcode And Sett_no = @@Sett_no  
  
  update isettlement set TradeQty = @@TradeQty - @TQty, Amount = (@@TradeQty - @TQty) * Marketrate  
      where sett_type = @sett_type and trade_no = @@trade_no and scrip_cd = @scripcd  
    and sauda_date Like @TDate + '%'  and sell_buy =@sellbuy  and party_code = @partycd  
    and netrate= @@NetRate and  partipantcode = @Memcode And Sett_no = @@Sett_no  
  
  Select @TQty = 0  
 end  
 else if @@TradeQty < @TQty  
 Begin  
                                /* Print ' In Tradeqty < Tqty'  */  
                Insert into Settlement select  
  @@contractno,0,@@ttradeno,@toparty,Scrip_Cd,user_id,@@TradeQty, AUCTIONPART, MarketType,  
    series,order_no,MarketRate, Sauda_date,Table_no, Line_No ,Val_perc, Normal,Day_puc,day_sales,  
    Sett_purch,Sett_sales,Sell_buy,settflag ,Brokapplied, NetRate,amount =  (@@Tradeqty *@@NetRate) ,  
    Ins_chrg,turn_tax,other_chrg, sebi_tax,Broker_chrg,Service_tax,Trade_amount= (@tqty * @@MarketRate) ,  
     Billflag,sett_no,nbrokapp ,nsertax ,n_netrate ,sett_type,@@MemberCode,status,pro_cli,cpid,instrument,  
    bookType,branch_id, tmark ,scheme,0  ,dummy2  from isettlement  
  where sett_type = @sett_type and trade_no = @@trade_no and scrip_cd = @scripcd  
    and sauda_date Like @TDate + '%'  and sell_buy =@sellbuy  and party_code = @partycd  
    and netrate= @@NetRate and   partipantcode = @Memcode And Sett_no = @@Sett_no  
  
  update isettlement set tradeqty= 0,Normal = 0,Day_puc = 0,day_sales = 0,Sett_purch = 0,Sett_sales  = 0,  
                marketrate = 0,Brokapplied = 0,NetRate = 0,Amount = 0,Ins_chrg = 0,turn_tax = 0,other_chrg = 0,  
      sebi_tax = 0,Broker_chrg = 0,Service_tax = 0,Trade_amount = 0,NBrokApp = 0,NSerTax = 0,N_NetRate = 0  
      where sett_type = @sett_type and trade_no = @@trade_no and scrip_cd = @scripcd  
    and sauda_date Like @TDate + '%'  and sell_buy =@sellbuy  and party_code = @partycd  
    and netrate= @@NetRate and  partipantcode = @Memcode And Sett_no = @@Sett_no  
  
  Select @TQty = @TQty - @@TradeQty  
 end  
 Fetch Next from @@Cont Into @@trade_no ,@@tradeqty,@@marketrate,@@netrate  
end  
  
  
  
  
/*    We will do now Settlement To Isettlement Transefer   */  
  
  
While @@Fetch_Status = 0 and @TQty > 0  and @Flag = 4  
begin  
  
Select @@TTradeNo = 'R' + @@trade_no  
 Select @@TFlag = 1  
 Select @@XTradeNo = '0'  
 while  @@TFlag = 1  
 Begin  
  Set @@TNo = Cursor for  
  select trade_no from settlement where trade_no like @@ttradeno  
      and sauda_date Like @TDate + '%' and scrip_cd = @scripcd and  
    sell_buy =@sellbuy  and party_code = @partycd and sett_type like @sett_type  and partipantcode = @Memcode  
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
 if @@TradeQty = @TQty  
 Begin  
/*                                      Print ' In Tradeqty = Tqty'  */  
  Insert into isettlement select  
  @@contractno,0,@@ttradeno,@toparty,Scrip_Cd,user_id,@@TradeQty, AUCTIONPART, MarketType,  
    series,order_no,MarketRate, Sauda_date,Table_no, Line_No ,Val_perc, Normal,Day_puc,day_sales,  
    Sett_purch,Sett_sales,Sell_buy,settflag ,Brokapplied, NetRate,amount =  (@Tqty *@@NetRate) ,  
    Ins_chrg,turn_tax,other_chrg, sebi_tax,Broker_chrg,Service_tax,Trade_amount= (@tqty * @@MarketRate) ,  
     Billflag,sett_no,nbrokapp ,nsertax ,n_netrate ,sett_type,partipantcode,status,pro_cli,cpid,instrument,  
    bookType,branch_id,tmark ,scheme,dummy1,dummy2 from isettlement  
  where sett_type = @sett_type and trade_no = @@trade_no and scrip_cd = @scripcd  
    and sauda_date Like @TDate + '%'  and sell_buy =@sellbuy  and party_code = @partycd  
     and netrate= @@NetRate and  partipantcode = @Memcode And Sett_no = @@Sett_no  
  
       update Settlement set tradeqty= 0,Normal = 0,Day_puc = 0,day_sales = 0,Sett_purch = 0,Sett_sales  = 0,  
        marketrate = 0,Brokapplied = 0,NetRate = 0,Amount = 0,Ins_chrg = 0,turn_tax = 0,other_chrg = 0,  
      sebi_tax = 0,Broker_chrg = 0,Service_tax = 0,Trade_amount = 0,NBrokApp = 0,NSerTax = 0,N_NetRate = 0  
      where sett_type = @sett_type and trade_no = @@trade_no and scrip_cd = @scripcd  
    and sauda_date Like @TDate + '%'  and sell_buy =@sellbuy  and party_code = @partycd  
    and netrate= @@NetRate and  partipantcode = @Memcode And Sett_no = @@Sett_no  
  Select @TQty = 0  
 end  
 else if @@TradeQty > @TQty  
 Begin  
                                /*      Print ' In Tradeqty > Tqty'  */  
  Insert into isettlement select  
  @@contractno,0,@@ttradeno,@toparty,Scrip_Cd,user_id,@tqty, AUCTIONPART, MarketType,  
    series,order_no,MarketRate, Sauda_date,Table_no, Line_No ,Val_perc, Normal,Day_puc,day_sales,  
    Sett_purch,Sett_sales,Sell_buy,settflag ,Brokapplied, NetRate,amount =  (@Tqty *@@NetRate) ,  
    Ins_chrg,turn_tax,other_chrg, sebi_tax,Broker_chrg,Service_tax,Trade_amount= (@tqty * @@MarketRate) ,  
     Billflag,sett_no,nbrokapp ,nsertax ,n_netrate ,sett_type,partipantcode,status,pro_cli,cpid,instrument,  
    bookType,branch_id,tmark ,scheme,dummy1,dummy2  from isettlement  
  where sett_type = @sett_type and trade_no = @@trade_no and scrip_cd = @scripcd  
    and sauda_date Like @TDate + '%'  and sell_buy =@sellbuy  and party_code = @partycd  
    and netrate= @@NetRate and  partipantcode = @Memcode And Sett_no = @@Sett_no  
  
  update  Settlement set TradeQty = @@TradeQty - @TQty, Amount = (@@TradeQty - @TQty) * Marketrate  
      where sett_type = @sett_type and trade_no = @@trade_no and scrip_cd = @scripcd  
    and sauda_date Like @TDate + '%'  and sell_buy =@sellbuy  and party_code = @partycd  
    and netrate= @@NetRate and  partipantcode = @Memcode And Sett_no = @@Sett_no  
  
  Select @TQty = 0  
 end  
 else if @@TradeQty < @TQty  
 Begin  
                                /*      Print ' In Tradeqty < Tqty'  */  
                Insert into isettlement select  
  @@contractno,0,@@ttradeno,@toparty,Scrip_Cd,user_id,@@TradeQty, AUCTIONPART, MarketType,  
    series,order_no,MarketRate, Sauda_date,Table_no, Line_No ,Val_perc, Normal,Day_puc,day_sales,  
    Sett_purch,Sett_sales,Sell_buy,settflag ,Brokapplied, NetRate,amount =  (@@Tradeqty *@@NetRate) ,  
    Ins_chrg,turn_tax,other_chrg, sebi_tax,Broker_chrg,Service_tax,Trade_amount= (@tqty * @@MarketRate) ,  
     Billflag,sett_no,nbrokapp ,nsertax ,n_netrate ,sett_type,partipantcode,status,pro_cli,cpid,instrument,  
    bookType,branch_id, tmark ,scheme,dummy1,dummy2 from isettlement  
  where sett_type = @sett_type and trade_no = @@trade_no and scrip_cd = @scripcd  
    and sauda_date Like @TDate + '%'  and sell_buy =@sellbuy  and party_code = @partycd  
    and netrate= @@NetRate and  partipantcode = @Memcode And Sett_no = @@Sett_no  
  
  update Settlement set tradeqty= 0,Normal = 0,Day_puc = 0,day_sales = 0,Sett_purch = 0,Sett_sales  = 0,  
                marketrate = 0,Brokapplied = 0,NetRate = 0,Amount = 0,Ins_chrg = 0,turn_tax = 0,other_chrg = 0,  
      sebi_tax = 0,Broker_chrg = 0,Service_tax = 0,Trade_amount = 0,NBrokApp = 0,NSerTax = 0,N_NetRate = 0  
      where sett_type = @sett_type and trade_no = @@trade_no and scrip_cd = @scripcd  
    and sauda_date Like @TDate + '%'  and sell_buy =@sellbuy  and party_code = @partycd  
    and netrate= @@NetRate and  partipantcode = @Memcode And Sett_no = @@Sett_no  
  
  Select @TQty = @TQty - @@TradeQty  
 end  
 Fetch Next from @@Cont Into @@trade_no ,@@tradeqty,@@marketrate,@@netrate  
end  
  
If @@Error < > 0  
Insert into errorlog Values (Getdate(), '  In AfterContcursorins   Error Occured in section Actual Transfer  ', @OrderNo + '     ' +@Tradeno + '   '+ @Partycd + '      ' +@Scripcd +'   ' +@Tdate + '   ' +Convert(Varchar,@Mkrate) + '    ' +  @Sellbuy  +  '
   ' + @Sett_type +'   '+ @@Sett_no ,' ' + Convert(Varchar,@Flag) + '     ' + @Memcode + '   ' +@ToParty  + '    ' +  Convert(Varchar,@Tqty),'  ')  
  
  
If @@Error = 0  
Begin  
 --Insert into contlogin values( 'SA',  @Partycd,@ToParty,@Scripcd, 'EQ', @@MyQty,@SellBuy, @Tdate,@@ContractNo, Getdate(), 0,@@TTradeNo)  
 If @@Sameparty = 'N'  
 Begin  
  insert into details Values  ( Left(convert(varchar,@Tdate,109),11),@@Sett_no,@sett_type,@ToParty,'IS' )  
 End  
  
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
  'AfterContCursorIns', /*called_from*/  
  getdate(), /*timestamp*/  
  ltrim(rtrim('')), /*extrafield3*/  
  ltrim(rtrim('')), /*extrafield4*/  
  ltrim(rtrim(''))  /*extrafield5*/  
 )  
End

GO
