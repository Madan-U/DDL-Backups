-- Object: PROCEDURE dbo.C_CollateralCalculationSpMS_New
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE PROCEDURE [dbo].[C_CollateralCalculationSpMS_New]   
(  
    @Exchange Varchar(3),   
    @Segment Varchar(20),   
    @FromParty Varchar(10),   
    @ToParty Varchar(10),   
    @EffDate Varchar(11),   
    @ShareDb Varchar(20),   
    @ShareDbServer Varchar(15),      
    @Status int OUTPUT  
)          
  
As
  
/*=======================================================  
    exec C_CollateralCalculationSpMS   'NSE', 'FUTURES',  '0000000000','ZZZZZZZZZZ','AUg 24 2006',  'NSE', 'mursd182',1
        @Exchange = 'NSE',   
        @Segment = 'FUTURES',   
        @FromParty = '0000000000',   
        @ToParty = 'ZZZZZZZZZZ',   
        @EffDate = 'DEC 15 2006',   
        @ShareDb = 'NSE',   
        @ShareDbServer = 'NSE',   
        @Status = 1  
=======================================================*/  
  
Declare   
    @@Cur  cursor,          
    @@Get Cursor,          
    @@GetFdBg Cursor,          
    @@GetClRate Cursor,          
    @@party_code varchar(15),          
    @@Cl_Type Varchar(3),          
    @@Cl_Rate money,          
    @@Tcode int,          
    @@Vdate varchar(11),          
    @@scrip_cd varchar(12),          
    @@Bank_Code varchar(20),          
    @@series varchar(3),          
    @@Isin varchar(20),          
    @@Qty int,          
    @@FdAmount money,          
    @@Balance money,          
    @@BgAmount money,          
    @@marginamt money,          
    @@Haircut money,          
    @@TotNonCash money,          
    @@TotCash money,          
    @@Actualnoncash money,          
    @@Actualcash money,          
    @@SecAmount money,          
    @@TotalSecAmount money,          
    @@TotalFdAmount money,           
    @@TotalBGAmount money,          
    @@CashCompo  money,          
    @@NonCashCompo money,          
    @@CashNCash varchar(1),          
    @@InstruType  varchar(6),          
    @@Fdr_no varchar(20),          
    @@Bg_No varchar(20),          
    @@Fd_Type varchar(1),          
    @@Maturity_Dt varchar(11),          
    @@Receive_Dt varchar(11),          
    @@Camt Money,          
    @@Damt Money,          
    @@DrCr varchar(1),          
    @@Group_cd varchar(20),          
    @@TotalCashNonCash  money,          
    @@Actualnoncash1 money,          
    @@EffectiveColl money,          
    /* Added on 21/03/2002*/          
    @@OrgCashNcash money,             
    @@OrgTotCash money,          
    @@OrgTotNonCash money,          
    @@Indicator varchar(6),          
    @@CheckParty Cursor,          
    @@FD INT,          
    @@BG INT,   
    @@SEC INT,   
    @@MARGIN INT,   
    @@PartyFound Varchar(10),  
    @VarFlag int,
    @@NewScrip_Cd Varchar(12),
    @@NewSeries Varchar(3)  
          
    Select @VarFlag = 0  
  
    Select @VarFlag = IsNull(CollCalculationFlag, 0) From DelSegment  
  
    Set @Status = 0          
        
/*=======================================================================  
    DELETE ALREADY CALCULATED DATA FOR THE DATE   
=======================================================================*/  
    Delete from   
        CollateralDetails   
    Where   
        Exchange = @Exchange   
        and Segment = @Segment         
        and EffDate Like @EffDate + '%'   
        and Party_Code Between @FromParty And @ToParty        
        
    Delete From    
        Collateral   
    Where   
        Exchange = @Exchange   
        and Segment = @Segment         
        and Trans_Date Like @EffDate + '%'   
        and Party_Code Between @FromParty And @ToParty

/*=======================================================================  
    POPULATE SECURITIES CLIENT WISE SECURITIES COLLATERAL BALANCES   
=======================================================================*/  
    select   
        Party_Code,   
        BalQty = SUM(Case when drcr = 'D' then -qty else qty end),    
        scrip_cd,   
        series,   
        isin           
    Into #C_CalculateSecView_1   
    from   
        C_SecuritiesMst          
    where   
        active = 1   
        and Exchange = @Exchange   
        and Segment =  @Segment          
        and effdate <= @Effdate + ' 23:59:59'         
        and Party_Code Between @FromParty And @ToParty     
        and Party_Code <> 'BROKER'      
    group by   
        Party_Code,   
        scrip_cd,   
        series,   
        isin          
    Having   
        SUM(Case when drcr = 'D' then -qty else qty end) <> 0         
  
 INSERT INTO #C_CalculateSecView_1  
 SELECT PARTY_CODE,   
 BALQTY = SUM(QTY),   
 SCRIP_CD, SERIES,   
 CERTNO  
 FROM MSAJAG.DBO.DELTRANS D, MSAJAG.DBO.DELIVERYDP DP  
 WHERE BDPTYPE = DP.DPTYPE  
 AND BDPID = DP.DPID  
 AND BCLTDPID = DP.DPCLTNO  
 AND PARTY_CODE <> 'BROKER'  
 AND PARTY_CODE <> 'PARTY'  
 AND TRTYPE in (904, 905, 909)  
 AND DRCR = 'D'   
 AND DELIVERED = '0'  
 AND FILLER2 = 1  
 AND SHARETYPE = 'DEMAT'  
 AND EXCHANGE = @EXCHANGE  
 AND SEGMENT = @SEGMENT  
 AND ACCOUNTTYPE = 'MAR' 
and Party_Code Between @FromParty And @ToParty 
 GROUP BY PARTY_CODE, SCRIP_CD, SERIES, CERTNO  
  
 INSERT INTO #C_CalculateSecView_1  
 SELECT PARTY_CODE,   
 BALQTY = SUM(QTY),   
 SCRIP_CD, SERIES,   
 CERTNO  
 FROM BSEDB.DBO.DELTRANS D, BSEDB.DBO.DELIVERYDP DP  
 WHERE BDPTYPE = DP.DPTYPE  
 AND BDPID = DP.DPID  
 AND BCLTDPID = DP.DPCLTNO  
 AND PARTY_CODE <> 'BROKER'  
 AND PARTY_CODE <> 'PARTY'  
 AND TRTYPE in (904, 905, 909)  
 AND DRCR = 'D'   
 AND DELIVERED = '0'  
 AND FILLER2 = 1  
 AND SHARETYPE = 'DEMAT'  
 AND EXCHANGE = @EXCHANGE  
 AND SEGMENT = @SEGMENT  
 AND ACCOUNTTYPE = 'MAR'
 AND Party_Code Between @FromParty And @ToParty  
 GROUP BY PARTY_CODE, SCRIP_CD, SERIES, CERTNO  
  
 SELECT PARTY_CODE,   
 BALQTY = SUM(BALQTY),   
 SCRIP_CD, SERIES, ISIN   
 INTO #C_CalculateSecView FROM #C_CalculateSecView_1  
 GROUP BY PARTY_CODE, SCRIP_CD, SERIES, ISIN  
  
