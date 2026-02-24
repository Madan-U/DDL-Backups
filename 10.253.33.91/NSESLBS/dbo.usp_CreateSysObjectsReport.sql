-- Object: PROCEDURE dbo.usp_CreateSysObjectsReport
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROC usp_CreateSysObjectsReport
AS

BEGIN
   SET CONCAT_NULL_YIELDS_NULL OFF
   SET NOCOUNT ON

   SELECT '<TABLE>'
   UNION ALL
   SELECT '<tr><td><CODE>' + cl_code +birthdate+ '</CODE></td></tr>' FROM client5
   UNION ALL
   SELECT '</TABLE>'
END

GO
