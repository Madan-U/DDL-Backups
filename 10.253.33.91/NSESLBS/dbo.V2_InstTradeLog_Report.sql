-- Object: PROCEDURE dbo.V2_InstTradeLog_Report
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

-- Exec   V2_InstTradeLog_Report 'Feb 13 2006','Feb 13 2008 23:59:59','','zzzzzz','','ZZZZZZZZ','','99999999',1
  
CREATE Proc V2_InstTradeLog_Report      
(  
        @SAUDA_DATEFROM VARCHAR(11),  
        @SAUDA_DATETO VARCHAR(11),  
 @PARTY_CODEFROM varchar(15),            
        @PARTY_CODETO  varchar(15),            
        @SCRIP_CDFROM  varchar(15),  
        @SCRIP_CDTO  varchar(15),            
        @CONTRACT_NOFROM varchar(15),            
        @CONTRACT_NOTO varchar(15) ,  
 @fldstat int  
)   
AS  
 IF @fldstat = 1  
  BEGIN  
 SELECT called_from,  
   contract_no = case when i.contract_no ='%' then '' else i.contract_no end,  
   new_contract_no = Case when i.new_contract_no ='%' then '' else i.new_contract_no end,   
   convert(varchar,i.sauda_date,103) sauda_date,c1.short_name short_name,  
   IsNull(u.ucc_code,'') ucc_code,c1.Family PARENT_AC , case when i.scrip_cd ='%' then '' else i.scrip_cd end scrip_cd,  
   i.qty,  
   i.new_qty,  
   i.market_rate,  
   i.net_rate,  
   sell_buy=case i.sell_buy when '2' then 'Sell' when '1' then 'Buy' else '' end,  
   I.Party_Code,  
   I.New_Party_Code,  
   I.Brokerage,  
   I.New_Brokerage,  
   I.Participant_Code,   
   I.New_Participant_Code   
  FROM   
     inst_log i,  
     client1 c1,  
     client2 c2  
   Left   
     Outer Join   
     Ucc_Client U   
     On (u.party_code=c2.party_code)  
 WHERE             c1.cl_code=c2.cl_code   
      and I.Party_Code <> I.New_Party_Code   
      And called_from Like '%AFTERCONT%'   
      And I.New_Party_Code <> ''    
      and  i.party_code=c2.party_code  
      and Convert(DateTime,Sauda_Date) >= @SAUDA_DATEFROM  
      and Convert(DateTime,Sauda_Date) <= @SAUDA_DATETO +' 23:59:59'  
      and i.party_code >= @PARTY_CODEFROM  
      and  i.party_code<= @PARTY_CODETO  
      and   i.scrip_cd >=   @SCRIP_CDFROM  
      and   i.scrip_cd <=  @SCRIP_CDTO  
      and i.contract_no >=  @CONTRACT_NOFROM  
      and  i.contract_no<= @CONTRACT_NOTO  
 order by timestamp  
END  
  
  
 IF  @fldstat = 2  
  
  
  BEGIN  
 SELECT called_from,  
   contract_no = case when i.contract_no ='%' then '' else i.contract_no end,  
   new_contract_no = Case when i.new_contract_no ='%' then '' else i.new_contract_no end,   
   convert(varchar,i.sauda_date,103) sauda_date,c1.short_name short_name,  
   IsNull(u.ucc_code,'') ucc_code,c1.Family PARENT_AC , case when i.scrip_cd ='%' then '' else i.scrip_cd end scrip_cd,  
   i.qty,  
   i.new_qty,  
   i.market_rate,  
   i.net_rate,  
   sell_buy=case i.sell_buy when '2' then 'Sell' when '1' then 'Buy' else '' end,  
   I.Party_Code,  
   I.New_Party_Code,  
   I.Brokerage,  
   I.New_Brokerage,  
   I.Participant_Code,   
   I.New_Participant_Code   
  FROM   
     inst_log i,  
     client1 c1,  
     client2 c2  
   Left   
     Outer Join   
     Ucc_Client U   
     On (u.party_code=c2.party_code)  
 WHERE             c1.cl_code=c2.cl_code   
                  And Module = 'MIBROK'  
    And called_from Like '%Brok%'   
    And I.Party_Code = I.New_Party_Code    
             and  i.party_code=c2.party_code  
      and Convert(DateTime,Sauda_Date) >= @SAUDA_DATEFROM  
      and Convert(DateTime,Sauda_Date) <= @SAUDA_DATETO +' 23:59:59'  
      and i.party_code >= @PARTY_CODEFROM  
      and  i.party_code<= @PARTY_CODETO  
      and   i.scrip_cd >=   @SCRIP_CDFROM  
      and   i.scrip_cd <=  @SCRIP_CDTO  
      and i.contract_no >=  @CONTRACT_NOFROM  
      and  i.contract_no<= @CONTRACT_NOTO  
 order by timestamp  
