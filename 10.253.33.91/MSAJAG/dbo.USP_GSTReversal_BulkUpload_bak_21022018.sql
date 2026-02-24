-- Object: PROCEDURE dbo.USP_GSTReversal_BulkUpload_bak_21022018
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE PROC USP_GSTReversal_BulkUpload_bak_21022018
@INV_DATE VARCHAR(12),
@IsThirdParty VARCHAR(12),
@CreatedBy VARCHAR(12),
@FILENAME VARCHAR(MAX)
AS

BEGIN
/*
DECLARE @INV_DATE VARCHAR(12)
DECLARE @IsThirdParty VARCHAR(12)
DECLARE @CreatedBy VARCHAR(12)
DECLARE @FILENAME VARCHAR(MAX)


SET @INV_DATE = 'JUN 2017'
SET @IsThirdParty = 'N'
SET @CreatedBy = 'BADDY'
*/

DECLARE @@ERROR_COUNT INT


CREATE TABLE #TempData
(
	--ID INT IDENTITY(1,1),
	PartyCode VARCHAR(20),
	InvoiceNo VARCHAR(20),
	RecordFor VARCHAR(20),
	InvoiceType VARCHAR(20),
	ReversalType VARCHAR(20),
	VDT VARCHAR(20),
	GLCode VARCHAR(20),
	ReversalAmount MONEY,
	Narration VARCHAR(200)
)


CREATE TABLE #ErrorResult
(
	ClientCode VARCHAR(50),
	ErrorMsg VARCHAR(100)	
)
/*
INSERT INTO  #TempData
(PartyCode,InvoiceNo,RecordFor,InvoiceType,ReversalType,VDT,GLCode,ReversalAmount,Narration)
SELECT PartyCode,InvoiceNo,RecordFor,InvoiceType,ReversalType,VDT,GLCode,ReversalAmount,Narration
FROM GSTReversal_Preprocess
*/

DECLARE @CMD VARCHAR(MAX)

