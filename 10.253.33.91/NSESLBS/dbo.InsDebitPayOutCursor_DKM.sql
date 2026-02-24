-- Object: PROCEDURE dbo.InsDebitPayOutCursor_DKM
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc InsDebitPayOutCursor_DKM
 @ProcessType Varchar(4)  
As  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED   
  
--Exec InsDebitPayOutCursor_DKM ''

 Declare   
  @Party_Code  Varchar(10),  
  @HoldAmt  Numeric(18,6),  
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
	[Ledbal] [money] NOT NULL ,
	[Effbal] [money] NOT NULL ,
	[Cl_Rate] [money] NOT NULL ,
	[Payoutdate] [datetime] NULL ,
	[Actpayout] [int] NULL, 
	[HoldAmt] [money] NULL ,
	[PayBal] [money] NULL, 
	[CurBal] [money] NULL, 
	[RunningBal] [money] NULL
) ON [PRIMARY]

      Insert Into #Tmp_Delpayout 
      Select Exchange,Sett_No,Sett_Type,D.Party_Code,Scrip_Cd,Series,Certno,Debitqty,Payqty,Shrtqty,Poolqty,Dptype,Ledbal,Effbal,Cl_Rate,Payoutdate,Actpayout, HoldAmt, 0, 0, 0 
      From 
            Delpayout D, 
            (
                  Select 
                        Party_code,
                        HoldAmt = 
                              (
                                    ( 
                                          Sum(DebitQty * Cl_Rate) + Sum(PayQty * Cl_Rate) - Sum(ShrtQty * Cl_Rate) 
                                    )  +   
                                    (
                                          Case 
                                          When LedBal < 0 
                                          Then -( Sum(DebitQty * Cl_Rate) + Sum(PayQty * Cl_Rate) - Sum(ShrtQty * Cl_Rate) ) * 20 / 100 
                                          Else  ( Sum(DebitQty * Cl_Rate) + Sum(PayQty * Cl_Rate) - Sum(ShrtQty * Cl_Rate) ) * 20 / 100 
                                          End
                                    )
                              )  
                  From DelPayOut  
                  Group By Party_code,LedBal  
            ) H
      Where 
            D.Party_Code = H.Party_Code 
            And DebitQty > 0 
      Order By D.Party_Code, PayOutDate, Cl_Rate

      Update #Tmp_Delpayout 
      Set 
            CurBal = DebitQty * Cl_Rate, 
            ActPayOut = ( 
                              Case 
                              When LedBal >= 0 And HoldAmt > 0 
                              Then DebitQty 
                              Else 0 
                              End 
                        ), 
            PayBal = (
                        Case 
                        When LedBal - Abs(HoldAmt) > 0 
                        Then LedBal - Abs(HoldAmt) 
                        Else 
                        (
                              Case 
                              When HoldAmt > 0 And LedBal < 0 And (HoldAmt + LedBal) > 0 
                              Then HoldAmt + LedBal 
                              Else 0 
                              End
                        )
                        End
                  )

      Update #Tmp_Delpayout 
            Set  
            RunningBal = 
                  isnull(( 
                        SELECT 
                              sum(CurBal) 
                        FROM #Tmp_Delpayout 
                        WHERE SNO < O.SNO 
                              And Party_Code = O.Party_Code         
                  ),0) 
      FROM #Tmp_Delpayout O 

      SELECT 
            O.*, 
            ActPay = (
                        Case 
                        When ActPayout = 0 
                        Then (
                              Case 
                              When CurBal + RunningBal <= PayBal 
                              Then DebitQty
                              Else Convert(Int,(PayBal - RunningBal) / Cl_Rate) 
                              End
                              )
                        End
                        )
      FROM #Tmp_Delpayout O 
      Order By Party_Code, PayOutDate, Cl_Rate

return

