-- Object: PROCEDURE dbo.CLS_RECON_CMS_YESBANK_BUSINESS_PROCESS_BAKMAR12017
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------





CREATE PROCEDURE [dbo].[CLS_RECON_CMS_YESBANK_BUSINESS_PROCESS_BAKMAR12017] (
--DECLARE
@UPLOADID NVARCHAR(50) 
,@UPLOAD_FLAG NVARCHAR(1)
,@BANKCODE NVARCHAR(20))

AS
BEGIN

DECLARE @FILENAME NVARCHAR(MAX)
SELECT @FILENAME=UPLOADFILENAME FROM RECON_BANK_FILEUPLOAD_LOGS WHERE UPLOADID=@UPLOADID
IF CHARINDEX('YESCMSBUSINESS', @FILENAME)=1
	BEGIN
	
		UPDATE MSAJAG..FILEDATA
		SET FILE_DATA =.dbo.Piece(FILE_DATA, '"', 1)
		+.dbo.Piece(FILE_DATA, '"', 2)
		+.dbo.Piece(FILE_DATA, '"', 3)
		+.dbo.Piece(FILE_DATA, '"', 4)
		+.dbo.Piece(FILE_DATA, '"', 5)
		+.dbo.Piece(FILE_DATA, '"', 6)
		+.dbo.Piece(FILE_DATA, '"', 7)
		+.dbo.Piece(FILE_DATA, '"', 8)
		+.dbo.Piece(FILE_DATA, '"', 9)
		+.dbo.Piece(FILE_DATA, '"', 10)
		+.dbo.Piece(FILE_DATA, '"', 11)
		+.dbo.Piece(FILE_DATA, '"', 12)
		+.dbo.Piece(FILE_DATA, '"', 13)
		+.dbo.Piece(FILE_DATA, '"', 14)
		+.dbo.Piece(FILE_DATA, '"', 15)
		+.dbo.Piece(FILE_DATA, '"', 16)
		+.dbo.Piece(FILE_DATA, '"', 17)
		+.dbo.Piece(FILE_DATA, '"', 18)
		+.dbo.Piece(FILE_DATA, '"', 13)
		+.dbo.Piece(FILE_DATA, '"', 20)
		+.dbo.Piece(FILE_DATA, '"', 21)
		+.dbo.Piece(FILE_DATA, '"', 22)
		+.dbo.Piece(FILE_DATA, '"', 23)
		+.dbo.Piece(FILE_DATA, '"', 24)
		+.dbo.Piece(FILE_DATA, '"', 25)
		+.dbo.Piece(FILE_DATA, '"', 26)
		+.dbo.Piece(FILE_DATA, '"', 27)
		+.dbo.Piece(FILE_DATA, '"', 28)
		+.dbo.Piece(FILE_DATA, '"', 29)
		+.dbo.Piece(FILE_DATA, '"', 30)
		+.dbo.Piece(FILE_DATA, '"', 31)
		+.dbo.Piece(FILE_DATA, '"', 32)
		+.dbo.Piece(FILE_DATA, '"', 33)
		+.dbo.Piece(FILE_DATA, '"', 34)
		+.dbo.Piece(FILE_DATA, '"', 35)
		+.dbo.Piece(FILE_DATA, '"', 36)
		+.dbo.Piece(FILE_DATA, '"', 37)
		+.dbo.Piece(FILE_DATA, '"', 38)
		+.dbo.Piece(FILE_DATA, '"', 39)
		+.dbo.Piece(FILE_DATA, '"', 40)
		+.dbo.Piece(FILE_DATA, '"', 41)
		+.dbo.Piece(FILE_DATA, '"', 42)
		+.dbo.Piece(FILE_DATA, '"', 43)
		+.dbo.Piece(FILE_DATA, '"', 44)
		+.dbo.Piece(FILE_DATA, '"', 45)
		+.dbo.Piece(FILE_DATA, '"', 46)
		WHERE PROGID = @UPLOADID
		AND .dbo.Piece(FILE_DATA,'"',1)<>''
		
			INSERT INTO #CMS_DATA
			SELECT
			RTRIM(LTRIM(U.UPLOADID))
			,RTRIM(LTRIM(@BANKCODE)) AS BANKCODE
			,RTRIM(LTRIM(REPLACE(.DBO.PIECE(REPLACE(FILE_DATA, '''', ''), ',', 2), '''', ''))) AS ROWTYPE
			,RTRIM(LTRIM(CONVERT(DATETIME, REPLACE(.DBO.PIECE(FILE_DATA, ',', 22), '''', ''), 105))) AS VALUEDATE
			,RTRIM(LTRIM(REPLACE(.DBO.PIECE(FILE_DATA, ',', 10), '''', ''))) AS DRCR
			,RTRIM(LTRIM(REPLACE(.DBO.PIECE(FILE_DATA, ',', 17), '''', ''))) AS INST_NO_CHECK
			,RTRIM(LTRIM(CAST(REPLACE(.DBO.PIECE(FILE_DATA, ',', 5), '''', '') AS DECIMAL(20, 2)))) AMT
			,RTRIM(LTRIM(REPLACE(.DBO.PIECE(FILE_DATA, ',', 23), '''', ''))) AS DRAWER_NAME
			,'' AS CLIENTID
			,'' AS CLTACC
			,'' AS VNO
			,'' AS VTYP
			,'' AS BOOKTYPE
			,0 AS MATCHEDFLAG
			,U.UPLOADSTATUS
			,U.FILEUPLOAD_SDATE
			,GETDATE()
			,F.UPLOADBY
			FROM RECON_BANK_FILEUPLOAD_LOGS U (NOLOCK)
			INNER JOIN FILEDATA_BANKRECO F (NOLOCK)
			ON U.UPLOADID = F.PROGID
			WHERE F.PROGID = @UPLOADID
			AND .dbo.Piece(FILE_DATA, ',', 1) <> ''
			AND.DBO.PIECE(FILE_DATA, ',', 22) <> 'VALUE_DATE'
			AND (.DBO.PIECE(FILE_DATA, ',', 2) LIKE '%CAP360%'
			OR.DBO.PIECE(FILE_DATA, ',', 2) LIKE '%NCDEX384%')
			

	END
	ELSE
	BEGIN
	SELECT 'FILE NAME SHOULD START WITH YESCMSBUSINESS ' 
	DELETE FROM RECON_BANK_UPLOAD_PROCESS_INFO WHERE UPLOADID=@UPLOADID			
	RETURN
	END

PRINT 'INSERTED TEMP TABLE'
END

GO
