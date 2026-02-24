-- Object: PROCEDURE dbo.V2_CONTCUMBILL_SECTION_HISTORY
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------
















CREATE     PROC V2_CONTCUMBILL_SECTION_HISTORY
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
	@CONTFLAG VARCHAR(10)
 ) 
AS 

Declare @ColName Varchar(6),
        @SDT DateTime 

Select @SDT = Convert(DateTime,@SAUDA_DATE)

Select @ColName = ''
IF @CONTFLAG = 'CONTRACT' 
	Select @ColName = Rpt_Code From V2_CONTRACTPRINT_SETTING 
	Where Rpt_Type = 'ORDER' And Rpt_PrintFlag = 1
ELSE
	Select @ColName = Rpt_Code From V2_CONTRACTPRINT_SETTING 
	Where Rpt_Type = 'ORDER' And Rpt_PrintFlag_Digi = 1

        SET NOCOUNT ON SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
        SELECT  Contractno,   
                Billno,   
                Trade_No,   
                Party_Code,   
                Scrip_Cd,   
                Tradeqty,   
                Series,   
                Order_No, 
                Marketrate,   
                Sauda_Date,   
                Sell_Buy, 
                Settflag,   
                Brokapplied,   
                Netrate,   
                Amount,   
                Ins_Chrg,   
                Turn_Tax,   
                Other_Chrg,   
                Sebi_Tax,   
                Broker_Chrg,   
                Service_Tax,   
                Billflag,   
                Sett_No,   
                Nbrokapp,   
                Nsertax,   
                N_Netrate,   
                Sett_Type,   
                Tmark,
		cpid
        INTO    #SETT 
        FROM    HISTORY 
        WHERE   1 = 2 
        INSERT 
        INTO    #SETT 
        SELECT  Contractno,   
                Billno,   
                Trade_No = '00000000000',   
                Party_Code,   
                Scrip_Cd,   
                Tradeqty,   
                Series,   
                ORDER_NO   ='0000000000000000', 
                Marketrate,   
                Sauda_Date=Left(Sauda_Date,11),   
                Sell_Buy, 
                Settflag,   
                Brokapplied,   
                Netrate,   
                Amount,   
                Ins_Chrg,   
                Turn_Tax,   
                Other_Chrg,   
                Sebi_Tax,   
                Broker_Chrg,   
                Service_Tax,   
                Billflag,   
                Sett_No,   
                Nbrokapp,   
                Nsertax,   
                N_Netrate,   
                Sett_Type,   
                Tmark,
		cpid = '        '
        FROM    HISTORY 
        WHERE   SETT_No       = @SETT_NO 
                AND SETT_TYPE = @SETT_TYPE 
                AND SAUDA_DATE NOT LIKE @SAUDA_DATE + '%' 
                AND AUCTIONPART NOT IN ('AP', 'AR') 
		And MarketRate > 0
		AND PARTY_CODE >= @FROMPARTY_CODE AND PARTY_CODE <= @TOPARTY_CODE

        INSERT 
        INTO    #SETT 
        SELECT  Contractno,   
                Billno,   
                Trade_No,   
                Party_Code,   
                Scrip_Cd,   
                Tradeqty,   
                Series,   
                Order_No, 
                Marketrate,   
                Sauda_Date,   
                Sell_Buy, 
                Settflag,   
                Brokapplied,   
                Netrate,   
                Amount,   
                Ins_Chrg,   
                Turn_Tax,   
                Other_Chrg,   
                Sebi_Tax,   
                Broker_Chrg,   
                Service_Tax,   
                Billflag,   
                Sett_No,   
                Nbrokapp,   
                Nsertax,   
                N_Netrate,   
                Sett_Type,   
                Tmark,
		cpid
        FROM    HISTORY 
        WHERE   SETT_TYPE = @SETT_TYPE 
                AND SAUDA_DATE LIKE @SAUDA_DATE + '%' 
                AND AUCTIONPART NOT IN ('AP', 'AR') 
		And MarketRate > 0
		AND PARTY_CODE >= @FROMPARTY_CODE AND PARTY_CODE <= @TOPARTY_CODE

        INSERT 
        INTO    #SETT 
        SELECT  Contractno,   
                Billno,   
                Trade_No,   
                Party_Code,   
                Scrip_Cd,   
                Tradeqty,   
                Series,   
                Order_No, 
                Marketrate,   
                Sauda_Date,   
                Sell_Buy, 
                Settflag,   
                Brokapplied,   
                Netrate,   
                Amount,   
                Ins_Chrg,   
                Turn_Tax,   
                Other_Chrg,   
                Sebi_Tax,   
                Broker_Chrg,   
                Service_Tax,   
                Billflag,   
                Sett_No,   
                Nbrokapp,   
                Nsertax,   
                N_Netrate,   
                Sett_Type,   
                Tmark,
		cpid
        FROM    SETTLEMENT 
        WHERE   SETT_TYPE = @SETT_TYPE 
                AND SAUDA_DATE LIKE @SAUDA_DATE + '%' 
                AND AUCTIONPART NOT IN ('AP', 'AR') 
		And MarketRate > 0
		AND PARTY_CODE >= @FROMPARTY_CODE AND PARTY_CODE <= @TOPARTY_CODE


        DELETE 
        FROM    #SETT 
        WHERE   SAUDA_DATE > @SAUDA_DATE + ' 23:59:59' 
        CREATE INDEX [DELPOS] 
                ON [dbo].[#SETT] 
                ( 
                        [Sett_No], 
                        [Sett_Type], 
                        [PARTY_CODE], 
                        [Scrip_Cd], 
                        [Series] 
                ) 

	select distinct S2.Scrip_Cd, S2.Series, Short_Name Into #Scrip
	From Scrip1 S1, Scrip2 S2, #Sett S
	Where S1.CO_CODE   = S2.CO_CODE   
	AND S2.SERIES    = S1.SERIES   
	AND S2.SCRIP_CD  = S.SCRIP_CD   
	AND S2.SERIES    = S.SERIES
	
	CREATE CLUSTERED INDEX [scr]   
	        ON [dbo].[#Scrip]   
	        (   
	                [SCRIP_CD],
			[SERIES]
	        )

                /*=========================================================================                                  
                /*FOR THE #SETT*/ 
                =========================================================================*/ 
        SELECT  C2.PARTY_CODE, 
                C1.LONG_NAME, 
                C1.L_ADDRESS1, 
                C1.L_ADDRESS2, 
                C1.L_ADDRESS3, 
                C1.L_CITY, 
                C1.L_STATE, 
                C1.L_ZIP, 
                C1.BRANCH_CD , 
                C1.SUB_BROKER, 
                C1.TRADER, 
                C1.PAN_GIR_NO, 
                C1.OFF_PHONE1, 
                C1.OFF_PHONE2, 
                PRINTF, 
                MAPIDID,
		UCC_CODE,
                C2.SERVICE_CHRG, 
                BROKERNOTE, 
                TURNOVER_TAX, 
                SEBI_TURN_TAX, 
                C2.OTHER_CHRG, 
                INSURANCE_CHRG,
 	  	SEBI_NO = FD_Code,
		Participant_Code=BankId,
		Cl_Type
        INTO    #CLIENTMASTER 
        FROM    CLIENT1 C1 
        WITH   
                (   
                        NOLOCK   
                )   
                , 
                CLIENT2 C2 
        WITH   
                (   
                        NOLOCK   
                ) 
        LEFT OUTER JOIN UCC_CLIENT UC 
        WITH   
                (   
                        NOLOCK   
                ) 
                ON C2.PARTY_CODE = UC.PARTY_CODE 
        WHERE   C2.CL_CODE       = C1.CL_CODE 
                AND C2.PARTY_CODE BETWEEN @FROMPARTY_CODE AND @TOPARTY_CODE 
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
                AND BRANCH_CD >= @FROMBRANCH 
                AND BRANCH_CD <= @TOBRANCH
                AND SUB_BROKER >= @FROMSUB_BROKER 
                AND SUB_BROKER <= @TOSUB_BROKER 
                AND C2.PARTY_CODE IN (SELECT DISTINCT PARTY_CODE FROM #SETT)

        CREATE CLUSTERED INDEX [PARTY]   
                ON [dbo].[#CLIENTMASTER]   
                (   
                        [PARTY_CODE]
                )

	SELECT  CONTRACTNO, 
                S.PARTY_CODE, 
                ORDER_NO, 
                ORDER_TIME=(   
                CASE 
                        WHEN CPID = 'NIL' 
                        THEN '        ' 
                        ELSE Right(CpId,8) END), 
                TM=CONVERT(VARCHAR,SAUDA_DATE,108), 
                TRADE_NO, 
                SAUDA_DATE, 
                S.SCRIP_CD, 
                S.SERIES, 
                SCRIPNAME = ( 
                CASE 
                        WHEN LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11) <> @SAUDA_DATE 
                        THEN 'BF-' 
                        ELSE '' END ) + S2.SHORT_NAME + '   ' , 
                SDT = CONVERT(VARCHAR,@SDT,103), 
                SELL_BUY, 
                BROKER_CHRG =( 
                CASE 
                        WHEN BROKERNOTE = 1 
                        THEN BROKER_CHRG 
                        ELSE 0 END ), 
                TURN_TAX =( 
                CASE 
                        WHEN TURNOVER_TAX = 1 
                        THEN TURN_TAX 
                        ELSE 0 END ), 
                SEBI_TAX =( 
                CASE 
                        WHEN SEBI_TURN_TAX = 1 
                        THEN SEBI_TAX 
                        ELSE 0 END ), 
                OTHER_CHRG =( 
                CASE 
                        WHEN C1.OTHER_CHRG = 1 
                        THEN S.OTHER_CHRG 
                        ELSE 0 END ) , 
                INS_CHRG = ( 
                CASE 
                        WHEN INSURANCE_CHRG = 1 
                        THEN INS_CHRG 
                        ELSE 0 END ), 
                SERVICE_TAX = ( 
                CASE 
                        WHEN SERVICE_CHRG = 0 
                        THEN NSERTAX 
                        ELSE 0 END ), 
                NSERTAX = ( 
                CASE 
                        WHEN SERVICE_CHRG = 0 
                        THEN NSERTAX 
                        ELSE 0 END ), 
                SAUDA_DATE1 = LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11), 
                PQTY        = ( 
                CASE 
                        WHEN SELL_BUY = 1 
                        THEN TRADEQTY 
                        ELSE 0 END ), 
                SQTY = ( 
                CASE 
                        WHEN SELL_BUY = 2 
                        THEN TRADEQTY 
                        ELSE 0 END ), 
                PRATE = ( 
                CASE 
                        WHEN SELL_BUY = 1 
                        THEN MARKETRATE 
                        ELSE 0 END ), 
                SRATE = ( 
                CASE 
                        WHEN SELL_BUY = 2 
                        THEN MARKETRATE 
                        ELSE 0 END ), 
                PBROK = ( 
                CASE 
                        WHEN SELL_BUY = 1 
                        THEN NBROKAPP + ( 
                        CASE 
                                WHEN SERVICE_CHRG = 1 
                                THEN NSERTAX/TRADEQTY 
                                ELSE 0 END ) 
                        ELSE 0 END ), 
                SBROK = ( 
                CASE 
                        WHEN SELL_BUY = 2 
                        THEN NBROKAPP + ( 
                        CASE 
                                WHEN SERVICE_CHRG = 1 
                                THEN NSERTAX/TRADEQTY 
                                ELSE 0 END ) 
                        ELSE 0 END ), 
                PNETRATE = ( 
                CASE 
                        WHEN SELL_BUY = 1 
                        THEN N_NETRATE + ( 
                        CASE 
                                WHEN SERVICE_CHRG = 1 
                                THEN NSERTAX/TRADEQTY 
                                ELSE 0 END ) 
                        ELSE 0 END ), 
                SNETRATE = ( 
                CASE 
                        WHEN SELL_BUY = 2 
                        THEN N_NETRATE - ( 
                        CASE 
                                WHEN SERVICE_CHRG = 1 
                                THEN NSERTAX/TRADEQTY 
                                ELSE 0 END ) 
                        ELSE 0 END ), 
                PAMT = ( 
                CASE 
                        WHEN SELL_BUY = 1 
                        THEN TRADEQTY*(N_NETRATE + ( 
                        CASE 
                                WHEN SERVICE_CHRG = 1 
                                THEN NSERTAX/TRADEQTY 
                                ELSE 0 END )) 
                        ELSE 0 END ), 
                SAMT = ( 
                CASE 
                        WHEN SELL_BUY = 2 
                        THEN TRADEQTY*(N_NETRATE - ( 
                        CASE 
                                WHEN SERVICE_CHRG = 1 
                                THEN NSERTAX/TRADEQTY 
                                ELSE 0 END )) 
                        ELSE 0 END ), 
                BROKERAGE = TRADEQTY*NBROKAPP+( 
                CASE 
                        WHEN SERVICE_CHRG = 1 
                        THEN NSERTAX 
                        ELSE 0 END ), 
                S.SETT_NO, 
                S.SETT_TYPE, 
                TRADETYPE = '  ', 
                TMARK     = 
                CASE 
                        WHEN BILLFLAG = 1 
                        OR BILLFLAG   = 4 
                        OR BILLFLAG   = 5 
                        THEN 'D' 
                        ELSE '' END , 
                /*TO DISPLAY THE HEADER PART*/ 
                PARTYNAME = C1.LONG_NAME, 
                C1.L_ADDRESS1, 
                C1.L_ADDRESS2, 
                C1.L_ADDRESS3, 
                C1.L_CITY,
		C1.L_STATE, 
                C1.L_ZIP, 
                C1.SERVICE_CHRG, 
                C1.BRANCH_CD , 
                C1.SUB_BROKER, 
                C1.TRADER, 
                C1.PAN_GIR_NO, 
                C1.OFF_PHONE1, 
                C1.OFF_PHONE2, 
                PRINTF, 
                MAPIDID, 
		UCC_CODE,
                ORDERFLAG  = 0, 
		SCRIPNAMEForOrderBy=S2.SHORT_NAME,
                SCRIPNAME1 = Convert(Varchar,(Case When Cl_Type = 'NRI' 
				   Then LTRIM(RTRIM(S2.SHORT_NAME)) + '_' + LTRIM(RTRIM(Sell_Buy)) 
			           Else '' 
			      End), 52),       
		SEBI_NO,
		Participant_Code,
		ActSell_buy = Sell_buy
        INTO    #CONTSETT 
        FROM    #SETT S 
        WITH   
                (   
                        NOLOCK   
                )   
                , 
                #CLIENTMASTER C1 
        WITH   
                (   
                        NOLOCK   
                )   
                , 
                SETT_MST M 
        WITH   
                (   
                        NOLOCK   
                )   
                , 
                #SCRIP S2 
        WHERE   S.SETT_NO       = @SETT_NO 
                AND S.SETT_TYPE = @SETT_TYPE 
                AND S.PARTY_CODE BETWEEN @FROMPARTY_CODE AND @TOPARTY_CODE 
                AND S.SETT_NO   = M.SETT_NO 
                AND S.SETT_TYPE = M.SETT_TYPE 
                AND M.END_DATE LIKE @SAUDA_DATE + '%' 
                AND S2.SCRIP_CD  = S.SCRIP_CD 
                AND S2.SERIES    = S.SERIES 
                AND S.PARTY_CODE = C1.PARTY_CODE 
                AND S.TRADEQTY   > 0 

                /*=========================================================================                                  
                /* ND RECORD BROUGHT FORWARD FOR SAME DAY OR PREVIOUS DAYS */ 
                =========================================================================*/ 
        INSERT 
        INTO    #CONTSETT SELECT  CONTRACTNO, 
                S.PARTY_CODE, 
                ORDER_NO, 
                ORDER_TIME=(   
                CASE 
                        WHEN CPID = 'NIL' 
                        THEN '        ' 
                        ELSE Right(CpId,8) END), 
                TM=CONVERT(VARCHAR,SAUDA_DATE,108), 
                TRADE_NO, 
                SAUDA_DATE, 
                S.SCRIP_CD, 
                S.SERIES, 
                SCRIPNAME = ( 
                CASE 
                        WHEN LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11) = @SAUDA_DATE 
                        THEN 'ND-' 
                        ELSE 'BF-' END ) + S2.SHORT_NAME, 
                SDT = CONVERT(VARCHAR,@SDT,103), 
                SELL_BUY, 
                BROKER_CHRG =0, 
                TURN_TAX    =0, 
                SEBI_TAX    =0, 
                S.OTHER_CHRG, 
                INS_CHRG    =0, 
                SERVICE_TAX = 0, 
                NSERTAX     =0, 
                SAUDA_DATE1 = LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11), 
                PQTY        = ( 
                CASE 
                        WHEN SELL_BUY = 1 
                        THEN TRADEQTY 
                        ELSE 0 END ), 
                SQTY = ( 
                CASE 
                        WHEN SELL_BUY = 2 
                        THEN TRADEQTY 
                        ELSE 0 END ), 
                PRATE = ( 
                CASE 
                        WHEN SELL_BUY = 1 
                        THEN MARKETRATE 
                        ELSE 0 END ), 
                SRATE = ( 
                CASE 
                        WHEN SELL_BUY = 2 
                        THEN MARKETRATE 
                        ELSE 0 END ), 
                PBROK    = 0, 
                SBROK    = 0, 
                PNETRATE = ( 
                CASE 
                        WHEN SELL_BUY = 1 
                        THEN MARKETRATE 
                        ELSE 0 END ), 
                SNETRATE = ( 
                CASE 
                        WHEN SELL_BUY = 2 
                        THEN MARKETRATE 
                        ELSE 0 END ), 
                PAMT = ( 
                CASE 
                        WHEN SELL_BUY = 1 
                        THEN TRADEQTY*MARKETRATE 
                        ELSE 0 END ), 
                SAMT = ( 
                CASE 
                        WHEN SELL_BUY = 2 
                        THEN TRADEQTY*MARKETRATE 
                        ELSE 0 END ), 
                BROKERAGE = 0, 
                S.SETT_NO, 
                S.SETT_TYPE, 
                TRADETYPE = 'BF', 
                TMARK     = 
                CASE 
                        WHEN BILLFLAG = 1 
                        OR BILLFLAG   = 4 
                        OR BILLFLAG   = 5 
                        THEN '' 
                        ELSE '' END , 
                /*TO DISPLAY THE HEADER PART*/ 
                PARTYNAME = C1.LONG_NAME, 
                C1.L_ADDRESS1, 
                C1.L_ADDRESS2, 
                C1.L_ADDRESS3, 
                C1.L_CITY, 
		C1.L_STATE,
                C1.L_ZIP, 
                C1.SERVICE_CHRG, 
                C1.BRANCH_CD , 
                C1.SUB_BROKER, 
                C1.TRADER, 
                C1.PAN_GIR_NO, 
                C1.OFF_PHONE1, 
                C1.OFF_PHONE2 , 
                PRINTF, 
                MAPIDID, 
		UCC_CODE,
                ORDERFLAG  = 0, 
		SCRIPNAMEForOrderBy=S2.SHORT_NAME,
                SCRIPNAME1 = Convert(Varchar,(Case When Cl_Type = 'NRI' 
				   Then LTRIM(RTRIM(S2.SHORT_NAME)) + '_' + LTRIM(RTRIM(Sell_Buy)) 
			           Else '' 
			      End), 52),       
		SEBI_NO,
		Participant_Code,
		ActSell_buy = Sell_buy
        FROM    #SETT S 
        WITH   
                (   
                        NOLOCK   
                )   
                , 
                #CLIENTMASTER C1 
        WITH   
                (   
                        NOLOCK   
                )   
                , 
                SETT_MST M 
        WITH   
                (   
                        NOLOCK   
                )   
                , 
                #SCRIP S2 
        WHERE   SAUDA_DATE <= @SAUDA_DATE + ' 23:59' 
                AND S.PARTY_CODE BETWEEN @FROMPARTY_CODE AND @TOPARTY_CODE 
                AND M.END_DATE  > @SAUDA_DATE + ' 23:59:59' 
                AND S.SETT_TYPE = @SETT_TYPE --AND S.SETT_NO > @SETT_NO AND S.SETT_TYPE = @SETT_TYPE               
                AND S.SETT_NO   = M.SETT_NO 
                AND S.SETT_TYPE = M.SETT_TYPE 
                AND M.END_DATE NOT LIKE @SAUDA_DATE + '%' 
                AND S2.SCRIP_CD  = S.SCRIP_CD 
                AND S2.SERIES    = S.SERIES 
                AND S.PARTY_CODE = C1.PARTY_CODE 
                AND S.TRADEQTY   > 0 
                /*=========================================================================                                  
                /* ND RECORD CARRY FORWARD FOR SAME DAY OR PREVIOUS DAYS */ 
                =========================================================================*/ 
        INSERT 
        INTO    #CONTSETT SELECT  CONTRACTNO, 
                S.PARTY_CODE, 
                ORDER_NO, 
                ORDER_TIME=(   
                CASE 
                        WHEN CPID = 'NIL' 
                        THEN '        ' 
                        ELSE Right(CpId,8) END), 
                TM=CONVERT(VARCHAR,SAUDA_DATE,108), 
                TRADE_NO, 
                SAUDA_DATE, 
                S.SCRIP_CD, 
                S.SERIES, 
                SCRIPNAME = 'CF-' + S2.SHORT_NAME, 
                SDT       = CONVERT(VARCHAR,@SDT,103), 
                SELL_BUY  =( 
                CASE 
                        WHEN SELL_BUY = 1 
                        THEN 2 
                        ELSE 1 END ), 
                BROKER_CHRG =0, 
                TURN_TAX    =0, 
                SEBI_TAX    =0, 
                S.OTHER_CHRG, 
                INS_CHRG    = 0, 
                SERVICE_TAX = 0, 
                NSERTAX     =0, 
                SAUDA_DATE1 = LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11), 
                PQTY        = ( 
                CASE 
                        WHEN SELL_BUY = 2 
                        THEN TRADEQTY 
                        ELSE 0 END), 
                SQTY = ( 
                CASE 
                        WHEN SELL_BUY = 1 
                        THEN TRADEQTY 
                        ELSE 0 END ), 
                PRATE = ( 
                CASE 
                        WHEN SELL_BUY = 2 
                        THEN MARKETRATE 
                        ELSE 0 END ), 
                SRATE = ( 
                CASE 
                        WHEN SELL_BUY = 1 
                        THEN MARKETRATE 
                        ELSE 0 END ), 
                PBROK    = 0, 
                SBROK    = 0, 
                PNETRATE = ( 
                CASE 
                        WHEN SELL_BUY = 2 
                        THEN MARKETRATE 
                        ELSE 0 END ), 
                SNETRATE = ( 
                CASE 
                        WHEN SELL_BUY = 1 
                        THEN MARKETRATE 
                        ELSE 0 END ), 
                PAMT = ( 
                CASE 
                        WHEN SELL_BUY = 2 
                        THEN TRADEQTY*MARKETRATE 
                        ELSE 0 END ), 
                SAMT = ( 
                CASE 
                        WHEN SELL_BUY = 1 
                        THEN TRADEQTY*MARKETRATE 
                        ELSE 0 END ), 
                BROKERAGE = 0, 
                S.SETT_NO, 
                S.SETT_TYPE, 
                TRADETYPE = 'CF', 
                TMARK     = 
                CASE 
                        WHEN BILLFLAG = 1 
                        OR BILLFLAG   = 4 
                        OR BILLFLAG   = 5 
                        THEN '' 
                        ELSE '' END , 
                /*TO DISPLAY THE HEADER PART*/ 
                PARTYNAME = C1.LONG_NAME, 
                C1.L_ADDRESS1, 
                C1.L_ADDRESS2, 
                C1.L_ADDRESS3, 
                C1.L_CITY, 
		C1.L_STATE,
                C1.L_ZIP, 
                C1.SERVICE_CHRG, 
                C1.BRANCH_CD , 
                C1.SUB_BROKER, 
                C1.TRADER, 
                C1.PAN_GIR_NO, 
                C1.OFF_PHONE1, 
                C1.OFF_PHONE2 , 
                PRINTF, 
                MAPIDID, 
		UCC_CODE,
                ORDERFLAG  = 1, 
		SCRIPNAMEForOrderBy=S2.SHORT_NAME,
                SCRIPNAME1 = Convert(Varchar,(Case When Cl_Type = 'NRI' 
				   Then LTRIM(RTRIM(S2.SHORT_NAME)) + '_' + LTRIM(RTRIM(Sell_Buy)) 
			           Else '' 
			      End), 52),
		SEBI_NO,
		Participant_Code,
		ActSell_buy = Sell_buy
        FROM    #SETT S 
        WITH   
                (   
               NOLOCK   
                )   
                , 
                #CLIENTMASTER C1 
        WITH   
                (   
                        NOLOCK   
                )   
                , 
                SETT_MST M 
        WITH   
                (   
                        NOLOCK   
                )   
                , 
                #SCRIP S2 
        WHERE   SAUDA_DATE <= @SAUDA_DATE + ' 23:59' 
                AND S.PARTY_CODE BETWEEN @FROMPARTY_CODE AND @TOPARTY_CODE 
                AND M.END_DATE  > @SAUDA_DATE + ' 23:59:59' 
                AND S.SETT_TYPE = @SETT_TYPE --AND S.SETT_NO > @SETT_NO AND S.SETT_TYPE = @SETT_TYPE               
                AND S.SETT_NO   = M.SETT_NO 
                AND S.SETT_TYPE = M.SETT_TYPE 
                AND M.END_DATE NOT LIKE @SAUDA_DATE + '%' 
                AND S2.SCRIP_CD  = S.SCRIP_CD 
                AND S2.SERIES    = S.SERIES 
                AND S.PARTY_CODE = C1.PARTY_CODE 
                AND S.TRADEQTY   > 0 

	        CREATE INDEX [DELPOS]   
                ON [dbo].[#CONTSETT]   
                (   
                        [SAUDA_DATE],   
                        [Sett_Type],   
                        [PARTY_CODE],   
                        [Scrip_Cd],   
                        [Series]   
                )

		SELECT  CONTRACTNO, 
                PARTY_CODE, 
                ORDER_NO   ='0000000000000000', 
                ORDER_TIME ='        ', 
                TM         ='        ', 
                TRADE_NO   ='00000000000', 
                SAUDA_DATE = LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11), 
                SCRIP_CD, 
                SERIES, 
                SCRIPNAME, 
                SDT, 
                SELL_BUY, 
                BROKER_CHRG =SUM(BROKER_CHRG), 
                TURN_TAX    =SUM(TURN_TAX), 
                SEBI_TAX    =SUM(SEBI_TAX), 
                OTHER_CHRG  =SUM(OTHER_CHRG), 
                INS_CHRG    = SUM(INS_CHRG), 
                SERVICE_TAX = SUM(SERVICE_TAX), 
                NSERTAX     =SUM(NSERTAX), 
                SAUDA_DATE1, 
                PQTY =SUM(PQTY), 
                SQTY =SUM(SQTY), 
                PRATE=( 
                CASE 
                        WHEN SUM(PQTY) > 0 
                        THEN SUM(PRATE*PQTY)/SUM(PQTY) 
                        ELSE 0 END ), 
                SRATE=( 
                CASE 
                        WHEN SUM(SQTY) > 0 
                        THEN SUM(SRATE*SQTY)/SUM(SQTY) 
                        ELSE 0 END ), 
                PBROK=( 
                CASE 
                        WHEN SUM(PQTY) > 0 
                        THEN SUM(PBROK*PQTY)/SUM(PQTY) 
                        ELSE 0 END ), 
                SBROK=( 
                CASE 
                        WHEN SUM(SQTY) > 0 
                        THEN SUM(SBROK*SQTY)/SUM(SQTY) 
                        ELSE 0 END ), 
                PNETRATE=( 
                CASE 
                        WHEN SUM(PQTY) > 0 
                        THEN SUM(PNETRATE*PQTY)/SUM(PQTY) 
                        ELSE 0 END ), 
                SNETRATE=( 
                CASE 
                        WHEN SUM(SQTY) > 0 
                        THEN SUM(SNETRATE*SQTY)/SUM(SQTY) 
                        ELSE 0 END ), 
                PAMT     =SUM(PAMT), 
                SAMT     =SUM(SAMT), 
                BROKERAGE=SUM(BROKERAGE), 
                SETT_NO, 
                SETT_TYPE, 
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
                PRINTF, 
                MAPIDID, 
		UCC_CODE,
                ORDERFLAG,
		SCRIPNAMEForOrderBy, 
                SCRIPNAME1,    
		SEBI_NO,
		Participant_Code,
		ActSell_buy,
                ISIN = CONVERT(VARCHAR(12),'')
        INTO    #CONTSETTNEW 
        FROM    #CONTSETT 
        WITH   
                (   
                        NOLOCK   
                ) 
        WHERE   PRINTF = '3' 
        GROUP BY CONTRACTNO, 
                PARTY_CODE, 
                LEFT(CONVERT(VARCHAR,SAUDA_DATE,109),11), 
                SCRIP_CD, 
                SERIES, 
                SCRIPNAME, 
                SDT, 
                SELL_BUY, 
                SETT_NO, 
                SETT_TYPE, 
                SAUDA_DATE1, 
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
                PRINTF, 
                MAPIDID, 
		UCC_CODE,
                ORDERFLAG,
		SCRIPNAMEForOrderBy,
                SCRIPNAME1,
		SEBI_NO,
		Participant_Code,
		ActSell_buy
        INSERT 
        INTO    #CONTSETTNEW SELECT  *, 
                ISIN = CONVERT(VARCHAR(12),'') 
        FROM    #CONTSETT 
        WITH   
                (   
                        NOLOCK   
                ) 
        WHERE   PRINTF <> '3' 

        CREATE INDEX [DELPOS]   
                ON [dbo].[#CONTSETTNEW]   
                (   
                        [SAUDA_DATE],   
                        [Sett_Type],   
                        [PARTY_CODE],   
                        [Scrip_Cd],   
                        [Series]   
                )

        UPDATE #CONTSETTNEW 
                SET ORDER_NO = S.ORDER_NO, 
                TM           = CONVERT(VARCHAR,S.SAUDA_DATE,108), 
                TRADE_NO     = S.TRADE_NO, 
                ORDER_Time   = S.ORDER_Time 
        FROM    #CONTSETT S 
        WITH   
                (   
                        NOLOCK   
                ) 
        WHERE   S.PRINTF     = #CONTSETTNEW.PRINTF 
                AND S.PRINTF = '3' 
                AND S.SAUDA_DATE LIKE @SAUDA_DATE + '%' 
                AND S.SCRIP_CD      = #CONTSETTNEW.SCRIP_CD 
                AND S.SERIES        = #CONTSETTNEW.SERIES 
                AND S.PARTY_CODE    = #CONTSETTNEW.PARTY_CODE 
                AND S.CONTRACTNO    = #CONTSETTNEW.CONTRACTNO 
                AND S.ActSell_buy   = #CONTSETTNEW.ActSell_buy 
                AND S.SAUDA_DATE = 
                (SELECT MIN(SAUDA_DATE) 
                FROM    #CONTSETT ISETT 
                WITH   
                        (   
                                NOLOCK   
                        ) 
                WHERE   PRINTF = '3' 
                        AND ISETT.SAUDA_DATE LIKE @SAUDA_DATE + '%' 
                        AND S.SCRIP_CD    = ISETT.SCRIP_CD 
                        AND S.SERIES      = ISETT.SERIES 
                        AND S.PARTY_CODE  = ISETT.PARTY_CODE 
                        AND S.CONTRACTNO  = ISETT.CONTRACTNO 
                        AND S.ActSell_buy = ISETT.ActSell_buy 
                ) 
        UPDATE #CONTSETTNEW 
                SET ISIN = M.ISIN 
        FROM    MULTIISIN M 
        WHERE   M.SCRIP_CD   = #CONTSETTNEW.SCRIP_CD    
                AND M.SERIES = (
                CASE 
                        WHEN #CONTSETTNEW.SERIES = 'BL' 
                        THEN 'EQ' 
                        WHEN #CONTSETTNEW.SERIES = 'IL' 
                        THEN 'EQ' 
                        ELSE #CONTSETTNEW.SERIES   END)    
                AND VALID = 1 
	IF (@CONTFLAG = 'CONTRACT') 
	BEGIN 
	SELECT OrderByFlag = (Case When @ColName = 'ORD_N' 
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
		CONTRACTNO,   
                PARTY_CODE,   
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
		QTY = (PQTY + SQTY),
                PQTY,   
                SQTY, 
                RATE = PRATE + SRATE, 
                PRATE,   
                SRATE, 
                BROK = PBROK+SBROK, 
                PBROK,   
                SBROK, 
                NETRATE = PNETRATE +SNETRATE, 
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
                SETT_NO, 
                SETT_TYPE,   
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
                PRINTF,   
                MAPIDID,   
		UCC_CODE,
                ORDERFLAG,
		SCRIPNAMEForOrderBy,
                SCRIPNAME1,
		ISIN,
		SEBI_NO,
		Participant_Code
        FROM    #CONTSETTNEW 
        WITH   
                (   
                        NOLOCK   
                ) 
        WHERE   PRINTF <> 1 
        ORDER BY OrderByFlag,
		BRANCH_CD, 
                SUB_BROKER, 
                TRADER, 
                PARTY_CODE, 
                PARTYNAME,
		SCRIPNAMEForOrderBy,
                SCRIPNAME1, 
		ContractNo Desc,
                ORDERFLAG, 
                SETT_NO, 
                SETT_TYPE,
		TM, 
                ORDER_NO, 
                TRADE_NO 
	END 
        ELSE 
	BEGIN 
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
	CONTRACTNO,
        PARTY_CODE,   
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
	QTY = (PQTY + SQTY),
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
                ELSE 0 END),        AMTSERSTT = (   
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
        SETT_NO, 
        SETT_TYPE,   
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
        PRINTF,   
        MAPIDID,   
	UCC_CODE,
        ORDERFLAG,
	SCRIPNAMEForOrderBy,
        SCRIPNAME1,
	ISIN,
	SEBI_NO,
	Participant_Code
FROM    #CONTSETTNEW
WITH   
        (   
                NOLOCK   
        ) 
ORDER BY
		OrderByFlag,
		BRANCH_CD, 
                SUB_BROKER, 
                TRADER, 
                PARTY_CODE, 
                PARTYNAME,
		SCRIPNAMEForOrderBy,
                SCRIPNAME1,
		ContractNo Desc, 
                ORDERFLAG, 
                SETT_NO, 
                SETT_TYPE, 
		TM,
                ORDER_NO, 
                TRADE_NO 
END

GO
