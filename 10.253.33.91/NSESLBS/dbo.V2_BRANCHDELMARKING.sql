-- Object: PROCEDURE dbo.V2_BRANCHDELMARKING
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE PROCEDURE V2_BRANCHDELMARKING 
(
      @STATUSID VARCHAR(15), 
      @STATUSNAME VARCHAR(25), 
      @DP VARCHAR(20), 
      @SETT_NO VARCHAR(7), 
      @SETT_TYPE VARCHAR(2), 
      @PARTY_CODE VARCHAR(10), 
      @SCRIP_CD VARCHAR(10), 
      @BRANCH VARCHAR(10)
)

AS

/*=========================================================================================================
      EXECUTE V2_BRANCHDELMARKING 
            @STATUSID = 'BROKER', 
            @STATUSNAME = 'BROKER', 
            @DP = 'BEN', 
            @SETT_NO = '%', 
            @SETT_TYPE = '%', 
            @PARTY_CODE = '%', 
            @SCRIP_CD = '%', 
            @BRANCH = '%' 

      EXECUTE V2_BRANCHDELMARKING 
            @STATUSID = 'BRANCH', 
            @STATUSNAME = 'AH00', 
            @DP = 'BEN', 
            @SETT_NO = '%', 
            @SETT_TYPE = '%', 
            @PARTY_CODE = '%', 
            @SCRIP_CD = '%', 
            @BRANCH = '%' 
=========================================================================================================*/

SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  

      SELECT PARTY_CODE = CL_CODE, 
            LONG_NAME, 
            FAMILY 
      INTO #CLIENTMASTER 
      FROM CLIENT1 WITH(NOLOCK) WHERE 1=2 

      SELECT 
            DpType,
            DpId,
            DpCltNo,
            Description,
            AccountType,
            LicenceNo 
      INTO #DELIVERYDP 
      FROM DELIVERYDP WITH(NOLOCK)
      WHERE 1 = 2 

      CREATE TABLE [#DELBRANCHMARK] 
      (
      	[SETT_NO] [VARCHAR] (7)  NULL ,
      	[SETT_TYPE] [VARCHAR] (2)  NULL ,
      	[PARTY_CODE] [VARCHAR] (10)  NULL ,
      	[SCRIP_CD] [VARCHAR] (10)  NULL ,
      	[SERIES] [VARCHAR] (3)  NULL ,
      	[CERTNO] [VARCHAR] (16)  NULL ,
      	[DPTYPE] [VARCHAR] (10)  NULL ,
      	[DPID] [VARCHAR] (16)  NULL ,
      	[CLTDPID] [VARCHAR] (16)  NULL ,
      	[PAYOUTQTY] [NUMERIC](7, 0) NULL ,
      	[DELMARKQTY] [NUMERIC](7, 0) NULL ,
      	[PAYOUTGIVEN] [NUMERIC](7, 0) NULL ,
      	[APROVED] [NUMERIC](1, 0) NULL ,
      	[MARKEDDATE] [DATETIME] NULL ,
      	[MARKEDBY] [VARCHAR] (25)  NULL ,
      	[APROVEDDATE] [DATETIME] NULL ,
      	[APROVEDBY] [VARCHAR] (25)  NULL, 
      	[LONG_NAME] [VARCHAR] (100)  NULL, 
      	[FAMILY] [VARCHAR] (10)  NULL 
      ) ON [PRIMARY]

      CREATE 
        INDEX [PARTY_CODE] ON [dbo].[#CLIENTMASTER] ([PARTY_CODE])
      ON [PRIMARY]

      CREATE CLUSTERED 
        INDEX [MAINIDX] ON [DBO].[#DELBRANCHMARK] ([APROVED], [PARTY_CODE], [SCRIP_CD], [SERIES], [CERTNO], [DPID], [CLTDPID])
      ON [PRIMARY]

      IF @DP = 'POOL' 
      BEGIN
            INSERT 
            INTO #DELIVERYDP 
            SELECT 
                  DpType, 
                  DpId, 
                  DpCltNo, 
                  Description, 
                  AccountType, 
                  LicenceNo 
            FROM DELIVERYDP WITH(NOLOCK) 
            WHERE DESCRIPTION LIKE '%POOL%' 
      END 
      ELSE
      BEGIN 
            INSERT 
            INTO #DELIVERYDP 
            SELECT 
                  DpType, 
                  DpId, 
                  DpCltNo, 
                  Description, 
                  AccountType, 
                  LicenceNo 
            FROM DELIVERYDP WITH(NOLOCK) 
            WHERE DESCRIPTION NOT LIKE '%POOL%' 	
      END

      
      IF UPPER(@STATUSID) = 'BROKER' 
      BEGIN  
            INSERT INTO #CLIENTMASTER 
            SELECT C2.PARTY_CODE, 
                  C1.LONG_NAME, 
                  C1.FAMILY 
            FROM CLIENT1 C1 WITH(NOLOCK), 
                  CLIENT2 C2 WITH(NOLOCK) 
            WHERE C2.CL_CODE = C1.CL_CODE 
                  AND C2.PARTY_CODE LIKE @PARTY_CODE 
                  AND BRANCH_CD LIKE @BRANCH 

            INSERT INTO #DELBRANCHMARK 
            SELECT 
                  B.*, C1.LONG_NAME, C1.FAMILY  
            FROM DELBRANCHMARK B WITH(NOLOCK), 
                  #CLIENTMASTER C1 WITH(NOLOCK) 
            WHERE B.PARTY_CODE = C1.PARTY_CODE 
                  AND APROVED = 0 

            SELECT 
                  D.SETT_NO,
                  D.SETT_TYPE,
                  D.PARTY_CODE,
                  D.LONG_NAME,
                  D.FAMILY,
                  D.SCRIP_CD,
                  D.SERIES,
                  ISIN=D.CERTNO,
                  D.DPTYPE, 
                  D.DPID,
                  D.CLTDPID,
                  PAYOUTQTY=PAYOUTQTY,
                  DELMARKQTY, 
                  FREEQTY=SUM(
                        CASE 
                              WHEN TRTYPE = 904 
                              THEN DT.QTY 
                              ELSE 0 
                        END
                        ), 
                  PLDQTY=SUM(
                        CASE 
                              WHEN TRTYPE = 909 
                              THEN DT.QTY 
                              ELSE 0 
                        END
                        ),
                  APROVED 
            FROM #DELBRANCHMARK D WITH(NOLOCK), 
                  DELTRANS DT WITH(NOLOCK), 
                  #DELIVERYDP DP WITH(NOLOCK) 
            WHERE D.SETT_NO LIKE @SETT_NO 
                  AND D.SETT_TYPE LIKE @SETT_TYPE 
                  AND APROVED = 0 
                  AND D.PARTY_CODE = DT.PARTY_CODE 
                  AND D.SCRIP_CD LIKE @SCRIP_CD 
                  AND D.SETT_NO = DT.SETT_NO 
                  AND D.SETT_TYPE = DT.SETT_TYPE 
                  AND D.SCRIP_CD = DT.SCRIP_CD 
                  AND DT.DELIVERED = '0' 
                  AND TRTYPE IN (909,904) 
                  AND FILLER2 = 1 
                  AND DRCR = 'D' 
                  AND DT.BDPID = DP.DPID 
                  AND DT.BCLTDPID = DP.DPCLTNO 
            GROUP BY D.SETT_NO,
                  D.SETT_TYPE,
                  D.PARTY_CODE,
                  D.LONG_NAME,
                  D.FAMILY,
                  D.SCRIP_CD,
                  D.SERIES,
                  D.CERTNO,
                  D.DPTYPE, 
                  D.DPID,
                  D.CLTDPID,
                  PAYOUTQTY,
                  DELMARKQTY,
                  APROVED 
            ORDER BY D.FAMILY,
                  D.PARTY_CODE,
                  D.SCRIP_CD,
                  D.SERIES,
                  D.SETT_NO,
                  D.SETT_TYPE 
      END 
      ELSE
      BEGIN 
            IF @DP = 'POOL' 
            BEGIN
                  INSERT INTO #CLIENTMASTER 
                  SELECT C2.PARTY_CODE, 
                        C1.LONG_NAME, 
                        C1.FAMILY 
                  FROM CLIENT1 C1 WITH(NOLOCK), 
                        CLIENT2 C2 WITH(NOLOCK) 
                  WHERE C2.CL_CODE = C1.CL_CODE 
                        AND C2.PARTY_CODE LIKE @PARTY_CODE 
                        AND BRANCH_CD = @STATUSNAME 
                        AND C2.PARTY_CODE NOT IN 
                              ( 
                                    SELECT 
                                          PARTY_CODE 
                                    FROM DELPARTYFLAG WITH(NOLOCK) 
                                    WHERE DEBITFLAG = 2 
                              ) 
            END 
            ELSE
            BEGIN 
                  INSERT INTO #CLIENTMASTER 
                  SELECT C2.PARTY_CODE, 
                        C1.LONG_NAME, 
                        C1.FAMILY 
                  FROM CLIENT1 C1 WITH(NOLOCK), 
                        CLIENT2 C2 WITH(NOLOCK) 
                  WHERE C2.CL_CODE = C1.CL_CODE 
                        AND C2.PARTY_CODE LIKE @PARTY_CODE 
                        AND BRANCH_CD = @STATUSNAME 
            END

            INSERT INTO #DELBRANCHMARK 
            SELECT 
                  B.*, C1.LONG_NAME, C1.FAMILY   
            FROM DELBRANCHMARK B WITH(NOLOCK), 
                  #CLIENTMASTER C1 WITH(NOLOCK) 
            WHERE B.PARTY_CODE = C1.PARTY_CODE 
                  AND APROVED = 0 

            SELECT 
                  D.SETT_NO,
                  D.SETT_TYPE,
                  D.PARTY_CODE,
                  C1.LONG_NAME,
                  C1.FAMILY,
                  D.SCRIP_CD,
                  D.SERIES,
                  ISIN=D.CERTNO,
                  D.DPTYPE, 
                  D.DPID,
                  D.CLTDPID,
                  PAYOUTQTY=SUM(QTY), 
                  DELMARKQTY=ISNULL(DELMARKQTY,0),
                  APROVED=ISNULL(APROVED,0) 
            FROM #CLIENTMASTER C1 WITH(NOLOCK), 
                  #DELIVERYDP DP WITH(NOLOCK), 
                  DELTRANS D WITH(NOLOCK) 
            LEFT OUTER JOIN #DELBRANCHMARK B WITH(NOLOCK) 
                  ON 
                  (
                        D.SETT_NO = B.SETT_NO 
                        AND D.SETT_TYPE = B.SETT_TYPE 
                        AND D.PARTY_CODE = B.PARTY_CODE 
                        AND D.SCRIP_CD = B.SCRIP_CD 
                        AND D.SERIES = B.SERIES 
                        AND D.CERTNO = B.CERTNO 
                        AND D.DPID = B.DPID 
                        AND D.DPID <> '' 
                        AND D.CLTDPID = B.CLTDPID 
                  ) 
            WHERE D.SETT_NO LIKE @SETT_NO 
                  AND D.SETT_TYPE LIKE @SETT_TYPE 
                  AND C1.PARTY_CODE = D.PARTY_CODE 
                  AND DRCR = 'D' 
                  AND FILLER2 = 1 
                  AND TRTYPE IN (904,909) 
                  AND DELIVERED = '0' 
                  AND D.BDPID = DP.DPID 
                  AND D.BCLTDPID = DP.DPCLTNO 
                  AND D.SCRIP_CD LIKE @SCRIP_CD 
                  AND D.CERTNO NOT LIKE 'AUCTION' 
            GROUP BY D.SETT_NO, 
                  D.SETT_TYPE,
                  D.PARTY_CODE,
                  C1.LONG_NAME,
                  C1.FAMILY, 
                  D.SCRIP_CD,
                  D.SERIES,
                  D.CERTNO,
                  D.DPTYPE,
                  D.DPID,
                  D.CLTDPID,
                  DELMARKQTY,
                  APROVED 
            HAVING SUM(QTY) > 0 
            ORDER BY C1.FAMILY,
                  D.PARTY_CODE,
                  D.SCRIP_CD,
                  D.SERIES,
                  D.SETT_NO,
                  D.SETT_TYPE 
      END

GO
