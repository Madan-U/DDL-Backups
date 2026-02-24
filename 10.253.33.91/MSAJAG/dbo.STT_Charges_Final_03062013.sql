-- Object: PROCEDURE dbo.STT_Charges_Final_03062013
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Proc [dbo].[STT_Charges_Final_03062013]                             
(                            
 @Sett_Type Varchar(2),          
 @Sauda_Date Varchar(11),          
 @FromParty Varchar(10),          
 @ToParty Varchar(10),          
 @fContract Varchar(7) = '0',          
 @tContract Varchar(7) = '9999999',          
 @processOn Int = 0          
)                             
As                                
                            
Declare @Party_Code Varchar(10),                                
 @Amt Numeric(18,4),          
 @Trade_No Varchar(14),          
 @Order_No Varchar(16),          
 @TrdBuyTrans Numeric(18,4),          
 @TrdSellTrans Numeric(18,4),          
 @DelBuyTrans Numeric(18,4),          
 @DelSellTrans Numeric(18,4),          
 @SETTFLAG INT,          
 @ISETTFLAG INT,          
 @STTCur Cursor          
                      
SELECT @SETTFLAG = ISNULL(COUNT(1),0) FROM (               
SELECT TOP 1 * FROM SETTLEMENT              
WHERE SAUDA_DATE LIKE @SAUDA_DATE + '%' AND SETT_TYPE = @SETT_TYPE           
And auctionpart not in ('AP','AR','FP','FL','FA','FC')           
AND TRADE_NO NOT LIKE '%C%') A            
            
SELECT @ISETTFLAG = ISNULL(COUNT(1),0) FROM (               
SELECT TOP 1 * FROM ISETTLEMENT              
WHERE SAUDA_DATE LIKE @SAUDA_DATE + '%' AND SETT_TYPE = @SETT_TYPE AND TRADE_NO NOT LIKE '%C%') A            
            
IF @SETTFLAG = 1 OR @ISETTFLAG = 1             
BEGIN                          
Begin Tran                      
          
Select @TrdBuyTrans  = 0          
Select @TrdSellTrans = 0          
Select @DelSellTrans = 0          
Select @DelBuyTrans  = 0          
          
Truncate Table STT_AniSett_Temp                              
Truncate Table STT_AniISett_Temp                              
Truncate Table STT_AniSettOrg_Temp                              
Truncate Table STT_SettSTTOrg_Temp                              
          
Truncate Table STT_AniSettRound_Temp                              
Truncate Table STT_SettSTTParty_Temp                              
Truncate Table STT_AniSettRoundOrg_Temp                              
Truncate Table STT_SettSTTPartyOrg_Temp                              
          
Truncate Table STT_AniISettRound_Temp                              
Truncate Table STT_ISettSTTParty_Temp                               
          
Truncate Table STT_SETT_TABLE                            
Truncate Table STT_ISETT_TABLE                            
          
/* NOW GETTING GLOBAL VALUES */                              
          
Select                             
  @TrdBuyTrans = TrdBuyTrans,                             
  @TrdSellTrans = TrdSellTrans,                                 
  @DelBuyTrans = DelBuyTrans,                             
  @DelSellTrans = DelSellTrans                                 
 From                             
  Globals                                 
 Where                             
  year_start_dt <= @Sauda_Date                             
  And year_end_dt >= @Sauda_Date                                
                             
        