If @ProcessType = 'BEN'   
Begin  
      Set @PayCur = Cursor For  
            Select 
                  Party_code,
                  LedBal,
                  HoldAmt = 
                        (
                              ( 
                                    Sum(DebitQty * Cl_Rate) + Sum(PayQty * Cl_Rate) - Sum(ShrtQty * Cl_Rate) 
                              )  +   
                              (
                                    Case 
                                    When LedBal < 0 
                                    Then -( Sum(DebitQty * Cl_Rate) + Sum(PayQty * Cl_Rate) - Sum(ShrtQty * Cl_Rate) ) * 20 / 100 
                                    Else  ( Sum(DebitQty * Cl_Rate) + Sum(PayQty * Cl_Rate) - Sum(ShrtQty * Cl_Rate) ) * 20 / 100 
                                    End
                              )
                        )  
            From DelPayOut  
            Group By Party_code,LedBal  
            Order By Party_code  
      Open @PayCur  
      Fetch next From @PayCur Into @Party_Code, @LedAmt, @HoldAmt  
      While @@Fetch_Status = 0   
      Begin  
            IF @LedAmt >= 0 And @HoldAmt > 0 /* Full PayOut */  
            Begin   
                  Update DelPayOut Set ActPayOut = DebitQty   
                  Where DebitQty > 0 And Party_Code = @Party_Code  
            End  
            Else IF @LedAmt - Abs(@HoldAmt) > 0 /* Breakup PayOut */  
            Begin  
                  Select @PayVal = @LedAmt - Abs(@HoldAmt)  
                  Select @CurVal = 0  
                  Set @RecCur = Cursor For  
                  Select Sett_No, Sett_Type, CertNo, DebitQty, Cl_Rate From DelPayOut  
                  Where DebitQty > 0 And Party_Code = @Party_Code  
                  Order By PayOutDate,Cl_Rate    
                  Open @RecCur  
                  Fetch Next From @RecCur Into @Sett_No, @Sett_Type, @CertNo, @DebitQty, @Cl_Rate  
                  While @@Fetch_Status = 0 And @PayVal > 0   
                  Begin  
                        Select @CurVal = @DebitQty * @Cl_Rate  
                        If @CurVal <= @PayVal   
                        Begin  
                              Select @PayVal = @PayVal - @CurVal   
                              Update DelPayOut Set ActPayOut = DebitQty Where  
                              Sett_No = @Sett_No And Sett_Type = @Sett_Type And  
                              CertNo = @CertNo And Party_Code = @Party_Code         
                        End  
                        Else  
                        Begin  
                              Select @DebitQty = Convert(Int,@PayVal / @Cl_Rate)  
                              Update DelPayOut Set ActPayOut = @DebitQty Where  
                              Sett_No = @Sett_No And Sett_Type = @Sett_Type And  
                              CertNo = @CertNo And Party_Code = @Party_Code     
                              Select @PayVal = 0  
                        End  
                        Fetch Next From @RecCur Into @Sett_No, @Sett_Type, @CertNo, @DebitQty, @Cl_Rate  
                  End  
            End  
            Else If @HoldAmt > 0 And @LedAmt < 0 And (@HoldAmt + @LedAmt) > 0 /* Breakup PayOut */  
            Begin  
                  Select @PayVal = @HoldAmt + @LedAmt  
                  Select @CurVal = 0  
                  Set @RecCur = Cursor For  
                  Select Sett_No, Sett_Type, CertNo, DebitQty, Cl_Rate From DelPayOut  
                  Where DebitQty > 0 And Party_Code = @Party_Code  
                  Order By PayOutDate,Cl_Rate    
                  Open @RecCur  
                  Fetch Next From @RecCur Into @Sett_No, @Sett_Type, @CertNo, @DebitQty, @Cl_Rate  
                  While @@Fetch_Status = 0 And @PayVal > 0   
                  Begin  
                        Select @CurVal = @DebitQty * @Cl_Rate  
                        If @CurVal <= @PayVal   
                        Begin  
                              Select @PayVal = @PayVal - @CurVal   
                              Update DelPayOut Set ActPayOut = DebitQty Where  
                              Sett_No = @Sett_No And Sett_Type = @Sett_Type And  
                              CertNo = @CertNo And Party_Code = @Party_Code         
                        End  
                        Else  
                        Begin  
                              Select @DebitQty = Convert(Int,@PayVal / @Cl_Rate)  
                              Update DelPayOut Set ActPayOut = @DebitQty Where  
                              Sett_No = @Sett_No And Sett_Type = @Sett_Type And  
                              CertNo = @CertNo And Party_Code = @Party_Code     
                              Select @PayVal = 0  
                        End  
                        Fetch Next From @RecCur Into @Sett_No, @Sett_Type, @CertNo, @DebitQty, @Cl_Rate  
                  End  
            End  
      Fetch next From @PayCur Into @Party_Code, @LedAmt, @HoldAmt  
      End  
