-- Object: PROCEDURE dbo.InsDebitPayOutCursor_DKM1
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc InsDebitPayOutCursor_DKM1
 @ProcessType Varchar(4)        
As        
Declare         
      @Party_Code  Varchar(10),        
      @ToDayShrt  Numeric(18,6),        
      @HoldAmt  Numeric(18,6),        
      @PayOut  Numeric(18,6),        
      @FutPayOut  Numeric(18,6),        
      @FutShort  Numeric(18,6),        
      @LedAmt   Numeric(18,6),        
      @PayVal   Numeric(18,6),        
      @CurVal   Numeric(18,6),        
      @Sett_No Varchar(7),        
      @Sett_Type Varchar(2),        
      @CertNo  Varchar(12),         
      @Cl_Rate Numeric(18,6),        
      @DebitQty Int,        
      @PoolQty Int,        
      @DpType  Varchar(4),        
      @PayCur  Cursor,        
      @RecCur  Cursor 

set transaction isolation level read uncommitted         
Set NoCount On        

--Exec InsDebitPayOut        

      CREATE TABLE [#Tmp_Delpayout] (
      	[SNo] [int] IDENTITY (1, 1) NOT NULL ,
      	[Exchange] [varchar] (3) NULL ,
      	[Sett_No] [varchar] (7) NULL ,
      	[Sett_Type] [varchar] (2) NULL ,
      	[Party_Code] [varchar] (10) NOT NULL ,
      	[Scrip_Cd] [varchar] (12) NOT NULL ,
      	[Series] [varchar] (3) NULL ,
      	[Certno] [varchar] (16) NULL ,
      	[Debitqty] [int] NULL ,
      	[Payqty] [int] NOT NULL ,
      	[Shrtqty] [int] NULL ,
      	[Poolqty] [int] NULL ,
      	[Dptype] [varchar] (4) NULL ,
      	[LedAmt] [money] NOT NULL ,
      	[Effbal] [money] NOT NULL ,
      	[Cl_Rate] [money] NOT NULL ,
      	[Payoutdate] [datetime] NULL ,
      	[Actpayout] [int] NULL, 
      
      	[HoldAmt] [money] NULL ,
      	[PayOut] [money] NULL, 
      	[ToDayShrt] [money] NULL ,
      	[FutShort] [money] NULL ,
      	[FutPayOut] [money] NULL ,
      
      	[PayVal] [money] NULL, 
      	[CurVal] [money] NULL, 
      	[RunningBal] [money] NULL 
      ) ON [PRIMARY]

If @ProcessType = 'BEN'         
Begin        

/*====================================================================================================================
      Populate data into # Table with additional fields to be used for calculations. 
====================================================================================================================*/
      Insert Into #Tmp_Delpayout 
      Select Exchange, Sett_No, Sett_Type, D.Party_Code, Scrip_Cd, Series, Certno, 
            Debitqty, Payqty, Shrtqty, Poolqty, 
            Dptype, Ledbal, Effbal, Cl_Rate, Payoutdate, Actpayout, 
            HoldAmt, PayOut, ToDayShrt, FutShort, 0, 0, 0, 0 
      From 
            Delpayout D, 
            (
                  Select 
                        Party_code,
                        ToDayShrt = 
                              Sum
                              (
                                    Case 
                                    When PayOutDate Like Left(Convert(Varchar,GetDate(),109),11) + '%'         
                                    Then ShrtQty * Cl_Rate         
                                    Else 0        
                                    End
                              ),        
                        PayOut = Sum(PayQty * Cl_Rate),        
                        FutShort = 
                              Sum
                              (
                                    Case 
                                    When PayOutDate > Left(Convert(Varchar,GetDate(),109),11) + ' 23:59:59'        
                                    Then ShrtQty * Cl_Rate         
                                    Else 0        
                                    End
                              ),        
                        HoldAmt = Sum(DebitQty * Cl_Rate)        
                  From DelPayOut         
                  Group By Party_code
            ) H
      Where 
            D.Party_Code = H.Party_Code 
            And DebitQty > 0 
      Order By D.Party_Code, PayOutDate, Cl_Rate


