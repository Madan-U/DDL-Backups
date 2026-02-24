-- Object: PROCEDURE dbo.CBO_GetCategoryGrpReport
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE     PROC CBO_GetCategoryGrpReport
		@STATUSID VARCHAR(25) = 'BROKER',
		@STATUSNAME VARCHAR(25) = 'BROKER'
AS
	IF @STATUSID <> 'BROKER'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END
	

		SELECT 
			r.fldreportcode, 
			r.fldreportname, 
			r.flddesc,
			g.fldgrpname
		FROM 	
			tblreports r (nolock),tblreportgrp g (nolock)
		WHERE
			r.fldreportgrp =g.fldreportgrp
			and (r.fldstatus = 'All' 
			or r.fldstatus = '"&Trim(iduser)&"')
	
		ORDER BY
			r.fldreportgrp

GO
