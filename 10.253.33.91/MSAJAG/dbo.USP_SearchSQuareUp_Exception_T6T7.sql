-- Object: PROCEDURE dbo.USP_SearchSQuareUp_Exception_T6T7
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

-- USP_SearchSQuareUp_Exception_T6T7 'BRANCH','%','Branch','CHEN','ALL'
CREATE proc USP_SearchSQuareUp_Exception_T6T7

@AccessLevel varchar(20),
@AccessCode varchar(20),
@Access_to varchar(20),
@Access_Code varchar(20)
-- ,@SQ_OFF_TYPE VARCHAR(20)

AS
BEGIN
DECLARE @Main AS NVARCHAR(MAX)

-- IF(@SQ_OFF_TYPE ='ALL')
--SET @SQ_OFF_TYPE ='%'

SET @Main = ' '

SET @Main = @Main + ' SELECT ExceptionId,AccessLevel,AccessCode'
SET @Main = @Main + ' ,ValidFrom = CONVERT(VARCHAR(11),ValidFrom,106),ValidTo = CONVERT(VARCHAR(11),ValidTo,106)'
SET @Main = @Main + ' ,Status,CreateDt,CreateBy,SQ_OFF_TYPE,Remarks FROM SQuareUp_Exception_T6T7 '

if UPPER(@AccessLevel) ='REGION'
SET @Main = @Main + ' WHERE AccessLevel ='''+@AccessLevel+''' and AccessCode like '''+@AccessCode+''' ' -- AND SQ_OFF_TYPE like ''' + @SQ_OFF_TYPE + ''' '
else if UPPER(@AccessLevel) = 'BRANCH'
SET @Main = @Main + ' WHERE AccessLevel ='''+@AccessLevel+''' and AccessCode like '''+@AccessCode+''' ' --AND SQ_OFF_TYPE like ''' + @SQ_OFF_TYPE + ''' '
else if UPPER(@AccessLevel) = 'SB'
SET @Main = @Main + ' WHERE AccessLevel ='''+@AccessLevel+''' and AccessCode like '''+@AccessCode+''' ' -- AND SQ_OFF_TYPE like ''' + @SQ_OFF_TYPE + ''' '
else if UPPER(@AccessLevel) = 'CLIENT'
SET @Main = @Main + ' WHERE AccessLevel ='''+@AccessLevel+''' and AccessCode like '''+@AccessCode+''' '-- AND SQ_OFF_TYPE like ''' + @SQ_OFF_TYPE + ''' '

IF @Access_to = 'REGIONMAST'
SET @Main = @Main + ' and AccessLevel in (select Accesscode from tbl_RMS_GroupMaster where groupcode= '''+@access_code+''') ' -- AND SQ_OFF_TYPE like ''' + @SQ_OFF_TYPE + ''' '
ELSE IF @Access_to = 'BRMAST'
SET @Main = @Main + ' and AccessLevel in (select Accesscode from tbl_RMS_GroupMaster where groupcode= '''+@access_code+''') ' -- AND SQ_OFF_TYPE like ''' + @SQ_OFF_TYPE + ''' '
ELSE IF @Access_to = 'BROKER'
SET @Main = @Main + ' '
ELSE
SET @Main = @Main + ' and AccessLevel like '''+@Access_to+''' and AccessCode like '''+@access_code+''' '
SET @Main = @Main + ' ORDER BY Createdt DESC '
print @Main
EXECUTE sp_executesql @Main

END

GO
