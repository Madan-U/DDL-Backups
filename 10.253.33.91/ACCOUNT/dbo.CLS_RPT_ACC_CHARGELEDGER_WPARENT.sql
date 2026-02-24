-- Object: PROCEDURE dbo.CLS_RPT_ACC_CHARGELEDGER_WPARENT
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------




--EXEC RPT_ACC_PARTYLEDGER_ALL 'AUG  1 2007','AUG  8 2007','0000','ZZZZ','ACCODE','VDT','BROKER','BROKER','', 'N','N'  
  
--EXEC CLS_RPT_ACC_CHARGELEDGER_WPARENT 'DEC  1 2018','DEC 31 2018','0','ZZZ','ACCODE','VDT','BROKER','BROKER','', 'BROKER', ''        
        
CREATE PROCEDURE [dbo].[CLS_RPT_ACC_CHARGELEDGER_WPARENT]
(          
 @FDATE VARCHAR(11),            /* AS MMM DD YYYY */                
 @TDATE VARCHAR(11),            /* AS MMM DD YYYY */                
 @FCODE VARCHAR(10),                
 @TCODE VARCHAR(10),                
 @STRORDER VARCHAR(8),                
 @SELECTBY VARCHAR(3),                
 @STATUSID VARCHAR(15),                
 @STATUSNAME VARCHAR(15),                
 @STRBRANCH VARCHAR(10),
 @ENTITY VARCHAR(20),
 @ENTITY_LIST VARCHAR(MAX),
 @FORPDF VARCHAR(1) = 'N',
 @PARENTCHILD_FLAG CHAR(1) = 'C' --,
--- @DASHBOARD CHAR(1) = 'N'
)          
          
AS         
  
DECLARE                
 @@REPTYPE VARCHAR(1),  
 @@STRORDER VARCHAR(6)  

  
SELECT @@REPTYPE = .dbo.CLS_Piece(@STRORDER, '~', 2)  
SELECT @@STRORDER = .dbo.CLS_Piece(@STRORDER, '~', 1)  
  /*
IF @@REPTYPE = 'P'  
BEGIN  
 EXEC RPT_ACC_PARTYLEDGER_PARENT @FDATE, @TDATE, @FCODE, @TCODE, @@STRORDER, @SELECTBY, @STATUSID, @STATUSNAME, @STRBRANCH  
 RETURN  
END */ 
  
  
                
/*========================================================================          
      EXEC RPT_ACC_PARTYLEDGER_ALL           
            'NOV  1 2005',          
            'DEC 31 2005',          
            'A',          
            'ZZZ',          
            'ACCODE',          
            'VDT',          
            'BROKER',          
            'UNDEFINED',          
            ''          
========================================================================*/
CREATE TABLE #LEDGERCLIENTS
(
	PARTY_CODE VARCHAR(10),          
	LONG_NAME VARCHAR(100),          
    BANK_NAME VARCHAR(50),           
    L_ADDRESS1 VARCHAR(100),           
	L_ADDRESS2  VARCHAR(100),           
	L_ADDRESS3 VARCHAR(100),           
    L_CITY VARCHAR(50),           
    L_ZIP VARCHAR(20),           
    RES_PHONE1 VARCHAR(20),           
    BRANCH_CD VARCHAR(20),           
    FAMILY VARCHAR(10),           
    SUB_BROKER VARCHAR(30),           
    TRADER VARCHAR(50),           
    CL_TYPE VARCHAR(20),           
    CLTDPID VARCHAR(30),
    EMAIL VARCHAR(500),
    MOBILE_PAGER VARCHAR(50),
	PAN VARCHAR(20)
)



CREATE TABLE #CL_LIST
(
	CLTCODE VARCHAR(10) NOT NULL
)

ALTER TABLE #CL_LIST
 ADD PRIMARY KEY (CLTCODE)

DECLARE
	@@SQL VARCHAR(MAX),
	@ENTITY_FIELD VARCHAR(20)
	

 SELECT @ENTITY_FIELD =    
  CASE WHEN @ENTITY = 'BRANCH' THEN  'BRANCH_CD' ELSE    
  CASE WHEN @ENTITY = 'SUB_BROKER' THEN 'SUB_BROKER' ELSE     
  CASE WHEN @ENTITY = 'TRADER' THEN 'TRADER' ELSE    
  CASE WHEN @ENTITY = 'AREA' THEN 'AREA' ELSE    
  CASE WHEN @ENTITY = 'REGION' THEN 'REGION' ELSE   
  CASE WHEN @STATUSID = 'CLIENT' THEN 'CL_CODE' ELSE 	 
  CASE WHEN @ENTITY = 'FAMILY' THEN 'FAMILY' ELSE 'BROKER'    
 END END END END END END  END  
 
 
 DECLARE
	@SHAREDB VARCHAR(25) 
	
