-- Object: PROCEDURE dbo.TEST_SETTLEMENT_UAT_DATA_03Aug2017
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE  PROC TEST_SETTLEMENT_UAT_DATA_03Aug2017
as

TRUNCATE TABLE SETTLEMENT_UAT 

INSERT INTO SETTLEMENT_UAT 
SELECT [ContractNo]
      ,[BillNo]
      ,[Trade_no]
      ,[Party_Code]
      ,[Scrip_Cd]
      ,[User_id]
      ,[Tradeqty]
      ,[AuctionPart]
      ,[MarketType]
      ,[Series]
      ,[Order_no]
      ,[MarketRate]
      ,[Sauda_date]
      ,[Table_No]
      ,[Line_No]
      ,[Val_perc]
      ,[Normal]
      ,[Day_puc]
      ,[day_sales]
      ,[Sett_purch]
      ,[Sett_sales]
      ,[Sell_buy]
      ,[Settflag]
      ,[Brokapplied]
      ,[NetRate]
      ,[Amount]
      ,[Ins_chrg]
      ,[turn_tax]
      ,[other_chrg]
      ,[sebi_tax]
      ,[Broker_chrg]
      ,[Service_tax]
      ,[Trade_amount]
      ,[Billflag]
      ,[sett_no]
      ,[NBrokApp]
      ,[NSerTax]
      ,[N_NetRate]
      ,[sett_type]
      ,[Partipantcode]
      ,[Status]
      ,[Pro_Cli]
      ,[CpId]
      ,[Instrument]
      ,[BookType]
      ,[Branch_Id]
      ,[TMark]
      ,[Scheme]
      ,[Dummy1]
      ,[Dummy2]
--      ,[SRNO]
  FROM [dbo].[SETTLEMENT] with (nolock)

GO