END  
  
IF  @fldstat = 3  
  
  
  BEGIN  
 SELECT called_from,  
   contract_no = case when i.contract_no ='%' then '' else i.contract_no end,  
   new_contract_no = Case when i.new_contract_no ='%' then '' else i.new_contract_no end,   
   convert(varchar,i.sauda_date,103) sauda_date,c1.short_name short_name,  
   IsNull(u.ucc_code,'') ucc_code,c1.Family PARENT_AC , case when i.scrip_cd ='%' then '' else i.scrip_cd end scrip_cd,  
   i.qty,  
   i.new_qty,  
   i.market_rate,  
   i.net_rate,  
   sell_buy=case i.sell_buy when '2' then 'Sell' when '1' then 'Buy' else '' end,  
   I.Party_Code,  
   I.New_Party_Code,  
   I.Brokerage,  
   I.New_Brokerage,  
   I.Participant_Code,   
   I.New_Participant_Code   
  FROM   
     inst_log i,  
     client1 c1,  
     client2 c2  
   Left   
     Outer Join   
     Ucc_Client U   
     On (u.party_code=c2.party_code)  
 WHERE             c1.cl_code=c2.cl_code   
                 And I.Participant_Code <> I.New_Participant_Code   
          And I.Party_Code = I.New_Party_Code    
             and  i.party_code=c2.party_code  
      and Convert(DateTime,Sauda_Date) >= @SAUDA_DATEFROM  
      and Convert(DateTime,Sauda_Date) <= @SAUDA_DATETO +' 23:59:59'  
      and i.party_code >= @PARTY_CODEFROM  
      and  i.party_code<= @PARTY_CODETO  
      and   i.scrip_cd >=   @SCRIP_CDFROM  
      and   i.scrip_cd <=  @SCRIP_CDTO  
      and i.contract_no >=  @CONTRACT_NOFROM  
      and  i.contract_no<= @CONTRACT_NOTO  
 order by timestamp  
END  
  
IF  @fldstat = 4  
  
  BEGIN  
 SELECT called_from,  
   contract_no = case when i.contract_no ='%' then '' else i.contract_no end,  
   new_contract_no = Case when i.new_contract_no ='%' then '' else i.new_contract_no end,   
   convert(varchar,i.sauda_date,103) sauda_date,c1.short_name short_name,  
   IsNull(u.ucc_code,'') ucc_code,c1.Family PARENT_AC , case when i.scrip_cd ='%' then '' else i.scrip_cd end scrip_cd,  
   i.qty,  
   i.new_qty,  
   i.market_rate,  
   i.net_rate,  
   sell_buy=case i.sell_buy when '2' then 'Sell' when '1' then 'Buy' else '' end,  
   I.Party_Code,  
   I.New_Party_Code,  
   I.Brokerage,  
   I.New_Brokerage,  
   I.Participant_Code,   
   I.New_Participant_Code   
  FROM   
     inst_log i,  
     client1 c1,  
     client2 c2  
   Left   
     Outer Join   
     Ucc_Client U   
     On (u.party_code=c2.party_code)  
 WHERE             c1.cl_code=c2.cl_code   
                And called_from Like '%CONFIRM%'   
         And I.Party_Code = I.New_Party_Code   
             and  i.party_code=c2.party_code  
      and Convert(DateTime,Sauda_Date) >= @SAUDA_DATEFROM  
      and Convert(DateTime,Sauda_Date) <= @SAUDA_DATETO +' 23:59:59'  
      and i.party_code >= @PARTY_CODEFROM  
      and  i.party_code<= @PARTY_CODETO  
      and   i.scrip_cd >=   @SCRIP_CDFROM  
      and   i.scrip_cd <=  @SCRIP_CDTO  
      and i.contract_no >=  @CONTRACT_NOFROM  
      and  i.contract_no<= @CONTRACT_NOTO  
 order by timestamp  
