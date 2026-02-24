-- Object: PROCEDURE dbo.CBO_SHOWLEDGERDETAILS
-- Server: 10.253.33.91 | DB: MTFTRADE
--------------------------------------------------




    
    
CREATE PROCEDURE [dbo].[CBO_SHOWLEDGERDETAILS](      
                @STATUSID   VARCHAR(25),      
                @STATUSNAME VARCHAR(25),      
                @EXCHANGE   VARCHAR(25),      
                @SEGMENT    VARCHAR(25),      
                @SEGMENTDB  VARCHAR(25),      
                @FROMCODE   VARCHAR(25),      
                @TOCODE     VARCHAR(25),      
                @DATEFROM   VARCHAR(11),      
                @DATETO     VARCHAR(11),      
                @SEARCHCODE VARCHAR(25),      
                @SEARCHWHAT VARCHAR(20) = 'CLIENT',    
    @RPT_TYPE VARCHAR(20) = 'SUMMARY')      
      
AS      
      
/*==============================================================================================================        
        EXEC CBO_SHOWLEDGERDETAILS @NOOFDAYS 10      
==============================================================================================================*/      
      
  SET NOCOUNT ON      
      
  CREATE TABLE [DBO].[#SEGMENT] (      
   [EXCHANGE]  [VARCHAR] (25) NOT NULL ,      
   [SEGMENT]   [VARCHAR] (25) NOT NULL ,      
   [SEGMENTDB] [VARCHAR] (25) NOT NULL ,      
  ) ON [PRIMARY]      
      
  IF @SEGMENTDB <> 'ALL'       
       INSERT INTO #SEGMENT       
       SELECT @EXCHANGE,       
              @SEGMENT,       
              @SEGMENTDB      
      
  IF @SEGMENTDB = 'ALL'       
     AND @SEGMENT = 'EQUITIES'       
     AND @EXCHANGE = 'ALL'       
       INSERT INTO #SEGMENT      
       SELECT EXCHANGE,       
              SEGMENT,       
              ACCOUNTDB       
       FROM   MULTICOMPANY       
       WHERE  EXCHANGE IN ('NSE','BSE')       
      
  IF @SEGMENTDB = 'ALL'       
     AND @SEGMENT IN ('CAPITAL','FUTURES')        
     AND @EXCHANGE = 'ALL'       
       INSERT INTO #SEGMENT      
       SELECT EXCHANGE,       
              SEGMENT,       
              ACCOUNTDB       
       FROM   MULTICOMPANY       
       WHERE  EXCHANGE IN ('NSE','BSE')      
              AND SEGMENT = @SEGMENT       
       
  IF @SEGMENTDB = 'ALL'       
     AND @SEGMENT = 'EQUITIES'       
     AND @EXCHANGE IN ('NSE','BSE')       
       INSERT INTO #SEGMENT      
       SELECT EXCHANGE,       
              SEGMENT,       
              ACCOUNTDB       
       FROM   MULTICOMPANY       
       WHERE  EXCHANGE = @EXCHANGE      
      
