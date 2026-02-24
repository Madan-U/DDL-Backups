-- Object: PROCEDURE dbo.CBO_GetCategoryReportDetail
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



CREATE   PROC  CBO_GetCategoryReportDetail
		@fldcode VARCHAR(25),
--		@fldAdminAuto VARCHAR(25),
		@STATUSID VARCHAR(25) = 'BROKER',
		@STATUSNAME VARCHAR(25) = 'BROKER'
AS
		IF @STATUSID <> 'BROKER'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END

		set transaction isolation level read uncommitted 
		
		SELECT
			r.fldreportname,
			r.flddesc,
			g.fldgrpname,
			fldreportcode = isnull(cm.fldreportcode, '')
		FROM
			        tblreports r (nolock)
				LEFT JOIN TBLCATMENU CM (NOLOCK)
				ON r.fldreportcode = cm.fldreportcode AND cm.fldcategorycode like '%,'+@fldcode+',%'
--				AND cm.Fldadminauto= @fldAdminAuto
			 	,tblreportgrp g (nolock)/*,
			tblcatmenu cm (nolock) */
		WHERE
			r.fldreportgrp = g.fldreportgrp
			 
			/*and r.fldreportcode = cm.fldreportcode 
			and cm.fldcategorycode like '%,'+@fldcode+',%'*/
		ORDER BY
			g.fldgrpname

GO
