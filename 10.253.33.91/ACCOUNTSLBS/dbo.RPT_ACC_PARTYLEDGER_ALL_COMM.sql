-- Object: PROCEDURE dbo.RPT_ACC_PARTYLEDGER_ALL_COMM
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

/*      
Exec rpt_acc_partyledger_all_Comm 'Apr  1 2005','Mar 31 2006','0A141','0A141','ACCODE','vdt','broker','broker','%','Y'    
EXEC account..RPT_ACC_PARTYLEDGER 'Apr  2 2008','Oct 15 2008','0A141','0A141','ACCODE','vdt','broker','broker',''      
*/        
CREATE PROCEDURE [dbo].[RPT_ACC_PARTYLEDGER_ALL_COMM]          
 @FDATE VARCHAR(11),            /* AS MMM DD YYYY */          
 @TDATE VARCHAR(11),            /* AS MMM DD YYYY */          
 @FCODE VARCHAR(10),          
 @TCODE VARCHAR(10),          
 @STRORDER VARCHAR(6),          
 @SELECTBY VARCHAR(3),          
 @STATUSID VARCHAR(15),          
 @STATUSNAME VARCHAR(15),          
 @STRBRANCH VARCHAR(10),          
 @ORDERFLG VARCHAR(1) = 'N' ,          
 @SINGLE VARCHAR(1) = 'N'          
          
