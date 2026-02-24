-- Object: PROCEDURE dbo.Stp_TradeDetailsISO515
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

    
 /****** Object:  Stored Procedure dbo.Stp_TradeDetailsISO515    Script Date: 02/08/2008 3:41:48 PM ******/      
      
/*      
:95Q::EXCH//ORDER DETAILS      
:70D::PART//0000000000000043      
228,      
758,1440      
20070627 122855      
:20C::PROC//0000000018864003      
:16S:OTHRPRTY      
-}      
      
-------------------------------------------      
Select * From Stp_Header_new Where ServiceProvider = 'NSEIT'      
Select ExchangeCode, MemberCode, * From Owner      
--------------------------------------------      
*/      
      
CREATE  PROCEDURE Stp_TradeDetailsISO515      
(      
 @ExchangeCode Varchar(4),       
 @ContractNo Varchar(7),    
 @SaudaDate Varchar(11)=''    
)      
AS        
BEGIN      
 SET NOCOUNT ON      
      
 DECLARE @T_TradeDetails TABLE (      
  TradeDate VARCHAR(8) DEFAULT(''),     --- YYYYMMDD      
  TradeTime VARCHAR(8) DEFAULT(''),     --- HHMMSS      
  TradeQty INT DEFAULT(0),      
  MktRate NUMERIC(28,4) DEFAULT(0),  -- Trade Rate      
  TradeRefNo VARCHAR(20) DEFAULT(''),      
  OrderNo VARCHAR(20) DEFAULT(''),      
  OrderDate VARCHAR(8) DEFAULT(''), --- YYYMMDD      
  OrderTime VARCHAR(6) DEFAULT('') --- HHMMSS       
  )      
      
 IF @ExchangeCode = 'NSE'      
  --- Collect Individual Trade Details ISettlement Table      
  INSERT INTO @T_TradeDetails(      
   TradeDate,      
   TradeTime,       
   TradeRefNo,       
   TradeQty,       
   MktRate,      
   OrderNo,       
   OrderDate,       
   OrderTime)      
  SELECT      
   TradeDate = CONVERT(CHAR, I.Sauda_Date, 112),      
   --TradeTime = CONVERT(CHAR, I.Sauda_Date, 108),
