-- Object: PROCEDURE dbo.CBO_GET_BLOCKED_REPORTS
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------






CREATE PROCEDURE [dbo].[CBO_GET_BLOCKED_REPORTS]
(
	@fldreportcode int 
        
	
)
AS


select Fldreportcode,block_flag from TblReports_Blocked where fldreportcode=@fldreportcode

GO
