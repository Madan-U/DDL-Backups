-- Object: PROCEDURE dbo.V2_ComputeLedgerBalance
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------


CREATE Procedure V2_ComputeLedgerBalance
(          
      @sdate varchar(11),            
      @fparty varchar(10),             
      @tparty varchar(10),         
      @stlno varchar(7),    
      @GenFlag varchar(1),               
      @user varchar(25),        
      @Exchange varchar(3),    
      @effdate varchar(11)          
)          
          
As              
            
/*===========================================================================    
      Exec V2_ComputeLedgerBalance
            @sdate = 'Apr  1 2005',     
            @fparty = '',     
            @Tparty = '',     
            @stlno = '2005125',    
            @GenFlag = 'S',                 
            @user = 'PM',     
            @Exchange = 'NSE',     
            @effdate = 'Mar  4 2006'
    
      Exec V2_ComputeLedgerBalance
            @sdate = 'Apr  1 2005',     
            @fparty = '',     
            @Tparty = '',     
            @stlno = '',    
            @GenFlag = 'A',                 
            @user = 'PM',     
            @Exchange = 'NSE',     
            @effdate = 'Mar  4 2006'
    
      SELECT * FROM V2_LedgerBalance     
    
      SELECT PartyCode FROM V2_LedgerBalance Group By PartyCode Having Count(*) > 1    
    
      Select * From Msajag..AccBill Where Sett_No = '2005079'    
===========================================================================*/    
    
Set Nocount On    
    
If @fparty = ''                           
Begin                           
      Set @fparty = '0000000000'         
End                          
          
If @tparty = ''                           
Begin                           
      Set @tparty = 'ZZZZZZZZZZ'          
End             
      
Set Transaction Isolation Level Read Uncommitted      
      
Declare     
      @@reccount int    
    
Set @@reccount = 0    
    
Select @@reccount = Count(1) From SettPayout Where Left(RequestDt,11) = Left(GetDate(),11) And Status = 'P'     
    
      IF @@reccount <> 0     
      BEGIN    
            SELECT ':: SORRY!! CANNOT PROCEED. THERE ARE SOME REQUESTS PENDING. PLEASE REJECT/APPROVE TO RECALCULATE ::'    
            Return    
      END    
    
      DELETE     
            V2_LedgerBalance     
      WHERE PartyCode BETWEEN @fparty AND @tparty     
    
