-- Object: PROCEDURE dbo.RPT_ACC_MARGINLEDGER_COMM
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------


CREATE PROCEDURE [DBO].[RPT_ACC_MARGINLEDGER_COMM]                              
@FDATE VARCHAR(11),            /* AS MMM DD YYYY */                              
@TDATE VARCHAR(11),            /* AS MMM DD YYYY */                              
@FCODE VARCHAR(10),                              
@TCODE VARCHAR(10),                              
@STRORDER VARCHAR(6),                              
@SELECTBY VARCHAR(3),                              
@STATUSID VARCHAR(15),                              
@STATUSNAME VARCHAR(15),                              
@STRBRANCH VARCHAR(10)                              
AS                              
                              
DECLARE @@OPENDATE   AS VARCHAR(11)                              
    
-------------------------------------------------      
-- CREATING TEMPORARY TABLE      
-------------------------------------------------      
CREATE TABLE #OPPBALANCE      
(      
 CLTCODE VARCHAR(10),      
 OPPBAL MONEY      
)      
      
CREATE TABLE #LEDGERCLIENTS (      
	 [PARTY_CODE] [CHAR](10) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NOT NULL,    
	 [BANK_NAME] [VARCHAR](20) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NOT NULL,    
	 [L_ADDRESS1] [VARCHAR](40) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NOT NULL,    
	 [L_ADDRESS2] [VARCHAR](40) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NULL,    
	 [L_ADDRESS3] [VARCHAR](40) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NULL,    
	 [L_CITY] [VARCHAR](40) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NULL,    
	 [L_ZIP] [VARCHAR](10) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NULL,    
	 [RES_PHONE1] [VARCHAR](15) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NULL,    
	 [BRANCH_CD] [VARCHAR](10) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NULL,    
	 [FAMILY] [VARCHAR](10) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NOT NULL,    
	 [SUB_BROKER] [VARCHAR](10) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NOT NULL,    
	 [TRADER] [VARCHAR](20) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NULL,    
	 [CL_TYPE] [VARCHAR](3) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NOT NULL,    
	 [CLTDPID] [VARCHAR](20) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NOT NULL    
)      
      
CREATE TABLE #LEDGERDATA (      
	 [VTYP] [SMALLINT] NOT NULL,      
	 [VNO] [VARCHAR](12) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NOT NULL,      
	 [EDT] [DATETIME] NULL,      
	 [LNO] [INT] NOT NULL,      
	 [ACNAME] [VARCHAR](100) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NOT NULL,      
	 [DRCR] [CHAR](1) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NULL,      
	 [VAMT] [MONEY] NULL,      
	 [VDT] [DATETIME] NULL,      
	 [VNO1] [VARCHAR](12) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NULL,      
	 [REFNO] [CHAR](12) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NULL,      
	 [BALAMT] [MONEY] NOT NULL,      
	 [NODAYS] [INT] NULL,      
	 [CDT] [DATETIME] NULL,      
	 [CLTCODE] [VARCHAR](10) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NOT NULL,   
	 [BOOKTYPE] [CHAR](2) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NOT NULL,      
	 [ENTEREDBY] [VARCHAR](25) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NULL,      
	 [PDT] [DATETIME] NULL,      
	 [CHECKEDBY] [VARCHAR](25) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NULL,      
	 [ACTNODAYS] [INT] NULL,      
	 [NARRATION] [VARCHAR](234) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NULL,      
	 [SHORTDESC] [VARCHAR](35) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NULL      
)      
    
                        
CREATE TABLE [DBO].[#MARGINLEDGERDATA] (                                
  [BOOKTYPE] [CHAR] (2) NULL ,                                
  [VOUDT] [DATETIME] NULL ,                                
  [EFFDT] [DATETIME] NULL ,                                
  [ACNAME] [VARCHAR] (100) NULL ,                      
  [SHORTDESC] [CHAR] (6) NULL ,                                  
  [DRCR] [CHAR] (1) NULL ,                                
  [AMOUNT] [MONEY] NULL ,                                
  [VNO] [VARCHAR] (12) NULL ,                                
  [DDNO] [VARCHAR] (12) NULL ,                                
  [NARRATION] [VARCHAR] (234) NULL ,                                
  [PARTY_CODE] [VARCHAR] (10) NOT NULL ,                                
  [VTYP] [SMALLINT] NULL ,                                
  [VDT] [VARCHAR] (30) NULL ,                                
  [EDT] [VARCHAR] (30) NULL ,                                            
  [LNO] [DECIMAL](5, 0) NULL,            
  [PDT] [DATETIME] NULL            
 )    
    