/*====================================================================================================================
      Update Payout Qty for Clients set as Always Payout (DebitFLag = 1). 
====================================================================================================================*/
      UPDATE #Tmp_Delpayout 
      SET ActPayOut = DebitQty
      FROM 
            (
                  SELECT PARTY_CODE FROM DELPARTYFLAG WHERE DEBITFLAG = 1
                  UNION 
                  SELECT PARTY_CODE FROM BSEDB.DBO.DELPARTYFLAG WHERE DEBITFLAG = 1
            ) D
      WHERE DebitQty > 0 
            AND #Tmp_Delpayout.PARTY_CODE = D.PARTY_CODE        


/*====================================================================================================================
      Update Payout Qty for Clients where Full Payout can be given. 
            1) Ledger Balance - Todays Shortage - Future Shortage >= -500.
            2) Payout Value - (Todays + Future Shortage) With 20% Mark-Up should be greater than 0.
====================================================================================================================*/
      UPDATE #Tmp_Delpayout 
      SET 
            ActPayOut = 
                  isnull((
                        CASE 
                        WHEN (LedAmt - ToDayShrt - FutShort) >= -500   
                        THEN 
                        (
                              CASE 
                              WHEN (PayOut - (ToDayShrt + FutShort) * 120 / 100) >= 0    /* Full PayOut */           
                              THEN DebitQty 
                              ELSE 0 
                              END 
                        )
                        ELSE 0 
                        END 
                  ),0), 
            PayVal = HoldAmt + (LedAmt - TodayShrt + (PayOut - (FutShort) * 120 / 100)), 
            CurVal = DebitQty * Cl_Rate             
      WHERE DebitQty <> ActPayOut 


