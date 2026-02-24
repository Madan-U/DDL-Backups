-- Object: PROCEDURE dbo.usp_TradeSummaryInContractNotes_DataFetching_single
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE proc [dbo].[usp_TradeSummaryInContractNotes_DataFetching_single]  
( @FromDate varchar(11), @ToDate varchar(30),@CLTCODE VARCHAR(10) )  
AS  
/*  
  
EXEC usp_TradeSummaryInContractNotes_DataFetching @Flag = 'FETCHTransactions', @FromDate = '', @ToDate = ''   
  
*/  
BEGIN  
 --Declare @FromDate varchar(11), @ToDate varchar(30)  
 --set @FromDate= CONVERT(VARCHAR(11), GETDATE(),109)  
 --set @ToDate= CONVERT(VARCHAR(11), GETDATE(),109) +' 23:59:59'  
  
 print @FromDate  
 print @ToDate  
  
 /* Below code commented by DInesh on Apr 10 2019 and added new sp with new logice suggested & prepared by Arjun */  
 --BSE NSE  
 --Truncate table  tbl_DailyTradesumary_cashtrade  
 --insert into tbl_DailyTradesumary_cashtrade  
 --exec  [Pdf_CashTradesReport_Summarywithlevies_BSE_NSE_New_Daily] 'A','ZZZZZZZZZZ',@FromDate ,@ToDate  
  
-- IF EXISTS  
--(  
--SELECT 1 FROM sys. indexes  
--WHERE name='ClusteredIndex-Party_Code' AND object_id = OBJECT_ID('dbo.[Tbl_CashTradeSummaryforCN]')  
--)  
--BEGIN  
--DROP INDEX [ClusteredIndex-Party_Code] ON [dbo].[Tbl_CashTradeSummaryforCN]  
  
--END  
   
  
 --Truncate table Tbl_CashTradeSummaryforCN  
 --insert into Tbl_CashTradeSummaryforCN  
 exec usp_CashTradeSummaryforCN_NEW @CLTCODE,@CLTCODE,@FromDate ,@ToDate  
  
 --CREATE CLUSTERED INDEX [ClusteredIndex-Party_Code] ON [dbo].[Tbl_CashTradeSummaryforCN]  
 --([PARTY_CODE] ASC  
 --)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]  
  
 PRINT 'CASTRADE DONE'  
  
 --NSEFO   
 --TRUNCATE TABLE tbl_DailyTradesumary_NSEFO  
 --insert into tbl_DailyTradesumary_NSEFO  
 --exec  Pdf_CashTradesReport_SummaryNSEFO_Monthly 'A','ZZZZZZZZZZ',@FromDate ,@ToDate  
  
   
-- IF EXISTS  
--(  
--SELECT 1 FROM sys. indexes  
--WHERE name='ClusteredIndex-Party_Code' AND object_id = OBJECT_ID('dbo.[tbl_DailyTradesumary_NSEFO]')  
--)  
--BEGIN  
--DROP INDEX [ClusteredIndex-Party_Code] ON [dbo].[tbl_DailyTradesumary_NSEFO]  
  
--END  
  
   
  
 TRUNCATE TABLE tbl_DailyTradesumary_NSEFO  
 insert into tbl_DailyTradesumary_NSEFO  
 exec  Pdf_CashTradesReport_SummaryNSEFO_daily @CLTCODE,@CLTCODE,@FromDate ,@ToDate  
  
 --CREATE CLUSTERED INDEX [ClusteredIndex-Party_Code] ON [dbo].[tbl_DailyTradesumary_NSEFO]  
 --([PARTY_CODE] ASC  
 --)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)   
 --ON [PRIMARY]  
  
 PRINT 'NSEFO DONE'  
 /*  
 -- Commodity  
 Truncate table tbl_DailyTradesumary_COMMODITY  
 insert into tbl_DailyTradesumary_COMMODITY  
 exec  Pdf_CashTradesReport_Summary_COMMODITY_Monthly 'A','ZZZZZZZZZZ',@FromDate ,@ToDate  
  
 PRINT 'Commodity DONE' */  
  
  
END

GO