CREATE TABLE #TMPMLEDGER (    
 [BOOKTYPE] [CHAR](2) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NULL,    
 [VOUDT] [DATETIME] NULL,    
 [EFFDT] [DATETIME] NULL,    
 [SHORTDESC] [CHAR](6) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NULL,    
 [DRAMT] [MONEY] NULL,    
 [CRAMT] [MONEY] NULL,    
 [VNO] [VARCHAR](12) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NULL,    
 [DDNO] [VARCHAR](12) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NULL,    
 [NARRATION] [VARCHAR](234) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NULL,    
 [CLTCODE] [CHAR](10) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NOT NULL,    
 [VTYP] [SMALLINT] NULL,    
 [VDT] [VARCHAR](30) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NULL,    
 [EDT] [VARCHAR](30) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NULL,    
 [ACNAME] [VARCHAR](100) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NULL,    
 [OPBAL] [MONEY] NULL,    
 [L_ADDRESS1] [VARCHAR](40) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NOT NULL,    
 [L_ADDRESS2] [VARCHAR](40) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NULL,    
 [L_ADDRESS3] [VARCHAR](40) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NULL,    
 [L_CITY] [VARCHAR](40) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NULL,    
 [L_ZIP] [VARCHAR](10) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NULL,    
 [RES_PHONE1] [VARCHAR](15) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NULL,    
 [BRANCH_CD] [VARCHAR](10) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NULL,    
 [CROSAC] [VARCHAR](10) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NULL,    
 [EDIFF] [INT] NULL,    
 [FAMILY] [VARCHAR](10) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NOT NULL,    
 [SUB_BROKER] [VARCHAR](10) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NOT NULL,    
 [TRADER] [VARCHAR](20) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NULL,    
 [CL_TYPE] [VARCHAR](3) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NOT NULL,    
 [BANK_NAME] [VARCHAR](20) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NOT NULL,    
 [CLTDPID] [VARCHAR](20) COLLATE SQL_LATIN1_GENERAL_CP1_CI_AS NOT NULL,    
 [LNO] [DECIMAL](5, 0) NULL,    
 [PDT] [DATETIME] NULL    
)     
-------------------------------------------------      
-- CREATING TEMPORARY TABLES      
-------------------------------------------------      
                              
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                              
                      
SELECT @@OPENDATE = SDTCUR FROM PARAMETER WHERE @FDATE BETWEEN SDTCUR AND LDTCUR              
                              
/*GETTING OPENING BALANCE*/                              
IF @SELECTBY = 'VDT'                
BEGIN                              
 IF @@OPENDATE = @FDATE          
 BEGIN                              
  INSERT INTO  #OPPBALANCE                               
  SELECT CLTCODE=PARTY_CODE,OPPBAL = ISNULL(SUM( CASE WHEN UPPER(DRCR) = 'D' THEN AMOUNT ELSE -AMOUNT END),0)       
  FROM MARGINLEDGER                               
  WHERE PARTY_CODE >= @FCODE AND PARTY_CODE <=@TCODE AND  VDT LIKE @FDATE + '%' AND VTYP = 18                               
  GROUP BY PARTY_CODE                              
 END                              
 ELSE                              
 BEGIN                              
  INSERT INTO  #OPPBALANCE                               
  SELECT CLTCODE=PARTY_CODE,OPPBAL = ISNULL(SUM( CASE WHEN UPPER(DRCR) = 'D' THEN AMOUNT ELSE -AMOUNT END),0)                                
  FROM MARGINLEDGER                               
  WHERE PARTY_CODE >=@FCODE AND PARTY_CODE <= @TCODE  AND  VDT >=  @@OPENDATE + ' 00:00:00' AND VDT < @FDATE                               
  GROUP BY PARTY_CODE                              
 END                              
