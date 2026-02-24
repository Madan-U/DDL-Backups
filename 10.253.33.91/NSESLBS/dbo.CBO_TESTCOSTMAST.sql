-- Object: PROCEDURE dbo.CBO_TESTCOSTMAST
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE PROC CBO_TESTCOSTMAST 
	    @branchcode      varchar(10),
      --@costcode        varchar(10),
     -- @flag	           varchar(1),
      @STATUSID        VARCHAR(25),
      @STATUSNAME      VARCHAR(25)
AS
	IF @STATUSID <> 'BROKER'
		BEGIN
			RAISERROR ('This Procedure is accessible to Broker', 16, 1)
			RETURN
		END
	--IF @FLAG <> 'A' 
		--BEGIN
			--RAISERROR ('Add/Edit/Delete Flag Not Set Properly', 16, 1)
			--RETURN
		--END
	IF @branchcode = '' 
		BEGIN
			RAISERROR ('Old Party Code Cannot be Blank...', 16, 1)
			RETURN
		END
 DECLARE
    @SQLVAR  INT,
		@SQL    Varchar(2000)

    CREATE TABLE #TEMP (FLD INT)
		SET @SQL = "INSERT INTO #TEMP SELECT COUNT(1) FROM ACCOUNT.DBO.COSTMAST WHERE COSTNAME = '" + @branchcode + "'"
    --PRINT(@SQL)
		EXEC(@SQL)
    --SELECT @SQLVAR = COUNT(1) FROM ACCOUNT.DBO.COSTMAST
		SELECT @SQLVAR = FLD FROM #TEMP
		--SELECT @SQLVAR
		DROP TABLE #TEMP
     IF @SQLVAR = 0
      --begin 
	     --IF @FLAG = 'A'
  	    BEGIN
        INSERT INTO ACCOUNT.DBO.COSTMAST
			  SELECT @branchcode, ISNULL(MAX(COSTCODE)+1, 1), '1', '10000000000' 
	      FROM 
	      ACCOUNT.DBO.COSTMAST  
		  END
 -- end
   CREATE TABLE #TEMP1 (FLD INT)
		SET @SQL = "INSERT INTO #TEMP1 SELECT COUNT(1) FROM ACCOUNT.DBO.BRANCHACCOUNTS WHERE BRANCHNAME = '" + @branchcode + "'"
    --PRINT(@SQL)
		EXEC(@SQL)
    SELECT @SQLVAR = COUNT(1) FROM ACCOUNT.DBO.BRANCHACCOUNTS
		SELECT @SQLVAR = FLD FROM #TEMP1
		--SELECT @SQLVAR
		DROP TABLE #TEMP1
     IF @SQLVAR = 0
      BEGIN
        INSERT INTO ACCOUNT.DBO.BRANCHACCOUNTS VALUES 
			   (
					@branchcode, 
					(Case When Len(LTrim(RTrim(@BranchCode)) + 'CTRL') > 10 Then LTrim(RTrim(@BranchCode)) Else (LTrim(RTrim(@BranchCode)) + 'CTRL') End),
					'HOCTRL', 
					0
			   )  
		  END 
    
   CREATE TABLE #TEMP2 (FLD INT)
		SET @SQL = "INSERT INTO #TEMP2 SELECT COUNT(1) FROM ACCOUNT.DBO.ACMAST  WHERE ACNAME = '" + (Case When Len(LTrim(RTrim(@BranchCode)) + 'CTRL') > 10 Then LTrim(RTrim(@BranchCode)) Else (LTrim(RTrim(@BranchCode)) + 'CTRL') End) + "'"
    --PRINT(@SQL)
		EXEC(@SQL)
    --SELECT @SQLVAR = COUNT(1) FROM ACCOUNT.DBO.ACMAST 
		SELECT @SQLVAR = FLD FROM #TEMP2
		--SELECT @SQLVAR
		DROP TABLE #TEMP2
     IF @SQLVAR = 0
      BEGIN
        INSERT INTO ACCOUNT.DBO.ACMAST (Acname,Longname,Actyp,Accat,Familycd,Cltcode,Accdtls,Grpcode,Booktype,Micrno,Branchcode,Btobpayment,Paymode,Pobankname,Pobranch,Pobankcode)
			VALUES (
						LTRIM(RTRIM(@branchcode)) + ' CONTROL A/C', 
						LTRIM(RTRIM(@branchcode)) + ' CONTROL A/C', 
						'ASSET', 
						'4', 
						'', 
						(Case When Len(LTrim(RTrim(@BranchCode)) + 'CTRL') > 10 Then LTrim(RTrim(@BranchCode)) Else (LTrim(RTrim(@BranchCode)) + 'CTRL') End), 
						'', 
						'A0000000000', 
						'', 
						'0', 
						LTRIM(RTRIM(@branchcode)), 
						'0', 
						'C', 
						'', 
						'', 
						''
				)
		END

GO
