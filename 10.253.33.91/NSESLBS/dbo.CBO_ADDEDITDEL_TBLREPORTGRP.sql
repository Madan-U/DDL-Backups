-- Object: PROCEDURE dbo.CBO_ADDEDITDEL_TBLREPORTGRP
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------





CREATE  PROCEDURE [dbo].[CBO_ADDEDITDEL_TBLREPORTGRP]
	
	@Fldgrpname VARCHAR(35),
	@Fldmenugrp VARCHAR(3),
	@Flddesc VARCHAR(80),
	@FLAG   VARCHAR(10)='A',
        @STATUSID VARCHAR(25) = 'BROKER',
	@STATUSNAME VARCHAR(25) = 'BROKER'
AS
	IF @STATUSID <> 'BROKER'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END
	IF @FLAG <> 'A' AND @FLAG <> 'E' AND @FLAG <> 'D'
		BEGIN
			RAISERROR ('Add/Edit Flags Not Set Properly', 16, 1)
			RETURN
		END
	IF @FLAG = 'E'
		BEGIN
			UPDATE
				tblreportgrp WITH (ROWLOCK)
			SET
			Fldmenugrp =@Fldmenugrp ,
			Flddesc=@Flddesc
			WHERE
		        Fldgrpname=@Fldgrpname
		END
	ELSE IF @FLAG = 'A'
		INSERT INTO tblreportgrp 
		(
			Fldgrpname,
			Fldmenugrp,
			Flddesc
			
		)
		VALUES
		(
			@Fldgrpname,
			@Fldmenugrp,
			@Flddesc
			
			
		)
             ELSE IF @FLAG = 'D'
		BEGIN
			DELETE FROM
				 tblreportgrp
			WHERE
				Fldgrpname=@Fldgrpname
		END

GO