END                               
ELSE                              
BEGIN                               
 IF @@OPENDATE = @FDATE                               
 BEGIN        INSERT INTO  #OPPBALANCE                            
  SELECT CLTCODE=PARTY_CODE, OPBAL = SUM(SETT_NO)                          
  FROM MARGINLEDGER                           
  WHERE PARTY_CODE = @FCODE AND VDT LIKE @@OPENDATE + '%' AND VTYP = 18                          
  GROUP BY PARTY_CODE                          
 END                            
 ELSE                            
 BEGIN                            
  INSERT INTO  #OPPBALANCE                               
  SELECT CLTCODE, OPBAL=SUM(OPBAL)                          
  FROM                          
  (                         
  SELECT CLTCODE=PARTY_CODE, OPBAL = SUM(SETT_NO)                          
  FROM MARGINLEDGER                           
  WHERE PARTY_CODE = @FCODE AND VDT LIKE @@OPENDATE + '%' AND VTYP = 18                          
  GROUP BY PARTY_CODE                          
  UNION ALL                          
  SELECT CLTCODE=PARTY_CODE, OPBAL = SUM( CASE WHEN UPPER(DRCR) = 'D' THEN AMOUNT ELSE -AMOUNT END)                          
  FROM MARGINLEDGER                           
  WHERE PARTY_CODE = @FCODE AND VDT >= @@OPENDATE + ' 00:00:00' AND VDT < @FDATE AND VTYP <> 18                          
  GROUP BY PARTY_CODE) T                          
  GROUP BY CLTCODE                          
 END                            
END                              
                        
              
                        
IF @SELECTBY = 'VDT'                        
BEGIN                        
 INSERT INTO #MARGINLEDGERDATA                        
  SELECT M.BOOKTYPE, VOUDT=M.VDT , EFFDT=L.EDT, L.ACNAME, ISNULL(SHORTDESC,'') SHORTDESC, M.DRCR,M.AMOUNT,                         
  M.VNO,DDNO= ISNULL((SELECT MAX(DDNO) FROM LEDGER1 L1 WHERE L1.VNO=M.VNO AND L1.VTYP=M.VTYP AND L1.BOOKTYPE=M.BOOKTYPE AND L1.LNO = M.LNO),''),                         
  L.NARRATION, M.PARTY_CODE, M.VTYP, CONVERT(VARCHAR,M.VDT,103) VDT, CONVERT(VARCHAR,L.EDT,103) EDT,M.LNO, M.VDT                         
  FROM MARGINLEDGER M LEFT OUTER JOIN LEDGER L ON M.VTYP = L.VTYP AND M.BOOKTYPE = L.BOOKTYPE AND M.VNO = L.VNO                       
  AND M.LNO = L.LNO LEFT OUTER JOIN ACMAST A ON M.PARTY_CODE = A.CLTCODE , VMAST V                         
  WHERE L.VDT >= @FDATE + ' 00:00:00' AND L.VDT <= @TDATE + ' 23:59:59'                        
  AND M.PARTY_CODE >= @FCODE AND M.PARTY_CODE <= @TCODE AND M.VTYP <> 18 AND ACCAT = '4' AND M.VTYP = V.VTYPE                         