If (@TrdBuyTrans > 0 Or @TrdSellTrans > 0 Or @DelSellTrans > 0 Or @DelBuyTrans > 0 )                                
Begin                                
        
 SELECT @FROMPARTY = ISNULL(MIN(PARENTCODE), @FROMPARTY)        
 FROM CLIENT2        
 WHERE (PARTY_CODE >= @FROMPARTY AND PARTY_CODE <= @TOPARTY)        
 OR (PARENTCODE >= @FROMPARTY AND PARENTCODE <= @TOPARTY)        
        
 SELECT @TOPARTY = ISNULL(MAX(PARENTCODE), @TOPARTY)        
 FROM CLIENT2        
 WHERE (PARTY_CODE >= @FROMPARTY AND PARTY_CODE <= @TOPARTY)        
 OR (PARENTCODE >= @FROMPARTY AND PARENTCODE <= @TOPARTY)        
        
 TRUNCATE TABLE STT_SETTLEMENT        
        
    INSERT INTO STT_SETTLEMENT        
 SELECT SrNo,Contractno,Billno,Trade_No,PARENTCODE,Scrip_Cd,User_Id,        
    Tradeqty,Auctionpart,Markettype,Series,Order_No,Marketrate,Sauda_Date,        
    S.Table_No,Line_No,Val_Perc,Normal,Day_Puc,Day_Sales,Sett_Purch,Sett_Sales,Sell_Buy,        
    Settflag,Brokapplied,Netrate,Amount,Ins_Chrg,Turn_Tax,S.Other_Chrg,Sebi_Tax,Broker_Chrg,        
    Service_Tax,Trade_Amount,Billflag,Sett_No,Nbrokapp,Nsertax,N_Netrate,Sett_Type,Partipantcode,        
    Status,Pro_Cli,Cpid,Instrument,Booktype,Branch_Id,Tmark,Scheme,S.Dummy1,S.Dummy2        
 FROM SETTLEMENT S, CLIENT2 C2        
 WHERE            
 SAUDA_DATE LIKE @SAUDA_DATE + '%'                             
 AND S.PARTY_CODE = C2.PARTY_CODE        
 AND PARENTCODE BETWEEN @FROMPARTY AND @TOPARTY          
 AND CONTRACTNO BETWEEN @FCONTRACT AND @TCONTRACT                
 AND AUCTIONPART NOT IN ('AP','AR','FP','FL','FA','FC')                             
 AND SETT_TYPE = @SETT_TYPE                            
 AND TRADE_NO NOT LIKE '%C%'         
        
 EXEC RearrangeTrdflag_STT        
        
 Set Transaction Isolation level Read Uncommitted                            
 Insert Into STT_SETT_TABLE                            
 Select          
  Sauda_date,          
  ContractNo,          
  Trade_no,          
  Order_no,          
  sett_no,          
  sett_type,          
  Party_Code,          
  Scrip_Cd,          
  Series,          
  Sell_buy,          
  Tradeqty,          
  MarketRate,          
  AuctionPart,          
  User_id,          
  Settflag,          
  Ins_chrg = 0,          
  branch_id,          
  SRNO          
  from                             
   STT_SETTLEMENT WITH(INDEX(STT_INDEX),nolock)                            
  Where                               
   sauda_date like @Sauda_Date + '%'                             
   and Party_Code Between @FromParty And @ToParty          
   And ContractNo Between @fContract And @tContract                
   And auctionpart not in ('AP','AR','FP','FL','FA','FC')                             
   and sett_type = @sett_type                            
   AND TRADE_NO NOT LIKE '%C%'          
                            
  Set Transaction Isolation level Read Uncommitted                        
  Insert Into STT_ISETT_TABLE                            
  Select                             
                        Sauda_date,                             
                        ContractNo,                             
                   Trade_no,                             
                        Order_no,                             
                        sett_no,                             
                        sett_type,                             
           Party_Code,                             
    Scrip_Cd,                     
                        Series,                             
                        Sell_buy,                             
                        Tradeqty,                          
                        MarketRate,                             
                        AuctionPart,                             
                        User_id,                             
                        Settflag,                             
                        Ins_chrg = 0,                             
                        branch_id,          
   SRNO                            
  from                             
   ISettlement WITH(INDEX(STT_INDEX),nolock)                            
  Where                               
  sauda_date like @Sauda_Date + '%'                             
  AND Party_Code Between @FromParty AND @ToParty                
  And ContractNo Between @fContract And @tContract                
  And auctionpart not in ('AP','AR','FP','FL','FA','FC')                             
  and sett_type = @sett_type                            
  AND TRADE_NO NOT LIKE '%C%'          
                            
                            
    If Upper(LTrim(RTrim(@Sett_Type))) = 'N' Or Upper(LTrim(RTrim(@Sett_Type))) = 'D' Or Upper(LTrim(RTrim(@Sett_Type))) = 'H'                            
    Begin                                
                                 
    set transaction isolation level read uncommitted                            
    Insert Into STT_AniSett_Temp                              
    Select                             
     Sett_No,                             
     Sett_Type,                             
     ContractNo,                             
     Party_Code,                             
     Scrip_CD,                             
     Series,                                 
     TrdVal = Round(Sum(TradeQty*MarketRate)/Sum(TradeQty),4)                                
    From                             
    STT_SETT_TABLE WITH(INDEX(STT_INDEX),nolock)                          
    Where                             
     TradeQty > 0                                    
     -- And Trade_No Not Like '%C%'                              
     And User_Id Not In ( Select UserId From TermParty Where UserId = '')                                
    Group By                             
     Sett_No,                             
     Sett_Type,                             
     ContractNo,                             
     Party_Code,                             
     Scrip_CD,                             
     Series          
                            
                            
    Update STT_SETT_TABLE                            
  Set                             
     Ins_Chrg =   (Case  when STT_SETT_TABLE.settflag in (1,4,5)  then                              
         (Case When Sell_buy = 1                                
          Then Round(TradeQty * TrdVal * @DelBuyTrans / 100,4)                                
          Else Round(TradeQty * TrdVal * @DelSellTrans / 100,4)                                
         End)                                
       WHEN STT_SETT_TABLE.SettFlag In (2,3) AND STT_SETT_TABLE.Sell_buy = 2  THEN                              
         Round(TradeQty * TrdVal * @TrdSellTrans / 100,4)                                
       ELSE 0                              
       END)                              
    From                             
     STT_AniSett_Temp A                               
    Where                             
     STT_SETT_TABLE.Sett_No = A.Sett_No                               
     And STT_SETT_TABLE.Sett_Type = A.Sett_Type                                
     And STT_SETT_TABLE.Party_Code = A.Party_Code                               
     And STT_SETT_TABLE.Scrip_CD = A.Scrip_CD                                
     And STT_SETT_TABLE.SERIES = A.SERIES              
     And STT_SETT_TABLE.ContractNo = A.ContractNo                               
     -- And STT_SETT_TABLE.Trade_No Not Like '%C%'                                
     And STT_SETT_TABLE.User_Id Not In ( Select UserId From TermParty Where UserId = '')                                 
                                  
                            
    -- INS SETTLEMENT                         
                            
    set transaction isolation level read uncommitted                            
    Insert Into STT_AniISett_Temp                              
    Select                             
     Sett_No,                             
     Sett_Type,                             
     ContractNo,                             
     Party_Code,                             
     Scrip_CD,                            
     Series,                      
     TrdVal = Round(Sum(TradeQty*MarketRate)/Sum(TradeQty),4)                                
    From                             
    STT_ISETT_TABLE WITH(INDEX(STT_INDEX),nolock)                          
    Where                             
     TradeQty > 0                                    
     -- And Trade_No Not Like '%C%'                              
    Group By                             
     Sett_No,                             
     Sett_Type,                             
     ContractNo,                             
     Party_Code,                             
     Scrip_CD,                             
     Series                                
                            
                               
                        
                            
    Update STT_ISETT_TABLE                             
    Set                             
     Ins_Chrg =  (Case When Sell_buy = 1 Then Round(TradeQty * TrdVal * @DelBuyTrans / 100,4)                                
        Else Round(TradeQty * TrdVal * @DelSellTrans / 100,4)                                
       End)                                
    From STT_AniISett_Temp A                             
    Where                             
     STT_ISETT_TABLE.Sett_No = A.Sett_No                             
     And STT_ISETT_TABLE.Sett_Type = A.Sett_Type                                
     And STT_ISETT_TABLE.Party_Code = A.Party_Code                             
     And STT_ISETT_TABLE.Scrip_CD = A.Scrip_CD                                
     And STT_ISETT_TABLE.SERIES = A.SERIES              
     -- And STT_ISETT_TABLE.Trade_No Not Like '%C%'                                
     And STT_ISETT_TABLE.ContractNo = A.ContractNo                                
                        
                            
                                    
       /* For Terminal Mapping */                                
                                  
    Insert Into STT_AniSettOrg_Temp                              
    Select                             
     Sett_No,                             
     Sett_Type,                             
     ContractNo,                             
     Branch_id,                             
     Party_Code,                             
     Scrip_CD,                             
     Series,                                 
     TrdVal = IsNull(Round(Sum(TradeQty*MarketRate)/Sum(TradeQty),4),0),                                
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
    From                             
     STT_SETT_TABLE WITH(INDEX(STT_INDEX),nolock)                          
    Where                             
     TradeQty > 0                                 
     --AND Trade_No Not Like '%C%'                                     
     And User_Id In ( Select UserId From TermParty Where UserId = '')                                
    Group By Sett_No, Sett_Type, ContractNo, Branch_id, Party_Code, Scrip_CD, Series                                
                                       
                                  
                            
                            
    Update STT_AniSettOrg_Temp                             
    Set                             
     PSTTDEL  = Round(PQtyDel*TrdVal*@DelBuyTrans/100,4),                                
     SSTTDEL  = Round(SQtyDel*TrdVal*@DelSellTrans/100,4),                                 
     SSTTTRD  = Round(SQtyTrd*TrdVal*@TrdSellTrans/100,4),                                
     TotalTax = Round(PQtyDel*TrdVal*@DelBuyTrans/100,4)  +  Round(SQtyDel*TrdVal*@DelSellTrans/100,4) + Round(SQtyTrd*TrdVal*@TrdSellTrans/100,4)                                
                                          
    Insert Into STT_SettSTTOrg_Temp                                
    Select                             
     Sett_No,                             
     Sett_Type,                             
     ContractNo,                             
     Branch_id,                             
     Party_Code,                             
     Scrip_CD,                             
     Series,                             
     Trade_No = Min(SRNO)          
    From                          
     STT_SETT_TABLE WITH(INDEX(STT_INDEX),nolock)                          
    Where                             
     TradeQty > 0                                 
     -- And Trade_No Not Like '%C%'                                
     And User_Id In ( Select UserId From TermParty Where UserId = '')                                
    Group By Sett_No, Sett_Type, ContractNo, Branch_id, Party_Code, Scrip_CD, Series                                
                                       
                            
                            
    Update STT_SETT_TABLE                            
    Set                             
     Ins_Chrg = TotalTax                                 
    From                             
     STT_AniSettOrg_Temp S,                             
     STT_SettSttOrg_Temp A                                
    Where                             
    STT_SETT_TABLE.Sett_No = S.Sett_No                                
    And STT_SETT_TABLE.Sett_Type = S.Sett_Type                                
    And STT_SETT_TABLE.Scrip_Cd = S.Scrip_CD                                
    And STT_SETT_TABLE.Series = S.Series                                
    And STT_SETT_TABLE.Branch_id = S.Branch_id                  
    And STT_SETT_TABLE.Sett_No = A.Sett_No                  
    And STT_SETT_TABLE.Sett_Type = A.Sett_Type                                
    And STT_SETT_TABLE.Scrip_Cd = A.Scrip_CD                                
    And STT_SETT_TABLE.Series = A.Series                                
    And STT_SETT_TABLE.Branch_id = A.Branch_Id                                
    -- And STT_SETT_TABLE.Trade_No Not Like '%C%'                         
    And STT_SETT_TABLE.SRNO = A.Trade_No                                
    And STT_SETT_TABLE.ContractNo = A.ContractNo                                
    And User_Id In ( Select UserId From TermParty Where UserId = '')                                
                                   
    End                                
                                  
                            
    If Upper(LTrim(RTrim(@Sett_Type))) = 'A' Or Upper(LTrim(RTrim(@Sett_Type))) = 'W' Or Upper(LTrim(RTrim(@Sett_Type))) = 'AD' Or Upper(LTrim(RTrim(@Sett_Type))) = 'C'                                  
     Begin                                
                            
    Update STT_SETT_TABLE                             
    Set                             
     Ins_Chrg =  (Case When Sell_buy = 1                                 
        Then Round(TradeQty * MarketRate * @DelBuyTrans / 100,4)                                
        Else Round(TradeQty * MarketRate * @DelSellTrans / 100,4)                                
       End)                                
    Where                             
     TradeQty > 0                             
     --And Trade_No Not Like '%C%'                            
                            
                   
                            
                                 
    Update STT_ISETT_TABLE                            
    Set                             
     Ins_Chrg =  (Case When Sell_buy = 1                                 
        Then Round(TradeQty * MarketRate * @DelBuyTrans / 100, 4)                                
        Else Round(TradeQty * MarketRate * @DelSellTrans / 100, 4)                                
       End)                                
    Where                             
     TradeQty > 0                             
     -- And Trade_No Not Like '%C%'                            
                                
                                
     End                                
                                
                                
                                   
   Update STT_SETT_TABLE                             
   Set                             
    Ins_chrg = 0                             
   Where                             
    TradeQty > 0                             
    --And Trade_No Not Like '%C%'                                
    And User_Id Not In ( Select UserId From TermParty Where UserId = '')                                
    And                               
    (                             
     ( Scrip_Cd in (SELECT SCRIP_CD FROM TBL_STT_SCRIP WHERE @SAUDA_DATE BETWEEN DATEFROM AND DATETO))            
    OR                              
     ( Left(Series,1) Not In ('E','B','I','X','L','S') )                              
    )                              
                            
                                   
                                
   Update STT_ISETT_TABLE                             
   Set                             
    Ins_chrg = 0                             
   Where                        
    TradeQty > 0                             
    -- And Trade_No Not Like '%C%'                                
    And User_Id Not In ( Select UserId From TermParty Where UserId = '')                                
    And                               
    (                             
     ( Scrip_Cd in (SELECT SCRIP_CD FROM TBL_STT_SCRIP WHERE @SAUDA_DATE BETWEEN DATEFROM AND DATETO))            
    OR                              
     (Left(Series,1) Not In ('E','B','I','X','L','S') )                              
    )     
                                  
                                
   Exec STT_InsertData_Detail @Sett_Type, @Sauda_Date, @FromParty, @ToParty                                
                                  
                                
                                    
  If Upper(LTrim(RTrim(@Sett_Type))) = 'N' Or Upper(LTrim(RTrim(@Sett_Type))) = 'D' Or Upper(LTrim(RTrim(@Sett_Type))) = 'H'    
  Begin                                 
                              
   Update STT_AniSettOrg_Temp                             
   Set TotalTax = 0                             
   Where                               
     ( Scrip_Cd in (SELECT SCRIP_CD FROM TBL_STT_SCRIP WHERE @SAUDA_DATE BETWEEN DATEFROM AND DATETO))            
    OR                              
    ( Left(Series,1) Not In ('E','B','I','X','L','S') )                     
                              
                              
   Insert Into STT_ClientDetail                                
   Select                             
    30,                             
    Sett_no,                             
    Sett_Type,                             
    ContractNo,                         Party_Code,              
    Scrip_Cd,                             
    Series,                             
    Sauda_Date=@Sauda_Date,                      
    Branch_Id,                                
    TrdVal,                             
    PQtyDel,                             
    PQtyDel * TrdVal,                             
    PSttDel,                                
    TrdVal,                             
    SQtyDel,                             
    SQtyDel * TrdVal,                             
    SSttDel,                                
    TrdVal,                             
    SQtyTrd,                             
    SQtyTrd * TrdVal,                             
    SSttTrd,                                
    TotalTax                             
   From                             
    STT_AniSettOrg_Temp                        
  End                                
                                  
                            
                            