TradeTime = CONVERT(CHAR, I.Sauda_Date, 108),      
   TradeRefNo = I.Trade_No,      
   TradeQty = I.TradeQty,      
   MktRate = CASE WHEN ISNULL(I.Dummy1, 0) <> 0 THEN CONVERT(NUMERIC(28,4), I.Dummy1) ELSE I.MarketRate END,      
   OrderNo = I.Order_No,      
   --OrderDate = CONVERT(CHAR, CONVERT(DATETIME, I.CPID, 103), 112),      
   OrderDate = CASE WHEN I.CPID IS NOT NULL AND I.CPID <> 'Nil' THEN CONVERT(CHAR, CONVERT(DATETIME, I.CPID, 103), 112)       
          ELSE CONVERT(CHAR, CONVERT(DATETIME, I.Sauda_Date, 103), 112)  END,      
   OrderTime = CASE WHEN I.CPID IS NOT NULL AND I.CPID <> 'Nil' THEN REPLACE(CONVERT(CHAR, CONVERT(DATETIME, I.CPID, 103), 108), ':', '')       
          ELSE REPLACE(CONVERT(CHAR, CONVERT(DATETIME, I.Sauda_Date, 103), 108), ':', '')  END      
  FROM ISettlement I WHERE I.ContractNo = @ContractNo and Sauda_date Like @SaudaDate +'%'    
 ELSE    --- BSE      
  --- Collect Individual Trade Details ISettlement Table      
  INSERT INTO @T_TradeDetails(      
   TradeDate,      
   TradeTime,       
   TradeRefNo,       
   TradeQty,       
   MktRate,      
   OrderNo,       
   OrderDate,       
   OrderTime)      
  SELECT      
   TradeDate = CONVERT(CHAR, I.Sauda_Date, 112),      
   TradeTime = CONVERT(CHAR, I.Sauda_Date, 108),      
   TradeRefNo = I.Trade_No,      
   TradeQty = I.TradeQty,      
   MktRate = CASE WHEN ISNULL(I.Dummy2, 0) <> 0 THEN CONVERT(NUMERIC(28,2), I.Dummy2) ELSE I.MarketRate END,      
   OrderNo = I.Order_No,      
   --OrderDate = CONVERT(CHAR, CONVERT(DATETIME, I.CPID, 103), 112),      
   OrderDate = CASE WHEN I.CPID IS NOT NULL AND I.CPID <> 'Nil' THEN CONVERT(CHAR, CONVERT(DATETIME, I.CPID, 103), 112)       
          ELSE CONVERT(CHAR, CONVERT(DATETIME, I.Sauda_Date, 103), 112)  END,      
   OrderTime = CASE WHEN I.CPID IS NOT NULL  AND I.CPID <> 'Nil' THEN REPLACE(CONVERT(CHAR, CONVERT(DATETIME, I.CPID, 103), 108), ':', '')       
          ELSE REPLACE(CONVERT(CHAR, CONVERT(DATETIME, I.Sauda_Date, 103), 108), ':', '')  END      
  FROM ISettlement I WHERE I.ContractNo = @ContractNo  and Sauda_date Like @SaudaDate +'%'    
      
      
 IF @ExchangeCode = 'NSE'      
  --- Collect Individual Trade Details From Settlement Table      
  INSERT INTO @T_TradeDetails(      
   TradeDate,      
   TradeTime,       
   TradeRefNo,       
   TradeQty,       
   MktRate,      
   OrderNo,       
   OrderDate,       
   OrderTime)      
  SELECT      
   TradeDate = CONVERT(CHAR, I.Sauda_Date, 112),    
   TradeTime = CONVERT(CHAR, I.Sauda_Date, 108),      
   TradeRefNo = I.Trade_No,      
   TradeQty = I.TradeQty,      
   MktRate = CASE WHEN ISNULL(I.Dummy1, 0) <> 0 THEN CONVERT(NUMERIC(28,4), I.Dummy1) ELSE I.MarketRate END,      
   OrderNo = I.Order_No,      
   --OrderDate = CONVERT(CHAR, CONVERT(DATETIME, I.CPID, 103), 112),      
   OrderDate = CASE WHEN I.CPID IS NOT NULL  AND I.CPID <> 'Nil' THEN CONVERT(CHAR, CONVERT(DATETIME, I.CPID, 103), 112)       
          ELSE CONVERT(CHAR, CONVERT(DATETIME, I.Sauda_Date, 103), 112)  END,      
   OrderTime = CASE WHEN I.CPID IS NOT NULL  AND I.CPID <> 'Nil' THEN REPLACE(CONVERT(CHAR, CONVERT(DATETIME, I.CPID, 103), 108), ':', '')       
          ELSE REPLACE(CONVERT(CHAR, CONVERT(DATETIME, I.Sauda_Date, 103), 108), ':', '')  END      
  FROM Settlement I WHERE I.ContractNo = @ContractNo  and Sauda_date Like @SaudaDate +'%'    
 ELSE    -- BSE      
  --- Collect Individual Trade Details From Settlement Table      
  INSERT INTO @T_TradeDetails(      
   TradeDate,      
   TradeTime,       
   TradeRefNo,       
   TradeQty,       
   MktRate,      
   OrderNo,       
   OrderDate,       
   OrderTime)      
  SELECT      
   TradeDate = CONVERT(CHAR, I.Sauda_Date, 112),      
   TradeTime = CONVERT(CHAR, I.Sauda_Date, 108),      
   TradeRefNo = I.Trade_No,      
   TradeQty = I.TradeQty,      
   MktRate = CASE WHEN ISNULL(I.Dummy2, 0) <> 0 THEN CONVERT(NUMERIC(28,2), I.Dummy2) ELSE I.MarketRate END,      
   OrderNo = I.Order_No,      
   --OrderDate = CONVERT(CHAR, CONVERT(DATETIME, I.CPID, 103), 112),      
   OrderDate = CASE WHEN I.CPID IS NOT NULL  AND I.CPID <> 'Nil' THEN CONVERT(CHAR, CONVERT(DATETIME, I.CPID, 103), 112)       
          ELSE CONVERT(CHAR, CONVERT(DATETIME, I.Sauda_Date, 103), 112)  END,      
   OrderTime = CASE WHEN I.CPID IS NOT NULL  AND I.CPID <> 'Nil' THEN REPLACE(CONVERT(CHAR, CONVERT(DATETIME, I.CPID, 103), 108), ':', '')       
          ELSE REPLACE(CONVERT(CHAR, CONVERT(DATETIME, I.Sauda_Date, 103), 108), ':', '')  END      
  FROM Settlement I WHERE I.ContractNo = @ContractNo  and Sauda_date Like @SaudaDate +'%'    
      
 SET NOCOUNT OFF      
      
 IF @ExchangeCode = 'NSE'    ---4 DECIMALS      
  SELECT       
      ':16R:' + 'OTHRPRTY' + '[~]' + --OTHRPRTY      
   ':95Q:' + ':EXCH//ORDER DETAILS' + '[~]' +  --:EXCH//ORDER DETAILS      
   ':70D:' + ':PART//' + Right(Replicate('0',15) + LTrim(RTRim(TradeRefNo)),16) + '[~]' + --:PART//0000000000000043      
   RTRim(CONVERT(Char, TradeQty)) + ',0000' + '[~]' + -- 228,      
   --RTRim(REPLACE(CONVERT(Char, NetRate),'.', ',')) + '[~]' + --758,1440      
   RTRim(REPLACE(CONVERT(Char, MktRate),'.', ',')) + '[~]' + --758,1440      
   RTRim(OrderDate) + ' ' + RTrim(OrderTime) + '[~]' + --20070627 122855      
   --':20C:' + ':PROC//' + Right(Replicate('0',15)+LTrim(RTrim(OrderNo)), 16) + '[~]' +  --:PROC//0000000018864003      
   ':20C:' + ':PROC//' + LTrim(RTrim(OrderNo)) + '[~]' +  --:PROC//0000000018864003      
   ':16S:OTHRPRTY' + '[~]'      
  FROM @T_TradeDetails       
 ELSE      --- FOR BSE   2 DECIMALS      
  SELECT       
   ':16R:' + 'OTHRPRTY' + '[~]' + --OTHRPRTY   -- R-Money      
   ':95Q:' + ':EXCH//ORDER DETAILS' + '[~]' + --:EXCH//ORDER DETAILS - R-Money      
   ':70D:' + ':PART//' + Right(Replicate('0',15) + LTrim(RTRim(TradeRefNo)),16) + '[~]' + --:PART//0000000000000043      
   RTRim(CONVERT(Char, TradeQty)) + ',00' + '[~]' + -- 228,      
   --RTRim(REPLACE(CONVERT(Char, NetRate),'.', ',')) + '[~]' + --758,1440      
   RTRim(REPLACE(CONVERT(Char, CONVERT(NUMERIC(24,2),MktRate)),'.', ',')) + '[~]' + --758,1440      
   RTRim(OrderDate) + ' ' + RTrim(OrderTime) + '[~]' + --20070627 122855      
   ---':20C:' + ':PROC//' + Right(Replicate('0',15)+LTrim(RTrim(OrderNo)), 16) + '[~]' +  --:PROC//0000000018864003      
   ':20C:' + ':PROC//' + LTrim(RTrim(OrderNo)) + '[~]' +  --:PROC//0000000018864003      
   ':16S:OTHRPRTY' + '[~]'      
  FROM @T_TradeDetails       
       
END      
      
/*      
      
EXEC Stp_TradeDetailsISO515  'BSE', '0000375'      
      
EXEC Stp_TradeDetailsISO515  'NSE', '0000103'      
      
select party_code, * from msajag.dbo.isettlement where contractno = '0000103'      
      
select contractno, party_code, DUMMY2, MARKETRATE, * from bsedb.dbo.isettlement where party_code = '0A141'      
      
select party_code, dummy1, order_no,CPID, * from bsedb.dbo.isettlement where contractno = '0000375'      
      
update bsedb.dbo.isettlement  set CPID = null where contractno = '0000375'      
select cl_type, * from client1 where cl_code = '0A141     '      
update client1 set cl_type = 'INS' where cl_code = '0A141     '      
      
:70D::PART//000000000000R330[~]30,0000[~]175,50[~]19000101 120001[~]:20C::PROC//0000000011136203[~]:16S:OTHRPRTY[~]      
      
*/      
      
SET QUOTED_IDENTIFIER ON

GO
