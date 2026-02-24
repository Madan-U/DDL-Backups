-- Object: PROCEDURE dbo.BILLPOSTING
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


CREATE PROCEDURE [dbo].[BILLPOSTING]
(
	@SETT_NO VARCHAR(7),                      
    @SETT_TYPE VARCHAR(3),
    @BILL_DATE VARCHAR(11),
	@EXCHANGE	varchar(5)
)
AS

DECLARE
	@VNO VARCHAR(12),
	@VDT VARCHAR(11),
	@EDTDR VARCHAR(11),                      
    @EDTCR VARCHAR(11),                      
    @CDT VARCHAR(11),                      
    @PDT VARCHAR(11),                      
    @UNAME VARCHAR(25),                       

    @OVNO VARCHAR(12),                
	@NARR VARCHAR(20),
	@REC_COUNT INT

DECLARE
		@@SDTCUR VARCHAR(11),
		@@LDTCUR VARCHAR(11)
		
	SELECT @@SDTCUR = CONVERT(VARCHAR(11), SDTCUR, 109), @@LDTCUR = CONVERT(VARCHAR(11), LDTCUR, 109)
	FROM PARAMETER WHERE @BILL_DATE BETWEEN SDTCUR AND LDTCUR
	
	SELECT @CDT = CONVERT(VARCHAR(11), GETDATE(), 109), @PDT = CONVERT(VARCHAR(11), GETDATE(), 109)
	
SELECT @UNAME = 'AUTOPROCESS'

IF @EXCHANGE = 'BSE' 
	SET @EXCHANGE = 'BSECM'

IF @EXCHANGE = 'NSE' 
	SET @EXCHANGE = 'NSECM'

SET @OVNO = ''

SELECT @OVNO = VNO, @VNO = VNO, @EDTDR = CONVERT(VARCHAR(11), EDTDR, 109), @EDTCR = CONVERT(VARCHAR(11), EDTCR, 109) FROM BILLPOSTED 
WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE AND VTYP = 15

IF @OVNO = ''
BEGIN

	
	CREATE TABLE #VNO
	(
		LASTVNO VARCHAR(12)
	)

	INSERT INTO #VNO
	EXEC ACC_GENVNO_NEW @BILL_DATE, 15, '01', @@SDTCUR, @@LDTCUR, 1

	SELECT @VNO = LASTVNO FROM #VNO
	IF @EXCHANGE = 'NSE' OR  @EXCHANGE = 'NSECM' 
	BEGIN
		SELECT @EDTDR = CONVERT(VARCHAR(11), FUNDS_PAYIN, 109), @EDTCR = CONVERT(VARCHAR(11), FUNDS_PAYIN, 109) FROM MSAJAG.DBO.SETT_MST
		WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE
	END
	IF @EXCHANGE = 'BSECM' 
	BEGIN
		SELECT @EDTDR = CONVERT(VARCHAR(11), FUNDS_PAYIN, 109), @EDTCR = CONVERT(VARCHAR(11), FUNDS_PAYIN, 109) FROM MSAJAG.DBO.SETT_MST
		WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE		
	END

END

EXEC [NEWPOSTBILL]   
      15,                      
      '01',                      
      @VNO,                      
      @BILL_DATE,                      
      @EDTDR,                      
      @EDTCR,                      
      @CDT,                      
      @PDT,                      
      @UNAME,                      
      @UNAME,                      
      @SETT_NO,                      
      @SETT_TYPE,                      
      @UNAME,                       
      @EXCHANGE,                     
      @OVNO
      --,@EXCHANGE


IF @EXCHANGE = 'NSE' OR  @EXCHANGE = 'NSECM' 
BEGIN 
	SET @OVNO = ''

	SELECT @OVNO = VNO, @VNO = VNO, @EDTDR = CONVERT(VARCHAR(11), EDTDR, 109), @EDTCR = CONVERT(VARCHAR(11), EDTCR, 109) FROM BILLPOSTED 
	WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE AND VTYP = 21

	IF @OVNO = ''
	BEGIN
			
		SELECT @@SDTCUR = CONVERT(VARCHAR(11), SDTCUR, 109), @@LDTCUR = CONVERT(VARCHAR(11), LDTCUR, 109)
		FROM PARAMETER WHERE @BILL_DATE BETWEEN SDTCUR AND LDTCUR

		CREATE TABLE #VNO1
		(
			LASTVNO VARCHAR(12)
		)

		INSERT INTO #VNO1
		EXEC ACC_GENVNO_NEW @BILL_DATE, 21, '01', @@SDTCUR, @@LDTCUR, 1

		SELECT @VNO = LASTVNO FROM #VNO1
		IF @EXCHANGE = 'NSE' OR  @EXCHANGE = 'NSECM' 
		BEGIN
			SELECT @EDTDR = CONVERT(VARCHAR(11), FUNDS_PAYIN, 109), @EDTCR = CONVERT(VARCHAR(11), FUNDS_PAYIN, 109) FROM MSAJAG.DBO.SETT_MST
			WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE
		END
		IF @EXCHANGE = 'BSECM' 
		BEGIN
			SELECT @EDTDR = CONVERT(VARCHAR(11), FUNDS_PAYIN, 109), @EDTCR = CONVERT(VARCHAR(11), FUNDS_PAYIN, 109) FROM MSAJAG.DBO.SETT_MST
			WHERE SETT_NO = @SETT_NO AND SETT_TYPE = @SETT_TYPE		
		END
	END

	EXEC [NEWPOSTBILL]   
		  21,                      
		  '01',                      
		  @VNO,                      
		  @BILL_DATE,                      
		  @EDTDR,                      
		  @EDTCR,                      
		  @CDT,                      
		  @PDT,                      
		  @UNAME,                      
		  @UNAME,      
		  @SETT_NO,                      
		  @SETT_TYPE,                      
		  @UNAME,                       
		  @EXCHANGE,                     
		  @OVNO
		  --,@EXCHANGE
END

GO