/*====================================================================================================================
      Begin Cursor for Bulk Updates to allocate RMS Based Part Payout. 
====================================================================================================================*/
      While (Select Count(1) From #Tmp_Delpayout Where DebitQty <> ActPayOut And CurVal > 0) > 0         
      Begin        

      /*====================================================================================================================
            Update [Current Value] of Debit Qty as 0 for cases where the value is greater than the [Total Payout Value]. 
      ====================================================================================================================*/
            Update #Tmp_Delpayout 
            Set CurVal = 0 
            Where DebitQty <> ActPayOut 
            And CurVal > PayVal


      /*====================================================================================================================
            Compute Running Balance after adjusting the [Current Value] with the [Total Payout Value]. 
      ====================================================================================================================*/
            Update #Tmp_Delpayout 
                  Set  
                  RunningBal = PayVal - 
                                    isnull(( 
                                          SELECT 
                                                sum(CurVal) 
                                          FROM #Tmp_Delpayout 
                                          WHERE SNO < O.SNO 
                                                And Party_Code = O.Party_Code         
                                                And DebitQty <> ActPayOut
                                    ),0) 
            FROM #Tmp_Delpayout O 
            WHERE         
                  DebitQty <> ActPayOut 


      /*====================================================================================================================
            Update [Current Value] of Debit Qty as 0 to avoid cases where Part Payout can be given. 
      ====================================================================================================================*/
            UPDATE #Tmp_Delpayout 
            SET CurVal = 0 
            Where DebitQty <> ActPayOut 
            And RunningBal > 0 
            And RunningBal < CurVal 


      /*====================================================================================================================
            Reset [Payout Value] as [Running Balance] of un-allocated payouts for further processing. 
      ====================================================================================================================*/
            Update #Tmp_Delpayout 
            Set PayVal = R.RunningBal 
            From 
                  (
                        Select Party_Code, RunningBal = min(RunningBal) 
                        From #Tmp_Delpayout 
                        Where RunningBal > 0
                        Group By Party_Code
                  ) R
            WHERE 
            #Tmp_Delpayout.Party_Code = R.Party_Code 
            And #Tmp_Delpayout.DebitQty <> #Tmp_Delpayout.ActPayOut 
            And #Tmp_Delpayout.RunningBal < 0 


      /*====================================================================================================================
            Update Payout Qty for Payout approved so far. 
      ====================================================================================================================*/
            UPDATE #Tmp_Delpayout 
            SET ActPayOut = DebitQty
            Where DebitQty <> ActPayOut 
            And RunningBal > 0 
            And PayVal > CurVal 
            And CurVal > 0
      End


/*====================================================================================================================
      Final Update for [Actual Payout Qty] from Hash table to [DelPayout] table. 
====================================================================================================================*/
      Update DelPayout 
      Set ActPayOut = T.ActPayOut 
      From #Tmp_Delpayout T
      Where DelPayout.Party_Code = T.Party_Code
            And DelPayout.Sett_No = T.Sett_No 
            And DelPayout.Sett_Type = T.Sett_Type 
            And DelPayout.CertNo = T.CertNo 
            And DelPayout.Exchange = T.Exchange 

      Insert into delpayoutlog select *,getdate() from DelPayOut        
End        
Else        
Begin /* Begin for Payout from POOL Account */

/*====================================================================================================================
      Populate data into # Table with additional fields to be used for calculations. 
====================================================================================================================*/
      Insert Into #Tmp_Delpayout 
      Select Exchange, Sett_No, Sett_Type, D.Party_Code, Scrip_Cd, Series, Certno, 
            Debitqty, Payqty, Shrtqty, Poolqty, 
            Dptype, Ledbal, Effbal, Cl_Rate, Payoutdate, Actpayout, 
            HoldAmt, PayOut, 0, FutShort, FutPayOut, 0, 0, 0 
      From 
            Delpayout D, 
            (
                  Select 
                        Party_code,
                        FutPayOut = 
                              Sum
                              (
                                    Case 
                                    When PayOutDate > Left(Convert(Varchar,GetDate(),109),11) + ' 23:59:59'        
                                    Then PayQty * Cl_Rate        
                                    Else 0         
                                    End
                              ),        
                        PayOut = 
                              Sum
                              (
                                    Case 
                                    When PayOutDate Like Left(Convert(Varchar,GetDate(),109),11) + '%'         
                                    Then PayQty * Cl_Rate        
                                    Else 0         
                                    End
                              ),        
                        FutShort = 
                              Sum
                              (
                                    Case When PayOutDate > Left(Convert(Varchar,GetDate(),109),11) + ' 23:59:59'        
                                    Then ShrtQty * Cl_Rate         
                                    Else 0        
                                    End
                              )        
                  From DelPayOut         
                  Where Party_Code Not in 
                              (
                                    Select Distinct Party_Code 
                                    From DelPayOut 
                                    Where DebitQty > 0 
                              )        
                  Group By Party_code
            ) H
      Where 
            D.Party_Code = H.Party_Code 
            And PoolQty > 0 
      Order By D.Party_Code, PayOutDate, Cl_Rate

/*====================================================================================================================
      Update Payout Qty for Clients set as Always Payout (DebitFLag = 1). 
====================================================================================================================*/
      UPDATE #Tmp_Delpayout 
      SET ActPayOut = PoolQty
      FROM 
            (
                  SELECT PARTY_CODE FROM DELPARTYFLAG WHERE DEBITFLAG = 1
                  UNION 
                  SELECT PARTY_CODE FROM BSEDB.DBO.DELPARTYFLAG WHERE DEBITFLAG = 1
            ) D
      WHERE PoolQty > 0 
            AND #Tmp_Delpayout.PARTY_CODE = D.PARTY_CODE        

/*====================================================================================================================
      Update Payout Qty for Clients where Full Payout can be given. 
            1) Ledger Balance >= -500.
            2) Future Payout Value - (Future Shortage) With 20% Mark-Up should be greater than 0.
====================================================================================================================*/
      UPDATE #Tmp_Delpayout 
      SET 
            ActPayOut = 
                  isnull((
                        CASE 
                        WHEN LedAmt >= -500 
                        THEN 
                        (
                              CASE 
                              WHEN (FutPayOut -  (FutShort) * 120 / 100) >= 0    /* Full PayOut */           
                              THEN PoolQty 
                              ELSE 0 
                              END 
                        )
                        ELSE 0 
                        END 
                  ),0), 
            PayVal = PayOut + (LedAmt + (FutPayOut - (FutShort * 120 / 100))), 
            CurVal = PoolQty * Cl_Rate             
      WHERE PoolQty <> ActPayOut 

/*====================================================================================================================
      Begin Cursor for Bulk Updates to allocate RMS Based Part Payout. 
====================================================================================================================*/
      While (Select Count(1) From #Tmp_Delpayout Where PoolQty <> ActPayOut And CurVal > 0) > 0         
      Begin        

      /*====================================================================================================================
            Update [Current Value] of POOL Qty as 0 for cases where the value is greater than the [Total Payout Value]. 
      ====================================================================================================================*/
            Update #Tmp_Delpayout 
            Set CurVal = 0 
            Where PoolQty <> ActPayOut 
            And CurVal > PayVal


      /*====================================================================================================================
            Compute Running Balance after adjusting the [Current Value] with the [Total Payout Value]. 
      ====================================================================================================================*/
            Update #Tmp_Delpayout 
                  Set  
                  RunningBal = PayVal - 
                                    isnull(( 
                                          SELECT 
                                                sum(CurVal) 
                                          FROM #Tmp_Delpayout 
                                          WHERE SNO < O.SNO 
                                                And Party_Code = O.Party_Code         
                                                And PoolQty <> ActPayOut
                                    ),0) 
            FROM #Tmp_Delpayout O 
            WHERE         
                  PoolQty <> ActPayOut 


      /*====================================================================================================================
            Update [Current Value] of Pool Qty as 0 to avoid cases where Part Payout can be given. 
      ====================================================================================================================*/
            UPDATE #Tmp_Delpayout 
            SET CurVal = 0 
            Where PoolQty <> ActPayOut 
            And RunningBal > 0 
            And RunningBal < CurVal 


      /*====================================================================================================================
            Reset [Payout Value] as [Running Balance] of un-allocated payouts for further processing. 
      ====================================================================================================================*/
            Update #Tmp_Delpayout 
            Set PayVal = R.RunningBal 
            From 
                  (
                        Select Party_Code, RunningBal = min(RunningBal) 
                        From #Tmp_Delpayout 
                        Where RunningBal > 0
                        Group By Party_Code
                  ) R
            WHERE 
            #Tmp_Delpayout.Party_Code = R.Party_Code 
            And #Tmp_Delpayout.PoolQty <> #Tmp_Delpayout.ActPayOut 
            And #Tmp_Delpayout.RunningBal < 0 


      /*====================================================================================================================
            Update Payout Qty for Payout approved so far. 
      ====================================================================================================================*/
            UPDATE #Tmp_Delpayout 
            SET ActPayOut = PoolQty
            Where PoolQty <> ActPayOut 
            And RunningBal > 0 
            And PayVal > CurVal 
            And CurVal > 0
      End


/*====================================================================================================================
      Final Update for [Actual Payout Qty] from Hash table to [DelPayout] table. 
====================================================================================================================*/
      Update DelPayout 
      Set ActPayOut = T.ActPayOut 
      From #Tmp_Delpayout T
      Where DelPayout.Party_Code = T.Party_Code
            And DelPayout.Sett_No = T.Sett_No 
            And DelPayout.Sett_Type = T.Sett_Type 
            And DelPayout.CertNo = T.CertNo 
            And DelPayout.Exchange = T.Exchange 

      Insert into delpayoutlog select *,getdate() from DelPayOut        

End

GO
