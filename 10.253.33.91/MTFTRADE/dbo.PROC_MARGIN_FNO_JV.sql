-- Object: PROCEDURE dbo.PROC_MARGIN_FNO_JV
-- Server: 10.253.33.91 | DB: MTFTRADE
--------------------------------------------------

CREATE PROC [dbo].[PROC_MARGIN_FNO_JV]            
(            
 @TRANSDATE VARCHAR(11),            
 @EXCHANGE VARCHAR(3),            
 @SEGMENT VARCHAR(7),            
 @BATCHNO INT            
)            
AS            
            
DECLARE                   
--  @PREVDATE_1 VARCHAR(11),                  
  @PREVDATE VARCHAR(11),                  
  @SDTCUR VARCHAR(11),                
  @LDTCUR VARCHAR(11),                
  @CUTOFFDATE DATETIME,            
  @RefNo Varchar(4),            
  @filebrokercode varchar(1)            
              
DECLARE @STARTDATE VARCHAR(11)              
          
SELECT @SDTCUR = SDTCUR, @LDTCUR = LDTCUR FROM PARAMETER                  
WHERE @TRANSDATE BETWEEN SDTCUR AND LDTCUR              
          
SELECT CLTCODE=PARTY_CODE, AMOUNT, FROM_EXCHANGE=FROM_EXCHANGE, FROM_SEGMENT = FROM_SEGMENT,            
TO_EXCHANGE, TO_SEGMENT,              
BANKNAME = CONVERT(VARCHAR(4),''),            
BANK_GL = CONVERT(VARCHAR(10),''),            
JV_GL = CONVERT(VARCHAR(10),''),            
NARR = CONVERT(VARCHAR(100),''),            
INTNO = CONVERT(VARCHAR(15),'')            
INTO #FINALLEDGER_CR              
FROM ANGELFO.NSEFO.DBO.Tbl_ALL_MarginProcess_Fund                  
WHERE TRANSDATE = @TRANSDATE             
AND POSTEDFLAG = 0            
AND AMOUNT > 0             
AND FROM_EXCHANGE = @EXCHANGE            
AND FROM_SEGMENT = @SEGMENT             
            
SELECT CLTCODE=PARTY_CODE, AMOUNT, FROM_EXCHANGE=TO_EXCHANGE, FROM_SEGMENT = TO_SEGMENT,             
TO_EXCHANGE=FROM_EXCHANGE, TO_SEGMENT=FROM_SEGMENT,             
BANKNAME = CONVERT(VARCHAR(4),''),            
BANK_GL = CONVERT(VARCHAR(10),''),            
JV_GL = CONVERT(VARCHAR(10),''),            
NARR = CONVERT(VARCHAR(100),''),            
INTNO = CONVERT(VARCHAR(15),'')            
INTO #FINALLEDGER_DR              
FROM ANGELFO.NSEFO.DBO.Tbl_ALL_MarginProcess_Fund                  
WHERE TRANSDATE = @TRANSDATE             
AND POSTEDFLAG = 0            
AND AMOUNT > 0             
AND TO_EXCHANGE = @EXCHANGE            
AND TO_SEGMENT = @SEGMENT             
            
UPDATE #FINALLEDGER_DR SET JV_GL = JV_GLCODE            
FROM ANGELFO.NSEFO.DBO.Tbl_OTHERGLCODE	 N            
WHERE #FINALLEDGER_DR.FROM_EXCHANGE = N.FROM_EXCHANGE            
AND #FINALLEDGER_DR.FROM_SEGMENT = N.FROM_SEGMENT            
AND #FINALLEDGER_DR.TO_EXCHANGE = N.TO_EXCHANGE            
AND #FINALLEDGER_DR.TO_SEGMENT = N.TO_SEGMENT            
            
UPDATE #FINALLEDGER_CR SET JV_GL = JV_GLCODE            
FROM ANGELFO.NSEFO.DBO.Tbl_OTHERGLCODE N            
WHERE #FINALLEDGER_CR.FROM_EXCHANGE = N.FROM_EXCHANGE            
AND #FINALLEDGER_CR.FROM_SEGMENT = N.FROM_SEGMENT            
AND #FINALLEDGER_CR.TO_EXCHANGE = N.TO_EXCHANGE            
AND #FINALLEDGER_CR.TO_SEGMENT = N.TO_SEGMENT            

            
SELECT *,            
BANK_GL = CONVERT(VARCHAR(10),''),            
JV_GL = CONVERT(VARCHAR(10),''),            
INTNO = CONVERT(VARCHAR(15),'')             
INTO #LEDGER_CR FROM LEDGER                  
WHERE VTYP = 2 AND 1 =2                  
                  
SELECT *,            
BANK_GL = CONVERT(VARCHAR(10),''),            
JV_GL = CONVERT(VARCHAR(10),''),            
INTNO = CONVERT(VARCHAR(15),'')             
INTO #LEDGER_DR FROM LEDGER                  
WHERE VTYP = 3 AND 1 =2                  
                  
ALTER TABLE #LEDGER_CR                  
ADD SNO INT IDENTITY(1,1)                  
                  
ALTER TABLE #LEDGER_DR                  
ADD SNO INT IDENTITY(1,1)                  
                  
DECLARE @VNO BIGINT                  
                  
ALTER TABLE #FINALLEDGER_CR                  
ADD SNO INT IDENTITY(1,1)                  
                  
ALTER TABLE #FINALLEDGER_DR                  
ADD SNO INT IDENTITY(1,1)                  
            
TRUNCATE TABLE #LEDGER_CR            
TRUNCATE TABLE #LEDGER_DR            
            
