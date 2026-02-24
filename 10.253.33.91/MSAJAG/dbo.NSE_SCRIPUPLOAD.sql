-- Object: PROCEDURE dbo.NSE_SCRIPUPLOAD
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE PROC [dbo].[NSE_SCRIPUPLOAD] (@FilePath Varchar(100), @ROWTERMINATOR VARCHAR(10)='\n') AS    
  
DECLARE @CO_CODE INT  
  
SELECT @CO_CODE = ISNULL(MAX(convert(Int,CO_CODE)),0) FROM SCRIP2  
  
TRUNCATE TABLE Scrip_IMP    
    
INSERT INTO Scrip_imp    
SELECT * FROM SCRIP_IMP_TMP  
WHERE SCRIP_CD NOT IN (SELECT SCRIP_CD FROM SCRIP2   
WHERE SCRIP2.SCRIP_CD = SCRIP_IMP_TMP.SCRIP_CD  
AND SCRIP2.SERIES = SCRIP_IMP_TMP.SERIES)  
AND SCRIP_CD <> ''  

Insert Into Company     
Select Sno+@CO_CODE, Left(SCRIP_NAME,20),SCRIP_NAME,'','','','','','','','','','','',''     
From Scrip_imp   
    
Insert Into Scrip1     
Select Sno+@CO_CODE, Series,Left(SCRIP_NAME,20),SCRIP_NAME,1,10,'','','','','EQ','EQ','','','Dec 31 2049','','','',''     
From Scrip_imp    
    
Insert Into Scrip2     
Select Sno+@CO_CODE,Series,'NSE',Scrip_CD,'HIG','','',
(CASE WHEN FILLER1 LIKE '%#%' THEN RIGHT(filler1,1) ELSE 0 END),
0,0,'',ISIN,'NRM','','','','','','','','','', '', '', '', '', '', '', 0, 
(CASE WHEN FILLER1 LIKE '%#%' THEN LEFT(filler1,LEN(FILLER1)-2) ELSE FILLER1 END), 
0, 0, 0, '', 0     
From Scrip_imp    
 
--UPDATE SCRIP2 SET STATUS = '3'

UPDATE SCRIP2 SET STATUS = (CASE WHEN T.FILLER1 LIKE '%#%' THEN LEFT(T.filler1,LEN(T.FILLER1)-2) ELSE T.FILLER1 END), 
CL_RATE = (CASE WHEN T.FILLER1 LIKE '%#%' THEN RIGHT(T.filler1,1) ELSE CL_RATE END)
FROM SCRIP_IMP_TMP T
WHERE  T.SCRIP_CD = SCRIP2.SCRIP_CD 
AND T.SERIES = SCRIP2.SERIES

EXEC PROC_MULTIISIN_EFF

GO
