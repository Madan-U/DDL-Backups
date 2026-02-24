-- Object: PROCEDURE dbo.CBO_REPORTSLIST
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



CREATE PROCEDURE [dbo].[CBO_REPORTSLIST]
(
	@FLDREPORTCODE VARCHAR(15) = '',
	@STATUSID VARCHAR(25) = 'BROKER',
	@STATUSNAME VARCHAR(25) = 'BROKER'
)
AS
/*
	EXEC CBO_CUSTODIANLIST '123456', 'BROKER', 'BROKER'
	SELECT @@ERROR
*/
	IF @STATUSID <> 'BROKER'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END
	select 
		r.fldreportcode,r.fldmenugrp ,r.fldreportname,r.flddesc,g.fldgrpname,r.fldpath,fldtarget,r.fldstatus,r.fldorder,r.fldreportgrp 
        from tblreports r,tblreportgrp g  
	where r.fldreportgrp = g.fldreportgrp  
	order by g.fldgrpname,r.fldorder

GO
