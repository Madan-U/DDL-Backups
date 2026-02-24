-- Object: PROCEDURE dbo.BSEReArrangeAfterContFlag
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE procedure
	[dbo].[BSEReArrangeAfterContFlag]
	(
		@Sett_Type varchar(2),
		@Party_code Varchar(10),
		@Scrip_cd varchar(12),
		@Series varchar(3),
		@TDate Varchar(11),
		@TMark varchar(2),
		@Participantcode varchar(15),
		@StatusName VarChar(50),
		@FromWhere VarChar(50)
	)

as

Declare
 @@trade_no varchar(20),
 @@Pqty numeric(9),
 @@Sqty numeric(9),
 @@Ltrade_no varchar(20),
 @@Lqty numeric(9),
 @@Pdiff numeric(9),
 @@Flag cursor,
 @@loop cursor,
 @@TPqty numeric(9),
 @@TSqty numeric(9),
 @@TSell_Buy int


 /*  apply sett_flag = 1 to all trades where client2. tran_cat   = 'DEL' */

--Print ' Going in SP '

 Update Settlement Set Settflag = 1  FROM Settlement t , CLIENT2
 Where  CLIENT2.PARTY_CODE = T.party_code
 and (CLIENT2.tran_cat = 'DEL')
 and  t. party_code = @Party_code
 and t.scrip_cd = @scrip_cd
 and t.series = @series
 and t.sauda_date Like  @Tdate  +'%'
 and t.Sett_Type = @Sett_type
 and t.partipantcode = @Participantcode
 and  t.tradeqty > 0

If Upper(LTrim(RTrim(@Sett_Type))) = 'W'
BEGIN

Update settlement Set Settflag = (Case When Sell_Buy = 1 then 4 else 5 end )
Where Party_code = @Party_code
and Scrip_cd = @Scrip_Cd
and Series = @Series
and sauda_date Like @Tdate +'%'
and Sett_Type = @Sett_type
and partipantcode = @Participantcode

END

If Upper(LTrim(RTrim(@Sett_Type))) <> 'W'
BEGIN

Update settlement Set Settflag = (Case When Sell_Buy = 1 then 2 else 3 end )
Where Party_code = @Party_code
and Scrip_cd = @Scrip_Cd
and Series = @Series
and sauda_date Like @Tdate +'%'
and Sett_Type = @Sett_type
and partipantcode = @Participantcode

--Print ' Updated according to sell_buy flag '
Set  @@loop = cursor for
Select Isnull(Sum(Tradeqty),0) from Settlement where Sell_buy = 2
and Party_code = @Party_code and partipantcode = @Participantcode
and Scrip_cd = @Scrip_cd and Series = @Series
and  Sauda_date Like  @Tdate  +'%' and Sett_type = @Sett_type
Open @@Loop
Fetch next from @@Loop into @@Sqty
If @@Fetch_status = 0
Begin
          Close @@Loop
          Deallocate @@loop
End

--Print 'Sqty ' + Convert(varchar,@@Sqty)
Set @@Loop = Cursor for
Select Isnull(Sum(Tradeqty),0) from Settlement where Sell_buy = 1
and Party_code = @Party_code and partipantcode = @Participantcode
and Scrip_cd = @Scrip_cd and Series = @Series
and  Sauda_date Like  @Tdate  +'%' and Sett_type = @Sett_type

Open @@loop
Fetch Next from @@Loop into @@Pqty
--Print 'Pqty ' + Convert(varchar,@@Pqty)

If @@Fetch_status = 0
Begin
          Close @@Loop
          Deallocate @@loop
End

