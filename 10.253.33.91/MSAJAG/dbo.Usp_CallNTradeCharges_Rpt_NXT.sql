-- Object: PROCEDURE dbo.Usp_CallNTradeCharges_Rpt_NXT
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROCEDURE Usp_CallNTradeCharges_Rpt_NXT
@PartyCode VARCHAR(25) = NULL,
@Access_Code VARCHAR(25),
@StartDate VARCHAR(25) = NULL,
@EndDate VARCHAR(25) = NULL
AS
BEGIN

IF ISNULL(@StartDate,'') = ''
SET @StartDate = CAST(CONVERT(DATE,GETDATE()) AS varchar)

IF ISNULL(@EndDate,'') = ''
SET @StartDate = CAST(CONVERT(DATE,DATEADD(DD,-7,GETDATE())) AS varchar)

IF ISNULL(@PartyCode,'') = ''
Select 'PartyCode is mandatory' AS message


select * into #ORDER_TRANS_JV_CALC 
from ORDER_TRANS_JV_CALC with(nolock)
where sub_broker = @Access_Code AND PARTY_CODE = @PartyCode
and TRADE_DATE >= @StartDate and TRADE_DATE <= @EndDate and 
PRODUCT_TYPE = 'CALLNTRADE' AND ORDER_TYPE = 'OFFLINE'


declare 
@Charges float = 20 ,@GST DECIMAL(10,2),@GSTPERCENT INT = 18

set @GST = (@Charges * @GSTPERCENT) / 100
--select @Charges,@gst,(@Charges + @gst) 

select B.Trade_date orderDate, B.party_code clientCode,B.exchange, B.segment,A.Scripname
,A.sell_buy [buy/sell], A.order_NO orderNo, A.QTY,B.PRODUCT_TYPE chargeType, 
@Charges charges,@GST GST, (@Charges + @gst) netCharges
FROM 
(SELECT Scripname,sell_buy,order_NO,QTY FROM common_contract_data A WITH(NOLOCK)
WHERE SAUDA_DATE >=@StartDate and SAUDA_DATE <= @EndDate) A 
JOIN #ORDER_TRANS_JV_CALC B WITH(NOLOCK) ON A.order_NO = B.order_NO



END

GO
