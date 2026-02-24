-- Object: PROCEDURE dbo.CBO_GET_REPORTS_ORDER
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------







Create PROCEDURE [dbo].[CBO_GET_REPORTS_ORDER]
(
	@fldreportgrp int 
 	
)
AS


select fldreportcode ,fldreportname,flddesc,fldstatus,fldorder,fldreportgrp from tblreports  where fldreportgrp = @fldreportgrp order by fldorder

GO