If  @@Sqty = 0
Begin
         Update Settlement Set Settflag = 4
         Where Party_code = @Party_code
         and Scrip_cd = @scrip_cd
         and Series = @series
         and Sell_buy = 1
         and Sauda_date Like  @Tdate +'%'
         and Sett_Type = @Sett_type
         and partipantcode = @Participantcode
 End
 If  @@Pqty = 0
 Begin
           Update Settlement set Settflag = 5
           Where party_code = @Party_code
           and Scrip_cd = @Scrip_cd
           and Series = @Series
           and Sell_buy = 2
           and sauda_date Like  @Tdate +'%'
           and Sett_Type = @Sett_type
           and partipantcode = @Participantcode
 End

 If  ( (@@Pqty > @@Sqty) and (@@Sqty > 0 ))
 Begin
           Select @@Pdiff = @@Pqty - @@Sqty
           --Print ' in Pqty > Sqty '
           --Select @@Pdiff
           Set @@Loop  = Cursor For
           Select Trade_no,Tradeqty From Settlement
           Where Party_code = @Party_code
           and Scrip_cd = @Scrip_cd
          and Series = @Series
          and Sell_buy = 1
          and Sauda_date Like @Tdate +'%'
          and Sett_Type = @Sett_type
          and partipantcode = @Participantcode
          Order by Marketrate Desc
          Open @@Loop
          Fetch Next From @@Loop Into @@Ltrade_no,@@Lqty

          While ( @@Fetch_Status = 0 ) and (@@Pdiff > 0)
          Begin
                 If @@Pdiff >= @@Lqty
                    Begin
                              Update Settlement Set Settflag = 4
                              Where Party_code = @Party_code
                              and Scrip_cd = @Scrip_cd
                              and Series = @Series
                              and Sell_buy = 1
                              and Trade_no = @@ltrade_no
                              and Tradeqty = @@lqty
                              and sauda_date  Like @Tdate +'%'
                              and Sett_Type = @Sett_type
                              and partipantcode = @Participantcode

                             Select @@Pdiff = @@Pdiff - @@Lqty
                     End
                     Else If @@Pdiff < @@Lqty
                     Begin
                               Insert into Settlement
                               Select ContractNo,BillNo,'R'+Trade_no,Party_Code,Scrip_Cd,User_id,@@Pdiff,AuctionPart,MarketType,Series,Order_no,MarketRate,Sauda_date,Table_No,Line_No,Val_perc,Normal,Day_puc,day_sales,Sett_purch,Sett_sales,Sell_buy,4,Brokapplied,NetRate,Amount,Ins_chrg,turn_tax,other_chrg,sebi_tax,Broker_chrg,Service_tax,@@Pdiff*MarketRate,BillFlag,sett_no,NBrokApp,NSerTax,N_NetRate,sett_type  ,partipantCode,Status,Pro_Cli,CpId,Instrument,BookType,Branch_Id,tmark,scheme,Dummy1,Dummy2
                               From Settlement Where
                               Party_code = @Party_code
                               and Scrip_cd = @Scrip_cd
                               and Series = @Series
                               and Sell_buy = 1
                               and Trade_no = @@ltrade_no
                               and tradeqty = @@lqty
                               and sauda_date  Like @Tdate +'%'
                               and Sett_Type = @Sett_type
                               and partipantcode = @Participantcode

                               Update Settlement Set Settflag = 2,Tradeqty = @@Lqty - @@Pdiff,Trade_Amount = (@@Lqty - @@pdiff)*MarketRate
                               Where Party_code = @Party_code
                                and Scrip_cd = @Scrip_cd
                                and Series = @Series
                                and Sell_Buy = 1
                                and Trade_no = @@LTrade_no
                                and Tradeqty = @@LQty
                                and  sauda_date  Like @Tdate +'%'
                                and Sett_Type = @Sett_type
                                and partipantcode = @Participantcode
                                Select @@Pdiff = 0
                      End
                Fetch next from @@Loop into @@Ltrade_no,@@Lqty
        End
