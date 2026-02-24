-- Object: PROCEDURE dbo.Stt_insertdata_detail
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc Stt_insertdata_detail (@sett_type Varchar(2), @sauda_date Varchar(11), @fromparty Varchar(10), @toparty Varchar(10)) As   
Delete From Stt_clientdetail   
Where Rectype = 30   
And Sauda_date Like @sauda_date + '%'  
And Sett_type = @sett_type   
And Party_code >= @fromparty   
And Party_code <= @toparty  
  
If Upper(ltrim(rtrim(@sett_type))) = 'N' Or Upper(ltrim(rtrim(@sett_type))) = 'D'  
Begin  
  
 /* Normal Clients Start Here */  
 Insert Into Stt_clientdetail   
 Select 30, Sett_no, Sett_type, Contractno, Party_code, Scrip_cd, Series, Sauda_date=left(convert(varchar,sauda_date,109),11),branch_id=party_code,  
 Pdelprice=round(sum(tradeqty*marketrate)/sum(tradeqty),2),  
 Pqtydel=sum(case When Sell_buy = 1 And Settflag  In  (1,4) Then Tradeqty Else 0 End),  
 Pamtdel=sum(case When Sell_buy = 1 And Settflag In  (1,4) Then Tradeqty Else 0 End)*round(sum(tradeqty*marketrate)/sum(tradeqty),2),  
 Psttdel=round(sum(case When Sell_buy = 1 And Settflag In (1,4) Then Ins_chrg Else 0 End),2),  
 Sdelprice=round(sum(tradeqty*marketrate)/sum(tradeqty),2),  
 Sqtydel=sum(case When Sell_buy = 2 And Settflag In (1,5) Then Tradeqty Else 0 End),  
 Samtdel=sum(case When Sell_buy = 2 And Settflag In (1,5) Then Tradeqty Else 0 End)*round(sum(tradeqty*marketrate)/sum(tradeqty),2),  
 Ssttdel=round(sum(case When Sell_buy = 2 And Settflag In (1,5) Then Ins_chrg Else 0 End),2),  
 Strdprice=round(sum(tradeqty*marketrate)/sum(tradeqty),2),  
 Sqtytrd=sum(case When Sell_buy = 2 And Settflag = 3 Then Tradeqty Else 0 End),  
 Samttrd=sum(case When Sell_buy = 2 And Settflag = 3 Then Tradeqty Else 0 End)*round(sum(tradeqty*marketrate)/sum(tradeqty),2),  
 Sstttrd=round(sum(case When Sell_buy = 2 And Settflag = 3 Then Ins_chrg Else 0 End),2),  
 Totalstt=round(sum(case When Sell_buy = 1 And Settflag In (1,4) Then Ins_chrg Else 0 End),2) +   
          Round(sum(case When Sell_buy = 2 And Settflag In (1,5) Then Ins_chrg Else 0 End),2) +  
          Round(sum(case When Sell_buy = 2 And Settflag = 3 Then Ins_chrg Else 0 End),2)  
 From STT_SETT_TABLE Where Sett_type = @sett_type And Sauda_date Like @sauda_date + '%'  
 And Party_code >= @fromparty And Party_code <= @toparty   
 And Auctionpart Not In ('ap','ar','fp','fl','fa','fc')  
 And Tradeqty > 0 And Trade_no Not Like '%c%'  
 Group By Sett_no, Sett_type, Contractno, Party_code, Scrip_cd, Series, Left(convert(varchar,sauda_date,109),11)  
   
 /* Inst Clients Start Here */  
 Insert Into Stt_clientdetail   
 Select 30, Sett_no, Sett_type, Contractno, Party_code, Scrip_cd, Series, Sauda_date=left(convert(varchar,sauda_date,109),11),branch_id=party_code,  
 Pdelprice=round(sum(tradeqty*marketrate)/sum(tradeqty),2),   
 Pqtydel=sum(case When Sell_buy = 1 Then Tradeqty Else 0 End),  
 Pamtdel=sum(case When Sell_buy = 1 Then Tradeqty Else 0 End)*round(sum(tradeqty*marketrate)/sum(tradeqty),2),  
 Psttdel=round(sum(case When Sell_buy = 1 Then Ins_chrg Else 0 End),2),  
 Sdelprice=round(sum(tradeqty*marketrate)/sum(tradeqty),2),  
 Sqtydel=sum(case When Sell_buy = 2 Then Tradeqty Else 0 End),  
 Samtdel=sum(case When Sell_buy = 2 Then Tradeqty Else 0 End)*round(sum(tradeqty*marketrate)/sum(tradeqty),2),  
 Ssttdel=round(sum(case When Sell_buy = 2 Then Ins_chrg Else 0 End),2),  
 Strdprice=0,  
 Sqtytrd=0,  
 Samttrd=0,  
 Sstttrd=0,  
 Totalstt=round(sum(case When Sell_buy = 1 Then Ins_chrg Else 0 End),2) + Round(sum(case When Sell_buy = 2 Then Ins_chrg Else 0 End),2)  
 From STT_ISETT_TABLE Where Sett_type = @sett_type And Sauda_date Like @sauda_date + '%'  
 And Party_code >= @fromparty And Party_code <= @toparty   
                And Auctionpart Not In ('ap','ar','fp','fl','fa','fc')  
 And Tradeqty > 0 And Trade_no Not Like '%c%'  
 Group By Sett_no, Sett_type, Contractno, Party_code, Scrip_cd, Series, Left(convert(varchar,sauda_date,109),11)  
