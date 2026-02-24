-- Object: PROCEDURE dbo.NewUpdBillTaxAfterBill
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



CREATE procedure
	NewUpdBillTaxAfterBill
	(
		@SETTNO VARCHAR(7),
		@SETTYPE VARCHAR(2),
		@Party_code Varchar(10),
		@Scrip_cd varchar(12),
		@StatusName VarChar(50),
		@FromWhere VarChar(50)
	)

as

Update Settlement set Tmark = Tmark , table_no = broktable.table_no, line_no = broktable.line_no,val_perc = broktable.val_perc,
    Normal = Broktable.Normal, day_puc= Broktable.Day_puc,day_sales = Broktable.day_sales,
    sett_purch =   Broktable.Sett_purch,sett_sales = broktable.Sett_sales,
    NBrokApp = (  case
    when (  broktable.val_perc ='V' )
                             Then
		((floor(( broktable.Normal * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /

		(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /

		power(10,CT.Round_To))

                        when (  broktable.val_perc ='P' )
                             Then      ((floor ( (((broktable.Normal /100 ) * Settlement.marketrate)  * power(10,CT.Round_To) + CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
   Else
          BrokApplied
                        End
                         ),
       N_NetRate = (  case
                      when (  broktable.val_perc ='V' AND Settlement.SELL_BUY = 1)
                             Then
                                  Settlement.marketrate + ((floor((  (( broktable.Normal)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
                      when (  broktable.val_perc ='P' AND Settlement.SELL_BUY = 1 )
                             Then Settlement.marketrate + ((floor(( (((broktable.Normal /100 )* Settlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))

                      when (broktable.val_perc ='V' AND Settlement.SELL_BUY =2 )
                             Then Settlement.marketrate - ((floor(( (( broktable.Normal )) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / 	power(10,CT.Round_To))
                      when ( broktable.val_perc ='P' AND Settlement.SELL_BUY = 2 )
                             Then
                      Settlement.marketrate - ((floor(( (((broktable.Normal /100 )* Settlement.marketrate)) * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To))
   Else
             NetRate
                        End
                         ),/*modified by bhayashree on 27-12-2000*/

        NSertax = (Case When Client2.Service_Chrg = 1 And Client2.SerTaxMethod = 1
			     Then 0
			     Else (case when ( broktable.val_perc ='V' )
			Then ( ( ((floor(( broktable.Normal * power(10,CT.Round_To)+CT.RoFig + CT.ErrNum ) /
				(CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  /
				power(10,CT.Round_To)) ) * ( Settlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )
                        when (broktable.val_perc ='P' )
                        Then ((((floor ( (((broktable.Normal /100 ) * Settlement.marketrate)  * power(10,CT.Round_To) + CT.RoFig + CT.ErrNum ) /  (CT.RoFig + CT.NoZero )) * (CT.RoFig +CT.NoZero ) )  / power(10,CT.Round_To)) ) * ( Settlement.Tradeqty * Globals.service_tax) )  / ( CASE WHEN CLIENT2.Service_chrg <>  3 THEN 100 ELSE (100 + Globals.service_tax)  END )
   			Else Settlement.Service_tax
                        End ) End
                         ) /*  /  ( CASE WHEN CLIENT2.Service_chrg =  0 THEN 100 ELSE (100 + Settlement.service_tax)  END )*/,
Ins_chrg  =(Case when Settlement.status = 'N' then 0 else ((CT.insurance_chrg * Settlement.marketrate * Settlement.Tradeqty)/100) End),
turn_tax  = (Case when Settlement.status = 'N' then 0 else ((CT.turnover_tax * Settlement.marketrate * Settlement.Tradeqty)/100 ) end),
other_chrg =(Case when Settlement.status = 'N' then 0 else ((CT.other_chrg * Settlement.marketrate * Settlement.Tradeqty)/100 ) end),
sebi_tax = (Case when Settlement.status = 'N' then 0 else ((CT.sebiturn_tax * Settlement.marketrate * Settlement.Tradeqty)/100) end),
Broker_chrg =(Case when Settlement.status = 'N' then 0 else ((CT.broker_note * Settlement.marketrate * Settlement.Tradeqty)/100) end)

      FROM BrokTable BrokTable,Client2,globals, Settlement,Client1, ClientBrok_Scheme S, ClientTaxes_New CT, Owner
      WHERE Settlement.Party_Code = Client2.Party_code
      And Client2.Cl_code = Client1.Cl_code
      And Client2.Party_Code = CT.Party_Code
      And CT.trans_Cat = 'DEL'
      And S.Trade_Type = (Case When Settlement.PartipantCode = MemberCode Then 'NRM' Else 'INS' End)
      And Settlement.Sauda_Date Between FromDate And ToDate
      And S.Table_No = Broktable.Table_no
      And S.Scheme_Type = 'DEL'
      And S.Scrip_Cd = 'ALL'
      And S.PARTY_CODE = Settlement.Party_Code
      And Settlement.Sauda_Date Between S.From_Date And S.To_Date

      And Broktable.Line_no = (Select min(Broktable.line_no) from broktable where
		               S.Table_No = Broktable.Table_no
			       And Trd_Del = 'D' And Settlement.Party_Code =  Client2.Party_code
			       And Settlement.marketrate <= Broktable.upper_lim )
      And (Globals.exchange = 'NSE')

      AND Settlement.SETT_NO = @SETTNO
      AND Settlement.SETT_TYPE = @SETTYPE
      and Settlement.billflag in(4,5)
      and Settlement.status <> 'E'
      and Settlement.party_code = @party_code
      and Settlement.scrip_cd = @Scrip_cd
      And Sauda_date > Globals.year_start_dt
      And Sauda_date < Globals.year_end_dt

if @@error = 0
begin
	insert into inst_log values
	(
		ltrim(rtrim(@Party_code)),	/*party_code*/
		ltrim(rtrim(@Party_code)),	/*new_party_code*/
		convert(datetime, ltrim(rtrim(''))),	 /*sauda_date*/
		ltrim(rtrim(@SETTNO)),	 /*sett_no*/
		ltrim(rtrim(@SETTYPE)),	 /*sett_type*/
		ltrim(rtrim(@Scrip_cd)),	/*scrip_cd*/
		ltrim(rtrim('NSE')),	/*series*/
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
		ltrim(rtrim('')),	 /*participant_code*/
		ltrim(rtrim('')),	 /*new_participant_code*/
		ltrim(rtrim(@StatusName)),	 /*username*/
		ltrim((@FromWhere)),	 /*module*/
		'NewUpdBillTaxAfterBill',	/*called_from*/
		getdate(),	/*timestamp*/
		ltrim(rtrim('')),	/*extrafield3*/
		ltrim(rtrim('')),	/*extrafield4*/
		ltrim(rtrim(''))	 /*extrafield5*/
	)
end

GO
