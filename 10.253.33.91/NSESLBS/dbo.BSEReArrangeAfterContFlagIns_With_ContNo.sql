-- Object: PROCEDURE dbo.BSEReArrangeAfterContFlagIns_With_ContNo
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE procedure  
[dbo].[BSEReArrangeAfterContFlagIns_With_ContNo]  
(  
 @Sett_Type varchar(2),  
 @Party_code Varchar(10),  
 @Scrip_cd varchar(12),  
 @Series varchar(3),  
 @TDate Varchar(11),  
 @TMark varchar(2),  
 @Participantcode varchar(15),  
 @ContractNo varchar(7),  
 @StatusName VarChar(50),  
 @FromWhere VarChar(50)  
)  
  
as  
 Update ISettlement Set Settflag = (CASE WHEN SELL_BUY = 1 THEN 4 ELSE 5 END)   
 WHERE SETT_TYPE = @SETT_TYPE  
 AND SAUDA_DATE LIKE @TDate + '%'  
 AND PARTY_CODE LIKE @PARTY_CODE  
 AND SCRIP_CD LIKE @Scrip_cd  
 AND SERIES LIKE @Series  
 AND PARTIPANTCODE LIKE @Participantcode  
 AND CONTRACTNO = @ContractNo   
  
if @@error = 0  
begin  
 insert into inst_log values  
 (  
  ltrim(rtrim(@Party_code)), /*party_code*/  
  ltrim(rtrim(@Party_code)), /*new_party_code*/  
  convert(datetime, ltrim(rtrim(@TDate))),  /*sauda_date*/  
  ltrim(rtrim('')),  /*sett_no*/  
  ltrim(rtrim(@Sett_Type)),  /*sett_type*/  
  ltrim(rtrim(@Scrip_cd)), /*scrip_cd*/  
  ltrim(rtrim(@Series)), /*series*/  
  ltrim(rtrim('')),  /*order_no*/  
  ltrim(rtrim('')),  /*trade_no*/  
  ltrim(rtrim('')), /*sell_buy*/  
  ltrim(rtrim(@ContractNo)), /*contract_no*/  
  ltrim(rtrim(@ContractNo)), /*new_contract_no*/  
  0,  /*brokerage*/  
  0,  /*new_brokerage*/  
  0,  /*market_rate*/  
  0,  /*new_market_rate*/  
  0,  /*net_rate*/  
  0,  /*new_net_rate*/  
  0,  /*qty*/  
  0,  /*new_qty*/  
  ltrim(rtrim(@Participantcode)),  /*participant_code*/  
  ltrim(rtrim(@Participantcode)),  /*new_participant_code*/  
  ltrim(rtrim(@StatusName)),  /*username*/  
  ltrim((@FromWhere)),  /*module*/  
  'BSEReArrangeAfterContFlagIns_With_ContNo', /*called_from*/  
  getdate(), /*timestamp*/  
  ltrim(rtrim('')), /*extrafield3*/  
  ltrim(rtrim('')), /*extrafield4*/  
  ltrim(rtrim(''))  /*extrafield5*/  
 )  
end

GO
