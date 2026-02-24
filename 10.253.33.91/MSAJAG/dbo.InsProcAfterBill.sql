-- Object: PROCEDURE dbo.InsProcAfterBill
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE procedure
	InsProcAfterBill
	(
		@settno  varchar (7) ,
		@sett_type char(3),
		@Party_code Varchar(10),
		@Scrip_cd Varchar(12),
		@StatusName VarChar(50),
		@FromWhere VarChar(50)
	)

as

Exec DelpositionUp  @settno,@sett_type,@Party_code,@Scrip_cd
delete from deliveryclt where sett_no = @settno and sett_Type =  @sett_type and Party_code = @Party_code and Scrip_cd = @Scrip_cd
INSERT INTO DELIVERYCLT
select  sett_no ,sett_type , scrip_cd , series , party_code,abs(sum(pqty)-sum(sqty)) 'tradeqty',
inout = (case when (sum(pqty)-sum(sqty)) > 0
	      then 'O'
	      when (sum(pqty)-sum(sqty)) < 0
	      then 'I'
	      else 'N'
    	 end), 'HO' ,PartiPantCode
from delpos where sett_no = @settno and sett_Type =  @sett_type
and Delpos.party_code = @Party_code
And DelPos.Scrip_cd = @Scrip_cd
Group By sett_no ,sett_type , scrip_cd , series , party_code,PartiPantCode
Having Sum(PQty) <> Sum(SQty)

if @@error = 0
begin
	insert into inst_log values
	(
		ltrim(rtrim(@Party_code)),	/*party_code*/
		ltrim(rtrim(@Party_code)),	/*new_party_code*/
		convert(datetime, ltrim(rtrim(''))),	 /*sauda_date*/
		ltrim(rtrim(@settno)),	 /*sett_no*/
		ltrim(rtrim(@sett_type)),	 /*sett_type*/
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
		'InsProcAfterBill',	/*called_from*/
		getdate(),	/*timestamp*/
		ltrim(rtrim('')),	/*extrafield3*/
		ltrim(rtrim('')),	/*extrafield4*/
		ltrim(rtrim(''))	 /*extrafield5*/
	)
end

GO
