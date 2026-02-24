-- Object: PROCEDURE dbo.USP_GSTReversal_GetPreprocessData
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



-- USP_GSTReversal_GetPreprocessData '','','HO','June 2017','Y'

CREATE proc [dbo].[USP_GSTReversal_GetPreprocessData]
@FromClient varchar(20),
@ToClient varchar(20),
@Branch varchar(20),
@INV_DATE varchar(20),
@IsThirdparty CHAR
AS
begin

	SELECT SrNo,PartyCode,InvoiceNo + '/' + RecordFor + '/'  + InvoiceType as InvoiceDetails,ReversalType,VDT,GLCode,CONVERT(DECIMAL(18,2),ReversalAmount) as ReversalAmount,Narration,
			CONVERT(VARCHAR(12),CreatedOn,101) as CreatedOn,CreatedBy, IsThirdparty
	FROM GSTReversal_Preprocess
	WHERE [status] = 'P'
		AND INV_DATE = CASE WHEN @IsThirdparty = 'N' THEN  @INV_DATE ELSE '' END 
		AND (partycode BETWEEN @FromClient and @ToClient
					OR BRANCH = CASE WHEN @Branch = '' THEN NULL ELSE @Branch END )
		AND IsThirdparty = @IsThirdparty
end

GO
