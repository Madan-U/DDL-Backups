-- Object: PROCEDURE dbo.CBO_ADD_USERCONTROLDETAILS
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------




CREATE  PROCEDURE [dbo].[CBO_ADD_USERCONTROLDETAILS]
	
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
   @STATUSID VARCHAR(25)='ADMINISTRATOR',
	@STATUSNAME VARCHAR(25)='ADMINISTRATOR'
     
  AS
	IF @STATUSID <> 'ADMINISTRATOR'
		BEGIN
			RAISERROR ('This Procedure is accessible to ADMINISTRATOR', 16, 1)
			RETURN
		END
	IF EXISTS (SELECT TOP 1 @Fldusername FROM tblPradnyausers WHERE Fldusername = @Fldusername)
				BEGIN
					RAISERROR ('UserId already exists...', 16, 1)
					RETURN
				END

	
            INSERT INTO tblPradnyausers
		  (
			

[Fldusername], [Fldpassword], [Fldfirstname], [Fldmiddlename], [Fldlastname], [Fldsex], [Fldaddress1], [Fldaddress2], [Fldphone1], [Fldphone2], [Fldcategory], [Fldadminauto], [Fldstname], [Pwd_Expiry_Date]
   		)
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

GO
