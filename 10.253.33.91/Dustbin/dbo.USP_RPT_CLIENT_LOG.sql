-- Object: PROCEDURE dbo.USP_RPT_CLIENT_LOG
-- Server: 10.253.33.91 | DB: Dustbin
--------------------------------------------------

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>


--- exec   USP_RPT_CLIENT_LOG @cl_code= 'U16622'
-- =============================================
CREATE PROCEDURE [dbo].[USP_RPT_CLIENT_LOG]



 @cl_code  varchar (50)
 
AS
BEGIN
Select  cl_code,segment,exchange ,deactive_remarks,deactive_value,edit_on,edit_by,systemdate,active_date,modifiedby,modifiedon ,InActive_From,Status,
CheckActiveClient from msajag.dbo.client_brok_details_log where cl_code=@cl_code order by Edit_on desc
END

GO
