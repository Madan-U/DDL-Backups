-- Object: PROCEDURE dbo.NSESettBrokEditIns_With_ContNo
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



Create  procedure
NSESettBrokEditIns_With_ContNo
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

declare
@market_rate money,
@qty bigint

--print '@market_rate' + convert(varchar, @market_rate)
--print '@qty' + convert(varchar, @qty)

select distinct @market_rate = marketrate,  @qty = isnull(sum(tradeqty), 0) from isettlement
where
party_code = @tparty
and sauda_date like @tdate + '%'
and scrip_cd Like @tscrip_cd
and Series like @tSeries
and tradeqty > 0
And Sett_type Like @Sett_type
And Sett_no Like @sett_no
And Sell_buy = @Sell_buy
And Partipantcode = @partipantcode
And Order_no like @OrderNo
And Trade_no like @Trade_No
/*ADDED BY SHYAM*/
and convert(bigint, contractno) = convert(bigint, @ContractNo)
/*END - ADDED BY SHYAM*/
group by
	marketrate

--print 'select distinct marketrate,  tradeqty from isettlement'
--print 'where'
--print 'party_code = ''' +  @tparty + ''''
--print 'and sauda_date like ''' + @tdate + '%'''
--print 'and scrip_cd Like ''' +  @tscrip_cd + ''''
--print 'and Series like ''' +  @tSeries + ''''
--print 'and tradeqty > 0'
--print 'And Sett_type Like ''' +  @Sett_type + ''''
--print 'And Sett_no Like ''' + @sett_no + ''''
--print 'And Sell_buy = ''' + @Sell_buy + ''''
--print 'And Partipantcode = ''' + @partipantcode + ''''
--print 'And Order_no like ''' + @OrderNo + ''''
--print 'And Trade_no like ''' + @Trade_No + ''''
/*ADDED BY SHYAM*/
--print 'and convert(bigint, contractno) = convert(bigint, ''' + @ContractNo + ''')'
/*END - ADDED BY SHYAM*/

--print '@market_rate' + convert(varchar, @market_rate)
--print '@qty' + convert(varchar, @qty)

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
						/*(floor((Abs(@BrokRage)*power(10,Broktable.round_to)+broktable.roFig + broktable.errnum)/
		 		                 (broktable.RoFig + broktable.Nozero))*(broktable.rofig +broktable.NoZero))/power(10,broktable.round_to) */

				      Else
						(floor((Abs(@BrokRage*MarketRate/100)*power(10,Broktable.round_to)+broktable.roFig + broktable.errnum)/
		 		                (broktable.RoFig + broktable.Nozero))*(broktable.rofig +broktable.NoZero))/power(10,broktable.round_to)
				      End )
	               End),
       NetRate = (Case when ISettlement.status = 'N'
		       then ISettlement.MARKETRATE
	                    else (Case When Sell_Buy = 1
			           Then ( Case  When @ValPer = 0
				                   Then MarketRate + @BrokRage
							/*(floor((Abs(MarketRate + @BrokRage)*power(10,Broktable.round_to)+broktable.roFig + broktable.errnum)/
		             	             		(broktable.RoFig + broktable.Nozero))*(broktable.rofig +broktable.NoZero))/power(10,broktable.round_to) */
			                      	   Else
							(floor((Abs(MarketRate + (@BrokRage*MarketRate/100))*power(10,Broktable.round_to)+broktable.roFig + broktable.errnum)/
			             	                (broktable.RoFig + broktable.Nozero))*(broktable.rofig +broktable.NoZero))/power(10,broktable.round_to)
				         End)
			           Else ( Case  When @ValPer = 0
				                   Then MarketRate - @BrokRage
							/*(floor((Abs(MarketRate - @BrokRage)*power(10,Broktable.round_to)+broktable.roFig + broktable.errnum)/
		             	             		(broktable.RoFig + broktable.Nozero))*(broktable.rofig +broktable.NoZero))/power(10,broktable.round_to) */
			                      	   Else
							(floor((Abs(MarketRate - (@BrokRage*MarketRate/100))*power(10,Broktable.round_to)+broktable.roFig + broktable.errnum)/
			             	                (broktable.RoFig + broktable.Nozero))*(broktable.rofig +broktable.NoZero))/power(10,broktable.round_to)
				         End)
			 End)
	           End),
       Amount = TradeQty*(Case when ISettlement.status = 'N'
		       		then ISettlement.MARKETRATE
	        	            else (Case When Sell_Buy = 1
				           Then ( Case  When @ValPer = 0
					                   Then MarketRate + @BrokRage
								/*(floor((Abs(MarketRate + @BrokRage)*power(10,Broktable.round_to)+broktable.roFig + broktable.errnum)/
		             	             			(broktable.RoFig + broktable.Nozero))*(broktable.rofig +broktable.NoZero))/power(10,broktable.round_to) */
			                	      	   Else
								(floor((Abs(MarketRate + (@BrokRage*MarketRate/100))*power(10,Broktable.round_to)+broktable.roFig + broktable.errnum)/
			        	     	                (broktable.RoFig + broktable.Nozero))*(broktable.rofig +broktable.NoZero))/power(10,broktable.round_to)
					         End)
				           Else ( Case  When @ValPer = 0
					                   Then MarketRate - @BrokRage
								/*(floor((Abs(MarketRate - @BrokRage)*power(10,Broktable.round_to)+broktable.roFig + broktable.errnum)/
		             	             			(broktable.RoFig + broktable.Nozero))*(broktable.rofig +broktable.NoZero))/power(10,broktable.round_to) */
			                	      	   Else
								(floor((Abs(MarketRate - (@BrokRage*MarketRate/100))*power(10,Broktable.round_to)+broktable.roFig + broktable.errnum)/
				             	                (broktable.RoFig + broktable.Nozero))*(broktable.rofig +broktable.NoZero))/power(10,broktable.round_to)
					         End)
				 End)
		           End),
       Service_Tax = (Case when ISettlement.status = 'N'
		   	   then 0
			   Else (Case When @Valper = 0
				       Then ((floor((((floor((Abs(@BrokRage)*power(10,broktable.round_to)+Broktable.roFig+Broktable.errnum)/
					   (Broktable.RoFig + Broktable.Nozero))*(Broktable.rofig +Broktable.NoZero))/power(10,Broktable.round_to)*ISettlement.Tradeqty*Globals.service_tax)/
			         		  (CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax) END)*power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                            	  (Broktable.RoFig + Broktable.Nozero))*(Broktable.rofig +Broktable.NoZero))/power(10,Broktable.round_to))
				       Else ((floor((((floor((Abs(@BrokRage*Marketrate/100)*power(10,broktable.round_to)+Broktable.roFig+Broktable.errnum)/
					   (Broktable.RoFig + Broktable.Nozero))*(Broktable.rofig +Broktable.NoZero))/power(10,Broktable.round_to)*ISettlement.Tradeqty*Globals.service_tax)/
			         		  (CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax) END)*power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                            	  (Broktable.RoFig + Broktable.Nozero))*(Broktable.rofig +Broktable.NoZero))/power(10,Broktable.round_to))
			           End )
		      End),
       Trade_amount = ISettlement.Tradeqty * ISettlement.MarketRate,
       NBrokApp = (Case when ISettlement.status = 'N'
		   	  then 0
		   	  else (Case When @ValPer = 0
				      Then  @BrokRage
						/*(floor((Abs(@BrokRage)*power(10,Broktable.round_to)+broktable.roFig + broktable.errnum)/
		 		                 (broktable.RoFig + broktable.Nozero))*(broktable.rofig +broktable.NoZero))/power(10,broktable.round_to) */

				      Else
						(floor((Abs(@BrokRage*MarketRate/100)*power(10,Broktable.round_to)+broktable.roFig + broktable.errnum)/
		 		                (broktable.RoFig + broktable.Nozero))*(broktable.rofig +broktable.NoZero))/power(10,broktable.round_to)
				      End )
	               End),
       N_NetRate = (Case when ISettlement.status = 'N'
		       then ISettlement.MARKETRATE
	                    else (Case When Sell_Buy = 1
			           Then ( Case  When @ValPer = 0
				                   Then MarketRate + @BrokRage
							/*(floor((Abs(MarketRate + @BrokRage)*power(10,Broktable.round_to)+broktable.roFig + broktable.errnum)/
		             	             		(broktable.RoFig + broktable.Nozero))*(broktable.rofig +broktable.NoZero))/power(10,broktable.round_to) */
			                      	   Else
							(floor((Abs(MarketRate + (@BrokRage*MarketRate/100))*power(10,Broktable.round_to)+broktable.roFig + broktable.errnum)/
			             	                (broktable.RoFig + broktable.Nozero))*(broktable.rofig +broktable.NoZero))/power(10,broktable.round_to)
				         End)
			           Else ( Case  When @ValPer = 0
				                   Then MarketRate - @BrokRage
							/*(floor((Abs(MarketRate - @BrokRage)*power(10,Broktable.round_to)+broktable.roFig + broktable.errnum)/
		             	             		(broktable.RoFig + broktable.Nozero))*(broktable.rofig +broktable.NoZero))/power(10,broktable.round_to) */
			                      	   Else
							(floor((Abs(MarketRate - (@BrokRage*MarketRate/100))*power(10,Broktable.round_to)+broktable.roFig + broktable.errnum)/
			             	                (broktable.RoFig + broktable.Nozero))*(broktable.rofig +broktable.NoZero))/power(10,broktable.round_to)
				         End)
			 End)
	           End),
       NSertax = (Case when ISettlement.status = 'N'
		   	   then 0
			   Else (Case When @Valper = 0
				       Then ((floor((((floor((Abs(@BrokRage)*power(10,broktable.round_to)+Broktable.roFig+Broktable.errnum)/
					   (Broktable.RoFig + Broktable.Nozero))*(Broktable.rofig +Broktable.NoZero))/power(10,Broktable.round_to)*ISettlement.Tradeqty*Globals.service_tax)/
			         		  (CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax) END)*power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                            	  (Broktable.RoFig + Broktable.Nozero))*(Broktable.rofig +Broktable.NoZero))/power(10,Broktable.round_to))
				       Else ((floor((((floor((Abs(@BrokRage*Marketrate/100)*power(10,broktable.round_to)+Broktable.roFig+Broktable.errnum)/
					   (Broktable.RoFig + Broktable.Nozero))*(Broktable.rofig +Broktable.NoZero))/power(10,Broktable.round_to)*ISettlement.Tradeqty*Globals.service_tax)/
			         		  (CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax) END)*power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                                            	  (Broktable.RoFig + Broktable.Nozero))*(Broktable.rofig +Broktable.NoZero))/power(10,Broktable.round_to))
			           End )
		      End),
      Status = 'E'
      FROM BrokTable BrokTable,Client2 client2, globals,client1 client1 , Scrip1, Scrip2 /* ,BseBrokCursorAmtQtySumins c  */
      WHERE ISettlement.Party_Code = Client2.Party_code
 And client1.cl_code=client2.cl_code
 And Scrip1.series = scrip2.series
 and scrip1.co_code = scrip2.co_code
 and scrip2.Scrip_Cd = ISettlement.Scrip_Cd
 And ISettlement.series = scrip2.series
  And Broktable.Table_no = CLIENT2.TABLE_NO
	And
	Broktable.Line_no = (Select min(line_no) from broktable where
		             table_no = CLIENT2.TABLE_NO )
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
--  And ContractNo Like @ContractNo
  and iSettlement.Sauda_date > year_start_dt
  and iSettlement.Sauda_date < year_end_dt
	/*ADDED BY SHYAM*/
	and convert(bigint, contractno) = convert(bigint, @ContractNo)
	/*END - ADDED BY SHYAM*/
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
				/*(floor((Abs(@NetRate-MarketRate)*power(10,Broktable.round_to)+broktable.roFig + broktable.errnum)/
		               (broktable.RoFig + broktable.Nozero))*(broktable.rofig +broktable.NoZero))/power(10,broktable.round_to)*/
	      	     End),
       NetRate = (Case when ISettlement.status = 'N'
		       then ISettlement.MARKETRATE
	               else @NetRate
			    /*(floor((Abs(@NetRate)*power(10,Broktable.round_to)+broktable.roFig + broktable.errnum)/
		            (broktable.RoFig + broktable.Nozero))*(broktable.rofig +broktable.NoZero))/power(10,broktable.round_to)*/
		  End),
       Amount = TradeQty*(Case when ISettlement.status = 'N'
		       	       Then ISettlement.MARKETRATE
	                       else @NetRate
				    /*(floor((Abs(@NetRate)*power(10,Broktable.round_to)+broktable.roFig + broktable.errnum)/
		                    (broktable.RoFig + broktable.Nozero))*(broktable.rofig +broktable.NoZero))/power(10,broktable.round_to)*/
		          End),
       Service_Tax = (Case when ISettlement.status = 'N'
		   	   then 0
		   	   else ((floor((((floor((Abs(@NetRate-MarketRate)*power(10,broktable.round_to)+Broktable.roFig+Broktable.errnum)/
					     (Broktable.RoFig + Broktable.Nozero))*(Broktable.rofig +Broktable.NoZero))/power(10,Broktable.round_to)*ISettlement.Tradeqty*Globals.service_tax)/
				(CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax) END)*power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                (Broktable.RoFig + Broktable.Nozero))*(Broktable.rofig +Broktable.NoZero))/power(10,Broktable.round_to))
		      End),
       Trade_amount = ISettlement.Tradeqty * ISettlement.MarketRate,
       NBrokApp =   (Case when ISettlement.status = 'N'
		   	  then 0
		   	  else (Case When Sell_Buy = 1
				     Then @NetRate-MarketRate
				     Else MarketRate-@NetRate
				End )
				/*(floor((Abs(@NetRate-MarketRate)*power(10,Broktable.round_to)+broktable.roFig + broktable.errnum)/
		               (broktable.RoFig + broktable.Nozero))*(broktable.rofig +broktable.NoZero))/power(10,broktable.round_to)*/
	      	     End),
       N_NetRate = (Case when ISettlement.status = 'N'
		       then ISettlement.MARKETRATE
	               else @NetRate
			    /*(floor((Abs(@NetRate)*power(10,Broktable.round_to)+broktable.roFig + broktable.errnum)/
		            (broktable.RoFig + broktable.Nozero))*(broktable.rofig +broktable.NoZero))/power(10,broktable.round_to)*/
		    End),
       NSerTax = (Case when ISettlement.status = 'N'
		        then 0
		   	else ((floor((((floor((Abs(@NetRate-MarketRate)*power(10,broktable.round_to)+Broktable.roFig+Broktable.errnum)/
					     (Broktable.RoFig + Broktable.Nozero))*(Broktable.rofig +Broktable.NoZero))/power(10,Broktable.round_to)*ISettlement.Tradeqty*Globals.service_tax)/
				(CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax) END)*power(10,Broktable.round_to)+Broktable.roFig + Broktable.errnum ) /
                                (Broktable.RoFig + Broktable.Nozero))*(Broktable.rofig +Broktable.NoZero))/power(10,Broktable.round_to))
		   End),
      Status = 'E'
      FROM BrokTable BrokTable,Client2 client2, globals,client1 client1 , Scrip1, Scrip2 /* ,BseBrokCursorAmtQtySumins c  */
      WHERE ISettlement.Party_Code = Client2.Party_code
  and
 client1.cl_code=client2.cl_code And
 Scrip1.series = scrip2.series
 and scrip1.co_code = scrip2.co_code
 and scrip2.Scrip_Cd = ISettlement.Scrip_Cd
 And ISettlement.series = scrip2.series
 And Broktable.Table_no = CLIENT2.TABLE_NO
	And
	Broktable.Line_no = (Select min(line_no) from broktable where
		             table_no = CLIENT2.TABLE_NO )
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
--  And ContractNo Like @ContractNo
  and iSettlement.Sauda_date > year_start_dt
  and iSettlement.Sauda_date < year_end_dt
  /*ADDED BY SHYAM*/
  and convert(bigint, contractno) = convert(bigint, @ContractNo)
  /*END - ADDED BY SHYAM*/
End



Update ISettlement Set Brokapplied = Round(Brokapplied*100/(100 + Globals.service_tax),4),Service_Tax = ( TradeQty * BrokApplied ) - ( Tradeqty * Round(Brokapplied*100/(100 + Globals.service_tax),4)),
NBrokapp = Round(Brokapplied*100/(100 + Globals.service_tax),4),NSerTax = ( TradeQty * BrokApplied) - ( Tradeqty * Round(Brokapplied*100/(100 + Globals.service_tax),4)),
NetRate = (Case When Sell_buy = 1 Then MarketRate + Round(Brokapplied*100/(100 + Globals.service_tax),4) Else MarketRate - Round(Brokapplied*100/(100 + Globals.service_tax),4) End),
N_NetRate = (Case When Sell_buy = 1 Then MarketRate + Round(Brokapplied*100/(100 + Globals.service_tax),4) Else MarketRate - Round(Brokapplied*100/(100 + Globals.service_tax),4) End),
Amount = TradeQty*(Case When Sell_buy = 1 Then MarketRate + Round(Brokapplied*100/(100 + Globals.service_tax),4) Else MarketRate - Round(Brokapplied*100/(100 + Globals.service_tax),4) End)
From Client1 C1, Client2 C2 , Globals
Where C1.Cl_Code = C2.Cl_Code And C2.Party_Code = ISettlement.Party_Code
And C2.Service_Chrg = 1 And ISettlement.party_code = @tparty
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
--And ContractNo Like @ContractNo
And Status = 'E'
and iSettlement.Sauda_date > year_start_dt
and iSettlement.Sauda_date < year_end_dt
/*ADDED BY SHYAM*/
and convert(bigint, contractno) = convert(bigint, @ContractNo)
/*END - ADDED BY SHYAM*/

Select @contractno = convert(bigint, @contractno)
Select @contractno = STUFF('0000000', 8 - Len(@contractno), Len(@contractno), @contractno)

if @@error = 0
begin
	insert into inst_log values
	(
		ltrim(rtrim(@tparty)),	/*party_code*/
		ltrim(rtrim(@tparty)),	/*new_party_code*/
		convert(datetime, ltrim(rtrim(@tdate))),	 /*sauda_date*/
		ltrim(rtrim(@sett_no)),	 /*sett_no*/
		ltrim(rtrim(@sett_type)),	 /*sett_type*/
		ltrim(rtrim(@tscrip_cd)),	/*scrip_cd*/
		ltrim(rtrim(@tseries)),	/*series*/
		ltrim(rtrim(@Orderno)),	 /*order_no*/
		ltrim(rtrim(@Trade_no)),	 /*trade_no*/
		ltrim(rtrim(@Sell_buy)),	/*sell_buy*/
		ltrim(rtrim(@contractno)),	/*contract_no*/
		ltrim(rtrim(@contractno)),	/*new_contract_no*/
		@BrokRage,		/*brokerage*/
		@BrokRage,		/*new_brokerage*/
		@market_rate,		/*market_rate*/
		@market_rate,		/*new_market_rate*/
		@NetRate,		/*net_rate*/
		@NetRate,		/*new_net_rate*/
		@qty,		/*qty*/
		@qty,		/*new_qty*/
		ltrim(rtrim(@partipantCode)),	 /*participant_code*/
		ltrim(rtrim(@partipantCode)),	 /*new_participant_code*/
		ltrim(rtrim(@StatusName)),	 /*username*/
		ltrim((@FromWhere)),	 /*module*/
		'NSESettBrokEditIns_With_ContNo',	/*called_from*/
		getdate(),	/*timestamp*/
		ltrim(rtrim('')),	/*extrafield3*/
		ltrim(rtrim('')),	/*extrafield4*/
		ltrim(rtrim(''))	 /*extrafield5*/
	)
end

GO
