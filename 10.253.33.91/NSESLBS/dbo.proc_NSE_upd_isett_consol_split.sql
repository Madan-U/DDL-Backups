-- Object: PROCEDURE dbo.proc_NSE_upd_isett_consol_split
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


/****** Object:  Stored Procedure dbo.proc_NSE_upd_isett_consol_split    Script Date: Nov 25 2004 13:31:49 ******/  
CREATE procedure  
proc_NSE_upd_isett_consol_split  
(  
 @new_party_code varchar(10),  
 @new_contract_no varchar(7),  
 @sett_type varchar(2),  
 @party_code varchar(10),  
 @sauda_date varchar(11),  
 @scrip_cd varchar(10),  
 @series varchar(5),  
 @sell_buy varchar(2),  
 @participant_code varchar(15),  
 @contract_no varchar(7),  
 @order_no varchar(16),  
 @StatusName VarChar(50) = 'BROKER',  
 @FromWhere VarChar(50) = 'BROKER'  
)  
  
as  
  
set @sett_type = ltrim(rtrim(@sett_type))  
set @party_code = ltrim(rtrim(@party_code))  
set @sauda_date = ltrim(rtrim(@sauda_date))  
set @scrip_cd = ltrim(rtrim(@scrip_cd))  
set @series = ltrim(rtrim(@series))  
set @sell_buy = ltrim(rtrim(@sell_buy))  
set @participant_code = ltrim(rtrim(@participant_code))  
set @contract_no = ltrim(rtrim(@contract_no))  
set @order_no = ltrim(rtrim(@order_no))  
  
if len(@new_contract_no) = 0  /*contractno NOT TO BE UPDATED*/  
begin  
 update  
  isettlement  
 set  
  party_code = @new_party_code  
 where  
  party_code=@party_code and  
  scrip_cd=@scrip_cd and  
  order_no=@order_no and  
  contractno=@contract_no and  
  (sett_type like case when len(@sett_type) = 0 then '%' else @sett_type end) and  
  (sauda_date like case when len(@sauda_date) = 0 then '%' else @sauda_date end) and  
  (series like case when len(@series) = 0 then '%' else @series end) and  
  (sell_buy like case when len(@sell_buy) = 0 then '%' else @sell_buy end) and  
  (partipantcode like case when len(@participant_code) = 0 then '%' else @participant_code end)  
end  
else  /*if len(@new_contract_no) = 0*/  
begin  
 update  
  isettlement  
 set  
  contractno = @new_contract_no  
 where  
  party_code=@party_code and  
  scrip_cd=@scrip_cd and  
  order_no=@order_no and  
  contractno=@contract_no and  
  (sett_type like case when len(@sett_type) = 0 then '%' else @sett_type end) and  
  (sauda_date like case when len(@sauda_date) = 0 then '%' else @sauda_date end) and  
  (series like case when len(@series) = 0 then '%' else @series end) and  
  (sell_buy like case when len(@sell_buy) = 0 then '%' else @sell_buy end) and  
  (partipantcode like case when len(@participant_code) = 0 then '%' else @participant_code end)  
end  
  
if @@error = 0  
begin  
  
 if len(@new_contract_no) = 0 set @new_contract_no = @contract_no  /*FOR THE LOG, SO @new_contract_no WONT GO BLANK*/  
 if len(@new_party_code) = 0 set @new_party_code = @party_code  /*FOR THE LOG, SO @new_contract_no WONT GO BLANK*/  
  
 insert into inst_log values  
 (  
  ltrim(rtrim(@party_code)), /*party_code*/  
  ltrim(rtrim(@new_party_code)), /*new_party_code*/  
  convert(datetime, ltrim(rtrim(@sauda_date))),  /*sauda_date*/  
  ltrim(rtrim('')),  /*sett_no*/  
  ltrim(rtrim(@sett_type)),  /*sett_type*/  
  ltrim(rtrim(@scrip_cd)), /*scrip_cd*/  
  ltrim(rtrim(@series)), /*series*/  
  ltrim(rtrim(@order_no)),  /*order_no*/  
  ltrim(rtrim('')),  /*trade_no*/  
  ltrim(rtrim(@sell_buy)), /*sell_buy*/  
  ltrim(rtrim(@contract_no)), /*contract_no*/  
  ltrim(rtrim(@new_contract_no)), /*new_contract_no*/  
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
  'proc_NSE_upd_isett_consol_split', /*called_from*/  
  getdate(), /*timestamp*/  
  ltrim(rtrim('')), /*extrafield3*/  
  ltrim(rtrim('')), /*extrafield4*/  
  ltrim(rtrim(''))  /*extrafield5*/  
 )  
end

GO
