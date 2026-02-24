-- Object: PROCEDURE dbo.TBseRearrangeAfterBillflag
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




CREATE  Procedure TBseRearrangeAfterBillflag (@Sett_No varchar(7),@Sett_Type varchar(2),@Party_code Varchar(10),@Scrip_cd varchar(12),@Series varchar(3),@tmark varchar(2),@Participantcode varchar(15)) AS             
Declare 
 @@trade_no varchar(14),
 @@Pqty numeric(9), 
 @@Sqty numeric(9),
 @@Ltrade_no varchar(14),
 @@Lqty numeric(9), 
 @@Pdiff numeric(9),
 @@Flag cursor,
 @@loop cursor,
 @@Sdate Varchar(11),
 @@Edate Varchar(11),
 @@BillNo Int,
 @@Tran_cat Char(3),
 @@TerminalCursor Cursor,
 @@TerminalNo Int



Select  @@Sdate = left(Convert(Varchar,Start_date,109),11), @@Edate = left(Convert(Varchar,End_date,109),11) from
Sett_mst where Sett_no = @Sett_no and sett_type = @Sett_type


Set @@Terminalcursor = Cursor for

Select Terminalnumber from AngelTermBrok where
Party_code = @Party_code  
and FromDate <= @@Sdate
and ToDate >= @@Sdate

Open @@TerminalCursor
Fetch Next From @@TerminalCursor Into @@TerminalNo

Print 'In Tbse Rearrange after billflag '
Select @@TerminalNo
Select @Party_code
Select @@Sdate
Select @@Edate

While @@Fetch_Status = 0
Begin

if upper(LTrim(RTrim(@Sett_Type))) = 'W' 
Begin
Update Settlement Set BillFlag = (Case When Sell_buy = 1 Then 4 Else 5 End )
Where Party_code = @Party_code
      And  Sett_no = @Sett_no
      And Sett_type = @Sett_type
      And Scrip_cd = @Scrip_cd
      And Series = @Series
     And PartipantCode = @ParticipantCode          
     And User_Id = @@TerminalNo
End
Else
Begin       
 Select @@Sqty = 0
 Select @@PQty = 0

 Select @@Tran_Cat = Tran_cat from Client2 where party_code = @Party_code

 Print 'Sett type is not W'

--Print @@Sdate
--Print @@Edate


 If @@Sdate = @@Edate 
 Begin
      Print 'In Sdate = Edate'
      Update settlement Set Billflag = SettFlag ,Billno = @@Billno
      Where Party_code = @Party_code
      And  Sett_no = @Sett_no
      And Sett_type = @Sett_type
      And Scrip_cd = @Scrip_cd
      And Series = @Series
     And PartipantCode = @ParticipantCode         
     And User_Id = @@TerminalNo
 End
 Else If ( (@@Sdate <> @@Edate) )
 Begin
      Print 'In Sdate <> Edate'
      If @@Tran_cat = 'TRD' 
      Begin 
      Update Settlement Set Billflag = (Case When Sell_Buy = 1 then 2 else 3 end ) ,Billno = @@Billno 
      Where Party_code = @Party_code 
      and Scrip_cd = @Scrip_Cd 
 and Series = @Series
 and Sett_no = @Sett_no 
 and Sett_Type = @Sett_type 
 and partipantcode = @Participantcode
     And User_Id = @@TerminalNo

 Select @@Sqty  = Isnull(Sum(Tradeqty),0) from Settlement where Sell_buy = 2 
 and Party_code = @Party_code and Partipantcode = @Participantcode
 and Scrip_cd = @Scrip_cd and Series = @Series 
 and Sett_no = @Sett_no and Sett_type = @Sett_type
 And User_Id = @@TerminalNo
 --Print 'Sqty ' + Convert(varchar,@@Sqty)
       
 Select @@Pqty = Isnull(Sum(Tradeqty),0) from Settlement where Sell_buy = 1 
 and Party_code = @Party_code and Partipantcode = @Participantcode
 and Scrip_cd = @Scrip_cd and Series = @Series 
 and Sett_no = @Sett_no and Sett_type = @Sett_type
 And User_Id = @@TerminalNo

 --Print 'Pqty ' + Convert(varchar,@@Pqty)
 
 If  @@Sqty = 0
 Begin
      Update Settlement Set BillFlag = 4 ,Tmark = 'D'
      Where Party_code = @Party_code 
      and Scrip_cd = @Scrip_cd 
      and Series = @Series 
      and Sell_buy = 1 
      and Sett_Type = @Sett_type 
      and Sett_no = @Sett_no
      and Partipantcode = @Participantcode
     And User_Id = @@TerminalNo
  End
  If  @@Pqty = 0
  Begin
       Update Settlement Set BillFlag = 5 ,Tmark = 'D'
       Where party_code = @Party_code 
    and Scrip_cd = @Scrip_cd 
       and Series = @Series 
       and Sell_buy = 2
       and Sett_Type = @Sett_type 
       and Sett_no = @Sett_no
       and Partipantcode = @Participantcode
     And User_Id = @@TerminalNo
  End
  If  ( (@@Pqty > @@Sqty) and (@@Sqty > 0 )) 
  Begin 
       Select @@Pdiff = @@Pqty - @@Sqty 
       --Print ' in Pqty > Sqty '
       Select @@Pdiff
       Set @@Loop  = Cursor For 
       Select Trade_no,Tradeqty From Settlement 
       Where Party_code = @Party_code 
       and Scrip_cd = @Scrip_cd 
       and Series = @Series 
       and Sell_buy = 1 
       and Sett_no = @Sett_no 
       and Sett_Type = @Sett_type 
       and Partipantcode = @Participantcode
     And User_Id = @@TerminalNo
