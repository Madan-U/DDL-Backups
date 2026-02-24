-- Object: PROCEDURE dbo.COMPUTE_DPC_CHARGES_WRAPPER
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE PROCEDURE [dbo].[COMPUTE_DPC_CHARGES_WRAPPER_08012013]              
(              
 @FROM_DATE VARCHAR(11),              
 @TO_DATE VARCHAR(11),              
 @FROM_PARTY VARCHAR(10),              
 @TO_PARTY VARCHAR(10)              
)              
AS              
/*SELECT * INTO DPC_CHARGES_VERIFIED_CASH FROM DPC_CHARGES        
SELECT * FROM DPC_CHARGES WHERE CLTCODE = 's5643' AND entity = 'nse - FUTURES' ORDER BY DPC_DATE        
DELETE FROM DPC_CHARGES WHERE CLTCODE = 's5643'        
--EXEC COMPUTE_DPC_CHARGES_WRAPPER 'SEP  1 2012', 'SEP 15 2012', 's5643', 's5643'        
s5643        
*/        
DECLARE              
 @ACCOUNTSERVER VARCHAR(20),              
 @ACCOUNTDB VARCHAR(20),              
 @EXCHANGE VARCHAR(10),              
 @SEGMENT VARCHAR(10),              
 @GROUPID VARCHAR(10),              
 @@SQL VARCHAR(1000),              
 @@CUR AS CURSOR              
              
 SET @@CUR = CURSOR FOR              
 SELECT ACCOUNTSERVER, ACCOUNTDB, EXCHANGE, SEGMENT, GROUPID FROM dpc_MASTER_SETTING         
               
 OPEN @@CUR              
 FETCH NEXT FROM @@CUR INTO @ACCOUNTSERVER, @ACCOUNTDB, @EXCHANGE, @SEGMENT, @GROUPID              
 WHILE @@FETCH_STATUS = 0              
 BEGIN              
  TRUNCATE TABLE DPC_CHARGES_FINAL              
  --SET @@SQL = " EXEC " + @ACCOUNTSERVER + "." + @ACCOUNTDB + ".DBO.COMPUTE_DPC_CHARGES '" + @FROM_DATE + "','" + @TO_DATE + "','" + @FROM_PARTY + "','" + @TO_PARTY + "'"              
  SET @@SQL = " INSERT INTO DPC_CHARGES_FINAL "              
  SET @@SQL = @@SQL + " EXEC " + @ACCOUNTSERVER + "." + @ACCOUNTDB + ".DBO.COMPUTE_DPC_CHARGES '" + @FROM_DATE + "','" + @TO_DATE + "','" + @FROM_PARTY + "','" + @TO_PARTY + "'"              
  
  EXEC (@@SQL)     
      
     
        
          
                
  INSERT INTO DPC_CHARGES (DPC_DATE,CLTCODE,LONG_NAME,BRANCH_CD,SUB_BROKER,TRADER,REGION,AREA,CL_TYPE,DPC_BALANCE,LEDGER_BALANCE,CASH_COLLATREAL,NONCASH_COLLATREAL,MARGIN_REQ,DPC_CHARGE,DPC_PERCENTE,AMOUNT_REV,EXCHANGE,SEGMENT,ENTITY,SEG_GROUP,NET_TYPE_BALANCE,NET_TYPE_INT,NET_BALANCE,NET_INT)              
  SELECT               
   *,               
   EXCHANGE = @EXCHANGE,               
   SEGMENT = @SEGMENT,               
   ENTIRY = @EXCHANGE + ' - ' + @SEGMENT,              
   ENTITY_TYPE = @GROUPID,              
   DPC_BALANCE, DPC_CHARGE, DPC_BALANCE, DPC_CHARGE       
         
         
  FROM DPC_CHARGES_FINAL        
        
          
                           
                
  FETCH NEXT FROM @@CUR INTO @ACCOUNTSERVER, @ACCOUNTDB, @EXCHANGE, @SEGMENT, @GROUPID               
 END              
               
 UPDATE D SET NET_TYPE_BALANCE = D1.NET_TYPE_BALANCE, NET_TYPE_INT = CASE WHEN D1.NET_TYPE_INT > 0 THEN D1.NET_TYPE_INT ELSE 0 END              
 FROM DPC_CHARGES D, (              
 SELECT               
  CLTCODE, SEG_GROUP, DPC_DATE,               
  NET_TYPE_BALANCE = SUM(DPC_BALANCE),              
  NET_TYPE_INT = SUM((DPC_BALANCE * DPC_PERCENTE) / 365)               
 FROM DPC_CHARGES              
 GROUP BY CLTCODE, SEG_GROUP, DPC_DATE) D1              
 WHERE D.CLTCODE = D1.CLTCODE AND D.SEG_GROUP = D1.SEG_GROUP       
       
           
               
 UPDATE D SET NET_BALANCE = D1.NET_BALANCE, NET_INT = CASE WHEN D1.NET_INT > 0 THEN D1.NET_INT ELSE 0 END              
 FROM DPC_CHARGES D, (              
 SELECT               
  CLTCODE, SEG_GROUP, DPC_DATE,              
  NET_BALANCE = SUM(DPC_BALANCE),              
  NET_INT = SUM((DPC_BALANCE * DPC_PERCENTE) / 365)               
 FROM DPC_CHARGES              
 GROUP BY CLTCODE, SEG_GROUP, DPC_DATE) D1              
 WHERE D.CLTCODE = D1.CLTCODE AND D.SEG_GROUP = D1.SEG_GROUP

GO
