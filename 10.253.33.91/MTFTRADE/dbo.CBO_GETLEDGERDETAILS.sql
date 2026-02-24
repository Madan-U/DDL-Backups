-- Object: PROCEDURE dbo.CBO_GETLEDGERDETAILS
-- Server: 10.253.33.91 | DB: MTFTRADE
--------------------------------------------------




CREATE PROCEDURE [dbo].[CBO_GETLEDGERDETAILS](
                @STATUSID   VARCHAR(25),
                @STATUSNAME VARCHAR(25),
                @EXCHANGE   VARCHAR(25),
                @SEGMENT    VARCHAR(25),
                @FROMCODE   VARCHAR(25),
                @TOCODE     VARCHAR(25),
                @FROMDATE   VARCHAR(11),
                @TODATE     VARCHAR(11),
                @SEARCHCODE VARCHAR(25), 
                @SEARCHWHAT VARCHAR(20) = 'CLIENT')

AS

/*
  EXECUTE CBO_GETLEDGERDETAILS 1,258
*/
  SET NOCOUNT ON
  
  SET TRANSACTION ISOLATION  LEVEL  READ  UNCOMMITTED
  
  IF @SEARCHCODE = '' SELECT SEARCHCODE = '%'

  DECLARE  @FLDAUTO     INT,
           @FLDAUTOFROM INT,
           @OPENDATE    VARCHAR(11)
                        
  SELECT @FLDAUTO = ISNULL(MAX(FLDAUTO),0)
  FROM   PARAMETER WITH (NOLOCK)
  WHERE  CONVERT(DATETIME,CONVERT(CHAR,@TODATE)) BETWEEN SDTCUR AND LDTCUR
     
  SELECT @FLDAUTOFROM = ISNULL(MAX(FLDAUTO),0)
  FROM   PARAMETER WITH (NOLOCK)
  WHERE  CONVERT(DATETIME,CONVERT(CHAR,@FROMDATE)) BETWEEN SDTCUR AND LDTCUR
                                                                      
CREATE TABLE [dbo].[#MINILEDGER_DETAIL] (
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
	[MLD_OPBALFLAG] [int] NOT NULL,
	[MLD_ENTEREDBY] [VARCHAR](100) NOT NULL 
) ON [PRIMARY]

CREATE TABLE [dbo].[#MINILEDGER_MASTER] (
	[MLM_ACCAT] [char] (10) NOT NULL ,
	[MLM_CLTCODE] [varchar] (10) NOT NULL ,
	[MLM_BRANCH_CD] [varchar] (10) NOT NULL ,
	[MLM_ACNAME] [varchar] (100) NOT NULL 
) ON [PRIMARY]

CREATE TABLE [dbo].[#MARGINLEDGER_TMP] (
	[VTYP] [smallint] NOT NULL ,
	[BOOKTYPE] [char] (2) NOT NULL ,
	[LNO] [decimal](5, 0) NOT NULL ,
	[VNO] [varchar] (12) NOT NULL ,
	[EDT] [datetime] NOT NULL ,
	[VDT] [datetime] NOT NULL ,
	[VAMT] [money] NOT NULL ,
	[NARRATION] [varchar] (300) NULL ,
	[CLTCODE] [varchar] (10) NOT NULL ,
	[DRCR] [varchar] (1) NOT NULL,
	[ENTEREDBY] [VARCHAR](100)
) ON [PRIMARY]
  
CREATE TABLE [dbo].[#OPPBALANCE_TMP] (
	[CLTCODE] [varchar] (10) NOT NULL ,
	[OPPBAL] [money] NOT NULL ,
	[DRCR] [varchar] (1) NOT NULL 
) ON [PRIMARY]
  
CREATE TABLE [dbo].[#VMAST_TMP] (
	[VTYPE] [smallint] NOT NULL 
) ON [PRIMARY]