SET @CMD = ' BULK INSERT #TempData FROM ''' + @FILENAME + ''' WITH  (ROWTERMINATOR = ''\n'',FIELDTERMINATOR = '','') '

EXEC (@CMD)
PRINT (@CMD)

ALTER TABLE #TempData
ADD ID INT IDENTITY(1,1)

ALTER TABLE #TempData
ADD INV_DATE VARCHAR(20)

UPDATE #TempData
SET  INV_DATE = @INV_DATE

/*
update #TempData
set VDT = '12/12/2017'
where partycode = '0000000000000'
*/

/* Validate ClientCode Check */

INSERT INTO #ErrorResult
SELECT A.PartyCode , 'Party Code NOT FOUND' as ErrorMsg --, B.CltCode 
FROM #TempData A
		LEFT OUTER JOIN Account..ACMAST B 
		ON A.PartyCode = B.CltCOde 
			AND B.Accat = 4
WHERE B.CltCode  IS NULL

			
/* Validate GL CODE Check */

INSERT INTO #ErrorResult
SELECT A.PartyCode , 'GL Code NOT FOUND' as ErrorMsg --, B.CltCode 
FROM #TempData A
		LEFT OUTER JOIN Account..ACMAST B 
		ON A.GLCode  = B.CltCOde 
			AND B.Accat = 3
WHERE B.CltCode  IS NULL


/* Check of Invoice Type OR Reversal Type */

INSERT INTO #ErrorResult
SELECT PartyCode, 'Invoice Type NOT FOUND' as ErrorMsg 
FROM #TempData
WHERE UPPER(InvoiceType) NOT IN ('DEBIT', 'CREDIT')		

INSERT INTO #ErrorResult
SELECT PartyCode, 'Reversal Type NOT FOUND' as ErrorMsg 
FROM #TempData
WHERE UPPER(ReversalType) NOT IN ('EXCLUSIVE', 'INCLUSIVE')		



/* Validate VDT ID NOT GREATED THEN CURRENT DATE */

INSERT INTO #ErrorResult
SELECT PartyCode,  'VDT Can not greater then Current Date' as ErrorMsg 
FROM #TempData 
WHERE CONVERT(DATETIME,VDT,103) > GETDATE()

IF(@IsThirdParty = 'Y')
BEGIN

BEGIN TRY
BEGIN TRAN


SELECT @@ERROR_COUNT = COUNT(1) FROM #ErrorResult 
          
 IF @@ERROR_COUNT > 0          
BEGIN          
  
   SELECT * FROM #ErrorResult 
          
   ROLLBACK TRAN  
   RETURN          
END     

INSERT INTO GSTReversal_Preprocess
SELECT A.PartyCode, branch_cd, '', InvoiceNo, A.RecordFor, A.InvoiceType, A.ReversalType, A.VDT, A.GLCode, 0, A.ReversalAmount, 
		A.Narration, 'P', @IsThirdParty, GETDATE(), @CreatedBy, NULL, NULL
FROM #TempData A
		INNER JOIN Client_Details  B
		ON A.PartyCode= B.cl_code

SELECT 'Data Save Successfully..!'

COMMIT TRAN

END TRY

BEGIN CATCH

	SELECT 'ERROR IS : ' + ERROR_MESSAGE()
	ROLLBACK TRAN 

END CATCH
END 

ELSE IF(@IsThirdParty = 'N')
BEGIN
BEGIN TRY
BEGIN TRAN

/* Validate PartyCode with Invoice Number */

INSERT INTO #ErrorResult
SELECT PartyCode, 'INVOICE No. NOT FOUND' as ErrorMsg --, B.INV_NO 
FROM #TempData A
		LEFT OUTER JOIN TBL_GST_INVOICE_TMP B
		ON A.PartyCode = A.PartyCode 
				AND A.InvoiceNo = B.INV_NO
WHERE B.INV_NO IS NULL


/* Validate Reversal Amount against of Total Amount */


CREATE TABLE #ValidateClientAmount
(
	ID INT IDENTITY(1,1),
	PARTY_CODE VARCHAR(20),
	Name  VARCHAR(100),
	branch_cd  VARCHAR(20),
	TAXABLE_AMT  VARCHAR(20),
	INV_NO  VARCHAR(100),
	ReleasableAmount MONEY
)


DECLARE @MIN INT
DECLARE @MAX INT
DECLARE @Value INT

DECLARE @InvDate VARCHAR(11)
DECLARE @FromClient VARCHAR(11)
DECLARE @ToClient VARCHAR(11)
DECLARE @RecordFor VARCHAR(11)
DECLARE @InvoiceType VARCHAR(11)
DECLARE @ReversalType VARCHAR(11)

SET @MIN  = 1
SELECT @MAX = MAX(ID) FROM #TempData
PRINT @MAX

WHILE (@Min<=@MAX)
BEGIN
		
      PRINT @MIN
		
      SELECT @InvDate = INV_DATE, @FromClient = PartyCode, @ToClient = PartyCode, @RecordFor = RecordFor , @InvoiceType = InvoiceType, @ReversalType = ReversalType
	  FROM #TempData 
	  WHERE ID = @MIN
	
	  INSERT INTO #ValidateClientAmount	
	  EXEC USP_GSTREVESAL_POSTING_DATA @InvDate, @FromClient, @ToClient,'', @RecordFor, @InvoiceType, @ReversalType

	  SET @Min = @Min  + 1 

END


INSERT INTO #ErrorResult
SELECT PartyCode,  'Reversal Amount Can not be greater then Total Releasable Amount.' as ErrorMsg  --,A.ReversalAmount , B.ReleasableAmount 
FROM #TempData A
		INNER JOIN #ValidateClientAmount B
		ON A.PartyCode = B.PARTY_CODE
				AND  A.InvoiceNo = B.INV_NO	
WHERE  A.ReversalAmount > B.ReleasableAmount 



SELECT @@ERROR_COUNT = COUNT(1) FROM #ErrorResult 
          
 IF @@ERROR_COUNT > 0          
BEGIN          
  
   SELECT * FROM #ErrorResult 
          
   ROLLBACK TRAN  
   RETURN          
END     


INSERT INTO GSTReversal_Preprocess
SELECT A.PartyCode, branch_cd, @INV_DATE, A.InvoiceNo, A.RecordFor, A.InvoiceType, A.ReversalType, A.VDT, A.GLCode, 0, A.ReversalAmount, 
		A.Narration, 'P', @IsThirdParty, GETDATE(), @CreatedBy, NULL, NULL
FROM #TempData A
		INNER JOIN Client_Details  B
		ON A.PartyCode= B.cl_code
		

UPDATE A
SET TotalAmount = B.TAXABLE_AMT
FROM GSTReversal_Preprocess A
		INNER JOIN #ValidateClientAmount B
		ON A.PartyCode = B.PARTY_CODE 
				AND A.InvoiceNo = B.INV_NO	

SELECT 'Data Save Successfully..!'
/*

SELECT *
FROM GSTReversal_Preprocess
*/
COMMIT TRAN

END TRY

BEGIN CATCH

	SELECT 'ERROR IS : ' + ERROR_MESSAGE()
	ROLLBACK TRAN 

END CATCH
END
/*
SELECT * FROM #TempData
SELECT * FROM  #ValidateClientAmount
*/

--/*

 DROP TABLE #TempData
 DROP TABLE #ErrorResult
 DROP TABLE #ValidateClientAmount
 --*/
 END
 --*/

/*
SELECT * 
FROM TBL_GST_INVOICE_TMP
SELECT *
FROM #ValidateClientAmount	
*/
--	SELECT * FROM GSTReversal_Preprocess 13
/*
SELECT * FROM #ErrorResult
SELECT * FROM #TempData
*/

GO
