-- Object: PROCEDURE dbo.usp_nxt_getOrderBasedBrokerageReport_bkcp_26_04_19
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- usp_nxt_getOrderBasedBrokerageReport 'CLIENT','cbho','','2019-01-01','2019-04-30'
Create PROCEDURE  [dbo].[usp_nxt_getOrderBasedBrokerageReport_bkcp_26_04_19]
	-- Add the parameters for the stored procedure here
	@ReportLevel varchar(100),
	@access_code varchar(100),
	@party_code varchar(100),
	@from datetime,
	@to datetime
AS
BEGIN

	SET NOCOUNT ON;

	declare @sql varchar(max) = 'select cl_code,long_name,SP_CreatedOn,''iTrade Plan'' as SCHEME_NAME,sub_broker from Vw_VBB_SCHEME_NAME  where sub_broker='''+@access_code+'''';

	if(@ReportLevel ='CLIENT' and ISNULL(@party_code,'')<>'')
	begin
		set @sql = @sql + ' and cl_code='''+@party_code+'''';
	end

	if(ISNULL(@from,'')<>'' and ISNULL(@to,'')<>'')
	begin
	   set @sql = @sql + 'and cast(SP_CreatedOn as date) between convert(date,'''+convert(varchar,cast(@from as date),126) +''', 121) and convert(date,'''+convert(varchar,cast(@to as date),126) +''', 121)'
	end
	print (@sql)
	exec(@sql)
END

GO
