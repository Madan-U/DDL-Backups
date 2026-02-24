-- Object: PROCEDURE dbo.proc_NSE_ins_sett
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE procedure    
proc_NSE_ins_sett    
(    
 @sett_type varchar(2),    
 @sett_no varchar(10),    
 @party_code varchar(10),    
 @scrip_cd varchar(10),    
 @series varchar(5),    
 @sell_buy varchar(1),    
 @order_no varchar(16),    
 @dummy1 money,    
 @membercode varchar(15),    
 @StatusName VarChar(50) = 'BROKER',  
 @FromWhere VarChar(50) = 'BROKER'    
)    
    
as    
    
if len(ltrim(rtrim(@scrip_cd))) = 0 set @scrip_cd = '%'    
if len(ltrim(rtrim(@series))) = 0 set @series = '%'    
    
declare    
 @orig_participantcode varchar(15),    
 @orig_sauda_date datetime,    
 @orig_sell_buy varchar(1),    
 @orig_contractno varchar(7),    
 @orig_order_no varchar(16),    
 @orig_trade_no varchar(14)    
    
/*GET THE ORIG DETAILS B4 UPDATION*/    
select    
 @orig_participantcode = upper(ltrim(rtrim(partipantcode))),    
 @orig_sauda_date = ltrim(rtrim(sauda_date)),    
 @orig_sell_buy = ltrim(rtrim(sell_buy)),    
/*    
 @orig_sell_buy = case    
       when    
        len(@sell_buy) = 0    
       then    
        ltrim(rtrim(sell_buy))    
       else    
        @sell_buy    
       end,    
*/    
 @orig_contractno = ltrim(rtrim(contractno)),    
 @orig_order_no = ltrim(rtrim(order_no)),    
/*    
 @orig_order_no = case    
       when    
        len(@order_no) = 0    
       then    
        ltrim(rtrim(order_no))    
       else    
        @order_no    
      end,    
*/    
 @orig_trade_no = ltrim(rtrim(trade_no))    
from    
 isettlement    
where    
 sett_type = @sett_type and    
 sett_no = @sett_no and    
 party_code = @party_code and    
 (scrip_cd like case when len(@scrip_cd) = 0 then '%' else @scrip_cd end) and    
 (series like case when len(@series) = 0 then '%' else @series end) and    
 (sell_buy like case when len(@sell_buy) = 0 then '%' else @sell_buy end) and    
 (contractno like case when len(@order_no) = 0 then '%' else @order_no end)    
    
insert into settlement    
 select    
  contractno, billno, trade_no, party_code, scrip_cd, user_id, tradeqty, auctionpart, markettype, series, order_no,    
  marketrate, sauda_date, table_no, line_no, val_perc, normal, day_puc, day_sales, sett_purch, sett_sales, sell_buy,    
  settflag, brokapplied, netrate, amount, ins_chrg, turn_tax, other_chrg, sebi_tax, broker_chrg, service_tax,    
  trade_amount, billflag, sett_no, nbrokapp, nsertax, n_netrate, sett_type,    
  partipantcode=@membercode,    
  status, pro_cli, cpid, instrument, booktype, branch_id, tmark, scheme,    
  dummy1,    
  dummy2=0    
 from    
  isettlement    
 where    
  sett_type = @sett_type and    
  sett_no = @sett_no and    
  party_code = @party_code and    
  (scrip_cd like case when len(@scrip_cd) = 0 then '%' else @scrip_cd end) and    
  (series like case when len(@series) = 0 then '%' else @series end) and    
  (sell_buy like case when len(@sell_buy) = 0 then '%' else @sell_buy end) and    
  (contractno like case when len(@order_no) = 0 then '%' else @order_no end)    
    
delete from isettlement    
where    
 sett_type = @sett_type and    
 sett_no = @sett_no and    
 party_code = @party_code and    
 (scrip_cd like case when len(@scrip_cd) = 0 then '%' else @scrip_cd end) and    
 (series like case when len(@series) = 0 then '%' else @series end) and    
 (sell_buy like case when len(@sell_buy) = 0 then '%' else @sell_buy end) and    
 (contractno like case when len(@order_no) = 0 then '%' else @order_no end)    
    
if @@error = 0    
begin    
 insert into inst_log values    
 (    
  ltrim(rtrim(@party_code)), /*party_code*/    
  ltrim(rtrim(@party_code)), /*new_party_code*/    
  convert(datetime, ltrim(rtrim(@orig_sauda_date))),  /*sauda_date*/    
  ltrim(rtrim(@sett_no)),  /*sett_no*/    
  ltrim(rtrim(@sett_type)),  /*sett_type*/    
  ltrim(rtrim(@scrip_cd)), /*scrip_cd*/    
  ltrim(rtrim(@series)), /*series*/    
  ltrim(rtrim(@orig_order_no)),  /*order_no*/    
  ltrim(rtrim(@orig_trade_no)),  /*trade_no*/    
  ltrim(rtrim(@orig_sell_buy)), /*sell_buy*/    
  ltrim(rtrim(@orig_contractno)), /*contract_no*/    
  ltrim(rtrim(@orig_contractno)), /*new_contract_no*/    
  0,  /*brokerage*/    
  0,  /*new_brokerage*/    
  0,  /*market_rate*/    
  0,  /*new_market_rate*/    
  0 ,  /*net_rate*/    
  0,  /*new_net_rate*/    
  0,  /*qty*/    
  0 ,  /*new_qty*/    
  ltrim(rtrim(@orig_participantcode)),  /*participant_code*/    
  ltrim(rtrim(@membercode)),  /*new_participant_code*/    
  ltrim(rtrim(@StatusName)),  /*username*/    
  ltrim((@FromWhere)),  /*module*/    
  'proc_NSE_ins_sett', /*called_from*/    
  getdate(), /*timestamp*/    
  ltrim(rtrim('')), /*extrafield3*/    
  ltrim(rtrim('')), /*extrafield4*/    
  ltrim(rtrim(''))  /*extrafield5*/    
 )    
end

GO