END                        
ELSE                        
BEGIN                        
  INSERT INTO #MARGINLEDGERDATA                        
  SELECT M.BOOKTYPE, VOUDT=M.VDT, EFFDT=L.EDT, L.ACNAME, ISNULL(SHORTDESC,'') SHORTDESC, M.DRCR,M.AMOUNT,                         
  M.VNO,DDNO= ISNULL((SELECT DDNO FROM LEDGER1 L1 WHERE L1.VNO=M.VNO AND L1.VTYP=M.VTYP AND L1.BOOKTYPE=M.BOOKTYPE AND L1.LNO = M.LNO),''),                       
  L.NARRATION, M.PARTY_CODE, M.VTYP, CONVERT(VARCHAR,M.VDT,103) VDT, CONVERT(VARCHAR,L.EDT,103) EDT,M.LNO, M.VDT            
  FROM MARGINLEDGER M LEFT OUTER JOIN LEDGER L ON M.VTYP = L.VTYP AND M.BOOKTYPE = L.BOOKTYPE AND M.VNO = L.VNO                       
 AND M.LNO = L.LNO LEFT OUTER JOIN ACMAST A ON M.PARTY_CODE = A.CLTCODE , VMAST V                         
  WHERE L.EDT >= @FDATE + ' 00:00:00' AND L.EDT <= @TDATE + ' 23:59:59'                        
  AND M.PARTY_CODE >= @FCODE AND M.PARTY_CODE <= @TCODE AND M.VTYP <> 18 AND ACCAT = '4' AND M.VTYP = V.VTYPE                         
END                        
                        
                              
/*GETTING CLIENT LIST*/                              
INSERT INTO #LEDGERCLIENTS     
SELECT C2.PARTY_CODE,BANK_NAME =ISNULL(C4.BANKID,''),                              
L_ADDRESS1,L_ADDRESS2,L_ADDRESS3,L_CITY,L_ZIP,RES_PHONE1,C1.BRANCH_CD,                      
FAMILY,C1.SUB_BROKER,TRADER,CL_TYPE,CLTDPID =ISNULL(CLTDPID,'')                              
FROM MSAJAG.DBO.CLIENT1 C1 ,MSAJAG.DBO.CLIENT2 C2 LEFT OUTER JOIN MSAJAG.DBO.CLIENT4  C4 ON                              
(C2.PARTY_CODE=C4.PARTY_CODE  AND  DEPOSITORY NOT IN ('NSDL','CDSL')  AND  DEFDP=1)                              
WHERE C1.CL_CODE=C2.CL_CODE                              
AND C1.BRANCH_CD LIKE (CASE WHEN @STATUSID = 'BRANCH' THEN @STATUSNAME ELSE  '%' END)                              
AND SUB_BROKER LIKE (CASE WHEN @STATUSID = 'SUB_BROKER' THEN @STATUSNAME ELSE  '%' END)                              
AND TRADER LIKE (CASE WHEN @STATUSID = 'TRADER' THEN @STATUSNAME ELSE  '%' END)                              
AND C1.FAMILY LIKE (CASE WHEN @STATUSID = 'FAMILY' THEN @STATUSNAME ELSE  '%' END)                              
AND C2.PARTY_CODE LIKE (CASE WHEN @STATUSID = 'CLIENT' THEN @STATUSNAME ELSE  '%' END)                              
AND C1.BRANCH_CD LIKE @STRBRANCH +'%'                              
AND C2.PARTY_CODE >= @FCODE AND C2.PARTY_CODE <= @TCODE                   
                         
     
/*GETTING LDDGER ENTRIES*/                              
INSERT INTO #TMPMLEDGER    
SELECT M.BOOKTYPE, M.VOUDT, M.EFFDT, M.SHORTDESC,                               
DRAMT=(CASE WHEN UPPER(M.DRCR) = 'D' THEN M.AMOUNT ELSE 0 END),                                
CRAMT=(CASE WHEN UPPER(M.DRCR) = 'C' THEN M.AMOUNT ELSE 0 END),                              
M.VNO, M.DDNO, M.NARRATION, C.PARTY_CODE CLTCODE,M.VTYP, M.VDT,                               
M.EDT, M.ACNAME , OPBAL = AMOUNT,                               
C.L_ADDRESS1,C.L_ADDRESS2,C.L_ADDRESS3,C.L_CITY,C.L_ZIP,C.RES_PHONE1,C.BRANCH_CD, M.PARTY_CODE CROSAC ,                           
EDIFF=DATEDIFF(D,M.EFFDT,GETDATE()), C.FAMILY,C.SUB_BROKER,C.TRADER,C.CL_TYPE,                              
C.BANK_NAME,C.CLTDPID, M.LNO, M.PDT                                     
FROM  #MARGINLEDGERDATA M RIGHT OUTER JOIN #LEDGERCLIENTS C ON (M.PARTY_CODE=C.PARTY_CODE)                              
            
    
/*UPDATING OPENING BLANACE*/                              
UPDATE #TMPMLEDGER SET OPBAL = 0                              
UPDATE #TMPMLEDGER SET OPBAL = T.OPPBAL FROM #TMPMLEDGER M,#OPPBALANCE T WHERE M.CLTCODE = T.CLTCODE                              
                        
                              
/*UPDATING BANK NAME*/                                             
/*UPDATE  #TMPMLEDGER SET #TMPMLEDGER.BANK_NAME= B.BANK_NAME  FROM                              
MSAJAG.DBO.POBANK  B WHERE LTRIM(RTRIM(CAST(B.BANKID  AS CHAR))) = LTRIM(RTRIM(#TMPMLEDGER.BANK_NAME))                        */      
                          
