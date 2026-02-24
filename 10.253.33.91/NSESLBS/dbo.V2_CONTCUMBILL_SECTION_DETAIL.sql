-- Object: PROCEDURE dbo.V2_CONTCUMBILL_SECTION_DETAIL
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE  PROC V2_CONTCUMBILL_SECTION_DETAIL(
           @STATUSID       VARCHAR(15),
           @STATUSNAME     VARCHAR(25),
           @SAUDA_DATE     VARCHAR(11),
           @SETT_NO        VARCHAR(7),
           @SETT_TYPE      VARCHAR(2),
           @FROMPARTY_CODE VARCHAR(10),
           @TOPARTY_CODE   VARCHAR(10),
           @FROMBRANCH     VARCHAR(10),
           @TOBRANCH       VARCHAR(10),
           @FROMSUB_BROKER VARCHAR(10),
           @TOSUB_BROKER   VARCHAR(10),
           @CONTFLAG       VARCHAR(10))
AS

  DECLARE  @ColName VARCHAR(6)
  
  SELECT @ColName = ''
  
  IF @CONTFLAG = 'CONTRACT'
    SELECT @ColName = RPT_CODE
    FROM   V2_CONTRACTPRINT_SETTING
    WHERE  RPT_TYPE = 'ORDER'
           AND RPT_PRINTFLAG = 1
  ELSE
    SELECT @ColName = RPT_CODE
    FROM   V2_CONTRACTPRINT_SETTING
    WHERE  RPT_TYPE = 'ORDER'
           AND RPT_PRINTFLAG_DIGI = 1

	SELECT  
	OrderByFlag = (Case When @ColName = 'ORD_N' 
			  Then PartyName
			  When @ColName = 'ORD_P'
			  Then M.Party_Code
			  When @ColName = 'ORD_BP'
			  Then RTrim(LTrim(Branch_Cd)) + RTrim(LTrim(M.Party_Code))
			  When @ColName = 'ORD_BN'
			  Then RTrim(LTrim(Branch_Cd)) + RTrim(LTrim(PartyName))
			  When @ColName = 'ORD_DP'
			  Then RTrim(LTrim(Branch_Cd)) + RTrim(LTrim(Sub_Broker)) + RTrim(LTrim(Trader)) + RTrim(LTrim(M.Party_Code))
			  When @ColName = 'ORD_DN'
			  Then RTrim(LTrim(Branch_Cd)) + RTrim(LTrim(Sub_Broker)) + RTrim(LTrim(Trader)) + RTrim(LTrim(PartyName))
			  Else RTrim(LTrim(Branch_Cd)) + RTrim(LTrim(Sub_Broker)) + RTrim(LTrim(Trader)) + RTrim(LTrim(M.Party_Code))
		    End),	
	CONTRACTNO,
        M.PARTY_CODE,   
        ORDER_NO,   
        ORDER_TIME,   
        TM, 
        TRADE_NO,   
        SAUDA_DATE,   
        SCRIP_CD,   
        SERIES,   
        SCRIPNAME, 
	PSCRIPNAME = (
	CASE 
		WHEN SELL_BUY=1 
		THEN SCRIPNAME 
		ELSE '' END), 
	SSCRIPNAME = (
	CASE 
		WHEN SELL_BUY=2 
		THEN SCRIPNAME 
		ELSE '' END), 
        SDT,   
        SELL_BUY,   
        BROKER_CHRG,   
        TURN_TAX,
        PBROKER_CHRG=(
	CASE
		WHEN SELL_BUY = 1
		THEN BROKER_CHRG
		ELSE 0 END),
        SBROKER_CHRG=(
	CASE
		WHEN SELL_BUY = 2
		THEN BROKER_CHRG
		ELSE 0 END),
        PTURN_TAX=(
	CASE
		WHEN SELL_BUY = 1
		THEN TURN_TAX
		ELSE 0 END),
        STURN_TAX=(
	CASE
		WHEN SELL_BUY = 2
		THEN TURN_TAX
		ELSE 0 END),
        SEBI_TAX,   
        OTHER_CHRG,   
        INS_CHRG, 
        PINS_CHRG=(   
        CASE 
                WHEN SELL_BUY = 1 
                THEN INS_CHRG 
                ELSE 0 END), 
        SINS_CHRG=(   
        CASE 
                WHEN SELL_BUY = 2 
                THEN INS_CHRG 
                ELSE 0 END), 
        SERVICE_TAX,   
        NSERTAX,
	PNSERTAX=(
        CASE 
                WHEN SELL_BUY = 1 
                THEN NSERTAX 
                ELSE 0 END), 
	SNSERTAX=(
        CASE 
                WHEN SELL_BUY = 2 
                THEN NSERTAX 
                ELSE 0 END), 
        SAUDA_DATE1,   
        PQTY,   
        SQTY, 
        RATE = PRATE + SRATE, 
        PRATE,   
        SRATE, 
        BROK = PBROK+SBROK, 
        PBROK,   
        SBROK, 
        NETRATE = PNETRATE + SNETRATE, 
        PNETRATE,   
        SNETRATE, 
        AMT = (   
        CASE 
                WHEN SELL_BUY = 1 
                THEN -PAMT 
                ELSE SAMT END),   
        PAMT,   
        SAMT, 
        AMTSTT = (   
        CASE 
                WHEN SELL_BUY = 1 
                THEN -(PAMT+INS_CHRG) 
                ELSE (SAMT-INS_CHRG) END), 
        PAMTSTT = (   
        CASE 
                WHEN SELL_BUY = 1 
                THEN PAMT+INS_CHRG 
                ELSE 0 END), 
        SAMTSTT = (   
        CASE 
                WHEN SELL_BUY = 2 
                THEN SAMT-INS_CHRG 
                ELSE 0 END),
        AMTSER = (   
        CASE 
                WHEN SELL_BUY = 1 
                THEN -(PAMT+NSERTAX) 
                ELSE (SAMT-NSERTAX) END), 
        PAMTSER = (   
        CASE 
                WHEN SELL_BUY = 1 
                THEN PAMT+NSERTAX 
                ELSE 0 END), 
        SAMTSER = (   
        CASE 
                WHEN SELL_BUY = 2 
                THEN SAMT-NSERTAX 
                ELSE 0 END),        
	AMTSERSTT = (   
        CASE 
                WHEN SELL_BUY = 1 
                THEN -(PAMT+NSERTAX+INS_CHRG) 
                ELSE (SAMT-NSERTAX-INS_CHRG) END), 
        PAMTSERSTT = (   
        CASE 
                WHEN SELL_BUY = 1 
                THEN PAMT+NSERTAX+INS_CHRG 
                ELSE 0 END), 
        SAMTSERSTT = (   
        CASE 
                WHEN SELL_BUY = 2 
                THEN SAMT-NSERTAX-INS_CHRG
                ELSE 0 END),
        
        AMTSERSTTSTAMPTRANS = (   
        CASE 
            WHEN SELL_BUY = 1 
                THEN -(PAMT+NSERTAX+INS_CHRG+BROKER_CHRG+TURN_TAX) 
                ELSE (SAMT-NSERTAX-INS_CHRG-BROKER_CHRG-TURN_TAX) END), 
        PAMTSERSTTSTAMPTRANS = (   
        CASE 
                WHEN SELL_BUY = 1 
                THEN PAMT+NSERTAX+INS_CHRG+BROKER_CHRG+TURN_TAX 
                ELSE 0 END), 
        SAMTSERSTTSTAMPTRANS = (   
        CASE 
                WHEN SELL_BUY = 2 
                THEN SAMT-NSERTAX-INS_CHRG-BROKER_CHRG-TURN_TAX
                ELSE 0 END),

	MARKETAMT  = (PRATE + SRATE) * (PQTY+SQTY), 
        PMARKETAMT = PRATE * PQTY , 
        SMARKETAMT = SRATE * SQTY , 
        BROKERAGE,   
        PBROKERAGE=(CASE WHEN SELL_BUY = 1 THEN BROKERAGE ELSE 0 END),   
        SBROKERAGE=(CASE WHEN SELL_BUY = 2 THEN BROKERAGE ELSE 0 END),   
        M.SETT_NO, 
        M.SETT_TYPE,   
        TRADETYPE,   
        TMARK,   
        PARTYNAME,   
        L_ADDRESS1, 
        L_ADDRESS2,   
        L_ADDRESS3,   
        L_CITY,   
	L_STATE,
        L_ZIP,   
        SERVICE_CHRG, 
        BRANCH_CD,   
        SUB_BROKER,   
        TRADER,   
        PAN_GIR_NO,   
        OFF_PHONE1, 
        OFF_PHONE2,   
        M.PRINTF,   
        MAPIDID,   
	UCC_CODE,
        ORDERFLAG,
	SCRIPNAMEForOrderBy,
        SCRIPNAME1,
	ISIN,
	SEBI_NO,
	Participant_Code
  FROM     CONTRACT_DATA D,
           CONTRACT_MASTER M WITH (NOLOCK)
  WHERE    M.SETT_TYPE = D.SETT_TYPE
           AND M.SETT_NO = D.SETT_NO
           AND M.PARTY_CODE = D.PARTY_CODE
           AND M.SETT_TYPE = @SETT_TYPE
           AND M.SETT_NO = @SETT_NO
           AND M.PARTY_CODE BETWEEN @FROMPARTY_CODE
                                    AND @TOPARTY_CODE
           AND BRANCH_CD BETWEEN @FROMBRANCH
                                 AND @TOBRANCH
           AND SUB_BROKER BETWEEN @FROMSUB_BROKER
                                  AND @TOSUB_BROKER
           AND @StatusName = (CASE 
                                WHEN @StatusId = 'BRANCH' THEN M.BRANCH_CD
                                WHEN @StatusId = 'SUBBROKER' THEN M.SUB_BROKER
                                WHEN @StatusId = 'Trader' THEN M.TRADER
                                WHEN @StatusId = 'Family' THEN M.FAMILY
                                WHEN @StatusId = 'Area' THEN M.AREA
                                WHEN @StatusId = 'Region' THEN M.REGION
                                WHEN @StatusId = 'Client' THEN M.PARTY_CODE
                                ELSE 'BROKER'
                              END)
           AND M.PRINTF <> (CASE 
                              WHEN @CONTFLAG = 'CONTRACT' THEN 1
                              ELSE 9
                            END)
  ORDER BY ORDERBYFLAG,
           BRANCH_CD,
           SUB_BROKER,
           TRADER,
           M.PARTY_CODE,
           PARTYNAME,
           CONTRACTNO DESC,
           SCRIPNAME1,
	   SCRIPNAMEFORORDERBY,	
	   ORDERFLAG,
           SCRIPNAME,
           M.SETT_NO,
           M.SETT_TYPE,
           TM,
           ORDER_NO,
           TRADE_NO

GO
