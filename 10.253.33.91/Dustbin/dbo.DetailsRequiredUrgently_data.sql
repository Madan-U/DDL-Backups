-- Object: PROCEDURE dbo.DetailsRequiredUrgently_data
-- Server: 10.253.33.91 | DB: Dustbin
--------------------------------------------------

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DetailsRequiredUrgently_data]


AS
BEGIN
	
create table #s (Party_code varchar(50))



select *From #s

	--SELECT DISTINCT A.CL_CODE,A.Long_NAME, B.Exchange
	--, B.SEGMENT,B.INACTIVE_FROM,B.ACTIVE_DATE,B.
	--DEACTIVE_VALUE,B.DEACTIVE_REMARKS 
	--FROM MSAJAG.dbo.CLIENT_DETAILS A 
 --   INNER JOIN MSAJAG.dbo.CLIENT_BROK_DETAILS B ON A.CL_CODE = B.CL_CODE 
	--WHERE A.cl_code in (select *From #s)

END

GO
