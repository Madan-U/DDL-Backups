-- Object: PROCEDURE dbo.BANK_RECO_REPORT_ANG_Test
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

        
CREATE PROC [dbo].[BANK_RECO_REPORT_ANG_Test] (@FROMDATE DATETIME)                              
AS 

---- EXEC ACCOUNT.DBO.BANK_RECO_REPORT_ANG'May 25 2024'                             
                              
 --EXEC BANK_RECO_REPORT_ANG 'SEP 28 2022'                              
                              
                               
-- INSERT INTO  TABLE THE DATA OF FILES.                                    
        
DELETE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG_LOG WHERE RECODATE = @FROMDATE           
DELETE ACCOUNT.DBO.REC_BANK_RECO_ANG_ALL        
        
INSERT INTO ACCOUNT.DBO.BANK_RECO_BALANCE_ANG_LOG SELECT * FROM ACCOUNT.DBO.BANK_RECO_BALANCE_ANG WITH (NOLOCK)        
        
CREATE TABLE [DBO].[#DATA]([FILEDATA] [VARCHAR](MAX))      

insert into tbl_Reco(steps,Date_1)
values ('step1-Bulkinsert',getdate())                              
                                    
BULK INSERT [DBO].[#DATA] FROM 'J:\BACKOFFICE\EXPORT\COMB_RECO.CSV' WITH ( FIRSTROW = 2);                                    
                              
DELETE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG --WHERE RECODATE = @FROMDATE    

insert into tbl_Reco(steps,Date_1)
values ('step2-tblreco',getdate())                            
                                    
INSERT INTO ACCOUNT.DBO.BANK_RECO_BALANCE_ANG (RECODATE ,SEGMENT,BANKCODE,BANKBAL)                              
SELECT CONVERT(VARCHAR(11), CONVERT(DATE, DBO.PIECE(FILEDATA,',',1), 103), 109), DBO.PIECE(FILEDATA,',',2)                              
, DBO.PIECE(FILEDATA,',',3), DBO.PIECE(FILEDATA,',',4)                              
FROM [#DATA]                                    
                            
DROP TABLE #DATA                            
                               
UPDATE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG SET BOOKBAL = 0 , DIFFBAL = 0 , CRAMT = 0,DRAMT = 0,TOTDIFFBAL = 0 WHERE RECODATE = @FROMDATE    
                           
  insert into tbl_Reco(steps,Date_1)
values ('step3',getdate())                            
DECLARE @STARTDATE DATETIME                              
                              
 SELECT [BANK NAME],[Details],[BANKCODE],[TYPE OF ACCOUNT],[SEGMENT],[NAME],[BANK STATEMENT BALANCE]                          
 INTO #BANK_RECO_MASTER_ANG FROM BANK_RECO_MASTER_ANG B WITH (NOLOCK) WHERE SEGMENT  = 'NSE'                              
                              
 SELECT @STARTDATE = SDTCUR  FROM ACCOUNT.DBO.PARAMETER WITH (NOLOCK)   WHERE @FROMDATE BETWEEN SDTCUR  AND LDTCUR                                 
                              
  /*            
 UPDATE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG SET  BOOKBAL = A.BOOKBAL FROM                              
 (SELECT A.RECODATE, A.SEGMENT,A.BANKCODE,BOOKBAL = ISNULL(SUM(CASE DRCR WHEN 'D' THEN ISNULL(VAMT,0) ELSE ISNULL(-VAMT,0) END),0)                               
 FROM LEDGER L WITH (NOLOCK) , ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK), #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
 WHERE                                 
    VDT >= @STARTDATE                                 
    AND VDT <= @FROMDATE + ' 23:59:59'                                
    AND CLTCODE = A.BANKCODE                              
 AND A.SEGMENT = B.SEGMENT                              
 AND A.BANKCODE = B.BANKCODE                              
 AND A.RECODATE = @FROMDATE GROUP BY A.RECODATE, A.SEGMENT,A.BANKCODE) A , #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
 WHERE BANK_RECO_BALANCE_ANG.RECODATE = @FROMDATE                              
 AND A.RECODATE = BANK_RECO_BALANCE_ANG.RECODATE                              
 AND ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.SEGMENT   = B.SEGMENT                               
 AND ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.BANKCODE = A.BANKCODE                               
 AND A.BANKCODE = B.BANKCODE                              
 AND A.SEGMENT = B.SEGMENT                               
      */        
               
SELECT B.SEGMENT,B.BANKCODE,BOOKBAL = ISNULL(SUM(CASE DRCR WHEN 'D' THEN ISNULL(VAMT,0) ELSE ISNULL(-VAMT,0) END),0) INTO #CTE                          
 FROM LEDGER L WITH (NOLOCK) , #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
 WHERE                                 
 VDT >= @STARTDATE                                 
    AND VDT <= @FROMDATE + ' 23:59:59'                                
    AND CLTCODE = B.BANKCODE                              
  GROUP BY B.SEGMENT,B.BANKCODE

     insert into tbl_Reco(steps,Date_1)
values ('step4',getdate())
	 /*
;WITH CTE AS (SELECT B.SEGMENT,B.BANKCODE,BOOKBAL = ISNULL(SUM(CASE DRCR WHEN 'D' THEN ISNULL(VAMT,0) ELSE ISNULL(-VAMT,0) END),0)                               
 FROM LEDGER L WITH (NOLOCK) , #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
 WHERE                                 
 VDT >= @STARTDATE                                 
    AND VDT <= @FROMDATE + ' 23:59:59'                                
    AND CLTCODE = B.BANKCODE                              
  GROUP BY B.SEGMENT,B.BANKCODE)              
  */            

 UPDATE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG SET  BOOKBAL = A.BOOKBAL FROM                            
 #CTE A , #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
 WHERE BANK_RECO_BALANCE_ANG.RECODATE = @FROMDATE                              
 AND ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.SEGMENT   = B.SEGMENT                               
 AND ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.BANKCODE = A.BANKCODE                               
 AND A.BANKCODE = B.BANKCODE                              
 AND A.SEGMENT = B.SEGMENT                               
   
   
     insert into tbl_Reco(steps,Date_1)
values ('step5',getdate())                      
 DROP TABLE #CTE          
 
 --CREATE TABLE #LEDGER_BANK                                
 --(  BANKCODE VARCHAR(20),                              
 --VNO VARCHAR(12),                                
 --VTYP INT,                                
 --BOOKTYPE VARCHAR(3)                                
 -- )                                
                                
                                     
--WITH                                        
--    FILLFACTOR = 90                                        
--ON [PRIMARY]                                    
                                
                                 
  SELECT L.CLTCODE AS BANKCODE , VNO, VTYP, BOOKTYPE INTO #LEDGER_BANK    FROM LEDGER L (NOLOCK) , ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
  #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
  WHERE VDT BETWEEN @FROMDATE-92 AND @FROMDATE + ' 23:59:59' AND CLTCODE = A.BANKCODE       
  AND VTYP <> '18'                              
  AND A.RECODATE = @FROMDATE                                                 
  AND A.SEGMENT = B.SEGMENT                              
  AND A.BANKCODE = B.BANKCODE                            
                      
     insert into tbl_Reco(steps,Date_1)
values ('step6',getdate())                             
                           
CREATE   CLUSTERED  INDEX [VNO] ON [DBO].[#LEDGER_BANK] ([VNO], [VTYP], [BOOKTYPE] ,BANKCODE )                                 
                              
                               
  SELECT bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,vtyp,vno,lno,drcr,BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,clear_mode                      
  INTO #LED1                           
  FROM LEDGER1 L1 (NOLOCK) WHERE (RELDT ='1900-01-01 00:00:00.000' OR RELDT >  @FROMDATE )                           
  AND EXISTS(SELECT VNO FROM #LEDGER_BANK LL WITH (NOLOCK)  WHERE L1.VNO = LL.VNO AND L1.VTYP = LL.VTYP AND L1.BOOKTYPE = LL.BOOKTYPE)                                
   
     insert into tbl_Reco(steps,Date_1)
values ('step7',getdate())    
	   
  SELECT L3.DDNO,L3.VNO, L3.BookType, L3.DDDT, L3.Vtyp, L3.relamt, L3.BNKNAME
  into #led11
  FROM LEDGER1 L3 (NOLOCK), (SELECT VNO, VTYP, BOOKTYPE FROM #LEDGER_BANK WHERE VTYP = 16) L4                                    
  WHERE  L3.VNO = L4.VNO             
  AND L3.VTYP = L4.VTYP                           
  AND L3.BOOKTYPE = L4.BOOKTYPE 

    insert into tbl_Reco(steps,Date_1)
values ('step8',getdate())

  create nonclustered index idx_l11 on #led11(DDNO,VNO, BookType, DDDT, Vtyp, relamt, BNKNAME )
       
	   
	  UPDATE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG SET DRAMT = A.DRAMT  , CRAMT = A.CRAMT FROM                              
 ( SELECT  A.SEGMENT,A.BANKCODE,DRAMT= SUM(CASE WHEN UPPER(L.DRCR) = 'D' THEN RELAMT  ELSE 0 END ),                                                    
 CRAMT= SUM(CASE WHEN UPPER(L.DRCR) = 'C' THEN RELAMT ELSE 0 END )                                     
FROM                                     
 LEDGER L (NOLOCK)                                   
 inner join #LED1 L1 
 on  L.VTYP = L1.VTYP  AND L.VNO = L1.VNO AND L.LNO = L1.LNO  AND L.BOOKTYPE = L1.BOOKTYPE                                                     
 inner join #LEDGER_BANK L2       
 on L.VTYP = L2.VTYP  AND L.VNO= L2.VNO 
 AND L.BOOKTYPE = L2.BOOKTYPE           
 , ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
  #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
WHERE  VDT BETWEEN @FROMDATE-92 AND @FROMDATE + ' 23:59:59' AND CLTCODE <> A.BANKCODE                                          
      and                               
   L2.BANKCODE = A.BANKCODE                              
 AND NOT EXISTS                                    
  (SELECT L3.DDNO FROM #led11 L3                                     
  WHERE L1.DDNO = L3.DDNO                                 
  AND CONVERT(VARCHAR(11),L1.DDDT,109) = CONVERT(VARCHAR(11),L3.DDDT,109)              
  AND L1.RELAMT = L3.RELAMT                                 
  AND L1.BNKNAME = L3.BNKNAME                                
  AND L1.BOOKTYPE = L3.BOOKTYPE                                   
 AND L1.CLEAR_MODE = 'C'                                
  )                                   
 AND ( (RELDT ='1900-01-01 00:00:00.000' OR RELDT >  @FROMDATE) )  AND L1.VTYP <> 16                                
 AND A.BANKCODE = B.BANKCODE AND A.SEGMENT = B.SEGMENT                              
 AND A.RECODATE = @FROMDATE                              
 GROUP BY  A.SEGMENT,A.BANKCODE                              
  --AND L.VNO IN ('202104268075', '202104289454') AND L.VTYP=3 AND L.BOOKTYPE='01'                                 
   ) A   , #BANK_RECO_MASTER_ANG B WITH (NOLOCK) WHERE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.RECODATE = @FROMDATE                
 AND A.BANKCODE = ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.BANKCODE                              
 AND ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.SEGMENT = B.SEGMENT                              
 AND A.BANKCODE = B.BANKCODE                               
 AND A.SEGMENT = B.SEGMENT    
	 
	 
	   insert into tbl_Reco(steps,Date_1)
values ('step9',getdate())  
	                     
--UPDATE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG SET DRAMT = A.DRAMT  , CRAMT = A.CRAMT FROM                              
-- ( SELECT  A.SEGMENT,A.BANKCODE,DRAMT= SUM(CASE WHEN UPPER(L.DRCR) = 'D' THEN RELAMT  ELSE 0 END ),                                                    
-- CRAMT= SUM(CASE WHEN UPPER(L.DRCR) = 'C' THEN RELAMT ELSE 0 END )                                     
--FROM                                     
-- LEDGER L (NOLOCK),                                     
-- #LED1 L1 ,                                                    
-- #LEDGER_BANK L2       , ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
--  #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
--WHERE  VDT BETWEEN @FROMDATE-92 AND @FROMDATE + ' 23:59:59' AND CLTCODE <> A.BANKCODE       AND                                   
-- L.VTYP = L2.VTYP AND L.VTYP = L1.VTYP AND L.VNO= L2.VNO AND L.VNO = L1.VNO AND L.LNO = L1.LNO
-- AND L.BOOKTYPE = L2.BOOKTYPE                                                     
--  AND L.BOOKTYPE = L1.BOOKTYPE                                         
-- AND  L2.BANKCODE = A.BANKCODE                              
-- AND NOT EXISTS                                    
--  (SELECT L3.DDNO FROM #led11 L3                                     
--  WHERE L1.DDNO = L3.DDNO                                 
--  AND CONVERT(VARCHAR(11),L1.DDDT,109) = CONVERT(VARCHAR(11),L3.DDDT,109)              
--  AND L1.RELAMT = L3.RELAMT                                 
--  AND L1.BNKNAME = L3.BNKNAME                                
--  AND L1.BOOKTYPE = L3.BOOKTYPE                                   
-- AND L1.CLEAR_MODE = 'C'                                
--  )                                   
-- AND ( (RELDT ='1900-01-01 00:00:00.000' OR RELDT >  @FROMDATE) )  AND L1.VTYP <> 16                                
-- AND A.BANKCODE = B.BANKCODE AND A.SEGMENT = B.SEGMENT                              
-- AND A.RECODATE = @FROMDATE                              
-- GROUP BY  A.SEGMENT,A.BANKCODE                              
--  --AND L.VNO IN ('202104268075', '202104289454') AND L.VTYP=3 AND L.BOOKTYPE='01'                                 
--   ) A   , #BANK_RECO_MASTER_ANG B WITH (NOLOCK) WHERE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.RECODATE = @FROMDATE                
-- AND A.BANKCODE = ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.BANKCODE                              
-- AND ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.SEGMENT = B.SEGMENT                              
-- AND A.BANKCODE = B.BANKCODE                               
-- AND A.SEGMENT = B.SEGMENT                              
                        
            
 INSERT INTO  REC_BANK_RECO_ANG_ALL            
 SELECT   L.VDT,ISNULL(L1.DDNO,'') AS DDNO,A.BANKCODE,A.SEGMENT,CASE WHEN UPPER(L.DRCR) = 'C' THEN RELAMT  ELSE 0 END +    
 CASE WHEN UPPER(L.DRCR) = 'D' THEN RELAMT  ELSE 0 END     
  AS DRAMT,0  AS CRAMT ,RELDT,L1.REFNO,L.CLTCODE,L.VNO,L.VTYP   ,@FROMDATE                                       
FROM                                     
 LEDGER L (NOLOCK),                                     
 #LED1 L1 ,                                                    
 #LEDGER_BANK L2       , ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
  #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
WHERE VDT BETWEEN @FROMDATE-92 AND @FROMDATE + ' 23:59:59' AND   CLTCODE <> A.BANKCODE       AND                                  
 L.VTYP = L2.VTYP AND L.VTYP = L1.VTYP AND L.VNO= L2.VNO AND L.VNO = L1.VNO AND L.LNO = L1.LNO AND L.BOOKTYPE = L2.BOOKTYPE                                                     
  AND L.BOOKTYPE = L1.BOOKTYPE                                        
 AND  L2.BANKCODE = A.BANKCODE                              
 AND NOT EXISTS                                    
  (SELECT L3.DDNO FROM #led11 L3                                     
  WHERE L1.DDNO = L3.DDNO                                 
  AND CONVERT(VARCHAR(11),L1.DDDT,109) = CONVERT(VARCHAR(11),L3.DDDT,109)              
  AND L1.RELAMT = L3.RELAMT                                 
  AND L1.BNKNAME = L3.BNKNAME                                
  AND L1.BOOKTYPE = L3.BOOKTYPE                                   
 AND L1.CLEAR_MODE = 'C'                                
  )                                  
 AND ( (RELDT ='1900-01-01 00:00:00.000' OR RELDT >   @FROMDATE) )  AND L1.VTYP <> 16                                
 AND A.BANKCODE = B.BANKCODE AND A.SEGMENT = B.SEGMENT                              
 AND A.RECODATE =  @FROMDATE             
       
	     insert into tbl_Reco(steps,Date_1)
values ('step10',getdate())
	   
	            
                        
  SELECT L.CLTCODE AS BANKCODE , L.VNO, L.VTYP, L.BOOKTYPE                       
  INTO #LEDGER_BANK_2  FROM LEDGER L (NOLOCK) , ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
  #BANK_RECO_MASTER_ANG B WITH (NOLOCK)        , LEDGER1 L1 (NOLOCK)                      
  WHERE VDT BETWEEN @FROMDATE+1 AND @FROMDATE+3 AND L.VTYP <> '18'      AND CLTCODE = A.BANKCODE         
  AND  L.VTYP = L1.VTYP  AND L.VTYP IN (2,3) AND L.VNO = L1.VNO  AND L.BOOKTYPE = L1.BOOKTYPE          
  AND A.RECODATE = @FROMDATE                                           
  AND A.SEGMENT = B.SEGMENT                              
  AND A.BANKCODE = B.BANKCODE                      
  AND ((RELDT BETWEEN @FROMDATE AND @FROMDATE + ' 23:59')  OR (RELDT  < @FROMDATE AND RELDT <> '1900-01-01 00:00:00.000'))                        
              
                      
       insert into tbl_Reco(steps,Date_1)
values ('step11',getdate())                   
                           
CREATE   CLUSTERED  INDEX [VNO] ON [DBO].[#LEDGER_BANK_2] ([VNO], [VTYP], [BOOKTYPE] ,BANKCODE )                                 
                                        
                          
  SELECT  bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,vtyp,vno,lno,drcr,BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,clear_mode                      
  INTO #LED1_2                             
  FROM LEDGER1 L1 (NOLOCK) 
  WHERE ((RELDT BETWEEN @FROMDATE AND @FROMDATE + ' 23:59')  OR (RELDT  < @FROMDATE AND RELDT <> '1900-01-01 00:00:00.000'))                                 
  AND EXISTS(SELECT VNO FROM #LEDGER_BANK_2 LL WITH (NOLOCK)  WHERE L1.VNO = LL.VNO AND L1.VTYP = LL.VTYP AND L1.BOOKTYPE = LL.BOOKTYPE)                          
                      
  insert into tbl_Reco(steps,Date_1)
values ('step12',getdate())
                           
UPDATE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG SET DRAMT = ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.DRAMT + A.DRAMT  ,                       
CRAMT = ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.CRAMT + A.CRAMT FROM                              
 ( SELECT  A.SEGMENT,A.BANKCODE,DRAMT= SUM(CASE WHEN UPPER(L.DRCR) = 'C' THEN RELAMT  ELSE 0 END ),                                                    
 CRAMT= SUM(CASE WHEN UPPER(L.DRCR) = 'D' THEN RELAMT ELSE 0 END )                                     
FROM                                     
 LEDGER L (NOLOCK),                                     
 #LED1_2 L1 ,                                                    
 #LEDGER_BANK_2 L2       , ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                       
  #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                           
WHERE VDT BETWEEN @FROMDATE-92 AND @FROMDATE + ' 23:59:59' AND  CLTCODE <> A.BANKCODE       AND                                   
 L.VTYP = L2.VTYP AND L.VTYP = L1.VTYP AND L.VNO= L2.VNO AND L.VNO = L1.VNO AND L.LNO = L1.LNO AND L.BOOKTYPE = L2.BOOKTYPE                                                     
 AND  L.BOOKTYPE = L1.BOOKTYPE                                         
 AND  L2.BANKCODE = A.BANKCODE                                   
 --AND RELDT BETWEEN @FROMDATE AND @FROMDATE + ' 23:59'  
 AND ((RELDT BETWEEN @FROMDATE AND @FROMDATE + ' 23:59')  OR (RELDT  < @FROMDATE AND RELDT <> '1900-01-01 00:00:00.000'))
 AND A.BANKCODE = B.BANKCODE AND A.SEGMENT = B.SEGMENT                              
 AND A.RECODATE = @FROMDATE                              
 AND VDT > @FROMDATE                      
 GROUP BY  A.SEGMENT,A.BANKCODE                              
  --AND L.VNO IN ('202104268075', '202104289454') AND L.VTYP=3 AND L.BOOKTYPE='01'                                 
   ) A   , #BANK_RECO_MASTER_ANG B WITH (NOLOCK) WHERE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.RECODATE = @FROMDATE                               
 AND A.BANKCODE = ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.BANKCODE                              
 AND ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.SEGMENT = B.SEGMENT                              
 AND A.BANKCODE = B.BANKCODE                               
 AND A.SEGMENT = B.SEGMENT  



   insert into tbl_Reco(steps,Date_1)
values ('step13',getdate())


 INSERT INTO  REC_BANK_RECO_ANG_ALL            
SELECT  L.VDT,ISNULL(L1.DDNO,'') AS DDNO,A.BANKCODE,A.SEGMENT,        
 0 AS DRAMT,CASE WHEN UPPER(L.DRCR) = 'C' THEN RELAMT  ELSE 0 END +    
 CASE WHEN UPPER(L.DRCR) = 'D' THEN RELAMT  ELSE 0 END AS CRAMT,RELDT,L1.REFNO,L.CLTCODE,L.VNO,L.VTYP   ,@FROMDATE                                    
FROM                                     
 LEDGER L (NOLOCK),                                     
 #LED1_2 L1 ,                                                    
 #LEDGER_BANK_2 L2       , ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
  #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                           
WHERE  VDT BETWEEN @FROMDATE-92 AND @FROMDATE + ' 23:59:59' AND     CLTCODE <> A.BANKCODE       AND                       
 L.VTYP = L2.VTYP AND L.VTYP = L1.VTYP AND L.VNO= L2.VNO AND L.VNO = L1.VNO AND L.LNO = L1.LNO AND L.BOOKTYPE = L2.BOOKTYPE                                                     
 AND  L.BOOKTYPE = L1.BOOKTYPE                                         
 AND  L2.BANKCODE = A.BANKCODE                                   
 --AND RELDT BETWEEN @FROMDATE AND @FROMDATE + ' 23:59'      
 AND ((RELDT BETWEEN @FROMDATE AND @FROMDATE + ' 23:59')  OR (RELDT  < @FROMDATE AND RELDT <> '1900-01-01 00:00:00.000'))
 AND A.BANKCODE = B.BANKCODE AND A.SEGMENT = B.SEGMENT                              
 AND A.RECODATE = @FROMDATE                            
 AND VDT > @FROMDATE                
                               
       insert into tbl_Reco(steps,Date_1)
values ('step14',getdate())
	                             
                      
                               
 UPDATE BANK_RECO_BALANCE_ANG SET TOTDIFFBAL = ABS((BANKBAL - BOOKBAL) - (DRAMT - CRAMT)) ,DIFFBAL = ABS(BANKBAL - BOOKBAL)                                
 FROM  #BANK_RECO_MASTER_ANG  WHERE RECODATE = @FROMDATE                              
 AND BANK_RECO_BALANCE_ANG.BANKCODE = #BANK_RECO_MASTER_ANG.BANKCODE AND BANK_RECO_BALANCE_ANG.SEGMENT = #BANK_RECO_MASTER_ANG.SEGMENT                              
     
	   insert into tbl_Reco(steps,Date_1)
values ('step15',getdate())
	                           
 TRUNCATE TABLE  #BANK_RECO_MASTER_ANG                              
 TRUNCATE TABLE  #LEDGER_BANK           
 TRUNCATE TABLE  #LEDGER_BANK_2                      
 TRUNCATE TABLE  #LED1                      
 TRUNCATE TABLE  #LED1_2                      
                               
 INSERT  INTO #BANK_RECO_MASTER_ANG                               
 SELECT [BANK NAME],[Details],[BANKCODE],[TYPE OF ACCOUNT],[SEGMENT],[NAME],[BANK STATEMENT BALANCE]                          
 FROM ACCOUNT.DBO.BANK_RECO_MASTER_ANG B WITH (NOLOCK) WHERE SEGMENT  = 'BSE'                              
    
	  insert into tbl_Reco(steps,Date_1)
values ('step16',getdate())
	                           
 UPDATE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG SET  BOOKBAL = A.BOOKBAL FROM                              
 (SELECT A.RECODATE, A.SEGMENT,A.BANKCODE,BOOKBAL = ISNULL(SUM(CASE DRCR WHEN 'D' THEN ISNULL(VAMT,0) ELSE ISNULL(-VAMT,0) END),0)                               
 FROM [AngelBSECM].ACCOUNT_AB.DBO.LEDGER L WITH (NOLOCK) , ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
 #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
 WHERE                                 
    VDT >= @STARTDATE                                 
    AND VDT <= @FROMDATE + ' 23:59:59'                                
    AND CLTCODE = A.BANKCODE                              
 AND A.SEGMENT = B.SEGMENT                              
 AND A.BANKCODE = B.BANKCODE                              
 AND A.RECODATE = @FROMDATE GROUP BY A.RECODATE, A.SEGMENT,A.BANKCODE) A , #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
 WHERE BANK_RECO_BALANCE_ANG.RECODATE = @FROMDATE                              
 AND A.RECODATE = BANK_RECO_BALANCE_ANG.RECODATE                              
 AND ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.SEGMENT   = B.SEGMENT                               
 AND ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.BANKCODE = A.BANKCODE                               
 AND A.BANKCODE = B.BANKCODE                              
 AND A.SEGMENT = B.SEGMENT                               
   
     insert into tbl_Reco(steps,Date_1)
values ('step17',getdate())
                               
                               
  INSERT INTO #LEDGER_BANK                                
  SELECT A.BANKCODE, VNO, VTYP, BOOKTYPE FROM [AngelBSECM].ACCOUNT_AB.DBO.LEDGER L WITH (NOLOCK) ,                               
  ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
  #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
  WHERE VDT BETWEEN @FROMDATE-7 AND @FROMDATE + ' 23:59:59'   AND VTYP <> '18'                             
  AND A.RECODATE = @FROMDATE                              
  AND CLTCODE = A.BANKCODE                              
  AND A.SEGMENT = B.SEGMENT                              
  AND A.BANKCODE = B.BANKCODE                               
    
	  insert into tbl_Reco(steps,Date_1)
values ('step18',getdate())

	                          
  INSERT INTO #LED1   
  SELECT bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,vtyp,vno,lno,drcr,BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,clear_mode                      
  FROM [AngelBSECM].ACCOUNT_AB.DBO.LEDGER1 L1 WITH (NOLOCK) WHERE (RELDT ='1900-01-01 00:00:00.000' OR RELDT >  @FROMDATE )                                    
  AND EXISTS(SELECT VNO FROM #LEDGER_BANK LL WITH (NOLOCK)  WHERE L1.VNO = LL.VNO AND L1.VTYP = LL.VTYP AND L1.BOOKTYPE = LL.BOOKTYPE)                                
                              
      insert into tbl_Reco(steps,Date_1)
values ('step19',getdate())


UPDATE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG SET DRAMT = A.DRAMT  , CRAMT = A.CRAMT FROM                              
 ( SELECT  A.SEGMENT,A.BANKCODE,DRAMT= SUM(CASE WHEN UPPER(L.DRCR) = 'D' THEN RELAMT  ELSE 0 END ),                                                    
 CRAMT= SUM(CASE WHEN UPPER(L.DRCR) = 'C' THEN RELAMT ELSE 0 END )                                     
FROM                                     
 [AngelBSECM].ACCOUNT_AB.DBO.LEDGER L WITH (NOLOCK),                                     
 #LED1 L1 ,                       
 #LEDGER_BANK L2       , ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
  #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
WHERE                                     
 L.VTYP = L2.VTYP AND L.VNO= L2.VNO AND L.BOOKTYPE = L2.BOOKTYPE                                                     
 AND L.VTYP = L1.VTYP AND L.BOOKTYPE = L1.BOOKTYPE AND L.VNO = L1.VNO AND L.LNO = L1.LNO                                        
 AND CLTCODE <> A.BANKCODE       AND L2.BANKCODE = A.BANKCODE                              
 AND NOT EXISTS                                    
  (SELECT L3.DDNO FROM [AngelBSECM].ACCOUNT_AB.DBO.LEDGER1 L3 WITH (NOLOCK), (SELECT VNO, VTYP, BOOKTYPE FROM #LEDGER_BANK WHERE VTYP = 16) L4                                    
  WHERE L1.DDNO = L3.DDNO                                 
  AND CONVERT(VARCHAR(11),L1.DDDT,109) = CONVERT(VARCHAR(11),L3.DDDT,109)                                 
  AND L1.RELAMT = L3.RELAMT                                 
  AND L1.BNKNAME = L3.BNKNAME                                
  AND L1.BOOKTYPE = L3.BOOKTYPE                                   
  AND L3.VNO = L4.VNO                                 
  AND L3.VTYP = L4.VTYP                                 
  AND L3.BOOKTYPE = L4.BOOKTYPE AND L1.CLEAR_MODE = 'C'                                
  )                                   
 AND (RELDT ='1900-01-01 00:00:00.000' OR RELDT >  @FROMDATE )  AND L1.VTYP <> 16                                
 AND A.BANKCODE = B.BANKCODE AND A.SEGMENT = B.SEGMENT                              
 AND A.RECODATE = @FROMDATE                              
 GROUP BY  A.SEGMENT,A.BANKCODE                              
  --AND L.VNO IN ('202104268075', '202104289454') AND L.VTYP=3 AND L.BOOKTYPE='01'                                 
   ) A   , #BANK_RECO_MASTER_ANG B WITH (NOLOCK) WHERE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.RECODATE = @FROMDATE                               
 AND ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.SEGMENT = B.SEGMENT                                
 AND A.BANKCODE = ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.BANKCODE                              
 AND A.BANKCODE = B.BANKCODE                  
 AND A.SEGMENT = B.SEGMENT                              
         
			   insert into tbl_Reco(steps,Date_1)
values ('step20',getdate())
		 
		                       
  INSERT INTO #LEDGER_BANK_2                      
  SELECT L.CLTCODE AS BANKCODE , L.VNO, L.VTYP, L.BOOKTYPE                       
  FROM [AngelBSECM].ACCOUNT_AB.DBO.LEDGER L (NOLOCK) , ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
  #BANK_RECO_MASTER_ANG B WITH (NOLOCK)        , LEDGER1 L1 (NOLOCK)                      
  WHERE VDT BETWEEN @FROMDATE+1 AND @FROMDATE+3 AND L.VTYP <> '18'                              
  AND A.RECODATE = @FROMDATE                      
  AND CLTCODE = A.BANKCODE                              
  AND A.SEGMENT = B.SEGMENT                              
  AND A.BANKCODE = B.BANKCODE                      
  AND RELDT BETWEEN @FROMDATE AND @FROMDATE + ' 23:59'                      
  AND L.VNO = L1.VNO AND  L.VTYP = L1.VTYP  AND L.BOOKTYPE = L1.BOOKTYPE                      
  AND L.VTYP IN (2,3)                      
      
	    insert into tbl_Reco(steps,Date_1)
values ('step21',getdate())
	                        
   INSERT INTO #LED1_2                      
  SELECT bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,vtyp,vno,lno,drcr,BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,clear_mode                      
  FROM [AngelBSECM].ACCOUNT_AB.DBO.LEDGER1 L1 (NOLOCK) WHERE RELDT BETWEEN @FROMDATE AND @FROMDATE + ' 23:59'                                   
  AND EXISTS(SELECT VNO FROM #LEDGER_BANK_2 LL  WHERE L1.VNO = LL.VNO AND L1.VTYP = LL.VTYP AND L1.BOOKTYPE = LL.BOOKTYPE)                          
     
	   insert into tbl_Reco(steps,Date_1)
values ('step22',getdate())                 
                           
UPDATE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG SET DRAMT = ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.DRAMT + A.DRAMT  ,                       
CRAMT = ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.CRAMT + A.CRAMT FROM                              
 ( SELECT  A.SEGMENT,A.BANKCODE,DRAMT= SUM(CASE WHEN UPPER(L.DRCR) = 'C' THEN RELAMT  ELSE 0 END ),                                                    
 CRAMT= SUM(CASE WHEN UPPER(L.DRCR) = 'D' THEN RELAMT ELSE 0 END )                                     
FROM                                     
 [AngelBSECM].ACCOUNT_AB.DBO.LEDGER L (NOLOCK),                                     
 #LED1_2 L1 ,                                                    
 #LEDGER_BANK_2 L2       , ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
  #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
WHERE                                
 L.VTYP = L2.VTYP AND L.VNO= L2.VNO AND L.BOOKTYPE = L2.BOOKTYPE                                                     
 AND L.VTYP = L1.VTYP AND L.BOOKTYPE = L1.BOOKTYPE AND L.VNO = L1.VNO AND L.LNO = L1.LNO                                        
 AND CLTCODE <> A.BANKCODE       AND L2.BANKCODE = A.BANKCODE                                   
 AND RELDT BETWEEN @FROMDATE AND @FROMDATE + ' 23:59'                                     
 AND A.BANKCODE = B.BANKCODE AND A.SEGMENT = B.SEGMENT                              
 AND A.RECODATE = @FROMDATE                              
 AND VDT > @FROMDATE                      
 GROUP BY  A.SEGMENT,A.BANKCODE            --AND L.VNO IN ('202104268075', '202104289454') AND L.VTYP=3 AND L.BOOKTYPE='01'                                 
   ) A   , #BANK_RECO_MASTER_ANG B WITH (NOLOCK) WHERE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.RECODATE = @FROMDATE                               
 AND A.BANKCODE = ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.BANKCODE                              
 AND ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.SEGMENT = B.SEGMENT                              
 AND A.BANKCODE = B.BANKCODE                               
 AND A.SEGMENT = B.SEGMENT                              
     
	   insert into tbl_Reco(steps,Date_1)
values ('step23',getdate())                            
                               
 UPDATE BANK_RECO_BALANCE_ANG SET TOTDIFFBAL = ABS((BANKBAL - BOOKBAL) - (DRAMT - CRAMT)) ,DIFFBAL = ABS(BANKBAL - BOOKBAL)                                
 FROM  #BANK_RECO_MASTER_ANG  WHERE RECODATE = @FROMDATE                              
 AND BANK_RECO_BALANCE_ANG.BANKCODE = #BANK_RECO_MASTER_ANG.BANKCODE AND BANK_RECO_BALANCE_ANG.SEGMENT = #BANK_RECO_MASTER_ANG.SEGMENT                              
                                     
      insert into tbl_Reco(steps,Date_1)
values ('step24',getdate())
	                           
 TRUNCATE TABLE  #BANK_RECO_MASTER_ANG                              
 TRUNCATE TABLE  #LEDGER_BANK                      
 TRUNCATE TABLE  #LEDGER_BANK_2                      
 TRUNCATE TABLE  #LED1                      
 TRUNCATE TABLE  #LED1_2                      
                               
 INSERT  INTO #BANK_RECO_MASTER_ANG                               
 SELECT [BANK NAME],[Details],[BANKCODE],[TYPE OF ACCOUNT],[SEGMENT],[NAME],[BANK STATEMENT BALANCE]                           
 FROM ACCOUNT.DBO.BANK_RECO_MASTER_ANG B WITH (NOLOCK) WHERE SEGMENT  = 'NSEFO'                              
     
	   insert into tbl_Reco(steps,Date_1)
values ('step25',getdate())
	              
 UPDATE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG SET  BOOKBAL = A.BOOKBAL FROM                              
 (SELECT A.RECODATE, A.SEGMENT,A.BANKCODE,BOOKBAL = ISNULL(SUM(CASE DRCR WHEN 'D' THEN ISNULL(VAMT,0) ELSE ISNULL(-VAMT,0) END),0)                               
 FROM [AngelFO].ACCOUNTFO.DBO.LEDGER L WITH (NOLOCK) , ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
 #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
 WHERE                                 
    VDT >= @STARTDATE                                 
    AND VDT <= @FROMDATE + ' 23:59:59'                                
    AND CLTCODE = A.BANKCODE                              
 AND A.SEGMENT = B.SEGMENT                              
 AND A.BANKCODE = B.BANKCODE                              
 AND A.RECODATE = @FROMDATE GROUP BY A.RECODATE, A.SEGMENT,A.BANKCODE) A , #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
 WHERE BANK_RECO_BALANCE_ANG.RECODATE = @FROMDATE                              
 AND A.RECODATE = BANK_RECO_BALANCE_ANG.RECODATE                              
 AND ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.SEGMENT   = B.SEGMENT                               
 AND ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.BANKCODE = A.BANKCODE                               
 AND A.BANKCODE = B.BANKCODE                              
 AND A.SEGMENT = B.SEGMENT                               
    
	  insert into tbl_Reco(steps,Date_1)
values ('step26',getdate())
	
	                          
 UPDATE BANK_RECO_BALANCE_ANG SET DIFFBAL = BANKBAL - BOOKBAL  FROM  #BANK_RECO_MASTER_ANG WHERE RECODATE = @FROMDATE                              
 AND BANK_RECO_BALANCE_ANG.BANKCODE = #BANK_RECO_MASTER_ANG.BANKCODE AND BANK_RECO_BALANCE_ANG.SEGMENT = #BANK_RECO_MASTER_ANG.SEGMENT                              
      
	    insert into tbl_Reco(steps,Date_1)
values ('step27',getdate())
	  
	                           
  INSERT INTO #LEDGER_BANK                                
  SELECT A.BANKCODE, VNO, VTYP, BOOKTYPE FROM [AngelFO].ACCOUNTFO.DBO.LEDGER L WITH (NOLOCK) ,                               
  ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
  #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
  WHERE VDT BETWEEN @FROMDATE-7 AND @FROMDATE + ' 23:59:59'   AND VTYP <> '18'               
  AND A.RECODATE = @FROMDATE                              
  AND CLTCODE = A.BANKCODE                              
  AND A.SEGMENT = B.SEGMENT                              
  AND A.BANKCODE = B.BANKCODE                               
         
		   insert into tbl_Reco(steps,Date_1)
values ('step28',getdate())
		                      
  INSERT INTO #LED1                               
  SELECT bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,vtyp,vno,lno,drcr,BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,clear_mode                      
  FROM [AngelFO].ACCOUNTFO.DBO.LEDGER1 L1 WITH (NOLOCK) WHERE (RELDT ='1900-01-01 00:00:00.000' OR RELDT >  @FROMDATE )                                    
  AND EXISTS(SELECT VNO FROM #LEDGER_BANK LL WHERE L1.VNO = LL.VNO AND L1.VTYP = LL.VTYP AND L1.BOOKTYPE = LL.BOOKTYPE)                                
                              
             insert into tbl_Reco(steps,Date_1)
values ('step29',getdate())
		                        
UPDATE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG SET DRAMT = A.DRAMT  , CRAMT = A.CRAMT FROM                              
 ( SELECT  A.SEGMENT,A.BANKCODE,DRAMT= SUM(CASE WHEN UPPER(L.DRCR) = 'D' THEN RELAMT  ELSE 0 END ),                                                    
 CRAMT= SUM(CASE WHEN UPPER(L.DRCR) = 'C' THEN RELAMT ELSE 0 END )                                     
FROM                                     
 [AngelFO].ACCOUNTFO.DBO.LEDGER L WITH (NOLOCK),                                     
 #LED1 L1 ,                                                    
 #LEDGER_BANK L2       , ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                           
  #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
WHERE                                     
 L.VTYP = L2.VTYP AND L.VNO= L2.VNO AND L.BOOKTYPE = L2.BOOKTYPE                                                     
 AND L.VTYP = L1.VTYP AND L.BOOKTYPE = L1.BOOKTYPE AND L.VNO = L1.VNO AND L.LNO = L1.LNO                                        
 AND CLTCODE <> A.BANKCODE       AND L2.BANKCODE = A.BANKCODE                              
 AND NOT EXISTS                                    
  (SELECT L3.DDNO FROM [AngelFO].ACCOUNTFO.DBO.LEDGER1 L3 WITH (NOLOCK), (SELECT VNO, VTYP, BOOKTYPE FROM #LEDGER_BANK WHERE VTYP = 16) L4                                    
  WHERE L1.DDNO = L3.DDNO                                 
  AND CONVERT(VARCHAR(11),L1.DDDT,109) = CONVERT(VARCHAR(11),L3.DDDT,109)                                 
  AND L1.RELAMT = L3.RELAMT                                 
  AND L1.BNKNAME = L3.BNKNAME                                
  AND L1.BOOKTYPE = L3.BOOKTYPE                                   
  AND L3.VNO = L4.VNO                                 
  AND L3.VTYP = L4.VTYP                                 
  AND L3.BOOKTYPE = L4.BOOKTYPE AND L1.CLEAR_MODE = 'C'                                
  )                                   
 AND (RELDT ='1900-01-01 00:00:00.000' OR RELDT >  @FROMDATE )  AND L1.VTYP <> 16                                
 AND A.BANKCODE = B.BANKCODE AND A.SEGMENT = B.SEGMENT                              
 AND A.RECODATE = @FROMDATE                              
 GROUP BY  A.SEGMENT,A.BANKCODE                              
  --AND L.VNO IN ('202104268075', '202104289454') AND L.VTYP=3 AND L.BOOKTYPE='01'                                 
   ) A   , #BANK_RECO_MASTER_ANG B WITH (NOLOCK) WHERE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.RECODATE = @FROMDATE                               
 AND A.BANKCODE = ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.BANKCODE                              
 AND A.BANKCODE = B.BANKCODE                               
 AND A.SEGMENT = B.SEGMENT                        
 AND ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.SEGMENT = B.SEGMENT                                
                              
        insert into tbl_Reco(steps,Date_1)
values ('step30',getdate())                   
                         
  INSERT INTO #LEDGER_BANK_2                      
  SELECT L.CLTCODE AS BANKCODE , L.VNO, L.VTYP, L.BOOKTYPE                       
  FROM [AngelFO].ACCOUNTFO.DBO.LEDGER L (NOLOCK) , ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
  #BANK_RECO_MASTER_ANG B WITH (NOLOCK)        , LEDGER1 L1 (NOLOCK)                      
  WHERE VDT BETWEEN @FROMDATE+1 AND @FROMDATE+3 AND L.VTYP <> '18'                              
  AND A.RECODATE = @FROMDATE                      
  AND CLTCODE = A.BANKCODE                              
  AND A.SEGMENT = B.SEGMENT           
  AND A.BANKCODE = B.BANKCODE                      
  AND RELDT BETWEEN @FROMDATE AND @FROMDATE + ' 23:59'                      
  AND L.VNO = L1.VNO AND  L.VTYP = L1.VTYP  AND L.BOOKTYPE = L1.BOOKTYPE                      
  AND L.VTYP IN (2,3)  
  
    insert into tbl_Reco(steps,Date_1)
values ('step31',getdate())                    
                            
  INSERT INTO #LED1_2                             
  SELECT bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,vtyp,vno,lno,drcr,BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,clear_mode                      
  FROM [AngelFO].ACCOUNTFO.DBO.LEDGER1 L1 (NOLOCK) WHERE RELDT BETWEEN @FROMDATE AND @FROMDATE + ' 23:59'                                   
  AND EXISTS(SELECT VNO FROM #LEDGER_BANK_2 LL WHERE L1.VNO = LL.VNO AND L1.VTYP = LL.VTYP AND L1.BOOKTYPE = LL.BOOKTYPE)                          
    
	
	  insert into tbl_Reco(steps,Date_1)
values ('step32',getdate())                  
                           
UPDATE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG SET DRAMT = ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.DRAMT + A.DRAMT  ,                       
CRAMT = ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.CRAMT + A.CRAMT FROM                              
 ( SELECT  A.SEGMENT,A.BANKCODE,DRAMT= SUM(CASE WHEN UPPER(L.DRCR) = 'C' THEN RELAMT  ELSE 0 END ),                                                    
 CRAMT= SUM(CASE WHEN UPPER(L.DRCR) = 'D' THEN RELAMT ELSE 0 END )                                
FROM                                     
 [AngelFO].ACCOUNTFO.DBO.LEDGER L (NOLOCK),                                     
 #LED1_2 L1 ,                       
 #LEDGER_BANK_2 L2       , ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
  #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
WHERE                                     
 L.VTYP = L2.VTYP AND L.VNO= L2.VNO AND L.BOOKTYPE = L2.BOOKTYPE                                                     
 AND L.VTYP = L1.VTYP AND L.BOOKTYPE = L1.BOOKTYPE AND L.VNO = L1.VNO AND L.LNO = L1.LNO                                        
 AND CLTCODE <> A.BANKCODE       AND L2.BANKCODE = A.BANKCODE                                   
 AND RELDT BETWEEN @FROMDATE AND @FROMDATE + ' 23:59'                                     
 AND A.BANKCODE = B.BANKCODE AND A.SEGMENT = B.SEGMENT                              
 AND A.RECODATE = @FROMDATE                              
 AND VDT > @FROMDATE                      
 GROUP BY  A.SEGMENT,A.BANKCODE                              
  --AND L.VNO IN ('202104268075', '202104289454') AND L.VTYP=3 AND L.BOOKTYPE='01'                                 
   ) A   , #BANK_RECO_MASTER_ANG B WITH (NOLOCK) WHERE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.RECODATE = @FROMDATE                               
 AND A.BANKCODE = ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.BANKCODE                              
 AND ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.SEGMENT = B.SEGMENT                              
 AND A.BANKCODE = B.BANKCODE                               
 AND A.SEGMENT = B.SEGMENT                              
       
	   
	     insert into tbl_Reco(steps,Date_1)
values ('step33',getdate())                            
                      
 TRUNCATE TABLE  #BANK_RECO_MASTER_ANG                              
 TRUNCATE TABLE  #LEDGER_BANK                      
 TRUNCATE TABLE  #LEDGER_BANK_2                      
 TRUNCATE TABLE  #LED1                      
 TRUNCATE TABLE  #LED1_2                      
                               
 INSERT  INTO #BANK_RECO_MASTER_ANG                               
 SELECT [BANK NAME],[Details],[BANKCODE],[TYPE OF ACCOUNT],[SEGMENT],[NAME],[BANK STATEMENT BALANCE]                          
 FROM ACCOUNT.DBO.BANK_RECO_MASTER_ANG B WITH (NOLOCK) WHERE SEGMENT  = 'NSECD'     
 
 
   insert into tbl_Reco(steps,Date_1)
values ('step34',getdate())                         
                               
 UPDATE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG SET  BOOKBAL = A.BOOKBAL FROM                              
 (SELECT A.RECODATE, A.SEGMENT,A.BANKCODE,BOOKBAL = ISNULL(SUM(CASE DRCR WHEN 'D' THEN ISNULL(VAMT,0) ELSE ISNULL(-VAMT,0) END),0)                               
 FROM [AngelFO].ACCOUNTCURFO.DBO.LEDGER L WITH (NOLOCK) , ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
 #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
 WHERE                                 
    VDT >= @STARTDATE                                 
    AND VDT <= @FROMDATE + ' 23:59:59'                                
    AND CLTCODE = A.BANKCODE                              
 AND A.SEGMENT = B.SEGMENT                              
 AND A.BANKCODE = B.BANKCODE                              
 AND A.RECODATE = @FROMDATE GROUP BY A.RECODATE, A.SEGMENT,A.BANKCODE) A , #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
 WHERE BANK_RECO_BALANCE_ANG.RECODATE = @FROMDATE                              
 AND A.RECODATE = BANK_RECO_BALANCE_ANG.RECODATE                              
 AND ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.SEGMENT   = B.SEGMENT                               
 AND ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.BANKCODE = A.BANKCODE                               
 AND A.BANKCODE = B.BANKCODE                              
 AND A.SEGMENT = B.SEGMENT                               
      
	  
	    insert into tbl_Reco(steps,Date_1)
values ('step35',getdate())                        
                               
  INSERT INTO #LEDGER_BANK                                
  SELECT A.BANKCODE, VNO, VTYP, BOOKTYPE FROM [AngelFO].ACCOUNTCURFO.DBO.LEDGER L WITH (NOLOCK) ,                               
  ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
  #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                WHERE VDT BETWEEN @FROMDATE-7 AND @FROMDATE + ' 23:59:59'   AND VTYP <> '18'                             
  AND A.RECODATE = @FROMDATE                              
  AND CLTCODE = A.BANKCODE                              
  AND A.SEGMENT = B.SEGMENT                              
  AND A.BANKCODE = B.BANKCODE                               
         
		   insert into tbl_Reco(steps,Date_1)
values ('step36',getdate())
		 
		    
  INSERT INTO #LED1                                  
  SELECT bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,vtyp,vno,lno,drcr,BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,clear_mode                      
  FROM [AngelFO].ACCOUNTCURFO.DBO.LEDGER1 L1 WITH (NOLOCK) WHERE (RELDT ='1900-01-01 00:00:00.000' OR RELDT >  @FROMDATE )                                    
  AND EXISTS(SELECT VNO FROM #LEDGER_BANK LL WHERE L1.VNO = LL.VNO AND L1.VTYP = LL.VTYP AND L1.BOOKTYPE = LL.BOOKTYPE)                                
         
		   insert into tbl_Reco(steps,Date_1)
values ('step37',getdate())
		                      
                                
UPDATE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG SET DRAMT = A.DRAMT  , CRAMT = A.CRAMT FROM                            
 ( SELECT  A.SEGMENT,A.BANKCODE,DRAMT= SUM(CASE WHEN UPPER(L.DRCR) = 'D' THEN RELAMT  ELSE 0 END ),                                                
 CRAMT= SUM(CASE WHEN UPPER(L.DRCR) = 'C' THEN RELAMT ELSE 0 END )                                     
FROM                                     
 [AngelFO].ACCOUNTCURFO.DBO.LEDGER L WITH (NOLOCK),                                     
 #LED1 L1 ,                                                    
 #LEDGER_BANK L2       , ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
  #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
WHERE                                     
 L.VTYP = L2.VTYP AND L.VNO= L2.VNO AND L.BOOKTYPE = L2.BOOKTYPE                                              
 AND L.VTYP = L1.VTYP AND L.BOOKTYPE = L1.BOOKTYPE AND L.VNO = L1.VNO AND L.LNO = L1.LNO                                        
 AND CLTCODE <> A.BANKCODE       AND L2.BANKCODE = A.BANKCODE                              
 AND NOT EXISTS                                    
  (SELECT L3.DDNO FROM [AngelFO].ACCOUNTCURFO.DBO.LEDGER1 L3 WITH (NOLOCK), (SELECT VNO, VTYP, BOOKTYPE FROM #LEDGER_BANK WHERE VTYP = 16) L4                                    
  WHERE L1.DDNO = L3.DDNO                                 
  AND CONVERT(VARCHAR(11),L1.DDDT,109) = CONVERT(VARCHAR(11),L3.DDDT,109)                                 
  AND L1.RELAMT = L3.RELAMT                                 
  AND L1.BNKNAME = L3.BNKNAME                                
  AND L1.BOOKTYPE = L3.BOOKTYPE                                   
  AND L3.VNO = L4.VNO                                 
  AND L3.VTYP = L4.VTYP                                 
  AND L3.BOOKTYPE = L4.BOOKTYPE AND L1.CLEAR_MODE = 'C'                                
  )                                   
 AND (RELDT ='1900-01-01 00:00:00.000' OR RELDT >  @FROMDATE )  AND L1.VTYP <> 16                                
 AND A.BANKCODE = B.BANKCODE AND A.SEGMENT = B.SEGMENT                              
 AND A.RECODATE = @FROMDATE                              
 GROUP BY  A.SEGMENT,A.BANKCODE                              
  --AND L.VNO IN ('202104268075', '202104289454') AND L.VTYP=3 AND L.BOOKTYPE='01'                                 
   ) A   , #BANK_RECO_MASTER_ANG B WITH (NOLOCK) WHERE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.RECODATE = @FROMDATE                               
 AND A.BANKCODE = ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.BANKCODE                              
 AND A.BANKCODE = B.BANKCODE                               
 AND A.SEGMENT = B.SEGMENT                              
 AND ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.SEGMENT = B.SEGMENT                 
                              
       insert into tbl_Reco(steps,Date_1)
values ('step38',getdate())                   
                         
  INSERT INTO #LEDGER_BANK_2                      
  SELECT L.CLTCODE AS BANKCODE , L.VNO, L.VTYP, L.BOOKTYPE                       
  FROM [AngelFO].ACCOUNTCURFO.DBO.LEDGER L (NOLOCK) , ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
  #BANK_RECO_MASTER_ANG B WITH (NOLOCK)        , LEDGER1 L1 (NOLOCK)                      
  WHERE VDT BETWEEN @FROMDATE+1 AND @FROMDATE+3 AND L.VTYP <> '18'                              
  AND A.RECODATE = @FROMDATE                      
  AND CLTCODE = A.BANKCODE                              
  AND A.SEGMENT = B.SEGMENT                              
  AND A.BANKCODE = B.BANKCODE                      
  AND RELDT BETWEEN @FROMDATE AND @FROMDATE + ' 23:59'                      
  AND L.VNO = L1.VNO AND  L.VTYP = L1.VTYP  AND L.BOOKTYPE = L1.BOOKTYPE                      
  AND L.VTYP IN (2,3)                      
         
		   insert into tbl_Reco(steps,Date_1)
values ('step39',getdate())
		                    
  INSERT INTO #LED1_2                             
  SELECT bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,vtyp,vno,lno,drcr,BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,clear_mode                       
  FROM [AngelFO].ACCOUNTCURFO.DBO.LEDGER1 L1 (NOLOCK) WHERE RELDT BETWEEN @FROMDATE AND @FROMDATE + ' 23:59'                                   
  AND EXISTS(SELECT VNO FROM #LEDGER_BANK_2 LL WHERE L1.VNO = LL.VNO AND L1.VTYP = LL.VTYP AND L1.BOOKTYPE = LL.BOOKTYPE)          
                      
      		   insert into tbl_Reco(steps,Date_1)
values ('step40',getdate())
	  
	                       
UPDATE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG SET DRAMT = ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.DRAMT + A.DRAMT  ,                       
CRAMT = ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.CRAMT + A.CRAMT FROM                              
 ( SELECT  A.SEGMENT,A.BANKCODE,DRAMT= SUM(CASE WHEN UPPER(L.DRCR) = 'C' THEN RELAMT  ELSE 0 END ),                                                    
 CRAMT= SUM(CASE WHEN UPPER(L.DRCR) = 'D' THEN RELAMT ELSE 0 END )                                     
FROM                                     
 [AngelFO].ACCOUNTCURFO.DBO.LEDGER L (NOLOCK),                                     
 #LED1_2 L1 ,                                             
 #LEDGER_BANK_2 L2       , ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
  #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                    WHERE                                     
 L.VTYP = L2.VTYP AND L.VNO= L2.VNO AND L.BOOKTYPE = L2.BOOKTYPE                                                     
 AND L.VTYP = L1.VTYP AND L.BOOKTYPE = L1.BOOKTYPE AND L.VNO = L1.VNO AND L.LNO = L1.LNO                                        
 AND CLTCODE <> A.BANKCODE       AND L2.BANKCODE = A.BANKCODE                          
 AND RELDT BETWEEN @FROMDATE AND @FROMDATE + ' 23:59'                                     
 AND A.BANKCODE = B.BANKCODE AND A.SEGMENT = B.SEGMENT                              
 AND A.RECODATE = @FROMDATE                              
 AND VDT > @FROMDATE                      
 GROUP BY  A.SEGMENT,A.BANKCODE                              
  --AND L.VNO IN ('202104268075', '202104289454') AND L.VTYP=3 AND L.BOOKTYPE='01'                                 
   ) A   , #BANK_RECO_MASTER_ANG B WITH (NOLOCK) WHERE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.RECODATE = @FROMDATE                               
 AND A.BANKCODE = ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.BANKCODE                              
 AND ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.SEGMENT = B.SEGMENT                              
 AND A.BANKCODE = B.BANKCODE                               
 AND A.SEGMENT = B.SEGMENT                          
   
   		   insert into tbl_Reco(steps,Date_1)
values ('step41',getdate())
                               
 UPDATE BANK_RECO_BALANCE_ANG SET OTDIFFBAL = ABS((BANKBAL - BOOKBAL) - (DRAMT - CRAMT)) ,DIFFBAL = ABS(BANKBAL - BOOKBAL)                                
 FROM  #BANK_RECO_MASTER_ANG  WHERE RECODATE = @FROMDATE                              
 AND BANK_RECO_BALANCE_ANG.BANKCODE = #BANK_RECO_MASTER_ANG.BANKCODE AND BANK_RECO_BALANCE_ANG.SEGMENT = #BANK_RECO_MASTER_ANG.SEGMENT                              
  
  		   insert into tbl_Reco(steps,Date_1)
values ('step42',getdate())
                        
 TRUNCATE TABLE  #BANK_RECO_MASTER_ANG                              
 TRUNCATE TABLE  #LEDGER_BANK                      
 TRUNCATE TABLE  #LEDGER_BANK_2                      
 TRUNCATE TABLE  #LED1                      
 TRUNCATE TABLE  #LED1_2                      

INSERT  INTO #BANK_RECO_MASTER_ANG                               
 SELECT [BANK NAME],[Details],[BANKCODE],[TYPE OF ACCOUNT],[SEGMENT],[NAME],[BANK STATEMENT BALANCE]                           
 FROM ACCOUNT.DBO.BANK_RECO_MASTER_ANG B WITH (NOLOCK) WHERE SEGMENT  = 'MCX'  
  
  		   insert into tbl_Reco(steps,Date_1)
values ('step43',getdate())
                             
                               
 UPDATE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG SET  BOOKBAL = A.BOOKBAL FROM                              
 (SELECT A.RECODATE, A.SEGMENT,A.BANKCODE,BOOKBAL = ISNULL(SUM(CASE DRCR WHEN 'D' THEN ISNULL(VAMT,0) ELSE ISNULL(-VAMT,0) END),0)                               
 FROM [AngelCommodity].ACCOUNTMCDX.DBO.LEDGER L WITH (NOLOCK) , ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
 #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
 WHERE                                 
    VDT >= @STARTDATE                                 
    AND VDT <= @FROMDATE + ' 23:59:59'                                
    AND CLTCODE = A.BANKCODE                              
 AND A.SEGMENT = B.SEGMENT                              
 AND A.BANKCODE = B.BANKCODE                             
 AND A.RECODATE = @FROMDATE GROUP BY A.RECODATE, A.SEGMENT,A.BANKCODE) A , #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
 WHERE BANK_RECO_BALANCE_ANG.RECODATE = @FROMDATE                              
 AND A.RECODATE = BANK_RECO_BALANCE_ANG.RECODATE                              
 AND ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.SEGMENT   = B.SEGMENT                               
 AND ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.BANKCODE = A.BANKCODE                               
 AND A.BANKCODE = B.BANKCODE                              
 AND A.SEGMENT = B.SEGMENT                               
          
		   insert into tbl_Reco(steps,Date_1)
values ('step44',getdate())		                         
                               
  INSERT INTO #LEDGER_BANK                                
  SELECT A.BANKCODE, VNO, VTYP, BOOKTYPE FROM [AngelCommodity].ACCOUNTMCDX.DBO.LEDGER L WITH (NOLOCK) ,                               
  ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
  #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
  WHERE VDT BETWEEN @FROMDATE-7 AND @FROMDATE + ' 23:59:59'   AND VTYP <> '18'                             
  AND A.RECODATE = @FROMDATE                              
  AND CLTCODE = A.BANKCODE                              
  AND A.SEGMENT = B.SEGMENT                              
  AND A.BANKCODE = B.BANKCODE                               
  
  		   insert into tbl_Reco(steps,Date_1)
values ('step45',getdate())
                
  INSERT INTO #LED1                                 
  SELECT bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,vtyp,vno,lno,drcr,BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,clear_mode                      
  FROM [AngelCommodity].ACCOUNTMCDX.DBO.LEDGER1 L1 WITH (NOLOCK) WHERE (RELDT ='1900-01-01 00:00:00.000' OR RELDT >  @FROMDATE )                                    
  AND EXISTS(SELECT VNO FROM #LEDGER_BANK LL WHERE L1.VNO = LL.VNO AND L1.VTYP = LL.VTYP AND L1.BOOKTYPE = LL.BOOKTYPE)                                
                              
  		   insert into tbl_Reco(steps,Date_1)
values ('step46',getdate())
                                
UPDATE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG SET DRAMT = A.DRAMT  , CRAMT = A.CRAMT FROM                              
 ( SELECT  A.SEGMENT,A.BANKCODE,DRAMT= SUM(CASE WHEN UPPER(L.DRCR) = 'D' THEN RELAMT  ELSE 0 END ),                                                    
 CRAMT= SUM(CASE WHEN UPPER(L.DRCR) = 'C' THEN RELAMT ELSE 0 END )                                     
FROM                                     
 [AngelCommodity].ACCOUNTMCDX.DBO.LEDGER L WITH (NOLOCK),                                     
 #LED1 L1 ,                                                    
 #LEDGER_BANK L2       , ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
  #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
WHERE                                     
 L.VTYP = L2.VTYP AND L.VNO= L2.VNO AND L.BOOKTYPE = L2.BOOKTYPE                                                      AND L.VTYP = L1.VTYP AND L.BOOKTYPE = L1.BOOKTYPE AND L.VNO = L1.VNO AND L.LNO = L1.LNO                                        
 AND CLTCODE <> A.BANKCODE       AND L2.BANKCODE = A.BANKCODE                              
 AND NOT EXISTS                                    
  (SELECT L3.DDNO FROM [AngelCommodity].ACCOUNTMCDX.DBO.LEDGER1 L3 WITH (NOLOCK), (SELECT VNO, VTYP, BOOKTYPE FROM #LEDGER_BANK WHERE VTYP = 16) L4                                    
  WHERE L1.DDNO = L3.DDNO                                 
  AND CONVERT(VARCHAR(11),L1.DDDT,109) = CONVERT(VARCHAR(11),L3.DDDT,109)                                 
  AND L1.RELAMT = L3.RELAMT                                 
  AND L1.BNKNAME = L3.BNKNAME                                
  AND L1.BOOKTYPE = L3.BOOKTYPE                                   
  AND L3.VNO = L4.VNO                                 
  AND L3.VTYP = L4.VTYP                                 
  AND L3.BOOKTYPE = L4.BOOKTYPE AND L1.CLEAR_MODE = 'C'                                
  )                                   
 AND (RELDT ='1900-01-01 00:00:00.000' OR RELDT >  @FROMDATE )  AND L1.VTYP <> 16                                
 AND A.BANKCODE = B.BANKCODE AND A.SEGMENT = B.SEGMENT                              
 AND A.RECODATE = @FROMDATE                              
 GROUP BY  A.SEGMENT,A.BANKCODE                              
  --AND L.VNO IN ('202104268075', '202104289454') AND L.VTYP=3 AND L.BOOKTYPE='01'                                 
   ) A   , #BANK_RECO_MASTER_ANG B WITH (NOLOCK) WHERE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.RECODATE = @FROMDATE                               
 AND A.BANKCODE = ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.BANKCODE                              
 AND A.BANKCODE = B.BANKCODE                               
 AND A.SEGMENT = B.SEGMENT                              
 AND ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.SEGMENT = B.SEGMENT                                
                      
  		   insert into tbl_Reco(steps,Date_1)
values ('step47',getdate())                     
                         
  INSERT INTO #LEDGER_BANK_2                      
  SELECT L.CLTCODE AS BANKCODE , L.VNO, L.VTYP, L.BOOKTYPE                       
  FROM [AngelCommodity].ACCOUNTMCDX.DBO.LEDGER L (NOLOCK) , ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
  #BANK_RECO_MASTER_ANG B WITH (NOLOCK)        , LEDGER1 L1 (NOLOCK)                      
  WHERE VDT BETWEEN @FROMDATE+1 AND @FROMDATE+3 AND L.VTYP <> '18'                              
  AND A.RECODATE = @FROMDATE                      
  AND CLTCODE = A.BANKCODE                              
  AND A.SEGMENT = B.SEGMENT                              
  AND A.BANKCODE = B.BANKCODE                      
  AND RELDT BETWEEN @FROMDATE AND @FROMDATE + ' 23:59'                      
  AND L.VNO = L1.VNO AND  L.VTYP = L1.VTYP  AND L.BOOKTYPE = L1.BOOKTYPE                      
  AND L.VTYP IN (2,3)                      
  
  		   insert into tbl_Reco(steps,Date_1)
values ('step48',getdate())
                        
  INSERT INTO #LED1_2                             
  SELECT bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,vtyp,vno,lno,drcr,BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,clear_mode                      
  FROM [AngelCommodity].ACCOUNTMCDX.DBO.LEDGER1 L1 (NOLOCK) WHERE RELDT BETWEEN @FROMDATE AND @FROMDATE + ' 23:59'                                   
  AND EXISTS(SELECT VNO FROM #LEDGER_BANK_2 LL WHERE L1.VNO = LL.VNO AND L1.VTYP = LL.VTYP AND L1.BOOKTYPE = LL.BOOKTYPE)                          
       
	   
	   		   insert into tbl_Reco(steps,Date_1)
values ('step49',getdate())               
                           
UPDATE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG SET DRAMT = ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.DRAMT + A.DRAMT  ,                       
CRAMT = ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.CRAMT + A.CRAMT FROM                              
 ( SELECT  A.SEGMENT,A.BANKCODE,DRAMT= SUM(CASE WHEN UPPER(L.DRCR) = 'C' THEN RELAMT  ELSE 0 END ),                                                    
 CRAMT= SUM(CASE WHEN UPPER(L.DRCR) = 'D' THEN RELAMT ELSE 0 END )                                     
FROM                                     
 [AngelCommodity].ACCOUNTMCDX.DBO.LEDGER L (NOLOCK),                                     
 #LED1_2 L1 ,               
 #LEDGER_BANK_2 L2       , ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
  #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
WHERE                                     
 L.VTYP = L2.VTYP AND L.VNO= L2.VNO AND L.BOOKTYPE = L2.BOOKTYPE                                                     
 AND L.VTYP = L1.VTYP AND L.BOOKTYPE = L1.BOOKTYPE AND L.VNO = L1.VNO AND L.LNO = L1.LNO                                        
 AND CLTCODE <> A.BANKCODE       AND L2.BANKCODE = A.BANKCODE                                   
 AND RELDT BETWEEN @FROMDATE AND @FROMDATE + ' 23:59'                                     
 AND A.BANKCODE = B.BANKCODE AND A.SEGMENT = B.SEGMENT                              
 AND A.RECODATE = @FROMDATE                              
 AND VDT > @FROMDATE                      
 GROUP BY  A.SEGMENT,A.BANKCODE                              
  --AND L.VNO IN ('202104268075', '202104289454') AND L.VTYP=3 AND L.BOOKTYPE='01'                                 
   ) A   , #BANK_RECO_MASTER_ANG B WITH (NOLOCK) WHERE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.RECODATE = @FROMDATE                               
 AND A.BANKCODE = ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.BANKCODE                              
 AND ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.SEGMENT = B.SEGMENT                              
 AND A.BANKCODE = B.BANKCODE                               
 AND A.SEGMENT = B.SEGMENT                          
      
	  
	  		   insert into tbl_Reco(steps,Date_1)
values ('step50',getdate())
	                           
 UPDATE BANK_RECO_BALANCE_ANG SET TOTDIFFBAL = ABS((BANKBAL - BOOKBAL) - (DRAMT - CRAMT)) ,DIFFBAL = ABS(BANKBAL - BOOKBAL)                                
 FROM  #BANK_RECO_MASTER_ANG  WHERE RECODATE = @FROMDATE                              
 AND BANK_RECO_BALANCE_ANG.BANKCODE = #BANK_RECO_MASTER_ANG.BANKCODE AND BANK_RECO_BALANCE_ANG.SEGMENT = #BANK_RECO_MASTER_ANG.SEGMENT                   
     
	 		   insert into tbl_Reco(steps,Date_1)
values ('step51',getdate())
	                           
                       
 TRUNCATE TABLE  #BANK_RECO_MASTER_ANG                              
 TRUNCATE TABLE  #LEDGER_BANK                      
 TRUNCATE TABLE  #LEDGER_BANK_2                      
 TRUNCATE TABLE  #LED1                      
 TRUNCATE TABLE  #LED1_2                           
                               
 INSERT  INTO #BANK_RECO_MASTER_ANG                               
 SELECT [BANK NAME],[Details],[BANKCODE],[TYPE OF ACCOUNT],[SEGMENT],[NAME],[BANK STATEMENT BALANCE]                           
 FROM ACCOUNT.DBO.BANK_RECO_MASTER_ANG B WITH (NOLOCK) WHERE SEGMENT  = 'NCDX'                              
  
  		   insert into tbl_Reco(steps,Date_1)
values ('step52',getdate())
                               
 UPDATE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG SET  BOOKBAL = A.BOOKBAL FROM                              
 (SELECT A.RECODATE, A.SEGMENT,A.BANKCODE,BOOKBAL = ISNULL(SUM(CASE DRCR WHEN 'D' THEN ISNULL(VAMT,0) ELSE ISNULL(-VAMT,0) END),0)                               
 FROM [AngelCommodity].ACCOUNTNCDX.DBO.LEDGER L WITH (NOLOCK) , ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
 #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
 WHERE                                 
    VDT >= @STARTDATE                                 
    AND VDT <= @FROMDATE + ' 23:59:59'                                
    AND CLTCODE = A.BANKCODE                              
 AND A.SEGMENT = B.SEGMENT                              
 AND A.BANKCODE = B.BANKCODE                              
 AND A.RECODATE = @FROMDATE GROUP BY A.RECODATE, A.SEGMENT,A.BANKCODE) A , #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
 WHERE BANK_RECO_BALANCE_ANG.RECODATE = @FROMDATE                
 AND A.RECODATE = BANK_RECO_BALANCE_ANG.RECODATE                              
 AND ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.SEGMENT   = B.SEGMENT                 
 AND ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.BANKCODE = A.BANKCODE                               
 AND A.BANKCODE = B.BANKCODE                              
 AND A.SEGMENT = B.SEGMENT          
                                
    		   insert into tbl_Reco(steps,Date_1)
values ('step53',getdate())
	                           
  INSERT INTO #LEDGER_BANK                                
  SELECT A.BANKCODE, VNO, VTYP, BOOKTYPE FROM [AngelCommodity].ACCOUNTNCDX.DBO.LEDGER L WITH (NOLOCK) ,                               
  ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
  #BANK_RECO_MASTER_ANG B WITH (NOLOCK)           
  WHERE VDT BETWEEN @FROMDATE-7 AND @FROMDATE + ' 23:59:59'   AND VTYP <> '18'                                 
  AND A.RECODATE = @FROMDATE                              
  AND CLTCODE = A.BANKCODE                              
  AND A.SEGMENT = B.SEGMENT                              
  AND A.BANKCODE = B.BANKCODE                               
   
   		   insert into tbl_Reco(steps,Date_1)
values ('step54',getdate())
                              
  INSERT INTO #LED1                                 
  SELECT bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,vtyp,vno,lno,drcr,BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,clear_mode                      
  FROM [AngelCommodity].ACCOUNTNCDX.DBO.LEDGER1 L1 WITH (NOLOCK) WHERE (RELDT ='1900-01-01 00:00:00.000' OR RELDT >  @FROMDATE )                                    
  AND EXISTS(SELECT VNO FROM #LEDGER_BANK LL WHERE L1.VNO = LL.VNO AND L1.VTYP = LL.VTYP AND L1.BOOKTYPE = LL.BOOKTYPE)                                
    
			   insert into tbl_Reco(steps,Date_1)
values ('step55',getdate())
	                          
                                
UPDATE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG SET DRAMT = A.DRAMT  , CRAMT = A.CRAMT FROM                              
 ( SELECT  A.SEGMENT,A.BANKCODE,DRAMT= SUM(CASE WHEN UPPER(L.DRCR) = 'D' THEN RELAMT  ELSE 0 END ),                                                    
 CRAMT= SUM(CASE WHEN UPPER(L.DRCR) = 'C' THEN RELAMT ELSE 0 END )                                     
FROM                                     
 [AngelCommodity].ACCOUNTNCDX.DBO.LEDGER L WITH (NOLOCK),                                     
 #LED1 L1 ,                                                    
 #LEDGER_BANK L2       , ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
  #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
WHERE                               
 L.VTYP = L2.VTYP AND L.VNO= L2.VNO AND L.BOOKTYPE = L2.BOOKTYPE                                                     
 AND L.VTYP = L1.VTYP AND L.BOOKTYPE = L1.BOOKTYPE AND L.VNO = L1.VNO AND L.LNO = L1.LNO                    
 AND CLTCODE <> A.BANKCODE       AND L2.BANKCODE = A.BANKCODE                              
 AND NOT EXISTS                                    
  (SELECT L3.DDNO FROM [AngelCommodity].ACCOUNTNCDX.DBO.LEDGER1 L3 WITH (NOLOCK), (SELECT VNO, VTYP, BOOKTYPE FROM #LEDGER_BANK WHERE VTYP = 16) L4                                    
  WHERE L1.DDNO = L3.DDNO                                 
  AND CONVERT(VARCHAR(11),L1.DDDT,109) = CONVERT(VARCHAR(11),L3.DDDT,109)                                 
  AND L1.RELAMT = L3.RELAMT                                 
  AND L1.BNKNAME = L3.BNKNAME                                
  AND L1.BOOKTYPE = L3.BOOKTYPE                                   
  AND L3.VNO = L4.VNO                                 
  AND L3.VTYP = L4.VTYP                                 
  AND L3.BOOKTYPE = L4.BOOKTYPE AND L1.CLEAR_MODE = 'C'                                
  )                                   
 AND (RELDT ='1900-01-01 00:00:00.000' OR RELDT >  @FROMDATE )  AND L1.VTYP <> 16                                
 AND A.BANKCODE = B.BANKCODE AND A.SEGMENT = B.SEGMENT                              
 AND A.RECODATE = @FROMDATE                              
 GROUP BY  A.SEGMENT,A.BANKCODE                              
  --AND L.VNO IN ('202104268075', '202104289454') AND L.VTYP=3 AND L.BOOKTYPE='01'                                 
   ) A   , #BANK_RECO_MASTER_ANG B WITH (NOLOCK) WHERE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.RECODATE = @FROMDATE                               
 AND A.BANKCODE = ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.BANKCODE                              
 AND A.BANKCODE = B.BANKCODE    
 AND A.SEGMENT = B.SEGMENT                              
 AND ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.SEGMENT = B.SEGMENT                                
   
   		   insert into tbl_Reco(steps,Date_1)
values ('step56',getdate())
                        
                      
  INSERT INTO #LEDGER_BANK_2                      
  SELECT L.CLTCODE AS BANKCODE , L.VNO, L.VTYP, L.BOOKTYPE                       
  FROM [AngelCommodity].ACCOUNTNCDX.DBO.LEDGER L (NOLOCK) , ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
  #BANK_RECO_MASTER_ANG B WITH (NOLOCK)        , LEDGER1 L1 (NOLOCK)                      
  WHERE VDT BETWEEN @FROMDATE+1 AND @FROMDATE+3 AND L.VTYP <> '18'                              
  AND A.RECODATE = @FROMDATE                      
  AND CLTCODE = A.BANKCODE                              
  AND A.SEGMENT = B.SEGMENT                              
  AND A.BANKCODE = B.BANKCODE                      
  AND RELDT BETWEEN @FROMDATE AND @FROMDATE + ' 23:59'                      
  AND L.VNO = L1.VNO AND  L.VTYP = L1.VTYP  AND L.BOOKTYPE = L1.BOOKTYPE                      
  AND L.VTYP IN (2,3)                      
   
   		   insert into tbl_Reco(steps,Date_1)
values ('step57',getdate())
   
                            
   INSERT INTO #LED1_2                             
  SELECT bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,vtyp,vno,lno,drcr,BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,clear_mode                      
  FROM [AngelCommodity].ACCOUNTNCDX.DBO.LEDGER1 L1 (NOLOCK) WHERE RELDT BETWEEN @FROMDATE AND @FROMDATE + ' 23:59'                                   
  AND EXISTS(SELECT VNO FROM #LEDGER_BANK_2 LL WHERE L1.VNO = LL.VNO AND L1.VTYP = LL.VTYP AND L1.BOOKTYPE = LL.BOOKTYPE)                          
                   
  		   insert into tbl_Reco(steps,Date_1)
values ('step58',getdate())
                           
UPDATE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG SET DRAMT = ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.DRAMT + A.DRAMT  ,                       
CRAMT = ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.CRAMT + A.CRAMT FROM                              
 ( SELECT  A.SEGMENT,A.BANKCODE,DRAMT= SUM(CASE WHEN UPPER(L.DRCR) = 'C' THEN RELAMT  ELSE 0 END ),                                                    
 CRAMT= SUM(CASE WHEN UPPER(L.DRCR) = 'D' THEN RELAMT ELSE 0 END )                                     
FROM                                     
 [AngelCommodity].ACCOUNTNCDX.DBO.LEDGER L (NOLOCK),                                     
 #LED1_2 L1 ,                                                    
 #LEDGER_BANK_2 L2       , ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
  #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
WHERE                                     
 L.VTYP = L2.VTYP AND L.VNO= L2.VNO AND L.BOOKTYPE = L2.BOOKTYPE                                                     
 AND L.VTYP = L1.VTYP AND L.BOOKTYPE = L1.BOOKTYPE AND L.VNO = L1.VNO AND L.LNO = L1.LNO                 
 AND CLTCODE <> A.BANKCODE       AND L2.BANKCODE = A.BANKCODE                                   
 AND RELDT BETWEEN @FROMDATE AND @FROMDATE + ' 23:59'                                     
 AND A.BANKCODE = B.BANKCODE AND A.SEGMENT = B.SEGMENT                              
 AND A.RECODATE = @FROMDATE                              
 AND VDT > @FROMDATE                      
 GROUP BY  A.SEGMENT,A.BANKCODE                              
  --AND L.VNO IN ('202104268075', '202104289454') AND L.VTYP=3 AND L.BOOKTYPE='01'                                 
   ) A   , #BANK_RECO_MASTER_ANG B WITH (NOLOCK) WHERE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.RECODATE = @FROMDATE                               
 AND A.BANKCODE = ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.BANKCODE                              
 AND ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.SEGMENT = B.SEGMENT                              
 AND A.BANKCODE = B.BANKCODE                        
 AND A.SEGMENT = B.SEGMENT                          
    
			   insert into tbl_Reco(steps,Date_1)
values ('step59',getdate())                  
                               
 UPDATE BANK_RECO_BALANCE_ANG SET TOTDIFFBAL = ABS((BANKBAL - BOOKBAL) - (DRAMT - CRAMT)) ,DIFFBAL = ABS(BANKBAL - BOOKBAL)                                
 FROM  #BANK_RECO_MASTER_ANG  WHERE RECODATE = @FROMDATE                              
 AND BANK_RECO_BALANCE_ANG.BANKCODE = #BANK_RECO_MASTER_ANG.BANKCODE AND BANK_RECO_BALANCE_ANG.SEGMENT = #BANK_RECO_MASTER_ANG.SEGMENT    
 
 		   insert into tbl_Reco(steps,Date_1)
values ('step60',getdate())                          
                        
 TRUNCATE TABLE  #BANK_RECO_MASTER_ANG                              
 TRUNCATE TABLE  #LEDGER_BANK                      
 TRUNCATE TABLE  #LEDGER_BANK_2                      
 TRUNCATE TABLE  #LED1                      
 TRUNCATE TABLE  #LED1_2                      
                               
 INSERT  INTO #BANK_RECO_MASTER_ANG                               
 SELECT [BANK NAME],[Details],[BANKCODE],[TYPE OF ACCOUNT],[SEGMENT],[NAME],[BANK STATEMENT BALANCE]                           
 FROM ACCOUNT.DBO.BANK_RECO_MASTER_ANG B WITH (NOLOCK) WHERE SEGMENT  = 'BSEFO'                              
    
			   insert into tbl_Reco(steps,Date_1)
values ('step61',getdate())
                           
 UPDATE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG SET  BOOKBAL = A.BOOKBAL FROM                              
 (SELECT A.RECODATE, A.SEGMENT,A.BANKCODE,BOOKBAL = ISNULL(SUM(CASE DRCR WHEN 'D' THEN ISNULL(VAMT,0) ELSE ISNULL(-VAMT,0) END),0)                               
 FROM [AngelCommodity].ACCOUNTBFO.DBO.LEDGER L WITH (NOLOCK) , ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
 #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
 WHERE                                 
    VDT >= @STARTDATE                                 
    AND VDT <= @FROMDATE + ' 23:59:59'                                
    AND CLTCODE = A.BANKCODE                              
 AND A.SEGMENT = B.SEGMENT                              
 AND A.BANKCODE = B.BANKCODE                              
 AND A.RECODATE = @FROMDATE GROUP BY A.RECODATE, A.SEGMENT,A.BANKCODE) A , #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
 WHERE BANK_RECO_BALANCE_ANG.RECODATE = @FROMDATE                              
 AND A.RECODATE = BANK_RECO_BALANCE_ANG.RECODATE                              
 AND ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.SEGMENT   = B.SEGMENT                               
 AND ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.BANKCODE = A.BANKCODE                               
 AND A.BANKCODE = B.BANKCODE                              
 AND A.SEGMENT = B.SEGMENT                               
      
	  
	  		   insert into tbl_Reco(steps,Date_1)
values ('step62',getdate())                        
                               
  INSERT INTO #LEDGER_BANK                                
  SELECT A.BANKCODE, VNO, VTYP, BOOKTYPE FROM [AngelCommodity].ACCOUNTBFO.DBO.LEDGER L WITH (NOLOCK) ,                               
  ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
  #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
  WHERE VDT BETWEEN @FROMDATE-7 AND @FROMDATE + ' 23:59:59'   AND VTYP <> '18'                             
  AND A.RECODATE = @FROMDATE                              
  AND CLTCODE = A.BANKCODE                              
  AND A.SEGMENT = B.SEGMENT                              
  AND A.BANKCODE = B.BANKCODE                               
    
			   insert into tbl_Reco(steps,Date_1)
values ('step63',getdate())
	                          
  INSERT INTO #LED1                          
  SELECT  bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,vtyp,vno,lno,drcr,BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,clear_mode                
  FROM [AngelCommodity].ACCOUNTBFO.DBO.LEDGER1 L1 WITH (NOLOCK) WHERE (RELDT ='1900-01-01 00:00:00.000' OR RELDT >  @FROMDATE )                                    
  AND EXISTS(SELECT VNO FROM #LEDGER_BANK LL WHERE L1.VNO = LL.VNO AND L1.VTYP = LL.VTYP AND L1.BOOKTYPE = LL.BOOKTYPE)                                
     
	 		   insert into tbl_Reco(steps,Date_1)
values ('step64',getdate())
	                            
UPDATE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG SET DRAMT = A.DRAMT  , CRAMT = A.CRAMT FROM                              
 ( SELECT  A.SEGMENT,A.BANKCODE,DRAMT= SUM(CASE WHEN UPPER(L.DRCR) = 'D' THEN RELAMT  ELSE 0 END ),                                                    
 CRAMT= SUM(CASE WHEN UPPER(L.DRCR) = 'C' THEN RELAMT ELSE 0 END )                                     
FROM                                   
 [AngelCommodity].ACCOUNTBFO.DBO.LEDGER L WITH (NOLOCK),                                     
 #LED1 L1 ,                                                    
 #LEDGER_BANK L2       , ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
  #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
WHERE                                     
 L.VTYP = L2.VTYP AND L.VNO= L2.VNO AND L.BOOKTYPE = L2.BOOKTYPE                                                     
 AND L.VTYP = L1.VTYP AND L.BOOKTYPE = L1.BOOKTYPE AND L.VNO = L1.VNO AND L.LNO = L1.LNO                                        
 AND CLTCODE <> A.BANKCODE       AND L2.BANKCODE = A.BANKCODE                              
 AND NOT EXISTS                                    
  (SELECT L3.DDNO FROM [AngelCommodity].ACCOUNTBFO.DBO.LEDGER1 L3 WITH (NOLOCK), (SELECT VNO, VTYP, BOOKTYPE FROM #LEDGER_BANK WHERE VTYP = 16) L4                                    
  WHERE L1.DDNO = L3.DDNO                                 
  AND CONVERT(VARCHAR(11),L1.DDDT,109) = CONVERT(VARCHAR(11),L3.DDDT,109)                                 
  AND L1.RELAMT = L3.RELAMT                                 
  AND L1.BNKNAME = L3.BNKNAME                                
  AND L1.BOOKTYPE = L3.BOOKTYPE                                   
  AND L3.VNO = L4.VNO                                
  AND L3.VTYP = L4.VTYP                                 
  AND L3.BOOKTYPE = L4.BOOKTYPE AND L1.CLEAR_MODE = 'C'                                
  )                                   
 AND (RELDT ='1900-01-01 00:00:00.000' OR RELDT >  @FROMDATE )  AND L1.VTYP <> 16                                
 AND A.BANKCODE = B.BANKCODE AND A.SEGMENT = B.SEGMENT                              
 AND A.RECODATE = @FROMDATE                              
 GROUP BY  A.SEGMENT,A.BANKCODE                              
  --AND L.VNO IN ('202104268075', '202104289454') AND L.VTYP=3 AND L.BOOKTYPE='01'                                 
   ) A   , #BANK_RECO_MASTER_ANG B WITH (NOLOCK) WHERE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.RECODATE = @FROMDATE                               
 AND A.BANKCODE = ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.BANKCODE                              
 AND A.BANKCODE = B.BANKCODE                               
 AND A.SEGMENT = B.SEGMENT                              
 AND ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.SEGMENT = B.SEGMENT                                
              
	   insert into tbl_Reco(steps,Date_1)
values ('step65',getdate())                
                       
  INSERT INTO #LEDGER_BANK_2                      
  SELECT L.CLTCODE AS BANKCODE , L.VNO, L.VTYP, L.BOOKTYPE                       
  FROM [AngelCommodity].ACCOUNTBFO.DBO.LEDGER L (NOLOCK) , ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
  #BANK_RECO_MASTER_ANG B WITH (NOLOCK)        , LEDGER1 L1 (NOLOCK)                      
  WHERE VDT BETWEEN @FROMDATE+1 AND @FROMDATE+3 AND L.VTYP <> '18'                              
  AND A.RECODATE = @FROMDATE                      
  AND CLTCODE = A.BANKCODE                              
  AND A.SEGMENT = B.SEGMENT                              
  AND A.BANKCODE = B.BANKCODE                      
  AND RELDT BETWEEN @FROMDATE AND @FROMDATE + ' 23:59'                      
  AND L.VNO = L1.VNO AND  L.VTYP = L1.VTYP  AND L.BOOKTYPE = L1.BOOKTYPE                      
  AND L.VTYP IN (2,3)                      
                            
   INSERT INTO #LED1_2                            
  SELECT bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,vtyp,vno,lno,drcr,BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,clear_mode                      
  FROM [AngelCommodity].ACCOUNTBFO.DBO.LEDGER1 L1 (NOLOCK) WHERE RELDT BETWEEN @FROMDATE AND @FROMDATE + ' 23:59'                                   
  AND EXISTS(SELECT VNO FROM #LEDGER_BANK_2 LL WHERE L1.VNO = LL.VNO AND L1.VTYP = LL.VTYP AND L1.BOOKTYPE = LL.BOOKTYPE)                          
                      
                           
UPDATE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG SET DRAMT = ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.DRAMT + A.DRAMT  ,                       
CRAMT = ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.CRAMT + A.CRAMT FROM                              
 ( SELECT  A.SEGMENT,A.BANKCODE,DRAMT= SUM(CASE WHEN UPPER(L.DRCR) = 'C' THEN RELAMT  ELSE 0 END ),                                                    
 CRAMT= SUM(CASE WHEN UPPER(L.DRCR) = 'D' THEN RELAMT ELSE 0 END )                                     
FROM                                     
 [AngelCommodity].ACCOUNTBFO.DBO.LEDGER L (NOLOCK),                                     
 #LED1_2 L1 ,                                                    
 #LEDGER_BANK_2 L2       , ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
  #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
WHERE                                     
 L.VTYP = L2.VTYP AND L.VNO= L2.VNO AND L.BOOKTYPE = L2.BOOKTYPE                                                     
 AND L.VTYP = L1.VTYP AND L.BOOKTYPE = L1.BOOKTYPE AND L.VNO = L1.VNO AND L.LNO = L1.LNO                                        
 AND CLTCODE <> A.BANKCODE       AND L2.BANKCODE = A.BANKCODE                                   
 AND RELDT BETWEEN @FROMDATE AND @FROMDATE + ' 23:59'                                     
 AND A.BANKCODE = B.BANKCODE AND A.SEGMENT = B.SEGMENT                              
 AND A.RECODATE = @FROMDATE                              
 AND VDT > @FROMDATE                      
 GROUP BY  A.SEGMENT,A.BANKCODE                              
  --AND L.VNO IN ('202104268075', '202104289454') AND L.VTYP=3 AND L.BOOKTYPE='01'                                 
   ) A   , #BANK_RECO_MASTER_ANG B WITH (NOLOCK) WHERE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.RECODATE = @FROMDATE                               
 AND A.BANKCODE = ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.BANKCODE                              
 AND ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.SEGMENT = B.SEGMENT                      
 AND A.BANKCODE = B.BANKCODE                               
 AND A.SEGMENT = B.SEGMENT                           
                       
                               
 UPDATE BANK_RECO_BALANCE_ANG SET TOTDIFFBAL = ABS((BANKBAL - BOOKBAL) - (DRAMT - CRAMT)) ,DIFFBAL = ABS(BANKBAL - BOOKBAL)                                
 FROM  #BANK_RECO_MASTER_ANG  WHERE RECODATE = @FROMDATE                              
 AND BANK_RECO_BALANCE_ANG.BANKCODE = #BANK_RECO_MASTER_ANG.BANKCODE AND BANK_RECO_BALANCE_ANG.SEGMENT = #BANK_RECO_MASTER_ANG.SEGMENT               
                       
 TRUNCATE TABLE  #BANK_RECO_MASTER_ANG                              
 TRUNCATE TABLE  #LEDGER_BANK                      
 TRUNCATE TABLE  #LEDGER_BANK_2                      
 TRUNCATE TABLE  #LED1                      
 TRUNCATE TABLE  #LED1_2                          
                               
 INSERT  INTO #BANK_RECO_MASTER_ANG                               
 SELECT [BANK NAME],[Details],[BANKCODE],[TYPE OF ACCOUNT],[SEGMENT],[NAME],[BANK STATEMENT BALANCE]                           
 FROM ACCOUNT.DBO.BANK_RECO_MASTER_ANG B WITH (NOLOCK) WHERE SEGMENT  = 'MCXCD'                              
                               
 UPDATE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG SET  BOOKBAL = A.BOOKBAL FROM                              
 (SELECT A.RECODATE, A.SEGMENT,A.BANKCODE,BOOKBAL = ISNULL(SUM(CASE DRCR WHEN 'D' THEN ISNULL(VAMT,0) ELSE ISNULL(-VAMT,0) END),0)                               
 FROM [AngelCommodity].ACCOUNTMCDXCDS.DBO.LEDGER L WITH (NOLOCK) , ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
 #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
 WHERE                            
    VDT >= @STARTDATE                                 
    AND VDT <= @FROMDATE + ' 23:59:59'                                
    AND CLTCODE = A.BANKCODE                              
 AND A.SEGMENT = B.SEGMENT                              
 AND A.BANKCODE = B.BANKCODE                              
 AND A.RECODATE = @FROMDATE GROUP BY A.RECODATE, A.SEGMENT,A.BANKCODE) A , #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
WHERE BANK_RECO_BALANCE_ANG.RECODATE = @FROMDATE                              
 AND A.RECODATE = BANK_RECO_BALANCE_ANG.RECODATE                              
 AND ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.SEGMENT   = B.SEGMENT                               
 AND ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.BANKCODE = A.BANKCODE                               
 AND A.BANKCODE = B.BANKCODE                              
 AND A.SEGMENT = B.SEGMENT                                
                              
  INSERT INTO #LEDGER_BANK                                
  SELECT A.BANKCODE, VNO, VTYP, BOOKTYPE FROM [AngelCommodity].ACCOUNTMCDXCDS.DBO.LEDGER L WITH (NOLOCK) ,                               
  ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
  #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
  WHERE VDT BETWEEN @FROMDATE-7 AND @FROMDATE + ' 23:59:59'   AND VTYP <> '18'                             
  AND A.RECODATE = @FROMDATE                              
  AND CLTCODE = A.BANKCODE                              
  AND A.SEGMENT = B.SEGMENT                              
  AND A.BANKCODE = B.BANKCODE                               
                              
  INSERT INTO #LED1                                 
  SELECT  bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,vtyp,vno,lno,drcr,BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,clear_mode                      
  FROM [AngelCommodity].ACCOUNTMCDXCDS.DBO.LEDGER1 L1 WITH (NOLOCK) WHERE (RELDT ='1900-01-01 00:00:00.000' OR RELDT >  @FROMDATE )                                    
  AND EXISTS(SELECT VNO FROM #LEDGER_BANK LL WHERE L1.VNO = LL.VNO AND L1.VTYP = LL.VTYP AND L1.BOOKTYPE = LL.BOOKTYPE)                                
                              
                                
UPDATE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG SET DRAMT = A.DRAMT  , CRAMT = A.CRAMT FROM                             
 ( SELECT  A.SEGMENT,A.BANKCODE,DRAMT= SUM(CASE WHEN UPPER(L.DRCR) = 'D' THEN RELAMT  ELSE 0 END ),                                                    
 CRAMT= SUM(CASE WHEN UPPER(L.DRCR) = 'C' THEN RELAMT ELSE 0 END )                                     
FROM                                     
 [AngelCommodity].ACCOUNTMCDXCDS.DBO.LEDGER L WITH (NOLOCK),               
 #LED1 L1 ,                                                    
 #LEDGER_BANK L2       , ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
  #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
WHERE                                     
 L.VTYP = L2.VTYP AND L.VNO= L2.VNO AND L.BOOKTYPE = L2.BOOKTYPE                                                     
 AND L.VTYP = L1.VTYP AND L.BOOKTYPE = L1.BOOKTYPE AND L.VNO = L1.VNO AND L.LNO = L1.LNO                                        
 AND CLTCODE <> A.BANKCODE       AND L2.BANKCODE = A.BANKCODE                              
 AND NOT EXISTS                                    
  (SELECT L3.DDNO FROM [AngelCommodity].ACCOUNTMCDXCDS.DBO.LEDGER1 L3 WITH (NOLOCK), (SELECT VNO, VTYP, BOOKTYPE FROM #LEDGER_BANK WHERE VTYP = 16) L4                                    
  WHERE L1.DDNO = L3.DDNO                                 
  AND CONVERT(VARCHAR(11),L1.DDDT,109) = CONVERT(VARCHAR(11),L3.DDDT,109)                                 
  AND L1.RELAMT = L3.RELAMT                                 
  AND L1.BNKNAME = L3.BNKNAME                                
  AND L1.BOOKTYPE = L3.BOOKTYPE                                   
  AND L3.VNO = L4.VNO                                 
  AND L3.VTYP = L4.VTYP                                 
  AND L3.BOOKTYPE = L4.BOOKTYPE AND L1.CLEAR_MODE = 'C'                                
  )                                   
 AND (RELDT ='1900-01-01 00:00:00.000' OR RELDT >  @FROMDATE )  AND L1.VTYP <> 16                                
 AND A.BANKCODE = B.BANKCODE AND A.SEGMENT = B.SEGMENT                             
 AND A.RECODATE = @FROMDATE                              
 GROUP BY  A.SEGMENT,A.BANKCODE                              
  --AND L.VNO IN ('202104268075', '202104289454') AND L.VTYP=3 AND L.BOOKTYPE='01'                        
   ) A   , #BANK_RECO_MASTER_ANG B WITH (NOLOCK) WHERE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.RECODATE = @FROMDATE                               
 AND A.BANKCODE = ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.BANKCODE                              
 AND A.BANKCODE = B.BANKCODE                       
 AND A.SEGMENT = B.SEGMENT                              
 AND ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.SEGMENT = B.SEGMENT                                
                              
                          
                       
  INSERT INTO #LEDGER_BANK_2                      
  SELECT L.CLTCODE AS BANKCODE , L.VNO, L.VTYP, L.BOOKTYPE                       
  FROM [AngelCommodity].ACCOUNTMCDXCDS.DBO.LEDGER L (NOLOCK) , ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
  #BANK_RECO_MASTER_ANG B WITH (NOLOCK)        , LEDGER1 L1 (NOLOCK)                      
  WHERE VDT BETWEEN @FROMDATE+1 AND @FROMDATE+3 AND L.VTYP <> '18'                              
  AND A.RECODATE = @FROMDATE                      
  AND CLTCODE = A.BANKCODE                              
  AND A.SEGMENT = B.SEGMENT                              
  AND A.BANKCODE = B.BANKCODE                      
  AND RELDT BETWEEN @FROMDATE AND @FROMDATE + ' 23:59'                      
  AND L.VNO = L1.VNO AND  L.VTYP = L1.VTYP  AND L.BOOKTYPE = L1.BOOKTYPE                      
  AND L.VTYP IN (2,3)                      
                            
  INSERT INTO #LED1_2                             
  SELECT bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,vtyp,vno,lno,drcr,BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,clear_mode                      
  FROM [AngelCommodity].ACCOUNTMCDXCDS.DBO.LEDGER1 L1 (NOLOCK) WHERE RELDT BETWEEN @FROMDATE AND @FROMDATE + ' 23:59'                                   
  AND EXISTS(SELECT VNO FROM #LEDGER_BANK_2 LL WHERE L1.VNO = LL.VNO AND L1.VTYP = LL.VTYP AND L1.BOOKTYPE = LL.BOOKTYPE)                          
                      
                           
UPDATE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG SET DRAMT = ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.DRAMT + A.DRAMT  ,                       
CRAMT = ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.CRAMT + A.CRAMT FROM                              
 ( SELECT  A.SEGMENT,A.BANKCODE,DRAMT= SUM(CASE WHEN UPPER(L.DRCR) = 'C' THEN RELAMT  ELSE 0 END ),                                                    
 CRAMT= SUM(CASE WHEN UPPER(L.DRCR) = 'D' THEN RELAMT ELSE 0 END )                                     
FROM                                     
 [AngelCommodity].ACCOUNTMCDXCDS.DBO.LEDGER L (NOLOCK),                                     
 #LED1_2 L1 ,                                                    
 #LEDGER_BANK_2 L2 , ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
  #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
WHERE                                     
 L.VTYP = L2.VTYP AND L.VNO= L2.VNO AND L.BOOKTYPE = L2.BOOKTYPE                                                     
 AND L.VTYP = L1.VTYP AND L.BOOKTYPE = L1.BOOKTYPE AND L.VNO = L1.VNO AND L.LNO = L1.LNO                                        
 AND CLTCODE <> A.BANKCODE       AND L2.BANKCODE = A.BANKCODE                                   
 AND RELDT BETWEEN @FROMDATE AND @FROMDATE + ' 23:59'                                     
 AND A.BANKCODE = B.BANKCODE AND A.SEGMENT = B.SEGMENT                              
 AND A.RECODATE = @FROMDATE                              
 AND VDT > @FROMDATE                      
 GROUP BY  A.SEGMENT,A.BANKCODE                              
  --AND L.VNO IN ('202104268075', '202104289454') AND L.VTYP=3 AND L.BOOKTYPE='01'                                 
   ) A   , #BANK_RECO_MASTER_ANG B WITH (NOLOCK) WHERE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.RECODATE = @FROMDATE                               
 AND A.BANKCODE = ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.BANKCODE                              
 AND ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.SEGMENT = B.SEGMENT                              
 AND A.BANKCODE = B.BANKCODE                               
 AND A.SEGMENT = B.SEGMENT                           
                       
                               
 UPDATE BANK_RECO_BALANCE_ANG SET TOTDIFFBAL = ABS((BANKBAL - BOOKBAL) - (DRAMT - CRAMT)) ,DIFFBAL = ABS(BANKBAL - BOOKBAL)                                
 FROM  #BANK_RECO_MASTER_ANG  WHERE RECODATE = @FROMDATE                              
 AND BANK_RECO_BALANCE_ANG.BANKCODE = #BANK_RECO_MASTER_ANG.BANKCODE AND BANK_RECO_BALANCE_ANG.SEGMENT = #BANK_RECO_MASTER_ANG.SEGMENT                              
                        
 TRUNCATE TABLE  #BANK_RECO_MASTER_ANG                              
 TRUNCATE TABLE  #LEDGER_BANK                      
 TRUNCATE TABLE  #LEDGER_BANK_2                      
 TRUNCATE TABLE  #LED1                      
 TRUNCATE TABLE  #LED1_2                           
                               
 INSERT  INTO #BANK_RECO_MASTER_ANG                               
 SELECT [BANK NAME],[Details],[BANKCODE],[TYPE OF ACCOUNT],[SEGMENT],[NAME],[BANK STATEMENT BALANCE]                           
 FROM ACCOUNT.DBO.BANK_RECO_MASTER_ANG B WITH (NOLOCK) WHERE SEGMENT  = 'BSE Curr'                              
                               
 UPDATE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG SET  BOOKBAL = A.BOOKBAL FROM                              
 (SELECT A.RECODATE, A.SEGMENT,A.BANKCODE,BOOKBAL = ISNULL(SUM(CASE DRCR WHEN 'D' THEN ISNULL(VAMT,0) ELSE ISNULL(-VAMT,0) END),0)                               
 FROM [AngelCommodity].ACCOUNTCURBFO.DBO.LEDGER L WITH (NOLOCK) , ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
 #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
 WHERE                                 
    VDT >= @STARTDATE                                 
    AND VDT <= @FROMDATE + ' 23:59:59'                                
    AND CLTCODE = A.BANKCODE                              
 AND A.SEGMENT = B.SEGMENT                              
 AND A.BANKCODE = B.BANKCODE                              
 AND A.RECODATE = @FROMDATE GROUP BY A.RECODATE, A.SEGMENT,A.BANKCODE) A , #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
 WHERE BANK_RECO_BALANCE_ANG.RECODATE = @FROMDATE                              
 AND A.RECODATE = BANK_RECO_BALANCE_ANG.RECODATE                              
 AND ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.SEGMENT   = B.SEGMENT                               
 AND ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.BANKCODE = A.BANKCODE                               
 AND A.BANKCODE = B.BANKCODE                              
 AND A.SEGMENT = B.SEGMENT                               
                              
                               
  INSERT INTO #LEDGER_BANK                                
  SELECT A.BANKCODE, VNO, VTYP, BOOKTYPE FROM [AngelCommodity].ACCOUNTCURBFO.DBO.LEDGER L WITH (NOLOCK) ,                               
  ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
  #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
  WHERE VDT BETWEEN @FROMDATE-7 AND @FROMDATE + ' 23:59:59'   AND VTYP <> '18'                             
  AND A.RECODATE = @FROMDATE                              
  AND CLTCODE = A.BANKCODE                              
  AND A.SEGMENT = B.SEGMENT                              
  AND A.BANKCODE = B.BANKCODE                               
                              
  INSERT INTO #LED1                                 
  SELECT bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,vtyp,vno,lno,drcr,BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,clear_mode                      
  FROM [AngelCommodity].ACCOUNTCURBFO.DBO.LEDGER1 L1 WITH (NOLOCK) WHERE (RELDT ='1900-01-01 00:00:00.000' OR RELDT >  @FROMDATE )                                    
  AND EXISTS(SELECT VNO FROM #LEDGER_BANK LL WHERE L1.VNO = LL.VNO AND L1.VTYP = LL.VTYP AND L1.BOOKTYPE = LL.BOOKTYPE)                                
                              
                                
UPDATE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG SET DRAMT = A.DRAMT  , CRAMT = A.CRAMT FROM                              
 ( SELECT  A.SEGMENT,A.BANKCODE,DRAMT= SUM(CASE WHEN UPPER(L.DRCR) = 'D' THEN RELAMT  ELSE 0 END ),                                                    
 CRAMT= SUM(CASE WHEN UPPER(L.DRCR) = 'C' THEN RELAMT ELSE 0 END )                                     
FROM           
 [AngelCommodity].ACCOUNTCURBFO.DBO.LEDGER L WITH (NOLOCK),                                     
 #LED1 L1 ,                                                    
 #LEDGER_BANK L2       , ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
  #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
WHERE                                     
 L.VTYP = L2.VTYP AND L.VNO= L2.VNO AND L.BOOKTYPE = L2.BOOKTYPE                                                     
 AND L.VTYP = L1.VTYP AND L.BOOKTYPE = L1.BOOKTYPE AND L.VNO = L1.VNO AND L.LNO = L1.LNO                                        
 AND CLTCODE <> A.BANKCODE       AND L2.BANKCODE = A.BANKCODE                              
 AND NOT EXISTS                    
  (SELECT L3.DDNO FROM [AngelCommodity].ACCOUNTCURBFO.DBO.LEDGER1 L3 WITH (NOLOCK), (SELECT VNO, VTYP, BOOKTYPE FROM #LEDGER_BANK WHERE VTYP = 16) L4                                    
  WHERE L1.DDNO = L3.DDNO                                 
  AND CONVERT(VARCHAR(11),L1.DDDT,109) = CONVERT(VARCHAR(11),L3.DDDT,109)                                 
  AND L1.RELAMT = L3.RELAMT                                 
  AND L1.BNKNAME = L3.BNKNAME                                
  AND L1.BOOKTYPE = L3.BOOKTYPE                                   
  AND L3.VNO = L4.VNO                                 
  AND L3.VTYP = L4.VTYP                                 
  AND L3.BOOKTYPE = L4.BOOKTYPE AND L1.CLEAR_MODE = 'C'                                
  )                                   
 AND (RELDT ='1900-01-01 00:00:00.000' OR RELDT >  @FROMDATE )  AND L1.VTYP <> 16                                
 AND A.BANKCODE = B.BANKCODE AND A.SEGMENT = B.SEGMENT               
 AND A.RECODATE = @FROMDATE                              
 GROUP BY  A.SEGMENT,A.BANKCODE                              
  --AND L.VNO IN ('202104268075', '202104289454') AND L.VTYP=3 AND L.BOOKTYPE='01'                               
   ) A   , #BANK_RECO_MASTER_ANG B WITH (NOLOCK) WHERE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.RECODATE = @FROMDATE                               
 AND A.BANKCODE = ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.BANKCODE                              
 AND A.BANKCODE = B.BANKCODE                               
 AND A.SEGMENT = B.SEGMENT                              
 AND ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.SEGMENT = B.SEGMENT                               
                       
                       
  INSERT INTO #LEDGER_BANK_2                      
  SELECT L.CLTCODE AS BANKCODE , L.VNO, L.VTYP, L.BOOKTYPE                       
  FROM [AngelCommodity].ACCOUNTCURBFO.DBO.LEDGER L (NOLOCK) , ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
  #BANK_RECO_MASTER_ANG B WITH (NOLOCK)        , LEDGER1 L1 (NOLOCK)                      
  WHERE VDT BETWEEN @FROMDATE+1 AND @FROMDATE+3 AND L.VTYP <> '18'                              
  AND A.RECODATE = @FROMDATE                      
  AND CLTCODE = A.BANKCODE                              
  AND A.SEGMENT = B.SEGMENT                              
  AND A.BANKCODE = B.BANKCODE                      
  AND RELDT BETWEEN @FROMDATE AND @FROMDATE + ' 23:59'                      
  AND L.VNO = L1.VNO AND  L.VTYP = L1.VTYP  AND L.BOOKTYPE = L1.BOOKTYPE                      
  AND L.VTYP IN (2,3)                      
                            
  INSERT INTO #LED1_2               
  SELECT bnkname,brnname,dd,ddno,dddt,reldt,relamt,refno,receiptno,vtyp,vno,lno,drcr,BookType,MicrNo,SlipNo,slipdate,ChequeInName,Chqprinted,clear_mode                      
  FROM [AngelCommodity].ACCOUNTCURBFO.DBO.LEDGER1 L1 (NOLOCK) WHERE RELDT BETWEEN @FROMDATE AND @FROMDATE + ' 23:59'                                   
  AND EXISTS(SELECT VNO FROM #LEDGER_BANK_2 LL WHERE L1.VNO = LL.VNO AND L1.VTYP = LL.VTYP AND L1.BOOKTYPE = LL.BOOKTYPE)                          
                      
                           
UPDATE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG SET DRAMT = ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.DRAMT + A.DRAMT  ,                       
CRAMT = ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.CRAMT + A.CRAMT FROM                              
 ( SELECT  A.SEGMENT,A.BANKCODE,DRAMT= SUM(CASE WHEN UPPER(L.DRCR) = 'C' THEN RELAMT  ELSE 0 END ),                                                    
 CRAMT= SUM(CASE WHEN UPPER(L.DRCR) = 'D' THEN RELAMT ELSE 0 END )                                     
FROM                                     
 [AngelCommodity].ACCOUNTCURBFO.DBO.LEDGER L (NOLOCK),                                     
 #LED1_2 L1 ,                                                    
 #LEDGER_BANK_2 L2   , ACCOUNT.DBO.BANK_RECO_BALANCE_ANG A WITH (NOLOCK),                               
  #BANK_RECO_MASTER_ANG B WITH (NOLOCK)                              
WHERE                                     
 L.VTYP = L2.VTYP AND L.VNO= L2.VNO AND L.BOOKTYPE = L2.BOOKTYPE                                                     
 AND L.VTYP = L1.VTYP AND L.BOOKTYPE = L1.BOOKTYPE AND L.VNO = L1.VNO AND L.LNO = L1.LNO                                        
 AND CLTCODE <> A.BANKCODE       AND L2.BANKCODE = A.BANKCODE                                   
 AND RELDT BETWEEN @FROMDATE AND @FROMDATE + ' 23:59'                                     
 AND A.BANKCODE = B.BANKCODE AND A.SEGMENT = B.SEGMENT                              
 AND A.RECODATE = @FROMDATE                              
 AND VDT > @FROMDATE                      
 GROUP BY  A.SEGMENT,A.BANKCODE                              
  --AND L.VNO IN ('202104268075', '202104289454') AND L.VTYP=3 AND L.BOOKTYPE='01'                                 
   ) A   , #BANK_RECO_MASTER_ANG B WITH (NOLOCK) WHERE ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.RECODATE = @FROMDATE                               
 AND A.BANKCODE = ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.BANKCODE                  
 AND ACCOUNT.DBO.BANK_RECO_BALANCE_ANG.SEGMENT = B.SEGMENT                              
 AND A.BANKCODE = B.BANKCODE                               
 AND A.SEGMENT = B.SEGMENT                           
                       
                               
 UPDATE BANK_RECO_BALANCE_ANG SET TOTDIFFBAL = ABS((BANKBAL - BOOKBAL) - (DRAMT - CRAMT)) ,DIFFBAL = ABS(BANKBAL - BOOKBAL)                                
 FROM  #BANK_RECO_MASTER_ANG  WHERE RECODATE = @FROMDATE                              
 AND BANK_RECO_BALANCE_ANG.BANKCODE = #BANK_RECO_MASTER_ANG.BANKCODE AND BANK_RECO_BALANCE_ANG.SEGMENT = #BANK_RECO_MASTER_ANG.SEGMENT                              
                               
                                
                              
 SELECT B.SRNO,[BANK NAME],[Details],B.BANKCODE,[TYPE OF ACCOUNT],B.SEGMENT,[NAME] ,                              
 A.BANKBAL AS [BANK STATEMENT BALANCE] , A.BOOKBAL AS [BANK BOOK BALANCE], A.CRAMT AS [CHQ. DEPOSITED BUT NOT CREDITED] ,                              
 A.DRAMT AS [CHQ. ISSUED BUT NOT DEBITED],TOTDIFFBAL AS DIFF , [TALLY/ UNTALLY] = CASE WHEN TOTDIFFBAL = 0 THEN 'TALLY' ELSE 'UNTALLY' END,                              
 REMARKS = ''          INTO #FINAL                    
 FROM BANK_RECO_BALANCE_ANG A,                               
 ACCOUNT.DBO.BANK_RECO_MASTER_ANG  B WHERE RECODATE = @FROMDATE  AND                               
 A.SEGMENT = B.SEGMENT AND A.BANKCODE  = B.BANKCODE                               
 AND B.SEGMENT NOT IN ('BSEMFSS','NSEMFSS')                              
             
 INSERT INTO #FINAL                    
 SELECT  SRNO,[BANK NAME],[Details],BANKCODE,[TYPE OF ACCOUNT],SEGMENT,[NAME] ,                              
 0 AS [BANK STATEMENT BALANCE] , 0 AS [BANK BOOK BALANCE], 0 AS [CHQ. DEPOSITED BUT NOT CREDITED] ,                              
 0 AS [CHQ. ISSUED BUT NOT DEBITED],0 AS DIFF , [TALLY/ UNTALLY] = 'TALLY',                              
 REMARKS = ''  FROM BANK_RECO_MASTER_ANG WHERE SRNO NOT IN (SELECT SRNO FROM #FINAL)                    
                    
 SELECT * FROM #FINAL ORDER BY SRNO                  
                    
 DROP TABLE #LED1                              
 DROP TABLE #LED1_2                           
 DROP TABLE #BANK_RECO_MASTER_ANG                              
 DROP TABLE #LEDGER_BANK                      
 DROP TABLE #LEDGER_BANK_2                    
 DROP TABLE #FINAL

GO
