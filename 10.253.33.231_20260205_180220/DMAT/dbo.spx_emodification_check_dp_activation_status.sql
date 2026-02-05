-- Object: PROCEDURE dbo.spx_emodification_check_dp_activation_status
-- Server: 10.253.33.231 | DB: DMAT
--------------------------------------------------

-- =============================================
-- Author:		Mitesh Parmar
-- Create date: 12-July-2023
-- Description:	Requirement from Suresh sir and Siva
--				Before doing any kind of modification check if DP Activation is done or not
-- JIRA Story:	KYC20-6214		
-- spx_emodification_check_dp_activation_status '1203320038203003'
-- =============================================
CREATE PROCEDURE [dbo].[spx_emodification_check_dp_activation_status]
(
	@client_dp_id varchar(100)
)
AS
BEGIN
	-- ===========================================================
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	-- ===========================================================
	SET NOCOUNT ON;

    
	if exists 
	(
		select	TOP 1 CLIENT_CODE,ACTIVE_DATE,status 
		From	dbo.tbl_client_master  WITH(NOLOCK)
		WHERE	CLIENT_CODE = @client_dp_id
	)
		BEGIN
			select 'success' AS Result
		END
	ELSE 
		BEGIN	
			select 'failure' AS Result
		END
END

GO