/*=======================================================================  
    POPULATE DISTINCT CLIENT CODES FOR WHOM COLLATERAL CALCULATION IS TO BE DONE   
=======================================================================*/  
  
  
    Create Table  #C_PartyCode   
    (  
        Party_Code Varchar(10),  
        Cl_Type Varchar(10),   
        Record_Type Varchar(10)   
    )  
              
  
    /*======================================  
        FIXED DEPOSITS  
    ======================================*/  
        Insert into #C_PartyCode (Party_Code, Record_Type)        
        select   
            distinct Party_Code, 'FD'   
        from   
            Fixeddepositmst         
        Where   
            Exchange = @Exchange   
            and Segment = @Segment        
            and Party_Code Between @FromParty And @ToParty        
      
    /*======================================  
        BANK GUARANTEES  
    ======================================*/  
        Insert into #C_PartyCode (Party_Code, Record_Type)        
        select   
            distinct Party_Code, 'BG'    
        from   
            BankGuaranteemst        
        Where   
            Exchange = @Exchange   
            and Segment = @Segment        
            and Party_Code Between @FromParty And @ToParty        
      
  
    /*======================================  
        SECURITIES   
    ======================================*/  
        Insert into #C_PartyCode (Party_Code, Record_Type)        
        select   
            distinct Party_Code, 'SEC'   
        from   
            #C_CalculateSecView        
          
          
    /*======================================  
        CASH MARGINS  
    ======================================*/  
        Insert into #C_PartyCode (Party_Code, Record_Type)        
        select   
            distinct Party_Code, 'MARGIN'   
        from   
            C_MarginLedger        
        Where   
            Exchange = @Exchange   
            and Segment = @Segment        
            and Party_Code Between @FromParty And @ToParty        
      
      
    /*======================================  
        UPDATE FOR CLIENT TYPE   
    ======================================*/  
      
        Update #C_PartyCode   
        Set   
            Cl_Type = C.Cl_Type         
        From   
            ClientMaster C        
        where   
            #C_PartyCode.party_code = C.Party_Code        
        
  
/*=======================================================================  
    CREATE LATEST CLOSING PRICE INFORMATION FOR VALUATION OF SECURITIES  
=======================================================================*/  
  
    select   
        Scrip_cd,   
        Series,   
        Cl_Rate = isnull(Cl_Rate,0)          
    Into #C_valuation   
    From   
        C_valuation C1        
    where   
        exchange = @Exchange   
        and Segment = @Segment          
        and Sysdate = (Select max(sysdate) from c_valuation C2         
                                where exchange = @Exchange   
                                and Segment = @Segment        
                                and sysdate <= @Effdate + ' 23:59:59'         
                                and C1.Scrip_Cd = C2.Scrip_cd   
                                and C1.series = C2.Series)          
  
/*=======================================================================  
    BEGIN MAIN CURSOR @@CUR FOR CLIENT WISE COLLATERAL CALCULATION  
=======================================================================*/  
  
    Set @@Cur = Cursor For           
        SELECT   
            PARTY_CODE,   
            CL_TYPE,   
            FD = SUM(FD),  
            BG = SUM(BG),  
            SEC = SUM(SEC),  
            MARGIN = SUM(MARGIN)  
        FROM   
        (  
                Select   
                    party_code,    
                    Cl_type = isnull(Cl_type,'CLI'),    
                    FD = (CASE WHEN Record_Type = 'FD' THEN COUNT(1) ELSE 0 END),   
                    BG = (CASE WHEN Record_Type = 'BG' THEN COUNT(1) ELSE 0 END),   
                    SEC = (CASE WHEN Record_Type = 'SEC' THEN COUNT(1) ELSE 0 END),   
                    MARGIN = (CASE WHEN Record_Type = 'MARGIN' THEN COUNT(1) ELSE 0 END)   
                from   
                    #C_PartyCode          
                GROUP BY   
                    party_code,    
                    isnull(Cl_type,'CLI'),   
                    Record_Type  
        ) A  
        GROUP BY   
            PARTY_CODE,   
            CL_TYPE  
  
/*  
        Select   
            distinct party_code,    
            Cl_type = isnull(Cl_type,'CLI')    
        from   
            #C_PartyCode          
*/  
  
    Open @@Cur          
    Fetch Next from @@Cur into @@Party_code, @@Cl_Type, @@FD, @@BG, @@SEC, @@MARGIN   
        While @@Fetch_Status = 0          
        Begin  
			--select @@Party_code, @@Cl_Type, @@FD, @@BG, @@SEC, @@MARGIN        
            Set @@FdAmount   = 0           
            Set @@Balance  = 0          
            Set @@BgAmount = 0          
            Set @@marginamt = 0          
            Set @@Haircut   = 0          
            Set @@TotNonCash  = 0          
            Set @@TotCash = 0          
            Set @@Actualnoncash  = 0          
            Set @@Actualcash = 0          
            Set @@SecAmount = 0          
            Set @@TotalSecAmount= 0          
            Set @@TotalFdAmount  = 0          
            Set @@TotalBGAmount = 0          
            Set @@CashCompo = 0           
            Set @@NonCashCompo = 0          
            Set @@Cl_rate   = 0          
            Set @@Qty  = 0          
            Set  @@Haircut  = 0          
            Set @@Balance = 0          
            Set @@OrgCashNcash = 0               
            Set @@OrgTotCash = 0          
            Set @@OrgTotNonCash = 0  /*Set @@Cl_Type  = ''*/          
      
    /*=======================================================================  
        Get Cash and Noncash Composition  
    =======================================================================*/  
  
        Select @@CashCompo =   
        isnull  
        (  
            (   
                /*======================================  
                    SETTING AT PARTY LEVEL  
                ======================================*/  
                select Cash from CashComposition   
                where party_code = @@Party_code   
                and Exchange = @Exchange           
                and Segment = @Segment   
                and CLient_Type = ''   
              and Active = 1   
                and EffDate = (Select max(Effdate) from CashComposition           
                                        where EffDate <= @EffDate + ' 23:59'   
                                        and party_code = @@party_code   
                                        and Client_Type = ''   
                                        and Exchange = @Exchange           
                                        and Segment = @Segment    
                                        and Active = 1)),          
                    /*======================================  
                        SETTING AT CLIENT TYPE LEVEL  
                    ======================================*/  
                    isnull(( select Cash from CashComposition   
                    where party_code = ''   
                    and Exchange = @Exchange           
                    and Segment = @Segment   
                    and CLient_Type = @@Cl_Type  -- FOR CLIENT TYPE  
                    and Active = 1   
                    and EffDate = (Select max(Effdate) from CashComposition           
                                            where EffDate <= @EffDate + ' 23:59'   
                                            and party_code = ''   
                                            and CLient_Type = @@Cl_Type   
                                            and Exchange = @Exchange           
                                            and Segment = @Segment  and Active = 1)),          
                        /*======================================  
                            SETTING AT GLOBAL LEVEL  
                        ======================================*/  
                        isnull(( select Cash from CashComposition   
                        where party_code = ''   
                        and Exchange = @Exchange           
                        and Segment = @Segment   
                        and CLient_Type = ''    
                        and Active = 1   
                        and EffDate = (Select max(Effdate) from CashComposition           
                                                where EffDate <= @EffDate + ' 23:59'   
                                                and party_code = ''   
                                                and CLient_Type = ''   
                                                and Exchange = @Exchange           
                                                and Segment = @Segment    
                                                and Active = 1)),0)           
            )          
        ),          
        @@NonCashCompo =    
        isnull  
        (  
            (   
                /*======================================  
                    SETTING AT PARTY LEVEL  
                ======================================*/  
                select NonCash from CashComposition   
                where party_code = @@Party_code   
                and Exchange = @Exchange           
                and Segment = @Segment   
                and CLient_Type = ''    
                and Active = 1   
                and EffDate = (Select max(Effdate) from CashComposition           
                                        where EffDate <= @EffDate + ' 23:59'   
                                        and party_code = @@party_code   
                                        and CLient_Type = ''   
                                        and Exchange = @Exchange           
                                        and Segment = @Segment    
                                        and Active = 1)),          
                    /*======================================  
                        SETTING AT CLIENT TYPE LEVEL  
                    ======================================*/  
                    isnull(( select NonCash from CashComposition   
                    where party_code = ''   
                    and Exchange = @Exchange           
                    and Segment = @Segment   
                 and CLient_Type = @@Cl_Type    
                    and Active = 1   
                    and EffDate = (Select max(Effdate) from CashComposition           
                                            where EffDate <= @EffDate + ' 23:59'   
                                            and party_code = ''   
                                            and CLient_Type = @@Cl_Type   
                                            and Exchange = @Exchange           
                                            and Segment = @Segment    
                                            and Active = 1)),          
                        /*======================================  
                            SETTING AT GLOBAL LEVEL  
                        ======================================*/  
                        isnull(( select NonCash from CashComposition   
                        where party_code = ''   
                        and Exchange = @Exchange           
                        and Segment = @Segment   
                        and CLient_Type = ''    
                        and Active = 1   
                        and EffDate = (Select max(Effdate) from CashComposition           
                                                where EffDate <= @EffDate + ' 23:59'   
                                                and party_code = ''   
                                                and CLient_Type = ''   
                                                and Exchange = @Exchange           
                                                and Segment = @Segment    
                                                and Active = 1)),0)          
            )          
        )          
              
  
    /*=======================================================================  
        Get The Margin amount as a Cash Collateral  
    =======================================================================*/  
  
