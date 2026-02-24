-- Object: PROCEDURE dbo.STT_Charges_Final_bkp03062013
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

  
 CREATE Proc [dbo].[STT_Charges_Final_bkp03062013] (@Sett_Type Varchar(2), @Sauda_Date Varchar(11), @FromParty Varchar(10), @ToParty Varchar(10)) As  
Declare @Party_Code Varchar(10),  
@Amt Numeric(18,4),  
@Trade_No Varchar(14),  
@Order_No Varchar(16),  
@TrdBuyTrans Numeric(18,4),  
@TrdSellTrans Numeric(18,4),  
@DelBuyTrans Numeric(18,4),  
@DelSellTrans Numeric(18,4),  
@ETFSELLTRANS  NUMERIC(18,4),  
@STTCur Cursor  
  
Select @TrdBuyTrans  = 0   
Select @TrdSellTrans = 0  
Select @DelSellTrans = 0  
Select @DelBuyTrans  = 0  
SELECT @ETFSELLTRANS = 0  
  
Select @TrdBuyTrans = TrdBuyTrans, @TrdSellTrans = TrdSellTrans,   
@DelBuyTrans = DelBuyTrans, @DelSellTrans = DelSellTrans,  
  @ETFSELLTRANS = ETFSELLTRANS   
From Globals   
Where year_start_dt <= @Sauda_Date And year_end_dt >= @Sauda_Date  
  
  
If (@TrdBuyTrans > 0 Or @TrdSellTrans > 0 Or @DelSellTrans > 0 Or @DelBuyTrans > 0 OR @ETFSELLTRANS > 0)  
Begin  
   
 Update settlement set ins_chrg = 0  
 where Sett_Type = @Sett_Type And   
 sauda_date like @Sauda_Date + '%' and   
 Party_Code >= @FromParty And Party_Code <= @ToParty And   
 auctionpart not in ('AP','AR','FP','FL','FA','FC') and  
 trade_no not like '%C%'  
   
 If Upper(LTrim(RTrim(@Sett_Type))) = 'N' Or Upper(LTrim(RTrim(@Sett_Type))) = 'D'  
 Begin  
   Select Sett_No, Sett_Type, ContractNo, Party_Code, Scrip_CD, Series,   
   TrdVal = Round(Sum(TradeQty*MarketRate)/Sum(TradeQty),4)  
   Into #AniSett From Settlement   
   Where Sett_Type = @Sett_Type And Sauda_Date Like @Sauda_Date + '%'   
   And Party_Code >= @FromParty And Party_Code <= @ToParty  
   And TradeQty > 0      
   And Trade_No Not Like '%C%'  
   And AuctionPart Not in ('AP','AR','FP','FL','FA','FC')  
   And User_Id Not In ( Select UserId From TermParty )  
   Group By Sett_No, Sett_Type, ContractNo, Party_Code, Scrip_CD, Series  
   Order By Sett_No, Sett_Type, ContractNo, Party_Code, Scrip_CD, Series  
    
   Update Settlement Set Ins_Chrg = Round(TradeQty * TrdVal * @TrdSellTrans / 100,4)        
   From #AniSett A   
   Where Settlement.Sett_No = A.Sett_No And Settlement.Sett_Type = A.Sett_Type  
   And Settlement.Party_Code = A.Party_Code And Settlement.Scrip_CD = A.Scrip_CD  
   And Sauda_Date Like @Sauda_Date + '%' And Settlement.Sett_Type = @Sett_Type  
   And Settlement.Party_Code >= @FromParty And Settlement.Party_Code <= @ToParty   
   And SettFlag In (2,3) And AuctionPart Not in ('AP','AR','FP','FL','FA','FC')  
   And Sell_buy = 2   
   And Settlement.ContractNo = A.ContractNo And Trade_No Not Like '%C%'  
   And User_Id Not In ( Select UserId From TermParty )  
    
   Update Settlement Set Ins_Chrg = (Case When Sell_buy = 1   
              Then Round(TradeQty * TrdVal * @DelBuyTrans / 100,4)  
              Else Round(TradeQty * TrdVal * @DelSellTrans / 100,4)  
         End)  
   From #AniSett A Where Settlement.Sett_No = A.Sett_No And Settlement.Sett_Type = A.Sett_Type  
   And Settlement.Party_Code = A.Party_Code And Settlement.Scrip_CD = A.Scrip_CD  
   And Sauda_Date Like @Sauda_Date + '%' And Settlement.Sett_Type = @Sett_Type  
   And Settlement.Party_Code >= @FromParty And Settlement.Party_Code <= @ToParty   
   And SettFlag In (1,4,5) And AuctionPart Not in ('AP','AR','FP','FL','FA','FC')  
   And Settlement.ContractNo = A.ContractNo And Trade_No Not Like '%C%'  
   And User_Id Not In ( Select UserId From TermParty )   
  
    UPDATE Settlement                      
    SET                       
     INS_CHRG = (CASE WHEN SELL_BUY = 1                          
      THEN 0                          
      ELSE ROUND(TRADEQTY * TRDVAL * @ETFSELLTRANS / 100,4)                          
     END)              
    FROM                       
     #AniSett A                         
   Where Settlement.Sett_No = A.Sett_No And Settlement.Sett_Type = A.Sett_Type  
   And Settlement.Party_Code = A.Party_Code And Settlement.Scrip_CD = A.Scrip_CD  
   And Sauda_Date Like @Sauda_Date + '%' And Settlement.Sett_Type = @Sett_Type  
   And Settlement.Party_Code >= @FromParty And Settlement.Party_Code <= @ToParty   
   And SettFlag In (1,4,5) And AuctionPart Not in ('AP','AR','FP','FL','FA','FC')  
   And Settlement.ContractNo = A.ContractNo And Trade_No Not Like '%C%'  
   And User_Id Not In ( Select UserId From TermParty )   
  AND Settlement.SCRIP_CD IN (SELECT SCRIP_CD FROM TBL_STT_SCRIP WHERE @SAUDA_DATE BETWEEN DATEFROM AND DATETO   
          AND Settlement.SCRIP_CD = TBL_STT_SCRIP.SCRIP_CD AND Settlement.SERIES = TBL_STT_SCRIP.SERIES AND CHARGE_FLAG = 1)  
  AND @ETFSELLTRANS > 0  
  
   Select Sett_No, Sett_Type, ContractNo, Party_Code, Scrip_CD, Series,   
   TrdVal = Round(Sum(TradeQty*MarketRate)/Sum(TradeQty),4)  
   Into #AniISett From ISettlement   
   Where Sauda_Date Like @Sauda_Date + '%'   
   And ISettlement.Sett_Type = @Sett_Type  
   And Party_Code >= @FromParty And Party_Code <= @ToParty   
   And Trade_No Not Like '%C%' And TradeQty > 0   
   Group By Sett_No, Sett_Type, ContractNo, Party_Code, Scrip_CD, Series  
   Order By Sett_No, Sett_Type, ContractNo, Party_Code, Scrip_CD, Series  
     
   Update ISettlement Set Ins_Chrg = (Case When Sell_buy = 1   
              Then Round(TradeQty * TrdVal * @DelBuyTrans / 100,4)  
              Else Round(TradeQty * TrdVal * @DelSellTrans / 100,4)  
          End)  
   From #AniISett A Where ISettlement.Sett_No = A.Sett_No And ISettlement.Sett_Type = A.Sett_Type  
   And ISettlement.Party_Code = A.Party_Code And ISettlement.Scrip_CD = A.Scrip_CD  
   And Sauda_Date Like @Sauda_Date + '%' And ISettlement.Sett_Type = @Sett_Type  
   And ISettlement.Party_Code >= @FromParty And ISettlement.Party_Code <= @ToParty   
   And Trade_No Not Like '%C%'  
   And ISettlement.ContractNo = A.ContractNo  
  
    UPDATE ISettlement                       
    SET                       
     INS_CHRG =  (CASE WHEN SELL_BUY = 1 THEN 0                          
        ELSE ROUND(TRADEQTY * TRDVAL * @ETFSELLTRANS / 100,4)                          
       END)                          
    FROM #AniISett A                       
    Where ISettlement.Sett_No = A.Sett_No And ISettlement.Sett_Type = A.Sett_Type  
   And ISettlement.Party_Code = A.Party_Code And ISettlement.Scrip_CD = A.Scrip_CD  
   And Sauda_Date Like @Sauda_Date + '%' And ISettlement.Sett_Type = @Sett_Type  
   And ISettlement.Party_Code >= @FromParty And ISettlement.Party_Code <= @ToParty   
   And Trade_No Not Like '%C%'  
   And ISettlement.ContractNo = A.ContractNo  
  AND ISettlement.SCRIP_CD IN (SELECT SCRIP_CD FROM TBL_STT_SCRIP WHERE @SAUDA_DATE BETWEEN DATEFROM AND DATETO   
          AND ISettlement.SCRIP_CD = TBL_STT_SCRIP.SCRIP_CD AND ISettlement.SERIES = TBL_STT_SCRIP.SERIES AND CHARGE_FLAG = 1)  
  AND @ETFSELLTRANS > 0   
  
   /* For Terminal Mapping */  
   Select Sett_No, Sett_Type, ContractNo, Branch_id, Party_Code, Scrip_CD, Series,   
   TrdVal = IsNull(Round(Sum(TradeQty*MarketRate)/Sum(TradeQty),2),0),  
   PQtyDel = (Case When Sum(Case When Sell_Buy = 1  
                   Then TradeQty   
                   Else 0   
                     End) > Sum(Case When Sell_Buy = 2   
                       Then TradeQty   
                       Else 0   
                  End)  
                  Then Sum(Case When Sell_Buy = 1   
                   Then TradeQty   
                   Else 0   
                     End) - Sum(Case When Sell_Buy = 2   
                       Then TradeQty   
                       Else 0   
                  End)  
     Else 0   
       End),  
   SQtyDel = (Case When Sum(Case When Sell_Buy = 2  
                   Then TradeQty   
                   Else 0   
                     End) > Sum(Case When Sell_Buy = 1   
                       Then TradeQty   
                       Else 0   
                  End)  
                  Then Sum(Case When Sell_Buy = 2   
                   Then TradeQty   
                   Else 0   
                     End) - Sum(Case When Sell_Buy = 1   
                       Then TradeQty   
                       Else 0   
                  End)  
     Else 0   
       End),  
   SQtyTrd = (Case When Sum(Case When Sell_Buy = 1  
                   Then TradeQty   
                   Else 0   
                     End) >= Sum(Case When Sell_Buy = 2   
                       Then TradeQty   
                       Else 0   
                  End)  
                  Then Sum(Case When Sell_Buy = 2   
                   Then TradeQty   
                   Else 0   
                     End)  
     Else Sum(Case When Sell_Buy = 1   
                   Then TradeQty   
                   Else 0   
                     End)  
       End),  
   PSTTDEL = Convert(Numeric(18,4),4),  
   SSTTDEL = Convert(Numeric(18,4),4),  
   SSTTTRD = Convert(Numeric(18,4),4),  
   TotalTax = Convert(Numeric(18,4),4)  
   Into #AniSettOrg From Settlement   
   Where Sauda_Date Like @Sauda_Date + '%'      
   And Settlement.Sett_Type = @Sett_Type  
   And Party_Code >= @FromParty And Party_Code <= @ToParty   
   And AuctionPart Not in ('AP','AR','FP','FL','FA','FC') And Trade_No Not Like '%C%'  
   And TradeQty > 0   
   And User_Id In ( Select UserId From TermParty )  
   Group By Sett_No, Sett_Type, ContractNo, Branch_id, Party_Code, Scrip_CD, Series  
   Order By Sett_No, Sett_Type, ContractNo, Branch_id, Party_Code, Scrip_CD, Series  
     
   Update #AniSettOrg Set PSTTDEL  = Round(PQtyDel*TrdVal*@DelBuyTrans/100,4),  
            SSTTDEL  = Round(SQtyDel*TrdVal*@DelSellTrans/100,4),   
            SSTTTRD  = Round(SQtyTrd*TrdVal*@TrdSellTrans/100,4),  
            TotalTax = Round(PQtyDel*TrdVal*@DelBuyTrans/100,4)  +   
         Round(SQtyDel*TrdVal*@DelSellTrans/100,4) +   
         Round(SQtyTrd*TrdVal*@TrdSellTrans/100,4)  
  
 UPDATE #AniSettOrg                       
    SET PSTTDEL = 0, SSTTDEL  = ROUND(SQTYDEL*TRDVAL*@ETFSELLTRANS/100,4),   
 TOTALTAX =  ROUND(SQTYDEL*TRDVAL*@ETFSELLTRANS/100,4) + SSTTTRD  
 WHERE #AniSettOrg.SCRIP_CD IN (SELECT SCRIP_CD FROM TBL_STT_SCRIP WHERE @SAUDA_DATE BETWEEN DATEFROM AND DATETO   
          AND #AniSettOrg.SCRIP_CD = TBL_STT_SCRIP.SCRIP_CD AND #AniSettOrg.SERIES = TBL_STT_SCRIP.SERIES AND CHARGE_FLAG = 1)  
 AND @ETFSELLTRANS > 0   
     
   Select Sett_No, Sett_Type, ContractNo, Branch_id, Party_Code, Scrip_CD, Series, Trade_No = Min(Trade_No+'-'+Scrip_cd)   
   Into #SettSTTOrg From Settlement Where Sauda_Date Like @Sauda_Date + '%'   
   And Settlement.Sett_Type = @Sett_Type  
   And Party_Code >= @FromParty And Party_Code <= @ToParty   
   And TradeQty > 0   
   And AuctionPart Not in ('AP','AR','FP','FL','FA','FC')   
   And Trade_No Not Like '%C%'  
   And User_Id In ( Select UserId From TermParty )  
   Group By Sett_No, Sett_Type, ContractNo, Branch_id, Party_Code, Scrip_CD, Series  
     
   Update Settlement Set Ins_Chrg = TotalTax   
   From #AniSettOrg S, #SettSttOrg A  
   Where Settlement.Sett_No = S.Sett_No  
   And Settlement.Sett_Type = S.Sett_Type  
   And Sauda_Date Like @Sauda_Date + '%' And TradeQty > 0   
   And Settlement.Scrip_Cd = S.Scrip_CD  
   And Settlement.Series = S.Series  
   And Settlement.Branch_id = S.Branch_id    
   And Settlement.Sett_No = A.Sett_No  
   And Settlement.Sett_Type = A.Sett_Type  
   And Settlement.Scrip_Cd = A.Scrip_CD  
   And Settlement.Series = A.Series  
   And Settlement.Branch_id = A.Branch_Id  
   And AuctionPart Not in ('AP','AR','FP','FL','FA','FC')  
   And Settlement.Trade_No Not Like '%C%'  
   And Settlement.Trade_No + '-' + Settlement.Scrip_Cd = A.Trade_No  
   And Settlement.ContractNo = A.ContractNo  
   And User_Id In ( Select UserId From TermParty )  
  
 End  
  
 If Upper(LTrim(RTrim(@Sett_Type))) = 'A' Or Upper(LTrim(RTrim(@Sett_Type))) = 'W' Or Upper(LTrim(RTrim(@Sett_Type))) = 'AD' Or Upper(LTrim(RTrim(@Sett_Type))) = 'C'    
  Begin  
   Update Settlement Set Ins_Chrg = (Case When Sell_buy = 1   
              Then Round(TradeQty * MarketRate * @DelBuyTrans / 100,4)  
              Else Round(TradeQty * MarketRate * @DelSellTrans / 100,4)  
         End)  
   Where Sauda_Date Like @Sauda_Date + '%'        
   And Settlement.Sett_Type = @Sett_Type  
   And Party_Code >= @FromParty And Party_Code <= @ToParty   
   And AuctionPart Not in ('AP','AR','FP','FL','FA','FC')   
   And TradeQty > 0 And Trade_No Not Like '%C%'  
   And User_Id Not In ( Select UserId From TermParty )  
  
 UPDATE Settlement                       
    SET                       
     INS_CHRG =  (CASE WHEN SELL_BUY = 1                           
        THEN 0                      
        ELSE ROUND(TRADEQTY * MARKETRATE * @ETFSELLTRANS / 100,4)                          
       END)                          
   Where Sauda_Date Like @Sauda_Date + '%'        
   And Settlement.Sett_Type = @Sett_Type  
   And Party_Code >= @FromParty And Party_Code <= @ToParty   
   And AuctionPart Not in ('AP','AR','FP','FL','FA','FC')   
   And TradeQty > 0 And Trade_No Not Like '%C%'  
   And User_Id Not In ( Select UserId From TermParty )                       
 AND Settlement.SCRIP_CD IN (SELECT SCRIP_CD FROM TBL_STT_SCRIP WHERE @SAUDA_DATE BETWEEN DATEFROM AND DATETO   
          AND Settlement.SCRIP_CD = TBL_STT_SCRIP.SCRIP_CD AND Settlement.SERIES = TBL_STT_SCRIP.SERIES AND CHARGE_FLAG = 1)                      
    AND @ETFSELLTRANS > 0   
     
   Update ISettlement Set Ins_Chrg = (Case When Sell_buy = 1   
              Then Round(TradeQty * MarketRate * @DelBuyTrans / 100,4)  
              Else Round(TradeQty * MarketRate * @DelSellTrans / 100,4)  
         End)  
   Where Sauda_Date Like @Sauda_Date + '%'        
   And ISettlement.Sett_Type = @Sett_Type  
   And Party_Code >= @FromParty And Party_Code <= @ToParty   
   And AuctionPart Not in ('AP','AR','FP','FL','FA','FC')   
   And TradeQty > 0 And Trade_No Not Like '%C%'  
  
 UPDATE ISettlement                       
    SET                       
     INS_CHRG =  (CASE WHEN SELL_BUY = 1                           
        THEN 0                      
        ELSE ROUND(TRADEQTY * MARKETRATE * @ETFSELLTRANS / 100,4)                          
       END)                          
    WHERE                       
     Sauda_Date Like @Sauda_Date + '%'        
   And ISettlement.Sett_Type = @Sett_Type  
   And Party_Code >= @FromParty And Party_Code <= @ToParty   
   And AuctionPart Not in ('AP','AR','FP','FL','FA','FC')   
   And TradeQty > 0 And Trade_No Not Like '%C%'                 
 AND ISettlement.SCRIP_CD IN (SELECT SCRIP_CD FROM TBL_STT_SCRIP WHERE @SAUDA_DATE BETWEEN DATEFROM AND DATETO   
          AND ISettlement.SCRIP_CD = TBL_STT_SCRIP.SCRIP_CD AND ISettlement.SERIES = TBL_STT_SCRIP.SERIES AND CHARGE_FLAG = 1)   
    AND @ETFSELLTRANS > 0   
     
   Update Settlement Set Ins_Chrg = (Case When Sell_buy = 1   
              Then Round(TradeQty * MarketRate * @DelBuyTrans / 100,4)  
              Else Round(TradeQty * MarketRate * @DelSellTrans / 100,4)  
         End)  
   Where Sauda_Date Like @Sauda_Date + '%'        
   And Settlement.Sett_Type = @Sett_Type  
   And Party_Code >= @FromParty And Party_Code <= @ToParty   
   And AuctionPart Not in ('AP','AR','FP','FL','FA','FC')   
   And TradeQty > 0 And Trade_No Not Like '%C%'  
   And User_Id In ( Select UserId From TermParty )  
  
 UPDATE Settlement                       
    SET                       
     INS_CHRG =  (CASE WHEN SELL_BUY = 1                           
        THEN 0                      
        ELSE ROUND(TRADEQTY * MARKETRATE * @ETFSELLTRANS / 100,4)                          
       END)                          
   Where Sauda_Date Like @Sauda_Date + '%'        
   And Settlement.Sett_Type = @Sett_Type  
   And Party_Code >= @FromParty And Party_Code <= @ToParty   
   And AuctionPart Not in ('AP','AR','FP','FL','FA','FC')   
   And TradeQty > 0 And Trade_No Not Like '%C%'  
   And User_Id In ( Select UserId From TermParty )                       
 AND Settlement.SCRIP_CD IN (SELECT SCRIP_CD FROM TBL_STT_SCRIP WHERE @SAUDA_DATE BETWEEN DATEFROM AND DATETO   
          AND Settlement.SCRIP_CD = TBL_STT_SCRIP.SCRIP_CD AND Settlement.SERIES = TBL_STT_SCRIP.SERIES AND CHARGE_FLAG = 1)                      
    AND @ETFSELLTRANS > 0   
  End  
  
 Update Settlement Set Ins_chrg = 0 Where Sett_Type = @Sett_Type   
  And Sauda_Date Like @Sauda_Date + '%'        
 And Party_Code >= @FromParty And Party_Code <= @ToParty   
 And AuctionPart Not in ('AP','AR','FP','FL','FA','FC')   
 And TradeQty > 0 And Trade_No Not Like '%C%'  
 And User_Id Not In ( Select UserId From TermParty )  
  And ( Scrip_Cd Like '9%' Or Scrip_Cd Like 'LIQUIDBEES')  
  
 Update Settlement Set Ins_chrg = 0 Where Sett_Type = @Sett_Type   
  And Sauda_Date Like @Sauda_Date + '%'        
 And Party_Code >= @FromParty And Party_Code <= @ToParty   
 And AuctionPart Not in ('AP','AR','FP','FL','FA','FC')   
 And TradeQty > 0 And Trade_No Not Like '%C%'  
 And User_Id Not In ( Select UserId From TermParty )  
  And Left(Series,1) Not In ('E','B','I','X','L')  
  
 Update ISettlement Set Ins_chrg = 0 Where Sett_Type = @Sett_Type   
  And Sauda_Date Like @Sauda_Date + '%'        
 And Party_Code >= @FromParty And Party_Code <= @ToParty   
 And AuctionPart Not in ('AP','AR','FP','FL','FA','FC')   
 And TradeQty > 0 And Trade_No Not Like '%C%'  
 And User_Id Not In ( Select UserId From TermParty )  
  And ( Scrip_Cd Like '9%' Or Scrip_Cd Like 'LIQUIDBEES')  
  
 Update ISettlement Set Ins_chrg = 0 Where Sett_Type = @Sett_Type   
  And Sauda_Date Like @Sauda_Date + '%'        
 And Party_Code >= @FromParty And Party_Code <= @ToParty   
 And AuctionPart Not in ('AP','AR','FP','FL','FA','FC')   
 And TradeQty > 0 And Trade_No Not Like '%C%'  
 And User_Id Not In ( Select UserId From TermParty )  
  And Left(Series,1) Not In ('E','B','I','X','L')  
  
 Exec STT_InsertData_Detail @Sett_Type, @Sauda_Date, @FromParty, @ToParty  
  
 If Upper(LTrim(RTrim(@Sett_Type))) = 'N' Or Upper(LTrim(RTrim(@Sett_Type))) = 'D'  
  Begin   
  
   Update #AniSettOrg Set TotalTax = 0 Where ( Scrip_Cd Like '9%' Or Scrip_Cd Like 'LIQUIDBEES')  
   Update #AniSettOrg Set TotalTax = 0 Where Left(Series,1) Not In ('E','B','I','X','L')  
  
   Insert Into STT_ClientDetail  
   Select 30, Sett_no, Sett_Type, ContractNo, Party_Code, Scrip_Cd, Series, Sauda_Date=@Sauda_Date,Branch_Id,  
   TrdVal, PQtyDel, PQtyDel * TrdVal, PSttDel,  
   TrdVal, SQtyDel, SQtyDel * TrdVal, SSttDel,  
   TrdVal, SQtyTrd, SQtyTrd * TrdVal, SSttTrd,  
   TotalTax From #AniSettOrg  
   End  
  
 /* Rounding for 1 Rs. Start with out terminal mapping */  
  
 Select ContractNo, Party_Code, Sett_No, Sett_Type, ActChrg = Sum(ActChrg),  
  TobeChrg = Round(Sum(TobeChrg),0) Into #AniSettRound From (   
 Select ContractNo, Party_Code, Sett_No, Sett_Type, Scrip_Cd, Series, ActChrg = Sum(Ins_Chrg),   
 TobeChrg = Sum(Ins_Chrg)  
 From Settlement   
 Where Sauda_Date Like @Sauda_Date + '%'        
 And Settlement.Sett_Type = @Sett_Type  
 And Party_Code >= @FromParty And Party_Code <= @ToParty   
 And AuctionPart Not in ('AP','AR','FP','FL','FA','FC')   
 And TradeQty > 0 And Trade_No Not Like '%C%'  
 And User_Id Not In ( Select UserId From TermParty )  
 Group By ContractNo, Party_Code, Sett_No, Sett_Type, Scrip_Cd, Series ) A  
 Group By ContractNo, Party_Code, Sett_No, Sett_Type  
   
 Select S.Sett_No, S.Sett_Type, S.ContractNo, S.Party_Code, Trade_No = Min(Trade_No+'-'+Scrip_Cd)   
 Into #SettSTTParty From Settlement S, #AniSettRound A   
 Where S.Sauda_Date Like @Sauda_Date + '%'        
 And S.Sett_Type = @Sett_Type  
 And S.Party_Code >= @FromParty And S.Party_Code <= @ToParty   
 And S.AuctionPart Not in ('AP','AR','FP','FL','FA','FC')   
 And TradeQty > 0 And Trade_No Not Like '%C%'   
 And A.Sett_Type = S.Sett_Type  
 And A.Sett_No = S.Sett_No  
 And A.Party_Code = S.Party_Code  
 And Ins_Chrg >= (Case When ToBeChrg-ActChrg < 0 Then abs(ToBeChrg-ActChrg) Else 0 End)  
 And Ins_Chrg > 0    
 And S.ContractNo = A.ContractNo  
 And S.ContractNo = A.ContractNo  
 And User_Id Not In ( Select UserId From TermParty )  
 Group By S.Sett_No, S.Sett_Type, S.ContractNo, S.Party_Code  
   
 Update Settlement Set Ins_Chrg = Ins_Chrg + (ToBeChrg-ActChrg)  
 From #SettSTTParty A, #AniSettRound S  
 Where Settlement.Sauda_Date Like @Sauda_Date + '%'        
 And Settlement.Sett_Type = @Sett_Type  
 And Settlement.Party_Code >= @FromParty And Settlement.Party_Code <= @ToParty   
 And Settlement.AuctionPart Not in ('AP','AR','FP','FL','FA','FC')   
 And Settlement.TradeQty > 0 And Settlement.Trade_No Not Like '%C%'   
 And Settlement.Sett_No = A.Sett_No  
 And Settlement.Sett_Type = A.Sett_Type  
 And Settlement.Party_Code = A.Party_Code  
 And Settlement.Sett_No = S.Sett_No  
 And Settlement.Sett_Type = S.Sett_Type  
 And Settlement.Party_Code = S.Party_Code  
 And Settlement.Trade_No + '-' + Settlement.Scrip_Cd = A.Trade_No  
 And Settlement.ContractNo = A.ContractNo  
 And S.ContractNo = A.ContractNo  
 And User_Id Not In ( Select UserId From TermParty )  
  
 Update Settlement set Ins_Chrg = 0   
 Where Settlement.Sauda_Date Like @Sauda_Date + '%'        
 And Settlement.Sett_Type = @Sett_Type  
 And Settlement.Party_Code >= @FromParty And Settlement.Party_Code <= @ToParty   
 And Settlement.AuctionPart Not in ('AP','AR','FP','FL','FA','FC')   
 And TradeQty > 0 And Trade_No Not Like '%C%'   
 And Party_Code in ( Select Party_Code From #AniSettRound A  
 Where Settlement.Sett_No = A.Sett_No  
 And Settlement.Sett_Type = A.Sett_Type  
 And Settlement.Party_Code = A.Party_Code  
 And TobeChrg = 0)  And User_Id Not In ( Select UserId From TermParty )  
  
 /* Rounding for 1 Rs. End Normal Clients with out terminal mapping*/  
  
 /* Rounding for 1 Rs. Start Here with terminal mapping */  
  
  Select ContractNo, Branch_Id, Party_Code, Sett_No, Sett_Type, ActChrg = Sum(ActChrg),   
  TobeChrg = Round(Sum(TobeChrg),0) Into #AniSettRoundOrg From (  
 Select ContractNo, Branch_Id, Party_Code, Sett_No, Sett_Type, Scrip_Cd, Series, ActChrg = Sum(Ins_Chrg),   
 TobeChrg = Sum(Ins_Chrg)  
 From Settlement   
 Where Settlement.Sauda_Date Like @Sauda_Date + '%'        
 And Settlement.Sett_Type = @Sett_Type  
 And Settlement.Party_Code >= @FromParty And Settlement.Party_Code <= @ToParty   
 And Settlement.AuctionPart Not in ('AP','AR','FP','FL','FA','FC')   
 And TradeQty > 0 And Trade_No Not Like '%C%'   
 And User_Id In ( Select UserId From TermParty )  
 Group By ContractNo, Branch_Id, Party_Code, Sett_No, Sett_Type, Scrip_Cd, Series ) A  
 Group BY ContractNo, Branch_Id, Party_Code, Sett_No, Sett_Type  
   
 Select S.Sett_No, S.Sett_Type, S.ContractNo, S.Branch_Id, S.Party_Code, Trade_No = Min(Trade_No+'-'+Scrip_Cd)   
 Into #SettSTTPartyOrg From Settlement S, #AniSettRoundOrg A   
 Where S.Sauda_Date Like @Sauda_Date + '%'        
 And S.Sett_Type = @Sett_Type  
 And S.Party_Code >= @FromParty And S.Party_Code <= @ToParty   
 And S.AuctionPart Not in ('AP','AR','FP','FL','FA','FC')   
 And TradeQty > 0 And Trade_No Not Like '%C%'   
 And A.Sett_Type = S.Sett_Type  
 And A.Sett_No = S.Sett_No  
 And A.Branch_Id = S.Branch_Id  
 And Ins_Chrg >= (Case When ToBeChrg-ActChrg < 0 Then abs(ToBeChrg-ActChrg) Else 0 End)  
 And Ins_Chrg > 0    
 And S.ContractNo = A.ContractNo  
 And User_Id In ( Select UserId From TermParty )  
 Group By S.Sett_No, S.Sett_Type, S.ContractNo, S.Branch_Id, S.Party_Code   
   
 Update Settlement Set Ins_Chrg = Ins_Chrg + (ToBeChrg-ActChrg)  
 From #SettSTTPartyOrg A, #AniSettRoundOrg S  
 Where Settlement.Sauda_Date Like @Sauda_Date + '%'        
 And Settlement.Sett_Type = @Sett_Type  
 And Settlement.Party_Code >= @FromParty And Settlement.Party_Code <= @ToParty   
 And Settlement.AuctionPart Not in ('AP','AR','FP','FL','FA','FC')   
 And TradeQty > 0 And Settlement.Trade_No Not Like '%C%'   
 And Settlement.Sett_No = A.Sett_No  
 And Settlement.Sett_Type = A.Sett_Type  
 And Settlement.Branch_id = A.Branch_Id  
 And Settlement.Sett_No = S.Sett_No  
 And Settlement.Sett_Type = S.Sett_Type  
 And Settlement.Branch_id = S.Branch_Id   
 And Settlement.Trade_No + '-' + Settlement.Scrip_Cd = A.Trade_No  
 And Settlement.ContractNo = A.ContractNo  
 And S.ContractNo = A.ContractNo  
 And User_Id In ( Select UserId From TermParty )  
  
 Update Settlement set Ins_Chrg = 0   
 Where Settlement.Sauda_Date Like @Sauda_Date + '%'        
 And Settlement.Sett_Type = @Sett_Type  
 And Settlement.Party_Code >= @FromParty And Settlement.Party_Code <= @ToParty   
 And Settlement.AuctionPart Not in ('AP','AR','FP','FL','FA','FC')   
 And TradeQty > 0 And Trade_No Not Like '%C%'   
 And Branch_Id in ( Select Branch_Id From #AniSettRoundOrg A  
 Where Settlement.Sett_No = A.Sett_No  
 And Settlement.Sett_Type = A.Sett_Type  
 And Settlement.Branch_Id = A.Branch_Id  
 And TobeChrg = 0)  And User_Id In ( Select UserId From TermParty )  
  
 /* Rounding for 1 Rs. End Here with terminal mapping */  
  
 /* Rounding for 1 Rs. Start Here For Inst Trades */  
 Select ContractNo, Party_Code, Sett_No, Sett_Type, ActChrg = Sum(ActChrg),  
     TobeChrg = Round(Sum(TobeChrg),0) Into #AniISettRound From (   
 Select ContractNo, Party_Code, Sett_No, Sett_Type, Scrip_Cd, Series, ActChrg = Sum(Ins_Chrg),   
 TobeChrg = Sum(Ins_Chrg)   
 From ISettlement   
 Where ISettlement.Sauda_Date Like @Sauda_Date + '%'        
 And ISettlement.Sett_Type = @Sett_Type  
 And ISettlement.Party_Code >= @FromParty And ISettlement.Party_Code <= @ToParty   
 And ISettlement.AuctionPart Not in ('AP','AR','FP','FL','FA','FC')   
 And TradeQty > 0 And Trade_No Not Like '%C%'   
 Group By ContractNo, Party_Code, Sett_No, Sett_Type, Scrip_Cd, Series ) A  
 Group By ContractNo, Party_Code, Sett_No, Sett_Type  
   
 Select S.Sett_No, S.Sett_Type, S.ContractNo, S.Party_Code, Trade_No = Min(Trade_No+'-'+Scrip_Cd)   
 Into #ISettSTTParty From ISettlement S, #AniISettRound A   
 Where S.Sauda_Date Like @Sauda_Date + '%'        
 And S.Sett_Type = @Sett_Type  
 And S.Party_Code >= @FromParty And S.Party_Code <= @ToParty   
 And S.AuctionPart Not in ('AP','AR','FP','FL','FA','FC')   
 And TradeQty > 0 And S.Trade_No Not Like '%C%'   
 And A.Sett_Type = S.Sett_Type  
 And A.Sett_No = S.Sett_No  
 And A.Party_Code = S.Party_Code  
 And Ins_Chrg >= (Case When ToBeChrg-ActChrg < 0 Then abs(ToBeChrg-ActChrg) Else 0 End)  
  And Ins_Chrg > 0    
 And S.ContractNo = A.ContractNo  
 Group By S.Sett_No, S.Sett_Type, S.ContractNo, S.Party_Code  
   
 Update ISettlement Set Ins_Chrg = Ins_Chrg + (ToBeChrg-ActChrg)  
 From #ISettSTTParty A, #AniISettRound S  
 Where ISettlement.Sauda_Date Like @Sauda_Date + '%'        
 And ISettlement.Sett_Type = @Sett_Type  
 And ISettlement.Party_Code >= @FromParty And ISettlement.Party_Code <= @ToParty   
 And ISettlement.AuctionPart Not in ('AP','AR','FP','FL','FA','FC')   
 And TradeQty > 0 And ISettlement.Trade_No Not Like '%C%'   
 And ISettlement.Sett_No = A.Sett_No  
 And ISettlement.Sett_Type = A.Sett_Type  
 And ISettlement.Party_Code = A.Party_Code  
 And ISettlement.Sett_No = S.Sett_No  
 And ISettlement.Sett_Type = S.Sett_Type  
 And ISettlement.Party_Code = S.Party_Code  
 And ISettlement.Trade_No + '-' + ISettlement.Scrip_Cd = A.Trade_No  
 And ISettlement.ContractNo = S.ContractNo  
 And A.ContractNo = S.ContractNo  
  
 Update ISettlement set Ins_Chrg = 0   
 Where ISettlement.Sauda_Date Like @Sauda_Date + '%'        
 And ISettlement.Sett_Type = @Sett_Type  
 And ISettlement.Party_Code >= @FromParty And ISettlement.Party_Code <= @ToParty   
 And ISettlement.AuctionPart Not in ('AP','AR','FP','FL','FA','FC')   
 And TradeQty > 0 And Trade_No Not Like '%C%'   
 And Party_Code in ( Select Party_Code From #AniISettRound A  
 Where ISettlement.Sett_No = A.Sett_No  
 And ISettlement.Sett_Type = A.Sett_Type  
 And ISettlement.Party_Code = A.Party_Code  
 And TobeChrg = 0)  And User_Id Not In ( Select UserId From TermParty )  
  
 /* Rounding for 1 Rs. End Here For Inst Trades */  
   
 Exec STT_InsertData_Summary @Sett_Type, @Sauda_Date, @FromParty, @ToParty  
   
 Update Settlement Set Ins_Chrg = 0  
 From Client2 C   
 Where Settlement.Sauda_Date Like @Sauda_Date + '%'        
 And Settlement.Sett_Type = @Sett_Type  
 And Settlement.Party_Code >= @FromParty And Settlement.Party_Code <= @ToParty   
 And Settlement.AuctionPart Not in ('AP','AR','FP','FL','FA','FC')   
 And TradeQty > 0 And Trade_No Not Like '%C%'   
 And Settlement.Party_Code = C.Party_Code  
 And Insurance_Chrg = 0   
  
 Update ISettlement Set Ins_Chrg = 0  
 From Client2 C   
 Where ISettlement.Sauda_Date Like @Sauda_Date + '%'        
 And ISettlement.Sett_Type = @Sett_Type  
 And ISettlement.Party_Code >= @FromParty And ISettlement.Party_Code <= @ToParty   
 And ISettlement.AuctionPart Not in ('AP','AR','FP','FL','FA','FC')   
 And TradeQty > 0 And Trade_No Not Like '%C%'   
 And ISettlement.Party_Code = C.Party_Code  
 And Insurance_Chrg = 0   
End

GO