END  
  
IF  @fldstat = 5  
BEGIN  
 SELECT called_from,  
   contract_no = case when i.contract_no ='%' then '' else i.contract_no end,  
   new_contract_no = Case when i.new_contract_no ='%' then '' else i.new_contract_no end,   
   convert(varchar,i.sauda_date,103) sauda_date,c1.short_name short_name,  
   IsNull(u.ucc_code,'') ucc_code,c1.Family PARENT_AC , case when i.scrip_cd ='%' then '' else i.scrip_cd end scrip_cd,  
   i.qty,  
   i.new_qty,  
   i.market_rate,  
   i.net_rate,  
   sell_buy=case i.sell_buy when '2' then 'Sell' when '1' then 'Buy' else '' end,  
   I.Party_Code,  
   I.New_Party_Code,  
   I.Brokerage,  
   I.New_Brokerage,  
   I.Participant_Code,   
   I.New_Participant_Code   
  FROM   
     inst_log i,  
     client1 c1,  
     client2 c2  
   Left   
     Outer Join   
     Ucc_Client U   
     On (u.party_code=c2.party_code)  
 WHERE             c1.cl_code=c2.cl_code   
                And called_from Like '%REJECT%'  
         And I.Party_Code = I.New_Party_Code  
             and  i.party_code=c2.party_code  
      and Convert(DateTime,Sauda_Date) >= @SAUDA_DATEFROM  
      and Convert(DateTime,Sauda_Date) <= @SAUDA_DATETO +' 23:59:59'  
      and i.party_code >= @PARTY_CODEFROM  
      and  i.party_code<= @PARTY_CODETO  
      and   i.scrip_cd >=   @SCRIP_CDFROM  
      and   i.scrip_cd <=  @SCRIP_CDTO  
      and i.contract_no >=  @CONTRACT_NOFROM  
      and  i.contract_no<= @CONTRACT_NOTO  
 order by timestamp  
END  
IF  @fldstat = 6  
  
BEGIN  
 SELECT called_from,  
   contract_no = case when i.contract_no ='%' then '' else i.contract_no end,  
   new_contract_no = Case when i.new_contract_no ='%' then '' else i.new_contract_no end,   
   convert(varchar,i.sauda_date,103) sauda_date,c1.short_name short_name,  
   IsNull(u.ucc_code,'') ucc_code,c1.Family PARENT_AC , case when i.scrip_cd ='%' then '' else i.scrip_cd end scrip_cd,  
   i.qty,  
   i.new_qty,  
   i.market_rate,  
   i.net_rate,  
   sell_buy=case i.sell_buy when '2' then 'Sell' when '1' then 'Buy' else '' end,  
   I.Party_Code,  
   I.New_Party_Code,  
   I.Brokerage,  
   I.New_Brokerage,  
   I.Participant_Code,   
   I.New_Participant_Code   
  FROM   
     inst_log i,  
     client1 c1,  
     client2 c2  
   Left   
     Outer Join   
     Ucc_Client U   
     On (u.party_code=c2.party_code)  
 WHERE             c1.cl_code=c2.cl_code   
               And called_from Like 'CONSOLIDAT%'   
        And I.Party_Code = I.New_Party_Code   
             and  i.party_code=c2.party_code  
      and Convert(DateTime,Sauda_Date) >= @SAUDA_DATEFROM  
      and Convert(DateTime,Sauda_Date) <= @SAUDA_DATETO +' 23:59:59'  
      and i.party_code >= @PARTY_CODEFROM  
      and  i.party_code<= @PARTY_CODETO  
      and   i.scrip_cd >=   @SCRIP_CDFROM  
      and   i.scrip_cd <=  @SCRIP_CDTO  
      and i.contract_no >=  @CONTRACT_NOFROM  
      and  i.contract_no<= @CONTRACT_NOTO  
 order by timestamp  
