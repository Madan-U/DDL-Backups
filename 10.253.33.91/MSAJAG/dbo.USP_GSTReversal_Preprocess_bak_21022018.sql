-- Object: PROCEDURE dbo.USP_GSTReversal_Preprocess_bak_21022018
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------




--exec USP_GSTReversal_Preprocess @StrData='WXBPANKA~MH01/LC/D0000001~20000.00~HO~10~dsd',@INV_DATE='June 2017',@ReversalType='Exclusive',@VDT='15/08/2017',@RECORDFOR='LEDGER',@InvoiceType='DEBIT',@GLCode='61310',@CreatedBy='61310',@IDThirdparty ='N'
CREATE PROC [dbo].[USP_GSTReversal_Preprocess_bak_21022018]
(
	--@PartyCode VARCHAR(12),
	@StrData VARCHAR(MAX),
	@INV_DATE VARCHAR(25),
	--@InvoiceNo VARCHAR(12),
	@RecordFor VARCHAR(20),
	@InvoiceType VARCHAR(20),
	@ReversalType VARCHAR(20),
	@VDT  VARCHAR(20),
	@GLCode VARCHAR(20),
	--@TotalAmount MONEY,
	--@ReversalAmount MONEY,
	--@Narration VARCHAR(100),
	@CreatedBy VARCHAR(20),
	@IDThirdparty CHAR
)
AS

--SELECT * FROM GSTReversal_Preprocess

BEGIN
BEGIN TRY

DECLARE @ChkInvoiveType VARCHAR(20)
SET @ChkInvoiveType = CASE WHEN @IDThirdparty = 'N' THEN @InvoiceType ELSE .DBO.Piece(@StrData,'~',7) END


			INSERT INTO GSTReversal_Preprocess
			(PartyCode,Branch,INV_DATE,InvoiceNo,RecordFor,InvoiceType,ReversalType,VDT,GLCode,TotalAmount,ReversalAmount,Narration,[Status],IsThirdParty,CreatedOn,CreatedBy)
			SELECT .DBO.Piece(@StrData,'~',1), .DBO.Piece(@StrData,'~',4) , @INV_DATE, .DBO.Piece(@StrData,'~',2) ,@RecordFor, @ChkInvoiveType, @ReversalType, @VDT, @GLCode,
					.DBO.Piece(@StrData,'~',3) ,.DBO.Piece(@StrData,'~',5) ,.DBO.Piece(@StrData,'~',6)  , 'P', @IDThirdparty, getdate(), @CreatedBy
			
			
			--VALUES(@PartyCode, @Branch, @Month, @InvoiceNo, @RecordFor, @InvoiceType, @ReversalType, @VDT, @GLCode, @TotalAmount, @ReversalAmount, @Narration,'P',GETDATE(), @CreatedBy)	
		
			SELECT 'Data Save Successfully..!'

END TRY
BEGIN CATCH

		SELECT 'Error is:' + ERROR_MESSAGE()

END CATCH			


END

-- SELECT * FROM GSTReversal_Preprocess

GO
