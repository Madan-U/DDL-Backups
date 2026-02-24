-- Object: PROCEDURE dbo.V2_ACCOUNT_LISTING
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------



CREATE PROCEDURE V2_ACCOUNT_LISTING  
(  
    @FILTER VARCHAR(11), 
	@FROMPARTY VARCHAR(10), 
	@TOPARTY VARCHAR(10), 
	@STATUSID VARCHAR(20), 
	@STATUSNAME VARCHAR(20) 
)  
  
AS  
  
/*==============================================================================================================  
        EXEC V2_ACCOUNT_LISTING  
	    @FILTER = 'BRANCH', 
		@FROMPARTY = '0000000000', 
		@TOPARTY = 'ZZZZZZZZZZ', 
		@STATUSID = 'BROKER', 
		@STATUSNAME = 'BROKER' 
==============================================================================================================*/  
  
        SET NOCOUNT ON

		IF @FILTER = 'BRANCH' 
		BEGIN 
			SELECT DISTINCT 
				PARTY_CODE = BRANCH_CODE, 
				LONG_NAME = BRANCH 
			FROM MSAJAG.DBO.CLIENT_DETAILS C, 
				MSAJAG.DBO.BRANCH B 
			WHERE PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY 
					AND BRANCH_CD = BRANCH_CODE 
					AND @STATUSNAME = (   
							CASE 
									WHEN @STATUSID = 'BRANCH' 
									THEN C.BRANCH_CD 
									WHEN @STATUSID = 'SUBBROKER' 
									THEN C.SUB_BROKER 
									WHEN @STATUSID = 'TRADER' 
									THEN C.TRADER 
									WHEN @STATUSID = 'FAMILY' 
									THEN C.FAMILY 
									WHEN @STATUSID = 'AREA' 
									THEN C.AREA 
									WHEN @STATUSID = 'REGION' 
									THEN C.REGION 
									WHEN @STATUSID = 'CLIENT' 
									THEN C.PARTY_CODE 
									ELSE 'BROKER' END) 
		END

		IF @FILTER = 'FAMILY' 
		BEGIN 
			SELECT DISTINCT 
				PARTY_CODE, 
				LONG_NAME 
			FROM MSAJAG.DBO.CLIENT_DETAILS C 
			WHERE PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY 
					AND PARTY_CODE = FAMILY 
					AND @STATUSNAME = (   
							CASE 
									WHEN @STATUSID = 'BRANCH' 
									THEN C.BRANCH_CD 
									WHEN @STATUSID = 'SUBBROKER' 
									THEN C.SUB_BROKER 
									WHEN @STATUSID = 'TRADER' 
									THEN C.TRADER 
									WHEN @STATUSID = 'FAMILY' 
									THEN C.FAMILY 
									WHEN @STATUSID = 'AREA' 
									THEN C.AREA 
									WHEN @STATUSID = 'REGION' 
									THEN C.REGION 
									WHEN @STATUSID = 'CLIENT' 
									THEN C.PARTY_CODE 
									ELSE 'BROKER' END) 
		END

		IF @FILTER = 'CLIENT' 
		BEGIN
			SELECT 
				PARTY_CODE, 
				LONG_NAME 
			FROM MSAJAG.DBO.CLIENT_DETAILS C
			WHERE PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY 
					AND @STATUSNAME = (   
							CASE 
									WHEN @STATUSID = 'BRANCH' 
									THEN C.BRANCH_CD 
									WHEN @STATUSID = 'SUBBROKER' 
									THEN C.SUB_BROKER 
									WHEN @STATUSID = 'TRADER' 
									THEN C.TRADER 
									WHEN @STATUSID = 'FAMILY' 
									THEN C.FAMILY 
									WHEN @STATUSID = 'AREA' 
									THEN C.AREA 
									WHEN @STATUSID = 'REGION' 
									THEN C.REGION 
									WHEN @STATUSID = 'CLIENT' 
									THEN C.PARTY_CODE 
									ELSE 'BROKER' END) 
		END

GO