SELECT @SHAREDB = SHAREDB FROM OWNER	

SET @@SQL = "INSERT INTO #CL_LIST "
SET @@SQL = @@SQL + "SELECT distinct C1.CL_CODE FROM " + @SHAREDB + ".DBO.CLIENT1 C1, " + @SHAREDB + ".DBO.CLIENT2_VW C2 "
SET @@SQL = @@SQL + "WHERE C1.CL_CODE = C2.PARTY_CODE "
IF @PARENTCHILD_FLAG = 'C'
	SET @@SQL = @@SQL + "AND PARTY_CODE >= '" + @FCODE + "' AND PARTY_CODE <= '" + @TCODE + "'"
ELSE
	SET @@SQL = @@SQL + "AND ParentCode >= '" + @FCODE + "' AND ParentCode <= '" + @TCODE + "'"
IF @ENTITY_FIELD <> 'BROKER' AND  @ENTITY_LIST <> '' AND @ENTITY_LIST <> 'ALL|'
BEGIN 
 SET @@SQL = @@SQL + "AND " + @ENTITY_FIELD + " IN('" + REPLACE(@ENTITY_LIST, '|', ''',''') + "')" 
 --SET @@SQL = @@SQL + " AND " + @ENTITY_FIELD + " <= '" + @ENTITY_TO + "'"    
END  
PRINT @@SQL
EXEC (@@SQL)


