-- Object: PROCEDURE dbo.CBO_GETUSERDETAIL
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE       PROC CBO_GETUSERDETAIL
	@Fldcat INT,
	@STATUSID VARCHAR(25) = 'ADMINISTRATOR',
	@STATUSNAME VARCHAR(25) = 'ADMINISTRATOR'
AS
	IF @STATUSID <> 'ADMINISTRATOR'
		BEGIN
			RAISERROR ('This Procedure is accessible to ADMINISTRATOR', 16, 1)
			RETURN
		END				
	SELECT
		FldAuto,
		FldCategoryName,
		FldCategoryId ,
		FlDPWDExpiry ,
		FLDMAXATTEMPT,
		FLDACCESSLVL ,
                FLDTIMEOUT,
                FLDFIRSTLOGIN,
                FLDFORCELOGOUT
       FROM
		tblCategory a,tblUserControlGlobals b
	
	
       WHERE  
                a.fldcategorycode = b.fldcategoryId  and b.fldCategoryId=@Fldcat

GO