/* Rounding for 1 Rs. Start with out terminal mapping */                                
                            
  Insert Into STT_AniSettRound_Temp                               
  Select                             
   ContractNo,                             
   Party_Code,                             
   Sett_No,                             
   Sett_Type,                           
   ActChrg = Sum(ActChrg),                                
   TobeChrg = Round(Sum(TobeChrg),0)                             
  From                             
   (                                
    Select                             
     ContractNo,                             
     Party_Code,                             
     Sett_No,                             
     Sett_Type,                             
     Scrip_Cd,                             
     Series,                             
     ActChrg = Sum(Ins_Chrg),                                 
     TobeChrg = Sum(Ins_Chrg)          
    From                             
     STT_SETT_TABLE WITH(INDEX(STT_INDEX),nolock)                          
    Where                             
     TradeQty > 0                             
     --And Trade_No Not Like '%C%'                                
     And User_Id Not In ( Select UserId From TermParty Where UserId = '')                                
    Group By ContractNo, Party_Code, Sett_No, Sett_Type, Scrip_Cd, Series                             
   ) A                                
  Group By ContractNo, Party_Code, Sett_No, Sett_Type                                
                                      
                                 
  Insert Into STT_SettSTTParty_Temp                               
  Select                             
   S.Sett_No,                             
   S.Sett_Type,                      
   S.ContractNo,                 
   S.Party_Code,                             
   Trade_No = Min(SRNO)                                 
  From                             
   STT_SETT_TABLE s WITH(INDEX(STT_INDEX),nolock),                             
   STT_AniSettRound_Temp A  (nolock)                               
  Where                             
   TradeQty > 0                             
   -- And Trade_No Not Like '%C%'                                 
   And A.Sett_Type = S.Sett_Type                                
   And A.Sett_No = S.Sett_No                                
   And A.Party_Code = S.Party_Code                                
   And Ins_Chrg >= (Case When ToBeChrg-ActChrg < 0 Then abs(ToBeChrg-ActChrg) Else 0 End)                                
   And Ins_Chrg > 0                                  
   And S.ContractNo = A.ContractNo                                
   And S.ContractNo = A.ContractNo                                
   --And User_Id Not In ( Select UserId From TermParty Where UserId = '')---commited by suresh                                
  Group By S.Sett_No, S.Sett_Type, S.ContractNo, S.Party_Code                                
                                    
                            
  Update STT_SETT_TABLE                              
  Set                             
   Ins_Chrg = Ins_Chrg + (ToBeChrg-ActChrg)                                
  From                             
   STT_SettSTTParty_Temp A (nolock),                             
   STT_AniSettRound_Temp S (nolock)                               
  Where                             
   STT_SETT_TABLE.TradeQty > 0                             
   And STT_SETT_TABLE.Sett_No = A.Sett_No                                
   And STT_SETT_TABLE.Sett_Type = A.Sett_Type                                
   And STT_SETT_TABLE.Party_Code = A.Party_Code                                
   And STT_SETT_TABLE.Sett_No = S.Sett_No             
   And STT_SETT_TABLE.Sett_Type = S.Sett_Type                                
   And STT_SETT_TABLE.Party_Code = S.Party_Code                                
   And STT_SETT_TABLE.SRNO = A.Trade_No                                
   And STT_SETT_TABLE.ContractNo = A.ContractNo                                
   And S.ContractNo = A.ContractNo                                
   And User_Id Not In ( Select UserId From TermParty Where UserId = '')                                
                              
                            
                                   
   Update STT_SETT_TABLE                             
   set                             
    Ins_Chrg = 0                                 
   Where                             
    TradeQty > 0                             
    --And Trade_No Not Like '%C%'                                 
    And Party_Code in                             
    (                             
     Select                             
      Party_Code                             
     From                             
      STT_AniSettRound_Temp A                                
     Where                             
      STT_SETT_TABLE.Sett_No = A.Sett_No                                
      And STT_SETT_TABLE.Sett_Type = A.Sett_Type                                
      And STT_SETT_TABLE.Party_Code = A.Party_Code                                
      And STT_SETT_TABLE.ContractNo = A.ContractNo                                
      And TobeChrg = 0                            
    )                              
    And User_Id Not In ( Select UserId From TermParty Where UserId = '')                        
                      
     /* Rounding for 1 Rs. End Normal Clients with out terminal mapping*/                                
                                   
                            
                            
    /* Rounding for 1 Rs. Start Here with terminal mapping */                                
                                 
  Insert Into STT_AniSettRoundOrg_Temp                                
  Select                             
   ContractNo,                             
   Branch_Id,                             
   Party_Code,                             
   Sett_No,                             
   Sett_Type,                             
   ActChrg = Sum(ActChrg),                                 
   TobeChrg = Round(Sum(TobeChrg),0)                             
  From                             
   (                                
    Select                             
 ContractNo,                             
     Branch_Id,                             
     Party_Code,                             
     Sett_No,                             
     Sett_Type,                             
     Scrip_Cd,                             
     Series,                             
     ActChrg = Sum(Ins_Chrg),                                 
     TobeChrg = Sum(Ins_Chrg)                                
    From                             
     STT_SETT_TABLE WITH(INDEX(STT_INDEX),nolock)                          
    Where                             
     TradeQty > 0                             
     --And Trade_No Not Like '%C%'                                 
     And User_Id In ( Select UserId From TermParty Where UserId = '')                                
    Group By ContractNo, Branch_Id, Party_Code, Sett_No, Sett_Type, Scrip_Cd, Series                             
   ) A                                
  Group BY ContractNo, Branch_Id, Party_Code, Sett_No, Sett_Type                                
                                 
                            
                            
  Insert  Into STT_SettSTTPartyOrg_Temp                                 
  Select                             
   S.Sett_No,                             
   S.Sett_Type,                             
   S.ContractNo,                             
   S.Branch_Id,                             
   S.Party_Code,                             
   Trade_No = Min(SRNO)                                 
  From                             
   STT_SETT_TABLE S (nolock),                             
   STT_AniSettRoundOrg_Temp A                                 
  Where                             
   s.TradeQty > 0                             
   -- And Trade_No Not Like '%C%'                                 
   And A.Sett_Type = S.Sett_Type                                
   And A.Sett_No = S.Sett_No                                
   And A.Branch_Id = S.Branch_Id                                
   And Ins_Chrg >= (Case When ToBeChrg-ActChrg < 0 Then abs(ToBeChrg-ActChrg) Else 0 End)                                
   And Ins_Chrg > 0                     
   And S.ContractNo = A.ContractNo                                
   And User_Id In ( Select UserId From TermParty Where UserId = '')                                
  Group By S.Sett_No, S.Sett_Type, S.ContractNo, S.Branch_Id, S.Party_Code                                 
                            
                            
                            
                                    
  Update STT_SETT_TABLE                             
  Set                             
   Ins_Chrg = Ins_Chrg + (ToBeChrg-ActChrg)                                
  From                             
   STT_SettSTTPartyOrg_Temp A,                             
   STT_AniSettRoundOrg_Temp S                                
  Where                             
   STT_SETT_TABLE.TradeQty > 0                             
   --And STT_SETT_TABLE.Trade_No Not Like '%C%'                                 
   And STT_SETT_TABLE.Sett_No = A.Sett_No                                
   And STT_SETT_TABLE.Sett_Type = A.Sett_Type                                
   And STT_SETT_TABLE.Branch_id = A.Branch_Id                                
  -- And STT_SETT_TABLE.Sett_No = S.Sett_No   ----commited by suresh                             
  -- And STT_SETT_TABLE.Sett_Type = S.Sett_Type  ----commited by suresh                                        
  -- And STT_SETT_TABLE.Branch_id = S.Branch_Id  ----commited by suresh                                         
   And STT_SETT_TABLE.SRNO = A.Trade_No                                
   And STT_SETT_TABLE.ContractNo = A.ContractNo                                
   --And S.ContractNo = A.ContractNo                                
  -- And User_Id In ( Select UserId From TermParty Where UserId = '')   ----commited by suresh                                       
                                   
                            
   Update STT_SETT_TABLE                            
   set                             
    Ins_Chrg = 0                                 
   Where                             
    TradeQty > 0                             
    --And Trade_No Not Like '%C%'                                 
    And Branch_Id in                             
     (                             
      Select                             
       Branch_Id                             
      From                             
       STT_AniSettRoundOrg_Temp A                                
      Where                             
       STT_SETT_TABLE.Sett_No = A.Sett_No                                
       And STT_SETT_TABLE.Sett_Type = A.Sett_Type                                
       And STT_SETT_TABLE.Branch_Id = A.Branch_Id                                
       And STT_SETT_TABLE.ContractNo = A.ContractNo                                
       And TobeChrg = 0                            
     )                              
   And User_Id In ( Select UserId From TermParty Where UserId = '')                                
                                   
                            
    /* Rounding for 1 Rs. End Here with terminal mapping */                                
                                   
                            
                            
                            
                            
                            
                            
    /* Rounding for 1 Rs. Start Here For Inst Trades */                                
                                   
  Insert Into STT_AniISettRound_Temp                              
  Select                             
   ContractNo,                             
   Party_Code,                             
   Sett_No,                             
   Sett_Type,                             
   ActChrg = Sum(ActChrg),                                
   TobeChrg = Round(Sum(round(TobeChrg,2)),0)                             
  From                             
   (                                 
    Select                             
     ContractNo,                             
     Party_Code,                             
     Sett_No,                             
     Sett_Type,                             
     Scrip_Cd,                             
     Series,                         
     ActChrg = Sum(Ins_Chrg),                                 
     TobeChrg = Sum(Ins_Chrg)                                 
    From                             
     STT_ISETT_TABLE WITH(INDEX(STT_INDEX),nolock)                          
    Where                             
     TradeQty > 0                             
     --And Trade_No Not Like '%C%'                                 
    Group By ContractNo, Party_Code, Sett_No, Sett_Type, Scrip_Cd, Series                             
   ) A                                
  Group By ContractNo, Party_Code, Sett_No, Sett_Type                                
                            
                            
                  
  Insert  Into STT_ISettSTTParty_Temp                               
  Select                             
   S.Sett_No,                             
   S.Sett_Type,                             
   S.ContractNo,                             
   S.Party_Code,                             
   Trade_No = Min(SRNO)                                 
  From                             
   STT_ISETT_TABLE S WITH(INDEX(STT_INDEX),nolock),                             
   STT_AniISettRound_Temp A                                 
  Where                             
   TradeQty > 0                             
   --And S.Trade_No Not Like '%C%'                    
   And A.Sett_Type = S.Sett_Type                                
   And A.Sett_No = S.Sett_No                                
   And A.Party_Code = S.Party_Code                                
   And Ins_Chrg >= (Case When ToBeChrg-ActChrg < 0 Then abs(ToBeChrg-ActChrg) Else 0 End)                                
   And Ins_Chrg > 0                                  
   And S.ContractNo = A.ContractNo                                
  Group By S.Sett_No, S.Sett_Type, S.ContractNo, S.Party_Code                            
                                    
                  
                            
  Update STT_ISETT_TABLE                            
  Set                             
   Ins_Chrg = Ins_Chrg + (ToBeChrg-ActChrg)                                
  From                             
   STT_ISettSTTParty_Temp A,                             
   STT_AniISettRound_Temp S                                
  Where                             
   TradeQty > 0                             
   --And STT_ISETT_TABLE.Trade_No Not Like '%C%'                                 
   And STT_ISETT_TABLE.Sett_No = A.Sett_No                                
   And STT_ISETT_TABLE.Sett_Type = A.Sett_Type                                
   And STT_ISETT_TABLE.Party_Code = A.Party_Code                                
   And STT_ISETT_TABLE.Sett_No = S.Sett_No                                
   And STT_ISETT_TABLE.Sett_Type = S.Sett_Type                                
   And STT_ISETT_TABLE.Party_Code = S.Party_Code                                
   And STT_ISETT_TABLE.SRNO = A.Trade_No                                
   And STT_ISETT_TABLE.ContractNo = S.ContractNo                                
   And A.ContractNo = S.ContractNo                                
                                   
                            
                            
  Update STT_ISETT_TABLE                             
  set                             
   Ins_Chrg = 0                                 
  Where                             
   TradeQty > 0                             
   --And Trade_No Not Like '%C%'                                 
   And Party_Code in                             
    (                             
     Select                             
      Party_Code                             
     From                             
      STT_AniISettRound_Temp A                                
     Where                             
      STT_ISETT_TABLE.Sett_No = A.Sett_No                                
      And STT_ISETT_TABLE.Sett_Type = A.Sett_Type                                
      And STT_ISETT_TABLE.Party_Code = A.Party_Code                                
      And STT_ISETT_TABLE.ContractNo = A.ContractNo                                
      And TobeChrg = 0                            
    )                              
   And User_Id Not In ( Select UserId From TermParty Where UserId = '')                                
                                   
                            
    EXEC Stt_rounding_further @Sett_Type, @Sauda_Date, @FromParty, @ToParty             
                            
    /* Rounding for 1 Rs. End Here For Inst Trades */                                
   Exec STT_InsertData_Summary @Sett_Type, @Sauda_Date, @FromParty, @ToParty                                
                           
                           
  Update STT_SETT_TABLE                            
