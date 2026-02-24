-- Object: PROCEDURE dbo.DelProcAfterBill
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE procedure
	DelProcAfterBill
	(
		@sett_no varchar(7),
		@sett_Type Varchar(3),
		@Scrip_cd Varchar(12),
		@StatusName VarChar(50),
		@FromWhere VarChar(50)
	)

as

delete from delnet where sett_no = @sett_no and sett_Type =  @sett_type and Scrip_cd = @Scrip_cd
insert into delnet
select  sett_no ,sett_type , scrip_cd , series,abs(sum(pqty)-sum(sqty)) 'tradeqty',inout = case
  when (sum(pqty)-sum(sqty)) > 0
  then
  'O'
    when (sum(pqty)-sum(sqty))< 0
     then
  'I'
    end
from DelPos  where sett_no = @sett_no and sett_type = @sett_Type
and  Scrip_cd = @Scrip_cd
Group By sett_no ,sett_type , scrip_cd , series
having abs(sum(pqty)-sum(sqty)) > 0

if @@error = 0
begin
	insert into inst_log values
	(
		ltrim(rtrim('')),	/*party_code*/
		ltrim(rtrim('')),	/*new_party_code*/
		convert(datetime, ltrim(rtrim(''))),	 /*sauda_date*/
		ltrim(rtrim(@sett_no)),	 /*sett_no*/
		ltrim(rtrim(@sett_Type)),	 /*sett_type*/
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
		'DelProcAfterBill',	/*called_from*/
		getdate(),	/*timestamp*/
		ltrim(rtrim('')),	/*extrafield3*/
		ltrim(rtrim('')),	/*extrafield4*/
		ltrim(rtrim(''))	 /*extrafield5*/
	)
end

GO
