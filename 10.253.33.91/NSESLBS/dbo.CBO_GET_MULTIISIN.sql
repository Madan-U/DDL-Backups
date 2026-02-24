-- Object: PROCEDURE dbo.CBO_GET_MULTIISIN
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------








CREATE PROCEDURE [dbo].[CBO_GET_MULTIISIN]
(
	@scrip_cd VARCHAR(25) = ''
	
)
AS
 	
	Select * 
	From MultiIsin 
	where scrip_cd like @scrip_cd order By Series

GO