CREATE TABLE [dbo].[#MINILEDGER_DETAIL] (      
 [MLD_SNO] [int] IDENTITY (1, 1) NOT NULL ,      
 [MLD_VTYP] [smallint] NOT NULL ,      
 [MLD_BOOKTYPE] [char] (2) NOT NULL ,      
 [MLD_LNO] [decimal](5, 0) NOT NULL ,      
 [MLD_VNO] [varchar] (12) NOT NULL ,      
 [MLD_EDT] [datetime] NOT NULL ,      
 [MLD_VDT] [datetime] NOT NULL ,      
 [MLD_SHORTDESC] [char] (35) NOT NULL ,      
 [MLD_DRAMT] [money] NOT NULL ,      
 [MLD_CRAMT] [money] NOT NULL ,      
 [MLD_DDNO] [varchar] (20) NULL ,      
 [MLD_NARRATION] [varchar] (300) NULL ,      
 [MLD_CLTCODE] [varchar] (10) NOT NULL ,      
 [MLD_OPBAL] [money] NOT NULL ,      
 [MLD_CROSAC] [varchar] (10) NULL ,      
 [MLD_EDIFF] [int] NULL ,      
 [MLD_LEDGER] [int] NULL ,      
 [MLD_OPBALFLAG] [int] NOT NULL ,       
 [ENTEREDBY]  [varchar] (100) NULL,    
 [EXCHANGE] [varchar] (25) NULL ,      
 [SEGMENT] [varchar] (25) NULL ,       
 [ENT_NAME] [varchar] (100) NULL    
) ON [PRIMARY]      
      
  DECLARE  @@ACCCUR       AS CURSOR,      
           @@ACCOUNTDB   VARCHAR(25),      
           @@EXCHANGE    VARCHAR(25),      
           @@SEGMENT     VARCHAR(25),      
           @@SQL         VARCHAR(5000)      
        
  SET @@ACCCUR = CURSOR FOR SELECT  SEGMENTDB,       
                                    EXCHANGE,       
                                    SEGMENT        
                            FROM    #SEGMENT        
      
  OPEN @@ACCCUR      
        
  FETCH NEXT FROM @@ACCCUR      
  INTO @@ACCOUNTDB,      
       @@EXCHANGE,       
       @@SEGMENT              
  WHILE @@FETCH_STATUS = 0      
    BEGIN      
      SELECT @@SQL = ' '      
     SELECT @@SQL = @@SQL + 'INSERT INTO #MINILEDGER_DETAIL '      
      SELECT @@SQL = @@SQL + 'EXECUTE ' + @@ACCOUNTDB + '.DBO.CBO_GETLEDGERDETAILS '       
      SELECT @@SQL = @@SQL + '@STATUSID   = ''' + @STATUSID + ''', '      
      SELECT @@SQL = @@SQL + '@STATUSNAME = ''' + @STATUSNAME + ''', '      
      SELECT @@SQL = @@SQL + '@EXCHANGE   = ''' + @@EXCHANGE + ''', '      
      SELECT @@SQL = @@SQL + '@SEGMENT    = ''' + @@SEGMENT + ''', '      
      SELECT @@SQL = @@SQL + '@FROMCODE   = ''' + @FROMCODE + ''', '      
      SELECT @@SQL = @@SQL + '@TOCODE     = ''' + @TOCODE + ''', '      
      SELECT @@SQL = @@SQL + '@FROMDATE   = ''' + @DATEFROM + ''', '      
      SELECT @@SQL = @@SQL + '@TODATE     = ''' + @DATETO + ''', '      
      SELECT @@SQL = @@SQL + '@SEARCHCODE = ''' + @SEARCHCODE + ''', '      
      SELECT @@SQL = @@SQL + '@SEARCHWHAT = ''' + @SEARCHWHAT + ''' '      
        PRINT @@SQL    
      EXEC( @@SQL)      
     
      
      FETCH NEXT FROM @@ACCCUR      
      INTO @@ACCOUNTDB,      
           @@EXCHANGE,       
           @@SEGMENT              
    END      
        
  CLOSE @@ACCCUR      
  DEALLOCATE @@ACCCUR                

SELECT  MLD_SNO,MLD_EDT,MLD_VDT,MLD_SHORTDESC,MLD_DRAMT,MLD_CRAMT,    
 MLD_DDNO,MLD_NARRATION,MLD_CLTCODE,MLD_CROSAC,EXCHANGE,SEGMENT,MLD_OPBALFLAG,MLD_LNO       
 INTO #LEDGER    
 FROM            
 (      
  SELECT MLD_SNO, MLD_EDT, MLD_VDT, MLD_SHORTDESC, MLD_DRAMT, MLD_CRAMT, MLD_DDNO,     
   MLD_NARRATION,    
  MLD_CLTCODE,     
  MLD_CROSAC,    
  --MLD_CROSAC='',     
  EXCHANGE, SEGMENT, MLD_OPBALFLAG,MLD_LNO    
  FROM (    
  SELECT MLD_SNO = MIN(MLD_SNO),      
         MLD_EDT=LEFT(MLD_EDT,11),      
         MLD_VDT=LEFT(MLD_VDT,11),      
         MLD_SHORTDESC,      
         MLD_DRAMT = CASE       
                       WHEN SUM(MLD_DRAMT-MLD_CRAMT) > 0 THEN SUM(MLD_DRAMT-MLD_CRAMT)       
                       ELSE 0       
                     END,      
         MLD_CRAMT = CASE       
                       WHEN SUM(MLD_CRAMT-MLD_DRAMT) > 0 THEN SUM(MLD_CRAMT-MLD_DRAMT)       
                       ELSE 0       
                     END,      
         MLD_DDNO,      
         MLD_NARRATION=MLD_NARRATION,      
         MLD_CLTCODE,      
         MLD_CROSAC,      
         EXCHANGE=@EXCHANGE,      
         SEGMENT=@SEGMENT,      
         MLD_OPBALFLAG,MLD_LNO      
  FROM   #MINILEDGER_DETAIL       
  WHERE  MLD_OPBALFLAG = 0       
  GROUP BY MLD_EDT,MLD_VDT,MLD_SHORTDESC,MLD_DDNO,MLD_NARRATION,      
           MLD_CLTCODE,MLD_CROSAC,MLD_OPBALFLAG,MLD_LNO      
  UNION ALL      
  SELECT MLD_SNO = MIN(MLD_SNO),      
         MLD_EDT=LEFT(MLD_EDT,11),      
         MLD_VDT=LEFT(MLD_VDT,11),      
         MLD_SHORTDESC,      
         MLD_DRAMT = CASE       
                       WHEN SUM(MLD_DRAMT-MLD_CRAMT) > 0 THEN SUM(MLD_DRAMT-MLD_CRAMT)       
                       ELSE 0       
                     END,      
         MLD_CRAMT = CASE       
                       WHEN SUM(MLD_CRAMT-MLD_DRAMT) > 0 THEN SUM(MLD_CRAMT-MLD_DRAMT)       
                       ELSE 0       
                     END,      
         MLD_DDNO,      
         MLD_NARRATION,    
         MLD_CLTCODE,      
   MLD_CROSAC,    
         --MLD_CROSAC='',      
         EXCHANGE,      
         SEGMENT,      
         MLD_OPBALFLAG,MLD_LNO      
  FROM (    
  SELECT MLD_SNO = MIN(MLD_SNO),      
         MLD_EDT=LEFT(MLD_EDT,11),      
         MLD_VDT=LEFT(MLD_VDT,11),      
         MLD_SHORTDESC=(CASE WHEN @RPT_TYPE = 'DETAIL' THEN MLD_SHORTDESC   
        /*WHEN MLD_SHORTDESC = 'BIIL' AND SUM(MLD_DRAMT-MLD_CRAMT) > 0 THEN 'PAYBNK'    
          WHEN MLD_SHORTDESC = 'BIIL' AND SUM(MLD_DRAMT-MLD_CRAMT) < 0 THEN 'PAYBNK'    
          ELSE 'PAYBNK' END)*/    
          WHEN ENTEREDBY = 'ANIMESH' OR ENTEREDBY = 'SYSTEM' THEN 'LOAN' ELSE MLD_SHORTDESC END),      
         MLD_DRAMT = CASE       
                       WHEN SUM(MLD_DRAMT-MLD_CRAMT) > 0 THEN SUM(MLD_DRAMT-MLD_CRAMT)       
                       ELSE 0       
                     END,      
         MLD_CRAMT = CASE       
                       WHEN SUM(MLD_CRAMT-MLD_DRAMT) > 0 THEN SUM(MLD_CRAMT-MLD_DRAMT)       
                       ELSE 0       
                     END,      
         MLD_DDNO,      
         MLD_NARRATION=(CASE WHEN @RPT_TYPE = 'DETAIL' THEN MLD_NARRATION    
        WHEN ENTEREDBY = 'ANIMESH' OR ENTEREDBY = 'SYSTEM' THEN 'LOAN' ELSE MLD_NARRATION END),    
         MLD_CLTCODE,     
   MLD_CROSAC,     
         --MLD_CROSAC='',      
         EXCHANGE,      
         SEGMENT,      
         MLD_OPBALFLAG,  
   VNO = (CASE WHEN @RPT_TYPE = 'DETAIL' THEN MLD_VNO    
        WHEN ENTEREDBY = 'ANIMESH' OR ENTEREDBY = 'SYSTEM' THEN '' ELSE MLD_VNO END),MLD_LNO      
  FROM   #MINILEDGER_DETAIL       
  WHERE  MLD_OPBALFLAG <> 0       
  GROUP BY MLD_EDT,MLD_VDT,MLD_SHORTDESC,MLD_DDNO,MLD_BOOKTYPE,ENTEREDBY,(CASE WHEN @RPT_TYPE = 'DETAIL' THEN MLD_VNO    
        WHEN ENTEREDBY = 'ANIMESH' OR ENTEREDBY = 'SYSTEM' THEN '' ELSE MLD_VNO END),    
 (CASE WHEN @RPT_TYPE = 'DETAIL' THEN MLD_NARRATION    
        WHEN ENTEREDBY = 'ANIMESH' OR ENTEREDBY = 'SYSTEM' THEN 'LOAN' ELSE MLD_NARRATION END),    
           MLD_CLTCODE,MLD_CROSAC,EXCHANGE,SEGMENT,MLD_OPBALFLAG,MLD_LNO) B     
 GROUP BY MLD_EDT,MLD_VDT,MLD_SHORTDESC,MLD_NARRATION,MLD_CLTCODE,MLD_DDNO,MLD_CROSAC,EXCHANGE,SEGMENT,MLD_OPBALFLAG,VNO,MLD_LNO    
 HAVING SUM(MLD_CRAMT-MLD_DRAMT) <> 0    
  ) A     
) P    
     
SELECT MLD_SNO,MLD_EDT,MLD_VDT,MLD_SHORTDESC,MLD_DRAMT,MLD_CRAMT,    
MLD_DDNO=(CASE WHEN MLD_DDNO='100214' THEN '' ELSE MLD_DDNO END),    
MLD_NARRATION=UPPER(MLD_NARRATION),MLD_CLTCODE,MLD_CROSAC,EXCHANGE,SEGMENT,
MLD_OPBALFLAG,LONG_NAME,L_ADDRESS1, L_ADDRESS2, L_ADDRESS3, 
L_CITY, L_STATE, L_ZIP,L_NATION,RES_PHONE1,RES_PHONE2,OFF_PHONE1,    
OFF_PHONE2,EMAIL    
FROM   #LEDGER B,MSAJAG.DBO.CLIENT1 C1    
WHERE C1.CL_CODE = B.MLD_CLTCODE    
AND EXISTS (SELECT PARTY_CODE FROM TBLCLIENTMARGIN C
			WHERE MLD_CLTCODE = PARTY_CODE AND TO_DATE >=  @DATEFROM )
ORDER BY 1

GO
