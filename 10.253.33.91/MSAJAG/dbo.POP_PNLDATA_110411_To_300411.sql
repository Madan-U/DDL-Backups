-- Object: PROCEDURE dbo.POP_PNLDATA_110411_To_300411
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

 
CREATE PROC [dbo].[POP_PNLDATA_110411_To_300411]               
(              
 @FROMDATE VARCHAR(11),               
 @TODATE VARCHAR(11),              
 @FROMPARTY VARCHAR(10),               
 @TOPARTY VARCHAR(10)              
)              
              
AS                  
                  
DECLARE @SAUDA_DATE VARCHAR(11),                  
  @YY  INT,                   
  @MM  INT,                   
  @DD  INT,                  
  @DATECUR    CURSOR                  
                  
SET @DATECUR = CURSOR FOR        
                  
SELECT DISTINCT LEFT(Start_Date,11), YY=YEAR(Start_Date), MM=MONTH(Start_Date), DD=DAY(Start_Date)                   
FROM MSAJAG.DBO.Sett_Mst WHERE Start_Date BETWEEN @FROMDATE AND @TODATE + ' 23:59:59'              
And Sett_Type = 'N'            
ORDER BY 2, 3, 4                 
        
--SELECT * INTO BSECMBILLVALAN_PL            
--FROM ANAND.BSEDB_AB.DBO.CMBILLVALAN            
--WHERE SAUDA_DATE BETWEEN 'APR  1 2010' AND 'MAR 31 2011 23:59'        
--AND PARTY_CODE BETWEEN '0' AND 'ZZZZ'             
                                        
        
         
OPEN @DATECUR                  
FETCH NEXT FROM @DATECUR INTO @SAUDA_DATE, @YY, @MM, @DD                  
WHILE @@FETCH_STATUS = 0                  
BEGIN                  
 EXEC PROC_PNLPROCESS_110411_To_300411 @SAUDA_DATE, @FROMPARTY, @TOPARTY              
 FETCH NEXT FROM @DATECUR INTO @SAUDA_DATE, @YY, @MM, @DD                  
END                  
CLOSE @DATECUR                  
DEALLOCATE @DATECUR

GO
