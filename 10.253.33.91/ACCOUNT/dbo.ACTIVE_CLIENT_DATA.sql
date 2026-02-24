-- Object: PROCEDURE dbo.ACTIVE_CLIENT_DATA
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

---sp_helptext ACTIVE_CLIENT_DATA  'jul 31 2019','jul 31 2019'



 
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--ACTIVE_CLIENT_DATA '12/09/2018','14/09/2018'                           

CREATE PROC [dbo].[ACTIVE_CLIENT_DATA]
 (
@FROMDATE VARCHAR(11), 
@TODATE   VARCHAR(11)) 

AS 

IF Len(@FROMDATE) = 10 

AND Charindex('/', @FROMDATE) > 0 

BEGIN 

SET @FROMDATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @FROMDATE, 103) , 109) 

END 



IF Len(@TODATE) = 10 

AND Charindex('/', @TODATE) > 0 

BEGIN 

SET @TODATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @TODATE, 103),  109) 

END 

 
PRINT @FROMDATE 



BEGIN 

SELECT * 

INTO   #temp 

FROM   (SELECT  [cl_code]=[L1].cl_code, 

[long_name] =L.long_name, 
[exchange] =L1.exchange, 

[segment]=L1.segment, 
CONVERT(VARCHAR(11), CONVERT(DATETIME, L1.active_date, 103), 103)   AS active_date,
CONVERT(VARCHAR(11), CONVERT(DATETIME, L1.inactive_from, 103), 103)   AS inactive_from,
[Deactive_Remarks]=replace(replace(replace(replace(replace(replace(replace(replace(replace(REPLACE(Replace(LEFT(Replace(Ltrim(Rtrim(L1.Deactive_Remarks)), '"', '' ),100), ',',''),'|', ''),'{',''),'}',''),'''',''),'#', ''),'_', ''),'/', '

'),':', ''),'-', ''),'.', ''),					 
[Deactive_VALUE] = L1.Deactive_value                    

FROM   msajag..Client_Details L (nolock), 

msajag..client_brok_details L1 (nolock) 

WHERE  L1.cl_code=L.CL_CODE AND L1.Deactive_value NOT IN ('P')

AND L1.Active_Date>=@FROMDATE AND L1.Active_Date<=@TODATE + ' 23:59')A             

              

SELECT  DISTINCT * FROM #TEMP ORDER BY CL_CODE
                                        

END

GO
