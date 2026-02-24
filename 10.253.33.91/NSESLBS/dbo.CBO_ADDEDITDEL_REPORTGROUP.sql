-- Object: PROCEDURE dbo.CBO_ADDEDITDEL_REPORTGROUP
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------





CREATE           PROCEDURE [dbo].[CBO_ADDEDITDEL_REPORTGROUP]
	@Fldgrpname VARCHAR(35),
	@Fldmenugrp VARCHAR(3),
	@Flddesc VARCHAR(80),
	@FLAG   VARCHAR(10),
        @STATUSID VARCHAR(25) = 'ADMINISTRATOR',
	@STATUSNAME VARCHAR(25) = 'ADMINISTRATOR'
AS
	IF @STATUSID <> 'ADMINISTRATOR'
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
				TBLREPORTGRP 
			SET
			Fldmenugrp=@Fldmenugrp,
			Flddesc=@Flddesc
			WHERE
		        Fldgrpname = @Fldgrpname
		END

	ELSE IF @FLAG = 'A'
             BEGIN
              
                       
		INSERT INTO TBLREPORTGRP
		(
			Fldgrpname,
			Fldmenugrp,
			Flddesc			
		)
		VALUES
		(
			@Fldgrpname ,
	                @Fldmenugrp ,
	                @Flddesc	 
		)
END
             ELSE IF @FLAG = 'D'
		BEGIN
			DELETE 
				TBLREPORTGRP
			WHERE
				Fldgrpname =@Fldgrpname
                         
		END

GO
