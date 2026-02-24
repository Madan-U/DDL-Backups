-- Object: PROCEDURE dbo.V2_C_CollateralCalculationSpMS
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



CREATE PROCEDURE [DBO].[V2_C_CollateralCalculationSpMS]
(
    @Exchange Varchar(3), 
    @Segment Varchar(20), 
    @FromParty Varchar(10), 
    @ToParty Varchar(10), 
    @EffDate Varchar(11), 
    @VDate Varchar(11),
    @ShareDb Varchar(20), 
    @ShareDbServer Varchar(15), 
    @Status int OUTPUT
)        
    AS
    /*=======================================================
    exec V2_C_CollateralCalculationSpMS
    @Exchange = 'NSE',
    @Segment = 'FUTURES',
    @FromParty = '0000000000',
    @ToParty = 'ZZZZZZZZZZ',
    @EffDate = 'feb 29 2008',
    @VDate = 'feb 28 2008',
    @ShareDb = 'NSE',
    @ShareDbServer = 'NSE',
    @Status = 1
    =======================================================*/
    SET @Status = 0
    /*=======================================================================
    POPULATE SECURITIES CLIENT WISE SECURITIES COLLATERAL BALANCES
    =======================================================================*/
    CREATE
            TABLE #C_CalculateSecView
            (
                    Party_Code VARCHAR(10)   ,
                    BalQty BigInt            ,
                    Scrip_Cd   VARCHAR(12)   ,
                    Series     VARCHAR(3)    ,
                    ISIN       VARCHAR(20)   ,
                    Group_Code VARCHAR(50)   ,
                    Cl_Rate Money            ,
                    SecAmount Money          ,
                    SecHaircut NUMERIC(18, 2),
                    TotalSecAmount Money     ,
            )
    INSERT
    INTO
            #C_CalculateSecView
    SELECT
            Party_Code,
            BalQty = SUM(
            CASE
                    WHEN drcr = 'D'
                    THEN - qty
                    ELSE qty
            END)             ,
            c.scrip_cd       ,
            Series = c.series,
            c.isin           ,
            Group_Code     = ''  ,
            Cl_Rate        = 0   ,
            SecAmount      = 0   ,
            Haircut        = 0   ,
            TotalSecAmount = 0
    FROM
            C_SecuritiesMst C
    WHERE
            active   = 1
        AND Exchange = @Exchange
        AND Segment  = @Segment
        AND effdate <= @Effdate + ' 23:59:59'
        AND Party_Code BETWEEN @FromParty AND @ToParty
        AND Party_Code <> 'BROKER'
    GROUP BY
            Party_Code,
            c.scrip_cd,
            c.series  ,
            c.isin
    HAVING
            SUM(
            CASE
                    WHEN drcr = 'D'
                    THEN - qty
                    ELSE qty
            END) <> 0
    /*=======================================================================
    POPULATE DISTINCT CLIENT CODES FOR WHOM COLLATERAL CALCULATION IS TO BE DONE
    =======================================================================*/
    CREATE
            TABLE #C_PartyCode
            (
                    Party_Code    VARCHAR(10)   ,
                    Cl_Type       VARCHAR(10)   ,
                    Record_Type   VARCHAR(10)   ,
                    Cash_Compo    NUMERIC(18, 2),
                    NonCash_Compo NUMERIC(18, 2),
                    Cash_NCash    CHAR(1)
            )
    /*======================================
    FIXED DEPOSITS
    ======================================*/
    INSERT
    INTO
            #C_PartyCode
            (
                    Party_Code   ,
                    Record_Type  ,
                    Cash_Compo   ,
                    NonCash_Compo,
                    Cash_NCash
            )
    SELECT DISTINCT
            Party_Code,
            'FD'      ,
            0         ,
            0         ,
            ''
    FROM
            Fixeddepositmst
    WHERE
            Exchange = @Exchange
        AND Segment  = @Segment
        AND Party_Code BETWEEN @FromParty AND @ToParty
    /*======================================
    BANK GUARANTEES
    ======================================*/
    INSERT
    INTO
            #C_PartyCode
            (
                    Party_Code   ,
                    Record_Type  ,
                    Cash_Compo   ,
                    NonCash_Compo,
                    Cash_NCash
            )
    SELECT DISTINCT
            Party_Code,
            'BG'      ,
            0         ,
            0         ,
            ''
    FROM
            BankGuaranteemst
    WHERE
            Exchange = @Exchange
        AND Segment  = @Segment
        AND Party_Code BETWEEN @FromParty AND @ToParty
    /*======================================
    SECURITIES
    ======================================*/
    INSERT
    INTO
            #C_PartyCode
            (
                    Party_Code   ,
                    Record_Type  ,
                    Cash_Compo   ,
                    NonCash_Compo,
                    Cash_NCash
            )
    SELECT DISTINCT
            Party_Code,
            'SEC'     ,
            0         ,
            0         ,
            ''
    FROM
            #C_CalculateSecView
    /*======================================
    CASH MARGINS
    ======================================*/
    INSERT
    INTO
            #C_PartyCode
            (
                    Party_Code   ,
                    Record_Type  ,
                    Cash_Compo   ,
                    NonCash_Compo,
                    Cash_NCash
            )
    SELECT DISTINCT
            Party_Code,
            'MARGIN'  ,
            0         ,
            0         ,
            ''
    FROM
            C_MarginLedger
    WHERE
            Exchange = @Exchange
        AND Segment  = @Segment
        AND Party_Code BETWEEN @FromParty AND @ToParty
    /*======================================
    UPDATE FOR CLIENT TYPE
    ======================================*/
    UPDATE
            #C_PartyCode
    SET
            Cl_Type = C.Cl_Type
    FROM
            ClientMaster C
    WHERE
            #C_PartyCode.party_code = C.Party_Code
    /*==============================================================
    UPDATE FOR CASH COMPOSITION - SETTING AT PARTY LEVEL
    =================================================================*/
    UPDATE
            #C_PartyCode
    SET
            Cash_Compo = Cash
    FROM
            CashComposition
    WHERE
            CashComposition.party_code = #C_PartyCode.Party_code
        AND Exchange                   = @Exchange
        AND Segment                    = @Segment
        AND CLient_Type                = ''
        AND Active                     = 1
        AND EffDate                    =
            (SELECT
                    MAX(Effdate)
            FROM
                    CashComposition
            WHERE
                    EffDate                    <= @EffDate + ' 23:59'
                AND CashComposition.party_code  = #C_PartyCode.party_code
                AND CashComposition.Client_Type = ''
                AND Exchange                    = @Exchange
                AND Segment                     = @Segment
                AND Active                      = 1
            )
    /*===================================================================
    UPDATE FOR CASH COMPOSITION - SETTING AT CLIENT TYPE LEVEL
    ====================================================================*/
    UPDATE
            #C_PartyCode
    SET
            Cash_Compo = Cash
    FROM
            CashComposition
    WHERE
            CashComposition.party_code = ''
        AND Exchange                   = @Exchange
        AND Segment                    = @Segment
        AND CLient_Type                = #C_PartyCode.Cl_Type
        AND Active                     = 1
        AND EffDate                    =
            (SELECT
                    MAX(Effdate)
            FROM
                    CashComposition
            WHERE
                    EffDate                   <= @EffDate + ' 23:59'
                AND CashComposition.party_code = ''
                AND Client_Type                = #C_PartyCode.Cl_Type
                AND Exchange                   = @Exchange
                AND Segment                    = @Segment
                AND Active                     = 1
            )
        AND Cash_Compo = 0
    /*===================================================================
    UPDATE FOR CASH COMPOSITION - SETTING AT GLOBAL LEVEL
    ===================================================================*/
    UPDATE
            #C_PartyCode
    SET
            Cash_Compo = Cash
    FROM
            CashComposition
    WHERE
            CashComposition.party_code = ''
        AND Exchange                   = @Exchange
        AND Segment                    = @Segment
        AND CLient_Type                = ''
        AND Active                     = 1
        AND EffDate                    =
            (SELECT
                    MAX(Effdate)
            FROM
                    CashComposition
            WHERE
                    EffDate                   <= @EffDate + ' 23:59'
                AND CashComposition.party_code = ''
                AND Client_Type                = ''
                AND Exchange                   = @Exchange
                AND Segment                    = @Segment
                AND Active                     = 1
            )
        AND Cash_Compo = 0
    /*==============================================================
    UPDATE FOR NON CASH COMPOSITION - SETTING AT PARTY LEVEL
    =================================================================*/
    UPDATE
            #C_PartyCode
    SET
            NonCash_Compo = NonCash
    FROM
            CashComposition
    WHERE
            CashComposition.party_code = #C_PartyCode.Party_code
        AND Exchange                   = @Exchange
        AND Segment                    = @Segment
        AND CLient_Type                = ''
        AND Active                     = 1
        AND EffDate                    =
            (SELECT
                    MAX(Effdate)
            FROM
                    CashComposition
            WHERE
                    EffDate                   <= @EffDate + ' 23:59'
                AND CashComposition.party_code = #C_PartyCode.party_code
                AND Client_Type                = ''
                AND Exchange                   = @Exchange
                AND Segment                    = @Segment
                AND Active                     = 1
            )
    /*=======================================================================
    UPDATE FOR NON CASH COMPOSITION - SETTING AT CLIENT TYPE LEVEL
    =======================================================================*/
    UPDATE
            #C_PartyCode
    SET
            NonCash_Compo = NonCash
    FROM
            CashComposition
    WHERE
            CashComposition.party_code = ''
        AND Exchange                   = @Exchange
        AND Segment                    = @Segment
        AND CLient_Type                = #C_PartyCode.Cl_Type
        AND Active                     = 1
        AND EffDate                    =
            (SELECT
                    MAX(Effdate)
            FROM
                    CashComposition
            WHERE
                    EffDate                   <= @EffDate + ' 23:59'
                AND CashComposition.party_code = ''
                AND Client_Type                = #C_PartyCode.Cl_Type
                AND Exchange                   = @Exchange
                AND Segment                    = @Segment
                AND Active                     = 1
            )
        AND NonCash_Compo = 0
    /*===================================================================
    UPDATE FOR NON CASH COMPOSITION - SETTING AT GLOBAL LEVEL
    ===================================================================*/
    UPDATE
            #C_PartyCode
    SET
            NonCash_Compo = NonCash
    FROM
            CashComposition
    WHERE
            CashComposition.party_code = ''
        AND Exchange                   = @Exchange
        AND Segment                    = @Segment
        AND CLient_Type                = ''
        AND Active                     = 1
        AND EffDate                    =
            (SELECT
                    MAX(Effdate)
            FROM
                    CashComposition
            WHERE
                    EffDate                   <= @EffDate + ' 23:59'
                AND CashComposition.party_code = ''
                AND Client_Type                = ''
                AND Exchange                   = @Exchange
                AND Segment                    = @Segment
                AND Active                     = 1
            )
        AND NonCash_Compo = 0
    /*=============================================================
    UPDATE FOR INSTR TYPE MST - SETTING AT PARTY LEVEL
    ===============================================================*/
    UPDATE
            #C_PartyCode
    SET
            Cash_NCash = InstruTypeMst.Cash_NCash
    FROM
            InstruTypeMst
    WHERE
            InstruTypeMst.party_code = #C_PartyCode.Party_code
        AND Exchange                 = @Exchange
        AND Segment                  = @Segment
        AND CLient_Type              = ''
        AND Active                   = 1
        AND EffDate                  =
            (SELECT
                    MAX(Effdate)
            FROM
                    InstruTypeMst
            WHERE
                    EffDate                 <= @EffDate + ' 23:59'
                AND InstruTypeMst.party_code = #C_PartyCode.party_code
                AND Client_Type              = ''
                AND Exchange                 = @Exchange
                AND Segment                  = @Segment
                AND Active                   = 1
            )
        AND Instru_Type = Record_Type
    /*==================================================================
    UPDATE FOR INSTR TYPE MST - SETTING AT CLIENT TYPE LEVEL
    ==================================================================*/
    UPDATE
            #C_PartyCode
    SET
            Cash_NCash = InstruTypeMst.Cash_NCash
    FROM
            InstruTypeMst
    WHERE
            InstruTypeMst.party_code = ''
        AND Exchange                 = @Exchange
        AND Segment                  = @Segment
        AND CLient_Type              = #C_PartyCode.Cl_Type
        AND Active                   = 1
        AND EffDate                  =
            (SELECT
                    MAX(Effdate)
            FROM
                    InstruTypeMst
            WHERE
                    EffDate                 <= @EffDate + ' 23:59'
                AND InstruTypeMst.party_code = ''
                AND Client_Type              = #C_PartyCode.Cl_Type
                AND Exchange                 = @Exchange
                AND Segment                  = @Segment
                AND Active                   = 1
            )
        AND Instru_Type             = Record_Type
        AND #C_PartyCode.Cash_NCash = ''
    /*===============================================================
    UPDATE FOR INSTR TYPE MST - SETTING AT GLOBAL LEVEL
    ================================================================*/
    UPDATE
            #C_PartyCode
    SET
            Cash_NCash = InstruTypeMst.Cash_NCash
    FROM
            InstruTypeMst
    WHERE
            InstruTypeMst.party_code = ''
        AND Exchange                 = @Exchange
        AND Segment                  = @Segment
        AND CLient_Type              = ''
        AND Active                   = 1
        AND EffDate                  =
            (SELECT
                    MAX(Effdate)
            FROM
                    InstruTypeMst
            WHERE
                    EffDate                 <= @EffDate + ' 23:59'
                AND InstruTypeMst.party_code = ''
                AND Client_Type              = ''
                AND Exchange                 = @Exchange
                AND Segment                  = @Segment
                AND Active                   = 1
            )
        AND Instru_Type             = Record_Type
        AND #C_PartyCode.Cash_NCash = ''
    /*=======================================================================
    CREATE LATEST CLOSING PRICE INFORMATION FOR VALUATION OF SECURITIES
    =======================================================================*/
    SELECT
            Scrip_Cd,
            Series  ,
            Cl_Rate = MAX(Cl_Rate)
    INTO
            #C_valuation
    FROM
            C_valuation C1
    WHERE
            exchange = @Exchange
        AND Segment  = @Segment
        AND Sysdate  =
            (SELECT
                    MAX(sysdate)
            FROM
                    c_valuation C2
            WHERE
                    exchange    = @Exchange
                AND Segment     = @Segment
                AND sysdate    <= @VDate + ' 23:59:59'
                AND C1.Scrip_Cd = C2.Scrip_cd
                AND C1.series   = C2.series
                AND scrip_cd   IN
                    (SELECT DISTINCT
                            Scrip_Cd
                    FROM
                            #C_CalculateSecView
                    )
            )
        AND scrip_cd IN
            (SELECT DISTINCT
                    Scrip_Cd
            FROM
                    #C_CalculateSecView
            )
    GROUP BY
            Scrip_Cd,
            Series
    /*================================================================
    TAKING DETAILS TO TEMP TABLE
    ================================================================*/
    CREATE
            TABLE #COLLATERALDATA
            (
                    Party_Code    VARCHAR(10)   ,
                    Cl_Type       VARCHAR(10)   ,
                    Record_Type   VARCHAR(10)   ,
                    Cash_Compo    NUMERIC(18, 2),
                    NonCash_Compo NUMERIC(18, 2),
                    MarginAmt Money             ,
                    TotalCash Money             ,
                    OrgTotCash Money            ,
                    TotalNonCash Money          ,
                    OrgTotNonCash Money         ,
                    Cash_NCash CHAR(1)          ,
                    FdAmount Money              ,
                    TotalFdAmount Money         ,
                    BgAmount Money              ,
                    TotalBgAmount Money         ,
                    SecAmount Money             ,
                    TotalSecAmount Money
            )
    /*================================================================
    UPDATING FROM MARGIN LEDGER
    ================================================================*/
    INSERT
    INTO
            #COLLATERALDATA
    SELECT
            #C_PartyCode.PARTY_CODE         ,
            CL_TYPE = isnull(Cl_type, 'CLI'),
            Record_Type                     ,
            CASH_COMPO                      ,
            NONCASH_COMPO                   ,
            MARGINAMT     = MARGINAMT           ,
            TOTALCASH     = MARGINAMT           ,
            ORGTOTCASH    = MARGINAMT           ,
            TOTALNONCASH  = 0                   ,
            ORGTOTNONCASH = 0                   ,
            CASH_NCASH                          ,
            FDAMOUNT       = 0                        ,
            TotalFdAmount  = 0                        ,
            BgAmount       = 0                        ,
            TotalBgAmount  = 0                        ,
            SecAmount      = 0                        ,
            TotalSecAmount = 0
    FROM
            #C_PartyCode,
            (SELECT
                    Party_code,
                    MARGINAMT = Isnull((SUM(Damt) - SUM(Camt)), 0)
            FROM
                    C_MarginLedger
            WHERE
                    Exchange = @Exchange
                AND Segment  = @Segment
            GROUP BY
                    Party_Code
            ) Mrg
    WHERE
            Mrg.Party_code = #C_PartyCode.Party_code
        AND Record_Type    = 'MARGIN'
    CREATE
            TABLE [#Collateraldetails]
            (
                    [Effdate] [   DATETIME]           ,
                    [Exchange] [  VARCHAR](3)         ,
                    [Segment] [   VARCHAR](20)        ,
                    [Party_Code] [VARCHAR](10)        ,
                    [Scrip_Cd] [  VARCHAR](12)        ,
                    [Series] [    VARCHAR](3)         ,
                    [Isin] [      VARCHAR](20)        ,
                    [Cl_Rate] [money]                 ,
                    [Amount] [money]                  ,
                    [Qty] [NUMERIC](18, 4)            ,
                    [Haircut] [money]                 ,
                    [Finalamount] [money]             ,
                    [Percentagecash] [   NUMERIC](18, 2),
                    [Perecntagenoncash] [NUMERIC](18, 2),
                    [Receive_Date] [     DATETIME]      ,
                    [Maturity_Date] [    DATETIME]      ,
                    [Coll_Type] [        VARCHAR](6)    ,
                    [Clienttype] [       VARCHAR](3)    ,
                    [Remarks] [          VARCHAR](50)   ,
                    [Loginname] [        VARCHAR](20)   ,
                    [Logintime] [        DATETIME]      ,
                    [Cash_Ncash] [       VARCHAR](2)    ,
                    [Group_Code] [       VARCHAR](15)   ,
                    [Fd_Bg_No] [         VARCHAR](20)   ,
                    [Bank_Code] [        VARCHAR](15)   ,
                    [Fd_Type] [          VARCHAR](1)
            )
    INSERT
    INTO
            #CollateralDetails SELECT EffDate = @Effdate ,
            Exchange                          = @Exchange,
            Segment                           = @Segment ,
            Party_Code                                   ,
            Scrip_Cd          = ''                                ,
            Series            = ''                                ,
            Isin              = ''                                ,
            Cl_Rate           = 0                                 ,
            Amount            = Marginamt                         ,
            Qty               = 0                                 ,
            HairCut           = 0                                 ,
            FinalAmount       = Marginamt                         ,
            PercentageCash    = Cash_Compo                        ,
            PerecntageNonCash = NonCash_Compo                     ,
            Receive_Date      = ''                                ,
            Maturity_Date     = ''                                ,
            Coll_Type         = 'MARGIN'                          ,
            ClientType        = cl_type                           ,
            Remarks           = ''                                ,
            LoginName         = ''                                ,
            LoginTime         = GETDATE
            (
            )
            ,
            Cash_Ncash = 'C',
            Group_Code = '' ,
            Fd_Bg_No   = '' ,
            Bank_Code  = '' ,
            Fd_Type    = ''
    FROM
            #COLLATERALDATA
    WHERE
            MARGINAMT   > 0
        AND Record_Type = 'MARGIN'
    /*================================================================
    UPDATING FROM FIXED DEPOSITS
    ================================================================*/
    CREATE
            TABLE [#FixedDeposit]
            (
                    [Party_Code] [VARCHAR](10)    ,
                    [cl_Type]     VARCHAR(10)     ,
                    [Balance] [money]             ,
                    [Bank_Code] [   VARCHAR](15)  ,
                    [Fd_Type]       CHAR(1)       ,
                    [Fdr_No] [      VARCHAR](20)  ,
                    [Receive_Date]  DATETIME      ,
                    [Maturity_Date] DATETIME      ,
                    [FdHaircut]     NUMERIC(18, 2),
                    [FdAmount] Money
            )
    INSERT
    INTO
            #FixedDeposit
    SELECT
            F.Party_Code                     ,
            CL_Type                          ,
            Balance = isnull(SUM(balance), 0),
            fm.Bank_Code                     ,
            fm.FD_Type                       ,
            fm.Fdr_No                        ,
            Fm.Receive_Date                  ,
            fm.Maturity_Date                 ,
            FdHaircut = 0                    ,
            FdAmount  = 0
    FROM
            FixedDepositTrans F,
            FixedDepositMst Fm ,
            #COLLATERALDATA
    WHERE
            F.Trans_Date =
            (SELECT
                    MAX(f1.Trans_Date)
            FROM
                    FixedDepositTrans F1
            WHERE
                    f.party_code   = f1.party_code
                AND f.bank_code    = f1.bank_code
                AND f.fdr_no       = f1.fdr_no
                AND f1.Trans_Date <= @EffDate + ' 23:59'
                AND f1.branch_code = f1.branch_code
                AND F1.Tcode       = F.Tcode
            )
        AND Fm.Exchange             = @Exchange
        AND Fm.Segment              = @Segment
        AND f.branch_code           = fm.branch_code
        AND fm.party_Code           = f.party_code
        AND fm.Bank_Code            = f.Bank_Code
        AND fm.Fdr_no               = f.Fdr_No
        AND fm.Status              <> 'C'
        AND @EffDate + ' 23:59:59' >= fm.receive_date
        AND @EffDate + ' 00:00:00' <= fm.maturity_date - fm.Benefit_Removal_Days
        AND Fm.Tcode                = F.Tcode
        AND F.Party_Code            = #COLLATERALDATA.Party_Code
        AND Record_Type             = 'FD'
    GROUP BY
            fm.Bank_Code    ,
            fm.FD_Type      ,
            fm.Fdr_No       ,
            Fm.Receive_Date ,
            fm.Maturity_Date,
            Cl_Type         ,
            F.Party_Code
    /*===========================================================
    FIXED DEPOSITS - SETTING AT PARTY CODE + BANK CODE LEVEL
    ===========================================================*/
    UPDATE
            #FixedDeposit
    SET
            FdHaircut = haircut
    FROM
            fdhaircut
    WHERE
            fdhaircut.party_code = #FixedDeposit.party_code
        AND fdhaircut.bank_code  = #FixedDeposit.bank_code
        AND Exchange             = @Exchange
        AND Segment              = @Segment
        AND Active               = 1
        AND EffDate              =
            (SELECT
                    MAX(Effdate)
            FROM
                    fdhaircut
            WHERE
                    EffDate             <= @EffDate + ' 23:59'
                AND fdhaircut.party_code = #FixedDeposit.party_code
                AND fdhaircut.bank_code  = #FixedDeposit.bank_code
                AND Exchange             = @Exchange
                AND Segment              = @Segment
                AND Active               = 1
            )
    /*===========================================================
    FIXED DEPOSITS - SETTING AT PARTY CODE LEVEL
    ===========================================================*/
    UPDATE
            #FixedDeposit
    SET
            FdHaircut = haircut
    FROM
            fdhaircut
    WHERE
            fdhaircut.party_code = #FixedDeposit.party_code
        AND fdhaircut.bank_code  = ''
        AND Exchange             = @Exchange
        AND Segment              = @Segment
        AND Active               = 1
        AND EffDate              =
            (SELECT
                    MAX(Effdate)
            FROM
                    fdhaircut
            WHERE
                    EffDate             <= @EffDate + ' 23:59'
                AND fdhaircut.party_code = #FixedDeposit.party_code
                AND fdhaircut.bank_code  = ''
                AND Exchange             = @Exchange
                AND Segment              = @Segment
                AND Active               = 1
            )
        AND #FixedDeposit.FdHaircut = 0
    /*===========================================================
    FIXED DEPOSITS - SETTING AT BANK CODE LEVEL
    ===========================================================*/
    UPDATE
            #FixedDeposit
    SET
            FdHaircut = haircut
    FROM
            fdhaircut
    WHERE
            fdhaircut.party_code = ''
        AND fdhaircut.bank_code  = #FixedDeposit.bank_code
        AND Exchange             = @Exchange
        AND Segment              = @Segment
        AND Active               = 1
        AND EffDate              =
            (SELECT
                    MAX(Effdate)
            FROM
                    fdhaircut
            WHERE
                    EffDate             <= @EffDate + ' 23:59'
                AND fdhaircut.party_code = ''
                AND fdhaircut.bank_code  = #FixedDeposit.bank_code
                AND Exchange             = @Exchange
                AND Segment              = @Segment
                AND Active               = 1
            )
        AND #FixedDeposit.FdHaircut = 0
    /*===========================================================
    FIXED DEPOSITS - SETTING AT CLIENT TYPE LEVEL
    ===========================================================*/
    UPDATE
            #FixedDeposit
    SET
            FdHaircut = haircut
    FROM
            fdhaircut
    WHERE
            fdhaircut.party_code = ''
        AND fdhaircut.bank_code  = ''
        AND Client_Type          = #FixedDeposit.Cl_Type
        AND Client_Type         <> ''
        AND Exchange             = @Exchange
        AND Segment              = @Segment
        AND Active               = 1
        AND EffDate              =
            (SELECT
                    MAX(Effdate)
            FROM
                    fdhaircut
            WHERE
                    EffDate             <= @EffDate + ' 23:59'
                AND fdhaircut.party_code = ''
                AND fdhaircut.bank_code  = ''
                AND Client_Type          = #FixedDeposit.Cl_Type
                AND Client_Type         <> ''
                AND Exchange             = @Exchange
                AND Segment              = @Segment
                AND Active               = 1
            )
        AND #FixedDeposit.FdHaircut = 0
    /*===========================================================
    FIXED DEPOSITS - SETTING AT GLOBAL LEVEL
    ===========================================================*/
    UPDATE
            #FixedDeposit
    SET
            FdHaircut = haircut
    FROM
            fdhaircut
    WHERE
            fdhaircut.party_code = ''
        AND fdhaircut.bank_code  = ''
        AND Client_Type          = ''
        AND Exchange             = @Exchange
        AND Segment              = @Segment
        AND Active               = 1
        AND EffDate              =
            (SELECT
                    MAX(Effdate)
            FROM
                    fdhaircut
            WHERE
                    EffDate             <= @EffDate + ' 23:59'
                AND fdhaircut.party_code = ''
                AND fdhaircut.bank_code  = ''
                AND Client_Type          = ''
                AND Exchange             = @Exchange
                AND Segment              = @Segment
                AND Active               = 1
            )
        AND #FixedDeposit.FdHaircut = 0
    /*===========================================================
    FIXED DEPOSITS - APPLYING HAIR CUT
    ===========================================================*/
    INSERT
    INTO
            #COLLATERALDATA
    SELECT
            #C_PartyCode.PARTY_CODE         ,
            CL_TYPE = isnull(Cl_type, 'CLI'),
            Record_Type                     ,
            CASH_COMPO                      ,
            NONCASH_COMPO                   ,
            MARGINAMT = 0                   ,
            TOTALCASH =
            CASE
                    WHEN CASH_NCASH <> 'N'
                    THEN(Balance -(Balance * FdHaircut / 100))
                    ELSE 0
            END,
            ORGTOTCASH =
            CASE
                    WHEN CASH_NCASH <> 'N'
                    THEN Balance
                    ELSE 0
            END,
            TOTALNONCASH =
            CASE
                    WHEN CASH_NCASH = 'N'
                    THEN(Balance -(Balance * FdHaircut / 100))
                    ELSE 0
            END,
            ORGTOTNONCASH =
            CASE
                    WHEN CASH_NCASH = 'N'
                    THEN Balance
                    ELSE 0
            END                                            ,
            CASH_NCASH                                     ,
            FDAMOUNT       = Balance -(Balance * FdHaircut / 100),
            TotalFdAmount  = Balance                             ,
            BgAmount       = 0                                   ,
            TotalBgAmount  = 0                                   ,
            SecAmount      = 0                                   ,
            TotalSecAmount = 0
    FROM
            #C_PartyCode,
            (SELECT
                    Party_Code,
                    FdHaircut ,
                    Balance = SUM(Balance)
            FROM
                    #FixedDeposit
            GROUP BY
                    Party_Code,
                    FdHaircut
            ) #FixedDeposit
    WHERE
            #FixedDeposit.Party_Code = #C_PartyCode.Party_Code
        AND Record_Type              = 'FD'
    INSERT
    INTO
            #CollateralDetails SELECT EffDate = @Effdate                ,
            Exchange                          = @Exchange               ,
            Segment                           = @Segment                ,
            Party_Code                        = #FixedDeposit.Party_Code,
            Scrip_Cd                          = ''                      ,
            Series                            = ''                      ,
            Isin                              = ''                      ,
            Cl_Rate                           = 0                       ,
            Amount                            = #FixedDeposit.Balance   ,
            Qty                               = 0                       ,
            HairCut                           = FdHaircut               ,
            FinalAmount                       = #FixedDeposit.FdAmount  ,
            PercentageCash                    = Cash_Compo              ,
            PerecntageNonCash                 = NonCash_Compo           ,
            Receive_Date                      = Receive_Date            ,
            Maturity_Date                     = Maturity_Date           ,
            Coll_Type                         = 'FD'                    ,
            ClientType                        = #COLLATERALDATA.Cl_type ,
            Remarks                           = ''                      ,
            LoginName                         = ''                      ,
            LoginTime                         = GETDATE
            (
            )
            ,
            Cash_Ncash            ,
            Group_Code = ''       ,
            Fd_Bg_No   = Fdr_No   ,
            Bank_Code  = Bank_Code,
            Fd_Type    = Fd_Type
    FROM
            #FixedDeposit,
            #COLLATERALDATA
    WHERE
            #FixedDeposit.Party_Code = #COLLATERALDATA.Party_Code
    /*=======================================================================
    Calculation for BG
    =======================================================================*/
    CREATE
            TABLE [#BankGuarantee]
            (
                    [Party_Code] [VARCHAR](10)    ,
                    [cl_Type]     VARCHAR(10)     ,
                    [Balance] [money]             ,
                    [Bank_Code] [   VARCHAR](15)  ,
                    [Bg_No] [       VARCHAR](20)  ,
                    [Receive_Date]  DATETIME      ,
                    [Maturity_Date] DATETIME      ,
                    [BgHaircut]     NUMERIC(18, 2),
                    [BgAmount] Money
            )
    INSERT
    INTO
            #BankGuarantee
    SELECT
            F.Party_Code                     ,
            CL_Type                          ,
            Balance = isnull(SUM(balance), 0),
            fm.Bank_Code                     ,
            fm.Bg_No                         ,
            Fm.Receive_Date                  ,
            fm.Maturity_Date                 ,
            0                                ,
            0
    FROM
            BankGuaranteeTrans F,
            BankGuaranteeMst Fm ,
            #COLLATERALDATA
    WHERE
            F.Trans_Date =
            (SELECT
                    MAX(f1.Trans_Date)
            FROM
                    BankGuaranteeTrans F1
            WHERE
                    f.party_code   = f1.party_code
                AND f.bank_code    = f1.bank_code
                AND f.Bg_no        = f1.BG_no
                AND f1.Trans_Date <= @EffDate + ' 23:59'
                AND f1.branch_code = f1.branch_code
                AND F1.Tcode       = F.Tcode
            )
        AND Fm.Exchange             = @Exchange
        AND Fm.Segment              = @Segment
        AND f.branch_code           = fm.branch_code
        AND fm.party_Code           = f.party_code
        AND fm.Bank_Code            = f.Bank_Code
        AND fm.Bg_no                = f.Bg_No
        AND fm.Status              <> 'C'
        AND @EffDate + ' 23:59:59' >= fm.receive_date
        AND @EffDate + ' 00:00:00' <= fm.maturity_date - fm.Benefit_Removal_Days
        AND Fm.Tcode                = F.Tcode
        AND F.Party_Code            = #COLLATERALDATA.Party_Code
        AND Record_Type             = 'BG'
    GROUP BY
            fm.Bank_Code    ,
            fm.Bg_No        ,
            Fm.Receive_Date ,
            fm.Maturity_Date,
            Cl_Type         ,
            F.Party_Code
    /*===========================================================
    BANK GUARANTEE - SETTING AT PARTY CODE + BANK CODE LEVEL
    ===========================================================*/
    UPDATE
            #BankGuarantee
    SET
            BgHaircut = haircut
    FROM
            BgHaircut
    WHERE
            BgHaircut.party_code = #BankGuarantee.party_code
        AND BgHaircut.bank_code  = #BankGuarantee.bank_code
        AND Exchange             = @Exchange
        AND Segment              = @Segment
        AND Active               = 1
        AND EffDate              =
            (SELECT
                    MAX(Effdate)
            FROM
                    BgHaircut
            WHERE
                    EffDate             <= @EffDate + ' 23:59'
                AND BgHaircut.party_code = #BankGuarantee.party_code
                AND BgHaircut.bank_code  = #BankGuarantee.bank_code
                AND Exchange             = @Exchange
                AND Segment              = @Segment
                AND Active               = 1
            )
    /*===========================================================
    BANK GUARANTEE - SETTING AT PARTY CODE LEVEL
    ===========================================================*/
    UPDATE
            #BankGuarantee
    SET
            BgHaircut = haircut
    FROM
            BgHaircut
    WHERE
            BgHaircut.party_code = #BankGuarantee.party_code
        AND BgHaircut.bank_code  = ''
        AND Exchange             = @Exchange
        AND Segment              = @Segment
        AND Active               = 1
        AND EffDate              =
            (SELECT
                    MAX(Effdate)
            FROM
                    BgHaircut
            WHERE
                    EffDate             <= @EffDate + ' 23:59'
                AND BgHaircut.party_code = #BankGuarantee.party_code
                AND BgHaircut.bank_code  = ''
                AND Exchange             = @Exchange
                AND Segment              = @Segment
                AND Active               = 1
            )
        AND #BankGuarantee.BgHaircut = 0
    /*===========================================================
    BANK GUARANTEE - SETTING AT BANK CODE LEVEL
    ===========================================================*/
    UPDATE
            #BankGuarantee
    SET
            BgHaircut = haircut
    FROM
            BgHaircut
    WHERE
            BgHaircut.party_code = ''
        AND BgHaircut.bank_code  = #BankGuarantee.bank_code
        AND Exchange             = @Exchange
        AND Segment              = @Segment
        AND Active               = 1
        AND EffDate              =
            (SELECT
                    MAX(Effdate)
            FROM
                    BgHaircut
            WHERE
                    EffDate             <= @EffDate + ' 23:59'
                AND BgHaircut.party_code = ''
                AND BgHaircut.bank_code  = #BankGuarantee.bank_code
                AND Exchange             = @Exchange
                AND Segment              = @Segment
                AND Active               = 1
            )
        AND #BankGuarantee.BgHaircut = 0
    /*===========================================================
    BANK GUARANTEE - SETTING AT CLIENT TYPE LEVEL
    ===========================================================*/
    UPDATE
            #BankGuarantee
    SET
            BgHaircut = haircut
    FROM
            BgHaircut
    WHERE
            BgHaircut.party_code = ''
        AND BgHaircut.bank_code  = ''
        AND Client_Type          = #BankGuarantee.Cl_Type
        AND Client_Type         <> ''
        AND Exchange             = @Exchange
        AND Segment              = @Segment
        AND Active               = 1
        AND EffDate              =
            (SELECT
                    MAX(Effdate)
            FROM
                    BgHaircut
            WHERE
                    EffDate             <= @EffDate + ' 23:59'
                AND BgHaircut.party_code = ''
                AND BgHaircut.bank_code  = ''
                AND Client_Type          = #BankGuarantee.Cl_Type
                AND Client_Type         <> ''
                AND Exchange             = @Exchange
                AND Segment              = @Segment
                AND Active               = 1
            )
        AND #BankGuarantee.BgHaircut = 0
    /*===========================================================
    BANK GUARANTEE - SETTING AT GLOBAL LEVEL
    ===========================================================*/
    UPDATE
            #BankGuarantee
    SET
            BgHaircut = haircut
    FROM
            BgHaircut
    WHERE
            BgHaircut.party_code  = ''
        AND BgHaircut.bank_code   = ''
        AND BgHaircut.Client_Type = ''
        AND Exchange              = @Exchange
        AND Segment               = @Segment
        AND Active                = 1
        AND EffDate               =
            (SELECT
                    MAX(Effdate)
            FROM
                    BgHaircut
            WHERE
                    EffDate              <= @EffDate + ' 23:59'
                AND BgHaircut.party_code  = ''
                AND BgHaircut.bank_code   = ''
                AND BgHaircut.Client_Type = ''
                AND Exchange              = @Exchange
                AND Segment               = @Segment
                AND Active                = 1
            )
        AND #BankGuarantee.BgHaircut = 0
    /*===========================================================
    BANK GAURANTEE - APPLYING HAIR CUT
    ===========================================================*/
    INSERT
    INTO
            #COLLATERALDATA
    SELECT
            #C_PartyCode.PARTY_CODE         ,
            CL_TYPE = isnull(Cl_type, 'CLI'),
            Record_Type                     ,
            CASH_COMPO                      ,
            NONCASH_COMPO                   ,
            MARGINAMT = 0                   ,
            TOTALCASH =
            CASE
                    WHEN CASH_NCASH <> 'N'
                    THEN(Balance -(Balance * BgHaircut / 100))
                    ELSE 0
            END,
            ORGTOTCASH =
            CASE
                    WHEN CASH_NCASH <> 'N'
                    THEN Balance
                    ELSE 0
            END,
            TOTALNONCASH =
            CASE
                    WHEN CASH_NCASH = 'N'
                    THEN(Balance -(Balance * BgHaircut / 100))
                    ELSE 0
            END,
            ORGTOTNONCASH =
            CASE
                    WHEN CASH_NCASH = 'N'
                    THEN Balance
                    ELSE 0
            END                                       ,
            CASH_NCASH                                ,
            FDAMOUNT       = 0                         ,
            TotalFdAmount  = 0                         ,
            BgAmount       =(Balance * BgHaircut / 100),
            TotalBgAmount  = Balance                   ,
            SecAmount      = 0                         ,
            TotalSecAmount = 0
    FROM
            #C_PartyCode,
            (SELECT
                    Party_Code,
                    BgHaircut ,
                    Balance = SUM(Balance)
            FROM
                    #BankGuarantee
            GROUP BY
                    Party_Code,
                    BgHaircut
            ) #BankGuarantee
    WHERE
            #BankGuarantee.Party_Code = #C_PartyCode.Party_Code
        AND Record_Type               = 'BG'
    INSERT
    INTO
            #CollateralDetails SELECT EffDate = @Effdate                 ,
            Exchange                          = @Exchange                ,
            Segment                           = @Segment                 ,
            Party_Code                        = #BankGuarantee.Party_Code,
            Scrip_Cd                          = ''                       ,
            Series                            = ''                       ,
            Isin                              = ''                       ,
            Cl_Rate                           = 0                        ,
            Amount                            = Balance                  ,
            Qty                               = 0                        ,
            HairCut                           = BgHaircut                ,
            FinalAmount                       = #BankGuarantee.BgAmount  ,
            PercentageCash                    = Cash_Compo               ,
            PerecntageNonCash                 = NonCash_Compo            ,
            Receive_Date                      = Receive_Date             ,
            Maturity_Date                     = Maturity_Date            ,
            Coll_Type                         = 'BG'                     ,
            ClientType                        = #COLLATERALDATA.Cl_type  ,
            Remarks                           = ''                       ,
            LoginName                         = ''                       ,
            LoginTime                         = GETDATE
            (
            )
            ,
            Cash_Ncash            ,
            Group_Code = ''       ,
            Fd_Bg_No   = Bg_No    ,
            Bank_Code  = Bank_Code,
            Fd_Type    = 'B'
    FROM
            #BankGuarantee,
            #COLLATERALDATA
    WHERE
            #BankGuarantee.Party_Code = #COLLATERALDATA.Party_Code
    /*=======================================================================
    Calculation for SEC
    =======================================================================*/
    UPDATE
            #C_CalculateSecView
    SET
            Group_Code = groupmst.Group_Code
    FROM
            groupmst
    WHERE
            groupmst.scrip_cd = #C_CalculateSecView.Scrip_Cd
        AND groupmst.series LIKE #C_CalculateSecView.Series + '%'
        AND exchange = @Exchange
        AND segment  = @Segment
        AND active   = 1
        AND effdate  =
            (SELECT
                    MAX(effdate)
            FROM
                    groupmst
            WHERE
                    groupmst.scrip_cd = #C_CalculateSecView.Scrip_Cd
                AND groupmst.series LIKE #C_CalculateSecView.Series + '%'
                AND exchange = @Exchange
                AND segment  = @Segment
                AND effdate <= @EffDate + ' 23:59:59'
                AND active   = 1
            )
    /*===================================================
    SECURITY HAIRCUT - SETTING AT PARTY + SCRIP LEVEL
    =====================================================*/
    UPDATE
            #C_CalculateSecView
    SET
            SecHaircut = HairCut
    FROM
            (SELECT
                    #C_CalculateSecView.party_code,
                    #C_CalculateSecView.Scrip_Cd  ,
                    HairCut = ISNULL(MAX(SecurityHaircut.HairCut), 0)
            FROM
                    #C_CalculateSecView,
                    SecurityHaircut
            WHERE
                    SecurityHaircut.party_code  = #C_CalculateSecView.party_code
                AND SecurityHaircut.Scrip_Cd    = #C_CalculateSecView.Scrip_Cd
                AND SecurityHaircut.Series     IN('EQ', 'BE')
                AND #C_CalculateSecView.Series IN('EQ', 'BE')
                AND Exchange                    = @Exchange
                AND Segment                     = @Segment
                AND Active                      = 1
                AND EffDate                     =
                    (SELECT
                            MAX(Effdate)
                    FROM
                            SecurityHaircut
                    WHERE
                            EffDate                    <= @EffDate + ' 23:59'
                        AND SecurityHaircut.party_code  = #C_CalculateSecView.party_code
                        AND SecurityHaircut.Scrip_Cd    = #C_CalculateSecView.Scrip_Cd
                        AND SecurityHaircut.Series     IN('EQ', 'BE')
                        AND #C_CalculateSecView.Series IN('EQ', 'BE')
                        AND Exchange                    = @Exchange
                        AND Segment                     = @Segment
                        AND Active                      = 1
                    )
            GROUP BY
                    #C_CalculateSecView.party_code,
                    #C_CalculateSecView.Scrip_Cd
            ) S
    WHERE
            S.party_code                = #C_CalculateSecView.party_code
        AND S.Scrip_Cd                  = #C_CalculateSecView.Scrip_Cd
        AND #C_CalculateSecView.SERIES IN('EQ', 'BE')
    UPDATE
            #C_CalculateSecView
    SET
            SecHaircut = SecurityHaircut.HairCut
    FROM
            SecurityHaircut
    WHERE
            SecurityHaircut.party_code = #C_CalculateSecView.party_code
        AND SecurityHaircut.Scrip_Cd   = #C_CalculateSecView.Scrip_Cd
        AND SecurityHaircut.Series     = #C_CalculateSecView.Series
        AND Exchange                   = @Exchange
        AND Segment                    = @Segment
        AND Active                     = 1
        AND EffDate                    =
            (SELECT
                    MAX(Effdate)
            FROM
                    SecurityHaircut
            WHERE
                    EffDate                   <= @EffDate + ' 23:59'
                AND SecurityHaircut.party_code = #C_CalculateSecView.party_code
                AND SecurityHaircut.Scrip_Cd   = #C_CalculateSecView.Scrip_Cd
                AND SecurityHaircut.Series     = #C_CalculateSecView.Series
                AND Exchange                   = @Exchange
                AND Segment                    = @Segment
                AND Active                     = 1
            )
        AND SecHaircut = 0
    /*===================================================
    SECURITY HAIRCUT - SETTING AT PARTY LEVEL
    =====================================================*/
    UPDATE
            #C_CalculateSecView
    SET
            SecHaircut = SecurityHaircut.HairCut
    FROM
            SecurityHaircut
    WHERE
            SecurityHaircut.party_code = #C_CalculateSecView.party_code
        AND SecurityHaircut.Scrip_Cd   = ''
        AND Exchange                   = @Exchange
        AND Segment                    = @Segment
        AND Active                     = 1
        AND EffDate                    =
            (SELECT
                    MAX(Effdate)
            FROM
                    SecurityHaircut
            WHERE
                    EffDate                   <= @EffDate + ' 23:59'
                AND SecurityHaircut.party_code = #C_CalculateSecView.party_code
                AND SecurityHaircut.Scrip_Cd   = ''
                AND Exchange                   = @Exchange
                AND Segment                    = @Segment
                AND Active                     = 1
            )
        AND SecHaircut = 0
    /*===================================================
    SECURITY HAIRCUT - SETTING SCRIP LEVEL
    =====================================================*/
    UPDATE
            #C_CalculateSecView
    SET
            SecHaircut = HairCut
    FROM
            (SELECT
                    #C_CalculateSecView.Scrip_Cd,
                    HairCut = ISNULL(MAX(SecurityHaircut.HairCut), 0)
            FROM
                    #C_CalculateSecView,
                    SecurityHaircut
            WHERE
                    SecurityHaircut.party_code  = ''
                AND SecurityHaircut.Scrip_Cd    = #C_CalculateSecView.Scrip_Cd
                AND SecurityHaircut.Series     IN('EQ', 'BE')
                AND #C_CalculateSecView.Series IN('EQ', 'BE')
                AND Exchange                    = @Exchange
                AND Segment                     = @Segment
                AND Active                      = 1
                AND EffDate                     =
                    (SELECT
                            MAX(Effdate)
                    FROM
                            SecurityHaircut
                    WHERE
                            EffDate                    <= @EffDate + ' 23:59'
                        AND SecurityHaircut.party_code  = ''
                        AND SecurityHaircut.Scrip_Cd    = #C_CalculateSecView.Scrip_Cd
                        AND SecurityHaircut.Series     IN('EQ', 'BE')
                        AND #C_CalculateSecView.Series IN('EQ', 'BE')
                        AND Exchange                    = @Exchange
                        AND Segment                     = @Segment
                        AND Active                      = 1
                    )
            GROUP BY
                    #C_CalculateSecView.Scrip_Cd
            ) S
    WHERE
            S.Scrip_Cd                  = #C_CalculateSecView.Scrip_Cd
        AND #C_CalculateSecView.SERIES IN('EQ', 'BE')
        AND SecHaircut                  = 0
    UPDATE
            #C_CalculateSecView
    SET
            SecHaircut = SecurityHaircut.HairCut
    FROM
            SecurityHaircut
    WHERE
            SecurityHaircut.party_code = ''
        AND SecurityHaircut.Scrip_Cd   = #C_CalculateSecView.Scrip_Cd
        AND SecurityHaircut.Series LIKE #C_CalculateSecView.Series + '%'
        AND Exchange = @Exchange
        AND Segment  = @Segment
        AND Active   = 1
        AND EffDate  =
            (SELECT
                    MAX(Effdate)
            FROM
                    SecurityHaircut
            WHERE
                    EffDate                   <= @EffDate + ' 23:59'
                AND SecurityHaircut.party_code = ''
                AND SecurityHaircut.Scrip_Cd   = #C_CalculateSecView.Scrip_Cd
                AND SecurityHaircut.Series LIKE #C_CalculateSecView.Series + '%'
                AND Exchange = @Exchange
                AND Segment  = @Segment
                AND Active   = 1
            )
        AND SecHaircut = 0
    /*===================================================
    SECURITY HAIRCUT - SETTING SCRIP GROUP LEVEL
    =====================================================*/
    UPDATE
            #C_CalculateSecView
    SET
            SecHaircut = SecurityHaircut.HairCut
    FROM
            SecurityHaircut
    WHERE
            SecurityHaircut.party_code = ''
        AND SecurityHaircut.Scrip_Cd   = ''
        AND Group_Code                 = #C_CalculateSecView.Group_Code
        AND Exchange                   = @Exchange
        AND Segment                    = @Segment
        AND Active                     = 1
        AND EffDate                    =
            (SELECT
                    MAX(Effdate)
            FROM
                    SecurityHaircut
            WHERE
                    EffDate                   <= @EffDate + ' 23:59'
                AND SecurityHaircut.party_code = ''
                AND SecurityHaircut.Scrip_Cd   = ''
                AND Group_Code                 = #C_CalculateSecView.Group_Code
                AND Exchange                   = @Exchange
                AND Segment                    = @Segment
                AND Active                     = 1
            )
        AND SecHaircut = 0
    /*===================================================
    SECURITY HAIRCUT - SETTING CLIENT TYPE LEVEL
    =====================================================*/
    UPDATE
            #C_CalculateSecView
    SET
            SecHaircut = SecurityHaircut.HairCut
    FROM
            SecurityHaircut,
            #C_PartyCode
    WHERE
            #C_PartyCode.Party_Code        = #C_CalculateSecView.Party_Code
        AND #C_CalculateSecView.party_code = ''
        AND SecurityHaircut.Scrip_Cd       = ''
        AND Client_Type                    = #C_PartyCode.Cl_Type
        AND Exchange                       = @Exchange
        AND Segment                        = @Segment
        AND Active                         = 1
        AND EffDate                        =
            (SELECT
                    MAX(Effdate)
            FROM
                    SecurityHaircut
            WHERE
                    EffDate                       <= @EffDate + ' 23:59'
                AND #C_CalculateSecView.party_code = ''
                AND SecurityHaircut.Scrip_Cd       = ''
                AND Client_Type                    = #C_PartyCode.Cl_Type
                AND Exchange                       = @Exchange
                AND Segment                        = @Segment
                AND Active                         = 1
            )
        AND SecHaircut = 0
    /*===================================================
    SECURITY HAIRCUT - SETTING GLOBAL LEVEL
    =====================================================*/
    UPDATE
            #C_CalculateSecView
    SET
            SecHaircut = SecurityHaircut.HairCut
    FROM
            SecurityHaircut
    WHERE
            SecurityHaircut.party_code = ''
        AND SecurityHaircut.Scrip_Cd   = ''
        AND Client_Type                = ''
        AND Exchange                   = @Exchange
        AND Segment                    = @Segment
        AND Active                     = 1
        AND EffDate                    =
            (SELECT
                    MAX(Effdate)
            FROM
                    SecurityHaircut
            WHERE
                    EffDate                   <= @EffDate + ' 23:59'
                AND SecurityHaircut.party_code = ''
                AND SecurityHaircut.Scrip_Cd   = ''
                AND Client_Type                = ''
                AND Exchange                   = @Exchange
                AND Segment                    = @Segment
                AND Active                     = 1
            )
        AND SecHaircut = 0
    UPDATE
            #C_CalculateSecView
    SET
            Cl_Rate = isnull(#C_valuation.Cl_Rate, 0)
    FROM
            #C_valuation
    WHERE
            #C_valuation.scrip_cd = #C_CalculateSecView.Scrip_Cd
        AND #C_valuation.series   = #C_CalculateSecView.Series
    UPDATE
            #C_CalculateSecView
    SET
            TotalSecAmount = Cl_Rate * BalQty
    UPDATE
            #C_CalculateSecView
    SET
            SecAmount =(TotalSecAmount -(TotalSecAmount * SecHaircut / 100))
    INSERT
    INTO
            #COLLATERALDATA
    SELECT
            #C_PartyCode.PARTY_CODE         ,
            CL_TYPE = isnull(Cl_type, 'CLI'),
            Record_Type                     ,
            CASH_COMPO                      ,
            NONCASH_COMPO                   ,
            MARGINAMT = 0                   ,
            TOTALCASH =
            CASE
                    WHEN CASH_NCASH <> 'N'
                    THEN #C_CalculateSecView.SecAmount
                    ELSE 0
            END,
            ORGTOTCASH =
            CASE
                    WHEN CASH_NCASH <> 'N'
                    THEN #C_CalculateSecView.TotalSecAmount
                    ELSE 0
            END,
            TOTALNONCASH =
            CASE
                    WHEN CASH_NCASH = 'N'
                    THEN #C_CalculateSecView.SecAmount
                    ELSE 0
            END,
            ORGTOTNONCASH =
            CASE
                    WHEN CASH_NCASH = 'N'
                    THEN #C_CalculateSecView.TotalSecAmount
                    ELSE 0
            END                                          ,
            CASH_NCASH                                   ,
            FDAMOUNT       = 0                            ,
            TotalFdAmount  = 0                            ,
            BgAmount       = 0                            ,
            TotalBgAmount  = 0                            ,
            SecAmount      = #C_CalculateSecView.SecAmount,
            TotalSecAmount = #C_CalculateSecView.TotalSecAmount
    FROM
            #C_PartyCode,
            (SELECT
                    Party_Code                ,
                    SecAmount      = SUM(SecAmount),
                    TotalSecAmount = SUM(TotalSecAmount)
            FROM
                    #C_CalculateSecView
            GROUP BY
                    Party_Code
            ) #C_CalculateSecView
    WHERE
            #C_CalculateSecView.Party_Code = #C_PartyCode.Party_Code
        AND Record_Type                    = 'SEC'
    INSERT
    INTO
            #CollateralDetails SELECT EffDate = @EffDate                          ,
            Exchange                          = @Exchange                         ,
            Segment                           = @Segment                          ,
            Party_Code                        = #C_CalculateSecView.Party_Code    ,
            Scrip_Cd                          = Scrip_Cd                          ,
            Series                            = Series                            ,
            Isin                              = isin                              ,
            Cl_Rate                           = Cl_rate                           ,
            Amount                            = #C_CalculateSecView.TotalSecAmount,
            Qty                               = BalQty                            ,
            HairCut                           = SecHaircut                        ,
            FinalAmount                       = #C_CalculateSecView.SecAmount     ,
            PercentageCash                    = Cash_Compo                        ,
            PerecntageNonCash                 = NonCash_Compo                     ,
            Receive_Date                      = ''                                ,
            Maturity_Date                     = ''                                ,
            Coll_Type                         = 'SEC'                             ,
            ClientType                        = #COLLATERALDATA.cl_type           ,
            Remarks                           = ''                                ,
            LoginName                         = ''                                ,
            LoginTime                         = GETDATE
            (
            )
            ,
            Cash_Ncash = Cash_NCash,
            Group_Code = ''        ,
            Fd_Bg_No   = ''        ,
            Bank_Code  = ''        ,
            Fd_Type    = ''
    FROM
            #C_CalculateSecView,
            #COLLATERALDATA
    WHERE
            #C_CalculateSecView.Party_Code = #COLLATERALDATA.Party_Code
        AND Record_Type                    = 'SEC'
    CREATE
            TABLE #COLLATERALDATA_FINAL
            (
                    Party_Code VARCHAR(10)   ,
                    CashCompo  NUMERIC(18, 2),
                    MarginAmt Money          ,
                    TotalCash Money          ,
                    OrgTotCash Money         ,
                    TotalNonCash Money       ,
                    OrgTotNonCash Money      ,
                    FdAmount Money           ,
                    TotalFdAmount Money      ,
                    BgAmount Money           ,
                    TotalBgAmount Money      ,
                    SecAmount Money          ,
                    TotalSecAmount Money     ,
                    Actualcash money         ,
                    Actualnoncash money      ,
                    EffectiveColl Money
            )
    INSERT
    INTO
            #COLLATERALDATA_FINAL
    SELECT
            Party_Code         ,
            Cash_Compo         ,
            SUM(MarginAmt)     ,
            SUM(TotalCash)     ,
            SUM(OrgTotCash)    ,
            SUM(TotalNonCash)  ,
            SUM(OrgTotNonCash) ,
            SUM(FdAmount)      ,
            SUM(TotalFdAmount) ,
            SUM(BgAmount)      ,
            SUM(TotalBgAmount) ,
            SUM(SecAmount)     ,
            SUM(TotalSecAmount),
            0                  ,
            0                  ,
            0
    FROM
            #COLLATERALDATA
    GROUP BY
            Party_Code,
            Cash_Compo
    /*=======================================================================
    Apply the Cash Composition Ratio
    =======================================================================*/
    UPDATE
            #COLLATERALDATA_FINAL
    SET
            Actualcash =
            CASE
                    WHEN CashCompo > 0
                    THEN TotalCash
                    ELSE 0
            END,
            ActualNonCash =
            CASE
                    WHEN CashCompo > 0
                    THEN
                            CASE
                                    WHEN TotalCash < TotalNonCash
                                    THEN
                                            CASE
                                                    WHEN CashCompo > 0
                                                    THEN(TotalCash * 100) / CashCompo
                                                    ELSE 0
                                            END
                                    ELSE TotalNonCash
                            END
                    ELSE 0
            END
    UPDATE
            #COLLATERALDATA_FINAL
    SET
            Actualcash =
            CASE
                    WHEN CashCompo > 0
                    THEN TotalCash
                    ELSE 0
            END,
            ActualNonCash =
            CASE
                    WHEN CashCompo > 0
                    THEN
                            CASE
                                    WHEN TotalCash < TotalNonCash
                                    THEN
                                            CASE
                                                    WHEN CashCompo > 0
                                                    THEN(TotalCash * 100) / CashCompo
                                                    ELSE 0
                                            END
                                    ELSE TotalNonCash
                            END
                    ELSE 0
            END
    UPDATE
            #COLLATERALDATA_FINAL
    SET
            EffectiveColl =
            CASE
                    WHEN CashCompo > 0
                    THEN
                            CASE
                                    WHEN TotalCash < TotalNonCash
                                    THEN
                                            CASE
                                                    WHEN Actualnoncash < TotalCash + TotalNonCash
                                                    THEN Actualnoncash
                                                    ELSE TotalCash + TotalNonCash
                                            END
                                    ELSE TotalCash + TotalNonCash
                            END
                    ELSE TotalCash + TotalNonCash
            END
    UPDATE
            #COLLATERALDATA_FINAL
    SET
            Actualnoncash = EffectiveColl - Actualcash
    /*=======================================================================
    DELETE ALREADY CALCULATED DATA FOR THE DATE
    =======================================================================*/
    DELETE
    FROM
            CollateralDetails
    WHERE
            Exchange = @Exchange
        AND Segment  = @Segment
        AND EffDate LIKE @EffDate + '%'
        AND Party_Code BETWEEN @FromParty AND @ToParty
    DELETE
    FROM
            Collateral
    WHERE
            Exchange = @Exchange
        AND Segment  = @Segment
        AND Trans_Date LIKE @EffDate + '%'
        AND Party_Code BETWEEN @FromParty AND @ToParty
    /*=======================================================================
    POPULATING TO FINAL TABLE
    =======================================================================*/
    INSERT
    INTO
            CollateralDetails
    SELECT
            *
    FROM
            #CollateralDetails
    INSERT
    INTO
            Collateral SELECT Exchange = @Exchange   ,
            Segment                    = @Segment    ,
            Party_Code                 = Party_Code  ,
            Trans_Date                 = @EffDate    ,
            Cash                       = TotalCash   ,
            NonCash                    = TotalNonCash,
            ActualCash                 =
            (
                    CASE
                            WHEN Actualcash <> 0
                            THEN Actualcash
                            ELSE TotalCash
                    END
            )
            ,
            ActualNonCash = Actualnoncash,
            EffectiveColl = EffectiveColl,
            Active        = 1            ,
            TCode         = 0            ,
            Remarks       = ''           ,
            LoginName     = ''           ,
            LoginTime     = GETDATE
            (
            )
            ,
            TotalFd     = TotalFdAmount,
            TotalBg     = TotalBgAmount,
            TotalSec    = SecAmount    ,
            TotalMargin = Marginamt    ,
            OrgCash     = OrgTotCash   ,
            OrgNonCash  = OrgTotNonCash
    FROM
            #COLLATERALDATA_FINAL
    WHERE
            TOTALCASH    <> 0
         OR TOTALNONCASH <> 0

    SET @Status   = 1
    /*=======================================================================
    REMOVING TEMP FILES
    =======================================================================*/
    DROP TABLE #COLLATERALDATA_FINAL
    DROP TABLE #COLLATERALDATA
    DROP TABLE #C_CalculateSecView
    DROP TABLE #C_PartyCode
    DROP TABLE #C_valuation
    DROP TABLE #Collateraldetails
    DROP TABLE #FixedDeposit
    DROP TABLE #BankGuarantee

/*====================================  End Of Prcedure =====================================*/

GO
