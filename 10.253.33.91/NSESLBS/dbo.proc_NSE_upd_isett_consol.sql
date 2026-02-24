-- Object: PROCEDURE dbo.proc_NSE_upd_isett_consol
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

 CREATE procedure    
 proc_NSE_upd_isett_consol    
 (    
  @party_code varchar(10),    
  @sett_type varchar(5),    
  @sett_no varchar(10),    
  @scrip_cd varchar(10),    
  @sell_buy varchar(1),    
  @participant_code varchar(15),    
  @order_no varchar(16),    
  @new_market_rate money,    
  @new_contract_no varchar(15),
  @Sauda_Date Varchar(11),    
  @StatusName VarChar(50) = 'BROKER',    
  @FromWhere VarChar(50) = 'BROKER'   
 )

as    
    
set @new_contract_no = ltrim(rtrim(@new_contract_no))    
    
declare    
 @orig_market_rate money,    
 @orig_dummy2 varchar(15),    
 @orig_contract_no varchar(7)    
    
/*GET THE ORIG DETAILS B4 UPDATION*/    
select    
 @orig_market_rate = marketrate,    
 @orig_dummy2 = dummy2,    
 @orig_contract_no = contractno    
from    
 isettlement    
where    
  sett_type = @sett_type and    
  party_code = @party_code and    
  sett_no = @sett_no and    
  scrip_cd = @scrip_cd and    
  sell_buy = @sell_buy and    
  (order_no like case when len(@order_no) = 0 then '%' else @order_no end) and    
  (partipantcode like case when len(@participant_code) = 0 then '%' else @participant_code end)    
  and Sauda_Date Like @Sauda_Date + '%'
if len(@new_contract_no) = 0  /*contractno NOT TO BE UPDATED*/    
begin    
 update    
  isettlement    
 set    
  marketrate=@new_market_rate,    
  dummy2=1    
 where    
  sett_type = @sett_type and    
  party_code = @party_code and    
  sett_no = @sett_no and    
  scrip_cd = @scrip_cd and    
  sell_buy = @sell_buy and    
  (order_no like case when len(@order_no) = 0 then '%' else @order_no end) and    
  (partipantcode like case when len(@participant_code) = 0 then '%' else @participant_code end)    
and Sauda_Date Like @Sauda_Date + '%'
end    
else  /*if len(@new_contract_no) = 0*/    
begin    
 update    
  isettlement    
 set    
  marketrate=@new_market_rate,    
  contractno=@new_contract_no,    
  dummy2=1    
 where    
  sett_type = @sett_type and    
  party_code = @party_code and    
  sett_no = @sett_no and    
  scrip_cd = @scrip_cd and    
  sell_buy = @sell_buy and    
  (order_no like case when len(@order_no) = 0 then '%' else @order_no end) and    
  (partipantcode like case when len(@participant_code) = 0 then '%' else @participant_code end)    
and Sauda_Date Like @Sauda_Date + '%'
end  /*if len(@new_contract_no) = 0*/    
    
    
if @@error = 0    
begin    
    
 if len(@new_contract_no) = 0 set @new_contract_no = @orig_contract_no /*FOR THE LOG, SO @new_contract_no WONT GO BLANK*/    
    
 insert into inst_log values    
 (    
  ltrim(rtrim(@party_code)), /*party_code*/    
  ltrim(rtrim(@party_code)), /*new_party_code*/    
  convert(datetime, ltrim(rtrim(@Sauda_Date))),  /*sauda_date*/    
  ltrim(rtrim(@sett_no)),  /*sett_no*/    
  ltrim(rtrim(@sett_type)),  /*sett_type*/    
  ltrim(rtrim(@scrip_cd)), /*scrip_cd*/    
  ltrim(rtrim('NSE')), /*series*/    
  ltrim(rtrim(@order_no)),  /*order_no*/    
  ltrim(rtrim('')),  /*trade_no*/    
  ltrim(rtrim(@sell_buy)), /*sell_buy*/    
  ltrim(rtrim(@orig_contract_no)), /*contract_no*/    
  ltrim(rtrim(@new_contract_no)), /*new_contract_no*/    
  0,  /*brokerage*/    
  0,  /*new_brokerage*/    
  @orig_market_rate,  /*market_rate*/    
  @new_market_rate,  /*new_market_rate*/    
  0,  /*net_rate*/    
  0,  /*new_net_rate*/    
  0,  /*qty*/    
  0,  /*new_qty*/    
  ltrim(rtrim(@participant_code)),  /*participant_code*/    
  ltrim(rtrim(@participant_code)),  /*new_participant_code*/    
  ltrim(rtrim(@StatusName)),  /*username*/    
  ltrim((@FromWhere)),  /*module*/    
  'proc_NSE_upd_isett_consol', /*called_from*/    
  getdate(), /*timestamp*/    
  ltrim(rtrim('')), /*extrafield3*/    
  ltrim(rtrim('')), /*extrafield4*/    
  ltrim(rtrim(''))  /*extrafield5*/    
 )    
    
    
end

GO
