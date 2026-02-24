-- Object: PROCEDURE dbo.V2_DVPCONTCUMBILL_SECTION
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------











CREATE        Proc V2_DVPCONTCUMBILL_SECTION
(
	@STATUSID VARCHAR(15),
	@STATUSNAME VARCHAR(25),
	@SAUDA_DATE VARCHAR(11),
	@SETT_NO VARCHAR(7),
	@SETT_TYPE VARCHAR(2), 
	@FROMPARTY_CODE VARCHAR(10),
	@TOPARTY_CODE VARCHAR(10),
	@FROMBRANCH VARCHAR(10), 
	@TOBRANCH VARCHAR(10), 
	@FROMSUB_BROKER VARCHAR(10), 
	@TOSUB_BROKER VARCHAR(10), 
	@FROMCONTRACTNO VARCHAR(12), 
	@TOCONTRACTNO VARCHAR(12), 
	@CONTFLAG VARCHAR(10)
 )     
AS     
Declare @ColName Varchar(6)

Select @ColName = ''
IF @CONTFLAG = 'CONTRACT' 
	Select @ColName = Rpt_Code From V2_CONTRACTPRINT_SETTING 
	Where Rpt_Type = 'ORDER' And Rpt_PrintFlag_Inst = 1

	If @FromContractno = ''
	Begin
		Set @FromContractno = 000000000
	End
	
	If @ToContractno = ''
	Begin
		Set @ToContractno   = 999999999
	End


        SET NOCOUNT ON SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED     
        SELECT  ContractNo,     
                S.Party_code,     
                Order_No   = '0000000000000000',     
                Order_TIME = '         ',     
                TM         = '0000000000000000',     
                Trade_no   = '0000000000000000',     
                S.Scrip_Cd,     
                S.Series,     
                ScripName = S1.Short_Name,     
                SDT       = Convert(Varchar,Min(Sauda_date),103),     
                Sell_Buy,     
                Broker_Chrg = Sum(    
                CASE     
                        WHEN C2.BrokerNote = 1     
                        THEN Broker_Chrg     
                        ELSE 0 END),     
                Service_Tax = Sum(    
                CASE     
                        WHEN Service_chrg = 0     
                        THEN NSerTax     
                        ELSE 0 END ),    
                NSerTax = Sum(    
                CASE     
                        WHEN Service_chrg = 0     
                        THEN NSerTax     
                        ELSE 0 END ),    
                turn_tax = Sum(    
                CASE     
                        WHEN TurnOver_tax = 1     
                        THEN turn_tax     
                        ELSE 0 END),     
                Ins_chrg = Sum(    
                CASE     
                        WHEN Insurance_chrg = 1     
                        THEN Ins_chrg     
                        ELSE 0 END),     
                other_chrg = Sum(    
                CASE     
                        WHEN c2.Other_chrg = 1     
                        THEN S.other_chrg     
                        ELSE 0 END) ,     
                sebi_tax = Sum(    
                CASE     
                        WHEN Sebi_Turn_tax = 1     
                        THEN sebi_tax     
                        ELSE 0 END),     
                Sauda_Date1 = Left(Convert(Varchar,Sauda_date,109),11),     
                PQty        = Sum(    
                CASE     
                        WHEN Sell_Buy = 1     
                        THEN TradeQty     
                        ELSE 0 END),     
                SQty = Sum(    
                CASE     
                        WHEN Sell_Buy = 2     
                        THEN TradeQty     
                        ELSE 0 END),     
                PRate = (    
                CASE     
                        WHEN Sell_Buy = 1     
                        THEN Sum(MarketRate*TradeQty)/Sum(TradeQty)     
                        ELSE 0 END),     
                SRate = (    
                CASE     
                        WHEN Sell_Buy = 2     
                        THEN Sum(MarketRate*TradeQty)/Sum(TradeQty)     
                        ELSE 0 END),     
                PBrok = (    
                CASE     
                        WHEN Sell_Buy = 1     
                        THEN Sum(NBrokApp*TradeQty)/Sum(TradeQty) + (    
                        CASE     
                                WHEN Service_Chrg = 1     
                                THEN Sum(NSertax)/Sum(TradeQty)     
                                ELSE 0 END)     
                        ELSE 0 END),     
                SBrok = (    
                CASE     
                        WHEN Sell_Buy = 2     
                        THEN Sum(NBrokApp*TradeQty)/Sum(TradeQty) + (    
                        CASE     
                                WHEN Service_Chrg = 1     
                                THEN Sum(NSertax)/Sum(TradeQty)     
                                ELSE 0 END)     
                        ELSE 0 END),     
             	PNetRate = (    
                CASE     
                        WHEN Sell_Buy = 1     
                        THEN Sum(N_NetRate*TradeQty)/Sum(TradeQty) + (    
                        CASE     
                                WHEN Service_Chrg = 1     
                                THEN Sum(NSertax)/Sum(TradeQty)     
                                ELSE 0 END)     
                        ELSE 0 END),     
                SNetRate = (    
                CASE     
                        WHEN Sell_Buy = 2     
                        THEN Sum(N_NetRate*TradeQty)/Sum(TradeQty) - (    
                        CASE     
                                WHEN Service_Chrg = 1     
                                THEN Sum(NSertax)/Sum(TradeQty)     
                                ELSE 0 END)     
                        ELSE 0 END),     
                PAmt = (    
                CASE     
                        WHEN Sell_Buy = 1     
                        THEN Sum(TradeQty*N_NetRate) + ((    
                        CASE     
                                WHEN Service_Chrg = 1     
                                THEN Sum(NSertax)/Sum(TradeQty)     
                                ELSE 0 END))     
                        ELSE 0 END),     
                SAmt = (    
                CASE     
                        WHEN Sell_Buy = 2     
                        THEN Sum(TradeQty*N_NetRate) - ((    
                        CASE     
                                WHEN Service_Chrg = 1     
                                THEN Sum(NSertax)/Sum(TradeQty)     
                                ELSE 0 END))     
                        ELSE 0 END),     
                Brokerage = Sum(TradeQty*NBrokApp) + (    
                CASE     
                        WHEN Service_Chrg = 1     
                        THEN Sum(NserTax)     
                        ELSE 0 END),     
                S.Sett_No,     
                S.Sett_Type,     
                TradeType = '  ',     
                Tmark     = '  ',     
                Partyname = c1.Long_name,     
                c1.l_address1,    
                c1.l_address2,    
                c1.l_address3,     
                c1.l_city,    
                c1.l_state,    
                c1.l_zip,     
                c2.service_chrg,    
                c1.Branch_cd ,    
                c1.sub_broker,    
                c1.pan_gir_no,     
                c1.Off_Phone1,    
                c1.Off_Phone2,    
                Printf,    
                Mapidid,     
		UCC_CODE,
                ISIN = CONVERT(VARCHAR(12),''),  
		trader,
 	  	SEBI_NO = FD_Code,
		Participant_Code=BankId,
		CUSTODIANCODE = CONVERT(VARCHAR(50), CLTDPNO), 
		MRounding = 4,
		BRounding = 4,
		NRounding = 4
        INTO    #INSTCONTCUMBILL     
        FROM    SETTLEMENT S     
        WITH    
                (    
                        NOLOCK    
                )     
        LEFT OUTER JOIN ucc_client uc     
        WITH    
                (    
                        NOLOCK    
                )     
                ON ( s.party_code = uc.party_code ),     
                SETT_MST M     
        WITH    
                (    
                        NOLOCK    
                )    
                ,     
                SCRIP1 S1     
        WITH    
                (    
                        NOLOCK    
                )    
                ,     
                SCRIP2 S2     
        WITH    
                (    
                        NOLOCK    
                )    
                ,     
                CLIENT1 c1     
        WITH    
                (    
                        NOLOCK    
                )    
                ,     
                CLIENT2 c2     
        WITH    
                (    
                        NOLOCK    
                )     
        WHERE   c1.cl_code        = c2.cl_code     
                AND C2.party_code = S.party_code     
                AND S.Scrip_Cd    = S2.Scrip_CD     
                AND S.Series      = S2.Series     
                AND S1.Co_Code    = S2.Co_Code     
                AND S1.Series     = S2.Series     
                AND S.Sett_No     = M.Sett_No     
                AND S.Sett_Type   = M.Sett_Type     
                AND S.Sett_Type   = @Sett_Type     
                AND Sauda_date Like @Sauda_Date + '%'     
                AND s.Party_code BETWEEN @FromParty_Code AND @ToParty_Code     
                AND S.Contractno BETWEEN @FromContractno AND @ToContractno     
                AND s.tradeqty  > 0     
                AND @STATUSNAME = (    
                CASE     
                        WHEN @STATUSID = 'BRANCH'     
                        THEN C1.BRANCH_CD     
                        WHEN @STATUSID = 'SUBBROKER'     
                        THEN C1.SUB_BROKER     
                  WHEN @STATUSID = 'TRADER'     
                        THEN C1.TRADER     
                        WHEN @STATUSID = 'FAMILY'     
                        THEN C1.FAMILY     
                        WHEN @STATUSID = 'AREA'     
                        THEN C1.AREA     
                        WHEN @STATUSID = 'REGION'     
                        THEN C1.REGION     
                        WHEN @STATUSID = 'CLIENT'     
                        THEN C2.PARTY_CODE     
                        ELSE 'BROKER' END)     
                AND Branch_cd >= @FROMBranch     
                AND Branch_cd <= @TOBranch     
                AND Sub_Broker >= @FROMSub_Broker     
                AND Sub_Broker <= @TOSub_Broker     
        GROUP BY ContractNo,     
                S.Party_code,     
                Left(Convert(Varchar,Sauda_Date,109),11),     
                S.Scrip_Cd,     
                S.Series,     
                S1.Short_Name,     
                Sell_Buy,     
                S.Sett_No,     
                S.Sett_Type,     
                c1.Long_name,     
                l_address1,     
                l_address2,     
                l_address3,     
                l_city,     
                l_state,    
                l_zip,     
                service_chrg,     
                Branch_cd,     
                sub_broker,     
                pan_gir_no,     
                Off_Phone1,     
                Off_Phone2,     
                Printf,     
                Mapidid,  
		UCC_CODE,
		trader,
 	  	FD_Code,
		BankId,
		CLTDPNO 
  
        UPDATE #INSTCONTCUMBILL     
                SET ISIN = M.ISIN     
        FROM    MULTIISIN M     
        WHERE   M.SCRIP_CD   = #INSTCONTCUMBILL.SCRIP_CD     
                AND M.SERIES = (       
                CASE     
                        WHEN #INSTCONTCUMBILL.SERIES = 'BL'     
                        THEN 'EQ'     
                        WHEN #INSTCONTCUMBILL.SERIES = 'IL'     
                        THEN 'EQ'     
                        ELSE #INSTCONTCUMBILL.SERIES END)     
                AND VALID = 1     
        UPDATE #INSTCONTCUMBILL     
                SET ORDER_NO = S.ORDER_NO,     
                ORDER_TIME   = (    
                CASE     
                        WHEN CPID = 'NIL'     
                        THEN '        '     
                        ELSE Right(CpId,8) END),     
                TM       = CONVERT(VARCHAR,S.SAUDA_DATE,108),     
                TRADE_NO = S.TRADE_NO     
        FROM    SETTLEMENT S     
        WITH    
                (    
                        NOLOCK    
                )     
        WHERE   S.SAUDA_DATE LIKE @SAUDA_DATE + '%'     
                AND S.SCRIP_CD   = #INSTCONTCUMBILL.SCRIP_CD     
                AND S.SERIES     = #INSTCONTCUMBILL.SERIES     
                AND S.PARTY_CODE = #INSTCONTCUMBILL.PARTY_CODE     
                AND S.CONTRACTNO = #INSTCONTCUMBILL.CONTRACTNO     
                AND S.SELL_BUY   = #INSTCONTCUMBILL.SELL_BUY 

	Update #INSTCONTCUMBILL set MRounding = T.MarketRate,
	BRounding = T.Brokerage,
	NRounding = T.NetRate,
	PRate = Round(PRate,cast(T.MarketRate as int)),
	SRate = Round(SRate,cast(T.MarketRate as int)),
	PBrok = Round(PBrok,cast(T.Brokerage as int)),
	SBrok = Round(SBrok,cast(T.Brokerage as int)),
	Brokerage = (Round(PBrok,cast(T.Brokerage as int)) + Round(SBrok,cast(T.Brokerage as int))) * (PQty + SQty),
	PNetRate = Round((Round(PRate,cast(T.MarketRate as int)) + Round(PBrok,cast(T.Brokerage as int))),cast(T.MarketRate as int)),
	SNetRate = Round((Round(SRate,cast(T.MarketRate as int)) - Round(SBrok,cast(T.Brokerage as int))),cast(T.MarketRate as int)),
	PAmt = Round((Round(PRate,cast(T.MarketRate as int)) + Round(PBrok,cast(T.Brokerage as int))),cast(T.MarketRate as int))*PQty,
	SAmt = Round((Round(SRate,cast(T.MarketRate as int)) - Round(SBrok,cast(T.Brokerage as int))),cast(T.MarketRate as int))*SQty
	From INSTClient_TBl T
	Where #INSTCONTCUMBILL.Party_Code = T.PartyCode
	

	UPDATE #INSTCONTCUMBILL 
		SET CUSTODIANCODE = CUSTODIAN.SHORT_NAME
	FROM 
		CUSTODIAN 
	WHERE 
		#INSTCONTCUMBILL.CUSTODIANCODE = CUSTODIAN.CUSTODIANCODE


	SELECT  
	OrderByFlag = (Case When @ColName = 'ORD_N' 
			  Then PartyName
			  When @ColName = 'ORD_P'
			  Then Party_Code
			  When @ColName = 'ORD_BP'
			  Then RTrim(LTrim(Branch_Cd)) + RTrim(LTrim(Party_Code))
			  When @ColName = 'ORD_BN'
			  Then RTrim(LTrim(Branch_Cd)) + RTrim(LTrim(PartyName))
			  When @ColName = 'ORD_DP'
			  Then RTrim(LTrim(Branch_Cd)) + RTrim(LTrim(Sub_Broker)) + RTrim(LTrim(Trader)) + RTrim(LTrim(Party_Code))
			  When @ColName = 'ORD_DN'
			  Then RTrim(LTrim(Branch_Cd)) + RTrim(LTrim(Sub_Broker)) + RTrim(LTrim(Trader)) + RTrim(LTrim(PartyName))
			  Else RTrim(LTrim(Branch_Cd)) + RTrim(LTrim(Sub_Broker)) + RTrim(LTrim(Trader)) + RTrim(LTrim(Party_Code))
		    End),		
		ContractNo,    
                Party_code,    
                Order_No,    
                Order_TIME,    
                TM,    
                Trade_no,    
                Scrip_Cd,    
                Series,    
                ScripName,
		PScripName = (
		CASE 
			WHEN SELL_BUY=1 
			THEN ScripName 
			ELSE '' END), 
		SScripName = (
		CASE 
			WHEN SELL_BUY=2 
			THEN ScripName 
			ELSE '' END), 
                SDT,    
                Sell_Buy,    
                Broker_Chrg,    
                Service_Tax,       
                NSerTax,       
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
                turn_tax,    
                Ins_chrg,       
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
                other_chrg,    
                sebi_tax,    
                Sauda_Date1,    
		QTY = (PQTY + SQTY),
                PQty,    
                SQty,       
                RATE = PRATE + SRATE,       
                PRate,    
                SRate,      
                BROK = PBROK+SBROK,       
                PBrok,    
                SBrok,       
     		NETRATE = PNETRATE +SNETRATE,       
                PNetRate,    
                SNetRate,       
                AMT = (     
                CASE     
                        WHEN SELL_BUY = 1     
                        THEN -PAMT     
          		ELSE SAMT END),     
                PAmt,    
                SAmt,       
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
                Brokerage,
                PBROKERAGE=(CASE WHEN SELL_BUY = 1 THEN BROKERAGE ELSE 0 END),   
                SBROKERAGE=(CASE WHEN SELL_BUY = 2 THEN BROKERAGE ELSE 0 END),       
                Sett_No,    
                Sett_Type,    
                TradeType,    
                Tmark,    
                Partyname,    
                l_address1,    
                l_address2,    
                l_address3,    
                l_city,    
                l_state,    
                l_zip,    
                service_chrg,    
                Branch_cd,    
                sub_broker,    
                pan_gir_no,    
                Off_Phone1,    
                Off_Phone2,    
                Printf,    
                Mapidid,    
		UCC_CODE,
                ISIN,  
  		trader,
 	  	SEBI_NO,
		Participant_Code,
		CUSTODIANCODE,
		MRounding,
		BRounding,
		NRounding
        FROM    #INSTCONTCUMBILL     
        ORDER BY
		OrderByFlag, 
		Branch_cd,     
                sub_broker,     
                Party_code,     
                ScripName,     
                ContractNo,     
                Sett_No,     
                Sett_Type,     
                Order_No,     
                Trade_No

GO
