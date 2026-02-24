-- Object: PROCEDURE dbo.CBO_DEL_REPORTS
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE  PROCEDURE [dbo].[CBO_DEL_REPORTS]
	@reportcode int
         
            
AS
	
	DELETE FROM
		Tblreports
	WHERE
		Fldreportcode = @reportcode


delete TblReports_Blocked where fldreportcode=@reportcode

GO
