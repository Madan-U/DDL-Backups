-- Object: PROCEDURE dbo.CBO_AddCategory
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------





CREATE   PROC [dbo].[CBO_AddCategory]
	
	@FLDCATEGORYNAME VARCHAR(25),
	@FLDDESCRIPTION VARCHAR(25)
	
AS
/*	IF @STATUSID <> 'BROKER'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END
	IF @FLAG <> 'A' AND @FLAG <> 'E' AND @FLAG <> 'D'
		BEGIN
			RAISERROR ('Add/Edit/Delete Flag Not Set Properly', 16, 1)
			RETURN
		END
*/
	IF @FLDCATEGORYNAME = '' OR @FLDDESCRIPTION = ''
		BEGIN
			RAISERROR ('Category Name Or Category Description Can Not Left Blank...', 16, 1)
			RETURN
		END

		Set Transaction Isolation Level Read Uncommitted  
		SELECT * FROM tblcategory (nolock) 
		WHERE fldcategoryname = @FLDCATEGORYNAME

		INSERT INTO tblcategory VALUES (@FLDCATEGORYNAME,'2',@FLDDESCRIPTION)
		
		INSERT INTO tblusercontrolglobals  
		SELECT fldcategorycode, 30, 6, 'F', 20, 'Y', 0  
		FROM tblcategory  WHERE fldcategoryname = @FLDCATEGORYNAME

		Set Transaction Isolation Level Read Uncommitted  
		SELECT * FROM tblcategory (nolock) 
		WHERE fldcategoryname = @FLDCATEGORYNAME and fldadminauto='2'
		
		





		Set Transaction Isolation Level Read Uncommitted  
		SELECT * FROM tblcategory (nolock)
		WHERE fldadminauto= '2' ORDER BY fldcategoryname

		SELECT r.fldreportcode, r.fldreportname, r.flddesc,g.fldgrpname 
		FROM tblreports r (nolock),tblreportgrp g (nolock) 
		WHERE r.fldreportgrp =g.fldreportgrp 
		and (r.fldstatus = 'All' or r.fldstatus = 'Broker') order by r.fldreportgrp

GO
