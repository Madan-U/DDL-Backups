-- Object: PROCEDURE dbo.Rms_new_details_15012008
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------







/****** Object:  Stored Procedure Dbo.rms_new_details    Script Date: 01/15/2005 1:24:52 Pm ******/

/****** Object:  Stored Procedure Dbo.rms_new_details    Script Date: 10/29/2004 12:03:41 Pm ******/



--sp_helptext Rpt_proc_netposition

--sp_helptext Rms_new_details

--written By						:			Animesh
--start Date						: 			Mar 31 2003.

-------------------------------------------------------------------------------------------------------------------
--				Modification History
-------------------------------------------------------------------------------------------------------------------
--	.1	By Animesh On Mar 31 2003
--	**********************************************
--	Write Modification Summary Here
--	**********************************************
-------------------------------------------------------------------------------------------------------------------

create     Proc
Rms_new_details_15012008

	@reportname Varchar(50),
	@statusid Varchar(20),
	@statusname Varchar(50),

	@fromdate Varchar(11),
	@todate Varchar(11),
	@whatcode Varchar(20),		--region/broker/branch/subbroker/trader/family/client
	@fromcode Varchar(20),
	@tocode Varchar(20),

	@frompartycode Varchar(20),	--]--> For The From And To Party Codes
	@topartycode Varchar(20),	--]--> If The Level Is Anything Other Than 'party/client'

	@oneormany Varchar(20),

	@categorycode Varchar(50),
	@dummy002 Varchar(50),
	@dummy003 Varchar(50),
	@dummy004 Varchar(50),
	@dummy005 Varchar(50),
	@dummy006 Varchar(50),
	@dummy007 Varchar(50),
	@dummy008 Varchar(50),
	@dummy009 Varchar(50),
	@dummy010 Varchar(50)
As