UPDATE  #TMPMLEDGER SET #TMPMLEDGER.ACNAME= A.ACNAME  FROM                              
ACMAST A WHERE LTRIM(RTRIM(A.CLTCODE)) = LTRIM(RTRIM(#TMPMLEDGER.CLTCODE))                              
                
              
                        
IF @STRORDER = 'ACCODE'                              
 BEGIN                              
  IF @SELECTBY = 'VDT'                              
   BEGIN                               
    SELECT L.* FROM #TMPMLEDGER L,ACMAST A  WHERE  L.CLTCODE = A.CLTCODE AND ACCAT IN ('4','104') ORDER BY L.CLTCODE,VOUDT                              
   END                              
  ELSE                              
   BEGIN                              
    SELECT L.* FROM #TMPMLEDGER L,ACMAST A   WHERE  L.CLTCODE = A.CLTCODE AND ACCAT IN ('4','104') ORDER BY L.CLTCODE,EFFDT                              
   END                              
 END         
ELSE                              
  BEGIN                              
   IF @SELECTBY = 'VDT'                              
    BEGIN                               
     SELECT L.* FROM #TMPMLEDGER L,ACMAST A   WHERE L.CLTCODE = A.CLTCODE AND ACCAT IN ('4','104') ORDER BY L.ACNAME,VOUDT                              
    END                              
   ELSE                              
    BEGIN                              
     SELECT L.* FROM #TMPMLEDGER L,ACMAST A  WHERE L.CLTCODE = A.CLTCODE AND ACCAT IN ('4','104') ORDER BY L.ACNAME,EFFDT                              
    END                              
  END                              
                              
/*  ------------------------------   END OF THE PROC  -------------------------------------*/                              
                              
                            
-------------------------------------------------      
-- DESTROYING TEMPORARY TABLE      
-------------------------------------------------      
TRUNCATE TABLE #OPPBALANCE                            
TRUNCATE TABLE #LEDGERCLIENTS      
TRUNCATE TABLE #LEDGERDATA      
TRUNCATE TABLE #TMPMLEDGER    
      
DROP TABLE #OPPBALANCE      
DROP TABLE #LEDGERCLIENTS                        
DROP TABLE #LEDGERDATA                      
DROP TABLE #TMPMLEDGER    
-------------------------------------------------      
-- DESTROYING TEMPORARY TABLE      
-------------------------------------------------

GO