/*GETTING CLIENT LIST*/                
INSERT INTO #LEDGERCLIENTS
      SELECT           
            C2.PARTY_CODE,          
			C1.LONG_NAME,          
            BANK_NAME ='',-- ISNULL(C4.BANKID, ''),           
            L_ADDRESS1,           
            L_ADDRESS2,           
            L_ADDRESS3,           
            L_CITY,           
            L_ZIP,           
            RES_PHONE1,           
            C1.BRANCH_CD,           
            FAMILY,           
            C1.SUB_BROKER,           
            TRADER,           
            CL_TYPE,           
            CLTDPID = '',--ISNULL(CLTDPID, '') ,
            EMAIL,
            MOBILE_PAGER,
			PAN_GIR_NO
			      
      FROM MSAJAG.DBO.CLIENT1 C1 WITH(NOLOCK),           
            MSAJAG.DBO.CLIENT2 C2 WITH(NOLOCK)           
      /*LEFT OUTER JOIN           
            MSAJAG.DBO.CLIENT4 C4 WITH(NOLOCK)           
            ON           
            (          
                  C2.PARTY_CODE = C4.PARTY_CODE           
                  AND DEPOSITORY NOT IN ('NSDL', 'CDSL')           
				 -- AND DEFDP = 1          
--                  AND DEFDP = 0      
            )       */    
      WHERE C1.CL_CODE = C2.CL_CODE 
			AND C1.AREA LIKE (          
            CASE           
                  WHEN @STATUSID = 'AREA'           
                  THEN @STATUSNAME           
                  ELSE '%'           
            END          
            ) 
			AND C1.REGION LIKE (          
            CASE           
                  WHEN @STATUSID = 'REGION'           
                  THEN @STATUSNAME           
                  ELSE '%'           
            END          
            )            
            AND C1.BRANCH_CD LIKE (          
            CASE           
                  WHEN @STATUSID = 'BRANCH'           
                  THEN @STATUSNAME           
                  ELSE '%'           
            END          
            )           
            AND SUB_BROKER LIKE (          
            CASE           
                  WHEN @STATUSID = 'SUB_BROKER'           
                  THEN @STATUSNAME           
                  ELSE '%'           
            END          
            )           
     AND SUB_BROKER LIKE (          
            CASE           
                  WHEN @STATUSID = 'SUBBROKER'           
                  THEN @STATUSNAME           
                  ELSE '%'           
            END          
            )           
            AND TRADER LIKE (          
            CASE           
                  WHEN @STATUSID = 'TRADER'           
                  THEN @STATUSNAME           
                  ELSE '%'           
            END          
            )           
            AND C1.FAMILY LIKE (          
            CASE           
                  WHEN @STATUSID = 'FAMILY'           
                  THEN @STATUSNAME           
                  ELSE '%'           
            END          
            )           
            AND C2.PARTY_CODE LIKE (          
            CASE           
                  WHEN @STATUSID = 'CLIENT'           
                  THEN @STATUSNAME           
                  ELSE '%'           
            END          
         )           
        AND C1.BRANCH_CD LIKE @STRBRANCH +'%'           
        AND EXISTS(SELECT CLTCODE FROM #CL_LIST C WHERE C2.PARTY_CODE = C.CLTCODE) 
		           

DECLARE           
 @@OPENDATE   AS VARCHAR(11)                
                
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                
                
                
/*GETTING LAST OPENING DATE 
      IF UPPER(@SELECTBY) = 'VDT'                
      BEGIN                */
            SELECT           
                  @@OPENDATE =           
                  (           
                        SELECT           
                              CONVERT(VARCHAR(11), SDTCUR, 109)
                        FROM PARAMETER WITH(NOLOCK)           
                        WHERE @FDATE BETWEEN SDTCUR AND LDTCUR
                  )           
      /*END                
      ELSE                
      BEGIN                
            SELECT           
                  @@OPENDATE =           
                  (           
                        SELECT           
                              LEFT(CONVERT(VARCHAR, ISNULL(MAX(EDT), 0), 109), 11)           
                        FROM LEDGER WITH(NOLOCK)           
                        WHERE VTYP = 18  
							  AND EXISTS(SELECT PARTY_CODE FROM #LEDGERCLIENTS L WHERE PARTY_CODE = CLTCODE)         
                              AND EDT < = @FDATE           
                  )           
      END                */
                      
                
      /*GENERATING BLANK STRUCTURE FOR FILTERED LEDGER */                
            SELECT           
                  VTYP,VNO,EDT,LNO,ACNAME,DRCR,VAMT,VDT,VNO1,REFNO,BALAMT,NODAYS,CDT,CLTCODE,BOOKTYPE,ENTEREDBY,PDT,CHECKEDBY,ACTNODAYS,L.NARRATION,           
                  SHORTDESC = SPACE(35)           
            INTO #LEDGERDATA           
            FROM LEDGER L WITH(NOLOCK)           
            WHERE 1 = 2  
			
			DECLARE
			@STARTOFMONTH DATETIME

			SELECT @STARTOFMONTH = DATEADD(MONTH, DATEDIFF(MONTH, 0, @TDATE), 0)         
			
      /*GETTING FIILTERED LEDGER*/                
      IF UPPER(@SELECTBY) = 'VDT'                
      BEGIN                
            INSERT           
            INTO #LEDGERDATA           
            SELECT           
                  VTYP,VNO,EDT,LNO,ACNAME = LONGNAME,DRCR,VAMT ,VDT,VNO1 ,REFNO = 0,BALAMT = 0,NODAYS = 0,CDT ,L.CLTCODE,l.BOOKTYPE,ENTEREDBY ,PDT ,CHECKEDBY ,ACTNODAYS = 0,L.NARRATION,           
                  SHORTDESC = SPACE(50)           
            FROM LEDGER L WITH(NOLOCK),
				 ACMAST A
            WHERE VDT > = @STARTOFMONTH + ' 00:00:00'           
                  AND VDT < = @TDATE +' 23:59:59' 
				  AND A.CLTCODE = L.CLTCODE
				  AND L.BOOKTYPE = '11'     
                  AND EXISTS(SELECT PARTY_CODE FROM #LEDGERCLIENTS L1 WHERE PARTY_CODE = L.CLTCODE)         
				  

      END                 
      ELSE                
      BEGIN                
            INSERT           
            INTO #LEDGERDATA           
            SELECT           
                  VTYP = 8,VNO = '',EDT,LNO = 0,ACNAME = LONGNAME,DRCR = 'D',VAMT ,VDT,VNO1 = '',REFNO = 0,BALAMT = 0,NODAYS = 0,CDT ,L.CLTCODE,l.BOOKTYPE,ENTEREDBY ,PDT ,CHECKEDBY ,ACTNODAYS = 0,L.NARRATION,           
                  SHORTDESC = SPACE(50)           
            FROM LEDGER L WITH(NOLOCK),
				 ACMAST A
            WHERE EDT > = @STARTOFMONTH + ' 00:00:00'           
                  AND EDT < = @TDATE +' 23:59:59' 
				  AND A.CLTCODE = L.CLTCODE    
				  AND L.BOOKTYPE = '11'      
                  AND EXISTS(SELECT PARTY_CODE FROM #LEDGERCLIENTS L1 WHERE PARTY_CODE = L.CLTCODE)            
      END

	      
          
          
      CREATE TABLE [#TMPLEDGER] (          
       [BOOKTYPE] [CHAR] (2)  NULL ,          
       [VOUDT] [DATETIME] NULL ,          
       [EFFDT] [DATETIME] NULL ,          
       [SHORTDESC] [VARCHAR] (35)  NULL ,          
       [DRAMT] [MONEY] NULL ,          
       [CRAMT] [MONEY] NULL ,          
       [VNO] [VARCHAR] (12)  NULL ,          
       [DDNO] [VARCHAR] (32)  NULL ,          
       [NARRATION] [VARCHAR] (234)  NULL ,          
       [CLTCODE] [VARCHAR] (10)  NOT NULL ,          
       [VTYP] [SMALLINT] NULL ,          
       [VDT] [VARCHAR] (30)  NULL ,          
       [EDT] [VARCHAR] (30)  NULL ,          
       [ACNAME] [VARCHAR] (100)  NULL ,          
       [OPBAL] [MONEY] NULL ,          
       [L_ADDRESS1] [VARCHAR] (100)  NOT NULL ,          
       [L_ADDRESS2] [VARCHAR] (100)  NULL ,          
       [L_ADDRESS3] [VARCHAR] (100)  NULL ,          
       [L_CITY] [VARCHAR] (40)  NULL ,          
       [L_ZIP] [VARCHAR] (10)  NULL ,          
       [RES_PHONE1] [VARCHAR] (15)  NULL ,          
       [BRANCH_CD] [VARCHAR] (10)  NOT NULL ,          
       [CROSAC] [VARCHAR] (10)  NULL ,          
       [EDIFF] [INT] NULL ,          
       [FAMILY] [VARCHAR] (10)  NOT NULL ,          
       [SUB_BROKER] [VARCHAR] (10)  NOT NULL ,          
       [TRADER] [VARCHAR] (20)  NOT NULL ,          
       [CL_TYPE] [VARCHAR] (3)  NOT NULL ,          
       [BANK_NAME] [VARCHAR] (50)  NOT NULL ,          
       [CLTDPID] [VARCHAR] (20)  NOT NULL ,          
       [LNO] [INT] NULL,        
       [PDT] [DATETIME] NULL,
       [EMAIL] VARCHAR(500),
       [MOBILE_PAGER] VARCHAR(80)
       ,PAN VARCHAR(20)

      ) ON [PRIMARY]          
   
           
/*GETTING LDDGER ENTRIES*/                
      INSERT           
            INTO #TMPLEDGER           
      SELECT           
            L.BOOKTYPE,           
			VOUDT = L.VDT,           
            EFFDT = L.EDT,           
            L.SHORTDESC,           
            DRAMT = (          
            CASE           
                  WHEN UPPER(L.DRCR) = 'D'           
                  THEN L.VAMT           
                  ELSE 0           
            END          
            ),           
            CRAMT = (          
            CASE           
                  WHEN UPPER(L.DRCR) = 'C'           
                  THEN L.VAMT           
                  ELSE 0           
            END          
            ),           
            L.VNO1  VNO,           
            DDNO = SPACE(15),           
            L.NARRATION,           
            C.PARTY_CODE CLTCODE,           
            VTYP = ISNULL(L.VTYP, 18),           
            CONVERT(VARCHAR, L.VDT, 103) VDT,           
            CONVERT(VARCHAR, L.EDT, 103) EDT,           
--            L.ACNAME ,           
            C.LONG_NAME,          
            OPBAL = VAMT,           
            C.L_ADDRESS1,           
            C.L_ADDRESS2,           
            C.L_ADDRESS3,           
            C.L_CITY,           
            C.L_ZIP,           
            C.RES_PHONE1,           
            C.BRANCH_CD,           
            CROSAC='' ,           
            EDIFF = DATEDIFF(D, L.EDT, GETDATE()),           
            C.FAMILY,           
            C.SUB_BROKER,           
            C.TRADER,           
            C.CL_TYPE,           
            C.BANK_NAME,           
            C.CLTDPID,           
            L.LNO,        
			L.PDT,
			EMAIL,
			MOBILE_PAGER
			,C.PAN
      FROM #LEDGERDATA L WITH(NOLOCK)           
      RIGHT OUTER JOIN           
            #LEDGERCLIENTS C WITH(NOLOCK)           
            ON           
            (          
                  L.CLTCODE = C.PARTY_CODE          
            )  


			
          
                
/*UPDATING OPENING BLANACE*/                
      UPDATE           
            #TMPLEDGER           
            SET OPBAL = 0           
          
          
          
/*UPDATING CHEQUE NUMBER*/                
      UPDATE           
            #TMPLEDGER           
            SET DDNO = L1.DDNO           
      FROM LEDGER1 L1 WITH(NOLOCK)           
      WHERE L1.VNO = #TMPLEDGER.VNO           
            AND L1.VTYP = #TMPLEDGER.VTYP           
            AND L1.BOOKTYPE = #TMPLEDGER.BOOKTYPE           
            AND L1.LNO = #TMPLEDGER.LNO           
                
          
          

          
/*UPDATING BANK NAME*/                               
      /*UPDATE           
            #TMPLEDGER           
            SET #TMPLEDGER.BANK_NAME = B.BANK_NAME           
      FROM MSAJAG.DBO.POBANK B WITH(NOLOCK)           
      WHERE LTRIM(RTRIM(CAST(B.BANKID AS CHAR))) = LTRIM(RTRIM(#TMPLEDGER.BANK_NAME))           */
      
      IF @FORPDF = 'Y'
		BEGIN
			ALTER TABLE #TMPLEDGER ADD PARTYCOUNT INT
			UPDATE #TMPLEDGER SET PARTYCOUNT = C.PCOUNTER
			FROM (SELECT CLTCODE, PCOUNTER = COUNT(1) FROM #TMPLEDGER GROUP BY CLTCODE) C
			WHERE #TMPLEDGER.CLTCODE = C.CLTCODE
		END
            

		--IF @DASHBOARD = 'Y'
	 -- BEGIN
	 --   INSERT INTO #TEMPDASHBOARD
		--SELECT * FROM #TMPLEDGER

	 -- END
	 -- ELSE
	  BEGIN
      IF @@STRORDER = 'ACCODE'                
      BEGIN                
            IF @SELECTBY = 'VDT'                
            BEGIN                 
                  SELECT           
                        L.*
                  FROM #TMPLEDGER L WITH(NOLOCK),           
                        ACMAST A WITH(NOLOCK)           
                  WHERE L.CLTCODE = A.CLTCODE           
                        AND ACCAT IN ('4', '104')           
					AND (CRAMT <> 0 OR DRAMT <> 0 OR OPBAL <> 0)          
                  ORDER BY L.CLTCODE,        
                        VOUDT, PDT        
            END                
            ELSE                
            BEGIN                
                  SELECT           
                        L.*
                  FROM #TMPLEDGER L WITH(NOLOCK),           
                        ACMAST A WITH(NOLOCK)           
                  WHERE L.CLTCODE = A.CLTCODE           
                        AND ACCAT IN ('4', '104')   
						AND (CRAMT <> 0 OR DRAMT <> 0 OR OPBAL <> 0)                  
                  ORDER BY L.CLTCODE,          
                        EFFDT, PDT        
            END                
      END                
      ELSE                
      BEGIN                
            IF @SELECTBY = 'VDT'                
            BEGIN                 
                  SELECT           
                        L.*           
                  FROM #TMPLEDGER L WITH(NOLOCK),           
                        ACMAST A WITH(NOLOCK)           
                  WHERE L.CLTCODE = A.CLTCODE           
                        AND ACCAT IN ('4', '104') 
						AND (CRAMT <> 0 OR DRAMT <> 0 OR OPBAL <> 0)                
                  ORDER BY L.ACNAME,         
                        VOUDT, PDT           
            END                
            ELSE                
            BEGIN                
                  SELECT           
                        L.*           
                  FROM #TMPLEDGER L WITH(NOLOCK),           
                        ACMAST A WITH(NOLOCK)           
                  WHERE L.CLTCODE = A.CLTCODE           
                        AND ACCAT IN ('4', '104')  
						AND (CRAMT <> 0 OR DRAMT <> 0 OR OPBAL <> 0)                   
                  ORDER BY L.ACNAME,          
                        EFFDT, PDT        
            END                
      END    
END	              
                
/*  ------------------------------   END OF THE PROC  -------------------------------------*/

GO
