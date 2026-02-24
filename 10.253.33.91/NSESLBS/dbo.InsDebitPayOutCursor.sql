-- Object: PROCEDURE dbo.InsDebitPayOutCursor
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc InsDebitPayOutCursor        
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
        
If @ProcessType = 'BEN'         
Begin        
 Set @PayCur = Cursor For        
  Select Party_code,LedBal,        
  ToDayShrt=Sum(Case When PayOutDate Like Left(Convert(Varchar,GetDate(),109),11) + '%'         
                                   Then ShrtQty*Cl_Rate         
                                   Else 0        
         End),        
  PayOut = Sum(PayQty*Cl_Rate),        
  FutShort=Sum(Case When PayOutDate > Left(Convert(Varchar,GetDate(),109),11) + ' 23:59:59'        
                                   Then ShrtQty*Cl_Rate         
                                   Else 0        
         End),        
  HoldAmt=Sum(DebitQty*Cl_Rate)        
  From DelPayOut         
  Group By Party_code,LedBal        
  Order By Party_code        
 Open @PayCur        
 Fetch next From @PayCur Into @Party_Code, @LedAmt, @ToDayShrt, @PayOut, @FutShort, @HoldAmt        
 --Select @Party_Code, @LedAmt, @ToDayShrt, @PayOut, @FutShort, @HoldAmt        
 While @@Fetch_Status = 0         
 Begin        
  IF (@LedAmt - @ToDayShrt - @FutShort) >= -500 /* Full PayOut */        
  Begin         
   IF (@PayOut -  (@ToDayShrt + @FutShort)*120/100) >= 0         
   Begin        
    Update DelPayOut Set ActPayOut = DebitQty         
    Where DebitQty > 0 And Party_Code = @Party_Code         
   End        
   Else        
   Begin        
    Select @PayVal = @HoldAmt + (@LedAmt - @TodayShrt + (@PayOut - (@FutShort)*120/100))        
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
      Select @PayVal = @PayVal        
     End        
     Fetch Next From @RecCur Into @Sett_No, @Sett_Type, @CertNo, @DebitQty, @Cl_Rate        
    End            
   End        
  End        
  Else         
  Begin        
   Select @PayVal = @HoldAmt + (@LedAmt - @TodayShrt + (@PayOut - (@FutShort)*120/100))        
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
     Select @PayVal = @PayVal        
    End        
    Fetch Next From @RecCur Into @Sett_No, @Sett_Type, @CertNo, @DebitQty, @Cl_Rate        
   End            
  End        
  Fetch next From @PayCur Into @Party_Code, @LedAmt, @ToDayShrt, @PayOut, @FutShort, @HoldAmt        
 End        
        
 UPDATE DelPayOut SET ActPayOut = DebitQty FROM DELPARTYFLAG D WHERE         
 DebitQty > 0 AND DelPayOut.PARTY_CODE = D.PARTY_CODE        
 AND D.DEBITFLAG = 1         
        
 UPDATE DelPayOut SET ActPayOut = DebitQty FROM BSEDB.DBO.DELPARTYFLAG D WHERE         
 DebitQty > 0 AND DelPayOut.PARTY_CODE = D.PARTY_CODE        
 AND D.DEBITFLAG = 1         
      
 Insert into delpayoutlog select *,getdate() from DelPayOut        
      
End        
Else        
Begin        
 Set @PayCur = Cursor For        
  Select Party_code, LedBal,         
  PayOut = Sum(Case When PayOutDate Like Left(Convert(Varchar,GetDate(),109),11) + '%'         
                                  Then PayQty*Cl_Rate        
                                  Else 0         
                             End),        
  FutPayOut = Sum(Case When PayOutDate > Left(Convert(Varchar,GetDate(),109),11) + ' 23:59:59'        
                                  Then PayQty*Cl_Rate        
                                  Else 0         
                             End),        
  FutShort=Sum(Case When PayOutDate > Left(Convert(Varchar,GetDate(),109),11) + ' 23:59:59'        
                                   Then ShrtQty*Cl_Rate         
                                   Else 0        
         End)        
  From DelPayOut Where Party_Code Not in ( Select Distinct Party_Code From DelPayOut Where DebitQty > 0 )        
  Group By Party_code,LedBal        
  Order By Party_code        
 Open @PayCur        
 Fetch next From @PayCur Into @Party_Code, @LedAmt, @PayOut, @FutPayOut, @FutShort        
 While @@Fetch_Status = 0         
 Begin        
  IF @LedAmt >= -500 /* Full PayOut */        
  Begin         
   If (@FutPayOut -  (@FutShort)*120/100) >= 0         
   Begin        
    Update DelPayOut Set ActPayOut = PoolQty         
    Where PoolQty > 0 And Party_Code = @Party_Code        
   End        
   Else        
   Begin        
    Select @PayVal = @PayOut + (@LedAmt + (@FutPayOut - (@FutShort*120/100)))        
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
      Select @PayVal = @PayVal        
     End        
     Fetch Next From @RecCur Into @Sett_No, @Sett_Type, @CertNo, @PoolQty, @Cl_Rate, @DpType        
    End        
   End        
  End        
  Else         
  Begin        
   Select @PayVal = @PayOut + (@LedAmt + (@FutPayOut - (@FutShort*120/100)))        
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
     Select @PayVal = @PayVal        
    End        
    Fetch Next From @RecCur Into @Sett_No, @Sett_Type, @CertNo, @PoolQty, @Cl_Rate, @DpType        
   End        
  End        
  Fetch next From @PayCur Into @Party_Code, @LedAmt, @PayOut, @FutPayOut, @FutShort        
 End        
        
 UPDATE DelPayOut SET ActPayOut = PoolQty FROM DELPARTYFLAG D WHERE         
 PoolQty > 0 AND DelPayOut.PARTY_CODE = D.PARTY_CODE        
 AND D.DEBITFLAG = 1         
        
 UPDATE DelPayOut SET ActPayOut = PoolQty FROM BSEDB.DBO.DELPARTYFLAG D WHERE         
 PoolQty > 0 AND DelPayOut.PARTY_CODE = D.PARTY_CODE        
 AND D.DEBITFLAG = 1           
 Insert into delpayoutlog select *,getdate() from DelPayOut        
End

GO
