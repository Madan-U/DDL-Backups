-- Object: PROCEDURE dbo.usp_trade_details_Ipartner
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- usp_trade_details_Ipartner 'A63778' ,'10 Jan 2018','NSX'
CREATE PROCEDURE [dbo].[usp_trade_details_Ipartner]
	@client_code varchar(50),
	@date datetime = null,
	@exchange varchar(20) = null
AS
BEGIN
 --return 0
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @DateString varchar(20)
	declare @partyName varchar(100)
	
	if ISNULL(@date,'') = ''
	begin
	set @DateString = '%'
	end
	else 
	begin
	set @DateString = convert(varchar(20),@date,23)
	end

	if ISNULL(@exchange,'') = ''
	begin
	set @exchange = '%'
	end
	select top 1 @partyName  = long_name from INTRANET.risk.dbo.client_details where party_code = @client_code
    -- Insert statements for procedure here
	select * from (
	SELECT 
		Convert(datetime,SD_DATE,111) as SD_DATE_DT
		,SD_DATE
		,PARTY_CODE	
		,@partyName as Party_name
		,SYMBOL
		,COMPNAME	
		--,MARKETTYPE
		,case when MARKETTYPE='NSEFO' Then 'NSEFNO' ELSE MARKETTYPE end  MARKETTYPE
		,QTY
		,PRICE
		,TR_TYPE	
		,EXPIRYDATE	
		,STRIKEPRICE
		,OPTION_TYPE
	FROM TRADE_DETAILS_JAMOON with(nolock) WHERE PARTY_CODE = @client_code
	UNION
	SELECT Convert(datetime,SD_DATE,111) as SD_DATE_DT
		,SD_DATE
		,PARTY_CODE	
		,@partyName as Party_name
		,SYMBOL
		,COMPNAME	
		,case when MARKETTYPE='NSEFO' Then 'NSEFNO' ELSE MARKETTYPE end MARKETTYPE
		,QTY	
		,PRICE
		,TR_TYPE	
		,EXPIRYDATE	
		,STRIKEPRICE
		,OPTION_TYPE FROM TRADE_DETAILS_NXT with(nolock) WHERE PARTY_CODE = @client_code) tbl 
	where tbl.MARKETTYPE like @exchange and tbl.SD_DATE like @DateString


END

GO
