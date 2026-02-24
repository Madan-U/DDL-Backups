-- Object: PROCEDURE dbo.proc_NSE_upd_trade_tradechanges
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE proc
proc_NSE_upd_trade_tradechanges
(
	@newpartycode varchar(10),
	@party_code varchar(10),
	@sauda_date varchar(11),
	@scrip_cd varchar(10),
	@participantcode varchar(15),
 @StatusName VarChar(50) = 'BROKER',  
 @FromWhere VarChar(50) = 'BROKER' 
)

as

set @newpartycode = ltrim(rtrim(@newpartycode))
set @party_code = ltrim(rtrim(@party_code))
set @sauda_date = ltrim(rtrim(@sauda_date))
set @scrip_cd = ltrim(rtrim(@scrip_cd))
set @participantcode = ltrim(rtrim(@participantcode))

declare @origpartycode varchar(10)

select
	@origpartycode=upper(ltrim(rtrim(party_code)))
from
	trade
where
	party_code = @party_code and
	sauda_date like @sauda_date + '%' and
	scrip_cd = @scrip_cd and
	partipantcode = @participantcode

update
	trade
set
	party_code = @newpartycode
where
	party_code = @party_code and
	sauda_date like @sauda_date + '%' and
	scrip_cd = @scrip_cd and
	partipantcode = @participantcode


if @@error = 0
begin
	insert into inst_log values
	(
		ltrim(rtrim(@origpartycode)),	/*party_code*/
		ltrim(rtrim(@newpartycode)),	/*new_party_code*/
		convert(datetime, ltrim(rtrim(@sauda_date))),	 /*sauda_date*/
		ltrim(rtrim('')),	 /*sett_no*/
		ltrim(rtrim('')),	 /*sett_type*/
		ltrim(rtrim(@scrip_cd)),	/*scrip_cd*/
		'NSE',	/*series*/
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
		ltrim(rtrim(@participantcode)),	 /*participant_code*/
		ltrim(rtrim(@participantcode)),	 /*new_participant_code*/
		ltrim(rtrim(@StatusName)),	 /*username*/
		ltrim((@FromWhere)),	 /*module*/
		'proc_NSE_upd_trade_tradechanges',	/*called_from*/
		getdate(),	/*timestamp*/
		ltrim(rtrim('')),	/*extrafield3*/
		ltrim(rtrim('')),	/*extrafield4*/
		ltrim(rtrim(''))	 /*extrafield5*/
	)
end

GO
