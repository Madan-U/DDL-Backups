-- Object: PROCEDURE dbo.proc_NSE_upd_isett_rej
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE procedure    
proc_NSE_upd_isett_rej    
(    
 @newparticipantcode varchar(15),    
 @origparticipantcode varchar(15),    
 @sett_type varchar(2),    
 @sett_no varchar(10),    
 @party_code varchar(10),    
 /*sauda_date COMES WHEN THIS proc IS CALLED FROM 'next.asp*/    
 @sauda_date varchar(11),    
 /*scrip_cd, series, sell_buy and contractno COME WHEN THIS proc IS CALLED FROM 'regnext3.asp'*/    
 @scrip_cd varchar(10),    
 @series varchar(5),    
 @sell_buy varchar(1),    
 @contractno varchar(7),    
 @StatusName VarChar(50)='BROKER',    
 @FromWhere VarChar(50)=''
)    
    
as    
    
set @newparticipantcode = ltrim(rtrim(@newparticipantcode))    
set @sett_type = ltrim(rtrim(@sett_type))    
set @sett_no = ltrim(rtrim(@sett_no))    
set @party_code = ltrim(rtrim(@party_code))    
set @sauda_date = ltrim(rtrim(@sauda_date))    
set @scrip_cd = ltrim(rtrim(@scrip_cd))    
set @series = ltrim(rtrim(@series))    
set @sell_buy = ltrim(rtrim(@sell_buy))    
set @contractno = ltrim(rtrim(@contractno))    
    
Insert into inst_log
Select Distinct Party_Code, Party_Code, @Sauda_Date, @sett_no, @Sett_Type, @scrip_cd, @Series, 
Order_No, '', Sell_Buy, ContractNo, ContractNo, 
  0,  /*brokerage*/    
  0,  /*new_brokerage*/    
  0,  /*market_rate*/    
  0,  /*new_market_rate*/    
  0,  /*net_rate*/    
  0,  /*new_net_rate*/    
  0,  /*qty*/    
  0,  /*new_qty*/  
PartiPantCode, @newparticipantcode,
  ltrim(rtrim(@StatusName)),  /*username*/    
  ltrim((@FromWhere)),  /*module*/    
  'proc_NSE_upd_isett_rej', /*called_from*/    
  getdate(), /*timestamp*/    
  ltrim(rtrim('')), /*extrafield3*/    
  ltrim(rtrim('')), /*extrafield4*/    
  ltrim(rtrim(''))  /*extrafield5*/  
from    
 isettlement    
where    
 party_code=@party_code and    
 sett_no=@sett_no and    
 sett_type=@sett_type and    
 ltrim(rtrim(partipantcode)) = @origparticipantcode and    
 (sauda_date like case when len(@sauda_date) = 0 then '%' else @sauda_date + '%' end) and    
 (scrip_cd like case when len(@scrip_cd) = 0 then '%' else @scrip_cd end) and    
 (series like case when len(@series) = 0 then '%' else @series end) and    
 (sell_buy like case when len(@sell_buy) = 0 then '%' else @sell_buy end) and    
 (contractno like case when len(@contractno) = 0 then '%' else @contractno end)    
    
update    
 isettlement    
set    
 partipantcode=@newparticipantcode    
where    
 party_code=@party_code and    
 sett_no=@sett_no and    
 sett_type=@sett_type and    
 (sauda_date like case when len(@sauda_date) = 0 then '%' else @sauda_date + '%' end) and    
 (scrip_cd like case when len(@scrip_cd) = 0 then '%' else @scrip_cd end) and    
 (series like case when len(@series) = 0 then '%' else @series end) and    
 (sell_buy like case when len(@sell_buy) = 0 then '%' else @sell_buy end) and    
 (contractno like case when len(@contractno) = 0 then '%' else @contractno end)

GO