/*===========================================================================    
      Create # Tables for Canned Ledger Balances And Bill Amounts    
===========================================================================*/    
      Create Table #LedgerBalance    
      (           
            PartyCode varchar(10),            
            PartyName varchar(100),             
            ChequeName varchar(100),            
            branchcode varchar(10),            
            accat varchar(10),            
            BtoBPayment Int,            
            TOTLedBal money,            
            NSELedBal money,            
            BSELedBal money,            
            FNOLedBal money,            
            Sett_No varchar(7),            
            NormalBillAmt money,            
            T2TBillAmt money,            
            BillAmt money,            
            futurepayout money,            
            shortage money,            
            Amounttobepaid money,           
            Paymode varchar(1),           
            Bankcode varchar(10),    
            GenFlag varchar(1),           
            RunDate DateTime           
      )     
          
      CREATE  INDEX [PartyCode] ON [dbo].[#LedgerBalance]([PartyCode]) ON [PRIMARY]           
          
      Create Table [#LedgerBillTmp]           
      (           
            [cltcode] [varchar] (10)  NULL ,            
            [branchcode] [varchar] (10)  NULL ,            
            [longname] [varchar] (100)  NULL ,            
            [accat] [char] (10)  NULL ,            
            [BtoBPayment] [Int] NULL ,            
            [PayMode] [char] (1)  NULL ,            
            [POBankcode] [varchar] (10)  NULL,           
            [Sett_No] [varchar] (7) NOT NULL,           
            [NormalBillAmt] [money],           
            [T2TBillAmt] [money],     
            [RunDate] [datetime]           
      ) ON [PRIMARY]          
    
    
/*===========================================================================    
      Populate Bill Amounts from AccBill table in the ShareDB for Normal And T2T Settlements    
      Delete Clients with Client Type Set As ('MTF', 'PMS', 'WEB')     
===========================================================================*/     
IF @Exchange = 'NSE' --NSE
BEGIN
      IF @GenFlag = 'S'    
      BEGIN    
            INSERT     
            INTO #LedgerBillTmp     
            SELECT     
                  A.cltcode ,     
                  A.BranchCode,     
                  longname,     
                  accat,     
                  BtoBPayment,     
                  PayMode,     
                  POBankcode,     
                  Sett_No = @stlno,     
                  NormalBillAmt = sum(    
                        CASE     
                              WHEN Sett_Type = 'N'     
                              THEN (    
                              CASE     
                                    WHEN Sell_Buy = '1'     
                                    THEN -Amount     
                                    ELSE Amount     
                              END    
                              )     
                              ELSE 0     
                        END    
                        ),     
                  T2TBillAmt = sum(    
                        CASE     
                              WHEN Sett_Type = 'W'     
                              THEN (    
                              CASE     
                                    WHEN Sell_Buy = '1'     
                                    THEN -Amount     
                                    ELSE Amount     
                              END    
                              )     
                              ELSE 0     
                        END    
                        ),     
                  RunDate = getdate()     
            FROM MSAJAG..AccBill l WITH(NoLock),     
                  Acmast A WITH(NoLock)     
            WHERE L.Party_Code = a.CltCode     
                  AND a.CltCode BETWEEN @fparty AND @tparty     
                  AND a.accat In (4, 104)     
                  AND l.Sett_No = @stlno     
                  AND a.POBankCode In     
                        (    
                              SELECT     
                                    CltCode     
                              FROM AcMast     
                              WITH(NoLock)     
                              WHERE Accat = 2    
                        )     
            GROUP BY A.CltCode,     
                  A.BranchCode,     
                  longname,     
                  accat,     
                  BtoBPayment,     
                  PayMode,     
                  POBankcode     
            HAVING sum(    
                        CASE     
                              WHEN Sell_Buy = '1'     
                              THEN -Amount     
                              ELSE Amount     
                        END    
                        ) > 0     
      END    
      ELSE    
      BEGIN    
            INSERT     
            INTO #LedgerBillTmp     
            SELECT     
                  A.cltcode ,     
                  A.BranchCode,     
                  longname,     
                  accat,     
                  BtoBPayment,     
                  PayMode,     
                  POBankcode,     
                  Sett_No = '',     
                  NormalBillAmt = 0,     
                  T2TBillAmt = 0,     
                  RunDate = getdate()     
            FROM Acmast A WITH(NoLock)     
            WHERE a.CltCode BETWEEN @fparty AND @tparty     
                  AND a.accat In (4, 104)                       
                  AND a.POBankCode In     
                        (    
                        SELECT     
                                    CltCode     
                              FROM AcMast     
                              WITH(NoLock)     
                              WHERE Accat = 2    
                        )     
            GROUP BY A.CltCode,     
                  A.BranchCode,     
                  longname,     
                  accat,     
                  BtoBPayment,     
                  PayMode,     
                  POBankcode                 
      END    
       
      CREATE  INDEX [Cltcode] ON [dbo].[#LedgerBillTmp]([cltcode]) ON [PRIMARY]           
             
      DELETE     
            #LedgerBillTmp     
      FROM MSAJAG..Client1 C1,     
            MSAJAG..Client2 C2     
      WHERE CltCode = C2.Party_Code     
            AND C1.Cl_Code = C2.Cl_Code     
            AND C1.Cl_Type In ('MTF', 'PMS', 'WEB') 

END

ELSE --BSE
BEGIN
      IF @GenFlag = 'S'    
      BEGIN    
            INSERT     
            INTO #LedgerBillTmp     
            SELECT     
                  A.cltcode ,     
                  A.BranchCode,     
                  longname,     
                  accat,     
                  BtoBPayment,     
                  PayMode,     
                  POBankcode,     
                  Sett_No = @stlno,     
                  NormalBillAmt = sum(    
                        CASE     
                              WHEN Sett_Type = 'D'     
                              THEN (    
                              CASE     
                                    WHEN Sell_Buy = '1'     
                                    THEN -Amount     
                                    ELSE Amount     
                              END    
                              )     
                              ELSE 0     
                        END    
                        ),     
                  T2TBillAmt = sum(    
                        CASE     
                              WHEN Sett_Type = 'C'     
                              THEN (    
                              CASE     
                                    WHEN Sell_Buy = '1'     
                                    THEN -Amount     
                                    ELSE Amount     
                              END    
                              )     
                              ELSE 0     
                        END    
                        ),     
                  RunDate = getdate()     
            FROM BSEDB..AccBill l WITH(NoLock),     
                  Acmast A WITH(NoLock)     
            WHERE L.Party_Code = a.CltCode     
                  AND a.CltCode BETWEEN @fparty AND @tparty     
                  AND a.accat In (4, 104)     
                  AND l.Sett_No = @stlno     
                  AND a.POBankCode In     
                        (    
                              SELECT     
                                    CltCode     
                              FROM AcMast     
                              WITH(NoLock)     
                              WHERE Accat = 2    
                        )     
            GROUP BY A.CltCode,     
                  A.BranchCode,     
                  longname,     
                  accat,     
                  BtoBPayment,     
                  PayMode,     
                  POBankcode     
            HAVING sum(    
                        CASE     
                              WHEN Sell_Buy = '1'     
                              THEN -Amount     
                              ELSE Amount     
                        END    
                        ) > 0     
      END    
      ELSE    
      BEGIN    
            INSERT     
            INTO #LedgerBillTmp     
            SELECT     
                  A.cltcode ,     
                  A.BranchCode,     
                  longname,     
                  accat,     
                  BtoBPayment,     
                  PayMode,     
                  POBankcode,     
                  Sett_No = '',     
                  NormalBillAmt = 0,     
                  T2TBillAmt = 0,     
                  RunDate = getdate()     
            FROM Acmast A WITH(NoLock)     
            WHERE a.CltCode BETWEEN @fparty AND @tparty     
                  AND a.accat In (4, 104)                       
                  AND a.POBankCode In     
                        (    
                        SELECT     
                                    CltCode     
                              FROM AcMast     
                              WITH(NoLock)     
                              WHERE Accat = 2    
                        )     
            GROUP BY A.CltCode,     
                  A.BranchCode,     
                  longname,     
                  accat,     
                  BtoBPayment,     
                  PayMode,     
                  POBankcode                 
      END    
       
      CREATE  INDEX [Cltcode] ON [dbo].[#LedgerBillTmp]([cltcode]) ON [PRIMARY]           
             
      DELETE     
            #LedgerBillTmp     
      FROM BSEDB..Client1 C1,     
            BSEDB..Client2 C2     
      WHERE CltCode = C2.Party_Code     
            AND C1.Cl_Code = C2.Cl_Code     
            AND C1.Cl_Type In ('MTF', 'PMS', 'WEB') 

END        
    
/*===========================================================================    
      Calculate NSE Cash Ledger Balances for Clients with Credit in the Selected Settlement     
===========================================================================*/    
      INSERT     
      INTO #LedgerBalance     
      SELECT     
            l.cltcode ,     
            acname = a.longname,     
            ChequeName = a.longname,     
            a.branchcode,     
            a.accat,     
            a.BtoBPayment ,     
            TOTLedBal = 0,     
            NSELedBal = Sum(    
                        CASE     
                              WHEN Edt BETWEEN @sdate + ' 00:00:00' AND @effdate + ' 23:59:00'     
                              THEN (    
                              CASE     
                                    WHEN DrCr = 'D'     
                                    THEN -Vamt     
                                    ELSE Vamt     
                              END    
                              )    
                              ELSE 0     
                        END     
                  ) + Sum(    
                        CASE     
                              WHEN Edt > @effdate + ' 23:59:00'     
                              THEN (    
                              CASE     
                                    WHEN DrCr = 'D'     
                                    THEN -Vamt     
                                    ELSE 0     
                              END    
                              )     
                              ELSE 0     
                        END     
                  ),     
            BSELedBal = 0,     
            FNOLedBal = 0,     
            a.Sett_No,     
            a.NormalBillAmt,     
            a.T2TBillAmt,     
            BillAmt = a.NormalBillAmt + a.T2TBillAmt,     
            futurepayout = 0 ,     
            shortage = 0,     
            Amounttobepaid = 0,     
            a.paymode,     
            a.POBankCode,     
            GenFlag = @GenFlag,     
            RunDate      
      FROM #LedgerBillTmp a WITH(NoLock),     
            Account..Ledger l WITH(NoLock)     
      WHERE l.cltcode = a.cltcode     
            AND l.vdt BETWEEN @sdate + ' 00:00:00' AND @effdate + ' 23:59:00'     
      GROUP BY a.branchcode,     
            l.cltcode,     
            a.longname,     
            a.accat,     
            a.BtoBPayment,     
            a.paymode,     
            a.POBankCode,     
            a.Sett_No,     
            a.NormalBillAmt,     
            a.T2TBillAmt,     
            RunDate      
    
    
/*===========================================================================    
      Calculate BSE Cash Ledger Balances for Clients with Credit in the Selected Settlement     
===========================================================================*/    
      INSERT     
      INTO #LedgerBalance     
      SELECT     
            l.cltcode ,     
            acname = a.longname,     
            ChequeName = a.longname,     
            a.branchcode,     
            a.accat,     
            a.BtoBPayment ,     
       TOTLedBal = 0,     
            NSELedBal = 0,     
            BSELedBal = Sum(    
                        CASE     
                              WHEN Edt BETWEEN @sdate + ' 00:00:00' AND @effdate + ' 23:59:00'     
                              THEN (    
                              CASE     
                                    WHEN DrCr = 'D'     
                                    THEN -Vamt     
                                    ELSE Vamt     
                              END    
                              )    
                              ELSE 0     
                        END     
                  ) + Sum(    
                        CASE     
                             WHEN Edt > @effdate + ' 23:59:00'     
                              THEN (    
                              CASE     
                                    WHEN DrCr = 'D'     
                                    THEN -Vamt     
                                    ELSE 0     
                              END    
                              )     
                              ELSE 0     
                        END     
                  ),     
            FNOLedBal = 0,     
            a.Sett_No,     
            a.NormalBillAmt,     
            a.T2TBillAmt,     
            BillAmt = a.NormalBillAmt + a.T2TBillAmt,     
            futurepayout = 0 ,     
            shortage = 0,     
            Amounttobepaid = 0,     
            a.paymode,     
            a.POBankCode,     
            GenFlag = @GenFlag,     
            RunDate      
      FROM #LedgerBillTmp a WITH(NoLock),     
            AccountBse..Ledger l WITH(NoLock)     
      WHERE l.cltcode = a.cltcode     
            AND l.vdt BETWEEN @sdate + ' 00:00:00' AND @effdate + ' 23:59:00'     
      GROUP BY a.branchcode,     
            l.cltcode,     
            a.longname,     
            a.accat,     
            a.BtoBPayment,     
            a.paymode,     
            a.POBankCode,     
            a.Sett_No,     
            a.NormalBillAmt,     
            a.T2TBillAmt,     
            RunDate      
    
    
/*===========================================================================    
      Calculate NSE Derivative Ledger Balances for Clients with Credit in the Selected Settlement     
===========================================================================*/    
      INSERT     
      INTO #LedgerBalance     
      SELECT     
            l.cltcode ,     
            acname = a.longname,     
            ChequeName = a.longname,     
            a.branchcode,     
            a.accat,     
            a.BtoBPayment ,     
            TOTLedBal = 0,     
            NSELedBal = 0,     
            BSELedBal = 0,     
            FNOLedBal = Sum(    
                        CASE     
                              WHEN Edt BETWEEN @sdate + ' 00:00:00' AND @effdate + ' 23:59:00'     
                              THEN (    
                              CASE     
                                    WHEN DrCr = 'D'     
                                    THEN -Vamt     
                                    ELSE Vamt     
                              END    
                              )    
                              ELSE 0     
                        END     
                  ) + Sum(    
                        CASE     
                              WHEN Edt > @effdate + ' 23:59:00'     
                              THEN (    
                              CASE     
                                    WHEN DrCr = 'D'     
                                    THEN -Vamt     
                                    ELSE 0     
                              END    
                              )     
                              ELSE 0     
                        END     
                  ),     
            a.Sett_No,     
            a.NormalBillAmt,     
            a.T2TBillAmt,     
            BillAmt = a.NormalBillAmt + a.T2TBillAmt,     
            futurepayout = 0 ,     
            shortage = 0,     
            Amounttobepaid = 0,     
            a.paymode,     
            a.POBankCode,     
            GenFlag = @GenFlag,     
            RunDate      
      FROM #LedgerBillTmp a WITH(NoLock),     
            AccountFo..Ledger l WITH(NoLock)     
      WHERE l.cltcode = a.cltcode     
            AND l.vdt BETWEEN @sdate + ' 00:00:00' AND @effdate + ' 23:59:00'     
      GROUP BY a.branchcode,     
            l.cltcode,     
            a.longname,     
            a.accat,     
            a.BtoBPayment,     
            a.paymode,     
            a.POBankCode,     
            a.Sett_No,     
            a.NormalBillAmt,     
            a.T2TBillAmt,     
            RunDate      
      HAVING Sum(    
                  CASE     
                        WHEN Edt BETWEEN @sdate + ' 00:00:00' AND @effdate + ' 23:59:00'     
                        THEN (    
                        CASE     
                 WHEN DrCr = 'D'     
                              THEN -Vamt     
                              ELSE Vamt     
                        END    
                        )    
                        ELSE 0     
                  END     
            ) + Sum(    
                  CASE     
                        WHEN Edt > @effdate + ' 23:59:00'      
                        THEN (    
                        CASE     
                              WHEN DrCr = 'D'     
                              THEN -Vamt     
                              ELSE 0     
                        END    
                        )     
                        ELSE 0     
                  END     
            ) < 0     
    
    
/*===========================================================================    
      Insert Into Physical table From Temp Table after Grouping as Required     
===========================================================================*/    
      INSERT     
      INTO V2_LedgerBalance     
      SELECT     
            PartyCode,    
            PartyName,    
            ChequeName,    
            branchcode,    
            accat,    
            BtoBPayment,    
            TOTLedBal = Sum(NSELedBal + BSELedBal + FNOLedBal),    
            NSELedBal = Sum(NSELedBal),    
            BSELedBal = Sum(BSELedBal),    
            FNOLedBal = Sum(FNOLedBal),    
            Sett_No,    
            NormalBillAmt,    
            T2TBillAmt,    
            BillAmt,    
            futurepayout,    
            shortage,    
            Amounttobepaid,    
            Paymode,    
            Bankcode,    
            GenFlag,    
            RunDate     
      FROM #LedgerBalance     
      GROUP BY PartyCode,    
            PartyName,    
            ChequeName,    
            branchcode,    
            accat,    
            BtoBPayment,    
            Sett_No,    
            NormalBillAmt,    
            T2TBillAmt,    
            BillAmt,    
            futurepayout,    
            shortage,    
            Amounttobepaid,    
            Paymode,    
            Bankcode,    
            GenFlag,    
            RunDate     
      --HAVING    
            --Sum(NSELedBal + BSELedBal + FNOLedBal) > 0    
    
      IF @GenFlag = 'A'     
      BEGIN    
            IF @Exchange = 'NSE' --NSE
            BEGIN
                  UPDATE     
                        V2_LedgerBalance     
                        SET BillAmt = NSELedBal     
                  WHERE PartyCode BETWEEN @fparty AND @tparty     
            END

            ELSE --BSE
            BEGIN
                  UPDATE     
                        V2_LedgerBalance     
                        SET BillAmt = BSELedBal     
                  WHERE PartyCode BETWEEN @fparty AND @tparty     
            END
      END    
    
SELECT ':: UPDATION COMPLETED SUCCESSFULLY ::'

GO
