-- Object: PROCEDURE dbo.CBO_GETADDCATEGORY
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------




CREATE  PROC CBO_GETADDCATEGORY
	
	@STATUSID VARCHAR(25) = 'BROKER',
	@STATUSNAME VARCHAR(25) = 'BROKER'
AS
	IF @STATUSID <> 'BROKER'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END
	
	
		select r.fldreportcode,
	        r.fldreportname, 
		r.flddesc,
		g.fldgrpname
		from tblreports r (nolock),
		tblreportgrp g (nolock) 
		where r.fldreportgrp =g.fldreportgrp and (r.fldstatus = 'All' or r.fldstatus = 'Broker') 
		order by r.fldreportgrp

GO
