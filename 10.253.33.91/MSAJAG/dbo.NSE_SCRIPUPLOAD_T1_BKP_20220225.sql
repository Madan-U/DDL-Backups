-- Object: PROCEDURE dbo.NSE_SCRIPUPLOAD_T1_BKP_20220225
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROC [dbo].[NSE_SCRIPUPLOAD_T1_BKP_20220225] (@FilePath Varchar(100), @ROWTERMINATOR VARCHAR(10)='\n') AS      
    
DECLARE @CO_CODE INT    
    
SELECT @CO_CODE = ISNULL(MAX(CONVERT(INT,CO_CODE)),0) FROM SCRIP2    
    
TRUNCATE TABLE Scrip_IMP      
      
INSERT INTO Scrip_imp      
SELECT * FROM SCRIP_IMP_TMP    
WHERE SCRIP_CD NOT IN (SELECT SCRIP_CD FROM SCRIP2     
WHERE SCRIP2.SCRIP_CD = SCRIP_IMP_TMP.SCRIP_CD    
AND SCRIP2.SERIES = SCRIP_IMP_TMP.SERIES)    
AND SCRIP_CD <> ''    
/*
INSERT INTO Scrip_imp  
SELECT DISTINCT SCRIP_CD, SERIES, SCRIP_CD, '', ISIN FROM BAK_SCRIP2 
WHERE SCRIP_CD NOT IN (SELECT SCRIP_CD FROM Scrip_imp S2 
WHERE S2.SCRIP_CD = BAK_SCRIP2.SCRIP_CD 
AND BAK_SCRIP2.SERIES = S2.SERIES)
AND SCRIP_CD NOT IN (SELECT SCRIP_CD FROM SCRIP2     
WHERE SCRIP2.SCRIP_CD = BAK_SCRIP2.SCRIP_CD    
AND SCRIP2.SERIES = BAK_SCRIP2.SERIES)    
AND SCRIP_CD <> ''  
*/      
Insert Into Company       
Select Sno+@CO_CODE, Left(SCRIP_NAME,20),SCRIP_NAME,'','','','','','','','','','','',''       
From Scrip_imp     
      
Insert Into Scrip1       
Select Sno+@CO_CODE, Series,Left(SCRIP_NAME,20),SCRIP_NAME,1,10,'','','','','EQ','EQ','','','Dec 31 2049','','','',''       
From Scrip_imp      
      
Insert Into Scrip2       
Select Sno+@CO_CODE,Series,'NSE',Scrip_CD,'HIG','','',0,0,0,'','','NRM','','','','','','','','','', '', '', '', '', '', '', 0, '', 0, 0, 0, '', 0       
From Scrip_imp      
  
UPDATE SCRIP1 
SET LONG_NAME = I.SCRIP_NAME, 
    SHORT_NAME = LEFT(I.SCRIP_NAME,20)  
FROM SCRIP2 S2, SCRIP_IMP_TMP I  
WHERE S2.SCRIP_CD = I.SCRIP_CD    
AND S2.SERIES = I.SERIES  
AND SCRIP1.CO_CODE = S2.CO_CODE   
AND SCRIP1.SERIES = S2.SERIES

GO
