-- Object: PROCEDURE dbo.NBFC_RearrangeFlag
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Procedure [dbo].[NBFC_RearrangeFlag] (@Sauda_Date Varchar(11), @FORPARTY VARCHAR(10) = '%') As
          
Declare @PrevDate Varchar(11),            
@Party_Code Varchar(10),            
@Scrip_Cd Varchar(12),            
@BseCode Varchar(6),
@Series Varchar(3),            
@PQty Int,            
@SQty Int,            
@PDiff Int,            
@TrdQty Int,            
@SettCur Cursor,            
@Sno Numeric,            
@SettRec Cursor            
  
Update MSAJAG.DBO.Settlement Set AuctionPart = 'N'  
From Nodel N           
Where MSAJAG.DBO.Settlement.scrip_cd = N.scrip_cd          
And  MSAJAG.DBO.Settlement.series = N.series            
And  MSAJAG.DBO.Settlement.sauda_date Between N.start_date And N.end_date          
And  MSAJAG.DBO.Settlement.sett_type = N.sett_type           
And  MSAJAG.DBO.Settlement.sauda_date Like @sauda_date + '%'  
And Party_Code Like @FORPARTY

Select @PrevDate = IsNull(Max(MarginDate), 'Apr  1 2004') From NBFC_TRANS             
Where MarginDate < @Sauda_Date            
            
Truncate Table NBFC_TRANS_PROCESS    
   
Insert into NBFC_TRANS_PROCESS    
SELECT Exchange='NSE',MarginDate=@Sauda_Date,TradeType='BT',sett_no,sett_type,Party_Code,Scrip_Cd,Series,
BSECODE='',User_id,ContractNo,Order_no,Trade_no,Sauda_date,Tradeqty,
MarketRate = (Case When Sell_Buy = 1         
                   Then N_NetRate +         
                       (Case When ( Ins_chrg + turn_tax + other_chrg + sebi_tax + Broker_chrg + NSerTax ) > 0         
                             Then Round(( Ins_chrg + turn_tax + other_chrg + sebi_tax + Broker_chrg + NSerTax ) / TradeQty , 4)        
        Else 0         
                        End)        
                   Else N_NetRate -         
                       (Case When ( Ins_chrg + turn_tax + other_chrg + sebi_tax + Broker_chrg + NSerTax ) > 0         
                             Then Round(( Ins_chrg + turn_tax + other_chrg + sebi_tax + Broker_chrg + NSerTax ) / TradeQty , 4)        
        Else 0         
                        End)        
              End),
AuctionPart,MarketType,Sell_buy,Ins_chrg,turn_tax,other_chrg,
sebi_tax,Broker_chrg,
Billflag,NBrokApp,NSerTax,N_NetRate,Partipantcode,CpId
From MSAJAG.DBO.Settlement with(index(stt_index), nolock)          
Where Left(Convert(Varchar,Sauda_Date,109),11) = @Sauda_Date And AuctionPart = 'MF'             
And TradeQty > 0
And Party_Code Like @FORPARTY

UPDATE NBFC_TRANS_PROCESS SET BSECODE = B.SCRIP_CD
FROM MSAJAG.DBO.MULTIISIN N, BSEDB.DBO.MULTIISIN B
WHERE N.ISIN = B.ISIN AND N.VALID = 1 AND B.VALID = 1 
AND N.SCRIP_CD = NBFC_TRANS_PROCESS.SCRIP_CD
AND N.SERIES = NBFC_TRANS_PROCESS.SERIES
AND EXCHANGE = 'NSE'

Insert into NBFC_TRANS_PROCESS    
SELECT Exchange='BSE',MarginDate=@Sauda_Date,TradeType='BT',sett_no,sett_type,Party_Code,Scrip_Cd='',Series='',
BSECODE=SCRIP_CD,User_id,ContractNo,Order_no,Trade_no,Sauda_date,Tradeqty,
MarketRate = (Case When Sell_Buy = 1         
                   Then N_NetRate +         
                       (Case When ( Ins_chrg + turn_tax + other_chrg + sebi_tax + Broker_chrg + NSerTax ) > 0         
                             Then Round(( Ins_chrg + turn_tax + other_chrg + sebi_tax + Broker_chrg + NSerTax ) / TradeQty , 4)        
        Else 0         
                        End)        
                   Else N_NetRate -         
                       (Case When ( Ins_chrg + turn_tax + other_chrg + sebi_tax + Broker_chrg + NSerTax ) > 0         
                             Then Round(( Ins_chrg + turn_tax + other_chrg + sebi_tax + Broker_chrg + NSerTax ) / TradeQty , 4)        
        Else 0         
                        End)        
              End),
AuctionPart,MarketType,Sell_buy,Ins_chrg,turn_tax,other_chrg,
sebi_tax,Broker_chrg,
Billflag,NBrokApp,NSerTax,N_NetRate,Partipantcode,CpId
From MSAJAG.DBO.Settlement with(index(stt_index), nolock)          
Where Left(Convert(Varchar,Sauda_Date,109),11) = @Sauda_Date And AuctionPart = 'MF'             
And TradeQty > 0 AND TRADE_NO NOT LIKE '%C%'
And Party_Code Like @FORPARTY

