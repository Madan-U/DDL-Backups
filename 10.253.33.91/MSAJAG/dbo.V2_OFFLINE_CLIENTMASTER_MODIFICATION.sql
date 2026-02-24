-- Object: PROCEDURE dbo.V2_OFFLINE_CLIENTMASTER_MODIFICATION
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

  
  
  
CREATE   PROC V2_OFFLINE_CLIENTMASTER_MODIFICATION(    
   @StatusId  Varchar(15),  
   @StatusName    Varchar(25),           
          @ModifyDate VARCHAR(11),   
   @TODATE     VARCHAR(11),           
          @FromPartyCode  VARCHAR(10),            
          @ToPartyCode  VARCHAR(10),            
          @MODIFYFLAG VARCHAR(1),            
          @EXCHANGE   VARCHAR(10),            
          @SEGMENT    VARCHAR(10))            
AS            
            
/*            
V2_OFFLINE_CLIENTMASTER_MODIFICATION '2006-05-30','UTIBK','C','',''            
V2_OFFLINE_CLIENTMASTER_MODIFICATION '2006/04/06','ALWC000001','C','',''            
select * from client_brok_details_log            
        
V2_OFFLINE_CLIENTMASTER_MODIFICATION '2006-07-27','','b','',''            
  Select LEFT(CONVERT(DATETIME,REPLACE(2006-04-06,'/','-'),112),11)            
        
*/            
            
  SET @ModifyDate = LEFT(CONVERT(DATETIME,REPLACE(REPLACE(@ModifyDate,'/',''),'-',''),112),11)            
  SET @TODATE = LEFT(CONVERT(DATETIME,REPLACE(REPLACE(@TODATE,'/',''),'-',''),112),11)            
        
  IF @ModifyFlag = 'C'            
    BEGIN            
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED        
      SELECT   *            
      FROM     (SELECT 
          
       EDIT_BY =ModifidedBy ,          
       EDIT_ON =ModifidedOn ,          
       [PARTY CODE] = PARTY_CODE,          
       [LONG NAME] = LONG_NAME,          
       [SHORT NAME] = SHORT_NAME,          
       [CL TYPE] = CL_TYPE,          
       [BRANCH] = BRANCH_CD,          
       [SUB BROKER] = SUB_BROKER,          
       [TRADER] = TRADER,          
       [FAMILY] = FAMILY,          
       [REGION] = REGION,          
       [AREA] = AREA,          
       [ADD1] = L_ADDRESS1,          
       [ADD2] = L_ADDRESS2,          
       [ADD3] = L_ADDRESS3,          
       [CITY] = L_CITY,          
       [ZIP] = L_ZIP,          
       [STATE] = L_STATE,          
       [NATION] = L_NATION,          
       [PAN NO] = PAN_GIR_NO,          
       [RES PH1] = RES_PHONE1,          
       [RES PH2] = RES_PHONE2,          
       [OFF PH1] = OFF_PHONE1,          
       [OFF PH2] = OFF_PHONE2,          
       [PERS PH] = P_PHONE,          
       [MOBILE] = MOBILE_PAGER,          
       [FAX] = FAX,          
       [EMAIL] = EMAIL,          
       [M/F] = SEX,          
       [DOB] = DOB,          
       [INTRODUCER] = INTRODUCER,          
       [PASSPORT#] = PASSPORT_NO,          
       [LICENCE#] = LICENCE_NO,          
       [RATION CARD#] = RAT_CARD_NO,          
       [VOTERID#] = VOTERSID_NO,          
       [BANK] = BANK_NAME,          
       [BANK BR] = BRANCH_NAME,          
       [AC TYPE] = AC_TYPE,          
       [A/C#] = AC_NUM,          
       [DEP1] = DEPOSITORY1,          
       [DPID1] = DPID1,          
       [CLTID1] = CLTDPID1,          
       [POA FLAG1] = POA1,          
       [DEP2] = DEPOSITORY2,          
       [DPID2] = DPID2,          
       [CLTID2] = CLTDPID2,          
       [POA FLAG2] = POA2,          
       [DEP3] = DEPOSITORY3,          
       [DPID3] = DPID3,          
       [CLTID3] = CLTDPID3,          
       [POA FLAG3] = POA3,        
       [CLT AG DT] = CLIENT_AGREEMENT_ON,          
       [SETT MODE] = SETT_MODE,          
       [BANK ID] = BANK_ID,          
       [MAPIN] = MAPIN_ID,          
       [UCC CODE] = UCC_CODE,          
       [MICR NO] = MICR_NO,          
       [PAY LOC] = PAYLOCATION          
                FROM   CLIENT_DETAILS (NOLOCK)           
                WHERE  CL_CODE >= @FromPartyCode and cl_code <= @toPartyCode  
  And @StatusName =           
                  (case           
                        when @StatusId = 'BRANCH' then branch_cd          
                        when @StatusId = 'SUBBROKER' then sub_broker          
                        when @StatusId = 'Trader' then Trader          
                        when @StatusId = 'Family' then Family          
                        when @StatusId = 'Area' then Area          
                        when @StatusId = 'Region' then Region          
                        when @StatusId = 'Client' then party_code          
                  else           
                        'BROKER'          
                  End)   
                UNION ALL            
                SELECT             
       EDIT_BY,            
       EDIT_ON,            
       [PARTY CODE] = PARTY_CODE,          
       [LONG NAME] = LONG_NAME,          
       [SHORT NAME] = SHORT_NAME,          
       [CL TYPE] = CL_TYPE,          
       [BRANCH] = BRANCH_CD,          
       [SUB BROKER] = SUB_BROKER,          
       [TRADER] = TRADER,          
       [FAMILY] = FAMILY,          
       [REGION] = REGION,          
       [AREA] = AREA,          
       [ADD1] = L_ADDRESS1,          
       [ADD2] = L_ADDRESS2,          
       [ADD3] = L_ADDRESS3,          
       [CITY] = L_CITY,          
      [ZIP] = L_ZIP,          
       [STATE] = L_STATE,          
       [NATION] = L_NATION,          
       [PAN NO] = PAN_GIR_NO,          
       [RES PH1] = RES_PHONE1,          
       [RES PH2] = RES_PHONE2,          
       [OFF PH1] = OFF_PHONE1,          
       [OFF PH2] = OFF_PHONE2,        
       [PERS PH] = P_PHONE,          
       [MOBILE] = MOBILE_PAGER,          
       [FAX] = FAX,          
       [EMAIL] = EMAIL,          
       [M/F] = SEX,          
       [DOB] = DOB,          
       [INTRODUCER] = INTRODUCER,          
   [PASSPORT#] = PASSPORT_NO,          
       [LICENCE#] = LICENCE_NO,          
       [RATION CARD#] = RAT_CARD_NO,          
       [VOTERID#] = VOTERSID_NO,          
       [BANK] = BANK_NAME,          
       [BANK BR] = BRANCH_NAME,          
       [AC TYPE] = AC_TYPE,          
       [A/C#] = AC_NUM,          
       [DEP1] = DEPOSITORY1,          
       [DPID1] = DPID1,          
       [CLTID1] = CLTDPID1,          
       [POA FLAG1] = POA1,          
       [DEP2] = DEPOSITORY2,          
       [DPID2] = DPID2,          
       [CLTID2] = CLTDPID2,          
       [POA FLAG2] = POA2,          
       [DEP3] = DEPOSITORY3,          
       [DPID3] = DPID3,          
       [CLTID3] = CLTDPID3,          
       [POA FLAG3] = POA3,        
       [CLT AG DT] = CLIENT_AGREEMENT_ON,          
       [SETT MODE] = SETT_MODE,          
       [BANK ID] = BANK_ID,          
       [MAPIN] = MAPIN_ID,          
       [UCC CODE] = UCC_CODE,          
       [MICR NO] = MICR_NO,          
       [PAY LOC] = PAYLOCATION          
                FROM   CLIENT_DETAILS_LOG  WITH(INDEX(CDL_IDX),NOLOCK)         
                WHERE  CL_CODE >= @FromPartyCode and cl_code <= @toPartyCode  
                AND EDIT_ON >= @ModifyDate  
  AND EDIT_ON <= @TODATE + ' 23:59:59'  
  And @StatusName =           
                  (case           
                        when @StatusId = 'BRANCH' then branch_cd          
                        when @StatusId = 'SUBBROKER' then sub_broker          
                        when @StatusId = 'Trader' then Trader          
                        when @StatusId = 'Family' then Family          
                        when @StatusId = 'Area' then Area          
                        when @StatusId = 'Region' then Region          
                        when @StatusId = 'Client' then party_code          
                  else           
                        'BROKER'          
                  End) ) X            
      ORDER BY X.EDIT_ON         
    END            
  IF @ModifyFlag = 'M'            
    BEGIN            
  IF @SEGMENT = 'CAPITAL'          
  BEGIN          
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED        
      SELECT   *            
      FROM     (SELECT           
       EDIT_BY =Modifiedby ,          
       EDIT_ON =Modifiedon ,             
      [EXCHANGE] = EXCHANGE,          
      [SEGMENT] = SEGMENT,          
      [BROK SCHEME] = BROK_SCHEME,          
      [TRD BROK] = TRD_BROK,          
      [DEL BROK] = DEL_BROK,        
      [SER TAX] = SER_TAX,          
      [SER TAX METHOD] = SER_TAX_METHOD,          
      [INACTIVE FROM] = INACTIVE_FROM,          
      [TRD STT] = TRD_STT,          
      [TRD TRAN CHRG] = TRD_TRAN_CHRGS,          
      [TRD SEBI FEES] = TRD_SEBI_FEES,          
      [TRD STAMP DUTY] = TRD_STAMP_DUTY,          
      [TRD OTHER CHRG] = TRD_OTHER_CHRGS,          
      [TRD EFF DT] = TRD_EFF_DT,          
      [DEL STT] = DEL_STT,          
      [DEL TRAN CHRG] = DEL_TRAN_CHRGS,          
      [DEL SEBI FEES] = DEL_SEBI_FEES,          
      [DEL STAMP DUTY] = DEL_STAMP_DUTY,          
      [DEL OTHER CHRG] = DEL_OTHER_CHRGS,          
      [DEL EFF DT] = DEL_EFF_DT,          
      [ROUND METHOD] = ROUNDING_METHOD,          
      [ROUND TO] = ROUND_TO_DIGIT,          
      [ROUND TO PS] = ROUND_TO_PAISE,          
      [PRINT OPTION] = PRINT_OPTIONS,          
      [COPIES] = NO_OF_COPIES,          
      [PARTICIPANT] = PARTICIPANT_CODE,          
      [CUSTODIAN] = CUSTODIAN_CODE,          
      [INS CONTRACT] = INST_CONTRACT,          
      [ROUND STYLE] = ROUND_STYLE,          
      [STP PROVIDER] = STP_PROVIDER,          
      [STP STYLE] = STP_RP_STYLE,          
      [MKT TYPE] = MARKET_TYPE,          
      [MULTIPLIER] = MULTIPLIER,          
      [CHARGED] = CHARGED,          
      [MAINTENANCE] = MAINTENANCE,          
      [REQ BY EXC] = REQD_BY_EXCH,          
      [REQ BY BROK] = REQD_BY_BROKER,          
      [RATING] = CLIENT_RATING,          
      [DEBIT BAL] = DEBIT_BALANCE,          
      [INT. SETT FLAG] = INTER_SETT,          
      [B3B PAYMENT] = PAY_B3B_PAYMENT,          
      [BANK NAME] = PAY_BANK_NAME,          
      [BRANCH] = PAY_BRANCH_NAME,          
      [AC NO] = PAY_AC_NO,          
      [PAY MODE] = PAY_PAYMENT_MODE,          
      [BROK EFF DT] = BROK_EFF_DATE,          
      [INS TRD BROK] = INST_TRD_BROK,          
      [INS DEL BROK] = INST_DEL_BROK,          
      [ACTIVE DATE] = ACTIVE_DATE,          
      [CHECK ACTIVE CL] = CHECKACTIVECLIENT          
       FROM   CLIENT_BROK_DETAILS   (NOLOCK)        
       WHERE  CL_CODE >= @FromPartyCode  and cl_code <= @toPartyCode  
        AND EXCHANGE = @EXCHANGE            
        AND SEGMENT = @SEGMENT           
    UNION ALL          
      SELECT EDIT_BY,            
      EDIT_ON,            
      [EXCHANGE] = EXCHANGE,          
      [SEGMENT] = SEGMENT,          
      [BROK SCHEME] = BROK_SCHEME,          
      [TRD BROK] = TRD_BROK,          
      [DEL BROK] = DEL_BROK,          
      [SER TAX] = SER_TAX,          
      [SER TAX METHOD] = SER_TAX_METHOD,          
      [INACTIVE FROM] = INACTIVE_FROM,          
      [TRD STT] = TRD_STT,          
      [TRD TRAN CHRG] = TRD_TRAN_CHRGS,          
      [TRD SEBI FEES] = TRD_SEBI_FEES,          
      [TRD STAMP DUTY] = TRD_STAMP_DUTY,          
      [TRD OTHER CHRG] = TRD_OTHER_CHRGS,          
      [TRD EFF DT] = TRD_EFF_DT,          
      [DEL STT] = DEL_STT,          
      [DEL TRAN CHRG] = DEL_TRAN_CHRGS,          
      [DEL SEBI FEES] = DEL_SEBI_FEES,          
      [DEL STAMP DUTY] = DEL_STAMP_DUTY,          
      [DEL OTHER CHRG] = DEL_OTHER_CHRGS,          
      [DEL EFF DT] = DEL_EFF_DT,          
      [ROUND METHOD] = ROUNDING_METHOD,          
      [ROUND TO] = ROUND_TO_DIGIT,          
      [ROUND TO PS] = ROUND_TO_PAISE,          
      [PRINT OPTION] = PRINT_OPTIONS,          
      [COPIES] = NO_OF_COPIES,          
      [PARTICIPANT] = PARTICIPANT_CODE,          
      [CUSTODIAN] = CUSTODIAN_CODE,          
      [INS CONTRACT] = INST_CONTRACT,          
      [ROUND STYLE] = ROUND_STYLE,          
      [STP PROVIDER] = STP_PROVIDER,          
      [STP STYLE] = STP_RP_STYLE,          
      [MKT TYPE] = MARKET_TYPE,          
      [MULTIPLIER] = MULTIPLIER,          
      [CHARGED] = CHARGED,          
      [MAINTENANCE] = MAINTENANCE,          
      [REQ BY EXC] = REQD_BY_EXCH,          
      [REQ BY BROK] = REQD_BY_BROKER,          
      [RATING] = CLIENT_RATING,          
    [DEBIT BAL] = DEBIT_BALANCE,          
      [INT. SETT FLAG] = INTER_SETT,          
      [B3B PAYMENT] = PAY_B3B_PAYMENT,          
      [BANK NAME] = PAY_BANK_NAME,          
      [BRANCH] = PAY_BRANCH_NAME,          
      [AC NO] = PAY_AC_NO,          
      [PAY MODE] = PAY_PAYMENT_MODE,          
      [BROK EFF DT] = BROK_EFF_DATE,          
      [INS TRD BROK] = INST_TRD_BROK,          
      [INS DEL BROK] = INST_DEL_BROK,          
      [ACTIVE DATE] = ACTIVE_DATE,          
      [CHECK ACTIVE CL] = CHECKACTIVECLIENT          
       FROM   CLIENT_BROK_DETAILS_LOG WITH(INDEX(CBDL_IDX),NOLOCK)            
       WHERE  CL_CODE >= @FromPartyCode and cl_code <= @toPartyCode  
        AND EDIT_ON >= @ModifyDate  
 AND EDIT_ON <= @TODATE + ' 23:59:59'  
        AND EXCHANGE = @EXCHANGE            
        AND SEGMENT = @SEGMENT          
    ) X            
      ORDER BY X.EDIT_ON             
  END          
  ELSE          
  BEGIN          
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED        
      SELECT   *            
      FROM     (SELECT           
      [EDIT_BY] = Modifiedby,            
      [EDIT_on] = Modifiedon,            
      [EXCHANGE] = EXCHANGE,          
      [SEGMENT] = SEGMENT,          
      [FUT BROK] = FUT_BROK,          
      [OPT BROK] = FUT_OPT_BROK,          
      [FUT FINAL BROK] = FUT_FUT_FIN_BROK,          
      [OPT EX BROK] = FUT_OPT_EXC,          
      [BROK APPLICABLE] = FUT_BROK_APPLICABLE,          
      [FUT STT] = FUT_STT,          
      [FUT TRAN CHRG] = FUT_TRAN_CHRGS,          
      [FUT SEBI FEES] = FUT_SEBI_FEES,          
      [FUT STAMP DUTY] = FUT_STAMP_DUTY,          
      [FUT OTHER CHRG] = FUT_OTHER_CHRGS,          
      [SER TAX] = SER_TAX,          
      [SER TAX METHOD] = SER_TAX_METHOD,          
      [INACTIVE FROM] = INACTIVE_FROM,          
      [TRD STT] = TRD_STT,          
      [TRD TRAN CHRG] = TRD_TRAN_CHRGS,          
      [TRD SEBI FEES] = TRD_SEBI_FEES,          
      [TRD STAMP DUTY] = TRD_STAMP_DUTY,          
      [TRD OTHER CHRG] = TRD_OTHER_CHRGS,          
      [TRD EFF DT] = TRD_EFF_DT,          
      [DEL STT] = DEL_STT,          
      [DEL TRAN CHRG] = DEL_TRAN_CHRGS,          
      [DEL SEBI FEES] = DEL_SEBI_FEES,          
      [DEL STAMP DUTY] = DEL_STAMP_DUTY,          
      [DEL OTHER CHRG] = DEL_OTHER_CHRGS,          
      [DEL EFF DT] = DEL_EFF_DT,          
      [ROUND METHOD] = ROUNDING_METHOD,          
      [ROUND TO] = ROUND_TO_DIGIT,          
      [ROUND TO PS] = ROUND_TO_PAISE,          
      [PRINT OPTION] = PRINT_OPTIONS,          
      [COPIES] = NO_OF_COPIES,          
      [PARTICIPANT] = PARTICIPANT_CODE,          
      [CUSTODIAN] = CUSTODIAN_CODE,          
      [INS CONTRACT] = INST_CONTRACT,          
      [ROUND STYLE] = ROUND_STYLE,          
      [STP PROVIDER] = STP_PROVIDER,          
      [STP STYLE] = STP_RP_STYLE,          
      [MKT TYPE] = MARKET_TYPE,          
      [MULTIPLIER] = MULTIPLIER,          
      [CHARGED] = CHARGED,          
      [MAINTENANCE] = MAINTENANCE,          
      [REQ BY EXC] = REQD_BY_EXCH,          
      [REQ BY BROK] = REQD_BY_BROKER,          
      [RATING] = CLIENT_RATING,          
      [DEBIT BAL] = DEBIT_BALANCE,          
      [INT. SETT FLAG] = INTER_SETT,          
      [B3B PAYMENT] = PAY_B3B_PAYMENT,          
      [BANK NAME] = PAY_BANK_NAME,          
      [BRANCH] = PAY_BRANCH_NAME,          
      [AC NO] = PAY_AC_NO,          
      [PAY MODE] = PAY_PAYMENT_MODE,          
      [BROK EFF DT] = BROK_EFF_DATE,          
      [INS TRD BROK] = INST_TRD_BROK,          
      [INS DEL BROK] = INST_DEL_BROK,          
      [ACTIVE DATE] = ACTIVE_DATE,          
      [CHECK ACTIVE CL] = CHECKACTIVECLIENT          
       FROM   CLIENT_BROK_DETAILS            
       WHERE  CL_CODE >= @FromPartyCode  and cl_code <= @toPartyCode  
       AND EXCHANGE = @EXCHANGE            
        AND SEGMENT = @SEGMENT          
    UNION ALL          
      SELECT EDIT_BY,            
      EDIT_ON,            
      [EXCHANGE] = EXCHANGE,          
      [SEGMENT] = SEGMENT,          
      [FUT BROK] = FUT_BROK,          
      [OPT BROK] = FUT_OPT_BROK,          
      [FUT FINAL BROK] = FUT_FUT_FIN_BROK,          
      [OPT EX BROK] = FUT_OPT_EXC,          
      [BROK APPLICABLE] = FUT_BROK_APPLICABLE,          
      [FUT STT] = FUT_STT,          
      [FUT TRAN CHRG] = FUT_TRAN_CHRGS,          
      [FUT SEBI FEES] = FUT_SEBI_FEES,          
      [FUT STAMP DUTY] = FUT_STAMP_DUTY,          
      [FUT OTHER CHRG] = FUT_OTHER_CHRGS,          
      [SER TAX] = SER_TAX,          
      [SER TAX METHOD] = SER_TAX_METHOD,          
      [INACTIVE FROM] = INACTIVE_FROM,          
      [TRD STT] = TRD_STT,          
      [TRD TRAN CHRG] = TRD_TRAN_CHRGS,          
      [TRD SEBI FEES] = TRD_SEBI_FEES,          
      [TRD STAMP DUTY] = TRD_STAMP_DUTY,          
      [TRD OTHER CHRG] = TRD_OTHER_CHRGS,          
      [TRD EFF DT] = TRD_EFF_DT,          
      [DEL STT] = DEL_STT,          
      [DEL TRAN CHRG] = DEL_TRAN_CHRGS,          
      [DEL SEBI FEES] = DEL_SEBI_FEES,          
      [DEL STAMP DUTY] = DEL_STAMP_DUTY,          
      [DEL OTHER CHRG] = DEL_OTHER_CHRGS,          
      [DEL EFF DT] = DEL_EFF_DT,          
      [ROUND METHOD] = ROUNDING_METHOD,          
      [ROUND TO] = ROUND_TO_DIGIT,          
      [ROUND TO PS] = ROUND_TO_PAISE,          
      [PRINT OPTION] = PRINT_OPTIONS,          
      [COPIES] = NO_OF_COPIES,          
      [PARTICIPANT] = PARTICIPANT_CODE,          
      [CUSTODIAN] = CUSTODIAN_CODE,          
      [INS CONTRACT] = INST_CONTRACT,          
      [ROUND STYLE] = ROUND_STYLE,          
      [STP PROVIDER] = STP_PROVIDER,          
      [STP STYLE] = STP_RP_STYLE,          
     [MKT TYPE] = MARKET_TYPE,          
      [MULTIPLIER] = MULTIPLIER,          
      [CHARGED] = CHARGED,          
      [MAINTENANCE] = MAINTENANCE,          
      [REQ BY EXC] = REQD_BY_EXCH,          
      [REQ BY BROK] = REQD_BY_BROKER,          
      [RATING] = CLIENT_RATING,          
      [DEBIT BAL] = DEBIT_BALANCE,          
      [INT. SETT FLAG] = INTER_SETT,          
      [B3B PAYMENT] = PAY_B3B_PAYMENT,          
      [BANK NAME] = PAY_BANK_NAME,          
      [BRANCH] = PAY_BRANCH_NAME,          
      [AC NO] = PAY_AC_NO,          
      [PAY MODE] = PAY_PAYMENT_MODE,          
      [BROK EFF DT] = BROK_EFF_DATE,          
      [INS TRD BROK] = INST_TRD_BROK,          
      [INS DEL BROK] = INST_DEL_BROK,          
      [ACTIVE DATE] = ACTIVE_DATE,          
      [CHECK ACTIVE CL] = CHECKACTIVECLIENT          
       FROM   CLIENT_BROK_DETAILS_LOG WITH(INDEX(CBDL_IDX),NOLOCK)            
       WHERE  CL_CODE >= @FromPartyCode  and cl_code <= @toPartyCode          
        AND EDIT_ON >= @ModifyDate            
 AND EDIT_ON <= @TODATE + ' 23:59:59'  
        AND EXCHANGE = @EXCHANGE            
        AND SEGMENT = @SEGMENT      
    ) X            
      ORDER BY X.EDIT_ON         
  END          
  END       
  IF @ModifyFlag = 'D'      
 BEGIN      
   CREATE TABLE #CLIENT_MODIFICATIONS      
   (   
    PARTY_CODE    VARCHAR(10),      
    PARTY_NAME    VARCHAR(100),      
    CLIENT_TYPE    VARCHAR(3),      
    BRANCH     VARCHAR(10),      
    SUB_BROKER    VARCHAR(10),      
    DEPOSITORY_1   VARCHAR(7),      
    DPID_1     VARCHAR(16),      
    CLTDPID_1    VARCHAR(16),      
    POA_FLAG_1    VARCHAR(1),      
    OLD_DEPOSITORY_1  VARCHAR(7),      
    OLD_DPID_1    VARCHAR(16),      
    OLD_CLTDPID_1   VARCHAR(16),      
    OLD_POA_FLAG_1   VARCHAR(1),      
    DEPOSITORY_2   VARCHAR(7),      
    DPID_2     VARCHAR(16),      
    CLTDPID_2    VARCHAR(16),      
    POA_FLAG_2    VARCHAR(1),      
    OLD_DEPOSITORY_2  VARCHAR(7),      
    OLD_DPID_2    VARCHAR(16),      
    OLD_CLTDPID_2   VARCHAR(16),      
    OLD_POA_FLAG_2   VARCHAR(1),      
    DEPOSITORY_3   VARCHAR(7),      
    DPID_3     VARCHAR(16),      
    CLTDPID_3    VARCHAR(16),      
    POA_FLAG_3    VARCHAR(1),      
    OLD_DEPOSITORY_3 VARCHAR(7),      
    OLD_DPID_3    VARCHAR(16),      
    OLD_CLTDPID_3   VARCHAR(16),      
    OLD_POA_FLAG_3   VARCHAR(1)      
   )      
      
   CREATE CLUSTERED INDEX TEMPCLIDX ON #CLIENT_MODIFICATIONS (PARTY_CODE)      
    
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
   INSERT INTO #CLIENT_MODIFICATIONS      
   (      
    PARTY_CODE,      
    PARTY_NAME,      
    CLIENT_TYPE,      
    BRANCH,      
    SUB_BROKER,      
    DEPOSITORY_1,      
    DPID_1,      
    CLTDPID_1,      
    POA_FLAG_1,      
    DEPOSITORY_2,      
    DPID_2,      
    CLTDPID_2,      
    POA_FLAG_2,      
    DEPOSITORY_3,      
    DPID_3,      
    CLTDPID_3,      
    POA_FLAG_3      
   )      
   SELECT      
    [PARTY CODE] = CD.PARTY_CODE,          
    [PARTY NAME] = CD.SHORT_NAME,          
    [CL TYPE] = CD.CL_TYPE,          
    [BRANCH] = CD.BRANCH_CD,          
    [SUB BROKER] = CD.SUB_BROKER,          
    [DEP1] = CD.DEPOSITORY1,          
    [DPID1] = CD.DPID1,          
    [CLTID1] = CD.CLTDPID1,          
    [POA FLAG1] = CD.POA1,          
    [DEP2] = CD.DEPOSITORY2,          
    [DPID2] = CD.DPID2,          
    [CLTID2] = CD.CLTDPID2,          
    [POA FLAG2] = CD.POA2,          
    [DEP3] = CD.DEPOSITORY3,          
    [DPID3] = CD.DPID3,          
    [CLTID3] = CD.CLTDPID3,          
    [POA FLAG3] = CD.POA3       
   FROM      
    CLIENT_DETAILS CD (NOLOCK)      
    JOIN       
    (      
     SELECT DISTINCT CL_CODE FROM CLIENT_DETAILS_LOG (NOLOCK)      
     WHERE EDIT_ON >= @ModifyDate  
    AND EDIT_ON <= @TODATE + ' 23:59:59'      
    ) M      
   ON (CD.CL_CODE = M.CL_CODE)      
WHERE  CD.CL_CODE >= @FromPartyCode and CD.cl_code <= @toPartyCode  
And @StatusName =           
                  (case           
                        when @StatusId = 'BRANCH' then CD.branch_cd          
                        when @StatusId = 'SUBBROKER' then CD.sub_broker          
                        when @StatusId = 'Trader' then CD.Trader          
                        when @StatusId = 'Family' then CD.Family          
                        when @StatusId = 'Area' then CD.Area          
                        when @StatusId = 'Region' then CD.Region          
                        when @StatusId = 'Client' then CD.party_code          
                  else           
                        'BROKER'          
                  End)   
      
      
   CREATE TABLE #CLIENT_MODIFICATIONS_TEMP      
   (      
    SNO      INT IDENTITY(1,1),      
    EDIT_ON     DATETIME,      
    PARTY_CODE    VARCHAR(10),      
    PARTY_NAME    VARCHAR(100),      
    CLIENT_TYPE    VARCHAR(3),      
    BRANCH     VARCHAR(10),      
    SUB_BROKER    VARCHAR(10),      
    OLD_DEPOSITORY_1   VARCHAR(7),      
    OLD_DPID_1     VARCHAR(16),      
    OLD_CLTDPID_1    VARCHAR(16),      
    OLD_POA_FLAG_1    VARCHAR(1),      
    OLD_DEPOSITORY_2   VARCHAR(7),      
    OLD_DPID_2     VARCHAR(16),      
    OLD_CLTDPID_2    VARCHAR(16),      
    OLD_POA_FLAG_2    VARCHAR(1),      
    OLD_DEPOSITORY_3   VARCHAR(7),      
    OLD_DPID_3     VARCHAR(16),      
    OLD_CLTDPID_3    VARCHAR(16),      
    OLD_POA_FLAG_3    VARCHAR(1)      
   )      
      
   INSERT INTO #CLIENT_MODIFICATIONS_TEMP      
    SELECT      
     [EDIT_ON] = CD.EDIT_ON,       
     [PARTY CODE] = CD.PARTY_CODE,          
     [PARTY NAME] = CD.SHORT_NAME,          
     [CL TYPE] = CD.CL_TYPE,          
     [BRANCH] = CD.BRANCH_CD,          
     [SUB BROKER] = CD.SUB_BROKER,          
     [DEP1] = CD.DEPOSITORY1,          
     [DPID1] = CD.DPID1,          
     [CLTID1] = CD.CLTDPID1,          
     [POA FLAG1] = CD.POA1,          
     [DEP2] = CD.DEPOSITORY2,          
     [DPID2] = CD.DPID2,          
     [CLTID2] = CD.CLTDPID2,          
     [POA FLAG2] = CD.POA2,          
     [DEP3] = CD.DEPOSITORY3,          
     [DPID3] = CD.DPID3,          
     [CLTID3] = CD.CLTDPID3,          
     [POA FLAG3] = CD.POA3      
    FROM      
     CLIENT_DETAILS_LOG CD (NOLOCK)      
    WHERE CD.EDIT_ON >= @ModifyDate      AND CD.EDIT_ON <= @TODATE + ' 23:59:59'  
AND CD.CL_CODE >= @FromPartyCode and CD.cl_code <= @toPartyCode  
And @StatusName =           
                  (case           
                        when @StatusId = 'BRANCH' then branch_cd          
                        when @StatusId = 'SUBBROKER' then sub_broker          
                        when @StatusId = 'Trader' then Trader          
                        when @StatusId = 'Family' then Family          
                        when @StatusId = 'Area' then Area          
                        when @StatusId = 'Region' then Region          
                        when @StatusId = 'Client' then party_code          
                  else           
                        'BROKER'          
                  End)   
  
    ORDER BY      
     CD.PARTY_CODE, CD.EDIT_ON       
      
      
      
    UPDATE #CLIENT_MODIFICATIONS      
    SET      
     OLD_DEPOSITORY_1 = A.OLD_DEPOSITORY_1,      
     OLD_DPID_1 = A.OLD_DPID_1,      
     OLD_CLTDPID_1 = A.OLD_CLTDPID_1,      
     OLD_POA_FLAG_1 = A.OLD_POA_FLAG_1,      
     OLD_DEPOSITORY_2 = A.OLD_DEPOSITORY_2,      
     OLD_DPID_2 = A.OLD_DPID_2,      
     OLD_CLTDPID_2 = A.OLD_CLTDPID_2,      
     OLD_POA_FLAG_2 = A.OLD_POA_FLAG_2,      
     OLD_DEPOSITORY_3 = A.OLD_DEPOSITORY_3,      
     OLD_DPID_3 = A.OLD_DPID_3,      
     OLD_CLTDPID_3 = A.OLD_CLTDPID_3,      
     OLD_POA_FLAG_3 = A.OLD_POA_FLAG_3      
    FROM      
    (      
     SELECT * FROM #CLIENT_MODIFICATIONS_TEMP TEMP      
     JOIN      
     (      
      SELECT CLCODE = PARTY_CODE, SRNO = MIN(SNO)  FROM #CLIENT_MODIFICATIONS_TEMP       
      GROUP BY PARTY_CODE      
     ) GRP      
     ON (      
      TEMP.PARTY_CODE = GRP.CLCODE       
      AND      
      TEMP.SNO = GRP.SRNO      
      )      
    ) A      
    WHERE      
     #CLIENT_MODIFICATIONS.PARTY_CODE = A.PARTY_CODE      
      
------------------------------------------------------------------------  
-- COMPLETED PROCESS  
------------------------------------------------------------------------  
  
    SELECT * FROM #CLIENT_MODIFICATIONS      
    WHERE       
     (      
      DEPOSITORY_1 <> OLD_DEPOSITORY_1      
      OR      
      DPID_1 <> OLD_DPID_1      
      OR      
      CLTDPID_1 <> OLD_CLTDPID_1      
      OR      
      POA_FLAG_1 <> OLD_POA_FLAG_1      
      OR      
      DEPOSITORY_2 <> OLD_DEPOSITORY_2      
      OR      
      DPID_2 <> OLD_DPID_2      
      OR      
      CLTDPID_2 <> OLD_CLTDPID_2      
      OR      
      POA_FLAG_2 <> OLD_POA_FLAG_2      
      OR      
      DEPOSITORY_3 <> OLD_DEPOSITORY_3      
      OR      
      DPID_3 <> OLD_DPID_3      
      OR      
      CLTDPID_3 <> OLD_CLTDPID_3      
      OR      
      POA_FLAG_3 <> OLD_POA_FLAG_3      
     )         
      
    DROP TABLE #CLIENT_MODIFICATIONS      
    DROP TABLE #CLIENT_MODIFICATIONS_TEMP      
 END    
 if @ModifyFlag = 'B'    
 begin    
  
    CREATE TABLE #CLIENT_BROK_MODIFICATIONS  
    (  
     PARTY_CODE         VARCHAR(10),  
     PARTY_NAME         VARCHAR(100),  
     CLIENT_TYPE         VARCHAR(3),  
     BRANCH           VARCHAR(10),  
     SUB_BROKER         VARCHAR(10),  
     NSECM_BROK_SCHEME      TINYINT,      
     NSECM_TRD_BROK       INT,  
     NSECM_DEL_BROK       INT,  
     OLD_NSECM_BROK_SCHEME    TINYINT,      
     OLD_NSECM_TRD_BROK      INT,  
     OLD_NSECM_DEL_BROK      INT,  
     BSECM_BROK_SCHEME      TINYINT,      
     BSECM_TRD_BROK       INT,  
     BSECM_DEL_BROK        INT,  
     OLD_BSECM_BROK_SCHEME    TINYINT,      
     OLD_BSECM_TRD_BROK      INT,  
     OLD_BSECM_DEL_BROK      INT,  
     NSEFO_FUT_BROK       INT,      
     NSEFO_FUT_OPT_BROK      INT,      
     NSEFO_FUT_FUT_FIN_BROK    INT,      
     NSEFO_FUT_OPT_EXC      INT,      
     NSEFO_FUT_BROK_APPLICABLE   INT,  
     OLD_NSEFO_FUT_BROK      INT,      
     OLD_NSEFO_FUT_OPT_BROK    INT,      
     OLD_NSEFO_FUT_FUT_FIN_BROK   INT,      
     OLD_NSEFO_FUT_OPT_EXC    INT,      
     OLD_NSEFO_FUT_BROK_APPLICABLE INT,  
     NCDX_FUT_BROK        INT,      
     NCDX_FUT_OPT_BROK      INT,      
     NCDX_FUT_FUT_FIN_BROK     INT,      
     NCDX_FUT_OPT_EXC       INT,      
     NCDX_FUT_BROK_APPLICABLE    INT,  
     OLD_NCDX_FUT_BROK      INT,      
     OLD_NCDX_FUT_OPT_BROK    INT,      
     OLD_NCDX_FUT_FUT_FIN_BROK   INT,      
     OLD_NCDX_FUT_OPT_EXC     INT,      
     OLD_NCDX_FUT_BROK_APPLICABLE  INT,  
     MCDX_FUT_BROK        INT,      
     MCDX_FUT_OPT_BROK      INT,      
     MCDX_FUT_FUT_FIN_BROK     INT,      
     MCDX_FUT_OPT_EXC      INT,      
     MCDX_FUT_BROK_APPLICABLE   INT,  
     OLD_MCDX_FUT_BROK      INT,      
     OLD_MCDX_FUT_OPT_BROK    INT,      
     OLD_MCDX_FUT_FUT_FIN_BROK   INT,      
     OLD_MCDX_FUT_OPT_EXC     INT,      
     OLD_MCDX_FUT_BROK_APPLICABLE  INT  
    )  
  
    CREATE CLUSTERED INDEX TEMPCLIDX ON #CLIENT_BROK_MODIFICATIONS (PARTY_CODE)    
  
  
  
       SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
       INSERT INTO #CLIENT_BROK_MODIFICATIONS      
       (      
     PARTY_CODE,      
     PARTY_NAME,      
     CLIENT_TYPE,      
     BRANCH,      
     SUB_BROKER      
       )      
       SELECT  DISTINCT  
     [PARTY CODE] = CD.PARTY_CODE,          
     [PARTY NAME] = CD.SHORT_NAME,          
     [CL TYPE] = CD.CL_TYPE,          
     [BRANCH] = CD.BRANCH_CD,          
     [SUB BROKER] = CD.SUB_BROKER  
       FROM      
     CLIENT_DETAILS CD (NOLOCK)      
     JOIN       
     (      
      SELECT DISTINCT CL_CODE FROM CLIENT_BROK_DETAILS_LOG (NOLOCK)      
      WHERE EDIT_ON >= @ModifyDate  
      AND EDIT_ON <= @TODATE + ' 23:59:59'      
     ) M      
       ON (CD.CL_CODE = M.CL_CODE)      
       WHERE  CD.CL_CODE >= @FROMPARTYCODE AND CD.CL_CODE <= @TOPARTYCODE  
    And @StatusName =           
                      (case           
                            when @StatusId = 'BRANCH' then cd.branch_cd          
                            when @StatusId = 'SUBBROKER' then cd.sub_broker          
                            when @StatusId = 'Trader' then cd.Trader          
                            when @StatusId = 'Family' then cd.Family          
                            when @StatusId = 'Area' then cd.Area          
                            when @StatusId = 'Region' then cd.Region          
                            when @StatusId = 'Client' then cd.party_code          
                      else           
                            'BROKER'          
                      End)   
    /*==================================================*/  
    /*           DOING NSE         */  
    /*==================================================*/  
  
  
    CREATE TABLE #CLIENT_NSE_MODIFICATIONS_TEMP  
    (  
     SNO            INT IDENTITY(1,1),  
     EDIT_ON           DATETIME,     
     PARTY_CODE         VARCHAR(10),  
     NSECM_BROK_SCHEME      TINYINT,      
     NSECM_TRD_BROK       INT,  
     NSECM_DEL_BROK       INT,  
     OLD_NSECM_BROK_SCHEME    TINYINT,      
     OLD_NSECM_TRD_BROK      INT,  
     OLD_NSECM_DEL_BROK      INT  
    )  
  
     INSERT INTO #CLIENT_NSE_MODIFICATIONS_TEMP      
     SELECT      
      CBDL.EDIT_ON,  
      CBDL.CL_CODE,  
      CBD.BROK_SCHEME,  
      CBD.TRD_BROK,  
      CBD.DEL_BROK,  
      CBDL.BROK_SCHEME,  
      CBDL.TRD_BROK,  
      CBDL.DEL_BROK  
     FROM      
      CLIENT_BROK_DETAILS_LOG CBDL (NOLOCK)      
      JOIN  
      CLIENT_BROK_DETAILS CBD (NOLOCK)      
     ON  
      (  
       CBD.CL_CODE = CBDL.CL_CODE  
       AND CBD.EXCHANGE = CBDL.EXCHANGE  
       AND CBD.SEGMENT = CBDL.SEGMENT  
      )  
     WHERE      
      CBDL.EDIT_ON >= @ModifyDate  
      AND CBDL.EDIT_ON <= @TODATE + ' 23:59:59'      
      AND CBDL.EXCHANGE = 'NSE'  
      AND CBDL.SEGMENT = 'CAPITAL'  
      AND CBDL.CL_CODE >= @FROMPARTYCODE AND CBDL.CL_CODE <= @TOPARTYCODE  
  
     ORDER BY      
      CBDL.CL_CODE, CBDL.EDIT_ON       
          
     UPDATE #CLIENT_BROK_MODIFICATIONS      
     SET      
      OLD_NSECM_BROK_SCHEME = A.OLD_NSECM_BROK_SCHEME,  
      OLD_NSECM_TRD_BROK = A.OLD_NSECM_TRD_BROK,  
      OLD_NSECM_DEL_BROK = A.OLD_NSECM_DEL_BROK,  
      NSECM_BROK_SCHEME = A.NSECM_BROK_SCHEME,  
      NSECM_TRD_BROK = A.NSECM_TRD_BROK,  
      NSECM_DEL_BROK = A.NSECM_DEL_BROK  
     FROM      
     (      
      SELECT * FROM #CLIENT_NSE_MODIFICATIONS_TEMP TEMP      
      JOIN      
      (      
       SELECT CLCODE = PARTY_CODE, SRNO = MIN(SNO)  FROM #CLIENT_NSE_MODIFICATIONS_TEMP       
       GROUP BY PARTY_CODE      
      ) GRP      
      ON (      
       TEMP.PARTY_CODE = GRP.CLCODE       
       AND      
       TEMP.SNO = GRP.SRNO      
       )      
     ) A      
     WHERE      
      #CLIENT_BROK_MODIFICATIONS.PARTY_CODE = A.PARTY_CODE      
  
    DROP TABLE #CLIENT_NSE_MODIFICATIONS_TEMP  
  
    /*==================================================*/  
    /*           DOING BSE         */  
    /*==================================================*/  
  
    CREATE TABLE #CLIENT_BSE_MODIFICATIONS_TEMP  
    (  
     SNO            INT IDENTITY(1,1),  
     EDIT_ON           DATETIME,     
     PARTY_CODE         VARCHAR(10),  
     BSECM_BROK_SCHEME      TINYINT,      
     BSECM_TRD_BROK       INT,  
     BSECM_DEL_BROK        INT,  
     OLD_BSECM_BROK_SCHEME    TINYINT,      
     OLD_BSECM_TRD_BROK      INT,  
     OLD_BSECM_DEL_BROK      INT  
    )  
  
     INSERT INTO #CLIENT_BSE_MODIFICATIONS_TEMP      
     SELECT      
      CBDL.EDIT_ON,  
      CBDL.CL_CODE,  
      CBD.BROK_SCHEME,  
      CBD.TRD_BROK,  
      CBD.DEL_BROK,  
      CBDL.BROK_SCHEME,  
      CBDL.TRD_BROK,  
      CBDL.DEL_BROK  
     FROM      
      CLIENT_BROK_DETAILS_LOG CBDL (NOLOCK)      
      JOIN  
      CLIENT_BROK_DETAILS CBD (NOLOCK)      
     ON  
      (  
       CBD.CL_CODE = CBDL.CL_CODE  
       AND CBD.EXCHANGE = CBDL.EXCHANGE  
       AND CBD.SEGMENT = CBDL.SEGMENT  
      )  
     WHERE      
      CBDL.EDIT_ON >= @ModifyDate  
      AND CBDL.EDIT_ON <= @TODATE + ' 23:59:59'      
      AND CBDL.EXCHANGE = 'BSE'  
      AND CBDL.SEGMENT = 'CAPITAL'  
      AND CBDL.CL_CODE >= @FROMPARTYCODE AND CBDL.CL_CODE <= @TOPARTYCODE  
     ORDER BY      
      CBDL.CL_CODE, CBDL.EDIT_ON            
          
  
     UPDATE #CLIENT_BROK_MODIFICATIONS      
     SET      
      OLD_BSECM_BROK_SCHEME = A.OLD_BSECM_BROK_SCHEME,  
      OLD_BSECM_TRD_BROK = A.OLD_BSECM_TRD_BROK,  
      OLD_BSECM_DEL_BROK = A.OLD_BSECM_DEL_BROK,  
      BSECM_BROK_SCHEME = A.BSECM_BROK_SCHEME,  
      BSECM_TRD_BROK = A.BSECM_TRD_BROK,  
      BSECM_DEL_BROK = A.BSECM_DEL_BROK  
     FROM      
     (      
      SELECT * FROM #CLIENT_BSE_MODIFICATIONS_TEMP TEMP      
      JOIN      
      (      
       SELECT CLCODE = PARTY_CODE, SRNO = MIN(SNO)  FROM #CLIENT_BSE_MODIFICATIONS_TEMP       
       GROUP BY PARTY_CODE      
      ) GRP      
      ON (      
       TEMP.PARTY_CODE = GRP.CLCODE       
       AND      
       TEMP.SNO = GRP.SRNO      
       )      
     ) A      
     WHERE      
      #CLIENT_BROK_MODIFICATIONS.PARTY_CODE = A.PARTY_CODE      
  
    DROP TABLE #CLIENT_BSE_MODIFICATIONS_TEMP  
  
  
    /*==================================================*/  
    /*          DOING NSEFO         */  
    /*==================================================*/  
  
    CREATE TABLE #CLIENT_NSEFO_MODIFICATIONS_TEMP  
    (  
     SNO            INT IDENTITY(1,1),  
     EDIT_ON           DATETIME,     
     PARTY_CODE         VARCHAR(10),  
     NSEFO_FUT_BROK       INT,      
     NSEFO_FUT_OPT_BROK      INT,      
     NSEFO_FUT_FUT_FIN_BROK    INT,      
     NSEFO_FUT_OPT_EXC      INT,      
     NSEFO_FUT_BROK_APPLICABLE   INT,  
     OLD_NSEFO_FUT_BROK      INT,      
     OLD_NSEFO_FUT_OPT_BROK    INT,      
     OLD_NSEFO_FUT_FUT_FIN_BROK   INT,      
     OLD_NSEFO_FUT_OPT_EXC    INT,      
     OLD_NSEFO_FUT_BROK_APPLICABLE INT  
    )  
  
     INSERT INTO #CLIENT_NSEFO_MODIFICATIONS_TEMP      
     SELECT      
      CBDL.EDIT_ON,  
      CBDL.CL_CODE,  
      CBD.FUT_BROK,  
      CBD.FUT_OPT_BROK,  
      CBD.FUT_FUT_FIN_BROK,  
      CBD.FUT_OPT_EXC,  
      CBD.FUT_BROK_APPLICABLE,  
      CBDL.FUT_BROK,  
      CBDL.FUT_OPT_BROK,  
      CBDL.FUT_FUT_FIN_BROK,  
      CBDL.FUT_OPT_EXC,  
      CBDL.FUT_BROK_APPLICABLE  
     FROM      
      CLIENT_BROK_DETAILS_LOG CBDL (NOLOCK)      
      JOIN  
      CLIENT_BROK_DETAILS CBD (NOLOCK)      
     ON  
      (  
       CBD.CL_CODE = CBDL.CL_CODE  
       AND CBD.EXCHANGE = CBDL.EXCHANGE  
       AND CBD.SEGMENT = CBDL.SEGMENT  
      )  
     WHERE      
      CBDL.EDIT_ON >= @ModifyDate  
  AND CBDL.EDIT_ON <= @TODATE + ' 23:59:59'  
      AND CBDL.EXCHANGE = 'NSE'  
      AND CBDL.SEGMENT = 'FUTURES'  
      AND CBDL.CL_CODE >= @FROMPARTYCODE AND CBDL.CL_CODE <= @TOPARTYCODE  
     ORDER BY      
      CBDL.CL_CODE, CBDL.EDIT_ON            
          
  
     UPDATE #CLIENT_BROK_MODIFICATIONS      
     SET      
      OLD_NSEFO_FUT_BROK = A.OLD_NSEFO_FUT_BROK,  
      OLD_NSEFO_FUT_OPT_BROK = A.OLD_NSEFO_FUT_OPT_BROK,  
      OLD_NSEFO_FUT_FUT_FIN_BROK = A.OLD_NSEFO_FUT_FUT_FIN_BROK,  
      OLD_NSEFO_FUT_OPT_EXC = A.OLD_NSEFO_FUT_OPT_EXC,      
      OLD_NSEFO_FUT_BROK_APPLICABLE = A.OLD_NSEFO_FUT_BROK_APPLICABLE,  
      NSEFO_FUT_BROK = A.NSEFO_FUT_BROK,  
      NSEFO_FUT_OPT_BROK = A.NSEFO_FUT_OPT_BROK,  
      NSEFO_FUT_FUT_FIN_BROK = A.NSEFO_FUT_FUT_FIN_BROK,  
      NSEFO_FUT_OPT_EXC = A.NSEFO_FUT_OPT_EXC,  
      NSEFO_FUT_BROK_APPLICABLE = A.NSEFO_FUT_BROK_APPLICABLE  
     FROM      
     (      
      SELECT * FROM #CLIENT_NSEFO_MODIFICATIONS_TEMP TEMP      
      JOIN      
      (      
       SELECT CLCODE = PARTY_CODE, SRNO = MIN(SNO)  FROM #CLIENT_NSEFO_MODIFICATIONS_TEMP       
       GROUP BY PARTY_CODE      
      ) GRP      
      ON (      
       TEMP.PARTY_CODE = GRP.CLCODE       
       AND      
       TEMP.SNO = GRP.SRNO      
       )      
     ) A      
     WHERE      
      #CLIENT_BROK_MODIFICATIONS.PARTY_CODE = A.PARTY_CODE      
  
    DROP TABLE #CLIENT_NSEFO_MODIFICATIONS_TEMP  
  
  
    /*==================================================*/  
    /*          DOING NCDX         */  
    /*==================================================*/  
  
    CREATE TABLE #CLIENT_NCDX_MODIFICATIONS_TEMP  
    (  
     SNO           INT IDENTITY(1,1),  
     EDIT_ON          DATETIME,     
     PARTY_CODE        VARCHAR(10),  
     NCDX_FUT_BROK       INT,      
     NCDX_FUT_OPT_BROK     INT,      
     NCDX_FUT_FUT_FIN_BROK    INT,      
     NCDX_FUT_OPT_EXC      INT,      
     NCDX_FUT_BROK_APPLICABLE   INT,  
     OLD_NCDX_FUT_BROK     INT,      
     OLD_NCDX_FUT_OPT_BROK   INT,      
     OLD_NCDX_FUT_FUT_FIN_BROK  INT,      
     OLD_NCDX_FUT_OPT_EXC    INT,      
     OLD_NCDX_FUT_BROK_APPLICABLE INT  
    )  
  
     INSERT INTO #CLIENT_NCDX_MODIFICATIONS_TEMP      
     SELECT      
      CBDL.EDIT_ON,  
      CBDL.CL_CODE,  
      CBD.FUT_BROK,  
      CBD.FUT_OPT_BROK,  
      CBD.FUT_FUT_FIN_BROK,  
      CBD.FUT_OPT_EXC,  
      CBD.FUT_BROK_APPLICABLE,  
      CBDL.FUT_BROK,  
      CBDL.FUT_OPT_BROK,  
      CBDL.FUT_FUT_FIN_BROK,  
      CBDL.FUT_OPT_EXC,  
      CBDL.FUT_BROK_APPLICABLE  
     FROM      
      CLIENT_BROK_DETAILS_LOG CBDL (NOLOCK)      
      JOIN  
      CLIENT_BROK_DETAILS CBD (NOLOCK)      
     ON  
      (  
       CBD.CL_CODE = CBDL.CL_CODE  
       AND CBD.EXCHANGE = CBDL.EXCHANGE  
       AND CBD.SEGMENT = CBDL.SEGMENT  
      )  
     WHERE      
      CBDL.EDIT_ON >= @ModifyDate  
  AND CBDL.EDIT_ON <= @TODATE + ' 23:59:59'  
      AND CBDL.EXCHANGE = 'NCX'  
      AND CBDL.SEGMENT = 'FUTURES'  
      AND CBDL.CL_CODE >= @FROMPARTYCODE AND CBDL.CL_CODE <= @TOPARTYCODE  
     ORDER BY      
      CBDL.CL_CODE, CBDL.EDIT_ON            
          
  
     UPDATE #CLIENT_BROK_MODIFICATIONS      
     SET      
      OLD_NCDX_FUT_BROK = A.OLD_NCDX_FUT_BROK,  
      OLD_NCDX_FUT_OPT_BROK = A.OLD_NCDX_FUT_OPT_BROK,  
      OLD_NCDX_FUT_FUT_FIN_BROK = A.OLD_NCDX_FUT_FUT_FIN_BROK,  
      OLD_NCDX_FUT_OPT_EXC = A.OLD_NCDX_FUT_OPT_EXC,      
      OLD_NCDX_FUT_BROK_APPLICABLE = A.OLD_NCDX_FUT_BROK_APPLICABLE,  
      NCDX_FUT_BROK = A.NCDX_FUT_BROK,  
      NCDX_FUT_OPT_BROK = A.NCDX_FUT_OPT_BROK,  
      NCDX_FUT_FUT_FIN_BROK = A.NCDX_FUT_FUT_FIN_BROK,  
      NCDX_FUT_OPT_EXC = A.NCDX_FUT_OPT_EXC,  
      NCDX_FUT_BROK_APPLICABLE = A.NCDX_FUT_BROK_APPLICABLE  
     FROM      
     (      
      SELECT * FROM #CLIENT_NCDX_MODIFICATIONS_TEMP TEMP      
      JOIN      
      (      
       SELECT CLCODE = PARTY_CODE, SRNO = MIN(SNO)  FROM #CLIENT_NCDX_MODIFICATIONS_TEMP       
       GROUP BY PARTY_CODE      
      ) GRP      
      ON (      
       TEMP.PARTY_CODE = GRP.CLCODE       
       AND      
       TEMP.SNO = GRP.SRNO      
       )      
     ) A      
     WHERE      
      #CLIENT_BROK_MODIFICATIONS.PARTY_CODE = A.PARTY_CODE      
  
    DROP TABLE #CLIENT_NCDX_MODIFICATIONS_TEMP  
  
    /*==================================================*/  
    /*          DOING MCX         */  
    /*==================================================*/  
  
    CREATE TABLE #CLIENT_MCDX_MODIFICATIONS_TEMP  
    (  
     SNO           INT IDENTITY(1,1),  
     EDIT_ON          DATETIME,     
     PARTY_CODE        VARCHAR(10),  
     MCDX_FUT_BROK       INT,      
     MCDX_FUT_OPT_BROK     INT,      
     MCDX_FUT_FUT_FIN_BROK    INT,      
     MCDX_FUT_OPT_EXC      INT,      
     MCDX_FUT_BROK_APPLICABLE   INT,  
     OLD_MCDX_FUT_BROK      INT,      
     OLD_MCDX_FUT_OPT_BROK    INT,      
     OLD_MCDX_FUT_FUT_FIN_BROK  INT,      
     OLD_MCDX_FUT_OPT_EXC    INT,      
     OLD_MCDX_FUT_BROK_APPLICABLE INT  
    )  
  
     INSERT INTO #CLIENT_MCDX_MODIFICATIONS_TEMP      
     SELECT      
      CBDL.EDIT_ON,  
      CBDL.CL_CODE,  
      CBD.FUT_BROK,  
      CBD.FUT_OPT_BROK,  
      CBD.FUT_FUT_FIN_BROK,  
      CBD.FUT_OPT_EXC,  
      CBD.FUT_BROK_APPLICABLE,  
      CBDL.FUT_BROK,  
      CBDL.FUT_OPT_BROK,  
      CBDL.FUT_FUT_FIN_BROK,  
      CBDL.FUT_OPT_EXC,  
      CBDL.FUT_BROK_APPLICABLE  
     FROM      
      CLIENT_BROK_DETAILS_LOG CBDL (NOLOCK)      
      JOIN  
      CLIENT_BROK_DETAILS CBD (NOLOCK)      
     ON  
      (  
       CBD.CL_CODE = CBDL.CL_CODE  
       AND CBD.EXCHANGE = CBDL.EXCHANGE  
       AND CBD.SEGMENT = CBDL.SEGMENT  
      )  
     WHERE      
      CBDL.EDIT_ON >= @ModifyDate  
  AND CBDL.EDIT_ON <= @TODATE + ' 23:59:59'  
      AND CBDL.EXCHANGE = 'MCX'  
      AND CBDL.SEGMENT = 'FUTURES'  
      AND CBDL.CL_CODE >= @FROMPARTYCODE AND CBDL.CL_CODE <= @TOPARTYCODE  
     ORDER BY      
      CBDL.CL_CODE, CBDL.EDIT_ON            
          
  
     UPDATE #CLIENT_BROK_MODIFICATIONS      
     SET      
      OLD_MCDX_FUT_BROK = A.OLD_MCDX_FUT_BROK,  
      OLD_MCDX_FUT_OPT_BROK = A.OLD_MCDX_FUT_OPT_BROK,  
      OLD_MCDX_FUT_FUT_FIN_BROK = A.OLD_MCDX_FUT_FUT_FIN_BROK,  
      OLD_MCDX_FUT_OPT_EXC = A.OLD_MCDX_FUT_OPT_EXC,      
      OLD_MCDX_FUT_BROK_APPLICABLE = A.OLD_MCDX_FUT_BROK_APPLICABLE,  
      MCDX_FUT_BROK = A.MCDX_FUT_BROK,  
      MCDX_FUT_OPT_BROK = A.MCDX_FUT_OPT_BROK,  
      MCDX_FUT_FUT_FIN_BROK = A.MCDX_FUT_FUT_FIN_BROK,  
      MCDX_FUT_OPT_EXC = A.MCDX_FUT_OPT_EXC,  
      MCDX_FUT_BROK_APPLICABLE = A.MCDX_FUT_BROK_APPLICABLE  
     FROM      
     (      
      SELECT * FROM #CLIENT_MCDX_MODIFICATIONS_TEMP TEMP      
      JOIN      
      (      
       SELECT CLCODE = PARTY_CODE, SRNO = MIN(SNO)  FROM #CLIENT_MCDX_MODIFICATIONS_TEMP       
       GROUP BY PARTY_CODE      
      ) GRP      
      ON (      
       TEMP.PARTY_CODE = GRP.CLCODE       
       AND      
       TEMP.SNO = GRP.SRNO      
       )      
     ) A      
     WHERE      
      #CLIENT_BROK_MODIFICATIONS.PARTY_CODE = A.PARTY_CODE      
  
    DROP TABLE #CLIENT_MCDX_MODIFICATIONS_TEMP  
  
    ------------------------------------------------------------------------  
    -- COMPLETED PROCESS  
    ------------------------------------------------------------------------  
  
  
    SELECT * FROM #CLIENT_BROK_MODIFICATIONS  
    WHERE  
     NSECM_BROK_SCHEME <> OLD_NSECM_BROK_SCHEME OR  
     NSECM_TRD_BROK <> OLD_NSECM_TRD_BROK OR  
     NSECM_DEL_BROK <> OLD_NSECM_DEL_BROK OR  
     BSECM_BROK_SCHEME <> OLD_BSECM_BROK_SCHEME OR  
     BSECM_TRD_BROK <> OLD_BSECM_TRD_BROK OR  
     BSECM_DEL_BROK <> OLD_BSECM_DEL_BROK OR  
     NSEFO_FUT_BROK <> OLD_NSEFO_FUT_BROK OR  
     NSEFO_FUT_OPT_BROK <> OLD_NSEFO_FUT_OPT_BROK OR  
     NSEFO_FUT_FUT_FIN_BROK <> OLD_NSEFO_FUT_FUT_FIN_BROK OR  
     NSEFO_FUT_OPT_EXC <> OLD_NSEFO_FUT_OPT_EXC OR  
     NSEFO_FUT_BROK_APPLICABLE <> OLD_NSEFO_FUT_BROK_APPLICABLE OR  
     NCDX_FUT_BROK <> OLD_NCDX_FUT_BROK OR  
     NCDX_FUT_OPT_BROK <> OLD_NCDX_FUT_OPT_BROK OR  
     NCDX_FUT_FUT_FIN_BROK <> OLD_NCDX_FUT_FUT_FIN_BROK OR  
     NCDX_FUT_OPT_EXC <> OLD_NCDX_FUT_OPT_EXC OR  
     NCDX_FUT_BROK_APPLICABLE <> OLD_NCDX_FUT_BROK_APPLICABLE OR  
     MCDX_FUT_BROK <> OLD_MCDX_FUT_BROK OR  
     MCDX_FUT_OPT_BROK <> OLD_MCDX_FUT_OPT_BROK OR  
     MCDX_FUT_FUT_FIN_BROK <> OLD_MCDX_FUT_FUT_FIN_BROK OR  
     MCDX_FUT_OPT_EXC <> OLD_MCDX_FUT_OPT_EXC OR  
     MCDX_FUT_BROK_APPLICABLE <> OLD_MCDX_FUT_BROK_APPLICABLE  
    ORDER BY PARTY_CODE  
  
     DROP TABLE #CLIENT_BROK_MODIFICATIONS      
 end

GO
