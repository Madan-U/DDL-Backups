-- Object: PROCEDURE dbo.USP_GSTReversal_Action_Wrapper
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



-- USP_GSTReversal_Action_Wrapper '41~42~43~44~45','A','Lucky'

CREATE PROC [dbo].[USP_GSTReversal_Action_Wrapper]
@STR VARCHAR(20),
@ACTION CHAR,
@ACTIONBY VARCHAR(20),
@Remarks VARCHAR(300)

AS
/*
DECLARE @STR VARCHAR(20)
DECLARE @ACTION CHAR
DECLARE @ACTIONBY VARCHAR(20)

SET @STR = '12~13'
SET @ACTION = 'R'
SET @ACTIONBY = 'Badrish' 
*/
BEGIN

		 SELECT *  
		 INTO #Remarks
		 FROM .dbo.fn_Split(@Remarks,'~')
         
		 SELECT SUBSTRING(Value,0,charindex('$',value)) as SrNo,  
				SUBSTRING(Value,charindex('$',value)+1,300) as Remarks  
		 INTO #FinalRemarks
		 FROM #Remarks



IF (@ACTION = 'R')
BEGIN

		 UPDATE GSTReversal_Preprocess
		 SET [Status] = @ACTION, ActionBy = @ACTIONBY, ActionOn = GETDATE()
		 WHERE Srno IN (SELECT Value  FROM .dbo.fn_Split(@Str,'~'))
		 
		 

		 UPDATE A
		 SET A.Remarks = B.Remarks
		 FROM GSTReversal_Preprocess A
				INNER JOIN #FinalRemarks B
				ON A.SrNo = B.SrNo


		 SELECT 'Entry Rejected Successfully..!'

END
ELSE IF (@ACTION = 'A')

BEGIN

TRUNCATE TABLE Account..GST_REVERSAL_OutputData

	DECLARE @MIN INT
	DECLARE @MAX INT
	DECLARE @Value INT
	
	DECLARE @INV_DATE  VARCHAR(25)
	DECLARE @PARTY_CODE  VARCHAR(11)
	DECLARE @INV_NO  VARCHAR(25)
	DECLARE @RECORDFOR  VARCHAR(20)
	DECLARE @INVOICE_TYPE VARCHAR(20)
	DECLARE @REV_AMOUNT MONEY
	DECLARE @VDT VARCHAR(12)
	DECLARE @GL_CODE VARCHAR(20)
	DECLARE @NARRATION VARCHAR(500)
	DECLARE @UNAME VARCHAR(20)
	DECLARE @ReversalType VARCHAR(20)
	DECLARE @BranchCode  VARCHAR(20)
	DECLARE @RemarksData VARCHAR(300)


	SET @MIN  = 1
	SELECT @MAX = position FROM .dbo.fn_Split(@Str,'~')


	WHILE (@Min<=@MAX)
	BEGIN
			 SET @Value = ''

			 SELECT @Value = Value 
			 FROM .dbo.fn_Split(@Str,'~')
			 WHERE position = @Min 		
		
		 
			 SELECT @INV_DATE = INV_DATE, @PARTY_CODE = PartyCode, @INV_NO = InvoiceNo, @RECORDFOR =RECORDFOR , @INVOICE_TYPE = INVOICETYPE, @REV_AMOUNT = ReversalAmount,
					@VDT = VDT, @GL_CODE = GLCode , @NARRATION = NARRATION , @UNAME = CreatedBy, @ReversalType = ReversalType , @BranchCode = Branch
			 FROM GSTReversal_Preprocess
			 WHERE Srno = @Value

			 SELECT @RemarksData = Remarks
			 FROM #FinalRemarks
			 WHERE Srno = @Value 
		 

			 EXEC ACCOUNT.DBO.GST_REVESAL_POSTING 
					@INV_DATE = @INV_DATE,
					@PARTY_CODE = @PARTY_CODE , 
					@INV_NO = @INV_NO , 
					@RECORDFOR = @RECORDFOR , 
					@INVOICE_TYPE = @INVOICE_TYPE , 
					@REV_AMOUNT = @REV_AMOUNT, 
					@VDT = @VDT , 
					@GL_CODE = @GL_CODE , 
					@NARRATION = @NARRATION , 
					@UNAME = @UNAME ,
					@ReversalType = @ReversalType ,
					@BranchCode  =@BranchCode  ,
					@SrNO = @Value,
				    @ACTIONBY = @ACTIONBY,
					@Remarks = @RemarksData


			 --UPDATE GSTReversal_Preprocess
			 --SET [Status] = @ACTION, ActionBy = @ACTIONBY, ActionOn = GETDATE()
			 --WHERE Srno = @Value

		
			SET @Min = @Min  + 1 
	END

	SELECT Result as '**** Output Summary ****' FROM Account..GST_REVERSAL_OutputData

--	SELECT 'Entry Accepted Successfully..!'
END
END
/*
SELECT *  FROM GSTReversal_Preprocess 
SELECT * FROM ACCOUNT.DBO.GST_REVERSAL_ENTRY_DETAILS 
SELECT * FROM ACCOUNT.DBO.JV_CN_DN_DETAILS 


delete ACCOUNT.DBO.GST_REVERSAL_ENTRY_DETAILS where narration like 'narr%'
delete  ACCOUNT.DBO.JV_CN_DN_DETAILS 
*/

GO
