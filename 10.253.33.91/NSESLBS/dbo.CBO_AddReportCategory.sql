-- Object: PROCEDURE dbo.CBO_AddReportCategory
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROCEDURE CBO_AddReportCategory  
(  
		 @UserID INT,  
		 @Catagory VARCHAR(100),    ---  (Non selected item in the list box) 2,3,6,10  
		 @Desc VARCHAR(150),  
		 @Reports VARCHAR(8000),  
		 @ReturnMsg VARCHAR(200) OUTPUT  
)  
AS  
	BEGIN  
		 DECLARE   
		 @@FldCategoryCode INT,  
		 @@Delimiter CHAR(1)  
  
 		DECLARE @@T_ReportIDList TABLE(ReportID INT)   
  
 		SET @ReturnMsg = ''  
  
 		IF EXISTS(SELECT 1 FROM TblCategory (nolock) WHERE fldcategoryname = @Catagory)  
		BEGIN  
	   SET @ReturnMsg = 'Catagory name exists! Choose another name.'  
		RETURN  
   END  
  
 -- Insert into TblCategory  
 		INSERT INTO TblCategory(Fldcategoryname, Fldadminauto, Flddesc) VALUES(@Catagory, @UserID, @Desc)  
  
 --- Insert into tblUserControlGlobals  
 	INSERT INTO TblUserControlGlobals(  
		  FLDCATEGORYID,  
		  FLDPWDEXPIRY,  
		  FLDMAXATTEMPT,  
		  FLDACCESSLVL,  
		  FLDTIMEOUT,  
		  FLDFIRSTLOGIN,  
		  FLDFORCELOGOUT)  
    SELECT  
		  FLDCATEGORYID = FldCategoryCode,  
		  FLDPWDEXPIRY = 30,  
		  FLDMAXATTEMPT = 6,  
		  FLDACCESSLVL = 'F',  
		  FLDTIMEOUT = 20 ,  
		  FLDFIRSTLOGIN = 'Y',  
		  FLDFORCELOGOUT = 0  
		  FROM TblCategory  
	  WHERE Fldcategoryname = @Catagory  
  
 	  SELECT @@FldCategoryCode = FldCategoryCode FROM TblCategory WHERE Fldcategoryname = @Catagory AND Fldadminauto = @UserID  
  
 	  SET @@FldCategoryCode = ISNULL(@@FldCategoryCode, 0)  
  
	  --- Split the given Report list and put into the table  
		 SET @@Delimiter = ','  
		  
	  INSERT INTO @@T_ReportIDList(ReportID) SELECT * FROM Dbo.CBOFN_Split(@Reports, @@Delimiter)  
	  
	  --- IF report id is available for the UserId, then Append the Given Category ID with the existing Category List. (IF report id is available for the UserId)  
	  UPDATE TblCatMenu SET FldCategoryCode = FldCategoryCode + ',' + RTRIM(CONVERT(CHAR, @@FldCategoryCode)) + ','   
 	  FROM TblCatMenu TC, @@T_ReportIDList TR   
	  WHERE TC.FldadminAuto  = @UserID AND TC.fldreportcode = TR.ReportID  
	  
     DELETE @@T_ReportIDList   
	  FROM @@T_ReportIDList TR, TblCatMenu TC   
	  WHERE TC.FldadminAuto  = @UserID AND TC.FldReportCode = TR.ReportID  
	  
	 --- IF report id is not available for the UserId, Insert Given CategoryID & Report   
	  INSERT INTO TblCatMenu(  
		  Fldreportcode,   
		  Fldadminauto,   
		  Fldcategorycode)   
 SELECT    
			  ReportID,   
			  @UserID,   
			  ',' + RTRIM(CONVERT(CHAR, @@FldCategoryCode)) + ','  
 	FROM @@T_ReportIDList   
  
 	IF @@ERROR <> 0   
		   SET @ReturnMsg = 'Error occured while adding new category...'  
 	ELSE  
  			SET @ReturnMsg = ''  
END

GO