AS          
         
          
 CREATE TABLE [DBO].[#TMPLEDGERNEW]           
 (          
  [BOOKTYPE] [CHAR] (2) NULL ,          
  [VOUDT] [DATETIME] NULL ,          
  [EFFDT] [DATETIME] NULL ,          
  [SHORTDESC] [VARCHAR] (35) NULL ,          
  [DRAMT] [MONEY] NULL ,          
  [CRAMT] [MONEY] NULL ,          
  [VNO] [VARCHAR] (12) NULL ,          
  [DDNO] [VARCHAR] (20) NULL ,          
  [NARRATION] [VARCHAR] (234) NULL ,          
  [CLTCODE] [VARCHAR] (10) NOT NULL ,          
  [VTYP] [SMALLINT] NULL ,          
  [VDT] [VARCHAR] (30) NULL ,          
  [EDT] [VARCHAR] (30) NULL ,          
  [ACNAME] [VARCHAR] (100) NULL ,          
  [OPBAL] [MONEY] NULL ,          
  [L_ADDRESS1] [VARCHAR] (40) NULL ,          
  [L_ADDRESS2] [VARCHAR] (40) NULL ,          
  [L_ADDRESS3] [VARCHAR] (40) NULL ,          
  [L_CITY] [VARCHAR] (40) NULL ,          
  [L_ZIP] [VARCHAR] (10) NULL ,          
  [RES_PHONE1] [VARCHAR] (15) NULL ,          
  [BRANCH_CD] [VARCHAR] (10) NULL ,          
  [CROSAC] [VARCHAR] (10) NULL ,          
  [EDIFF] [INT] NULL ,          
  [FAMILY] [VARCHAR] (10) NULL ,          
  [SUB_BROKER] [VARCHAR] (10) NULL ,          
  [TRADER] [VARCHAR] (20) NULL ,          
  [CL_TYPE] [VARCHAR] (3) NULL ,          
  [BANK_NAME] [VARCHAR] (50) NULL ,          
  [CLTDPID] [VARCHAR] (20) NULL ,          
  [LNO] [INT] NULL ,          
  [PDT] [DATETIME] NULL ,          
  [EXCHANGE] [VARCHAR] (15) NULL,          
  [SEGMENT] [VARCHAR] (15) NULL,          
  [ENTITY] [VARCHAR] (50) NULL,          
  [ORDERSEG][BIGINT] NULL          
 ) ON [PRIMARY]          
          
 CREATE TABLE #OPBAL          
 (          
  CLTCODE VARCHAR(10),          
  SEGMENT VARCHAR(10),          
  ORDERSEG INT,          
  OPBAL MONEY          
 )          
          
 CREATE TABLE #FINOPBAL          
 (          
  CLTCODE VARCHAR(10),          
  ORDERSEG INT,          
  OPBAL MONEY          
 )          
        
DECLARE        
 @@ACCOUNTDB VARCHAR(20),        
 @@EXCHANGE VARCHAR(15),        
 @@SEGMENT VARCHAR(15),        
 @@SQL VARCHAR(1000),        
 @@SEGORD TINYINT,        
 @@MAINREC AS CURSOR        
        
SET @@MAINREC = CURSOR FOR                      
                
SELECT ACCOUNTDB, EXCHANGE, SEGMENT FROM PRADNYA.DBO.MULTICOMPANY WHERE PRIMARYSERVER = 1         
            
/*select vno,vtyp,booktype,count(1) from ledger(nolock)            
where lno=2 and vdt between 'APR  1 2007' and 'MAR 31 2008'            
group by vno,vtyp,booktype            
having count(1)>1 */            
             
SET @@SEGORD = 1        
                    
OPEN @@MAINREC                      
 FETCH NEXT FROM @@MAINREC INTO @@ACCOUNTDB, @@EXCHANGE, @@SEGMENT                    
WHILE @@FETCH_STATUS = 0                      
BEGIN                      
        
 IF @@ACCOUNTDB = 'ACCOUNT' OR @@ACCOUNTDB = 'ACCOUNTBSE' OR @@ACCOUNTDB = 'ACCOUNTFO'  OR @@ACCOUNTDB = 'ACCOUNTBFO' OR @@ACCOUNTDB = 'ACCOUNTCURFO' OR @@ACCOUNTDB = 'ACCOUNTCURBFO' OR @@ACCOUNTDB  = 'ACCOUNTMCDXCDS'     
 BEGIN        
  --PRINT 'NSECMINSERT'          
  SET @@SQL = "INSERT INTO #TMPLEDGERNEW(BOOKTYPE,VOUDT,EFFDT,SHORTDESC,DRAMT,CRAMT,VNO,DDNO,NARRATION,CLTCODE,  "        
  SET @@SQL = @@SQL +  "VTYP,VDT,EDT,ACNAME,OPBAL,L_ADDRESS1,L_ADDRESS2,L_ADDRESS3,L_CITY,L_ZIP,RES_PHONE1,BRANCH_CD,  "        
  SET @@SQL = @@SQL +  "CROSAC,EDIFF,FAMILY,SUB_BROKER,TRADER,CL_TYPE,BANK_NAME,CLTDPID,LNO, PDT)  "        
  SET @@SQL = @@SQL +  "EXEC " + @@ACCOUNTDB + ".DBO.RPT_ACC_PARTYLEDGER_COMM '" + @FDATE + "','" + @TDATE + "','"        
  SET @@SQL = @@SQL +  @FCODE + "','" + @TCODE + "','" + @STRORDER + "','" + @SELECTBY + "','" + @STATUSID + "','" + @STATUSNAME + "','" + @STRBRANCH + "'"        
       
  PRINT @@SQL        
  EXEC (@@SQL)        
        
 IF @ORDERFLG = 'N'          
  BEGIN          
   UPDATE #TMPLEDGERNEW SET EXCHANGE = @@EXCHANGE, SEGMENT= @@SEGMENT, ENTITY='SETTLEMENT LEDGER', ORDERSEG = 1 WHERE SEGMENT IS NULL          
  END          
  ELSE          
  BEGIN          
   UPDATE #TMPLEDGERNEW SET EXCHANGE = @@EXCHANGE, SEGMENT= @@SEGMENT, ENTITY =  @@EXCHANGE + ' - ' + @@SEGMENT, ORDERSEG = @@SEGORD WHERE SEGMENT IS NULL          
  END          
        
  SET @@SQL = "INSERT INTO #TMPLEDGERNEW(BOOKTYPE,VOUDT,EFFDT,SHORTDESC,DRAMT,CRAMT,VNO,DDNO,NARRATION,CLTCODE,  "        
  SET @@SQL = @@SQL +  "VTYP,VDT,EDT,ACNAME,OPBAL,L_ADDRESS1,L_ADDRESS2,L_ADDRESS3,L_CITY,L_ZIP,RES_PHONE1,BRANCH_CD,  "        
  SET @@SQL = @@SQL +  "CROSAC,EDIFF,FAMILY,SUB_BROKER,TRADER,CL_TYPE,BANK_NAME,CLTDPID,LNO, PDT)  "        
  SET @@SQL = @@SQL +  "EXEC " + @@ACCOUNTDB + ".DBO.RPT_ACC_MARGINLEDGER_COMM '" + @FDATE + "','" + @TDATE + "','"        
  SET @@SQL = @@SQL +  @FCODE + "','" + @TCODE + "','" + @STRORDER + "','" + @SELECTBY + "','" + @STATUSID + "','" + @STATUSNAME + "','" + @STRBRANCH + "'"        
        
  PRINT @@SQL        
  EXEC (@@SQL)        
        
 IF @ORDERFLG = 'N'          
  BEGIN          
   UPDATE #TMPLEDGERNEW SET EXCHANGE = @@EXCHANGE, SEGMENT= @@SEGMENT, ENTITY='MARGIN LEDGER', ORDERSEG = 2 WHERE SEGMENT IS NULL          
  END          
  ELSE          
  BEGIN          
   UPDATE #TMPLEDGERNEW SET EXCHANGE = @@EXCHANGE, SEGMENT= @@SEGMENT, ENTITY = 'MARGIN ' + @@EXCHANGE + ' - ' + @@SEGMENT, ORDERSEG = CONVERT(TINYINT, @@SEGORD) + 4 WHERE SEGMENT IS NULL          
  END          
        
 SET @@SEGORD = @@SEGORD + 1         
 END        
          
 FETCH NEXT FROM @@MAINREC INTO @@ACCOUNTDB, @@EXCHANGE, @@SEGMENT          
END        
        
IF @ORDERFLG = 'N'          
 BEGIN          
          
  INSERT INTO #OPBAL          
  SELECT CLTCODE, SEGMENT, ORDERSEG, OPBAL = MAX(OPBAL) FROM #TMPLEDGERNEW          
  GROUP BY CLTCODE, EXCHANGE, SEGMENT, ORDERSEG          
          
  INSERT INTO #FINOPBAL          
  SELECT CLTCODE, ORDERSEG, OPBAL = SUM(OPBAL) FROM #OPBAL          
  GROUP BY CLTCODE, ORDERSEG          
          
  UPDATE          
  #TMPLEDGERNEW          
  SET OPBAL = 0          
          
  UPDATE          
  #TMPLEDGERNEW          
  SET OPBAL = T.OPBAL          
  FROM #TMPLEDGERNEW L WITH(NOLOCK),          
  #FINOPBAL T WITH(NOLOCK)          
  WHERE L.CLTCODE = T.CLTCODE  AND L.ORDERSEG = T.ORDERSEG          
 END        
      
/* DELETE T FROM #TMPLEDGERNEW T WHERE EXISTS(SELECT CLTCODE FROM #TMPLEDGERNEW T1       
 WHERE T.CLTCODE = T1.CLTCODE AND VTYP <> 18 GROUP BY CLTCODE HAVING ABS(SUM(OPBAL) + SUM(CASE WHEN DRAMT <> 0 THEN DRAMT ELSE -CRAMT END)) < 3120)*/      
   
IF @STRORDER = 'ACCODE'          
 BEGIN          
  IF @SELECTBY = 'VDT'          
  BEGIN          
     SELECT * FROM #TMPLEDGERNEW  WHERE (CRAMT <> 0 OR DRAMT <> 0 OR OPBAL <> 0)   ORDER BY CLTCODE,ORDERSEG,VOUDT          
   END          
  ELSE          
  BEGIN     
    SELECT * FROM #TMPLEDGERNEW  WHERE (CRAMT <> 0 OR DRAMT <> 0 OR OPBAL <> 0)   ORDER BY CLTCODE,ORDERSEG, EFFDT        
   END          
 END   
ELSE  
 BEGIN  
  IF @SELECTBY = 'VDT'          
  BEGIN          
     SELECT * FROM #TMPLEDGERNEW  WHERE (CRAMT <> 0 OR DRAMT <> 0 OR OPBAL <> 0)   ORDER BY ACNAME,ORDERSEG,VOUDT          
   END          
  ELSE          
  BEGIN     
    SELECT * FROM #TMPLEDGERNEW  WHERE (CRAMT <> 0 OR DRAMT <> 0 OR OPBAL <> 0)   ORDER BY ACNAME,ORDERSEG, EFFDT        
   END          
 END

GO
