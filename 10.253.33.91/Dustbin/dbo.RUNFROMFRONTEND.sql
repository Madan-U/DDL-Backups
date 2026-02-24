-- Object: PROCEDURE dbo.RUNFROMFRONTEND
-- Server: 10.253.33.91 | DB: Dustbin
--------------------------------------------------


CREATE PROC RUNFROMFRONTEND
AS
 
--EXEC dbo.sp_start_job N'SQL JOB TEST' ;  -- NOT WORKING
EXEC msdb.dbo.sp_start_job N'SQL JOB TEST';

GO