SET @VNO = 0                   
            
TRUNCATE TABLE #LEDGER_CR            
TRUNCATE TABLE #LEDGER_DR            
            
SET @VNO = 0                   
INSERT INTO #LEDGER_CR                  
SELECT VTYP = 8, VNO = SNO, EDT = @TRANSDATE, LNO=1, ACNAME = CLTCODE, DRCR='C', VAMT=ABS(AMOUNT), VDT=@TRANSDATE,VNO1=SNO,                
REFNO=0,BALAMT=0,NODAYS=0,CDT=@TRANSDATE,CLTCODE,BOOKTYPE='01', ENTEREDBY='BACKEND-ANI', PDT = GETDATE(),                 
CHECKEDBY =FROM_EXCHANGE+FROM_SEGMENT, '0', NARRATION = 'INTER SEGMENT JV FROM ' + TO_EXCHANGE+TO_SEGMENT,           
BANK_GL,            
JV_GL,            
INTNO=''                     
FROM #FINALLEDGER_DR              
WHERE BANK_GL = ''                
ORDER BY SNO                  
                
INSERT INTO #LEDGER_DR                  
SELECT VTYP = 8, VNO = SNO, EDT = @TRANSDATE, LNO=1, ACNAME = CLTCODE, DRCR='D', VAMT=ABS(AMOUNT), VDT=@TRANSDATE,VNO1=SNO,                
REFNO=0,BALAMT=0,NODAYS=0,CDT=@TRANSDATE,CLTCODE,BOOKTYPE='01', ENTEREDBY='BACKEND-ANI', PDT = GETDATE(),                 
CHECKEDBY =FROM_EXCHANGE+FROM_SEGMENT, '0', NARRATION = 'INTER SEGMENT JV TO ' + TO_EXCHANGE+TO_SEGMENT,            
BANK_GL,            
JV_GL,            
INTNO=''                   
FROM #FINALLEDGER_CR                  
WHERE BANK_GL = ''            
ORDER BY SNO                  
                
DECLARE @REC INT    
SELECT @REC = 0    
SELECT @REC = COUNT(1) FROM #LEDGER_CR    
    
CREATE TABLE #VNO    
(    
 LASTVNO BIGINT  
)    
    
IF @REC > 0     
BEGIN    
 INSERT INTO #VNO    
 EXEC ACC_GENVNO_NEW    
   @TRANSDATE,    
   '8',    
   '01',    
   @SDTCUR ,    
   @LDTCUR,    
   @REC    
   
   SELECT @VNO = LASTVNO - 1  
   FROM   #VNO    
  
 INSERT INTO LEDGER                  
 SELECT VTYP,VNO=@VNO+SNO,EDT,LNO+1,ACNAME,DRCR,VAMT,VDT=VDT,VNO1=@VNO+SNO,REFNO,BALAMT,NODAYS,CDT,CLTCODE,BOOKTYPE='01',ENTEREDBY='ANIMESH',                  
    PDT,CHECKEDBY,ACTNODAYS=@BATCHNO,NARRATION                 
 FROM #LEDGER_CR                   
                 
 INSERT INTO LEDGER                  
 SELECT VTYP,VNO=@VNO+SNO,EDT,LNO,ACNAME,DRCR='D',VAMT,VDT=VDT,VNO1=@VNO+SNO,REFNO,BALAMT,NODAYS,CDT,CLTCODE=JV_GL,BOOKTYPE='01',ENTEREDBY='ANIMESH',                  
    PDT,CHECKEDBY,ACTNODAYS=@BATCHNO,NARRATION                 
 FROM #LEDGER_CR                   
                  
 TRUNCATE TABLE #LEDGER_CR                
END               
            
SET @VNO = 0              
    
SELECT @REC = 0    
SELECT @REC = COUNT(1) FROM #LEDGER_DR    
    
TRUNCATE TABLE #VNO    
    
IF @REC > 0     
BEGIN    
 INSERT INTO #VNO    
 EXEC ACC_GENVNO_NEW    
   @TRANSDATE,    
   '8',    
   '01',    
   @SDTCUR ,    
   @LDTCUR,    
   @REC    
       
   SELECT @VNO = LASTVNO - 1   
   FROM   #VNO    
                     
 INSERT INTO LEDGER                  
 SELECT VTYP,VNO=@VNO+SNO,EDT,LNO+1,ACNAME,DRCR,VAMT,VDT=VDT,VNO1=@VNO+SNO,REFNO,BALAMT,NODAYS,CDT,CLTCODE,                
 BOOKTYPE='01',ENTEREDBY='ANIMESH',                  
    PDT,CHECKEDBY,ACTNODAYS=@BATCHNO,NARRATION FROM #LEDGER_DR                   
                   
 INSERT INTO LEDGER                  
 SELECT VTYP,VNO=@VNO+SNO,EDT,LNO,ACNAME,DRCR='C',VAMT,VDT=VDT,VNO1=@VNO+SNO,REFNO,BALAMT,NODAYS,CDT,                
 CLTCODE=JV_GL,BOOKTYPE='01',ENTEREDBY='ANIMESH',                  
    PDT,CHECKEDBY,ACTNODAYS=@BATCHNO,NARRATION FROM #LEDGER_DR                   
END      
                   
TRUNCATE TABLE #LEDGER_DR                
            
UPDATE LEDGER SET ACNAME = LONGNAME             
FROM ACMAST A                  
WHERE VDT = @TRANSDATE AND A.CLTCODE = LEDGER.CLTCODE                  
AND LEDGER.ACNAME <> LONGNAME

GO
