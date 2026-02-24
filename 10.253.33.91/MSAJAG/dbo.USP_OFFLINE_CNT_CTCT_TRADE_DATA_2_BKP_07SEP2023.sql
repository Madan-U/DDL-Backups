-- Object: PROCEDURE dbo.USP_OFFLINE_CNT_CTCT_TRADE_DATA_2_BKP_07SEP2023
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



CREATE PROCEDURE [dbo].[USP_OFFLINE_CNT_CTCT_TRADE_DATA_2_BKP_07SEP2023]
  AS
BEGIN

  IF OBJECT_ID('tempdb..#Results') IS NOT NULL
    DROP TABLE #Results
  Select * INTO #Results from [196.1.115.159].SSISDB.DBO.tbl_CNT_Omnesys_all_temp  A WITH(NOLOCK)
  WHERE REMARKS LIKE 'TradeNXT%Dealer%'
  
  INSERT INTO #Results
  Select * from [196.1.115.159].SSISDB.DBO.tbl_CNT_Omnesys_all_temp  A WITH(NOLOCK)
  WHERE  ([Order Source] ='TWS' AND (REMARKS ='' OR REMARKS IS NULL)) 
    
    create index ix_#Results ON #Results([Account Id])

    
  IF OBJECT_ID('tempdb..#Results_1') IS NOT NULL
    DROP TABLE #Results_1
    Select A.* INTO #Results_1 from #Results A
             where Exists (Select * from tbl_CTCL_Terminal_OFFLINE_CNT_TRADE B where A.[Account Id] =B.ACC_ID )
 
 DELETE A FROm #Results_1 A WHERE UserId =A.[Account Id]

 Select * from #Results_1

 END

GO
