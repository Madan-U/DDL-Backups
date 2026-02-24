-- Object: PROCEDURE dbo.InsDebitPayOutCursorJm
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

/****** Object:  Stored Procedure dbo.InsDebitPayOutCursor    Script Date: 05/10/2004 5:41:50 PM ******/  
/* Drop Proc InsDebitPayOutCursorjm */  
CREATE  Proc InsDebitPayOutCursorjm   
 @ProcessType Varchar(4)  
As  
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
  
Exec InsDebitPayOut  
  
If @ProcessType = 'BEN'   
Begin  
 Set @PayCur = Cursor For  
  Select Party_code,LedBal=LedBal-Abs(LedBal*20/100),HoldAmt=(Sum(DebitQty*Cl_Rate)+Sum(PayQty*Cl_Rate)-Sum(ShrtQty*Cl_Rate))     
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
     /*Select @DebitQty = Convert(Int,@PayVal / @Cl_Rate)  
     Update DelPayOut Set ActPayOut = @DebitQty Where  
     Sett_No = @Sett_No And Sett_Type = @Sett_Type And  
     CertNo = @CertNo And Party_Code = @Party_Code*/ /* Commented as MOSL doesn't want the breakup payout for any scrip in Qty*/  
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
     /*Select @DebitQty = Convert(Int,@PayVal / @Cl_Rate)  
     Update DelPayOut Set ActPayOut = @DebitQty Where  
     Sett_No = @Sett_No And Sett_Type = @Sett_Type And  
     CertNo = @CertNo And Party_Code = @Party_Code*/ /* Commented as MOSL doesn't want the breakup payout for any scrip in Qty*/  
     Select @PayVal = 0  
    End  
    Fetch Next From @RecCur Into @Sett_No, @Sett_Type, @CertNo, @DebitQty, @Cl_Rate  
   End  
  End  
  Fetch next From @PayCur Into @Party_Code, @LedAmt, @HoldAmt  
 End  
  
 UPDATE DelPayOut SET ActPayOut = DebitQty FROM DELPARTYFLAG D WHERE   
 DebitQty > 0 AND DelPayOut.PARTY_CODE = D.PARTY_CODE  
 AND D.DEBITFLAG = 1   
  
 UPDATE DelPayOut SET ActPayOut = DebitQty FROM BSEDB.DBO.DELPARTYFLAG D WHERE   
 DebitQty > 0 AND DelPayOut.PARTY_CODE = D.PARTY_CODE  
 AND D.DEBITFLAG = 1   
End  
Else  
Begin  
 Set @PayCur = Cursor For  
  Select Party_code,LedBal=LedBal-Abs(LedBal*20/100),HoldAmt=(Sum(DebitQty*Cl_Rate)+Sum(PayQty*Cl_Rate)-Sum(ShrtQty*Cl_Rate))  
  From DelPayOut Where Party_Code Not in ( Select Distinct Party_Code From DelPayOut Where DebitQty > 0 )  
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
     /*Select @PoolQty = Convert(Int,@PayVal / @Cl_Rate)  
     Update DelPayOut Set ActPayOut = @PoolQty Where  
     Sett_No = @Sett_No And Sett_Type = @Sett_Type And  
     CertNo = @CertNo And Party_Code = @Party_Code And   
     DpType = @DpType*/ /* Commented as MOSL doesn't want the breakup payout for any scrip in Qty*/  
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
     /*Select @DebitQty = Convert(Int,@PayVal / @Cl_Rate)  
     Update DelPayOut Set ActPayOut = @PoolQty Where  
     Sett_No = @Sett_No And Sett_Type = @Sett_Type And  
     CertNo = @CertNo And Party_Code = @Party_Code And  
     DpType = @DpType*/ /* Commented as MOSL doesn't want the breakup payout for any scrip in Qty*/  
     Select @PayVal = 0  
    End  
    Fetch Next From @RecCur Into @Sett_No, @Sett_Type, @CertNo, @PoolQty, @Cl_Rate, @DpType  
   End  
  End  
  Fetch next From @PayCur Into @Party_Code, @LedAmt, @HoldAmt  
 End  
  
 UPDATE DelPayOut SET ActPayOut = PoolQty FROM DELPARTYFLAG D WHERE   
 PoolQty > 0 AND DelPayOut.PARTY_CODE = D.PARTY_CODE  
 AND D.DEBITFLAG = 1   
  
 UPDATE DelPayOut SET ActPayOut = PoolQty FROM BSEDB.DBO.DELPARTYFLAG D WHERE   
 PoolQty > 0 AND DelPayOut.PARTY_CODE = D.PARTY_CODE  
 AND D.DEBITFLAG = 1   
End  
  
INSERT INTO DelPayOutLog  
SELECT Exchange,Sett_No,Sett_Type,Party_Code,Scrip_cd,Series,CertNo,DebitQty,PayQty,ShrtQty,  
PoolQty,DpType,LedBal,EffBal,Cl_Rate,PayOutDate,ActPayOut,RUNDATE=GETDATE()   
FROM DelPayOut

GO
