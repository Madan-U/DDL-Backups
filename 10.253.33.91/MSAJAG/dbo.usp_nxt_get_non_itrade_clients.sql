-- Object: PROCEDURE dbo.usp_nxt_get_non_itrade_clients
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- usp_nxt_get_non_itrade_clients 'cbho'
-- =============================================
CREATE PROCEDURE [dbo].[usp_nxt_get_non_itrade_clients] 
	-- Add the parameters for the stored procedure here
	@subbroker varchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   

select cl_code,long_name from INTRANET.risk.dbo.client_details with(nolock) where sub_broker = @subbroker
 and
  cl_code not in (select cl_code from Vw_VBB_SCHEME_NAME with(nolock) where sub_broker = @subbroker)



	
END

GO
