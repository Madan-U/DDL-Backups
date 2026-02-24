-- Object: PROCEDURE dbo.checkdate
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

-- Exec checkdate                   
CREATE PROC [DBO].[checkdate]                                                           
as

declare @SQL VARCHAR(200),
@PROCESS_DATE varchar(11),
@noofdays	int,
@start_date varchar(11)

                                             
SET @PROCESS_DATE = LEFT(GETDATE(),11) 
set @noofdays = 6

CREATE TABLE #SETT                                                          
(START_DATE VARCHAR(11))                                                          
                                                          
SELECT @SQL = 'INSERT INTO #SETT SELECT LEFT(MIN(START_DATE),11) AS START_DATE FROM ( '                                                          
SELECT @SQL = @SQL + ' SELECT TOP ' + CONVERT(VARCHAR,@NOOFDAYS) + ' * FROM MSAJAG.DBO.SETT_MST '                                                          
SELECT @SQL = @SQL + ' WHERE START_DATE <= ''' + LEFT(CONVERT(VARCHAR,@PROCESS_DATE),11) + ''''                                                          
SELECT @SQL = @SQL + ' AND SETT_TYPE = ''N'''                                                          
SELECT @SQL = @SQL + ' ORDER BY START_DATE DESC ) A'                                                         
          
EXEC (@SQL)                                                          
                        
SELECT @START_DATE = START_DATE FROM #SETT                                       
                                     
SELECT @START_DATE

GO