--     Order by Marketrate Desc  
       order by Sauda_date 
       Open @@Loop
       Fetch Next From @@Loop Into @@Ltrade_no,@@Lqty
      
       While ( @@Fetch_Status = 0 ) and (@@Pdiff > 0) 
       Begin
            If @@Pdiff >= @@Lqty 
            Begin
                 Update Settlement Set Billflag = 4   
                 Where Party_code = @Party_code 
                 and Scrip_cd = @Scrip_cd 
                 and Series = @Series 
                 and Sell_buy = 1 
                 and Trade_no = @@ltrade_no 
                 and Tradeqty = @@lqty
                 and Sett_no = @Sett_no  
                 and Sett_Type = @Sett_type  
                 and partipantcode = @Participantcode
                 And User_Id = @@TerminalNo
                 Select @@Pdiff = @@Pdiff - @@Lqty
            End    
            Else If @@Pdiff < @@Lqty 
            Begin                                                                                                                                                                                                                                              
                 Insert into Settlement                                                        
                 Select ContractNo,BillNo,'R'+Trade_no,Party_Code,Scrip_Cd,User_id,@@Pdiff,AuctionPart,MarketType,Series,Order_no,MarketRate,Sauda_date,Table_No,Line_No,Val_perc,Normal,Day_puc,day_sales,Sett_purch,Sett_sales,Sell_buy,Settflag,Brokapplied,
NetRate,Amount,Ins_chrg,turn_tax,other_chrg,sebi_tax,Broker_chrg,Service_tax,@@Pdiff*MarketRate,4,sett_no,NBrokApp,NSerTax,N_NetRate,sett_type  ,PartiPantCode,Status,Pro_Cli,CpId,Instrument,BookType,Branch_Id,TMark,scheme,Dummy1,Dummy2      
                 From Settlement Where 
                 Party_code = @Party_code 
                 and Scrip_cd = @Scrip_cd 
                 and Series = @Series 
                 and Sell_buy = 1 
                 and Trade_no = @@ltrade_no 
                 and tradeqty = @@lqty  
                 and Sett_no = @Sett_no
                 and Sett_Type = @Sett_type  
                 and partipantcode = @Participantcode
                 And User_Id = @@TerminalNo

                 Update Settlement Set Billflag = 2,Tradeqty = @@Lqty - @@Pdiff,Trade_Amount = (@@Lqty - @@pdiff)*MarketRate    
                 Where Party_code = @Party_code 
                 and Scrip_cd = @Scrip_cd 
                 and Series = @Series 
                 and Sell_Buy = 1 
                 and Trade_no = @@LTrade_no 
                 and Tradeqty = @@LQty
                 and Sett_no = @Sett_no
                 and Sett_Type = @Sett_type  
                 and partipantcode = @Participantcode          
                 And User_Id = @@TerminalNo

                 Select @@Pdiff = 0  
             End
        Fetch next from @@Loop into @@Ltrade_no,@@Lqty
     End
 End
