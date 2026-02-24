-- Object: PROCEDURE dbo.V2_Acc_MoneypayoutAdhoc
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------







CREATE Procedure V2_Acc_MoneypayoutAdhoc    
   @stltypno varchar (16),          
   @strPayMode varchar (4),          
   @effdate varchar(11),          
   @sdate varchar(11),          
   @setttype1 varchar(2),          
   @setttype2 varchar(2),          
   @statusname varchar(30),          
   @branchcode varchar(10),
   @NoRec varchar(5) = '250'
        
As         

/*
EXEC V2_Acc_MoneypayoutAdhoc 
    @stltypno = '2005125', 
    @strPayMode = 'BOTH', 
    @effdate = 'Feb 17 2006', 
    @sdate = 'Apr  1 2005', 
    @setttype1 = 'N', 
    @setttype2 = 'W', 
    @statusname = 'broker', 
    @branchcode = 'ALL', 
    @NoRec = '1000'
*/
        
Declare         
   @@SettNo Varchar(7),         
   @@PendingCnt Varchar(11),         
   @@MaxDate Varchar(11), 
   @@SQL Varchar(3000)
        
Set @@SettNo = Left(@stltypno, 7)        
Set @@PendingCnt = 0        
Set @@MaxDate = 'Jan  1 1900'        

Set Transaction Isolation Level Read Uncommitted    
     
/*=============================================================================
      LOOP for Broker Login to Rejection of Requests
            1. All Old Date Pending Requests
            2. Multiple Requests. All requests other than the first request of the lowest amount are rejected. 
=============================================================================*/

      If upper(@statusname) = 'BROKER'         
      Begin         
          SET @@PendingCnt = 
                (
                      SELECT 
                          Count(*) 
                      FROM SettPayout WITH(NoLock) 
                      WHERE status='P' 
                          AND GenFlag='A'
                )        
           
          If @@PendingCnt <> 0        
          Begin        
            SET @@MaxDate = 
              (
                    SELECT 
                        Left(Convert(Varchar, Max(RequestDt), 109), 11) 
                    FROM SettPayout WITH(NoLock) 
                    WHERE status='P' 
                        AND GenFlag='A' 
              )
          End        
           
            /*=============================================================================
                        1. All Old Date Pending Requests
            =============================================================================*/
                      UPDATE 
                          SettPayout 
                          SET status = 'R' 
                      WHERE status='P' 
                          AND GenFlag='A' 
                          AND RequestDt < @@MaxDate 
           
          SELECT 
              CltCode, 
              Amt = min(AmountToBePaid), 
              SrNo = 0 
          INTO #Payout_Reject 
          FROM SettPayout WITH(NoLock) 
          WHERE status='P' 
              AND GenFlag='A' 
          GROUP BY CltCode 
          HAVING Count(*) > 1         
           
          UPDATE 
              #Payout_Reject 
              SET SrNo = S.SrNo 
          FROM 
              (
                    SELECT 
                        #Payout_Reject.CltCode, 
                        SrNo = Min(SettPayout.SrNo) 
                    FROM SettPayout WITH(NoLock), 
                        #Payout_Reject WITH(NoLock) 
                    WHERE status='P' 
                        AND GenFlag='A' 
                        AND SettPayout.CltCode = #Payout_Reject.CltCode 
                        AND AmountToBePaid = Amt 
                    GROUP BY #Payout_Reject.CltCode 
              ) 
              S, 
              #Payout_Reject P WITH(NoLock) 
          WHERE S.CltCode = P.CltCode 
           
      /*=============================================================================
                  2. Multiple Requests. All requests other than the first request of the lowest amount are rejected. 
      =============================================================================*/
                UPDATE 
                    SettPayout 
                    SET Status = 'R' 
                WHERE status='P' 
                    AND GenFlag='A' 
                    AND CltCode In 
                          (
                                SELECT 
                                    CltCode 
                                FROM #Payout_Reject WITH(NoLock)
                          ) 
                    AND SrNo Not In 
                          (
                                SELECT 
                                    SrNo 
                                FROM #Payout_Reject WITH(NoLock)
                          )   
      End        
              
