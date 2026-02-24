-- Object: PROCEDURE dbo.usp_nxt_insertMailLogsForItrade
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- usp_nxt_insertMailLogsForItrade 'rp61','cbho','699 vbb'
CREATE PROCEDURE [dbo].[usp_nxt_insertMailLogsForItrade]
	-- Add the parameters for the stored procedure here
	@party_code varchar(100),
	@subbroker varchar(100),
	@scheme varchar(100)	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	INSERT INTO [dbo].[Brok_detail_modifcation_VBB_nxt_mailer_log]
			   ([cl_code]
			   ,[long_name]
			   ,[SP_CreatedOn]
			   ,[SCHEME_NAME]
			   ,[sub_broker])
			   
		 select top 1 party_code as cl_code,long_name,GETDATE() as SP_CreatedOn,@scheme as SCHEME_NAME,sub_broker  from INTRANET.risk.dbo.client_details with(nolock) where party_code  = @party_code and sub_broker = @subbroker



END

GO
