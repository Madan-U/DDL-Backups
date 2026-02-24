-- Object: PROCEDURE dbo.proc_NSE_upd_trade_qty_tradechanges
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


/****** Object:  Stored Procedure dbo.proc_NSE_upd_trade_qty_tradechanges    Script Date: Nov 25 2004 13:31:52 ******/  
CREATE procedure  
 proc_NSE_upd_trade_qty_tradechanges  
 (  
  @party_code varchar(10),  
  @sauda_date varchar(11),  
  @scrip_cd varchar(10),  
  @participant_code varchar(15),  
  @sell_buy varchar(1),  
  @trade_no  varchar(16),  
  @new_quantity int,  
 @StatusName VarChar(50) = 'BROKER',  
 @FromWhere VarChar(50) = 'BROKER'  
 )  
  
as  
  
/*line212 update trade set tradeqty =(cdbl(rs1(tradeqty))-cdbl(tquantity)) where party_code='trim(partycode)' and trade_no='rs1(trade_no)' and left(convert(varchar, sauda_date, 109), 11) like 'trim(saudadate)%' and scrip_cd='trim(scripcd)' and partipantco
de='trim(membercode)' and sell_buy='sellbuy'*/  
/*line440 update trade set tradeqty =(cdbl(rs1(tradeqty))-cdbl(tquantity)) where party_code='trim(partycode)' and trade_no='rs1(trade_no)' and left(convert(varchar, sauda_date, 109), 11) like 'trim(saudadate)%' and scrip_cd='trim(scripcd)' and partipantco
de='trim(membercode)' and sell_buy='sellbuy'*/  
  
declare  
 @orig_tradeqty int  
  
select  
 @orig_tradeqty = tradeqty  
from  
 trade  
where  
 party_code = @party_code and  
 trade_no = @trade_no and  
 sauda_date like @sauda_date + '%' and  
 scrip_cd = @scrip_cd and  
 partipantcode = @participant_code and  
 sell_buy= @sell_buy  
  
update  
 trade  
set  
 tradeqty = @new_quantity  
where  
 party_code = @party_code and  
 trade_no = @trade_no and  
 sauda_date like @sauda_date + '%' and  
 scrip_cd = @scrip_cd and  
 partipantcode = @participant_code and  
 sell_buy= @sell_buy  
  
if @@error = 0  
begin  
 insert into inst_log values  
 (  
  ltrim(rtrim(@party_code)), /*party_code*/  
  ltrim(rtrim(@party_code)), /*new_party_code*/  
  convert(datetime, ltrim(rtrim(@sauda_date))),  /*sauda_date*/  
  ltrim(rtrim('')),  /*sett_no*/  
  ltrim(rtrim('')),  /*sett_type*/  
  ltrim(rtrim(@scrip_cd)), /*scrip_cd*/  
  ltrim(rtrim('NSE')), /*series*/  
  ltrim(rtrim('')),  /*order_no*/  
  ltrim(rtrim(@trade_no)),  /*trade_no*/  
  ltrim(rtrim(@sell_buy)), /*sell_buy*/  
  ltrim(rtrim('')), /*contract_no*/  
  ltrim(rtrim('')), /*new_contract_no*/  
  0,  /*brokerage*/  
  0,  /*new_brokerage*/  
  0,  /*market_rate*/  
  0,  /*new_market_rate*/  
  0,  /*net_rate*/  
  0,  /*new_net_rate*/  
  @orig_tradeqty,  /*qty*/  
  @new_quantity,  /*new_qty*/  
  ltrim(rtrim(@participant_code)),  /*participant_code*/  
  ltrim(rtrim(@participant_code)),  /*new_participant_code*/  
  ltrim(rtrim(@StatusName)),  /*username*/  
  ltrim((@FromWhere)),  /*module*/  
  'proc_NSE_upd_trade_qty_tradechanges', /*called_from*/  
  getdate(), /*timestamp*/  
  ltrim(rtrim('')), /*extrafield3*/  
  ltrim(rtrim('')), /*extrafield4*/  
  ltrim(rtrim(''))  /*extrafield5*/  
 )  
end

GO
