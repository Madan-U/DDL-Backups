-- Object: PROCEDURE dbo.BSEReArrangeAfterBillFlag
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



CREATE procedure
	[dbo].[BSEReArrangeAfterBillFlag]
	(
		@Sett_No varchar(7),
		@Sett_Type varchar(2),
		@Party_code Varchar(10),
		@Scrip_cd varchar(12),
		@Series varchar(3),
		@tmark varchar(2),
		@Participantcode varchar(15),
		@StatusName VarChar(50),
		@FromWhere VarChar(50)
	)

AS

Declare
@@trade_no varchar(20),
 @@Pqty numeric(9),
 @@Sqty numeric(9),
 @@Ltrade_no varchar(20),
 @@Lqty numeric(9),
 @@Pdiff numeric(9),
 @@Flag cursor,
 @@loop cursor,
 @@Sdate Varchar(11),
 @@Edate Varchar(11),
 @@BillNo Int,
 @@Tran_cat Char(3)

Insert into errorlog Values (Getdate(), 'In BseRearrangeAfterbillflag  ', + @Party_code + '  ' +@Scrip_cd +'      ' + @Sett_type +'   '+@Sett_no ,' ','  ')

If Upper(LTrim(RTrim(@Sett_Type))) <> 'W'
BEGIN
 Select @@Sqty = 0
 Select @@PQty = 0

 Set @@Flag = Cursor for
 Select Isnull(Max(Convert(Int,Billno)),0) from Settlement where sett_no = @Sett_no and sett_type = @Sett_type  and party_code = @Party_code
 Open @@Flag
 Fetch Next from @@Flag into @@Billno

Select @@Tran_Cat = Tran_cat from Client2 where party_code = @Party_code

 If (  ( @@Fetch_status <> 0 )  Or ( @@Billno = 0 ))
 Begin
           Print 'in Bill no = 0'
           Set @@Flag = Cursor for
           Select Isnull(Max(Convert(Int,Billno)),0) from Settlement where  Sett_no = @Sett_no and Sett_type = @Sett_type
           Open @@Flag
           Fetch Next from @@Flag into @@BillNo
           Select @@Billno
           Set @@BillNo = Convert(Int,@@BillNo) + 1
 End


 If @@Fetch_status = 0
 Begin
           Close @@Flag
           Deallocate @@Flag
 End

 Select @@Billno

Set @@Flag = Cursor For
 Select  left(Convert(Varchar,Start_date,109),11), left(Convert(Varchar,End_date,109),11) from
 Sett_mst where Sett_no = @Sett_no and sett_type = @Sett_type
Open @@Flag
Fetch Next from @@Flag into @@Sdate , @@Edate

Print @@Sdate
Print @@Edate

If @@Fetch_status = 0
Begin
          Close @@Flag
          Deallocate @@Flag
End

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
 End
 Else If ( (@@Sdate <> @@Edate) )
 Begin
      If @@Tran_cat = 'TRD'
      Begin
      Update Settlement Set Billflag = (Case When Sell_Buy = 1 then 2 else 3 end ) ,Billno = @@Billno
      Where Party_code = @Party_code
      and Scrip_cd = @Scrip_Cd
 and Series = @Series
 and Sett_no = @Sett_no
 and Sett_Type = @Sett_type
 and partipantcode = @Participantcode

 Set @@Flag = Cursor for
 Select Isnull(Sum(Tradeqty),0) from Settlement where Sell_buy = 2
 and Party_code = @Party_code and Partipantcode = @Participantcode
 and Scrip_cd = @Scrip_cd and Series = @Series
 and Sett_no = @Sett_no and Sett_type = @Sett_type
 Open @@Flag
 Fetch Next from @@Flag into @@Sqty
 If @@Fetch_status = 0
 Begin
      Close @@Flag
      Deallocate @@Flag
 End

 Print 'Sqty ' + Convert(varchar,@@Sqty)

 Set @@Flag = Cursor for
 Select Isnull(Sum(Tradeqty),0) from Settlement where Sell_buy = 1
 and Party_code = @Party_code and Partipantcode = @Participantcode
 and Scrip_cd = @Scrip_cd and Series = @Series
 and Sett_no = @Sett_no and Sett_type = @Sett_type

 Open @@Flag
 Fetch Next from @@Flag into @@Pqty
 If @@Fetch_status = 0
 Begin
      Close @@Flag
      Deallocate @@Flag
 End


 Print 'Pqty ' + Convert(varchar,@@Pqty)

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
  End
