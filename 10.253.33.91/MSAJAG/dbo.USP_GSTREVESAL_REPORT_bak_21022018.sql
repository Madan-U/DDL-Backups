-- Object: PROCEDURE dbo.USP_GSTREVESAL_REPORT_bak_21022018
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------





--USP_GSTREVESAL_REPORT '0','z','','A','N'
--/*
create PROC [dbo].[USP_GSTREVESAL_REPORT_bak_21022018]
@FromClient varchar(20),
@ToClient varchar(20),
@Branch varchar(20),
@Status varchar(5),
@IsThirdparty CHAR,
@FromDate VARCHAR(12),
@ToDate VARCHAR(12),
@RetrieveType CHAR

AS
--*/
BEGIN
-- exec USP_GSTREVESAL_REPORT @FromClient='0',@ToClient='ZZ',@Branch='',@Status='ALL',@IsThirdparty='N',@FromDate='01/08/2017',@ToDate='28/08/2017',@RetrieveType='C'

/*
DECLARE @FromClient varchar(20)
DECLARE @ToClient varchar(20)
DECLARE @Branch varchar(20)
DECLARE @Status varchar(20)
DECLARE @IsThirdparty CHAR
DECLARE @FromDate VARCHAR(12)
DECLARE @ToDate VARCHAR(12)
DECLARE @RetrieveType CHAR


SET @FromClient = '0'
SET @ToClient ='ZZ'
SET @Branch = ''
SET @Status = 'ALL'
SET @IsThirdparty = 'N'
SET @FromDate = '01/08/2017'
SET @ToDate = '28/08/2017'
SET @RetrieveType = 'C'
*/


SET @Status = CASE WHEN @Status = 'ALL' THEN  NULL ELSE @Status END
SET @FromDate = CONVERT(DATETIME,@FromDate,103)
SET @ToDate = CONVERT(DATETIME,@ToDate,103)


SELECT PartyCode, long_name  as PartyName, branch_cd as Branch, CASE WHEN A.[status] = 'A' THEN 'Accepted' WHEN A.[status] = 'P' THEN 'Pending' ELSE 'Rejected' END AS [Status], InvoiceNo , RecordFor , InvoiceType ,ReversalType,VDT,GLCode,CONVERT(INT,ReversalAmount) as ReversalAmount,Narration,
	       CONVERT(VARCHAR(12),CreatedOn,101) as CreatedOn,CreatedBy, CONVERT(VARCHAR(12),ActionOn,101) as ActionOn, ActionBy ,remarks
FROM GSTReversal_Preprocess A
		INNER JOIN Client_Details B
		ON A.PartyCode = B.cl_code 
WHERE A.[status] = ISNULL(@Status,A.[status])
		AND (partycode BETWEEN @FromClient and @ToClient
					OR BRANCH = CASE WHEN @Branch = '' THEN NULL ELSE @Branch END )
		AND IsThirdparty = @IsThirdparty
		AND CASE WHEN @RetrieveType = 'C' THEN A.CreatedOn WHEN @RetrieveType = 'A' THEN ActionOn END  BETWEEN @FromDate AND @ToDate + '23:59:59'
END
/*
SELECT * FROM GSTReversal_Preprocess
*/

GO