CREATE TABLE [dbo].[#CLIENT] (
  [ENT_CODE]    [VARCHAR](25) NOT NULL,
  [ENT_NAME]    [VARCHAR](100) NOT NULL,
  [PARTY_CODE]  [VARCHAR](10) NOT NULL,
  [PARENTCODE]  [VARCHAR](10) NOT NULL,
  [AREA]        [VARCHAR](20) NOT NULL,
  [REGION]      [VARCHAR](20) NOT NULL,
  [BRANCH_CD]   [VARCHAR](10) NOT NULL,
  [SUB_BROKER]  [VARCHAR](10) NOT NULL,
  [TRADER]      [VARCHAR](20) NOT NULL,
  [FAMILY]      [VARCHAR](10) NOT NULL,
  [CL_TYPE]     [VARCHAR](10) NOT NULL,
  [CL_STATUS]   [VARCHAR](10) NOT NULL,
  [RELMGR]      [VARCHAR](10) NOT NULL,
  [SBU]         [VARCHAR](10) NOT NULL,
  [GROUPCODE]   [VARCHAR](10) NOT NULL 
) ON [PRIMARY]

  INSERT INTO #CLIENT 
  SELECT * 
  FROM   .dbo.CBO_FN_GETCODELIST(
                           @STATUSID,
                           @STATUSNAME,
                           @FROMCODE,
                           @TOCODE,
                           @SEARCHWHAT)
  WHERE ENT_CODE LIKE @SEARCHCODE
  
  IF @FLDAUTOFROM <> 0
    BEGIN
      SELECT @OPENDATE = LEFT(SDTCUR,11)
      FROM   PARAMETER WITH (NOLOCK)
      WHERE  FLDAUTO = @FLDAUTOFROM
    END
  ELSE
    BEGIN
    PRINT @FLDAUTO
      SELECT @OPENDATE = LEFT(SDTCUR,11)
      FROM   PARAMETER WITH (NOLOCK)
      WHERE  FLDAUTO = @FLDAUTO
                       
      SELECT @FROMDATE = @OPENDATE
    END
    
  ---------------------------------------------
  --SETTLEMENT LEDGER OPENING BALANCE
  ---------------------------------------------
  INSERT INTO #OPPBALANCE_TMP
  SELECT   CLTCODE = C.ENT_CODE,
           OPBAL = ISNULL(SUM(VAMT),0),
           DRCR
  FROM     LEDGER L WITH (NOLOCK), 
           #CLIENT C
  WHERE    EDT LIKE @OPENDATE + '%' 
           AND VTYP = 18
           AND L.CLTCODE = C.PARTY_CODE 
  GROUP BY C.ENT_CODE,DRCR
           
  INSERT INTO #OPPBALANCE_TMP
  SELECT   CLTCODE = C.ENT_CODE,
           OPBAL = ISNULL(SUM(VAMT),0),
           DRCR
  FROM     LEDGER L WITH (NOLOCK), 
           #CLIENT C
  WHERE    EDT >= @OPENDATE
           AND EDT < @FROMDATE
           AND VTYP <> 18
           AND L.CLTCODE = C.PARTY_CODE 
  GROUP BY C.ENT_CODE,DRCR
           
  INSERT INTO #OPPBALANCE_TMP
  SELECT   CLTCODE = C.ENT_CODE,
           OPPBAL = ISNULL(SUM(VAMT),0),
           DRCR = (CASE 
                     WHEN DRCR = 'C' THEN 'D'
                     ELSE 'C'
                   END)
  FROM     LEDGER L WITH (NOLOCK), 
           #CLIENT C
  WHERE    EDT >= @OPENDATE
           AND VDT < @OPENDATE
           AND L.CLTCODE = C.PARTY_CODE 
  GROUP BY C.ENT_CODE,DRCR
           
  INSERT INTO #MINILEDGER_DETAIL
  SELECT VTYP = 18,
         BOOKTYPE = '01',
         LNO = 1,
         VNO = 'OPENING BAL',
         EDT = @FROMDATE,
         VDT = @FROMDATE,
         SHORTDESC = 'OPENEN',
         DRAMT = (CASE 
                    WHEN OPPBAL >= 0 THEN OPPBAL
                    ELSE 0
                  END),
         CRAMT = (CASE 
                    WHEN OPPBAL >= 0 THEN 0
                    ELSE ABS(OPPBAL)
                  END),
         DDNO = '',
         NARRATION = 'OPENING BALANCE AS ON ' + LTRIM(RTRIM(@FROMDATE)),
         CLTCODE,
         OPBAL = 0,
         CROSAC = '',
         EDIFF = 0,
         LEDGER = 1,
         OPBALFLAG = 0,
		 MLD_ENTEREDBY = ''
  FROM   (SELECT   CLTCODE,
                   OPPBAL = SUM(CASE 
                                  WHEN DRCR = 'D' THEN OPPBAL
                                  ELSE -OPPBAL
                                END)
          FROM     #OPPBALANCE_TMP
          GROUP BY CLTCODE) L
         
  ---------------------------------------------
  --MARGIN LEDGER OPENING BALANCE
  ---------------------------------------------
  
  TRUNCATE TABLE #OPPBALANCE_TMP
  
  INSERT INTO #OPPBALANCE_TMP
  SELECT   CLTCODE,
           OPBAL = ISNULL(SUM(VAMT),0),
           DRCR
  FROM     #MARGINLEDGER_TMP WITH (NOLOCK)
  WHERE    EDT LIKE @OPENDATE + '%' 
           AND VTYP = 18
  GROUP BY CLTCODE,DRCR
           
  INSERT INTO #OPPBALANCE_TMP
  SELECT   CLTCODE,
           OPBAL = ISNULL(SUM(VAMT),0),
           DRCR
  FROM     #MARGINLEDGER_TMP WITH (NOLOCK)
  WHERE    EDT >= @OPENDATE
           AND EDT < @FROMDATE
           AND VTYP <> 18
  GROUP BY CLTCODE,DRCR
           
  INSERT INTO #OPPBALANCE_TMP
  SELECT   CLTCODE,
           OPPBAL = ISNULL(SUM(VAMT),0),
           DRCR = (CASE 
                     WHEN DRCR = 'C' THEN 'D'
                     ELSE 'C'
                   END)
  FROM     #MARGINLEDGER_TMP WITH (NOLOCK)
  WHERE    EDT >= @OPENDATE
           AND VDT < @OPENDATE
  GROUP BY CLTCODE,DRCR
           
  INSERT INTO #MINILEDGER_DETAIL
  SELECT VTYP = 18,
         BOOKTYPE = '01',
         LNO = 1,
         VNO = 'OPENING BAL',
         EDT = @FROMDATE,
         VDT = @FROMDATE,
         SHORTDESC = 'OPENEN',
         DRAMT = (CASE 
                    WHEN OPPBAL >= 0 THEN OPPBAL
                    ELSE 0
                  END),
         CRAMT = (CASE 
                    WHEN OPPBAL >= 0 THEN 0
                    ELSE ABS(OPPBAL)
                  END),
         DDNO = '',
         NARRATION = 'OPENING BALANCE AS ON ' + LTRIM(RTRIM(@FROMDATE)),
         CLTCODE,
         OPBAL = 0,
         CROSAC = '',
         EDIFF = 0,
         LEDGER = 2,
         OPBALFLAG = 0,
		 MLD_ENTEREDBY = ''
  FROM   (SELECT   CLTCODE,
                   OPPBAL = SUM(CASE 
                                  WHEN DRCR = 'D' THEN OPPBAL
                                  ELSE -OPPBAL
                                END)
          FROM     #OPPBALANCE_TMP
          GROUP BY CLTCODE) L
         
  ---------------------------------------------
  --SETTLEMENT LEDGER ENTRIES
  ---------------------------------------------
  INSERT INTO #MINILEDGER_DETAIL
  SELECT L.VTYP,
         L.BOOKTYPE,
         LNO=ACTNODAYS,
         L.VNO,
         L.EDT,
         L.VDT,
         V.SHORTDESC,
         DRAMT = (CASE 
                    WHEN DRCR = 'D' THEN VAMT
                    ELSE 0
                  END),
         CRAMT = (CASE 
                    WHEN DRCR = 'D' THEN 0
                    ELSE VAMT
                  END),
         DDNO = '',
         NARRATION = L.NARRATION,
         CLTCODE = C.ENT_CODE,
         OPBAL = 0,
         CROSAC = '',
         EDIFF = 0,
         LEDGER = 1,
         OPBALFLAG = 1,
		 MLD_ENTEREDBY = ENTEREDBY
  FROM   LEDGER L WITH (NOLOCK),
         VMAST V WITH (NOLOCK),
         #CLIENT C 
  WHERE  L.VTYP = V.VTYPE
         AND L.EDT BETWEEN @FROMDATE AND @TODATE + ' 23:59:59'
         AND L.VDT <= @TODATE + ' 23:59:59'
         AND V.VTYPE <> 18 
         AND L.CLTCODE = C.PARTY_CODE
  ORDER BY 6, 12, 1, 2, 4, 3
  --ORDER BY L.VDT, L.CLTCODE, L.VTYP, L.BOOKTYPE, L.VNO, L.DRCR, L.LNO 
                        
  INSERT INTO #MINILEDGER_DETAIL
  SELECT L.VTYP,
         L.BOOKTYPE,
         LNO=ACTNODAYS,
         L.VNO,
         L.EDT,
         L.VDT,
         V.SHORTDESC,
         DRAMT = (CASE 
                    WHEN DRCR = 'D' THEN VAMT
                    ELSE 0
                  END),
         CRAMT = (CASE 
                    WHEN DRCR = 'D' THEN 0
                    ELSE VAMT
                  END),
         DDNO = '',
         NARRATION = L.NARRATION,
         CLTCODE = C.ENT_CODE,
         OPBAL = 0,
         CROSAC = '',
         EDIFF = 0,
         LEDGER = 1,
         OPBALFLAG = 2,
		 MLD_ENTEREDBY = ENTEREDBY
  FROM   LEDGER L WITH (NOLOCK),
         VMAST V WITH (NOLOCK), 
         #CLIENT C 
  WHERE  L.VTYP = V.VTYPE
         AND L.EDT > @TODATE + ' 23:59:59' 
         AND L.VDT <= @TODATE + ' 23:59:59'
         AND V.VTYPE <> 18 
         AND L.CLTCODE = C.PARTY_CODE 
  ORDER BY 6, 12, 1, 2, 4, 3
  --ORDER BY VDT, CLTCODE, VTYP, BOOKTYPE, LNO, VNO, DRCR 
                        
  ---------------------------------------------
  --MARGIN LEDGER ENTRIES
  ---------------------------------------------
  INSERT INTO #MINILEDGER_DETAIL
  SELECT L.VTYP,
         L.BOOKTYPE,
         L.LNO,
         L.VNO,
         L.EDT,
         L.VDT,
         V.SHORTDESC,
         DRAMT = (CASE 
                    WHEN DRCR = 'D' THEN VAMT
                    ELSE 0
                  END),
         CRAMT = (CASE 
                    WHEN DRCR = 'D' THEN 0
                    ELSE VAMT
                  END),
         DDNO = '',
         L.NARRATION,
         CLTCODE,
         OPBAL = 0,
         CROSAC = '',
         EDIFF = 0,
         LEDGER = 2,
         OPBALFLAG = 1,
		 MLD_ENTEREDBY = ENTEREDBY
  FROM   #MARGINLEDGER_TMP L WITH (NOLOCK),
         VMAST V WITH (NOLOCK)
  WHERE  L.VTYP = V.VTYPE
         AND L.EDT BETWEEN @FROMDATE AND @TODATE + ' 23:59:59'
         AND L.VDT <= @TODATE + ' 23:59:59'
         AND V.VTYPE <> 18
                        
  INSERT INTO #MINILEDGER_DETAIL
  SELECT L.VTYP,
         L.BOOKTYPE,
         L.LNO,
         L.VNO,
         L.EDT,
         L.VDT,
         V.SHORTDESC,
         DRAMT = (CASE 
                    WHEN DRCR = 'D' THEN VAMT
                    ELSE 0
                  END),
         CRAMT = (CASE 
                    WHEN DRCR = 'D' THEN 0
                    ELSE VAMT
                  END),
         DDNO = '',
         L.NARRATION,
         CLTCODE,
         OPBAL = 0,
         CROSAC = '',
         EDIFF = 0,
         LEDGER = 2,
         OPBALFLAG = 2,
		 MLD_ENTEREDBY = ENTEREDBY
  FROM   #MARGINLEDGER_TMP L WITH (NOLOCK),
         VMAST V WITH (NOLOCK)
  WHERE  L.VTYP = V.VTYPE
         AND L.EDT > @TODATE + ' 23:59:59'
         AND L.VDT <= @TODATE + ' 23:59:59'
         AND V.VTYPE <> 18
                        
  ---------------------------------------------------------------
  --UPDATE CROSS ACCOUNT AND CHEQUE NUMBER
  ---------------------------------------------------------------
  INSERT INTO #VMAST_TMP
  SELECT VTYPE
  FROM   VMAST
  WHERE  VTYPE IN ('1','2','3','4',
                   '5','16','17','19',
                   '20','22','23')

  UPDATE A
  SET    A.MLD_CROSAC = B.CLTCODE
  FROM   #MINILEDGER_DETAIL A,
         LEDGER B
  WHERE  B.CLTCODE <> A.MLD_CLTCODE
         AND A.MLD_BOOKTYPE = B.BOOKTYPE
         AND A.MLD_VNO = B.VNO
         AND A.MLD_VTYP = B.VTYP
         AND EXISTS (SELECT VTYPE
                     FROM   #VMAST_TMP V
                     WHERE  V.VTYPE = A.MLD_VTYP)
         AND (B.VAMT = A.MLD_CRAMT + A.MLD_DRAMT)
             
  UPDATE A
  SET    A.MLD_DDNO = ISNULL(B.DDNO,'')
  FROM   #MINILEDGER_DETAIL A,
         LEDGER1 B WITH (NOLOCK)
  WHERE  A.MLD_BOOKTYPE = B.BOOKTYPE
         AND A.MLD_VNO = B.VNO
         AND A.MLD_VTYP = B.VTYP
         AND EXISTS (SELECT VTYPE
                     FROM   #VMAST_TMP V
                     WHERE  V.VTYPE = A.MLD_VTYP)
                    
  ---------------------------------------------------------------
  --POPULATE MINI LEDGER MASTER RECORDS 
  ---------------------------------------------------------------
  INSERT INTO #MINILEDGER_MASTER
  SELECT   ACCAT,
           CLTCODE,
           BRANCHCODE,
           ACNAME
  FROM     ACMAST A WITH (NOLOCK)
  WHERE    EXISTS (SELECT DISTINCT CLTCODE
                   FROM   #MINILEDGER_DETAIL V
                  WHERE  A.CLTCODE = V.MLD_CLTCODE)
  ORDER BY 1,
           2

  INSERT INTO #MINILEDGER_DETAIL
  SELECT VTYP = 18,
         BOOKTYPE = '01',
         LNO = 1,
         VNO = 'OPENING BAL',
         EDT = @FROMDATE,
         VDT = @FROMDATE,
         SHORTDESC = 'OPENEN',
         DRAMT = 0,
         CRAMT = 0,
         DDNO = '',
         NARRATION = 'OPENING BALANCE AS ON ' + LTRIM(RTRIM(CONVERT(CHAR,@FROMDATE))),
         MLM_CLTCODE,
         OPBAL = 0,
         CROSAC = '',
         EDIFF = 0,
         LEDGER = 1,
         OPBALFLAG = 0,
		 MLD_ENTEREDBY = ''
  FROM   #MINILEDGER_MASTER 
  WHERE  NOT EXISTS (SELECT DISTINCT MLD_CLTCODE
                     FROM   #MINILEDGER_DETAIL 
                     WHERE  MLM_CLTCODE = MLD_CLTCODE
                            AND MLD_LEDGER = 1
                            AND MLD_OPBALFLAG = 0) 
 
 INSERT INTO #MINILEDGER_DETAIL
  SELECT VTYP = 18,
         BOOKTYPE = '01',
         LNO = 1,
         VNO = 'OPENING BAL',
         EDT = @FROMDATE,
         VDT = @FROMDATE,
         SHORTDESC = 'OPENEN',
         DRAMT = 0,
         CRAMT = 0,
         DDNO = '',
         NARRATION = 'OPENING BALANCE AS ON ' + LTRIM(RTRIM(CONVERT(CHAR,@FROMDATE))),
         MLM_CLTCODE,
         OPBAL = 0,
         CROSAC = '',
         EDIFF = 0,
         LEDGER = 2,
         OPBALFLAG = 0,
		 MLD_ENTEREDBY = ''
  FROM   #MINILEDGER_MASTER 
  WHERE  NOT EXISTS (SELECT DISTINCT MLD_CLTCODE
                     FROM   #MINILEDGER_DETAIL 
                     WHERE  MLM_CLTCODE = MLD_CLTCODE
                            AND MLD_LEDGER = 2
                            AND MLD_OPBALFLAG = 0) 

  SELECT D.*, 
         @EXCHANGE, 
         @SEGMENT, 
         C.ENT_NAME 
  FROM   #MINILEDGER_DETAIL D, 
         (SELECT DISTINCT ENT_CODE, ENT_NAME FROM #CLIENT) C 
  WHERE  C.ENT_CODE = D.MLD_CLTCODE
  ORDER BY 12, 16, 17, 6, 5, 8 DESC, 9

GO
