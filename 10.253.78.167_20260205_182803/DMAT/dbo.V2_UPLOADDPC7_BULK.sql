-- Object: PROCEDURE dbo.V2_UPLOADDPC7_BULK
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE PROC [dbo].[V2_UPLOADDPC7_BULK](            
         @FNAME VARCHAR(200),            
         @UNAME VARCHAR(50))             
            
AS            
/*            
EXEC V2_UPLOADDPC7_BULK 'C:\BulkInsDbfolder\DPM DPC7(FREE BALANCE)-CDSL FILE\08DPC7U.901723',''     
      
*/            
SET NOCOUNT ON             
            
DECLARE              
 @ROWDATA  VARCHAR(2000),            
 @FILEDATA CURSOR,            
 @@SQL VARCHAR(1000)            
            
 CREATE TABLE #TMP            
 (            
  FLDDETAILS VARCHAR(1000)            
 )            
            
 CREATE TABLE #TMP_1            
 (            
  SNO        INT IDENTITY(1,1) NOT NULL,             
  FLDDETAILS VARCHAR(1000),             
  CLTDPID    VARCHAR(16),          
CONSTRAINT [IDX_SNO_A] PRIMARY KEY CLUSTERED           
(          
 SNO ASC          
)               
 )            
            
CREATE NONCLUSTERED INDEX [IDX_CLTDPID] ON [DBO].[#TMP_1]           
(          
 [CLTDPID]          
)          
          
 CREATE TABLE #TMP_2           
 (            
  SNO        INT,             
  CLTDPID    VARCHAR(16),          
CONSTRAINT [IDX_SNO_2] PRIMARY KEY CLUSTERED           
(          
 SNO ASC          
)                  
 )            
          
 CREATE TABLE #DPC7            
 (            
  SNO        INT IDENTITY(1,1) NOT NULL,             
  RECTYPE    VARCHAR(2),             
  ISIN       VARCHAR(12),          
  CURRQUANTITY VARCHAR(50),            
  FREEQUANTITY VARCHAR(50),             
  EARMARKQUANTITY VARCHAR(50),          
  PLEDGEQUANTITY VARCHAR(50),          
  REMLOCQUANTITY VARCHAR(50),          
  SCRIP_NAME1   VARCHAR(50),             
  SCRIP_NAME2   VARCHAR(100),             
  SCRIP_NAME3   VARCHAR(150),             
  FILLER1       VARCHAR(10),          
  FILLER2       VARCHAR(10),          
  FILLER3       VARCHAR(10),          
  FILLER4       VARCHAR(10),          
  FILLER5       VARCHAR(10),          
  FILLER6       VARCHAR(10),
  SETTNO     VARCHAR(13),          
  CLTDPID    VARCHAR(16)            
 )            
            
 SELECT @@SQL = 'BULK INSERT #TMP FROM '''+ @FNAME + ''' WITH (FIRSTROW = 1) '            
 EXEC(@@SQL)            
  
 ALTER TABLE #TMP           
 ADD SNO INT IDENTITY(1,1) NOT NULL  
        
  DELETE FROM #TMP             
  WHERE  FLDDETAILS NOT LIKE '01%'            
         AND FLDDETAILS NOT LIKE '04%' 

   SELECT @@SQL = 'INSERT INTO #TMP_1 (FLDDETAILS, CLTDPID)'  
   SELECT @@SQL = @@SQL + 'SELECT         '  
   SELECT @@SQL = @@SQL + 'FLDDETAILS,    '  
   SELECT @@SQL = @@SQL + 'CLTDPID = (CASE WHEN FLDDETAILS LIKE ''01%'' THEN SUBSTRING(FLDDETAILS,4,8) + SUBSTRING(FLDDETAILS,13,8) ELSE '''' END)'          
  SELECT @@SQL = @@SQL + ' FROM   #TMP ORDER BY SNO'  
PRINT  @@SQL  
EXEC(@@SQL)     
         
 INSERT INTO #TMP_2           
 SELECT SNO, CLTDPID            
 FROM   #TMP_1            
 WHERE  CLTDPID <> ''          
          
  UPDATE #TMP_1             
  SET    #TMP_1.FLDDETAILS = #TMP_1.FLDDETAILS + '~' + T.CLTDPID            
  FROM  #TMP_2 T             
  WHERE  T.SNO = (SELECT TOP 1 SNO            
                  FROM   #TMP_1 S            
                  WHERE  S.SNO < #TMP_1.SNO            
                         AND S.CLTDPID <> ''            
                  ORDER BY 1 DESC)            
         AND #TMP_1.CLTDPID = ''          
          
 SET @FILEDATA = CURSOR FOR  SELECT REPLACE(FLDDETAILS,'''','') FROM #TMP_1 WHERE  FLDDETAILS LIKE '04%' ORDER BY SNO             
 OPEN @FILEDATA                  
             
 FETCH NEXT FROM @FILEDATA INTO @ROWDATA          
 WHILE @@FETCH_STATUS = 0                   
 BEGIN                  
          PRINT @ROWDATA  
  SELECT @@SQL =  'INSERT INTO #DPC7 (RECTYPE,ISIN,CURRQUANTITY,FREEQUANTITY,EARMARKQUANTITY,PLEDGEQUANTITY,REMLOCQUANTITY,SCRIP_NAME1,SCRIP_NAME2,SCRIP_NAME3,FILLER1,FILLER2,FILLER3,FILLER4,FILLER5,FILLER6,SETTNO,CLTDPID) VALUES (' + ''''+ REPLACE(''+ @ROWDATA +'','~',''',''') + ''')'            
  EXEC (@@SQL)            
  --PRINT @@SQL            
 FETCH NEXT FROM @FILEDATA INTO @ROWDATA          
 END                  
 CLOSE @FILEDATA        
 DEALLOCATE @FILEDATA            
  
Update #DPC7 Set         
SETTNO = (Case When Left(SettNo,6) = '111000'         
      Then '20' + Left(Right(SettNo,7),2) + Right(SettNo,3) + 'D' 
      When Left(SettNo,6) = '111004'         
      Then '20' + Left(Right(SettNo,7),2) + Right(SettNo,3) + 'AD'         
      When Left(SettNo,6) = '121100'         
      Then Right(SettNo,7) + 'N' 
      When Left(SettNo,6) = '121104'         
      Then Right(SettNo,7) + 'W' 
      When Left(SettNo,6) = '121101'         
      Then Right(SettNo,7) + 'A'  
      End)
WHERE SETTNO <> '' AND SETTNO <> '9999999999999'


       
  SELECT PARTY_CODE=(CASE WHEN SETTNO = '' THEN 'PARTY' ELSE (CASE WHEN SETTNO = '9999999999999' THEN '9999999'+'N' ELSE LEFT(SETTNO, 10) END) END),DPID=LEFT(CLTDPID,8),          
  CLTDPID,SCRIP_CD='',SERIES='',ISIN,FREEBAL=CONVERT(NUMERIC(36,4),FREEQUANTITY),CURRBAL=CONVERT(NUMERIC(36,4),CURRQUANTITY),          
  FREEZEBAL=0,LOCKINBAL=0,PLEDGEBAL=CONVERT(NUMERIC(36,4),PLEDGEQUANTITY),DPVBAL=0,DPCBAL=0,RPCBAL=0,ELIMBAL=0,EARMARKBAL=CONVERT(NUMERIC(36,4),EARMARKQUANTITY),          
  REMLOCKBAL=CONVERT(NUMERIC(36,4),REMLOCQUANTITY),TOTALBALANCE=CONVERT(NUMERIC(36,4),FREEQUANTITY),TRDATE=GETDATE()           
  FROM #DPC7             
                    
  DROP TABLE #TMP            
  DROP TABLE #TMP_1             
  DROP TABLE #TMP_2          
  DROP TABLE #DPC7

GO