Declare

	@strselect Varchar(8000),
	@strselecttemp Varchar(8000),
	@strfrom Varchar(8000),
	@strwhere Varchar(8000),
	@strgroupby Varchar(8000),
	@strorderby Varchar(8000),
	@strcompute Varchar(8000),
	@strcomputesub Varchar(8000),

	@issublevel Varchar(3),
	@codeid Varchar(20),
	@comma Varchar(1)

	Set @strselect = ''
	Set @strselecttemp = ''
	Set @strfrom = ''
	Set @strwhere = ''
	Set @strgroupby = ''
	Set @strorderby = ''
	Set @strcompute = ''
	Set @strcomputesub = ''
	Set @issublevel = 'no'	

	If @categorycode = 'all' Or @categorycode = ''
		Select @categorycode = '%' 
	If (@reportname <> '')
	Begin
		If ((@whatcode = 'broker') Or (@whatcode = 'client')) Begin Set @codeid = 'party_code' End
		If (@whatcode = 'branch') Begin Set @codeid = 'branch_cd' End
		If (@whatcode = 'subbroker') Begin Set @codeid = 'sub_broker' End
		If (@whatcode = 'trader') Begin Set @codeid = 'trader' End
		If (@whatcode = 'family') Begin Set @codeid = 'family' End
		
		Set @strselect = @strselect + "select "
		Set @strcompute = @strcompute + "compute "

		If ((@oneormany = 'detail') Or (@whatcode = 'client'))
		Begin		
			If (@whatcode = 'client') Begin Set @strselect = @strselect + "party_code, Left(party_name,25) As Party_name,npercentscrip,npercent,bpercentscrip,bpercent,sales_person,cust_executive, " End
			If (@whatcode = 'branch') Begin Set @strselect = @strselect + "branch_cd,party_code, Left(party_name,25) As Party_name,npercentscrip,npercent,bpercentscrip,bpercent,sales_person,cust_executive, " End
			If (@whatcode = 'subbroker') Begin Set @strselect = @strselect + "sub_broker,party_code, Left(party_name,25) As Party_name,npercentscrip,npercent,bpercentscrip,bpercent,sales_person,cust_executive, " End
			If (@whatcode = 'trader') Begin Set @strselect = @strselect + "trader,party_code, Left(party_name,25) As Party_name,npercentscrip,npercent,bpercentscrip,bpercent,sales_person,cust_executive, " End
			If (@whatcode = 'family') Begin Set @strselect = @strselect + "family, Left(familyname,25) As Familyname,party_code,left(party_name,25) As Party_name,npercentscrip,npercent,bpercentscrip,bpercent,sales_person,cust_executive, " End
		End
		Else /*if ((@oneormany = 'detail') Or (@whatcode = 'broker') Or (@whatcode = 'client'))*/
		Begin /*else Of If ((@oneormany = 'detail') Or (@whatcode = 'broker') Or (@whatcode = 'client'))*/
			If (@whatcode = 'client') Begin Set @strselect = @strselect + "party_code, Left(party_name,25) As Party_name,npercentscrip,npercent,bpercentscrip,bpercent,sales_person,cust_executive, " End
			If (@whatcode = 'branch') Begin Set @strselect = @strselect + "branch_cd, " End
			If (@whatcode = 'subbroker') Begin Set @strselect = @strselect + "sub_broker, " End
			If (@whatcode = 'trader') Begin Set @strselect = @strselect + "trader, " End
			If (@whatcode = 'family') Begin Set @strselect = @strselect + "family, Left(familyname,25) As Familyname, " End
		End /*else Of If ((@oneormany = 'detail') Or (@whatcode = 'broker') Or (@whatcode = 'client'))*/

		--non_cash
		Set @strselecttemp = ''
		Set @strselecttemp = @strselecttemp + " Round(sum(non_cash)/100000,2) "
		Set @strcompute = @strcompute + "sum(" + @strselecttemp + ")," 
		Set @strselecttemp = @strselecttemp + "as Non_cash, "
		Set @strselect = @strselect + @strselecttemp

		--cash
		Set @strselecttemp = ''
		Set @strselecttemp = @strselecttemp + "round(sum(cash_deposit)/100000,2) "
		Set @strcompute = @strcompute + "sum(" + @strselecttemp + ")," 
		Set @strselecttemp = @strselecttemp + "as Cash_deposit, "
		Set @strselect = @strselect + @strselecttemp

		--tot_collateral_nb
		Set @strselecttemp = ''
		Set @strselecttemp = @strselecttemp + "round(sum(tot_collateral_nb)/100000,2) "
		Set @strcompute = @strcompute + "sum(" + @strselecttemp + ")," 
		Set @strselecttemp = @strselecttemp + "as Tot_collateral_nb, "
		Set @strselect = @strselect + @strselecttemp
		
		--debitacc
		Set @strselecttemp = ''
		Set @strselecttemp = @strselecttemp + "round(isnull(sum(debitvalueafterhaircut),0)/100000,2) "
		Set @strcompute = @strcompute + "sum(" + @strselecttemp + ")," 
		Set @strselecttemp = @strselecttemp + "as Debitacc, "
		Set @strselect = @strselect + @strselecttemp

		--poavalue
		Set @strselecttemp = ''
		Set @strselecttemp = @strselecttemp + "round(isnull(sum(poaafterhaircut),0)/100000,2) "
		Set @strcompute = @strcompute + "sum(" + @strselecttemp + ")," 
		Set @strselecttemp = @strselecttemp + "as Poavalue, "
		Set @strselect = @strselect + @strselecttemp

		--payin
		Set @strselecttemp = ''
		Set @strselecttemp = @strselecttemp + "round(isnull(sum(payinafterhaircut),0)/100000,2) "
		Set @strcompute = @strcompute + "sum(" + @strselecttemp + ")," 
		Set @strselecttemp = @strselecttemp + "as Payin, "
		Set @strselect = @strselect + @strselecttemp

		--credit_limit
		Set @strselecttemp = ''
		Set @strselecttemp = @strselecttemp + "round(sum(credit_limit)/100000,2) "
		Set @strcompute = @strcompute + "sum(" + @strselecttemp + ")," 
		Set @strselecttemp = @strselecttemp + "as Credit_limit, "
		Set @strselect = @strselect + @strselecttemp

		--nb_ledger_voc_bal
		Set @strselecttemp = ''
		Set @strselecttemp = @strselecttemp + "round(sum(nb_ledger_voc_bal)/100000,2) "
		Set @strcompute = @strcompute + "sum(" + @strselecttemp + ")," 
		Set @strselecttemp = @strselecttemp + "as Nb_ledger_voc_bal, "
		Set @strselect = @strselect + @strselecttemp

		--nb_ledger_eff_bal
		Set @strselecttemp = ''
		Set @strselecttemp = @strselecttemp + "round(sum(nb_ledger_eff_bal) /100000,2) "
		Set @strcompute = @strcompute + "sum(" + @strselecttemp + ")," 
		Set @strselecttemp = @strselecttemp + "as Nb_ledger_eff_bal, "
		Set @strselect = @strselect + @strselecttemp

		--nb_total_mtm
		Set @strselecttemp = ''
		Set @strselecttemp = @strselecttemp + "round(sum(nb_total_mtm)/100000,2) "
		Set @strcompute = @strcompute + "sum(" + @strselecttemp + ")," 
		Set @strselecttemp = @strselecttemp + "as Nb_total_mtm, "
		Set @strselect = @strselect + @strselecttemp

		--mtm_losses
		Set @strselecttemp = ''
		Set @strselecttemp = @strselecttemp + "round(sum(mtm_losses)/100000,2) "
		Set @strcompute = @strcompute + "sum(" + @strselecttemp + ")," 
		Set @strselecttemp = @strselecttemp + "as Mtm_losses, "
		Set @strselect = @strselect + @strselecttemp

		--avm
		Set @strselecttemp = ''
		Set @strselecttemp = @strselecttemp + "round(sum(avm)/100000,2) "
		Set @strcompute = @strcompute + "sum(" + @strselecttemp + ")," 
		Set @strselecttemp = @strselecttemp + "as Avm, "
		Set @strselect = @strselect + @strselecttemp

		--nb_day_purch
		Set @strselecttemp = ''
		Set @strselecttemp = @strselecttemp + "round(sum(nb_day_purch)/100000,2) "
		Set @strcompute = @strcompute + "sum(" + @strselecttemp + ")," 
		Set @strselecttemp = @strselecttemp + "as Nb_day_purch, "
		Set @strselect = @strselect + @strselecttemp

		--nb_day_sales
		Set @strselecttemp = ''
		Set @strselecttemp = @strselecttemp + "round(sum(nb_day_sales)/100000,2) "
		Set @strcompute = @strcompute + "sum(" + @strselecttemp + ")," 
		Set @strselecttemp = @strselecttemp + "as Nb_day_sales, "
		Set @strselect = @strselect + @strselecttemp

		--nb_upto_day_exp
		Set @strselecttemp = ''
		Set @strselecttemp = @strselecttemp + "round(sum(nb_upto_day_exp)/100000,2) "
		Set @strcompute = @strcompute + "sum(" + @strselecttemp + ")," 
		Set @strselecttemp = @strselecttemp + "as Nb_upto_day_exp, "
		Set @strselect = @strselect + @strselecttemp

		--nb_total_currentge
		Set @strselecttemp = ''
		Set @strselecttemp = @strselecttemp + "round(sum(nb_total_currentge)/100000,2) "
		Set @strcompute = @strcompute + "sum(" + @strselecttemp + ")," 
		Set @strselecttemp = @strselecttemp + "as Nb_total_currentge, "
		Set @strselect = @strselect + @strselecttemp

		--prive Ge New
		Set @strselecttemp = ''
		Set @strselecttemp = @strselecttemp + "round(sum(n_prev_ge+b_total_ge)/100000,2) "
		Set @strcompute = @strcompute + "sum(" + @strselecttemp + ")," 
		Set @strselecttemp = @strselecttemp + "as Prive_ge, "
		Set @strselect = @strselect + @strselecttemp

		--nb_excess_short
		Set @strselecttemp = ''
		Set @strselecttemp = @strselecttemp + "round(sum(nb_excess_short)/100000,2) "
		Set @strcompute = @strcompute + "sum(" + @strselecttemp + ")," 
		Set @strselecttemp = @strselecttemp + "as Nb_excess_short, "
		Set @strselect = @strselect + @strselecttemp

		--trdturn
		Set @strselecttemp = ''
		Set @strselecttemp = @strselecttemp + "round(sum(n_trdturnover+b_trdturnover)/100000,2) "
		Set @strcompute = @strcompute + "sum(" + @strselecttemp + ")," 
		Set @strselecttemp = @strselecttemp + "as Trdturn, "
		Set @strselect = @strselect + @strselecttemp

		--delturn
		Set @strselecttemp = ''
		Set @strselecttemp = @strselecttemp + "round(sum(n_delturnover+b_delturnover)/100000,2) "
		Set @strcompute = @strcompute + "sum(" + @strselecttemp + "), " 
		Set @strselecttemp = @strselecttemp + "as Delturn, "
		Set @strselect = @strselect + @strselecttemp
		
		--nb_turnover
		Set @strselecttemp = ''
		Set @strselecttemp = @strselecttemp + "round(sum(nb_turnover)/100000,2) "
		Set @strcompute = @strcompute + "sum(" + @strselecttemp + ")," 
		Set @strselecttemp = @strselecttemp + "as Nb_turnover, "
		Set @strselect = @strselect + @strselecttemp

		--nb_allowed
		Set @strselecttemp = ''
		Set @strselecttemp = @strselecttemp + "round(sum(nb_allowed)/100000,2) "
		Set @strcompute = @strcompute + "sum(" + @strselecttemp + ")," 
		Set @strselecttemp = @strselecttemp + "as Nb_allowed, "
		Set @strselect = @strselect + @strselecttemp
		Set @strselecttemp = ""

		--totalavgturnover
		Set @strselecttemp = ''
		Set @strselecttemp = @strselecttemp + "round(sum(totalavgturnover)/100000,2) "
		Set @strcompute = @strcompute + "sum(" + @strselecttemp + ")," 
		Set @strselecttemp = @strselecttemp + "as Totalavgturnover, "
		Set @strselect = @strselect + @strselecttemp

		--last 15 Days
		Set @strselecttemp = ''
		Set @strselecttemp = @strselecttemp + "round(sum(navgturnover15)/100000,2) "
		Set @strcompute = @strcompute + "sum(" + @strselecttemp + ")," 
		Set @strselecttemp = @strselecttemp + "as Last_15_days, "
		Set @strselect = @strselect + @strselecttemp

		--marginamt
		Set @strselecttemp = ''
		Set @strselecttemp = @strselecttemp + "round(sum(margamt)/100000,2) "
		Set @strcompute = @strcompute + "sum(" + @strselecttemp + ")," 
		Set @strselecttemp = @strselecttemp + "as Margamt, "
		Set @strselect = @strselect + @strselecttemp

		Set @strselecttemp = ''
		--set @strselecttemp = @strselecttemp + "sum(margper) "
		Set @strselecttemp = @strselecttemp + "round((case When Sum(debitvalueafterhaircut + Poaafterhaircut) > 0 "
		Set @strselecttemp = @strselecttemp + "          Then Sum( Nb_ledger_voc_bal + Debitvalueafterhaircut + Poaafterhaircut + Tot_collateral_nb ) * 100 / Sum(debitvalueafterhaircut + Poaafterhaircut) "
		Set @strselecttemp = @strselecttemp + "          Else 0 "
		Set @strselecttemp = @strselecttemp + "end),2) "
		Set @strcompute = @strcompute + "sum(" + @strselecttemp + ")," 
		Set @strselecttemp = @strselecttemp + "as Margper, "
		Set @strselect = @strselect + @strselecttemp

		Set @strselecttemp = ''
		Set @strselecttemp = @strselecttemp + "round(sum(netmarg)/100000,2) "
		Set @strcompute = @strcompute + "sum(" + @strselecttemp + ")," 
		Set @strselecttemp = @strselecttemp + "as Netmarg, "
		Set @strselect = @strselect + @strselecttemp

		Set @strselecttemp = ''
		--set @strselecttemp = @strselecttemp + "sum(netmargper) "
		Set @strselecttemp = @strselecttemp + "round((case When Sum(debitvalueafterhaircut + Poaafterhaircut + Payinafterhaircut) > 0 "
		Set @strselecttemp = @strselecttemp + "          Then Sum(nb_ledger_voc_bal + Debitvalueafterhaircut + Poaafterhaircut + Tot_collateral_nb - Payinafterhaircut)*100/sum(debitvalueafterhaircut + Poaafterhaircut + Payinafterhaircut) "
	             Set @strselecttemp = @strselecttemp + "          Else 0 "
	             Set @strselecttemp = @strselecttemp + "end),2) "
		Set @strcompute = @strcompute + "sum(" + @strselecttemp + ")," 
		Set @strselecttemp = @strselecttemp + "as Netmargper, "
		Set @strselect = @strselect + @strselecttemp

		Set @strselecttemp = ''
		Set @strselecttemp = @strselecttemp + "round(sum(stockn)/100000,2) "
		Set @strcompute = @strcompute + "sum(" + @strselecttemp + ")," 
		Set @strselecttemp = @strselecttemp + "as Stockn, "
		Set @strselect = @strselect + @strselecttemp

		Set @strselecttemp = ''
		Set @strselecttemp = @strselecttemp + "round(sum(stocky)/100000,2) "
		Set @strcompute = @strcompute + "sum(" + @strselecttemp + ")," 
		Set @strselecttemp = @strselecttemp + "as Stocky, "
		Set @strselect = @strselect + @strselecttemp

		Set @strselecttemp = ''
		Set @strselecttemp = @strselecttemp + "round(sum(nb_led_bill_bal)/100000,2) "
		Set @strcompute = @strcompute + "sum(" + @strselecttemp + "), " 
		Set @strselecttemp = @strselecttemp + "as Nb_led_bill_bal, "
		Set @strselect = @strselect + @strselecttemp

		Set @strselecttemp = ''
		Set @strselecttemp = @strselecttemp + "round(sum(poolnse)/100000,2) "
		Set @strcompute = @strcompute + "sum(" + @strselecttemp + ")," 
		Set @strselecttemp = @strselecttemp + "as Poolnse, "
		Set @strselect = @strselect + @strselecttemp

		Set @strselecttemp = ''
		Set @strselecttemp = @strselecttemp + "round(sum(poolbse)/100000,2) "
		Set @strcompute = @strcompute + "sum(" + @strselecttemp + "), " 
		Set @strselecttemp = @strselecttemp + "as Poolbse, "
		If ((@whatcode = 'broker') Or (@whatcode = 'client')) 
			Set @strselecttemp = @strselecttemp + " Category = Categorycode, "
		Else 
			Set @strselecttemp = @strselecttemp + " Category = '', "
		Set @strselect = @strselect + @strselecttemp

		Set @strselecttemp = ''
		Set @strselecttemp = @strselecttemp + "round((SUM(STOCKN*70/100) + SUM(STOCKY*50/100) + sum(nb_ledger_voc_bal) + sum(tot_collateral_nb) - sum(payinafterhaircut*130/100))/100000,2) "
		Set @strcompute = @strcompute + "sum(" + @strselecttemp + ") " 
		Set @strselecttemp = @strselecttemp + "as FreeMargin "
		Set @strselect = @strselect + @strselecttemp

		Set @strfrom = @strfrom + "from "
		Set @strfrom = @strfrom + "rmsallsegment "
	
		Set @strwhere = @strwhere + "where "	
		If (@fromcode = '' And @tocode = '')
		Begin
			Set @strwhere = @strwhere + @codeid + " Like '%' And "
		End
		Else
		Begin
			Set @strwhere = @strwhere + @codeid + " >= '" + @fromcode + "' And "
			Set @strwhere = @strwhere + @codeid + " <= '" + @tocode + "' And "
		End

		If (@fromdate = '' And @todate = '')
		Begin
			Set @strwhere = @strwhere + "sauda_date Like '%' And "
		End
		Else
		Begin
			Set @strwhere = @strwhere + "sauda_date >= '" + @fromdate + " 00:00:00' And "
			Set @strwhere = @strwhere + "sauda_date <= '" + @todate + " 23:59:59' And "
		End

		If ((@frompartycode <> '' And @topartycode <> ''))
		Begin
			Set @strwhere = @strwhere + "party_code >= '" + @frompartycode + "' And "
			Set @strwhere = @strwhere + "party_code <= '" + @topartycode + "' And "
		End
		
		/*login Conditions*/
		Set @strwhere = @strwhere + "branch_cd Like (case When '" + @statusid + "' = 'branch' Then '" + @statusname + "' Else '%' End) And "
		Set @strwhere = @strwhere + "sub_broker Like (case When '" + @statusid + "' = 'subbroker' Then '" + @statusname + "' Else '%' End) And "
		Set @strwhere = @strwhere + "trader Like (case When '" + @statusid + "' = 'trader' Then '" + @statusname + "' Else '%' End) And "
		Set @strwhere = @strwhere + "family Like (case When '" + @statusid + "' = 'family' Then '" + @statusname + "' Else '%' End) And "
		Set @strwhere = @strwhere + "region Like (case When '" + @statusid + "' = 'region' Then '" + @statusname + "' Else '%' End) And "
		Set @strwhere = @strwhere + "area Like (case When '" + @statusid + "' = 'area' Then '" + @statusname + "' Else '%' End) And "
		Set @strwhere = @strwhere + "party_code Like (case When '" + @statusid + "' = 'client' Then '" + @statusname + "' Else '%' End) And "
		/*end - Login Conditions*/
		Set @strwhere = @strwhere + " Categorycode Like '" + @categorycode + "'"

		Set @comma = ''

		Set @strgroupby = @strgroupby + @comma
		
		If ((@oneormany = 'detail') Or (@whatcode = 'broker') Or (@whatcode = 'client'))
		Begin
			If ((@whatcode = 'broker') Or (@whatcode = 'client')) Begin Set @strgroupby = @strgroupby + "party_code, Party_name,npercentscrip,npercent,bpercentscrip,bpercent,sales_person,cust_executive,categorycode " End
			If (@whatcode = 'branch') Begin Set @strgroupby = @strgroupby + "branch_cd,party_code, Party_name,npercentscrip,npercent,bpercentscrip,bpercent,sales_person,cust_executive " End
			If (@whatcode = 'subbroker') Begin Set @strgroupby = @strgroupby + "sub_broker,party_code, Party_name,npercentscrip,npercent,bpercentscrip,bpercent,sales_person,cust_executive " End
			If (@whatcode = 'trader') Begin Set @strgroupby = @strgroupby + "trader,party_code, Party_name,npercentscrip,npercent,bpercentscrip,bpercent,sales_person,cust_executive " End
			If (@whatcode = 'family') Begin Set @strgroupby = @strgroupby + "family,familyname,party_code, Party_name,npercentscrip,npercent,bpercentscrip,bpercent,sales_person,cust_executive " End
		End /*if (@oneormany = 'detail')*/
		Else /*if (@oneormany = 'detail')*/
		Begin /*else Of If (@oneormany = 'detail')*/
			If ((@whatcode = 'broker') Or (@whatcode = 'client')) Begin Set @strgroupby = @strgroupby + "party_code, Party_name,npercentscrip,npercent,bpercentscrip,bpercent,sales_person,cust_executive,categorycode " End
			If (@whatcode = 'branch') Begin Set @strgroupby = @strgroupby + "branch_cd " End
			If (@whatcode = 'subbroker') Begin Set @strgroupby = @strgroupby + "sub_broker " End
			If (@whatcode = 'trader') Begin Set @strgroupby = @strgroupby + "trader " End
			If (@whatcode = 'family') Begin Set @strgroupby = @strgroupby + "family,familyname " End
		End /*else Of If (@oneormany = 'detail')*/
		Set @strorderby = @strgroupby
		Set @strgroupby = "group By " + @strgroupby
		Set @strorderby = "order By " + @strorderby

	End/*if (@reportname = "saudasummary")*/

	Print 'reportname : ' + @reportname
	Print 'statusid : ' + @statusid
	Print 'statusname : ' + @statusname
	
	Print 'fromdate : ' + @fromdate
	Print 'todate : ' + @todate
	Print 'whatcode : ' + @whatcode
	Print 'fromcode : ' + @fromcode
	Print 'tocode : ' + @tocode	
	

	Print '=============================================================================================='

	If @strcomputesub <> '' 
	Begin 
		Set @strcomputesub = "by " + @strcomputesub 
		Set @strcomputesub = @strcompute + @strcomputesub
	End

	If (@issublevel = 'yes')
	Begin
		Exec (@strselect + @strfrom + @strwhere + @strgroupby + @strorderby + @strcomputesub + @strcompute)
	End
	Else
	Begin
		Exec (@strselect + @strfrom + @strwhere + @strgroupby + @strorderby + @strcompute)
	End

	Print @strselect + @strfrom + @strwhere + @strgroupby + @strorderby + @strcomputesub + @strcompute

	Print @strselect 
	Print @strfrom
	Print @strwhere
	Print @strgroupby
	Print @strorderby

	Print @strcomputesub
	Print @strcompute

GO
