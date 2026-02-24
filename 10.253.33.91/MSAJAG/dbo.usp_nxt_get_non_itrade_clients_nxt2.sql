-- Object: PROCEDURE dbo.usp_nxt_get_non_itrade_clients_nxt2
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- usp_nxt_get_non_itrade_clients_nxt2 'cbho'
-- =============================================
CREATE PROCEDURE usp_nxt_get_non_itrade_clients_nxt2--_paginated 
	-- Add the parameters for the stored procedure here
	@subbroker varchar(100)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   
select Cl_code into #Vw_VBB_SCHEME_NAME from Vw_VBB_SCHEME_NAME (nolock)
where sub_broker = @subbroker
select cl_code,long_name,sub_broker into #clientDetails from client_details with(nolock) 
where sub_broker = @subbroker
select cl_code,long_name from #clientDetails with(nolock) 
where sub_broker = @subbroker
 and
  cl_code not in (select cl_code from #Vw_VBB_SCHEME_NAME with(nolock) )
	
END

GO