End   
Else  
Begin   
 Insert Into Stt_clientdetail   
 Select 30, Sett_no, Sett_type, Contractno, Party_code, Scrip_cd, Series, Sauda_date=left(convert(varchar,sauda_date,109),11),branch_id=party_code,  
 Pdelprice=(case When Sum(case When Sell_buy = 1 Then Tradeqty Else 0 End) > 0   
   Then Round(sum(case When Sell_buy = 1 Then Tradeqty*marketrate Else 0 End)/  
        Sum(case When Sell_buy = 1 Then Tradeqty Else 0 End),2)  
   Else 0   
     End),  
 Pqtydel=sum(case When Sell_buy = 1 Then Tradeqty Else 0 End),  
 Pamtdel=round(sum(case When Sell_buy = 1 Then Tradeqty*marketrate Else 0 End),2),  
 Psttdel=round(sum(case When Sell_buy = 1 Then Ins_chrg Else 0 End),2),  
 Sdelprice=(case When Sum(case When Sell_buy = 2 Then Tradeqty Else 0 End) > 0   
   Then Round(sum(case When Sell_buy = 2 Then Tradeqty*marketrate Else 0 End)/  
        Sum(case When Sell_buy = 2 Then Tradeqty Else 0 End),2)  
   Else 0   
     End),  
 Sqtydel=sum(case When Sell_buy = 2 Then Tradeqty Else 0 End),  
 Samtdel=round(sum(case When Sell_buy = 2 Then Tradeqty*marketrate Else 0 End),2),  
 Ssttdel=round(sum(case When Sell_buy = 2 Then Ins_chrg Else 0 End),2),  
 Strdprice=0,  
 Sqtytrd=0,  
 Samttrd=0,  
 Sstttrd=0,  
 Totalstt=round(sum(case When Sell_buy = 1 Then Ins_chrg Else 0 End),2) + Round(sum(case When Sell_buy = 2 Then Ins_chrg Else 0 End),2)  
 From STT_SETT_TABLE Where Sett_type = @sett_type And Sauda_date Like @sauda_date + '%'  
 And Party_code >= @fromparty And Party_code <= @toparty   
 And Auctionpart Not In ('ap','ar','fp','fl','fa','fc')  
 And Tradeqty > 0 And Trade_no Not Like '%c%'  
 Group By Sett_no, Sett_type, Contractno, Party_code, Scrip_cd, Series, Left(convert(varchar,sauda_date,109),11)  
 /* Normal Clients End Here */  
   
 Insert Into Stt_clientdetail   
 Select 30, Sett_no, Sett_type, Contractno, Party_code, Scrip_cd, Series, Sauda_date=left(convert(varchar,sauda_date,109),11),branch_id=party_code,  
 Pdelprice=(case When Sum(case When Sell_buy = 1 Then Tradeqty Else 0 End) > 0   
   Then Round(sum(case When Sell_buy = 1 Then Tradeqty*marketrate Else 0 End)/  
        Sum(case When Sell_buy = 1 Then Tradeqty Else 0 End),2)  
   Else 0   
     End),  
 Pqtydel=sum(case When Sell_buy = 1 Then Tradeqty Else 0 End),  
 Pamtdel=round(sum(case When Sell_buy = 1 Then Tradeqty*marketrate Else 0 End),2),  
 Psttdel=round(sum(case When Sell_buy = 1 Then Ins_chrg Else 0 End),2),  
 Sdelprice=(case When Sum(case When Sell_buy = 2 Then Tradeqty Else 0 End) > 0   
   Then Round(sum(case When Sell_buy = 2 Then Tradeqty*marketrate Else 0 End)/  
        Sum(case When Sell_buy = 2 Then Tradeqty Else 0 End),2)  
   Else 0   
     End),  
 Sqtydel=sum(case When Sell_buy = 2 Then Tradeqty Else 0 End),  
 Samtdel=round(sum(case When Sell_buy = 2 Then Tradeqty*marketrate Else 0 End),2),  
 Ssttdel=round(sum(case When Sell_buy = 2 Then Ins_chrg Else 0 End),2),  
 Strdprice=0,  
 Sqtytrd=0,  
 Samttrd=0,  
 Sstttrd=0,  
 Totalstt=round(sum(case When Sell_buy = 1 Then Ins_chrg Else 0 End),2) + Round(sum(case When Sell_buy = 2 Then Ins_chrg Else 0 End),2)  
 From STT_ISETT_TABLE Where Sett_type = @sett_type And Sauda_date Like @sauda_date + '%'  
 And Party_code >= @fromparty And Party_code <= @toparty   
 And Auctionpart Not In ('ap','ar','fp','fl','fa','fc')  
 And Tradeqty > 0 And Trade_no Not Like '%c%'
 Group By Sett_no, Sett_type, Contractno, Party_code, Scrip_cd, Series, Left(convert(varchar,sauda_date,109),11)  
 /* Inst Clients End Here */   
  
End

GO
