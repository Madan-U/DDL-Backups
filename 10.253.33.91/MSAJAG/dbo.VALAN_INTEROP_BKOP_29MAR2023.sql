-- Object: PROCEDURE dbo.VALAN_INTEROP_BKOP_29MAR2023
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------







CREATE PROC [dbo].[VALAN_INTEROP_BKOP_29MAR2023]
(
	@SETT_NO	VARCHAR(7),
	@SETT_TYPE	VARCHAR(2)
)
AS

DECLARE @OTHER_SETT_TYPE VARCHAR(2),
		@OTHER_SETT_NO	VARCHAR(7),
		@Start_Date VARCHAR(11),
		@CLEARINGCODE	VARCHAR(10)

SELECT @Start_Date = START_DATE FROM SETT_MST WHERE Sett_No = @Sett_No And Sett_Type = @Sett_Type  


SELECT @CLEARINGCODE = ISNULL(CLEARINGCODE,'') FROM TBL_INTEROP_SETTING
WHERE  @START_DATE BETWEEN FROM_DATE AND TO_DATE

IF @CLEARINGCODE = ''
BEGIN
	RETURN
END
 
IF (SELECT ISNULL(COUNT(1),0) FROM TBL_INTEROP_SETT_TYPE WHERE NSE_SETT_TYPE = @Sett_Type AND @Start_Date BETWEEN FROM_DATE AND TO_DATE) > 0
BEGIN
	SELECT @OTHER_SETT_TYPE = BSE_SETT_TYPE FROM TBL_INTEROP_SETT_TYPE WHERE NSE_SETT_TYPE = @Sett_Type AND @Start_Date BETWEEN FROM_DATE AND TO_DATE
	
	SELECT @OTHER_SETT_NO = SETT_NO FROM [AngelBSECM].bsedb_ab.DBO.Sett_Mst Where Start_date >= @Start_Date and Start_date <= @Start_Date + ' 23:59' And Sett_Type = @OTHER_SETT_TYPE   
	
	DELETE FROM ACCBILL_ORG 
	Where Sett_No = @Sett_No And Sett_Type = @Sett_Type  
	
	INSERT INTO ACCBILL_ORG 
	SELECT * FROM ACCBILL 
	Where Sett_No = @Sett_No And Sett_Type = @Sett_Type 
	
	DELETE FROM ACCBILL 
	Where Sett_No = @Sett_No And Sett_Type = @Sett_Type   	

	DELETE FROM IACCBILL_ORG 
	Where Sett_No = @Sett_No And Sett_Type = @Sett_Type  
	
	INSERT INTO IACCBILL_ORG 
	SELECT * FROM ACCBILL 
	Where Sett_No = @Sett_No And Sett_Type = @Sett_Type 
	
	DELETE FROM IACCBILL 
	Where Sett_No = @Sett_No And Sett_Type = @Sett_Type  
	
	IF @CLEARINGCODE = 'ICCL'   
	BEGIN
		UPDATE ACCBILL_ORG SET PARTY_CODE = B.ACCODE FROM MSAJAG.DBO.ValanAccount N, [AngelBSECM].bsedb_ab.DBO.ValanAccount B
		Where Sett_No = @Sett_No And Sett_Type = @Sett_Type  
		AND N.AcName = 'Clearing House'
		AND B.AcName = 'Clearing House'
		AND B.AcCode = PARTY_CODE
		
		UPDATE ACCBILL_ORG SET PARTY_CODE = B.ACCODE FROM MSAJAG.DBO.ValanAccount N, [AngelBSECM].bsedb_ab.DBO.ValanAccount B
		Where Sett_No = @Sett_No And Sett_Type = @Sett_Type  
		AND N.AcName = 'Rounding Off'
		AND B.AcName = 'Rounding Off'
		AND B.AcCode = PARTY_CODE

		UPDATE IACCBILL_ORG SET PARTY_CODE = B.ACCODE FROM MSAJAG.DBO.ValanAccount N, [AngelBSECM].bsedb_ab.DBO.ValanAccount B
		Where Sett_No = @Sett_No And Sett_Type = @Sett_Type  
		AND N.AcName = 'Clearing House'
		AND B.AcName = 'Clearing House'
		AND B.AcCode = PARTY_CODE
		
		UPDATE IACCBILL_ORG SET PARTY_CODE = B.ACCODE FROM MSAJAG.DBO.ValanAccount N, [AngelBSECM].bsedb_ab.DBO.ValanAccount B
		Where Sett_No = @Sett_No And Sett_Type = @Sett_Type  
		AND N.AcName = 'Rounding Off'
		AND B.AcName = 'Rounding Off'
		AND B.AcCode = PARTY_CODE			 
	END
	ELSE
	BEGIN
		SELECT * INTO #ACC_OP FROM ACCBILL_ORG
		Where Sett_No = @Sett_No And Sett_Type = @Sett_Type  
		
		INSERT INTO #ACC_OP 
		SELECT * FROM [AngelBSECM].bsedb_ab.DBO.ACCBILL_ORG
		Where Sett_No = @OTHER_Sett_No And Sett_Type = @OTHER_SETT_TYPE  
		
		print 'bb'
		INSERT INTO ACCBILL  
		SELECT Party_Code,Bill_No,
		Sell_Buy=(CASE WHEN SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE -AMOUNT END) > 0 THEN 1 ELSE 2 END),
		Sett_No=@SETT_NO,Sett_Type=@SETT_TYPE,
		Start_Date=MAX(Start_Date),End_Date=MAX(End_Date),
		PayIn_Date=MAX(PayIn_Date),PayOut_Date=MAX(PayOut_Date),
		Amount=ABS(SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE -AMOUNT END)),
		branchCd,narration=MAX(narration)
		FROM #ACC_OP 
		WHERE PARTY_CODE NOT IN (SELECT CL_CODE FROM CLIENT1 WHERE CL_TYPE = 'NRI')
		GROUP BY Party_Code,Bill_No,branchCd

		INSERT INTO ACCBILL  
		SELECT Party_Code,Bill_No,
		Sell_Buy=(CASE WHEN SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE -AMOUNT END) > 0 THEN 1 ELSE 2 END),
		Sett_No=@SETT_NO,Sett_Type=@SETT_TYPE,
		Start_Date=MAX(Start_Date),End_Date=MAX(End_Date),
		PayIn_Date=MAX(PayIn_Date),PayOut_Date=MAX(PayOut_Date),
		Amount=ABS(SUM(CASE WHEN SELL_BUY = 1 THEN AMOUNT ELSE -AMOUNT END)),
		branchCd,narration=MAX(narration)
		FROM #ACC_OP 
		WHERE PARTY_CODE IN (SELECT CL_CODE FROM CLIENT1 WHERE CL_TYPE = 'NRI')
		GROUP BY Party_Code,Bill_No,branchCd, SELL_BUY
	END
END

GO
