-- Object: PROCEDURE dbo.CBO_ReportCPCodeChangesDetails
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



CREATE
proc




	[dbo].[CBO_ReportCPCodeChangesDetails]
	(
		@fortheday varchar(11),
		@statusid varchar(20)='Broker',
		@statusname varchar(50)='Broker'
	)

as
SET @fortheday=convert(varchar(12), convert(smalldatetime, @fortheday, 103), 109)


IF @STATUSID <> 'BROKER'
	BEGIN
		RAISERROR ('This Procedure is accessible to Broker', 16, 1)
		RETURN
	END

set @statusid = ltrim(rtrim(@statusid))
set @statusname = ltrim(rtrim(@statusname))

if (len(@statusid) > 0) and (len(@statusname) > 0)
begin
	/*
		FROM ISETTLEMENT - FOR GETTING RECS WHOSE CP CODE IS CHANGED MANUALLY
		THESE DONT GO INTO SETTLEMENT, ONLY THE CP CODE IS CHANGED
	*/
	select distinct
		20 as rec_type,
		ltrim(rtrim(il.new_participant_code)) as participant_code,
		'' as warehouse_code,
		case
			when
				ltrim(rtrim(t.sell_buy)) = 1
			then
				'B'
			else
				'S'
			end
		as sell_buy,
				'' as trade_no,
				ltrim(rtrim(t.order_no)) as order_no
	from
		Rpt_View_Cp_Code_Changes il, isettlement t
	where
		left(convert(varchar, ltrim(rtrim(il.sauda_date)), 109), 11) = left(convert(varchar, ltrim(rtrim(t.sauda_date)), 109), 11) and
		ltrim(rtrim(il.sett_no)) = ltrim(rtrim(t.sett_no)) and
		ltrim(rtrim(il.sett_type)) = ltrim(rtrim(t.sett_type)) and
		ltrim(rtrim(il.party_code)) = ltrim(rtrim(t.party_code)) and
		t.sauda_date like @fortheday + '%' and
		lower(ltrim(rtrim(il.participant_code))) <> lower(ltrim(rtrim(il.new_participant_code))) and
		T.Order_No = il.Order_No 
union
	/*
		FROM SETTLEMENT - FOR GETTING RECS WHOSE TRADES HAVE BEEN REJECTED, RESULTIN IN A CP CODE CHANGE
		AS PART OF THE REJECTION PROCESS
	*/
	select distinct
		20 as rec_type,
		ltrim(rtrim(il.new_participant_code)) as participant_code,
		'' as warehouse_code,
		case
			when
				ltrim(rtrim(t.sell_buy)) = 1
			then
				'B'
			else
				'S'
			end
		as sell_buy,
				'' as trade_no,
/*				ltrim(rtrim(t.trade_no)) as trade_no,*/
				ltrim(rtrim(t.order_no)) as order_no
	from
		Rpt_View_Cp_Code_Changes il, settlement t
	where
		left(convert(varchar, ltrim(rtrim(il.sauda_date)), 109), 11) = left(convert(varchar, ltrim(rtrim(t.sauda_date)), 109), 11) and
		ltrim(rtrim(il.sett_no)) = ltrim(rtrim(t.sett_no)) and
		ltrim(rtrim(il.sett_type)) = ltrim(rtrim(t.sett_type)) and
		ltrim(rtrim(il.party_code)) = ltrim(rtrim(t.party_code)) and
		t.sauda_date like @fortheday + '%' and
		lower(ltrim(rtrim(il.participant_code))) <> lower(ltrim(rtrim(il.new_participant_code))) and
		T.Order_No = il.Order_No 
	order by
		participant_code,
		sell_buy,
		order_no,
		trade_no
end		/*if (len(@statusid) > 0) and (len(@statusname) > 0)*/

else		/*if (len(@statusid) > 0) and (len(@statusname) > 0)*/
begin
	select 'invalid login'
end		/*if (len(@statusid) > 0) and (len(@statusname) > 0)*/

GO