End

 If ((@@Pqty < @@Sqty) And (@@PQty > 0 ))  
 Begin 
      Select @@Pdiff = @@Sqty - @@Pqty 
      --Print ' in Pqty > Sqty '
      Select @@Pdiff
      Set @@Loop  = Cursor For 
      Select Trade_no,Tradeqty From Settlement 
      Where Party_code = @Party_code 
      and Scrip_cd = @Scrip_cd 
      and Series = @Series 
      and Sell_buy = 2 
      and Sett_no = @Sett_no  
      and Sett_Type = @Sett_type 
      and Partipantcode = @Participantcode
      And User_Id = @@TerminalNo
--    Order by Marketrate Desc  
      Order by Sauda_date 
      Open @@Loop
      Fetch Next From @@Loop Into @@Ltrade_no,@@Lqty
      While ( @@Fetch_Status = 0 ) and (@@Pdiff > 0) 
      Begin
           If @@Pdiff >= @@Lqty 
           Begin
                Update Settlement Set Billflag = 5,Tmark = 'D'
                Where Party_code = @Party_code
                and Scrip_cd = @Scrip_cd
                and Series = @Series 
                and Sell_buy = 2 
                and Trade_no = @@ltrade_no 
                and Tradeqty = @@lqty
                and Sett_no = @Sett_no  
                and Sett_Type = @Sett_type  
                and partipantcode = @Participantcode
                And User_Id = @@TerminalNo                           
                Select @@Pdiff = @@Pdiff - @@Lqty
           End    
           Else If @@Pdiff < @@Lqty 
           Begin                                                                                                                                                                                                                                               
                Insert into Settlement                                                        
                Select ContractNo,BillNo,'Z'+Trade_no,Party_Code,Scrip_Cd,User_id,@@Pdiff,AuctionPart,MarketType,Series,Order_no,MarketRate,Sauda_date,Table_No,Line_No,Val_perc,Normal,Day_puc,day_sales,Sett_purch,Sett_sales,Sell_buy,Settflag,Brokapplied,NetRate,Amount,Ins_chrg,turn_tax,other_chrg,sebi_tax,Broker_chrg,Service_tax,@@Pdiff*MarketRate,5,sett_no,NBrokApp,NSerTax,N_NetRate,sett_type  ,PartiPantCode,Status,Pro_Cli,CpId,Instrument,BookType,Branch_Id, TMark,scheme,Dummy1,Dummy2      
                From Settlement Where 
                Party_code = @Party_code 
                and Scrip_cd = @Scrip_cd 
                and Series = @Series 
                and Sell_buy = 2 
                and Trade_no = @@ltrade_no 
                and Tradeqty = @@lqty 
                and Sett_no = @Sett_no 
                and Sett_Type = @Sett_type  
                and Partipantcode = @Participantcode
                And User_Id = @@TerminalNo
                Update Settlement Set Billflag = 3,Tradeqty = @@Lqty - @@Pdiff,Trade_Amount = (@@Lqty - @@pdiff)*MarketRate    
                Where Party_code = @Party_code 
                and Scrip_cd = @Scrip_cd 
                and Series = @Series 
                and Sell_Buy = 2
                and Trade_no = @@LTrade_no 
                and Tradeqty = @@LQty
                and Sett_no = @Sett_no
                and Sett_Type = @Sett_type  
                and Partipantcode = @Participantcode          
                And User_Id = @@TerminalNo
                Select @@Pdiff = 0  
            End
            Fetch next from @@Loop into @@Ltrade_no,@@Lqty
        End
 End
End
End
Fetch Next From @@TerminalCursor Into @@TerminalNo
End
--EXEC NEWUPDBILLTAXafterbill  @Sett_No,@Sett_Type,@Party_code,@Scrip_cd

GO