UPDATE NBFC_TRANS_PROCESS SET SCRIP_CD = N.SCRIP_CD, SERIES = N.SERIES
FROM MSAJAG.DBO.MULTIISIN N, BSEDB.DBO.MULTIISIN B
WHERE N.ISIN = B.ISIN AND N.VALID = 1 AND B.VALID = 1 
AND B.SCRIP_CD = NBFC_TRANS_PROCESS.BSECODE
AND EXCHANGE = 'BSE'

Insert into NBFC_TRANS_PROCESS    
SELECT Exchange,MarginDate=@Sauda_Date,TradeType='NA',sett_no,sett_type,Party_Code,Scrip_Cd,Series,BSECODE,
User_id,ContractNo,Order_no,Trade_no,Sauda_date,Tradeqty,MarketRate,AuctionPart,MarketType,
Sell_buy,Ins_chrg,turn_tax,other_chrg,sebi_tax,Broker_chrg,
BillFlag = (Case When Sell_Buy = 1 Then 4 Else 5 End),
NBrokApp,NSerTax,N_NetRate,Partipantcode,CpId
FROM NBFC_TRANS
Where Left(Convert(Varchar,MarginDate,109),11) = @PrevDate And BillFlag > 3             

Select Party_Code, Scrip_Cd, Series, BseCode, 
PQty = IsNull(Sum(Case When Sell_Buy = 1 Then TradeQty Else 0 End), 0),            
SQty = IsNull(Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End), 0) 
INTO #NBFC_SALEREVERSAL From NBFC_TRANS_PROCESS  
Where Left(Convert(Varchar,MarginDate,109),11) = @Sauda_Date       
And BillFlag Between '4' And '5'      
Group By Party_Code, Scrip_Cd, Series, BseCode
HAVING IsNull(Sum(Case When Sell_Buy = 2 Then TradeQty Else -TRADEQTY End), 0) > 0
Order By Party_Code, Scrip_Cd, Series, BseCode

Select Party_Code, Scrip_Cd, Series, BSECODE, 
PQty = IsNull(Sum(Case When Sell_Buy = 1 Then TradeQty Else 0 End), 0),            
SQty = IsNull(Sum(Case When Sell_Buy = 2 Then TradeQty Else 0 End), 0) 
INTO #NBFC_REARRANGE From NBFC_TRANS_PROCESS  
Where Left(Convert(Varchar,MarginDate,109),11) = @Sauda_Date       
And BillFlag Between '4' And '5'      
Group By Party_Code, Scrip_Cd, Series, BSECODE           
Order By Party_Code, Scrip_Cd, Series, BSECODE
    
Update NBFC_TRANS_PROCESS Set BillFlag = 2,            
TradeType = (Case When TradeType = 'NA' Then 'BF' Else TradeType End)            
From #NBFC_REARRANGE S (nolock)          
Where left(convert(varchar,MarginDate,109),11) = @Sauda_Date           
And S.Party_Code = NBFC_TRANS_PROCESS.Party_Code            
And S.Scrip_Cd = NBFC_TRANS_PROCESS.Scrip_Cd
And S.Series = NBFC_TRANS_PROCESS.Series            
And S.BseCode = NBFC_TRANS_PROCESS.BseCode
And PQty <= SQty And PQty > 0             
And NBFC_TRANS_PROCESS.Sell_Buy = 1            
And BillFlag = 4        
    
Update NBFC_TRANS_PROCESS Set BillFlag = 3,            
TradeType = (Case When TradeType = 'NA' Then 'BF' Else TradeType End)            
From #NBFC_REARRANGE S (nolock)            
Where left(convert(varchar,MarginDate,109),11) = @Sauda_Date           
And S.Party_Code = NBFC_TRANS_PROCESS.Party_Code            
And S.Scrip_Cd = NBFC_TRANS_PROCESS.Scrip_Cd            
And S.Series = NBFC_TRANS_PROCESS.Series       
And S.BseCode = NBFC_TRANS_PROCESS.BseCode     
And PQty >= SQty And SQty > 0             
And NBFC_TRANS_PROCESS.Sell_Buy = 2            
And BillFlag = 5        
           