Set                             
   Ins_Chrg = 0                                    
  From                             
   ClientTaxes_New C                                     
  Where                             
   TradeQty > 0                             
   And STT_SETT_TABLE.Party_Code = C.Party_Code                             
   And STT_SETT_TABLE.Sauda_Date BetWeen FromDate And ToDate                
   And Insurance_Chrg = 0                                     
        
  Update STT_ISETT_TABLE                            
  Set                             
Ins_Chrg = 0                                    
  From                       
   ClientTaxes_New C                                     
  Where                             
   TradeQty > 0                             
   And STT_ISETT_TABLE.Party_Code = C.Party_Code                                    
   And STT_ISETT_TABLE.Sauda_Date BetWeen FromDate And ToDate                                    
   And Insurance_Chrg = 0                                     
        
  /* NOW FINAL UPDATE IN SETTLEMENT TABLE*/                            
   Update STT_SETTLEMENT                             
   Set                             
    Ins_Chrg = A.INS_CHRG                            
   From                             
    STT_SETT_TABLE A WITH(INDEX(STT_INDEX),nolock)                            
   Where                             
    STT_SETTLEMENT.SRNO = A.SRNO         
        
   UPDATE SETTLEMENT SET INS_CHRG = A.INS_CHRG        
   FROM (SELECT ORGSRNO, INS_CHRG = SUM(INS_CHRG)        
   FROM STT_SETTLEMENT        
   GROUP BY ORGSRNO) A        
   WHERE SETTLEMENT.SRNO = A.ORGSRNO        
                             
   Update ISettlement                             
   Set                             
    Ins_Chrg = A.INS_CHRG                            
   From                             
    STT_ISETT_TABLE A    WITH(INDEX(STT_INDEX),nolock)                          
   Where                             
    ISettlement.SRNO = A.SRNO                               
                            
  /* PROCEDURE ENDS */                            
                            
  TRUNCATE TABLE STT_SETT_TABLE                            
  TRUNCATE TABLE STT_ISETT_TABLE                            
                
                            
End         
                           
EXEC PROC_TURNTAX_EXCEPTION @SETT_TYPE, @SAUDA_DATE --add by umesh                   
EXEC PROC_SERVICE_TAX_UPDATE @Sett_Type, @Sauda_Date, @FromParty, @ToParty        
EXEC CALCULATE_STAMP_DUTY  @SETT_TYPE, @SAUDA_DATE, @FROMPARTY, @TOPARTY                 
Commit            
end

GO
