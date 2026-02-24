-- Object: PROCEDURE dbo.spx_emodification_check_dp_activation_status
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

-- =============================================
-- Author:		Mitesh Parmar
-- Create date: 12-July-2023
-- Description:	KYC20-6214
-- requirement from SIVA and Suresh Raut, Before doing any type of modification check if DP Activation is completed or not

-- spx_emodification_check_dp_activation_status 'C51970020'

-- =============================================
CREATE PROCEDURE [dbo].[spx_emodification_check_dp_activation_status]
(
	@client_code varchar(100)
)
AS
BEGIN
	-- ===========================================================
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	-- ===========================================================
	SET NOCOUNT ON;

    
	declare @client_dp_id varchar(100)

	select	top 1	@client_dp_id = 
					case when	Depository = 'CDSL' then cltdpid 
						 when	Depository = 'NSDL' then bankid  + cltdpid 
						 else	cltdpid end
	from	AngelNseCM.msajag.dbo.client4 with(nolock) 
	where		cl_code = @client_code
			and Depository in ('CDSL','NSDL')
			and defdp =1

	select isnull(@client_dp_id,'') as client_dp_id

END

GO