End  
Else  
Begin  
      Set @PayCur = Cursor For  
            Select 
                  Party_code,
                  LedBal,
                  HoldAmt = 
                        (
                              (
                                    Sum(DebitQty * Cl_Rate) + Sum(PayQty * Cl_Rate) - Sum(ShrtQty * Cl_Rate) 
                              )  +   
                              (
                                    Case 
                                    When LedBal < 0 
                                    Then -( Sum(DebitQty * Cl_Rate) + Sum(PayQty * Cl_Rate) - Sum(ShrtQty * Cl_Rate) ) * 20 / 100 
                                    Else  ( Sum(DebitQty * Cl_Rate) + Sum(PayQty * Cl_Rate) - Sum(ShrtQty * Cl_Rate) ) * 20 / 100 
                                    End
                              )
                        )  
            From DelPayOut  
            Group By Party_code,LedBal  
            Order By Party_code  
      Open @PayCur  
      Fetch next From @PayCur Into @Party_Code, @LedAmt, @HoldAmt  
      While @@Fetch_Status = 0   
      Begin  
            IF @LedAmt >= 0 And @HoldAmt > 0 /* Full PayOut */  
            Begin   
                  Update DelPayOut Set ActPayOut = PoolQty   
                  Where PoolQty > 0 And Party_Code = @Party_Code  
            End  
            Else IF @LedAmt - Abs(@HoldAmt) > 0 /* Breakup PayOut */  
            Begin  
                  Select @PayVal = @LedAmt - Abs(@HoldAmt)  
                  Select @CurVal = 0  
                  Set @RecCur = Cursor For  
                  Select Sett_No, Sett_Type, CertNo, PoolQty, Cl_Rate , DpType From DelPayOut  
                  Where PoolQty > 0 And Party_Code = @Party_Code  
                  Order By PayOutDate,Cl_Rate    
                  Open @RecCur  
                  Fetch Next From @RecCur Into @Sett_No, @Sett_Type, @CertNo, @PoolQty, @Cl_Rate, @DpType  
                  While @@Fetch_Status = 0 And @PayVal > 0   
                  Begin  
                        Select @CurVal = @PoolQty * @Cl_Rate  
                        If @CurVal <= @PayVal   
                        Begin  
                              Select @PayVal = @PayVal - @CurVal   
                              Update DelPayOut Set ActPayOut = PoolQty Where  
                              Sett_No = @Sett_No And Sett_Type = @Sett_Type And  
                              CertNo = @CertNo And Party_Code = @Party_Code And  
                              DpType = @DpType        
                        End  
                        Else  
                        Begin  
                              Select @PoolQty = Convert(Int,@PayVal / @Cl_Rate)  
                              Update DelPayOut Set ActPayOut = @PoolQty Where  
                              Sett_No = @Sett_No And Sett_Type = @Sett_Type And  
                              CertNo = @CertNo And Party_Code = @Party_Code And   
                              DpType = @DpType    
                              Select @PayVal = 0  
                        End  
                        Fetch Next From @RecCur Into @Sett_No, @Sett_Type, @CertNo, @PoolQty, @Cl_Rate, @DpType  
                  End  
            End  
            Else If @HoldAmt > 0 And @LedAmt < 0 And (@HoldAmt + @LedAmt) > 0 /* Breakup PayOut */  
            Begin  
                  Select @PayVal = @HoldAmt + @LedAmt  
                  Select @CurVal = 0  
                  Set @RecCur = Cursor For  
                  Select Sett_No, Sett_Type, CertNo, PoolQty, Cl_Rate, DpType From DelPayOut  
                  Where PoolQty > 0 And Party_Code = @Party_Code  
                  Order By PayOutDate,Cl_Rate    
                  Open @RecCur  
                  Fetch Next From @RecCur Into @Sett_No, @Sett_Type, @CertNo, @PoolQty, @Cl_Rate, @DpType  
                  While @@Fetch_Status = 0 And @PayVal > 0   
                  Begin  
                        Select @CurVal = @PoolQty * @Cl_Rate  
                        If @CurVal <= @PayVal   
                        Begin  
                              Select @PayVal = @PayVal - @CurVal   
                              Update DelPayOut Set ActPayOut = PoolQty Where  
                              Sett_No = @Sett_No And Sett_Type = @Sett_Type And  
                              CertNo = @CertNo And Party_Code = @Party_Code And  
                              DpType = @DpType  
                        End  
                        Else  
                        Begin  
                              Select @DebitQty = Convert(Int,@PayVal / @Cl_Rate)  
                              Update DelPayOut Set ActPayOut = @PoolQty Where  
                              Sett_No = @Sett_No And Sett_Type = @Sett_Type And  
                              CertNo = @CertNo And Party_Code = @Party_Code And  
                              DpType = @DpType         
                              Select @PayVal = 0  
                        End  
                        Fetch Next From @RecCur Into @Sett_No, @Sett_Type, @CertNo, @PoolQty, @Cl_Rate, @DpType  
                  End  
            End  
            Fetch next From @PayCur Into @Party_Code, @LedAmt, @HoldAmt  
      End  
End

GO