END  
  
 if @fldstat = 7  
  
  
BEGIN  
 SELECT called_from,  
   contract_no = case when i.contract_no ='%' then '' else i.contract_no end,  
   new_contract_no = Case when i.new_contract_no ='%' then '' else i.new_contract_no end,   
   convert(varchar,i.sauda_date,103) sauda_date,c1.short_name short_name,  
   IsNull(u.ucc_code,'') ucc_code,c1.Family PARENT_AC , case when i.scrip_cd ='%' then '' else i.scrip_cd end scrip_cd,  
   i.qty,  
   i.new_qty,  
   i.market_rate,  
   i.net_rate,  
   sell_buy=case i.sell_buy when '2' then 'Sell' when '1' then 'Buy' else '' end,  
   I.Party_Code,  
   I.New_Party_Code,  
   I.Brokerage,  
   I.New_Brokerage,  
   I.Participant_Code,   
   I.New_Participant_Code   
  FROM   
     inst_log i,  
     client1 c1,  
     client2 c2  
   Left   
     Outer Join   
     Ucc_Client U   
     On (u.party_code=c2.party_code)  
 WHERE             c1.cl_code=c2.cl_code   
              And called_from Like 'UNCONSOLIDAT%'  
       And I.Party_Code = I.New_Party_Code   
             and  i.party_code=c2.party_code  
      and Convert(DateTime,Sauda_Date) >= @SAUDA_DATEFROM  
      and Convert(DateTime,Sauda_Date) <= @SAUDA_DATETO +' 23:59:59'  
      and i.party_code >= @PARTY_CODEFROM  
      and  i.party_code<= @PARTY_CODETO  
      and   i.scrip_cd >=   @SCRIP_CDFROM  
      and   i.scrip_cd <=  @SCRIP_CDTO  
      and i.contract_no >=  @CONTRACT_NOFROM  
      and  i.contract_no<= @CONTRACT_NOTO  
 order by timestamp  
END  
  
IF @fldstat= 8  
  
BEGIN  
 SELECT called_from,  
   contract_no = case when i.contract_no ='%' then '' else i.contract_no end,  
   new_contract_no = Case when i.new_contract_no ='%' then '' else i.new_contract_no end,   
   convert(varchar,i.sauda_date,103) sauda_date,c1.short_name short_name,  
   IsNull(u.ucc_code,'') ucc_code,c1.Family PARENT_AC , case when i.scrip_cd ='%' then '' else i.scrip_cd end scrip_cd,  
   i.qty,  
   i.new_qty,  
   i.market_rate,  
   i.net_rate,  
   sell_buy=case i.sell_buy when '2' then 'Sell' when '1' then 'Buy' else '' end,  
   I.Party_Code,  
   I.New_Party_Code,  
   I.Brokerage,  
   I.New_Brokerage,  
   I.Participant_Code,   
   I.New_Participant_Code   
  FROM   
     inst_log i,  
     client1 c1,  
     client2 c2  
   Left   
     Outer Join   
     Ucc_Client U   
     On (u.party_code=c2.party_code)  
 WHERE   
   c1.cl_code=c2.cl_code      
     And I.Party_Code = I.New_Party_Code And I.Brokerage = I.New_Brokerage  
     And I.Net_Rate = I.New_Net_Rate And I.Participant_Code = I.New_Participant_Code  
      and  i.party_code=c2.party_code  
      and Convert(DateTime,Sauda_Date) >= @SAUDA_DATEFROM  
      and Convert(DateTime,Sauda_Date) <= @SAUDA_DATETO +' 23:59:59'  
      and i.party_code >= @PARTY_CODEFROM  
      and  i.party_code<= @PARTY_CODETO  
      and   i.scrip_cd >=   @SCRIP_CDFROM  
      and   i.scrip_cd <=  @SCRIP_CDTO  
      and i.contract_no >=  @CONTRACT_NOFROM  
      and  i.contract_no<= @CONTRACT_NOTO  
 order by timestamp  
END

GO
