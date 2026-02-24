-- Object: PROCEDURE dbo.proc_NSE_ins_trade_tradechanges
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


/****** Object:  Stored Procedure dbo.proc_NSE_ins_trade_tradechanges    Script Date: Nov 25 2004 13:31:47 ******/
CREATE procedure
	proc_NSE_ins_trade_tradechanges
	(
		@party_code varchar(10),
		@new_party_code varchar(10),
		@sauda_date varchar(11),
		@scrip_cd varchar(10),
		@participant_code varchar(15),
		@sell_buy varchar(1),
		@trade_no varchar(16),
		@new_quantity int,
 @StatusName VarChar(50) = 'BROKER',  
 @FromWhere VarChar(50) = 'BROKER' 
	)
as

/*line201 insert into trade select 't'+trade_no, order_no, status, scrip_cd, series, scripname, instrument, booktype, markettype, user_id, partipantcode, branch_id, sell_buy, tradeqty=tquantity, marketrate, pro_cli, party_code='tpartycode', auctionpart, a
uctionno, settno, sauda_date, trademodified, cpid, settflag, tmark, scheme, dummy1, dummy2 from trade where party_code='trim(partycode)' and trade_no='rs1(trade_no)' and left(convert(varchar, sauda_date, 109), 11) like 'trim(saudadate)%' and scrip_cd='tri
m(scripcd)' and partipantcode='trim(membercode)' and sell_buy='sellbuy'*/
/*line429 insert into trade select 't'+trade_no, order_no, status, scrip_cd, series, scripname, instrument, booktype, markettype, user_id, partipantcode, branch_id, sell_buy, tradeqty=tquantity, marketrate, pro_cli, party_code='tpartycode', auctionpart, a
uctionno, settno, sauda_date, trademodified, cpid, settflag, tmark, scheme, dummy1, dummy2 from trade where party_code='trim(partycode)' and trade_no='rs1(trade_no)' and left(convert(varchar, sauda_date, 109), 11) like 'trim(saudadate)%' and scrip_cd='tri
m(scripcd)' and partipantcode='trim(membercode)' and sell_buy='sellbuy'*/

insert into
	trade
		select
			'T'+trade_no, order_no, status, scrip_cd, series, scripname, instrument, booktype, markettype, user_id, partipantcode,
			branch_id, sell_buy,
			tradeqty=@new_quantity,
			marketrate, pro_cli,
			party_code=@new_party_code,
			auctionpart, auctionno, settno,
			sauda_date, trademodified, cpid, settflag, tmark, scheme, dummy1, dummy2
		from
			trade
		where
			ltrim(rtrim(party_code)) = @party_code and
			trade_no = @trade_no and
			sauda_date like @sauda_date + '%' and
			ltrim(rtrim(scrip_cd)) = @scrip_cd and
			ltrim(rtrim(partipantcode)) = @participant_code and
			sell_buy = @sell_buy

if @@error = 0
begin
	insert into inst_log values
	(
		ltrim(rtrim(@party_code)),	/*party_code*/
		ltrim(rtrim(@new_party_code)),	/*new_party_code*/
		convert(datetime, ltrim(rtrim(@sauda_date))),	 /*sauda_date*/
		ltrim(rtrim('')),	 /*sett_no*/
		ltrim(rtrim('')),	 /*sett_type*/
		ltrim(rtrim(@scrip_cd)),	/*scrip_cd*/
		ltrim(rtrim('NSE')),	/*series*/
		ltrim(rtrim('')),	 /*order_no*/
		ltrim(rtrim(@trade_no)),	 /*trade_no*/
		ltrim(rtrim(@sell_buy)),	/*sell_buy*/
		ltrim(rtrim('')),	/*contract_no*/
		ltrim(rtrim('')),	/*new_contract_no*/
		0,		/*brokerage*/
		0,		/*new_brokerage*/
		0,		/*market_rate*/
		0,		/*new_market_rate*/
		0,		/*net_rate*/
		0,		/*new_net_rate*/
		0,		/*qty*/
		@new_quantity,		/*new_qty*/
		ltrim(rtrim(@participant_code)),	 /*participant_code*/
		ltrim(rtrim(@participant_code)),	 /*new_participant_code*/
		ltrim(rtrim(@StatusName)),	 /*username*/
		ltrim((@FromWhere)),	 /*module*/
		'proc_NSE_ins_trade_tradechanges',	/*called_from*/
		getdate(),	/*timestamp*/
		ltrim(rtrim('')),	/*extrafield3*/
		ltrim(rtrim('')),	/*extrafield4*/
		ltrim(rtrim(''))	 /*extrafield5*/
	)
end

GO
