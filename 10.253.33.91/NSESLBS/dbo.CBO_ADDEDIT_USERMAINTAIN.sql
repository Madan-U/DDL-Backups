-- Object: PROCEDURE dbo.CBO_ADDEDIT_USERMAINTAIN
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE  PROCEDURE [dbo].[CBO_ADDEDIT_USERMAINTAIN]
 (
   @Fldusername VARCHAR(25),
	@Fldpassword VARCHAR(15),
	@Fldfirstname VARCHAR(25),
	@Fldmiddlename VARCHAR(25),
	@Fldlastname VARCHAR(25),
	@Fldsex VARCHAR(8),                        
	@Fldaddress1 VARCHAR(40),
	@Fldaddress2 VARCHAR(40),
	@Fldphone1 VARCHAR(10),
	@Fldphone2 VARCHAR(10), 
	@Fldcategory VARCHAR(10),
	@Fldadminauto INT,
	@Fldstname VARCHAR(50),
	@Pwd_Expiry_Date DATETIME,
   @FLDPWDEXPIRY INT,
   @FLDSTATUS SMALLINT,
   @FLDMAXATTEMPT SMALLINT,
   @FLDATTEMPTCNT SMALLINT ,
 	@FLDLOGINFLAG SMALLINT,
   @FLDACCESSLVL CHAR (1),
	@FLDIPADD VARCHAR (2000),
   @FLDFIRSTLOGIN CHAR (1),
   --@FLAG VARCHAR(1),
   @STATUSID VARCHAR(25),
	@STATUSNAME VARCHAR(25)  
) 
AS
	/*IF @STATUSID <> 'ADMINISTRATOR'
		BEGIN
			RAISERROR ('This Procedure is accessible to ADMINISTRATOR', 16, 1)
			RETURN
		END
IF @FLAG <> 'A' AND @FLAG <> 'E' AND @FLAG <> 'D'
		BEGIN
			RAISERROR ('Add/Edit Flags Not Set Properly', 16, 1)
			RETURN
		END
IF @FLAG = 'A'*/
IF EXISTS (SELECT TOP 1 @Fldusername FROM tblPradnyausers WHERE Fldusername = @Fldusername)
				BEGIN
					RAISERROR ('UserId already exists...', 16, 1)
					RETURN
				END

INSERT INTO tblPradnyausers
VALUES
		(
			@Fldusername,
			@Fldpassword,
			@Fldfirstname,
			@Fldmiddlename,
			@Fldlastname,
			@Fldsex,
			@Fldaddress1,
			@Fldaddress2,
			@Fldphone1,
			@Fldphone2,
			@Fldcategory,
			@Fldadminauto,
			@Fldstname,
			@Pwd_Expiry_Date 		 
		)

--- Get the UniqueID From tblPradnyaUsers for the given user
DECLARE @FLDAUTO BIGINT
SELECT @FLDAUTO = Fldauto FROM tblPradnyaUsers WHERE fldUsername =  @Fldusername

--declare  @FLDAUTO int
--SELECT @FLDAUTO = FLDAUTO FROM tblPradnyaUsers
--print (@FLDAUTO)

IF ISNULL(@FLDAUTO,0) = 0 
	BEGIN
		RAISERROR ('Error in registering new user.....', 16, 1)
		RETURN
	END

DECLARE 
--@FLDFIRSTLOGIN CHAR (1),
@FLDFORCELOGOUT SMALLINT

/*	set @FLDTIMEOUT=0
	set @FLDLOGINFLAG=0
	set @FLDFORCELOGOUT=0 */
INSERT INTO tblUserControlMaster
/*(  FLDUSERID,
   FLDPWDEXPIRY ,
   FLDMAXATTEMPT ,
   FLDATTEMPTCNT  ,
   FLDSTATUS ,
   FLDLOGINFLAG,
   FLDACCESSLVL ,
	FLDIPADD ,
   FLDTIMEOUT ,
	FLDFIRSTLOGIN,
   FLDFORCELOGOUT 
)*/
VALUES
		     (				
  				@FLDAUTO,
				@FLDPWDEXPIRY,
				@FLDMAXATTEMPT,
				@FLDATTEMPTCNT,
				@FLDSTATUS,
				1,
				@FLDACCESSLVL,
				@FLDIPADD,
				0,
				@FLDFIRSTLOGIN,
				0
			  )
	
	INSERT INTO 
   TBLUSERCONTROLMASTER 
   SELECT a.FLDAUTO, b.FLDPWDEXPIRY, b.FLDMAXATTEMPT,0,0,0,b.FLDACCESSLVL,'',b.FLDTIMEOUT,b.FLDFIRSTLOGIN,b.FLDFORCELOGOUT
   FROM       
   TBLPRADNYAUSERS A left OUTER JOIN TBLUSERCONTROLMASTER X ON (A.FLDAUTO = X.FLDUSERID),
	TBLUSERCONTROLGLOBALS B
	WHERE 
   B.FLDCATEGORYID = A.FLDCATEGORY
	AND ISNULL(X.FLDUSERID,0) = 0
/*IF @FLAG = 'E'
BEGIN
			IF NOT EXISTS (SELECT TOP 1 Fldusername FROM tblPradnyausers WHERE USERID = @TERM_CODE)
				BEGIN
					RAISERROR ('UserId doesnot exist...', 16, 1)
					RETURN
				END

*/

GO