/*=============================================================================
      Temp Table Creation: 
            1. #LedgerTmp: Final Table for Ledger Balances And Bill Amount
            2. #LedgerBillTmp: Table for populating Bill Amounts as posted in SettPayout Table for Pending Requests. 
=============================================================================*/
      create table #LedgerTmp         
      (         
         cltcode varchar(10),          
         acname varchar(100),           
         ChequeName varchar(100),          
         branchcode varchar(10),          
         accat varchar(10),          
         BtoBPayment Int,          
         LedgerBalance money,          
         LedgerBalanceNSE money,          
         LedgerBalanceBSE money,          
         LedgerBalanceFNO money,          
         BillAmt money,          
         futurepayout money,          
         shOrtage money,          
         Amounttobepaid money,         
         Narration varchar (234)  NULL, 
         Remark varchar (234)  NULL,         
         Paymode varchar(1),         
         Bankcode varchar(10)         
      )         
              
      CREATE TABLE [#LedgerBillTmp]         
      (         
         [cltcode] [varchar] (10)  NULL ,          
         [branchcode] [varchar] (10)  NULL ,          
         [longname] [varchar] (100)  NULL ,          
         [accat] [char] (10)  NULL ,          
         [BtoBPayment] [Int] NULL ,          
         [PayMode] [char] (1)  NULL ,          
         [POBankcode] [varchar] (10)  NULL,         
         [BillAmt] [money],          
         [Amounttobepaid] [money],         
         [Narration] [varchar] (234)  NULL, 
         [Remark] [varchar] (234)  NULL         
      ) ON [PRIMARY]         
              
     
/*=============================================================================
      Fetching data for Bill Amount from SettPayout Table 
      -------Main Condition: Pending Requests for the Settlement Number provided----------------        
=============================================================================*/
              
Select @@SQL = "      INSERT "
Select @@SQL = @@SQL + "      INTO #LedgerBillTmp "
Select @@SQL = @@SQL + "      SELECT "
Select @@SQL = @@SQL + "      Top " + @NoRec
Select @@SQL = @@SQL + "          S.CltCode, "
Select @@SQL = @@SQL + "          A.BranchCode, "
Select @@SQL = @@SQL + "          longname, "
Select @@SQL = @@SQL + "          accat, "
Select @@SQL = @@SQL + "          BtoBPayment, "
Select @@SQL = @@SQL + "          PayMode, "
Select @@SQL = @@SQL + "          POBankcode, "
Select @@SQL = @@SQL + "          BillAmt, "
Select @@SQL = @@SQL + "          Amounttobepaid, "
Select @@SQL = @@SQL + "          Narration, "
Select @@SQL = @@SQL + "          Remark "
Select @@SQL = @@SQL + "      FROM SettPayout S WITH(NoLock), "
Select @@SQL = @@SQL + "          Acmast A WITH(NoLock) "
Select @@SQL = @@SQL + "      WHERE S.CltCode = A.CltCode "
Select @@SQL = @@SQL + "          AND A.accat In (4, 104) "
Select @@SQL = @@SQL + "          AND Status = 'P' "
Select @@SQL = @@SQL + "          AND GenFlag = 'A' "
Select @@SQL = @@SQL + "          AND upper(S.BranchCode) like (Case When upper('" + @branchcode + "') = 'ALL' Then '%' Else upper('" + @branchcode + "') End) "

EXEC (@@SQL)
 
      CREATE  INDEX [Cltcode] ON [dbo].[#LedgerBillTmp]([cltcode]) ON [PRIMARY]         
           
/*===========================================================================
      Calculate NSE Cash Ledger Balances for Clients with Credit in the Selected Settlement 
===========================================================================*/        
      INSERT 
      INTO #LedgerTmp 
      SELECT 
          l.cltcode , 
          acname = a.longname, 
          ChequeName = a.longname, 
          a.branchcode, 
          a.accat, 
          a.BtoBPayment , 
          LedgerBalance = 0, 
          LedgerBalanceNSE = Sum(
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
          LedgerBalanceBSE = 0, 
          LedgerBalanceFNO = 0, 
          a.BillAmt, 
          futurepayout = 0 , 
          shOrtage=0, 
          a.Amounttobepaid, 
          a.Narration, 
          a.Remark, 
          a.paymode, 
          a.POBankCode 
      FROM #LedgerBillTmp a WITH(NoLock), 
          Account..Ledger l WITH(NoLock) 
      WHERE l.cltcode= a.cltcode 
          AND l.vdt BETWEEN @sdate + ' 00:00:00' AND @effdate + ' 23:59:00'     
      GROUP BY a.branchcode, 
          l.cltcode , 
          a.longname, 
          a.accat, 
          a.BtoBPayment, 
          a.paymode, 
          a.Narration, 
          a.Remark, 
          a.BillAmt, 
          a.Amounttobepaid, 
          a.POBankCode        
      
/*===========================================================================
      Calculate BSE Cash Ledger Balances for Clients with Credit in the Selected Settlement 
===========================================================================*/        
      INSERT 
      INTO #LedgerTmp 
      SELECT 
          l.cltcode , 
          acname = a.longname, 
          ChequeName = a.longname, 
          a.branchcode, 
          a.accat, 
          a.BtoBPayment , 
          LedgerBalance = 0, 
          LedgerBalanceNSE = 0,
          LedgerBalanceBSE = Sum(
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
          LedgerBalanceFNO = 0, 
          a.BillAmt, 
          futurepayout = 0 , 
          shOrtage=0, 
          a.Amounttobepaid, 
          a.Narration, 
          a.Remark, 
          a.paymode, 
          a.POBankCode 
      FROM #LedgerBillTmp a WITH(NoLock), 
          AccountBSE..Ledger l WITH(NoLock) 
      WHERE l.cltcode= a.cltcode 
          AND l.vdt BETWEEN @sdate + ' 00:00:00' AND @effdate + ' 23:59:00'     
      GROUP BY a.branchcode, 
          l.cltcode , 
          a.longname, 
          a.accat, 
          a.BtoBPayment, 
          a.paymode, 
          a.Narration, 
          a.Remark, 
          a.BillAmt, 
          a.Amounttobepaid, 
          a.POBankCode          
      
/*===========================================================================
      Calculate NSE Derivative Ledger Balances for Clients with Credit in the Selected Settlement 
===========================================================================*/        
      INSERT 
      INTO #LedgerTmp 
      SELECT 
          l.cltcode , 
          acname = a.longname, 
          ChequeName = a.longname, 
          a.branchcode, 
          a.accat, 
          a.BtoBPayment , 
          LedgerBalance = 0, 
          LedgerBalanceNSE = 0, 
          LedgerBalanceBSE = 0, 
          LedgerBalanceFNO = Sum(
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
          a.BillAmt, 
          futurepayout = 0 , 
          shOrtage=0, 
          a.Amounttobepaid, 
          a.Narration, 
          a.Remark, 
          a.paymode, 
          a.POBankCode 
      FROM #LedgerBillTmp a WITH(NoLock), 
          AccountFO..Ledger l WITH(NoLock) 
      WHERE l.cltcode= a.cltcode 
          AND l.vdt BETWEEN @sdate + ' 00:00:00' AND @effdate + ' 23:59:00'     
      GROUP BY a.branchcode, 
          l.cltcode , 
          a.longname, 
          a.accat, 
          a.BtoBPayment, 
          a.paymode, 
          a.Narration, 
          a.Remark, 
          a.BillAmt, 
          a.Amounttobepaid, 
          a.POBankCode        
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
          
      CREATE  INDEX [Cltcode] ON [dbo].[#LedgerTmp]([cltcode]) ON [PRIMARY]         
             
/*===========================================================================
      Updating cheque In name From multibankid 
===========================================================================*/        
              
      UPDATE 
          tmp 
          SET ChequeName = m.ChequeName 
      FROM #LedgerTmp tmp, 
          MultiBankId m 
      WHERE m.cltcode = tmp.cltcode           AND m.DefaultBank = '1' 
              
      SELECT 
          PartyCode = l.cltcode, 
          PartyName = l.acname, 
          PartyName = l.chequename, 
          l.branchcode, 
          l.accat, 
          l.BtoBPayment, 
          TOTLedBal = Sum(l.LedgerBalanceNSE) + Sum(l.LedgerBalanceBSE) + Sum(l.LedgerBalanceFNO), 
          NSELedBal = Sum(l.LedgerBalanceNSE), 
          BSELedBal = Sum(l.LedgerBalanceBSE), 
          FNOLedBal = Sum(l.LedgerBalanceFNO), 
          l.BillAmt, 
          l.Futurepayout, 
          l.shOrtage, 
          l.amounttobepaid, 
          l.narration, 
          l.paymode, 
          l.remark, 
          l.bankcode 
      FROM #LedgerTmp l WITH(NoLock)
      GROUP BY l.cltcode, 
          l.acname, 
          l.chequename, 
          l.branchcode, 
          l.accat, 
          l.BtoBPayment, 
          l.BillAmt, 
          l.Futurepayout, 
          l.shOrtage, 
          l.amounttobepaid, 
          l.narration, 
          l.paymode, 
          l.remark, 
          l.bankcode 
      ORDER BY l.branchcode, 
          l.cltcode     


/*  -----------------------------------EOF  ----------------------------------------------------------------*/

GO
