-- Object: PROCEDURE dbo.Stp_TradeDetailsISO515
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


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

CREATE PROCEDURE Stp_TradeDetailsISO515
(
	@ContractNo Varchar(7)  
)
AS  
BEGIN
	SET NOCOUNT ON

	DECLARE @T_TradeDetails TABLE (
		TradeDate VARCHAR(8) DEFAULT(''), 				--- YYYYMMDD
		TradeTime VARCHAR(8) DEFAULT(''), 				--- HHMMSS
		TradeQty	INT DEFAULT(0),
		MktRate	NUMERIC(28,4) DEFAULT(0),		-- Trade Rate
		TradeRefNo VARCHAR(20) DEFAULT(''),
		OrderNo	VARCHAR(20) DEFAULT(''),
		OrderDate VARCHAR(8)	DEFAULT(''),	--- YYYMMDD
		OrderTime VARCHAR(6)	DEFAULT('')	--- HHMMSS 
		)

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
		MktRate = CASE WHEN ISNULL(I.Dummy1, 0) <> 0 THEN CONVERT(NUMERIC(28,4), I.Dummy1) ELSE I.MarketRate END,
		OrderNo = I.Order_No,
		OrderDate = CASE WHEN I.CPID IS NOT NULL AND I.CPID <> 'Nil' THEN CONVERT(CHAR, CONVERT(DATETIME, I.CPID, 103), 112) 
							  ELSE CONVERT(CHAR, CONVERT(DATETIME, I.Sauda_Date, 103), 112)  END,
		OrderTime = CASE WHEN I.CPID IS NOT NULL AND I.CPID <> 'Nil' THEN REPLACE(CONVERT(CHAR, CONVERT(DATETIME, I.CPID, 103), 108), ':', '') 
							  ELSE REPLACE(CONVERT(CHAR, CONVERT(DATETIME, I.Sauda_Date, 103), 108), ':', '')  END
	FROM ISettlement I	WHERE I.ContractNo = @ContractNo

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
		OrderDate = CASE WHEN I.CPID IS NOT NULL AND I.CPID <> 'Nil' THEN CONVERT(CHAR, CONVERT(DATETIME, I.CPID, 103), 112) 
							  ELSE CONVERT(CHAR, CONVERT(DATETIME, I.Sauda_Date, 103), 112)  END,
		OrderTime = CASE WHEN I.CPID IS NOT NULL AND I.CPID <> 'Nil' THEN REPLACE(CONVERT(CHAR, CONVERT(DATETIME, I.CPID, 103), 108), ':', '') 
							  ELSE REPLACE(CONVERT(CHAR, CONVERT(DATETIME, I.Sauda_Date, 103), 108), ':', '')  END
	FROM Settlement I	WHERE I.ContractNo = @ContractNo

	SET NOCOUNT OFF
	SELECT 
		':70D:' + ':PART//' + Right(Replicate('0',15) + LTrim(RTRim(TradeRefNo)),16) + '[~]' + --:PART//0000000000000043
		RTRim(REPLACE(CONVERT(Char, TradeQty),'.', ','))  + '[~]' + -- 228,
		--RTRim(REPLACE(CONVERT(Char, NetRate),'.', ',')) + '[~]' + --758,1440
		RTRim(REPLACE(CONVERT(Char, MktRate),'.', ',')) + '[~]' + --758,1440
		RTRim(OrderDate) + ' ' + RTrim(OrderTime) + '[~]' + --20070627 122855
		':20C:' + ':PROC//' + Right(Replicate('0',15)+LTrim(RTrim(OrderNo)), 16) + '[~]'  --:PROC//0000000018864003
	FROM @T_TradeDetails 

END

/*

EXEC Stp_TradeDetailsISO515 '0000333'



*/

GO
