-- Object: PROCEDURE dbo.CLS_Recon_NONCMS_SCB_Process_BAKDEC262016
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------



 CREATE PROCEDURE [dbo].[CLS_Recon_NONCMS_SCB_Process_BAKDEC262016] (@UPLOADID nvarchar(50), @UPLOAD_FLAG CHAR(1),@BANKCODE NVARCHAR(50) ) 
AS
BEGIN
       

--DECLARE @UPLOADID NVARCHAR(50) 
--SET @UPLOADID='35CBA453'


IF @UPLOAD_FLAG = 'B'
BEGIN
UPDATE MSAJAG.DBO.FILEDATA
SET FILE_DATA = ISNULL(.DBO.PIECE(FILE_DATA, '"', 1), '') + '' +
ISNULL(REPLACE(.DBO.PIECE(FILE_DATA, '"', 2), ',', ''), '') + '' +
ISNULL(.DBO.PIECE(FILE_DATA, '"', 3), '') + '' +
ISNULL(REPLACE(.DBO.PIECE(FILE_DATA, '"', 4), ',', ''), '') + '' +
ISNULL(.DBO.PIECE(FILE_DATA, '"', 5), '') + '' +
ISNULL(REPLACE(.DBO.PIECE(FILE_DATA, '"', 6), ',', ''), '') + '' +
ISNULL(.DBO.PIECE(FILE_DATA, '"', 7), '') + '' +
ISNULL(REPLACE(.DBO.PIECE(FILE_DATA, '"', 8), ',', ''), '') +
ISNULL(.DBO.PIECE(FILE_DATA, '"', 9), '') + '' +
ISNULL(REPLACE(.DBO.PIECE(FILE_DATA, '"', 10), ',', ''), '') +
ISNULL(.DBO.PIECE(FILE_DATA, '"', 11), '') + '' +
ISNULL(REPLACE(.DBO.PIECE(FILE_DATA, '"', 12), ',', ''), '') +
ISNULL(.DBO.PIECE(FILE_DATA, '"', 13), '') + '' +
ISNULL(REPLACE(.DBO.PIECE(FILE_DATA, '"', 14), ',', ''), '') + '' +
ISNULL(.DBO.PIECE(FILE_DATA, '"', 15), '') + '' +
ISNULL(REPLACE(.DBO.PIECE(FILE_DATA, '"', 16), ',', ''), '') + '' +
ISNULL(.DBO.PIECE(FILE_DATA, '"', 17), '') + '' +
ISNULL(REPLACE(.DBO.PIECE(FILE_DATA, '"', 18), ',', ''), '') + '' +
ISNULL(.DBO.PIECE(FILE_DATA, '"', 19), '') + '' +
ISNULL(REPLACE(.DBO.PIECE(FILE_DATA, '"', 20), ',', ''), '') + '' +
ISNULL(.DBO.PIECE(FILE_DATA, '"', 21), '') + '' +
ISNULL(REPLACE(.DBO.PIECE(FILE_DATA, '"', 22), ',', ''), '') + '' +
ISNULL(.DBO.PIECE(FILE_DATA, '"', 23), '') + '' +
ISNULL(REPLACE(.DBO.PIECE(FILE_DATA, '"', 24), ',', ''), '') + '' +
ISNULL(.DBO.PIECE(FILE_DATA, '"', 25), '') + '' +
ISNULL(REPLACE(.DBO.PIECE(FILE_DATA, '"', 26), ',', ''), '') + '' +
ISNULL(.DBO.PIECE(FILE_DATA, '"', 27), '') + '' +
ISNULL(REPLACE(.DBO.PIECE(FILE_DATA, '"', 28), ',', ''), '') + '' +
ISNULL(.DBO.PIECE(FILE_DATA, '"', 29), '') + '' +
ISNULL(REPLACE(.DBO.PIECE(FILE_DATA, '"', 30), ',', ''), '') + '' +
ISNULL(.DBO.PIECE(FILE_DATA, '"', 31), '') + '' +
ISNULL(REPLACE(.DBO.PIECE(FILE_DATA, '"', 32), ',', ''), '') + '' +
ISNULL(.DBO.PIECE(FILE_DATA, '"', 33), '')
WHERE PROGID = @UPLOADID
END

INSERT INTO #NONCMS_DATA
	SELECT
		U.UPLOADID
		,.dbo.piece(FILE_DATA, ',', 2) AS BANKACCOUNT
		, @BANKCODE AS BANKCODE
		,'' AS DESCRIPTION
		,'' AS LEDGERBALANCE
		,CASE
			WHEN.dbo.piece(FILE_DATA, ',', 16) = 'Credit' THEN 'C'
			ELSE 'D'
		END AS DRCR
		,CAST(.dbo.piece(FILE_DATA, ',', 32) AS DECIMAL(20, 2)) AS AMT
		,CONVERT(DATETIME,.DBO.PIECE(FILE_DATA, ',', 60), 105) AS VALUEDATE
		,.dbo.piece(FILE_DATA, ',', 30) AS REFERENCENO
		,'' AS CLTACCOUNT
		,'' AS CUSTOMERREFERENCE
		,'' AS TRANSACTIONDETAIL
		,'' AS VNO
		,'' AS VTYP
		,'' AS BOOKTYPE
		,0
		,U.UploadStatus
		,U.FILEUPLOAD_SDATE
		,GETDATE()
		,U.UPLOADBY
	FROM Recon_bank_FileUpload_logs U (NOLOCK)
	INNER JOIN MSAJAG.DBO.FILEDATA F (NOLOCK)
		ON U.UPLOADID = F.PROGID
	WHERE F.PROGID = @UPLOADID
	AND.dbo.piece(FILE_DATA, ',', 32) NOT IN (''
	, 'Transaction Amount')
END

GO