End
        If ((@@Pqty < @@Sqty) And (@@PQty > 0 ))
        Begin
                  Select @@Pdiff = @@Sqty - @@Pqty
                  --Print ' in Pqty > Sqty '
                 --Select @@Pdiff

                 Set @@Loop  = Cursor For
                 Select Trade_no,Tradeqty From Settlement
                 Where Party_code = @Party_code
                 and Scrip_cd = @Scrip_cd
                 and Series = @Series
                 and Sell_buy = 2
                 and  sauda_date  Like @Tdate +'%'
                 and Sett_Type = @Sett_type
                 and partipantcode = @Participantcode
                 Order by Marketrate Desc
                 Open @@Loop
                 Fetch Next From @@Loop Into @@Ltrade_no,@@Lqty

                 While ( @@Fetch_Status = 0 ) and (@@Pdiff > 0)
                 Begin
                            If @@Pdiff >= @@Lqty
                            Begin
                                       Update Settlement Set Settflag = 5
                                        Where Party_code = @Party_code
                                        and Scrip_cd = @Scrip_cd
                                        and Series = @Series
                                        and Sell_buy = 2
                                        and Trade_no = @@ltrade_no
                                        and Tradeqty = @@lqty
                                        and  sauda_date  Like @Tdate +'%'
                                        and Sett_Type = @Sett_type
                                        and partipantcode = @Participantcode

                                        Select @@Pdiff = @@Pdiff - @@Lqty
                            End
                            Else If @@Pdiff < @@Lqty
                            Begin
                                       Insert into Settlement
                                       Select ContractNo,BillNo,'R'+Trade_no,Party_Code,Scrip_Cd,User_id,@@Pdiff,AuctionPart,MarketType,Series,Order_no,MarketRate,Sauda_date,Table_No,Line_No,Val_perc,Normal,Day_puc,day_sales,Sett_purch,Sett_sales,Sell_buy,5,Brokapplied,NetRate,Amount,Ins_chrg,turn_tax,other_chrg,sebi_tax,Broker_chrg,Service_tax,@@Pdiff*MarketRate,BillFlag,sett_no,NBrokApp,NSerTax,N_NetRate,sett_type  ,partipantCode,Status,Pro_Cli,CpId,Instrument,BookType,Branch_Id, tmark,scheme,Dummy1,Dummy2
                                       From Settlement Where
                                       Party_code = @Party_code
                                       and Scrip_cd = @Scrip_cd
                                       and Series = @Series
                                       and Sell_buy = 2
                                       and Trade_no = @@ltrade_no
                                       and tradeqty = @@lqty
                                       and  sauda_date  Like @Tdate +'%'
                                       and Sett_Type = @Sett_type
                                       and partipantcode = @Participantcode

                                      Update Settlement Set Settflag = 3,Tradeqty = @@Lqty - @@Pdiff,Trade_Amount = (@@Lqty - @@pdiff)*MarketRate
                                       Where Party_code = @Party_code
                                       and Scrip_cd = @Scrip_cd
                                       and Series = @Series
                                       and Sell_Buy = 2
                                       and Trade_no = @@LTrade_no
                                       and Tradeqty = @@LQty
                                       and  sauda_date  Like @Tdate +'%'
                                       and Sett_Type = @Sett_type
                                       and partipantcode = @participantcode
                                       Select @@Pdiff = 0
                                End
                                Fetch next from @@Loop into @@Ltrade_no,@@Lqty
                    End
        End
END

if @@error = 0
begin
	insert into inst_log values
	(
		ltrim(rtrim(@Party_code)),	/*party_code*/
		ltrim(rtrim(@Party_code)),	/*new_party_code*/
		convert(datetime, ltrim(rtrim(@TDate))),	 /*sauda_date*/
		ltrim(rtrim('')),	 /*sett_no*/
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
		0,		/*net_rate*/
		0,		/*new_net_rate*/
		0,		/*qty*/
		0,		/*new_qty*/
		ltrim(rtrim(@Participantcode)),	 /*participant_code*/
		ltrim(rtrim(@Participantcode)),	 /*new_participant_code*/
		ltrim(rtrim(@StatusName)),	 /*username*/
		ltrim((@FromWhere)),	 /*module*/
		'BSEReArrangeAfterContFlag',	/*called_from*/
		getdate(),	/*timestamp*/
		ltrim(rtrim('')),	/*extrafield3*/
		ltrim(rtrim('')),	/*extrafield4*/
		ltrim(rtrim(''))	 /*extrafield5*/
	)
end

GO
