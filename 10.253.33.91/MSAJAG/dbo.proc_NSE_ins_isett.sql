-- Object: PROCEDURE dbo.proc_NSE_ins_isett
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE procedure  
proc_NSE_ins_isett  
(  
 @sett_type varchar(2),  
 @sett_no varchar(10),  
 @party_code varchar(10),  
 @scrip_cd varchar(10),  
 @series varchar(5),  
 @sell_buy varchar(1),  
 @StatusName VarChar(50) = 'BROKER',  
 @FromWhere VarChar(50) = 'BROKER' 
)  
  
as  
  
if len(ltrim(rtrim(@scrip_cd))) = 0 set @scrip_cd = '%'  
if len(ltrim(rtrim(@series))) = 0 set @series = '%'  
if len(ltrim(rtrim(@sell_buy))) = 0 set @sell_buy = '%'  
  
insert into isettlement  
 select  
  contractno, billno, trade_no, party_code, scrip_cd, user_id, tradeqty, auctionpart, markettype, series, order_no, marketrate,  
  sauda_date, table_no, line_no, val_perc, normal, day_puc, day_sales, sett_purch, sett_sales, sell_buy, settflag, brokapplied, netrate,  
  amount, ins_chrg, turn_tax, other_chrg, sebi_tax, broker_chrg, service_tax, trade_amount, billflag, sett_no, nbrokapp, nsertax,  
  n_netrate, sett_type, partipantcode='INST', status, pro_cli, cpid, instrument, booktype, branch_id, tmark, scheme, dummy1, dummy2  
 from  
  settlement  
 where  
  sett_type = @sett_type and  
  sett_no = @sett_no and  
  party_code = @party_code and  
  scrip_cd like @scrip_cd and  
  series like @series and  
  sell_buy like @sell_buy  
  
delete from settlement  
where  
 sett_type = @sett_type and  
 sett_no = @sett_no and  
 party_code = @party_code and  
 scrip_cd like @scrip_cd and  
 series like @series and  
 sell_buy like @sell_buy  
  
if @@error = 0  
begin  
 insert into inst_log values  
 (  
  ltrim(rtrim(@party_code)), /*party_code*/  
  ltrim(rtrim(@party_code)), /*new_party_code*/  
  convert(datetime, ltrim(rtrim(''))),  /*sauda_date*/  
  ltrim(rtrim(@sett_no)),  /*sett_no*/  
  ltrim(rtrim(@sett_type)),  /*sett_type*/  
  ltrim(rtrim(@scrip_cd)), /*scrip_cd*/  
  ltrim(rtrim(@series)), /*series*/  
  ltrim(rtrim('')),  /*order_no*/  
  ltrim(rtrim('')),  /*trade_no*/  
  ltrim(rtrim(@sell_buy)), /*sell_buy*/  
  ltrim(rtrim('')), /*contract_no*/  
  ltrim(rtrim('')), /*new_contract_no*/  
  0,  /*brokerage*/  
  0,  /*new_brokerage*/  
  0,  /*market_rate*/  
  0,  /*new_market_rate*/  
  0,  /*net_rate*/  
  0,  /*new_net_rate*/  
  0,  /*qty*/  
  0,  /*new_qty*/  
  ltrim(rtrim('')),  /*participant_code*/  
  ltrim(rtrim('')),  /*new_participant_code*/  
  ltrim(rtrim(@StatusName)),  /*username*/  
  ltrim((@FromWhere)),  /*module*/  
  'proc_NSE_ins_isett', /*called_from*/  
  getdate(), /*timestamp*/  
  ltrim(rtrim('')), /*extrafield3*/  
  ltrim(rtrim('')), /*extrafield4*/  
  ltrim(rtrim(''))  /*extrafield5*/  
 )  
end

GO