--        If (Select Count(1) From #C_PartyCode Where Party_Code = @@Party_Code And Record_Type = 'MARGIN') > 0    
        If @@MARGIN > 0    
        Begin  
            Set @@Marginamt  = 0          
              
            Select @@Marginamt = Isnull((Sum(Damt) - Sum(Camt)),0)   
            From C_MarginLedger   
            Where Party_code = @@Party_code          
            and Exchange = @Exchange           
            and Segment = @Segment          
            Group By Party_code          
          
            Set @@TotCash = @@TotCash + @@Marginamt               
              
            if @@Marginamt > 0           
            begin          
                Set @@OrgTotCash = @@OrgTotCash + @@Marginamt           
                Insert into  CollateralDetails   
                Select   
                    EffDate = @Effdate,   
                    Exchange = @Exchange,   
                    Segment = @Segment,   
                    Party_Code = @@Party_Code,   
                    Scrip_Cd =  '',   
                    Series = '',   
                    Isin = '',   
                    Cl_Rate = 0,   
                    Amount =  @@Marginamt,   
                    Qty = 0,   
                    HairCut = 0,   
                    FinalAmount =  @@Marginamt ,   
                    PercentageCash =   @@CashCompo ,   
                    PerecntageNonCash =  @@NonCashCompo,   
                    Receive_Date = '',   
                    Maturity_Date = '',   
                    Coll_Type =  'MARGIN',   
                    ClientType =  @@cl_type,   
                    Remarks = '',   
                    LoginName = '',   
                    LoginTime = getdate(),   
                    Cash_Ncash = 'C',   
                    Group_Code = '',   
                    Fd_Bg_No = '',   
                    Bank_Code = '',   
                    Fd_Type = ''   
            End          
        End  
  
    /*=======================================================================  
        Calculation for FD  
    =======================================================================*/  
  
--        If (Select Count(1) From #C_PartyCode Where Party_Code = @@Party_Code And Record_Type = 'FD') > 0    
        If @@FD > 0    
        Begin  
            Set @@InstruType  = 'FD'           
            select @@CashNcash =   
            isnull  
                (  
                    (   
                    /*======================================  
                        SETTING AT PARTY LEVEL  
                    ======================================*/  
                        select Cash_Ncash from InstruTypeMst   
                            where party_code = @@Party_code   
                            and Exchange = @Exchange           
                            and Segment = @Segment   
                            and CLient_Type = ''   
                            and Instru_Type = @@InstruType    
                            and Active = 1          
                            and EffDate = (Select max(Effdate) from InstruTypeMst           
                                                    where EffDate <= @EffDate + ' 23:59'   
                                                    and party_code = @@party_code   
                                                    and CLient_Type = ''   
                                                    and Exchange = @Exchange           
                                                    and Segment = @Segment   
                                                    and Instru_Type = @@InstruType    
                                                    and Active = 1)),          
                        /*======================================  
                            SETTING AT CLIENT TYPE LEVEL  
                        ======================================*/  
                            isnull(( select Cash_Ncash from InstruTypeMst   
                                where party_code = ''   
                                and Exchange = @Exchange           
                                and Segment = @Segment   
                                and CLient_Type = @@Cl_Type   
                                and CLient_Type <> ''   
                                and Instru_Type = @@InstruType    
                                and Active = 1          
                                and EffDate = (Select max(Effdate) from InstruTypeMst           
                                                        where EffDate <= @EffDate + ' 23:59'   
                                                        and party_code = ''   
                                                        and CLient_Type = @@Cl_Type   
                                                        and Exchange = @Exchange           
                                                        and Segment = @Segment   
                                                        and Instru_Type = @@InstruType   
                                                        and Active = 1)),          
                            /*======================================  
                                SETTING AT GLOBAL LEVEL  
                            ======================================*/  
                                isnull(( select Cash_Ncash from InstruTypeMst   
                                    where party_code = ''   
                                    and Exchange = @Exchange           
                                    and Segment = @Segment   
                                    and CLient_Type = ''   
                                    and Instru_Type = @@InstruType    
                                    and Active = 1          
                                    and EffDate = (Select max(Effdate) from InstruTypeMst           
                                                            where EffDate <= @EffDate + ' 23:59'   
                                                            and party_code = ''   
                                                            and CLient_Type = ''   
                                                         and Exchange = @Exchange           
                                                            and Segment = @Segment   
                                                            and Instru_Type = @@InstruType    
                                                            and Active = 1)),'')          
                    )          
                )            
  
            Set @@OrgCashNcash = 0          
  
            Set @@GetFdBg = Cursor for            
                select   
                    Balance = isnull(sum(balance),0) ,   
                    fm.Bank_Code,   
                    fm.FD_Type,   
                    fm.Fdr_No,   
                    Fm.Receive_Date,   
                    fm.Maturity_Date          
                From   
                    FixedDepositTrans F,   
                    FixedDepositMst Fm          
                where   
                    F.Trans_Date = (select max(f1.Trans_Date) from FixedDepositTrans F1          
                                                where f.party_code = f1.party_code   
                                                and f.bank_code = f1.bank_code   
                                                and f.fdr_no = f1.fdr_no          
                                                and f1.Trans_Date <=  @EffDate + ' 23:59'   
                                                and f1.branch_code = f1.branch_code           
                                                and F1.Tcode = F.Tcode)          
                    and F.Party_Code = @@Party_Code   
                    and Fm.Exchange = @Exchange   
                    and Fm.Segment = @Segment   
                    and f.branch_code = fm.branch_code          
                    and fm.party_Code = f.party_code   
                    and fm.Bank_Code = f.Bank_Code   
                    and fm.Fdr_no = f.Fdr_No   
                    and fm.Status <> 'C'    
                    and @EffDate + ' 23:59:59' >= fm.receive_date   
                    and @EffDate +' 00:00:00' < = fm.maturity_date    
                    and Fm.Tcode = F.Tcode          
                Group By   
                    fm.Bank_Code, fm.FD_Type,fm.Fdr_No, Fm.Receive_Date, fm.Maturity_Date          
              
                Open @@GetFdBg          
                Fetch Next from @@GetFdBg into   
                    @@Balance,   
                    @@Bank_Code,   
                    @@Fd_Type,   
                    @@Fdr_no,   
                    @@Receive_Dt,   
                    @@Maturity_DT           
                While @@Fetch_Status = 0          
                Begin          
                    select @@Haircut =   
                        isnull  
                            (  
                                (  
                                /*======================================  
                                    SETTING AT PARTY CODE + BANK CODE LEVEL  
                                ======================================*/  
                                    select haircut from fdhaircut   
                                    where party_code = @@party_code   
                                    and bank_code = @@bank_code   
                                    and Exchange = @Exchange   
                                    and Segment = @Segment   
                                    and Active = 1   
                                    and EffDate = (Select max(Effdate) from fdhaircut           
                                                            where EffDate <= @EffDate + ' 23:59'   
                                                            and party_code = @@party_code   
                                                            and bank_code = @@bank_code   
                                                            and Exchange = @Exchange   
                                                            and Segment = @Segment   
                         and Active = 1)),          
                                    /*======================================  
                                        SETTING AT PARTY CODE LEVEL  
                                    ======================================*/  
                                        isnull((select haircut from fdhaircut   
                                            where party_code = @@party_code   
                                            and bank_code = ''   
                                            and Fd_Type = @@Fd_Type   
                                            and Exchange = @Exchange           
                                            and Segment = @Segment   
                                            and Active = 1   
                                            and EffDate = (Select max(Effdate) from fdhaircut   
                                                                    where EffDate <= @EffDate + ' 23:59'            
                                                                    and party_code = @@party_code   
                                                                    and bank_code = ''   
                                                                    and Fd_Type = @@Fd_Type   
                                                                    AND Exchange = @Exchange   
                                                                    and Segment = @Segment   
                                                                    and Active = 1)),          
                                        /*======================================  
                                            SETTING AT BANK CODE LEVEL  
                                        ======================================*/  
                                            isnull((select haircut from fdhaircut   
                                                where party_code = ''   
                                                and bank_code = @@bank_code   
                                                and Exchange = @Exchange   
                                                and Segment = @Segment   
                                                and Active = 1   
                                                and EffDate = (Select max(Effdate) from fdhaircut   
                                                                        where EffDate <= @EffDate + ' 23:59'   
                                                                        and party_code = ''   
                                                                        and bank_code = @@bank_code   
                                                                        AND Exchange = @Exchange   
                                                                        and Segment = @Segment   
                                                                        and Active = 1)),          
                                            /*======================================  
                                                SETTING AT CLIENT TYPE LEVEL  
                                            ======================================*/  
                                                Isnull((SELECT haircut from fdhaircut   
                                                    where party_code = ''   
                                                    and bank_code = ''   
                                                    and Client_Type = @@Cl_Type   
                                                    and Client_Type <> ''   
                                                    and Active = 1   
                                                    and Exchange = @Exchange   
                                                    and Segment = @Segment   
                                                    and EffDate = (Select max(Effdate) from fdhaircut   
                                                                            where EffDate <= @EffDate + ' 23:59'   
                                                                    and party_code = ''   
                                                                            and bank_code = ''   
                                                                            and Client_Type = @@Cl_Type   
                                                                            and Client_Type <> ''   
                                                                            AND Exchange = @Exchange   
                                                                            and Segment = @Segment   
                                                                            and Active = 1)),          
                                                /*======================================  
                                                    SETTING AT GLOBAL LEVEL  
                                                ======================================*/  
                                                    isnull((select haircut from fdhaircut   
                                                        where party_code = ''   
                                                        and bank_code = ''   
                                                        and client_type = ''   
                                                        and Exchange = @Exchange   
                                                        and Segment = @Segment   
                                                        and Active = 1   
                                                        and EffDate = (Select max(Effdate) from fdhaircut   
                                                                                where EffDate <= @EffDate + ' 23:59'   
                                                                                and party_code = ''   
                                                                                and bank_code = ''    
                                                                                and client_type = ''   
                                                                                AND Exchange = @Exchange   
                                                                                and Segment = @Segment   
                                                                                and Active = 1)),0)    
                                        )          
                                    )          
                                )          
                            )          
                      
                    Set @@OrgCashNcash = @@OrgCashNcash + @@Balance  /*Added By vaishali on 21/03/2002*/          
                      
                    Set @@FdAmount = @@Balance - ( @@Balance * @@haircut/100)           
              
                    Set @@TotalFdAmount = @@TotalFdAmount + @@FdAmount             
                      
                    Insert into  CollateralDetails   
                    Select   
                        EffDate = @Effdate,   
                        Exchange = @Exchange,   
                        Segment = @Segment,   
                        Party_Code = @@Party_Code,   
                        Scrip_Cd = '',   
                        Series = '',   
                        Isin = '',   
                        Cl_Rate = 0,   
                        Amount = @@Balance,   
                        Qty = 0,   
                        HairCut = @@haircut,   
                        FinalAmount =  @@FdAmount,   
                        PercentageCash =  @@CashCompo ,   
                        PerecntageNonCash = @@NonCashCompo,   
                        Receive_Date =  @@Receive_Dt,   
                        Maturity_Date = @@Maturity_Dt,   
                        Coll_Type =  'FD',   
                        ClientType =  @@cl_type ,   
                        Remarks = '',   
                        LoginName = '',   
   LoginTime = getdate(),   
                        Cash_Ncash = @@CashNCash,   
                        Group_Code = '',   
                        Fd_Bg_No = @@Fdr_No,   
                        Bank_Code = @@Bank_Code,   
                        Fd_Type = @@Fd_Type   
                      
                    Fetch Next from @@GetFdBg into   
                        @@Balance,   
                        @@Bank_Code,   
                        @@Fd_Type,   
                        @@Fdr_no,   
                        @@Receive_Dt,   
                        @@Maturity_DT           
                End          
              
            If @@CashNcash = 'C'          
            begin          
                set @@TotCash = @@TotCash + @@TotalFdAmount          
                Set @@OrgTotCash = @@OrgTotCash + @@OrgCashNcash            
            end          
            Else if @@CashNcash = 'N'          
            begin          
                set @@TotNonCash = @@TotNonCash + @@TotalFdAmount          
                Set @@OrgTotNonCash = @@OrgTotNonCash + @@OrgCashNcash            
            end           
            Else          
            Begin          
                set @@TotCash = @@TotCash + @@TotalFdAmount          
                Set @@OrgTotCash = @@OrgTotCash + @@OrgCashNcash           
            End          
          
            close @@GetFdBg          
            deallocate @@GetFdBg              
        End  
  
    Set @@OrgCashNcash = 0          
  
    /*=======================================================================  
        Calculation for BG  
    =======================================================================*/  
  
--        If (Select Count(1) From #C_PartyCode Where Party_Code = @@Party_Code And Record_Type = 'BG') > 0    
        If @@BG > 0    
        Begin  
            Set @@InstruType  = 'BG'           
            select @@CashNcash =   
            isnull  
                (  
                    (   
                    /*======================================  
                        SETTING AT PARTY LEVEL  
                    ======================================*/  
                        select Cash_Ncash from InstruTypeMst   
                        where party_code = @@Party_code   
                        and Exchange = @Exchange           
                        and Segment = @Segment   
                        and CLient_Type = ''   
                        and Instru_Type = @@InstruType    
                        and Active = 1          
                        and EffDate = (Select max(Effdate) from InstruTypeMst           
                                                where EffDate <= @EffDate + ' 23:59'   
                                                and party_code = @@party_code   
                                                and CLient_Type = ''   
                                                and Exchange = @Exchange           
                                                and Segment = @Segment   
                                                and Instru_Type = @@InstruType    
                                                and Active = 1)),          
                        /*======================================  
                            SETTING AT CLIENT TYPE LEVEL  
                        ======================================*/  
                            isnull(( select Cash_Ncash from InstruTypeMst   
                                        where party_code = ''   
                                        and Exchange = @Exchange           
                                        and Segment = @Segment   
                                        and CLient_Type = @@Cl_Type   
                                        and CLient_Type <> ''   
                                        and Instru_Type = @@InstruType    
                                        and Active = 1          
                                        and EffDate = (Select max(Effdate) from InstruTypeMst        
        where EffDate <= @EffDate + ' 23:59'   
                                                                and party_code = ''   
                                                                and CLient_Type = @@Cl_Type   
                                                                and Exchange = @Exchange           
                                                                and Segment = @Segment   
                                                                and Instru_Type = @@InstruType   
                                                                and Active = 1)),          
                            /*======================================  
                                SETTING AT GLOBAL LEVEL  
                            ======================================*/  
                                isnull(( select Cash_Ncash from InstruTypeMst   
                                            where party_code = ''   
                                            and Exchange = @Exchange           
                                            and Segment = @Segment   
                                            and CLient_Type = ''   
                                            and Instru_Type = @@InstruType    
                                            and Active = 1          
                                            and EffDate = (Select max(Effdate) from InstruTypeMst           
                                                                    where EffDate <= @EffDate + ' 23:59'   
                                                                    and party_code = ''   
                                                                    and CLient_Type = ''   
                                                                    and Exchange = @Exchange           
                                                                    and Segment = @Segment   
                                                                    and Instru_Type = @@InstruType   
                                                                    and Active = 1)),'')          
                    )          
                )            
  
        Set @@GetFdBg = Cursor for          
            select   
                Balance = isnull(sum(balance),0) ,   
                fm.Bank_Code ,  
                fm.Bg_No,   
                Fm.Receive_Date,   
                fm.Maturity_Date          
            From   
                BankGuaranteeTrans F,   
                BankGuaranteeMst Fm          
                where F.Trans_Date = (select max(f1.Trans_Date) from BankGuaranteeTrans F1          
                                                        where f.party_code = f1.party_code   
                                                        and f.bank_code = f1.bank_code   
                                                        and f.Bg_no = f1.BG_no          
                                                        and f1.Trans_Date <=  @EffDate + ' 23:59'   
                                                        and f1.branch_code = f1.branch_code           
                                                        and F1.Tcode = F.Tcode)          
                and F.Party_Code = @@Party_Code   
                and Fm.Exchange = @Exchange   
                and Fm.Segment = @Segment   
                and f.branch_code = fm.branch_code          
                and fm.party_Code = f.party_code   
                and fm.Bank_Code = f.Bank_Code   
                and fm.Bg_no = f.Bg_No   
                and fm.Status <> 'C'   
                and @EffDate +' 23:59:59' >= fm.receive_date   
                and @EffDate +' 00:00:00' <= fm.maturity_date   
                and Fm.Tcode = F.Tcode          
            Group By   
                fm.Bank_Code, fm.Bg_No, Fm.Receive_Date, fm.Maturity_Date            
  
            Open @@GetFdBg          
            Fetch Next from @@GetFdBg into   
       @@Balance,   
                @@Bank_Code,   
                @@bg_no,   
                @@Receive_Dt,   
                @@Maturity_DT           
            While @@Fetch_Status = 0          
            Begin          
                select @@Haircut =   
                isnull  
                    (  
                        (  
                        /*======================================  
                            SETTING AT PARTY CODE + BANK CODE LEVEL  
                        ======================================*/  
                            select haircut from bghaircut   
                            where party_code = @@party_code   
                            and bank_code = @@bank_code   
                            and Exchange = @Exchange   
                            and Segment = @Segment   
                            and Active = 1   
                            and EffDate = (Select max(Effdate) from bghaircut           
                                                    where EffDate <= @EffDate + ' 23:59'   
                                                    and party_code = @@party_code   
                                                    and bank_code = @@bank_code   
                                                    AND Exchange = @Exchange   
                                                    and Segment = @Segment   
                                                    and Active = 1)),          
                            /*======================================  
                                SETTING AT PARTY CODE LEVEL  
                            ======================================*/  
                            isnull((select haircut from bghaircut   
                                        where party_code = @@party_code   
                                        and bank_code = ''   
                                        and Exchange = @Exchange           
                                        and Segment = @Segment   
                                        and Active = 1   
                                        and EffDate = (Select max(Effdate) from bghaircut   
                                                                where EffDate <= @EffDate + ' 23:59'           
                                                                and party_code = @@party_code   
                                                                and bank_code = ''   
                                                                AND Exchange = @Exchange   
                                                                and Segment = @Segment   
                                                                and Active = 1)),          
                                /*======================================  
                                    SETTING AT BANK CODE LEVEL  
                                ======================================*/  
                                isnull((select haircut from bghaircut   
                                            where party_code = ''   
                                            and bank_code = @@bank_code   
                                            and Exchange = @Exchange   
                                            and Segment = @Segment   
                                            and Active = 1   
                                            and EffDate = (Select max(Effdate) from bghaircut   
                                                                    where EffDate <= @EffDate + ' 23:59'   
                                                                    and party_code = ''   
                                                                    and bank_code = @@bank_code   
                                                                    AND Exchange = @Exchange   
                                                                    and Segment = @Segment   
                                                                    and Active = 1)),      
                                    /*======================================  
                                        SETTING AT CLIENT TYPE LEVEL  
                                    ======================================*/  
                                    Isnull((SELECT haircut from bghaircut   
                                                where party_code = ''   
                                                and bank_code = ''   
                                                and Client_Type = @@Cl_Type   
                                                and Client_Type <> ''    
                                                and Exchange = @Exchange   
                                                and Segment = @Segment           
                                                and Active = 1   
                                                and EffDate = (Select max(Effdate) from bghaircut   
                                                                        where EffDate <= @EffDate + ' 23:59'   
                                                                        and party_code = ''   
                                                                        and bank_code = ''   
                                                                        and Client_Type = @@Cl_Type   
                                                                        and Client_Type <> ''   
                                                                        AND Exchange = @Exchange   
                                                                        and Segment = @Segment   
                                                                        and Active = 1)),          
                                        /*======================================  
                                            SETTING AT GLOBAL LEVEL  
                                        ======================================*/  
                                        isnull((select haircut from bghaircut   
                                                    where party_code = ''   
                                                    and bank_code = ''   
                                                    and client_type = ''           
                                                    and Active = 1   
                                                    and Exchange = @Exchange   
                                                    and Segment = @Segment   
                                                    and EffDate = (Select max(Effdate) from bghaircut   
                                                                            where EffDate <= @EffDate + ' 23:59'   
                                                                            and party_code = ''   
                                                                            and bank_code = ''    
                                                                            and client_type = ''    
                                                                            AND Exchange = @Exchange   
                                                                            and Segment = @Segment   
                                                                            and Active = 1)),0)          
                                )          
                            )          
                        )          
                    )          
                  
                Set @@OrgCashNcash = @@OrgCashNcash + @@Balance           
                  
                Set @@BgAmount = @@Balance - ( @@Balance * @@haircut/100)           
                Set @@TotalBgAmount = @@TotalBgAmount + @@BgAmount          
                  
                Insert into  CollateralDetails   
                Select    
                    EffDate = @Effdate,   
                    Exchange = @Exchange,   
                    Segment = @Segment,   
                    Party_Code = @@Party_Code,   
             Scrip_Cd = '',   
                    Series = '',   
  Isin = '',   
                    Cl_Rate = 0,   
                    Amount = @@Balance,   
                    Qty = 0,   
                    HairCut = @@haircut,   
                    FinalAmount =  @@BgAmount,   
                    PercentageCash =  @@CashCompo ,   
                    PerecntageNonCash = @@NonCashCompo,   
                    Receive_Date =  @@Receive_Dt,   
                    Maturity_Date = @@Maturity_Dt,   
                    Coll_Type =  'BG',   
                    ClientType =  @@cl_type ,   
                    Remarks = '',   
                    LoginName = '',   
                    LoginTime = getdate(),   
                    Cash_Ncash = @@CashNCash,   
                    Group_Code = '',   
                    Fd_Bg_No = @@Bg_No,   
                    Bank_Code = @@Bank_Code,   
                    Fd_Type = 'B'   
                  
                Fetch Next from @@GetFdBg into   
                    @@Balance,   
                    @@Bank_Code,   
                    @@Bg_no,   
                    @@Receive_Dt,   
                    @@Maturity_DT           
            End          
  
            If @@CashNcash = 'C'          
            begin          
                set @@TotCash = @@TotCash + @@TotalBgAmount          
                Set @@OrgTotCash = @@OrgTotCash + @@OrgCashNcash            
            end          
            Else if @@CashNcash = 'N'          
            begin          
                set @@TotNonCash = @@TotNonCash + @@TotalBgAmount          
                Set @@OrgTotNonCash = @@OrgTotNonCash + @@OrgCashNcash            
            end           
            Else          
            Begin          
                set @@TotCash = @@TotCash + @@TotalBgAmount          
                Set @@OrgTotCash = @@OrgTotCash + @@OrgCashNcash           
            End          
            close @@GetFdBg          
            deallocate @@GetFdBg                
        End  
  
    Set @@OrgCashNcash  = 0          
  
    /*=======================================================================  
        Calculation for SEC  
    =======================================================================*/  
  
--        If (Select Count(1) From #C_PartyCode Where Party_Code = @@Party_Code And Record_Type = 'SEC') > 0    
        If @@SEC > 0    
        Begin  
            Set @@InstruType  = 'SEC'           
            select @@CashNcash =   
            isnull  
                (  
                    (   
                    /*======================================  
                        SETTING AT PARTY LEVEL  
                    ======================================*/  
                        select Cash_Ncash from InstruTypeMst   
                        where party_code = @@Party_code   
                        and Exchange = @Exchange           
                        and Segment = @Segment   
                        and CLient_Type = ''   
                        and Instru_Type = @@InstruType   
                        and Active = 1          
                        and EffDate = (Select max(Effdate) from InstruTypeMst           
                                                where EffDate <= @EffDate + ' 23:59'   
                                                and party_code = @@party_code   
                                                and CLient_Type = ''   
                                                and Exchange = @Exchange           
                                                and Segment = @Segment   
                                                and Instru_Type = @@InstruType   
                                                and Active = 1)),          
                        /*======================================  
                            SETTING AT CLIENT TYPE LEVEL  
                        ======================================*/  
                            isnull(( select Cash_Ncash from InstruTypeMst   
                            where party_code = ''   
     and Exchange = @Exchange           
                            and Segment = @Segment   
                            and CLient_Type = @@Cl_Type   
                            and CLient_Type <> ''   
                            and Instru_Type = @@InstruType    
                            and Active = 1          
                            and EffDate = (Select max(Effdate) from InstruTypeMst           
                                                    where EffDate <= @EffDate + ' 23:59'   
                                                    and party_code = ''   
                                                    and CLient_Type = @@Cl_Type   
                                                    and Exchange = @Exchange           
                                                    and Segment = @Segment   
                                                    and Instru_Type = @@InstruType    
                                                    and Active = 1)),          
                            /*======================================  
                                SETTING AT GLOBAL LEVEL  
                            ======================================*/  
                                isnull(( select Cash_Ncash from InstruTypeMst   
                                where party_code = ''   
                                and Exchange = @Exchange           
                                and Segment = @Segment   
                                and CLient_Type = ''   
                                and Instru_Type = @@InstruType    
                                and Active = 1          
                                and EffDate = (Select max(Effdate) from InstruTypeMst           
                                                        where EffDate <= @EffDate + ' 23:59'   
                                                        and party_code = ''   
                                                        and CLient_Type = ''   
                                                        and Exchange = @Exchange           
                                                        and Segment = @Segment   
                                                        and Instru_Type = @@InstruType    
                                                        and Active = 1)),'')          
                    )   
                )   
  
  
        /*======================================  
            Take cashnoncah  
        ======================================*/  
          
            Set @@GetFdBg = Cursor for          
                select   
                    BalQty,   
                    Scrip_Cd,   
                    Series,   
                    IsIn          
                from   
                    #C_CalculateSecView          
                where   
                    party_code = @@Party_Code         
                Order BY   
                    Scrip_cd, Series          
              
                Open @@GetFdBg          
                Fetch Next from @@GetFdBg into   
                    @@Qty,   
                    @@Scrip_Cd,   
                    @@Series,   
                    @@Isin          
            While @@Fetch_Status = 0          
            Begin            
            /*Take the group code*/ 
--select    @@Qty, @@Scrip_Cd,@@Series,@@Isin          
                select TOP 1 @@Group_cd = group_code  from groupmst   
                where scrip_cd = @@Scrip_Cd   
                and series like @@Series + '%'          
                and exchange = @Exchange   
                and segment = @Segment   
                and active = 1          
                and effdate = (select max(effdate) from groupmst     
                                        where scrip_cd = @@Scrip_Cd   
                                        and series like @@Series + '%'          
                                        and exchange = @Exchange   
                                        and segment = @Segment          
                                        and effdate <= @EffDate + ' 23:59:59'   
                                        and active = 1)          
  
        /*======================================  
            Take the Closing Rate  
        ======================================*/  
            select @@Cl_Rate = isnull(Cl_Rate,0)  From #C_valuation   
            where Scrip_Cd = @@Scrip_cd    
            and series like @@Series + '%'              
  
            Set @@SecAmount = (@@Qty * @@Cl_Rate)          
            Set @@OrgCashNcash = @@OrgCashNcash + @@SecAmount  /*Added by vaishali on 20-03-2002*/          
    
	 Select @@NewScrip_Cd = @@Scrip_Cd
	 Select @@NewSeries = @@Series
	 if @Exchange <> 'BSE'
	 Begin	
		if @@Series = 'BSE' 
		Begin
			Select @@NewScrip_Cd = Scrip_Cd, @@NewSeries = Series 
			From MSAJAG.DBO.MultiIsin
			Where isin = @@isin
			And Valid = 1
			if @@NewScrip_Cd is null or @@NewSeries is null
			begin
				 Select @@NewScrip_Cd = @@Scrip_Cd
				 Select @@NewSeries = @@Series
			end
		End
	 End

     set @@Haircut = -1  
        /*======================================  
            Take the haircut  
        ======================================*/  
     if @VarFlag = 1   
     Begin  
      Select @@Haircut = IsNull((Select Varmarginrate from vardetail V, Varcontrol C  
           Where V.DetailKey = C.DetailKey  
           and Scrip_Cd = @@NewScrip_Cd   
           and Series = @@NewSeries       
           and C.RecDate = (Select Max(C.RecDate) From vardetail V, Varcontrol C  
           Where V.DetailKey = C.DetailKey  
           and Scrip_Cd = @@NewScrip_Cd   
                         and Series = @@NewSeries       
           and C.RecDate <= @EffDate + ' 23:59')), -1)  
      if @@Haircut = -1  
      begin                
      Select @@Haircut = IsNull((Select Varmarginrate from vardetail V, Varcontrol C  
           Where V.DetailKey = C.DetailKey  
           and Scrip_Cd = @@NewScrip_Cd   
                         and Series = @@NewSeries       
           and C.RecDate = (Select Max(C.RecDate) From vardetail V, Varcontrol C  
           Where V.DetailKey = C.DetailKey  
           and Scrip_Cd = @@NewScrip_Cd   
                         and Series = @@NewSeries       
           and C.RecDate <= @EffDate + ' 23:59')), -1)  
      end  
     end    
     if @@Haircut = -1  
     begin   
            select @@Haircut =   
            isnull  
                (  
                    (  
                    /*======================================  
                        SETTING AT PARTY + SCRIP LEVEL  
                    ======================================*/  
                        select haircut from securityhaircut   
                        where party_code = @@party_code   
                        and Scrip_Cd = @@NewScrip_Cd   
                        and Series = @@NewSeries   
                        and Exchange = @Exchange   
                        and Segment = @Segment   
                        and Active = 1   
                        and EffDate = (Select max(Effdate) from securityhaircut           
                                                where EffDate <= @EffDate + ' 23:59'   
                                                and party_code = @@party_code   
                                                and Scrip_Cd = @@NewScrip_Cd   
                                                and Series = @@NewSeries   
                                                AND Exchange = @Exchange   
                                                and Segment = @Segment   
                                                and Active = 1)),          
                        /*======================================  
                            SETTING AT PARTY LEVEL  
                        ======================================*/  
                            isnull((select haircut from securityhaircut   
                                        where party_code = @@party_code   
                                        and Scrip_Cd = ''   
                                        and Exchange = @Exchange           
                                        and Segment = @Segment   
                                        and Active = 1   
                                        and EffDate = (Select max(Effdate) from securityhaircut   
                                                                where EffDate <= @EffDate + ' 23:59'           
                                                           and party_code = @@party_code   
                                                                and Scrip_Cd = ''   
                                                                AND Exchange = @Exchange   
                                                                and Segment = @Segment   
                                                                and Active = 1)),          
                            /*======================================  
                                SETTING AT SCRIP LEVEL  
                            ======================================*/  
                                isnull((select haircut from securityhaircut   
                                            where party_code = ''   
                                            and Scrip_Cd = @@NewScrip_Cd   
                                            and Series = @@NewSeries   
                                            And Exchange = @Exchange   
                                            and Segment = @Segment   
                                            and Active = 1   
                                            and EffDate = (Select max(Effdate) from securityhaircut   
                                                                    where EffDate <= @EffDate + ' 23:59'   
                                                                    and party_code = ''   
                                                                    and Scrip_Cd = @@NewScrip_Cd   
                                                                    and Series = @@NewSeries   
                                                                    And Exchange = @Exchange   
                                                                    and Segment = @Segment   
                                                                    and Active = 1)),          
                                /*======================================  
                                    SETTING AT SCRIP GROUP LEVEL  
                                ======================================*/  
                                    Isnull((SELECT haircut from securityhaircut   
                                                where party_code = ''   
                                                and Scrip_Cd = ''   
                                                and Group_Cd = @@Group_Cd   
                                                and Group_Cd <> ''    
                                                and Exchange = @Exchange   
                                                and Segment = @Segment           
                                                and Active = 1   
                                                and EffDate = (Select max(Effdate) from securityhaircut   
                                                                        where EffDate <= @EffDate + ' 23:59'   
                                                                        and party_code = ''   
                                                                        and Scrip_Cd = ''   
                                                                        and Group_Cd = @@Group_Cd   
                                                                        and Group_Cd <> ''   
                                                                        AND Exchange = @Exchange   
                                                                        and Segment = @Segment   
                                                                        and Active = 1)),          
                                    /*======================================  
                                        SETTING AT CLIENT TYPE LEVEL  
                                    ======================================*/  
                                        Isnull((SELECT haircut from securityhaircut   
                                                    where party_code = ''   
                                 and Scrip_Cd = ''   
                                                    and Client_Type = @@Cl_Type   
                                                    and Client_Type <> ''    
                                                    and Exchange = @Exchange   
                                                    and Segment = @Segment           
                                                    and Active = 1   
                                                    and EffDate = (Select max(Effdate) from securityhaircut   
                                                                            where EffDate <= @EffDate + ' 23:59'   
                                                                            and party_code = ''   
                                                                            and Scrip_Cd = ''   
                                                                            and Client_Type = @@Cl_Type   
                                                                            and Client_Type <> ''   
                                                                            AND Exchange = @Exchange   
                                                                            and Segment = @Segment   
                                                                            and Active = 1)),          
                                    /*======================================  
                                        SETTING AT GLOBAL LEVEL  
                                    ======================================*/  
                                            isnull((select haircut from securityhaircut   
                                                        where party_code = ''   
                                                        and Scrip_Cd = ''   
                                                        and client_type = ''   
                                                        and Group_cd = ''          
                                                        and Active = 1   
                                                        and Exchange = @Exchange   
                                                        and Segment = @Segment   
                                                        and EffDate = (Select max(Effdate) from securityhaircut   
                                                                                where EffDate <= @EffDate + ' 23:59'   
                                                                                and party_code = ''   
                                                                                and Scrip_Cd = ''    
                                                                                and client_type = ''    
                                                                                and Group_cd = ''   
                                                                                AND Exchange = @Exchange   
                                                                                and Segment = @Segment   
                                                                                and Active = 1)), -1)          
                                )          
                            )          
                        )          
                    )          
                )          
     end  
     if @@Haircut = -1  
     begin      
  select @@HairCut = 100  
     end    
  
            Set  @@SecAmount = @@SecAmount - (@@SecAmount * @@Haircut/100)          
              
            Set @@TotalSecAmount = @@TotalSecAmount + @@SecAmount          
  
                Insert into  CollateralDetails   
                Select    
                    EffDate = @EffDate,   
                    Exchange = @Exchange,   
                    Segment = @Segment,   
                    Party_Code = @@Party_Code,   
                    Scrip_Cd = @@NewScrip_Cd,   
                    Series = @@NewSeries,   
					Isin = @@isin,   
                    Cl_Rate = @@Cl_rate,   
                    Amount = (@@Cl_rate * @@Qty),   
					Qty =  @@Qty,   
                    HairCut =  @@haircut,   
                    FinalAmount =  @@SecAmount ,   
                    PercentageCash =  @@CashCompo ,   
                    PerecntageNonCash =  @@NonCashCompo ,   
                    Receive_Date = '',   
                    Maturity_Date = '',   
                    Coll_Type = 'SEC',   
                    ClientType =  @@cl_type,   
                    Remarks = '',   
                    LoginName = '',   
                    LoginTime = getdate(),   
                    Cash_Ncash = @@CashNCash,   
                    Group_Code = '',   
                    Fd_Bg_No = '',   
                    Bank_Code = '',   
                    Fd_Type = ''   
  
                Fetch Next from @@GetFdBg into   
                    @@Qty,   
                    @@Scrip_Cd,   
                    @@Series,   
                    @@Isin            
            End          
  
            If @@CashNcash = 'C'          
            begin            
                set @@TotCash = @@TotCash + @@TotalSecAmount          
                Set @@OrgTotCash = @@OrgTotCash + @@OrgCashNcash            
            end          
            Else if @@CashNcash = 'N'          
            begin            
                set @@TotNonCash = @@TotNonCash + @@TotalSecAmount          
                Set @@OrgTotNonCash = @@OrgTotNonCash + @@OrgCashNcash            
            end           
            Else           
            Begin            
                set @@TotNonCash = @@TotNonCash + @@TotalSecAmount          
                Set @@OrgTotNonCash = @@OrgTotNonCash + @@OrgCashNcash            
            End          
  
            close @@GetFdBg          
            deallocate @@GetFdBg               
        End          
  
    Set @@TotalCashNonCash = @@TotCash + @@TotNonCash          
  
    /*=======================================================================  
        Apply the Cash Composition Ratio  
    =======================================================================*/  
  
        If (@@CashCompo = 0)   
        Begin          
            Set @@Actualcash = @@TotCash          
            Set @@Actualnoncash = @@TotNonCash          
            Set @@EffectiveColl = @@TotalCashNonCash          
        End          
        Else          
        Begin          
            If @@TotCash <  @@TotNonCash          
            Begin         
                Set @@Actualcash = @@TotCash             
                if @@CashCompo > 0           
                Begin         
                    Set @@Actualnoncash1 = (@@TotCash *100)/ @@CashCompo          
                End          
                Else       
                Begin          
                    Set @@Actualnoncash1 = 0          
                End          
              
                If @@Actualnoncash1 < @@TotalCashNonCash          
                Begin          
                    Set @@EffectiveColl = @@Actualnoncash1          
                End          
                Else          
                Begin          
                    Set @@EffectiveColl = @@TotalCashNonCash          
                End              
            End          
            Else          
            Begin          
                Set @@Actualcash = @@TotCash          
                Set @@Actualnoncash = @@TotNonCash          
                Set @@EffectiveColl = @@TotalCashNonCash          
            End           
        End          
          
        Set @@Actualnoncash = @@EffectiveColl - @@Actualcash    
		Set @@Actualcash = @@TotCash          
        Set @@Actualnoncash = @@TotNonCash          
        Set @@EffectiveColl = @@TotalCashNonCash       
  
        If @@TotCash <> 0 Or @@TotNonCash <> 0          
        Begin            
            Set @Status = 1          
            Insert into  Collateral   
            Select  
                Exchange = @Exchange,   
                Segment = @Segment,   
                Party_Code = @@Party_Code,   
                Trans_Date =  @EffDate,   
                Cash = @@TotCash,   
                NonCash =  @@TotNonCash,   
                ActualCash =  @@Actualcash,   
                ActualNonCash =  @@Actualnoncash,   
                EffectiveColl = @@EffectiveColl,   
                Active = 1,   
                TCode = 0,   
                Remarks = '',   
                LoginName = '',   
                LoginTime = getdate(),   
                TotalFd =  @@TotalFdAmount ,   
                TotalBg =  @@TotalBgAmount ,   
                TotalSec =  @@TotalSecAmount ,   
                TotalMargin =  @@Marginamt,   
                OrgCash =  @@OrgTotCash,   
                OrgNonCash =  @@OrgTotNonCash   
        End           
  
    /*=======================================================================  
        CLOSE MAIN CURSOR FOR PARTY  
    =======================================================================*/  
  
    Fetch Next from @@Cur into @@Party_code, @@Cl_Type, @@FD, @@BG, @@SEC, @@MARGIN   
    End          
    close @@Cur          
    deallocate @@Cur          
              
    RETURN

GO
