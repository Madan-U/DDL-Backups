-- Object: PROCEDURE dbo.BSEReArrangeAfterContFlagIns_With_ContNo
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



CREATE procedure
[dbo].[BSEReArrangeAfterContFlagIns_With_ContNo]
(
	@Sett_Type varchar(2),
	@Party_code Varchar(10),
	@Scrip_cd varchar(12),
	@Series varchar(3),
	@TDate Varchar(11),
	@TMark varchar(2),
	@Participantcode varchar(15),
	@ContractNo varchar(7),
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
 @@Sett_no Varchar(10),
 @@GetStyle Cursor,
 @@TSell_Buy int,
 @@Tran_cat Char(3)

 /*  apply sett_flag = 1 to all trades where client2. tran_cat   = 'DEL' */

Select @Tdate = Ltrim(Rtrim(@Tdate))
If Len(@Tdate) = 10
Begin
          Select @Tdate = STUFF(@Tdate, 4, 1,'  ')
End


Set @@Getstyle = Cursor for
        Select Sett_no from sett_mst where Sett_type = @Sett_type and Start_Date < @Tdate + ' 00:01:01' and End_date > @Tdate + ' 00:01:01'
        Open @@Getstyle
        Fetch next from @@Getstyle into @@sett_no
        Close @@Getstyle

Select @@Tran_cat = Tran_cat from Client2 where party_code = @Party_code

 Update isettlement Set Settflag = 1  FROM isettlement t , CLIENT2
 Where  CLIENT2.PARTY_CODE = T.party_code
 and (CLIENT2.tran_cat = 'DEL' )
 and  t. party_code = @Party_code
 and t.scrip_cd = @scrip_cd
 and t.series = @series
 and t.sauda_date Like  @Tdate  +'%'
 and t.Sett_Type = @Sett_type
 and t.Partipantcode = @Participantcode
 and t.Tmark like @Tmark
 And T.Sett_no = @@Sett_no
 and  t.tradeqty > 0
 --ADDED BY SHYAM
 and contractno = @ContractNo
 --END - ADDED BY SHYAM

If @@Tran_cat = 'TRD'
Begin
Update isettlement Set Settflag = (Case When Sell_Buy = 1 then 2 else 3 end ) FROM isettlement t , CLIENT2
Where
Client2.Party_code = T.party_code
 and
(CLIENT2.tran_cat = 'TRD' )
And
t.Party_code = @Party_code
and Scrip_cd = @Scrip_Cd
and Series = @Series
and Sauda_date Like @Tdate +'%'
and Sett_Type = @Sett_type
and Partipantcode = @Participantcode
and Sett_no = @@Sett_no
--ADDED BY SHYAM
and contractno = @ContractNo
--END - ADDED BY SHYAM

Set  @@loop = cursor for
Select Isnull(Sum(Tradeqty),0) from ISettlement where Sell_buy = 2
and Party_code = @Party_code and Partipantcode = @Participantcode
and Scrip_cd = @Scrip_cd and Series = @Series and Tmark Like @Tmark
and  Sauda_date Like  @Tdate  +'%' and Sett_type = @Sett_type
and Sett_no = @@Sett_no
--ADDED BY SHYAM
and contractno = @ContractNo
--END - ADDED BY SHYAM

Open @@Loop
Fetch next from @@Loop into @@Sqty
If @@Fetch_status = 0
Begin
   close @@Loop
   deallocate @@loop
End

Set @@Loop = Cursor for
Select Isnull(Sum(Tradeqty),0) from ISettlement where Sell_buy = 1
and Party_code = @Party_code and Partipantcode = @Participantcode
and Scrip_cd = @Scrip_cd and Series = @Series and Tmark Like @Tmark
and  Sauda_date Like  @Tdate  +'%' and Sett_type = @Sett_type
and Sett_no = @@Sett_no
--ADDED BY SHYAM
and contractno = @ContractNo
--END - ADDED BY SHYAM

Open @@loop
Fetch Next from @@Loop into @@Pqty

If @@Fetch_status = 0
Begin
   close @@Loop
   deallocate @@loop
End


If  @@Sqty = 0
Begin
         Update isettlement Set Settflag = 4
         Where Party_code = @Party_code
         and Scrip_cd = @scrip_cd
         and Series = @series
         and Sell_buy = 1
         and Sauda_date Like  @Tdate +'%'
         and Sett_Type = @Sett_type
         and Tmark like @TMark
         and Partipantcode = @Participantcode
         And Sett_no = @@sett_no
			--ADDED BY SHYAM
			and contractno = @ContractNo
			--END - ADDED BY SHYAM
 End
 If  @@Pqty = 0
 Begin
           Update isettlement set Settflag = 5
           Where party_code = @Party_code
           and Scrip_cd = @Scrip_cd
           and Series = @Series
           and Sell_buy = 2
           and sauda_date Like  @Tdate +'%'
           and Sett_Type = @Sett_type
           and Tmark like @TMark
           and Partipantcode = @Participantcode
           And Sett_no = @@Sett_no
				--ADDED BY SHYAM
				and contractno = @ContractNo
				--END - ADDED BY SHYAM
 End
 If  ( (@@Pqty > @@Sqty) and (@@Sqty > 0 ))
 Begin
           Select @@Pdiff = @@Pqty - @@Sqty
           Set @@Loop  = Cursor For
           Select Trade_no,Tradeqty From isettlement
           Where Party_code = @Party_code
           and Scrip_cd = @Scrip_cd
          and Series = @Series
          and Sell_buy = 1
          and Sauda_date Like @Tdate +'%'
          and Sett_Type = @Sett_type
          and Tmark like @TMark
          and Partipantcode = @Participantcode
          And Sett_no = @@Sett_no
			--ADDED BY SHYAM
			and contractno = @ContractNo
			--END - ADDED BY SHYAM

          Order by Marketrate Desc            Open @@Loop
          Fetch Next From @@Loop Into @@Ltrade_no,@@Lqty

          While ( @@Fetch_Status = 0 ) and (@@Pdiff > 0)
          Begin
                    If @@Pdiff >= @@Lqty
                    Begin
                              Update isettlement Set Settflag = 4
                              Where Party_code = @Party_code
                              and Scrip_cd = @Scrip_cd
                              and Series = @Series
                              and Sell_buy = 1
                              and Trade_no = @@ltrade_no
                              and Tradeqty = @@lqty
                              and sauda_date  Like @Tdate +'%'
                              and Sett_Type = @Sett_type
                              and Tmark like @TMark
                              and partipantcode = @Participantcode
                              And Sett_no = @@Sett_no
										--ADDED BY SHYAM
										and contractno = @ContractNo
										--END - ADDED BY SHYAM

                             Select @@Pdiff = @@Pdiff - @@Lqty
                     End
                     Else If @@Pdiff < @@Lqty
                     Begin
                               Insert into isettlement
                               Select ContractNo,BillNo,'R'+Trade_no,Party_Code,Scrip_Cd,User_id,@@Pdiff,AuctionPart,MarketType,Series,Order_no,MarketRate,Sauda_date,Table_No,Line_No,Val_perc,Normal,Day_puc,day_sales,Sett_purch,Sett_sales,Sell_buy,4,Brokapplied,NetRate,Amount,Ins_chrg,turn_tax,other_chrg,sebi_tax,Broker_chrg,Service_tax,@@Pdiff*MarketRate,BillFlag,sett_no,NBrokApp,NSerTax,N_NetRate,sett_type  ,PartiPantCode,Status,Pro_Cli,CpId,Instrument,BookType,Branch_Id,tmark,scheme,Dummy1,Dummy2
                               From isettlement Where
                               Party_code = @Party_code
                               and Scrip_cd = @Scrip_cd
                               and Series = @Series
                               and Sell_buy = 1
                               and Trade_no = @@ltrade_no
                               and tradeqty = @@lqty
                               and   sauda_date  Like @Tdate +'%'
                               and Sett_Type = @Sett_type
                               and tmark like @TMark
                               and partipantcode = @Participantcode
                               And Sett_no = @@Sett_no
										--ADDED BY SHYAM
										and contractno = @ContractNo
										--END - ADDED BY SHYAM

                               Update isettlement Set Settflag = 2,Tradeqty = @@Lqty - @@Pdiff,Trade_Amount = (@@Lqty - @@pdiff)*MarketRate
                               Where Party_code = @Party_code
                                and Scrip_cd = @Scrip_cd
                                and Series = @Series
                                and Sell_Buy = 1
                                and Trade_no = @@LTrade_no
                                and Tradeqty = @@LQty
                                and  sauda_date  Like @Tdate +'%'
                                and Sett_Type = @Sett_type
                                and Tmark like @TMark
                                and partipantcode = @Participantcode
                                And Sett_no = @@Sett_no
										--ADDED BY SHYAM
										and contractno = @ContractNo
										--END - ADDED BY SHYAM

                                Select @@Pdiff = 0
                      End
                Fetch next from @@Loop into @@Ltrade_no,@@Lqty
        End
End
        If ((@@Pqty < @@Sqty) And (@@PQty > 0 ))
        Begin
                  Select @@Pdiff = @@Sqty - @@Pqty
                 Set @@Loop  = Cursor For
                 Select Trade_no,Tradeqty From isettlement
                 Where Party_code = @Party_code
                 and Scrip_cd = @Scrip_cd
                 and Series = @Series
                 and Sell_buy = 2
                 and  sauda_date  Like @Tdate +'%'
                 and Sett_Type = @Sett_type
                 and Tmark like @TMark
/*                 and  ( Tmark <> 'D') */
                 and Partipantcode = @Participantcode
                 And Sett_no = @@Sett_no
						--ADDED BY SHYAM
						and contractno = @ContractNo
						--END - ADDED BY SHYAM

                 Order by Marketrate Desc
                 Open @@Loop
                 Fetch Next From @@Loop Into @@Ltrade_no,@@Lqty

                 While ( @@Fetch_Status = 0 ) and (@@Pdiff > 0)
                 Begin
                            If @@Pdiff >= @@Lqty
                            Begin
                                       Update isettlement Set Settflag = 5
                                        Where Party_code = @Party_code
                                        and Scrip_cd = @Scrip_cd
                                        and Series = @Series
                                        and Sell_buy = 2
                                        and Trade_no = @@ltrade_no
                                        and Tradeqty = @@lqty
                                        and  sauda_date  Like @Tdate +'%'
                                        and Sett_Type = @Sett_type
                                        and Tmark like @TMark
                                        and partipantcode = @Participantcode
                                        And Sett_no = @@Sett_no
													--ADDED BY SHYAM
													and contractno = @ContractNo
													--END - ADDED BY SHYAM

                                        Select @@Pdiff = @@Pdiff - @@Lqty
                            End
                            Else If @@Pdiff < @@Lqty
                            Begin
                                       Insert into isettlement
                                       Select ContractNo,BillNo,'R'+Trade_no,Party_Code,Scrip_Cd,User_id,@@Pdiff,AuctionPart,MarketType,Series,Order_no,MarketRate,Sauda_date,Table_No,Line_No,Val_perc,Normal,Day_puc,day_sales,Sett_purch,Sett_sales,Sell_buy,5,Brokapplied,NetRate,Amount,Ins_chrg,turn_tax,other_chrg,sebi_tax,Broker_chrg,Service_tax,@@Pdiff*MarketRate,BillFlag,sett_no,NBrokApp,NSerTax,N_NetRate,sett_type  ,PartiPantCode,Status,Pro_Cli,CpId,Instrument,BookType,Branch_Id,tmark,scheme,Dummy1,Dummy2
                                       From isettlement Where
                                       Party_code = @Party_code
                                       and Scrip_cd = @Scrip_cd
                                       and Series = @Series
                                       and Sell_buy = 2
                                       and Trade_no = @@ltrade_no
                                       and tradeqty = @@lqty
                                       and  sauda_date  Like @Tdate +'%'
                                       and Sett_Type = @Sett_type
                                       and tmark like @TMark
                                       and partipantcode = @Participantcode
                                       And Sett_no = @@Sett_no
													--ADDED BY SHYAM
													and contractno = @ContractNo
													--END - ADDED BY SHYAM

                                      Update isettlement Set Settflag = 3,Tradeqty = @@Lqty - @@Pdiff,Trade_Amount = (@@Lqty - @@pdiff)*MarketRate
                                       Where Party_code = @Party_code
                                       and Scrip_cd = @Scrip_cd
                                       and Series = @Series
                                       and Sell_Buy = 2
                                       and Trade_no = @@LTrade_no
                                       and Tradeqty = @@LQty
                                       and  sauda_date  Like @Tdate +'%'
                                       and Sett_Type = @Sett_type
                                       and Tmark like @TMark
                                       and partipantcode = @participantcode
                                       And Sett_no = @@Sett_no
													--ADDED BY SHYAM
													and contractno = @ContractNo
													--END - ADDED BY SHYAM

                                       Select @@Pdiff = 0
                                End
                                Fetch next from @@Loop into @@Ltrade_no,@@Lqty
                    End
        End

End

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
		ltrim(rtrim(@ContractNo)),	/*contract_no*/
		ltrim(rtrim(@ContractNo)),	/*new_contract_no*/
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
		'BSEReArrangeAfterContFlagIns_With_ContNo',	/*called_from*/
		getdate(),	/*timestamp*/
		ltrim(rtrim('')),	/*extrafield3*/
		ltrim(rtrim('')),	/*extrafield4*/
		ltrim(rtrim(''))	 /*extrafield5*/
	)
end

GO