/*
  If @@Pqty = @@Sqty
  Begin
       Update Settlement Set Billflag = (Case When Sell_Buy = 1 then 2 else 3 end )
       Where Party_code = @Party_code
       and Scrip_cd = @Scrip_Cd
       and Series = @Series
       and Sett_no = @Sett_no
       and Sett_Type = @Sett_type
       and tmark like @TMark   and ( tmark <> 'D' )
       and participantcode = @Participantcode
  End
 */
  If  ( (@@Pqty > @@Sqty) and (@@Sqty > 0 ))
  Begin
       Select @@Pdiff = @@Pqty - @@Sqty
       Print ' in Pqty > Sqty '
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
       Order by Marketrate Desc
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
                 Select @@Pdiff = @@Pdiff - @@Lqty
            End
            Else If @@Pdiff < @@Lqty
            Begin
                 Insert into Settlement
                 Select ContractNo,BillNo,'R'+Trade_no,Party_Code,Scrip_Cd,User_id,@@Pdiff,AuctionPart,MarketType,Series,Order_no,MarketRate,Sauda_date,Table_No,Line_No,Val_perc,Normal,Day_puc,day_sales,Sett_purch,Sett_sales,Sell_buy,Settflag,Brokapplied,NetRate,Amount,Ins_chrg,turn_tax,other_chrg,sebi_tax,Broker_chrg,Service_tax,@@Pdiff*MarketRate,4,sett_no,NBrokApp,NSerTax,N_NetRate,sett_type  ,PartiPantCode,Status,Pro_Cli,CpId,Instrument,BookType,Branch_Id,TMark,scheme,Dummy1,Dummy2
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
                 Select @@Pdiff = 0
             End
        Fetch next from @@Loop into @@Ltrade_no,@@Lqty
     End
 End
End

 If ((@@Pqty < @@Sqty) And (@@PQty > 0 ))
 Begin
      Select @@Pdiff = @@Sqty - @@Pqty
      Print ' in Pqty > Sqty '
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
      Order by Marketrate Desc
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
                Select @@Pdiff = 0
            End
            Fetch next from @@Loop into @@Ltrade_no,@@Lqty
        End
 End
End
/*
update settlement set tmark = 'D' where party_code = @Party and scrip_cd = @scrip and series = @series
and Sett_no = @Sett_No and Sett_Type = @Sett_type
and tmark <> 'D'  and billflag > 3  */

/* EXEC NEWUPDBILLTAXafterbill  @Sett_No,@Sett_Type,@Party_code,@Scrip_cd */
END

Insert into errorlog Values (Getdate(), 'Out BseRearrangeAfterbillflag  ', + @Party_code + '  ' +@Scrip_cd +'      ' + @Sett_type +'   '+@Sett_no ,' ','  ')

if @@error = 0
begin
	insert into inst_log values
	(
		ltrim(rtrim(@Party_code)),	/*party_code*/
		ltrim(rtrim(@Party_code)),	/*new_party_code*/
		convert(datetime, ltrim(rtrim(''))),	 /*sauda_date*/
		ltrim(rtrim(@Sett_No)),	 /*sett_no*/
		ltrim(rtrim(@Sett_Type)),	 /*sett_type*/
		ltrim(rtrim(@Scrip_cd)),	/*scrip_cd*/
		ltrim(rtrim(@Series)),	/*series*/
		ltrim(rtrim('')),	 /*order_no*/
		ltrim(rtrim('')),	 /*trade_no*/
		ltrim(rtrim('')),	/*sell_buy*/
		ltrim(rtrim('')),	/*contract_no*/
		ltrim(rtrim('')),	/*new_contract_no*/
		0,		/*brokerage*/
		0,		/*new_brokerage*/
		0,		/*market_rate*/
		0,		/*new_market_rate*/
		0	,		/*net_rate*/
		0,		/*new_net_rate*/
		0,		/*qty*/
		0	,		/*new_qty*/
		ltrim(rtrim(@Participantcode)),	 /*participant_code*/
		ltrim(rtrim(@Participantcode)),	 /*new_participant_code*/
		ltrim(rtrim(@StatusName)),	 /*username*/
		ltrim((@FromWhere)),	 /*module*/
		'BSEReArrangeAfterBillFlag',	/*called_from*/
		getdate(),	/*timestamp*/
		ltrim(rtrim('')),	/*extrafield3*/
		ltrim(rtrim('')),	/*extrafield4*/
		ltrim(rtrim(''))	 /*extrafield5*/
	)
end

GO