Set @SettCur = Cursor For            
Select * From #NBFC_REARRANGE  (nolock)           
Where PQty > 0 And SQty > 0  And PQty <> SQty        
Order By Party_Code, Scrip_Cd, Series, BseCode            
Open @SettCur            
Fetch Next From @SettCur Into @Party_Code, @Scrip_Cd, @Series, @BseCode, @PQty, @SQty             
While @@Fetch_Status = 0             
Begin            
 If @PQty > @SQty             
 Begin            
  Select @PDiff = @SQty             
  Set @SettRec = Cursor For              
  Select Sno, TradeQty From NBFC_TRANS_PROCESS  (nolock)           
  Where left(convert(varchar,MarginDate,109),11) = @Sauda_Date           
  And Party_Code = @Party_Code            
  And Scrip_Cd = @Scrip_Cd            
  And Series = @Series
  And BseCode = @BseCode            
  And Sell_Buy = 1            
  And BillFlag = 4        
  Order By EXCHANGE DESC, Sauda_Date            
  Open @SettRec            
  Fetch Next From @SettRec Into @Sno, @TrdQty             
  While @PDiff > 0             
  Begin            
   If @PDiff >= @TrdQty            
   Begin            
    Update NBFC_TRANS_PROCESS Set BillFlag = 2,             
    TradeType = (Case When TradeType = 'NA' Then 'BF' Else TradeType End)             
    Where Sno = @Sno            
    Select @PDiff = @PDiff - @TrdQty             
   End            
   Else            
   Begin            
    Insert into NBFC_TRANS_PROCESS             
    SELECT Exchange,MarginDate,TradeType,sett_no,sett_type,Party_Code,Scrip_Cd,Series,BSECODE,
    User_id,ContractNo,Order_no,Trade_no,Sauda_date,Tradeqty=@TrdQty-@PDiff,MarketRate,AuctionPart,
    MarketType,Sell_buy,Ins_chrg,turn_tax,other_chrg,sebi_tax,
    Broker_chrg,Billflag,NBrokApp,NSerTax,N_NetRate,Partipantcode,CpId
    From NBFC_TRANS_PROCESS  (nolock)          
    Where Sno = @Sno     
            
    Update NBFC_TRANS_PROCESS Set BillFlag = 2,            
    TradeType = (Case When TradeType = 'NA' Then 'BF' Else TradeType End),            
    TradeQty = @PDiff            
    Where Sno = @Sno            
          
    Select @PDiff = 0            
   End            
   Fetch Next From @SettRec Into @Sno, @TrdQty            
  End            
  Close @SettRec            
  DeAllocate @SettRec            
 End            
 Else            
 Begin            
  Select @PDiff = @PQty             
  Set @SettRec = Cursor For              
  Select Sno, TradeQty From NBFC_TRANS_PROCESS            
  Where left(convert(varchar,MarginDate,109),11) = @Sauda_Date           
  And Party_Code = @Party_Code            
  And Scrip_Cd = @Scrip_Cd            
  And Series = @Series
  And BseCode = @BseCode                        
  And Sell_Buy = 2            
  And BillFlag = 5        
  Order By EXCHANGE DESC, Sauda_Date     
  Open @SettRec            
  Fetch Next From @SettRec Into @Sno, @TrdQty             
  While @PDiff > 0             
  Begin            
   If @PDiff >= @TrdQty            
   Begin            
    Update NBFC_TRANS_PROCESS Set BillFlag = 3,             
    TradeType = (Case When TradeType = 'NA' Then 'BF' Else TradeType End)             
    Where Sno = @Sno            
    Select @PDiff = @PDiff - @TrdQty             
   End            
   Else            
   Begin            

    Insert into NBFC_TRANS_PROCESS             
    SELECT Exchange,MarginDate,TradeType,sett_no,sett_type,Party_Code,Scrip_Cd,Series,BSECODE,
    User_id,ContractNo,Order_no,Trade_no,Sauda_date,Tradeqty=@TrdQty-@PDiff,MarketRate,AuctionPart,
    MarketType,Sell_buy,Ins_chrg,turn_tax,other_chrg,sebi_tax,
    Broker_chrg,Billflag,NBrokApp,NSerTax,N_NetRate,Partipantcode,CpId
    From NBFC_TRANS_PROCESS  (nolock)          
    Where Sno = @Sno   

    Update NBFC_TRANS_PROCESS Set BillFlag = 3,            
    TradeType = (Case When TradeType = 'NA' Then 'BF' Else TradeType End),            
    TradeQty = @PDiff            
    Where Sno = @Sno            
              
    Select @PDiff = 0            
   End            
   Fetch Next From @SettRec Into @Sno, @TrdQty            
  End            
  Close @SettRec            
  DeAllocate @SettRec            
 End            
 Fetch Next From @SettCur Into @Party_Code, @Scrip_Cd, @Series, @BseCode, @PQty, @SQty             
End            
Close @SettCur            
DeAllocate @SettCur        

Delete FROM NBFC_TRANS Where left(convert(varchar,MarginDate,109),11) = @Sauda_Date
And Party_Code Like @FORPARTY         
    
Insert Into NBFC_TRANS     
Select Exchange,MarginDate,TradeType,sett_no,sett_type,Party_Code,Scrip_Cd,Series,BSECODE,
User_id,ContractNo,Order_no,Trade_no,Sauda_date,Tradeqty,MarketRate,AuctionPart,MarketType,
Sell_buy,Ins_chrg,turn_tax,other_chrg,sebi_tax,Broker_chrg,
Billflag,NBrokApp,NSerTax,N_NetRate,Partipantcode,CpId 
From NBFC_TRANS_PROCESS
Where left(convert(varchar,MarginDate,109),11) = @Sauda_Date

GO
