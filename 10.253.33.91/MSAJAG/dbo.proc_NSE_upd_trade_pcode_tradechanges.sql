-- Object: PROCEDURE dbo.proc_NSE_upd_trade_pcode_tradechanges
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.proc_NSE_upd_trade_pcode_tradechanges    Script Date: Nov 25 2004 13:31:51 ******/  
CREATE procedure  
 proc_NSE_upd_trade_pcode_tradechanges  
 (  
  @party_code varchar(10),  
  @new_party_code varchar(10),  
  @sauda_date varchar(11),  
  @scrip_cd varchar(10),  
  @participant_code varchar(15),  
  @sell_buy varchar(1),  
  @trade_no varchar(16),  
 @StatusName VarChar(50) = 'BROKER',  
 @FromWhere VarChar(50) = 'BROKER'  
 )  
  
as  
  
/*line422 update trade set party_code ='tpartycode' where party_code='trim(partycode)' and left(convert(varchar, sauda_date, 109), 11) like 'trim(saudadate)%' and scrip_cd='trim(scripcd)' and partipantcode='trim(membercode)' and sell_buy='sellbuy' and tra
de_no='rs1(trade_no)'*/  
/*line194 update trade set party_code ='tpartycode' where party_code='trim(partycode)' and left(convert(varchar, sauda_date, 109), 11) like 'trim(saudadate)%' and scrip_cd='trim(scripcd)' and partipantcode='trim(membercode)' and sell_buy='sellbuy' and tra
de_no='rs1(trade_no)'*/  
/*line405 update trade set party_code ='tpartycode' where party_code='trim(partycode)' and left(convert(varchar, sauda_date, 109), 11) like 'trim(saudadate)%' and scrip_cd='trim(scripcd)' and partipantcode='trim(membercode)' and sell_buy='sellbuy'*/  
/*line177 update trade set party_code ='tpartycode' where party_code='trim(partycode)' and left(convert(varchar, sauda_date, 109), 11) like 'trim(saudadate)%' and scrip_cd='trim(scripcd)' and partipantcode='trim(membercode)' and sell_buy='sellbuy'*/  
  
update  
 trade  
set  
 party_code = @new_party_code  
where  
 party_code = @party_code and  
 sauda_date like @sauda_date + '%' and  
 scrip_cd = @scrip_cd and  
 partipantcode = @participant_code and  
 sell_buy = @sell_buy and  
 trade_no like  
  case  
   when  
    len(ltrim(rtrim(@trade_no))) = 0  
   then  
    '%'  
   else  
    @trade_no  
   end  
  
if @@error = 0  
begin  
 insert into inst_log values  
 (  
  ltrim(rtrim(@party_code)), /*party_code*/  
  ltrim(rtrim(@new_party_code)), /*new_party_code*/  
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
  0,  /*qty*/  
  0,  /*new_qty*/  
  ltrim(rtrim(@participant_code)),  /*participant_code*/  
  ltrim(rtrim(@participant_code)),  /*new_participant_code*/  
  ltrim(rtrim(@StatusName)),  /*username*/  
  ltrim((@FromWhere)),  /*module*/  
  'proc_NSE_upd_trade_pcode_tradechanges', /*called_from*/  
  getdate(), /*timestamp*/  
  ltrim(rtrim('')), /*extrafield3*/  
  ltrim(rtrim('')), /*extrafield4*/  
  ltrim(rtrim(''))  /*extrafield5*/  
 )  
end

GO
