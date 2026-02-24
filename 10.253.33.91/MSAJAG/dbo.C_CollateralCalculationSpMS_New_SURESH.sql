-- Object: PROCEDURE dbo.C_CollateralCalculationSpMS_New_SURESH
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

                              
                                                                                  
CREATE PROCEDURE [dbo].[C_CollateralCalculationSpMS_New_suresh]                                                                               
(                                                                              
    @EXCHANGE VARCHAR(3),                                                                               
    @SEGMENT VARCHAR(20),                                                                               
    @FROMPARTY VARCHAR(10),                                                                               
    @TOPARTY VARCHAR(10),                                                                               
    @EFFDATE VARCHAR(11),                                                                          
    @calcdate Varchar(11),                                                                               
    @SHAREDB VARCHAR(20),                                                                               
    @SHAREDBSERVER VARCHAR(15),                                                                               
    @STATUS INT OUTPUT                                                                              
)                                                                                      
                                                                              
AS                                                                            
                                                                          
SET @EFFDATE = LEFT(GETDATE(),11)                                                                          
                                                                                
DECLARE @SECHAIRCUTTYPE INT                                                                          
SET @SECHAIRCUTTYPE = 1                                                                          
                                                                          
DECLARE @VARMARGINTYPE INT                                                                          
SET @VARMARGINTYPE = 2                                                                          
                                                                          
DECLARE @APPRSEC INT                                                                          
SET @APPRSEC = 1                                                                          
                                                                          
                                                                          
 /*=======================================================                                                                              
 EXEC C_CollateralCalculationSpMS_New                                                                               
         @EXCHANGE = 'NSX',                                                                               
         @SEGMENT = 'FUTURES',                                                                               
         @FROMPARTY = 'KLNS4727',                                                                               
         @TOPARTY = 'KLNS4727',                                                                               
         @EFFDATE = 'NOV  3 2014' ,                                                                               
         @calcdate = 'NOV  3 2014' ,  
         @SHAREDB = 'NSE',                                                                               
         @SHAREDBSERVER = 'NSE',                                                                               
         @STATUS = 1                                                                              
  
 EXEC C_CollateralCalculationSpMS_New                                                                               
         @EXCHANGE = 'NSX',                    
         @SEGMENT = 'FUTURES',                                                                               
         @FROMPARTY = 'KLNS4725',                                                                               
         @TOPARTY = 'KLNS4725',                                                                               
         @EFFDATE = 'NOV  3 2014' ,         
         @calcdate = 'NOV  3 2014' ,                                                                        
         @SHAREDB = 'NSE',                                                                               
         @SHAREDBSERVER = 'NSE',                                                                               
         @STATUS = 1     
                                                                                        
 =======================================================*/                                                                              
                                                                              
    SET @STATUS = 0                                                      
    /*=======================================================================                               
    POPULATE SECURITIES CLIENT WISE SECURITIES COLLATERAL BALANCES                                                                          
    =======================================================================*/                                      
    CREATE TABLE #C_CALCULATESECVIEW                                            
            (                         
                    PARTY_CODE VARCHAR(10),                            
                    BALQTY BIGINT         ,                               
                    SCRIP_CD   VARCHAR(12)  ,                            
                    SERIES     VARCHAR(3)   ,                                                                          
                  ISIN       VARCHAR(20)  ,                                                                          
       GROUP_CODE VARCHAR(50)  ,                                                                          
                    CL_RATE MONEY           ,                                      
                    SECAMOUNT MONEY         ,                                                                          
                    SECHAIRCUT NUMERIC(18,2),                                                                          
             TOTALSECAMOUNT MONEY    ,                                                                          
            )                                                
                                                                                      
    CREATE TABLE #C_CALCULATESECVIEW_1                                                    
            (                                                                          
                    PARTY_CODE VARCHAR(10),                                                      
                    BALQTY BIGINT         ,                                                                          
                    SCRIP_CD   VARCHAR(12)  ,                                                                          
                    SERIES     VARCHAR(3)   ,                                                                          
     ISIN       VARCHAR(20)  ,                                                                          
                    GROUP_CODE VARCHAR(50)  ,                                                                          
     CL_RATE MONEY           ,                                                                          
                    SECAMOUNT MONEY         ,                                                                          
                  SECHAIRCUT NUMERIC(18,2),                                                                          
                    TOTALSECAMOUNT MONEY    ,                                                   
    )                                                                          
                                                                                                  
    INSERT                                                                          
    INTO    #C_CALCULATESECVIEW_1                                                                     
    SELECT  PARTY_CODE,                                                                          
            BALQTY = SUM(                                                                          
            CASE                                                                          
    WHEN DRCR = 'D'                                                                          
                    THEN -QTY                                                                          
                    ELSE QTY                                                                          
            END)           ,                                                                         
            C.SCRIP_CD     ,                                                      
            SERIES=C.SERIES,                                                                          
            C.ISIN       ,                                                                          
            GROUP_CODE    ='' ,                                                        
            CL_RATE       = 0 ,                                                                          
            SECAMOUNT     = 0 ,                                                                          
            HAIRCUT       =0  ,                                                                          
            TOTALSECAMOUNT=0                                                                          
    FROM    C_SECURITIESMST C                                  
    WHERE   ACTIVE   = 1                                                                          
        AND EXCHANGE = @EXCHANGE                                                          
        AND SEGMENT  = @SEGMENT                                                                          
   AND EFFDATE <= @EFFDATE + ' 23:59:59'                                                                          
        AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                                                          
        AND PARTY_CODE <> 'BROKER'                                                                          
   GROUP BY PARTY_CODE,                                                                        
            C.SCRIP_CD ,                                                                          
         C.SERIES   ,                                                                          
            C.ISIN                                                                          
    HAVING SUM(                               
            CASE                                                                          
                    WHEN DRCR = 'D'                                                                          
     THEN -QTY                                                 
                    ELSE QTY                                                                          
            END) <> 0                                                                          
                                     
                                                                          
 INSERT INTO #C_CalculateSecView_1                                              
 SELECT PARTY_CODE,                                                                                   
 BALQTY = SUM(QTY),                                                                              
 SCRIP_CD, SERIES,                                                                                   
 CERTNO ,                                                   
 GROUP_CODE    ='' ,                                                                          
 CL_RATE       = 0 ,                                                                          
 SECAMOUNT     = 0 ,                                                                          
 HAIRCUT       =0  ,                                                                          
 TOTALSECAMOUNT=0                                                                                  
 FROM ANGELDEMAT.MSAJAG.DBO.deltrans_report D (nolock),   
 ANGELDEMAT.MSAJAG.DBO.DELIVERYDP DP (nolock)                                                                                  
 WHERE BDPTYPE = DP.DPTYPE                                                                                  
 AND BDPID = DP.DPID                                               
 AND BCLTDPID = DP.DPCLTNO                                                                                  
 AND PARTY_CODE <> 'BROKER'                                                                                  
 AND PARTY_CODE <> 'PARTY'                                                                                  
 AND TRTYPE in (904, 905, 909)                                                                                  
 AND DRCR = 'D'                                                                                   
 AND DELIVERED = '0'                                         
 AND FILLER2 = 1                                                                                  
 AND SHARETYPE = 'DEMAT'                                   
 AND EXCHANGE = @EXCHANGE                                                                                  
 AND SEGMENT = @SEGMENT                                                                                  
 AND ACCOUNTTYPE = 'MAR'                                                                     
 and Party_Code Between @FromParty And @ToParty                                                                                   
 GROUP BY PARTY_CODE, SCRIP_CD, SERIES, CERTNO                                           
                                                                              
 INSERT INTO #C_CALCULATESECVIEW_1                   
 SELECT PARTY_CODE,                                                                             
 BALQTY = SUM(QTY),                                                                                 
 SCRIP_CD, SERIES,                                              
 CERTNO,                                                                          
 GROUP_CODE    ='' ,                                                                          
 CL_RATE       = 0 ,                                              
 SECAMOUNT     = 0 ,                                                                          
 HAIRCUT       =0  ,                                                                          
 TOTALSECAMOUNT=0                                      
 FROM ANGELDEMAT.MSAJAG.DBO.deltrans_report D (nolock),   
 ANGELDEMAT.MSAJAG.DBO.DELIVERYDP DP (nolock)                                                                                
 WHERE BDPTYPE = DP.DPTYPE                                                               
 AND BDPID = DP.DPID                                                                                
 AND BCLTDPID = DP.DPCLTNO                                                                                
 AND PARTY_CODE <> 'BROKER'                                                                                
 AND PARTY_CODE <> 'PARTY'                                                                              
 AND TRTYPE = 1000                                                                              
 AND DRCR = 'D'                                                                     
 AND DELIVERED = 'G'                                                 
 AND TRANSDATE > @EffDate                                                                  
 AND FILLER2 = 1                                                                                
 AND SHARETYPE = 'DEMAT'                                                                                
 AND EXCHANGE = @EXCHANGE                                                                                
 AND SEGMENT = @SEGMENT                                                            
 AND ACCOUNTTYPE = 'MAR'                                                                               
 AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                            
 GROUP BY PARTY_CODE, SCRIP_CD, SERIES, CERTNO                                                                               
                                                                                  
 INSERT INTO #C_CalculateSecView_1                                                                                  
 SELECT PARTY_CODE,                                                                                   
 BALQTY = SUM(QTY),                                                                                   
 SCRIP_CD, SERIES,                                                                                   
 CERTNO,                                                    
 GROUP_CODE    ='' ,                                                                       
 CL_RATE       = 0 ,                                                                          
 SECAMOUNT     = 0 ,                        
 HAIRCUT       =0  ,                                                                          
 TOTALSECAMOUNT=0                                                                                    
 FROM ANGELDEMAT.BSEDB.DBO.deltrans_report D (nolock),   
 ANGELDEMAT.BSEDB.DBO.DELIVERYDP DP (nolock)                                                                                  
 WHERE BDPTYPE = DP.DPTYPE                                                                                  
 AND BDPID = DP.DPID                                                                                  
 AND BCLTDPID = DP.DPCLTNO                                                        
 AND PARTY_CODE <> 'BROKER'                                                                                  
 AND PARTY_CODE <> 'PARTY'                                                                                  
 AND TRTYPE in (904, 905, 909)                                       
 AND DRCR = 'D'                                                                                   
 AND DELIVERED = '0'                                                  
 AND FILLER2 = 1                                              
 AND SHARETYPE = 'DEMAT'                                                                                  
 AND EXCHANGE = @EXCHANGE                                                                                  
 AND SEGMENT = @SEGMENT                                     
 AND ACCOUNTTYPE = 'MAR'                                                                                  
 and Party_Code Between @FromParty And @ToParty                                                                                   
 GROUP BY PARTY_CODE, SCRIP_CD, SERIES, CERTNO                                                                 
                                                                              
 INSERT INTO #C_CALCULATESECVIEW_1                                                                                
 SELECT PARTY_CODE,                                                                                 
 BALQTY = SUM(QTY),                                                     
 SCRIP_CD, SERIES,                                                                                 
 CERTNO ,                                                                          
 GROUP_CODE    ='' ,    
 CL_RATE       = 0 ,                                                                          
 SECAMOUNT     = 0 ,                                                                          
 HAIRCUT       =0  ,                                                                          
 TOTALSECAMOUNT=0                                                                                 
 FROM ANGELDEMAT.BSEDB.DBO.deltrans_report D (nolock),   
 ANGELDEMAT.BSEDB.DBO.DELIVERYDP DP (nolock)                                     
 WHERE BDPTYPE = DP.DPTYPE                                                                                
 AND BDPID = DP.DPID                                                                                
 AND BCLTDPID = DP.DPCLTNO                                                                                
 AND PARTY_CODE <> 'BROKER'                                  
 AND PARTY_CODE <> 'PARTY'                                                        
 AND TRTYPE = 1000                                                                              
 AND DRCR = 'D'                                                                                 
 AND DELIVERED = 'G'                                                                                
 AND TRANSDATE > @EFFDATE                                                                              
 AND FILLER2 = 1                                                                               
 AND SHARETYPE = 'DEMAT'                                                                                 
 AND EXCHANGE = @EXCHANGE                                                                                
 AND SEGMENT = @SEGMENT                                    
 AND ACCOUNTTYPE = 'MAR'                                                                              
 AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                                                                
 GROUP BY PARTY_CODE, SCRIP_CD, SERIES, CERTNO                                               
                                                                                  
    UPDATE #C_CalculateSecView_1 set scrip_cd = m.scrip_cd, series = m.series                                                                                  
    from ANGELDEMAT.MSAJAG.DBO.multiisin m   (nolock)                                                                               
    where #C_CalculateSecView_1.isin = m.isin and valid = 1                                                                                   
                                                                            
INSERT INTO #C_CalculateSecView                                                                                
 SELECT PARTY_CODE,                                                            
 BALQTY = SUM(BALQTY),                                                                   
 SCRIP_CD, SERIES, ISIN,                                                                          
 GROUP_CODE    ='' ,                                                                          
 CL_RATE       = 0 ,                           
 SECAMOUNT     = 0 ,                                                                          
 HAIRCUT       =0  ,                                                                          
 TOTALSECAMOUNT=0                                                                                     
  FROM #C_CalculateSecView_1                                         
 GROUP BY PARTY_CODE, SCRIP_CD, SERIES, ISIN                                                                              
                                                                                      
    /*=======================================================================                                                                          
    POPULATE DISTINCT CLIENT CODES FOR WHOM COLLATERAL CALCULATION IS TO BE DONE                                
    =======================================================================*/                                                                          
    CREATE TABLE #C_PARTYCODE                                                                          
            (                             
                    PARTY_CODE    VARCHAR(10)  ,                                                                          
                    CL_TYPE       VARCHAR(10)  ,                                                                          
                    RECORD_TYPE   VARCHAR(10)  ,                                                                          
                    CASH_COMPO    NUMERIC(18,2),                                                                          
    NONCASH_COMPO NUMERIC(18,2),                                                                          
                    CASH_NCASH    CHAR(1)                                                                          
            )                                                                          
    /*======================================                                                                          
    FIXED DEPOSITS                                
    ======================================*/                                                                          
    INSERT                                        
    INTO    #C_PARTYCODE                                                                          
            (                                                                          
                    PARTY_CODE   ,                                 
                    RECORD_TYPE  ,                                                                          
                CASH_COMPO   ,                                                                          
                    NONCASH_COMPO,                                                                          
    CASH_NCASH                                                                          
            )                                                                          
    SELECT DISTINCT PARTY_CODE,                                                                          
            'FD'              ,                                                                          
            0,0,                                                                          
            'C'                                                                          
    FROM    FIXEDDEPOSITMST                                                                          
    WHERE   EXCHANGE = @EXCHANGE                                    
        AND SEGMENT  = @SEGMENT                                                                          
        AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                                                          
    /*======================================                                                                          
    BANK GUARANTEES                                                                          
    ======================================*/                                                                          
    INSERT                                                                          
    INTO    #C_PARTYCODE                                                                 
            (                                                                          
            PARTY_CODE   ,                                                                          
                    RECORD_TYPE  ,                                                                          
                    CASH_COMPO   ,                                                                          
                    NONCASH_COMPO,           
                    CASH_NCASH                                                                          
            )                                                                          
    SELECT DISTINCT PARTY_CODE,                                                                          
           'BG'              ,                                                                          
            0,0,                                                                          
            'C'                       
    FROM    BANKGUARANTEEMST                                                                          
    WHERE   EXCHANGE = @EXCHANGE                                                                          
        AND SEGMENT  = @SEGMENT                                                                          
        AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                                                        
    /*======================================                                                          
    SECURITIES                                                                          
    ======================================*/                                                                          
    INSERT                                                                          
    INTO    #C_PARTYCODE                                                                          
            (                                                   
PARTY_CODE   ,                                                                          
                    RECORD_TYPE  ,                                                   
                    CASH_COMPO   ,                                                                          
                    NONCASH_COMPO,                                                                          
                    CASH_NCASH                                                             
            )                                                                          
    SELECT DISTINCT PARTY_CODE,                                                                          
            'SEC'       ,                                                                          
            0,0,                                                                          
            'N'                                          
    FROM    #C_CALCULATESECVIEW                                                                          
    /*======================================                                                                          
    CASH MARGINS                                                                          
    ======================================*/                                                                          
    INSERT                                                                          
    INTO    #C_PARTYCODE                                                  
            (                                                                          
                    PARTY_CODE   ,                                                                          
RECORD_TYPE  ,                                                                          
                    CASH_COMPO   ,                                                                          
  NONCASH_COMPO,                                                                          
            CASH_NCASH                                      
      )                                                                          
    SELECT DISTINCT PARTY_CODE,                                                                          
            'MARGIN'          ,                                                                          
            0,0,                                                                          
            ''                          
    FROM    C_MARGINLEDGER                                                                          
    WHERE   EXCHANGE = @EXCHANGE                                
        AND SEGMENT  = @SEGMENT                                                                          
        AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                                                          
    /*======================================                                                                          
    UPDATE FOR CLIENT TYPE                                                                          
    ======================================*/                                                                          
    UPDATE #C_PARTYCODE                                                                          
    SET     CL_TYPE = C.CL_TYPE                                                                          
    FROM    CLIENTMASTER C                                                                          
    WHERE   #C_PARTYCODE.PARTY_CODE = C.PARTY_CODE                                                    
    /*==============================================================                                                                          
    UPDATE FOR CASH COMPOSITION - SETTING AT PARTY LEVEL                                                                          
    =================================================================*/                                                                          
    UPDATE #C_PARTYCODE                                                                          
    SET     CASH_COMPO = CASH                                                               
    FROM    CASHCOMPOSITION                                                                          
    WHERE   CASHCOMPOSITION.PARTY_CODE = #C_PARTYCODE.PARTY_CODE                                                                          
        AND EXCHANGE                   = @EXCHANGE                                                                          
        AND SEGMENT                    = @SEGMENT                                                                          
        AND CLIENT_TYPE  = ''                                                                          
 AND ACTIVE                     = 1                                 
     AND EFFDATE                    =                                                                          
 (SELECT MAX(EFFDATE)                                                                          
            FROM    CASHCOMPOSITION                                                        
            WHERE   EFFDATE                    <= @EFFDATE + ' 23:59'                                                                          
                AND CASHCOMPOSITION.PARTY_CODE  = #C_PARTYCODE.PARTY_CODE                                                                          
                AND CASHCOMPOSITION.CLIENT_TYPE = ''                                                                          
                AND EXCHANGE                    = @EXCHANGE                                                                          
                AND SEGMENT                     = @SEGMENT                                                  
                AND ACTIVE                      = 1                                                                          
      )                                                                          
    /*===================================================================                              
    UPDATE FOR CASH COMPOSITION - SETTING AT CLIENT TYPE LEVEL                                                                          
    ====================================================================*/                        
    UPDATE #C_PARTYCODE                                                                          
    SET     CASH_COMPO = CASH                                                                          
    FROM    CASHCOMPOSITION                                                                          
   WHERE   CASHCOMPOSITION.PARTY_CODE = ''                                                                          
        AND EXCHANGE  = @EXCHANGE                                   
        AND SEGMENT            = @SEGMENT                                                                          
        AND CLIENT_TYPE                = #C_PARTYCODE.CL_TYPE                                                                          
        AND ACTIVE                     = 1                                                                          
        AND EFFDATE           =                                                                          
            (SELECT MAX(EFFDATE)                                                                          
            FROM    CASHCOMPOSITION                                                                          
            WHERE   EFFDATE         <= @EFFDATE + ' 23:59'                                                
                AND CASHCOMPOSITION.PARTY_CODE = ''                                                                          
                AND CLIENT_TYPE                = #C_PARTYCODE.CL_TYPE                                                                          
                AND EXCHANGE                  = @EXCHANGE                                                                          
                AND SEGMENT  = @SEGMENT                                                  
                AND ACTIVE                     = 1                                                                          
            )                                                                          
        AND CASH_COMPO = 0                                                 
    /*===================================================================                                                                          
    UPDATE FOR CASH COMPOSITION - SETTING AT GLOBAL LEVEL                                                                          
    ===================================================================*/                                                                          
    UPDATE #C_PARTYCODE                                                                          
    SET     CASH_COMPO = CASH                                                                          
    FROM    CASHCOMPOSITION                                                                          
    WHERE   CASHCOMPOSITION.PARTY_CODE = ''                                                                          
        AND EXCHANGE                   = @EXCHANGE                                     
        AND SEGMENT                    = @SEGMENT                                                                          
        AND CLIENT_TYPE                = ''                                                            
        AND ACTIVE                     = 1                                                                          
        AND EFFDATE                    =                                                                          
            (SELECT MAX(EFFDATE)                                                                          
            FROM    CASHCOMPOSITION                                                                          
            WHERE   EFFDATE         <= @EFFDATE + ' 23:59'                                                                          
                AND CASHCOMPOSITION.PARTY_CODE = ''                                                                          
    AND CLIENT_TYPE                = ''                                                                          
                AND EXCHANGE                   = @EXCHANGE                                                    
                AND SEGMENT                   = @SEGMENT                                                                          
                AND ACTIVE                     = 1                                                                          
            )                                                                          
        AND CASH_COMPO = 0                                                            
    /*==============================================================                                                                          
    UPDATE FOR NON CASH COMPOSITION - SETTING AT PARTY LEVEL                                                                          
    =================================================================*/                                                                          
    UPDATE #C_PARTYCODE                                                                          
    SET     NONCASH_COMPO = NONCASH                                                                          
    FROM    CASHCOMPOSITION                                                                          
    WHERE   CASHCOMPOSITION.PARTY_CODE = #C_PARTYCODE.PARTY_CODE                                                                          
        AND EXCHANGE                   = @EXCHANGE                                                                          
        AND SEGMENT             = @SEGMENT              AND CLIENT_TYPE                = ''                                                                          
        AND ACTIVE              = 1                                                            
        AND EFFDATE                    =                                                                          
            (SELECT MAX(EFFDATE)                                                                          
            FROM    CASHCOMPOSITION                                                                          
            WHERE   EFFDATE                   <= @EFFDATE + ' 23:59'                              
                AND CASHCOMPOSITION.PARTY_CODE = #C_PARTYCODE.PARTY_CODE                                     
                AND CLIENT_TYPE                = ''                     
                AND EXCHANGE                   = @EXCHANGE                                                                          
                AND SEGMENT                    = @SEGMENT                                                                          
                AND ACTIVE                     = 1                                                                          
            )                                                     
    /*=======================================================================                                                                          
    UPDATE FOR NON CASH COMPOSITION - SETTING AT CLIENT TYPE LEVEL                                        
    =======================================================================*/                                                                          
    UPDATE #C_PARTYCODE                                                                          
    SET     NONCASH_COMPO = NONCASH                                                                          
    FROM    CASHCOMPOSITION                                                                          
    WHERE   CASHCOMPOSITION.PARTY_CODE = ''                                                                          
        AND EXCHANGE                   = @EXCHANGE                             
        AND SEGMENT                    = @SEGMENT                          
        AND CLIENT_TYPE                = #C_PARTYCODE.CL_TYPE                                                                          
        AND ACTIVE              = 1                                            
        AND EFFDATE                    =                                                                          
            (SELECT MAX(EFFDATE)                                                                          
            FROM    CASHCOMPOSITION                                                                          
            WHERE   EFFDATE                   <= @EFFDATE + ' 23:59'                                                                          
         AND CASHCOMPOSITION.PARTY_CODE = ''                                                                      
                AND CLIENT_TYPE                = #C_PARTYCODE.CL_TYPE                                                                          
                AND EXCHANGE                   = @EXCHANGE                                                                          
                AND SEGMENT                    = @SEGMENT                                                                          
                AND ACTIVE       = 1                                                       
            )                                    
        AND NONCASH_COMPO = 0                                                                  
    /*===================================================================                                                                         
    UPDATE FOR NON CASH COMPOSITION - SETTING AT GLOBAL LEVEL                                                                          
    ===================================================================*/                                                                          
    UPDATE #C_PARTYCODE                                                                          
 SET     NONCASH_COMPO = NONCASH                                                                          
    FROM    CASHCOMPOSITION                                                                      
    WHERE   CASHCOMPOSITION.PARTY_CODE = ''                                                                          
        AND EXCHANGE                   = @EXCHANGE                                                                          
        AND SEGMENT                   = @SEGMENT                                                                          
        AND CLIENT_TYPE       = ''                                                                          
        AND ACTIVE                     = 1                                                                      
        AND EFFDATE                    =                         
            (SELECT MAX(EFFDATE)                                                                          
            FROM    CASHCOMPOSITION                                                                          
            WHERE   EFFDATE                   <= @EFFDATE + ' 23:59'                                                                          
                AND CASHCOMPOSITION.PARTY_CODE = ''                                                                          
                AND CLIENT_TYPE                = ''                                                                          
    AND EXCHANGE              = @EXCHANGE                                                               
                AND SEGMENT                    = @SEGMENT                                                                          
       AND ACTIVE                     = 1                                                                          
            )                                                                          
        AND NONCASH_COMPO = 0                                                                          
    /*=============================================================                                                                          
    UPDATE FOR INSTR TYPE MST - SETTING AT PARTY LEVEL        
    ===============================================================*/                                                                          
    UPDATE #C_PARTYCODE                                                                          
    SET     CASH_NCASH = INSTRUTYPEMST.CASH_NCASH                                              
    FROM    INSTRUTYPEMST                                                                          
    WHERE   INSTRUTYPEMST.PARTY_CODE = #C_PARTYCODE.PARTY_CODE                                                                          
        AND EXCHANGE                 = @EXCHANGE                        AND SEGMENT                  = @SEGMENT                                                                          
        AND CLIENT_TYPE              = ''                                
        AND ACTIVE                   = 1                                                                          
        AND EFFDATE                  =                                                                          
            (SELECT MAX(EFFDATE)                                                                          
FROM    INSTRUTYPEMST                                                   
           WHERE   EFFDATE                 <= @EFFDATE + ' 23:59'                                                                          
                AND INSTRUTYPEMST.PARTY_CODE = #C_PARTYCODE.PARTY_CODE                                           
                AND CLIENT_TYPE              = ''                                                                          
                AND EXCHANGE                 = @EXCHANGE                                                                          
          AND SEGMENT                  = @SEGMENT                                                          
                AND ACTIVE                   = 1                                                                          
            )                                                                          
        AND INSTRU_TYPE = RECORD_TYPE                                                                          
    /*==================================================================                 
    UPDATE FOR INSTR TYPE MST - SETTING AT CLIENT TYPE LEVEL                                                                          
    ==================================================================*/                                                                          
    UPDATE #C_PARTYCODE                                             
    SET     CASH_NCASH = INSTRUTYPEMST.CASH_NCASH                                                                          
    FROM    INSTRUTYPEMST                                                                          
    WHERE   INSTRUTYPEMST.PARTY_CODE = ''                                                                          
        AND EXCHANGE                 = @EXCHANGE                                                        
        AND SEGMENT                  = @SEGMENT                                     
        AND CLIENT_TYPE              = #C_PARTYCODE.CL_TYPE                                                                          
        AND ACTIVE                   = 1                                                                          
     AND EFFDATE                  =                                                  
            (SELECT MAX(EFFDATE)                                                                          
            FROM    INSTRUTYPEMST                                                                          
            WHERE   EFFDATE                 <= @EFFDATE + ' 23:59'                                                                          
                AND INSTRUTYPEMST.PARTY_CODE = ''                                                                          
                AND CLIENT_TYPE              = #C_PARTYCODE.CL_TYPE                                                                          
                AND EXCHANGE           = @EXCHANGE                                                   
             AND SEGMENT                  = @SEGMENT                   
                AND ACTIVE                   = 1                                                                          
            )                                                                          
        AND INSTRU_TYPE             = RECORD_TYPE                                                                          
        AND #C_PARTYCODE.CASH_NCASH =''                                                                          
    /*===============================================================                                                                          
    UPDATE FOR INSTR TYPE MST - SETTING AT GLOBAL LEVEL                                                                          
    ================================================================*/                           
    UPDATE #C_PARTYCODE                                                                   
    SET     CASH_NCASH = INSTRUTYPEMST.CASH_NCASH                                                                          
    FROM    INSTRUTYPEMST                                                                          
    WHERE   INSTRUTYPEMST.PARTY_CODE = ''                                                                          
        AND EXCHANGE                 = @EXCHANGE                                                                          
        AND SEGMENT                  = @SEGMENT                                                                          
        AND CLIENT_TYPE = ''                                                                          
        AND ACTIVE          = 1                                                                          
     AND EFFDATE                  =                                                                      
            (SELECT MAX(EFFDATE)                                                                          
        FROM    INSTRUTYPEMST                                                                          
            WHERE   EFFDATE                 <= @EFFDATE + ' 23:59'                                                                          
                AND INSTRUTYPEMST.PARTY_CODE = ''                                                                          
                AND CLIENT_TYPE              = ''                                                                          
     AND EXCHANGE                 = @EXCHANGE                                                              
                AND SEGMENT                  = @SEGMENT                                                                          
             AND ACTIVE                   = 1                                                                          
            )                                                                          
        AND INSTRU_TYPE             = RECORD_TYPE                                                                          
        AND #C_PARTYCODE.CASH_NCASH =''                                                                          
    /*=======================================================================                                                                          
    CREATE LATEST CLOSING PRICE INFORMATION FOR VALUATION OF SECURITIES                                             
    =======================================================================*/                                                                          
    SELECT  SCRIP_CD,                                                             
            SERIES  ,                                                                          
            CL_RATE=MAX(CL_RATE)                         
    INTO    #C_VALUATION                                                                
    FROM    C_VALUATION C1                                                                          
    WHERE   EXCHANGE = @EXCHANGE                                                                          
        AND SEGMENT  = @SEGMENT                                                                          
        AND SYSDATE  =                              
    (SELECT MAX(SYSDATE)                                                                          
            FROM    C_VALUATION C2                                                                          
      WHERE   EXCHANGE    = @EXCHANGE                                                                          
                AND SEGMENT     = @SEGMENT                                                                          
                AND SYSDATE    <= @EFFDATE + ' 23:59:59'                                                                          
                AND C1.SCRIP_CD = C2.SCRIP_CD                                                                          
                AND C1.SERIES   = C2.SERIES                                                                          
                AND SCRIP_CD   IN                                            
                    (SELECT DISTINCT SCRIP_CD                                                                          
                    FROM    #C_CALCULATESECVIEW                                                                          
                    )                                                                          
            )                                                                          
        AND SCRIP_CD IN                                                                          
            (SELECT DISTINCT SCRIP_CD                                                 
            FROM    #C_CALCULATESECVIEW                                                                          
      )                                                          
    GROUP BY SCRIP_CD,                                                                          
            SERIES                                                                          
    /*================================================================                                         
    TAKING DETAILS TO TEMP TABLE                                                                          
    ================================================================*/                                                                          
 CREATE TABLE #COLLATERALDATA                                                                          
            (                                                    
                PARTY_CODE    VARCHAR(10)  ,                                                                          
            CL_TYPE       VARCHAR(10)  ,                                           
                    RECORD_TYPE   VARCHAR(10)  ,                                                                          
                    CASH_COMPO    NUMERIC(18,2),                                                                          
                    NONCASH_COMPO NUMERIC(18,2),                                                                          
                    MARGINAMT MONEY            ,                                                                          
                    TOTALCASH MONEY            ,                                                                          
   ORGTOTCASH MONEY           ,                             
          TOTALNONCASH MONEY         ,                                                                          
                    ORGTOTNONCASH MONEY     ,                                        
                    CASH_NCASH CHAR(1)        ,                                         
                 FDAMOUNT MONEY             ,                                                                          
                    TOTALFDAMOUNT MONEY        ,                                                                          
                    BGAMOUNT MONEY             ,                                                                          
                    TOTALBGAMOUNT MONEY        ,                                                       
                    SECAMOUNT MONEY            ,                                                                          
                    TOTALSECAMOUNT MONEY                                                                     
            )                                                                          
    /*================================================================                                                                          
    UPDATING FROM MARGIN LEDGER                      
    ================================================================*/                                                                          
    INSERT                                                                          
    INTO    #COLLATERALDATA                                                                    
    SELECT  #C_PARTYCODE.PARTY_CODE       ,                                                                          
            CL_TYPE= ISNULL(CL_TYPE,'CLI'),                                                                        
            RECORD_TYPE                   ,                                                                         
            CASH_COMPO                    ,                                                                          
            NONCASH_COMPO                 ,                                                                          
            MARGINAMT    = MARGINAMT         ,                                                               
            TOTALCASH    = MARGINAMT         ,                                                                          
            ORGTOTCASH   = MARGINAMT         ,                                    
            TOTALNONCASH =0                  ,                                                                          
            ORGTOTNONCASH=0                  ,                                                                          
    CASH_NCASH                       ,                                                                          
    FDAMOUNT      =0                       ,                                                                          
            TOTALFDAMOUNT = 0                      ,                                                                          
            BGAMOUNT      = 0                      ,                       
            TOTALBGAMOUNT = 0                      ,                                                                          
            SECAMOUNT     =0                       ,                                                                          
            TOTALSECAMOUNT=0                                                             
    FROM    #C_PARTYCODE      ,                                                                          
            (SELECT PARTY_CODE,                                                  
                    MARGINAMT = ISNULL((SUM(DAMT) - SUM(CAMT)),0)                                                                          
            FROM    C_MARGINLEDGER                                                                          
            WHERE   EXCHANGE = @EXCHANGE                                                                          
                AND SEGMENT  = @SEGMENT                                                  
            GROUP BY PARTY_CODE                                                                          
  ) MRG                                                                          
    WHERE   MRG.PARTY_CODE = #C_PARTYCODE.PARTY_CODE                                                                          
        AND RECORD_TYPE    = 'MARGIN'                                                                          
    CREATE TABLE [#COLLATERALDETAILS]                                                                          
            (                                                                 
                    [EFFDATE] [DATETIME]                 ,                                        
                    [EXCHANGE] [VARCHAR] (3)             ,                                                                          
                    [SEGMENT] [VARCHAR] (20)             ,                                                                          
                    [PARTY_CODE] [VARCHAR] (10)          ,                                                                          
                    [SCRIP_CD] [VARCHAR] (12)            ,                                                                          
                    [SERIES] [VARCHAR] (3)               ,                                                                          
                    [ISIN] [VARCHAR] (20)                ,                                                                          
                    [CL_RATE] [MONEY]     ,                                                                          
                    [AMOUNT] [MONEY]                     ,                                                                          
              [QTY] [NUMERIC](18, 4)          ,                                                                          
                    [HAIRCUT] [MONEY]                    ,                                                                          
     [FINALAMOUNT] [MONEY]                ,                                                                     
                    [PERCENTAGECASH] [NUMERIC](18, 2)    ,                                                                          
                    [PERECNTAGENONCASH] [NUMERIC](18, 2) ,                                                                 
                    [RECEIVE_DATE] [DATETIME]            ,                                      
                    [MATURITY_DATE] [DATETIME]           ,                                                                          
                    [COLL_TYPE] [VARCHAR] (6)            ,                                                                          
                    [CLIENTTYPE] [VARCHAR] (3)           ,                                                                          
                    [REMARKS] [VARCHAR] (50)             ,                         
                  [LOGINNAME] [VARCHAR] (20)           ,                                                                          
                    [LOGINTIME] [DATETIME]               ,                                                                          
                    [CASH_NCASH] [VARCHAR] (2)           ,                                            
                    [GROUP_CODE] [VARCHAR] (15)          ,                                                               
                    [FD_BG_NO] [VARCHAR] (20)            ,                                                                       
                    [BANK_CODE] [VARCHAR] (15)           ,                                                                          
                    [FD_TYPE] [VARCHAR] (1)                                                                          
            )                                                                          
    INSERT                                                                          
    INTO    #COLLATERALDETAILS SELECT EFFDATE = @EFFDATE ,                                                 
            EXCHANGE                          = @EXCHANGE,                                                               
            SEGMENT                           = @SEGMENT ,                                                                          
            PARTY_CODE                                   ,                                                                        
            SCRIP_CD          = ''                                ,                                                                          
            SERIES            = ''                   ,                                                                          
            ISIN          = ''                                ,                                                                          
            CL_RATE           = 0                                 ,                                                                          
            AMOUNT            = MARGINAMT                         ,                                                                   
            QTY               = 0        ,                                                         
            HAIRCUT   = 0                                 ,                                                                          
            FINALAMOUNT       = MARGINAMT                         ,                           
            PERCENTAGECASH    = CASH_COMPO       ,                                                                          
            PERECNTAGENONCASH = NONCASH_COMPO                     ,                                                                          
            RECEIVE_DATE      = ''                                ,                                                                          
            MATURITY_DATE     = ''                                ,                                                                          
            COLL_TYPE         = 'MARGIN'                          ,  CLIENTTYPE        = CL_TYPE                           ,         
            REMARKS       = ''                                ,                           
         LOGINNAME         = ''                       ,                                                                          
            LOGINTIME         = GETDATE                                                                          
            (                                                                          
            )                                                                          
            ,                                                                          
            CASH_NCASH = 'C',                                                                          
 GROUP_CODE = '' ,                                                                          
            FD_BG_NO   = '' ,                                                                          
            BANK_CODE  = '' ,                                                                          
            FD_TYPE    = ''                                           
    FROM  #COLLATERALDATA                                                                          
    WHERE   MARGINAMT   > 0                                                                          
        AND RECORD_TYPE = 'MARGIN'                                                           
                                                          
                                                      
    /*================================================================                                                                          
    UPDATING FROM FIXED DEPOSITS                                                                          
    ================================================================*/                                                                          
    CREATE TABLE [#FIXEDDEPOSIT]                      
            (                                                                          
                    [PARTY_CODE] [VARCHAR] (10)  ,                                                 
                    [CL_TYPE] VARCHAR(10)        ,                                                                          
                   [BALANCE] [MONEY]            ,                                                                          
                    [BANK_CODE] [VARCHAR](15)    ,                                                                          
                    [FD_TYPE] CHAR(1)            ,                                                                          
                    [FDR_NO] [VARCHAR] (20)      ,                                                                          
                    [RECEIVE_DATE]  DATETIME     ,                                        
                    [MATURITY_DATE] DATETIME   ,                                                                          
             [FDHAIRCUT]     NUMERIC(18,2),                                                            
                    [FDAMOUNT] MONEY                                                                          
            )                                                       
    INSERT                                
    INTO    #FIXEDDEPOSIT                                                                          
    SELECT  F.PARTY_CODE                     ,                                                                          
            CL_TYPE                          ,                                                                   
            BALANCE = ISNULL(SUM(BALANCE),0) ,                                                                          
            FM.BANK_CODE                     ,                                                                          
            FM.FD_TYPE                       ,                                                                          
            FM.FDR_NO                        ,                                                  
            FM.RECEIVE_DATE    ,                                                                          
            FM.MATURITY_DATE                 ,                                                                          
            FDHAIRCUT = 0                    ,                                                                 
       FDAMOUNT  =0                                                                          
    FROM    FIXEDDEPOSITTRANS F,                                                                          
            FIXEDDEPOSITMST FM ,                                                                          
            #C_PARTYCODE                                                     
    WHERE   F.TRANS_DATE =                                                                          
            (SELECT MAX(F1.TRANS_DATE)                                                                          
            FROM    FIXEDDEPOSITTRANS F1                                                 
            WHERE   F.PARTY_CODE   = F1.PARTY_CODE                                                                          
                AND F.BANK_CODE    = F1.BANK_CODE                                                                          
                AND F.FDR_NO       = F1.FDR_NO                                                                       
                AND F1.TRANS_DATE <= @EFFDATE + ' 23:59'                                                                          
                AND F1.BRANCH_CODE = F1.BRANCH_CODE                                                                          
AND F1.TCODE       = F.TCODE                                                                          
            )                                                                          
        AND FM.EXCHANGE             = @EXCHANGE                                                                          
        AND FM.SEGMENT              = @SEGMENT                                                                          
        AND F.BRANCH_CODE           = FM.BRANCH_CODE                                                                          
        AND FM.PARTY_CODE           = F.PARTY_CODE                                                                          
        AND FM.BANK_CODE            = F.BANK_CODE                                                                          
        AND FM.FDR_NO               = F.FDR_NO                                                                          
        AND FM.STATUS              <> 'C'                                                                          
    AND @EFFDATE + ' 23:59:59' >= FM.RECEIVE_DATE                                                                          
        AND @EFFDATE +' 00:00:00'  <= FM.MATURITY_DATE -- - ISNULL(FM.BENEFIT_REMOVAL_DAYS,0)                                                              
   AND FM.TCODE                = F.TCODE                                                                          
        AND F.PARTY_CODE            = #C_PARTYCODE.PARTY_CODE                                                                
        AND RECORD_TYPE             = 'FD'                                                                          
    GROUP BY FM.BANK_CODE   ,                                                                          
            FM.FD_TYPE      ,                                                        
            FM.FDR_NO       ,                                                                FM.RECEIVE_DATE ,                                                                          
            FM.MATURITY_DATE,                                                                          
            CL_TYPE         ,                                                                          
            F.PARTY_CODE                                                                          
    /*===========================================================                                                                          
    FIXED DEPOSITS - SETTING AT PARTY CODE + BANK CODE LEVEL                                                                          
    ===========================================================*/                                                                          
    UPDATE #FIXEDDEPOSIT                                                                          
    SET     FDHAIRCUT = HAIRCUT                                                                          
    FROM    FDHAIRCUT                                                              
    WHERE   FDHAIRCUT.PARTY_CODE = #FIXEDDEPOSIT.PARTY_CODE                                                   
        AND FDHAIRCUT.BANK_CODE  = #FIXEDDEPOSIT.BANK_CODE                                                                          
        AND EXCHANGE             = @EXCHANGE             AND SEGMENT              = @SEGMENT                                                                          
        AND ACTIVE               = 1                                                                              AND EFFDATE              =                                                                          
            (SELECT MAX(EFFDATE)                                                                
         FROM    FDHAIRCUT                                                                          
            WHERE   EFFDATE             <= @EFFDATE + ' 23:59'                                                                          
                AND FDHAIRCUT.PARTY_CODE = #FIXEDDEPOSIT.PARTY_CODE                                                                          
                AND FDHAIRCUT.BANK_CODE  = #FIXEDDEPOSIT.BANK_CODE                                                                     
       AND EXCHANGE             = @EXCHANGE                                                                          
                AND SEGMENT              = @SEGMENT                                                                          
                AND ACTIVE               = 1                                                                          
            )                                                                          
    /*===========================================================                                                                          
    FIXED DEPOSITS - SETTING AT PARTY CODE LEVEL                                                                          
    ===========================================================*/                                                                          
    UPDATE #FIXEDDEPOSIT                                        
    SET     FDHAIRCUT = HAIRCUT                                                                          
    FROM    FDHAIRCUT                                                                          
    WHERE   FDHAIRCUT.PARTY_CODE = #FIXEDDEPOSIT.PARTY_CODE                                                                          
  AND FDHAIRCUT.BANK_CODE  = ''                                                                          
        AND EXCHANGE             = @EXCHANGE                                                                          
        AND SEGMENT              = @SEGMENT                                                                          
        AND ACTIVE               = 1                                                                          
        AND EFFDATE              =                                                                          
            (SELECT MAX(EFFDATE)                                                                 
            FROM    FDHAIRCUT                                                                          
            WHERE   EFFDATE             <= @EFFDATE + ' 23:59'                                                                          
                AND FDHAIRCUT.PARTY_CODE = #FIXEDDEPOSIT.PARTY_CODE                                                                          
                AND FDHAIRCUT.BANK_CODE  = ''                                                      
                AND EXCHANGE             = @EXCHANGE                                                                 
                AND SEGMENT              = @SEGMENT                      
                AND ACTIVE               = 1                                                                          
            )                                                                      
        AND #FIXEDDEPOSIT.FDHAIRCUT = 0                                                
    /*===========================================================                                                                          
    FIXED DEPOSITS - SETTING AT BANK CODE LEVEL                                     
    ===========================================================*/                                                                          
    UPDATE #FIXEDDEPOSIT                                                                          
    SET     FDHAIRCUT = HAIRCUT                                                                          
    FROM    FDHAIRCUT                                                                          
    WHERE   FDHAIRCUT.PARTY_CODE = ''                                                                          
        AND FDHAIRCUT.BANK_CODE  = #FIXEDDEPOSIT.BANK_CODE                                                                          
        AND EXCHANGE       = @EXCHANGE                                                                          
        AND SEGMENT              = @SEGMENT                         
        AND ACTIVE = 1                                                                          
        AND EFFDATE              =                                                                          
            (SELECT MAX(EFFDATE)                                                                          
            FROM    FDHAIRCUT                                 
     WHERE   EFFDATE             <= @EFFDATE + ' 23:59'                                                                          
               AND FDHAIRCUT.PARTY_CODE = ''                                                                          
                AND FDHAIRCUT.BANK_CODE  = #FIXEDDEPOSIT.BANK_CODE                                                                          
                AND EXCHANGE             = @EXCHANGE                                                                          
                AND SEGMENT              = @SEGMENT                                                                          
                AND ACTIVE             = 1                                                                          
            )                                                                          
        AND #FIXEDDEPOSIT.FDHAIRCUT = 0                                                                          
    /*===========================================================                                                                          
    FIXED DEPOSITS - SETTING AT CLIENT TYPE LEVEL                                                               
    ===========================================================*/                                                                       
    UPDATE #FIXEDDEPOSIT                                    
    SET     FDHAIRCUT = HAIRCUT                                                                          
    FROM    FDHAIRCUT                                                                 
    WHERE   FDHAIRCUT.PARTY_CODE = ''                                                                          
        AND FDHAIRCUT.BANK_CODE  = ''               
        AND CLIENT_TYPE          = #FIXEDDEPOSIT.CL_TYPE                                                                          
        AND CLIENT_TYPE         <> ''                                                                          
        AND EXCHANGE             = @EXCHANGE                                                                          
        AND SEGMENT              = @SEGMENT                                                                          
        AND ACTIVE               = 1                                                                          
        AND EFFDATE              =                                                                          
            (SELECT MAX(EFFDATE)                                                                          
            FROM    FDHAIRCUT                                                                          
            WHERE   EFFDATE             <= @EFFDATE + ' 23:59'                                
                AND FDHAIRCUT.PARTY_CODE = ''                                                                          
                AND FDHAIRCUT.BANK_CODE  = ''                                                     
        AND CLIENT_TYPE      = #FIXEDDEPOSIT.CL_TYPE                                        
                AND CLIENT_TYPE         <> ''                                                                          
                AND EXCHANGE             = @EXCHANGE                                                         
                AND SEGMENT              = @SEGMENT                                        
                AND ACTIVE               = 1                                                                          
            )                                                                          
        AND #FIXEDDEPOSIT.FDHAIRCUT = 0                                                                          
    /*===========================================================                                                                          
    FIXED DEPOSITS - SETTING AT GLOBAL LEVEL                                                                          
    ===========================================================*/                                                                          
    UPDATE #FIXEDDEPOSIT                                                                   
    SET     FDHAIRCUT = HAIRCUT                                                                         
    FROM    FDHAIRCUT                           
    WHERE   FDHAIRCUT.PARTY_CODE = ''                                     
        AND FDHAIRCUT.BANK_CODE  = ''                                                                          
        AND CLIENT_TYPE       = ''                                                                          
  AND EXCHANGE             = @EXCHANGE                                                                          
   AND SEGMENT              = @SEGMENT                                                                          
        AND ACTIVE               = 1                                                                          
        AND EFFDATE              =                                                                          
            (SELECT MAX(EFFDATE)                                                                          
            FROM    FDHAIRCUT                                                                          
            WHERE   EFFDATE             <= @EFFDATE + ' 23:59'                                                   
                AND FDHAIRCUT.PARTY_CODE = ''                                                             
                AND FDHAIRCUT.BANK_CODE  = ''                                                                          
               AND CLIENT_TYPE          = ''                                                                          
                AND EXCHANGE             = @EXCHANGE                                                                          
          AND SEGMENT              = @SEGMENT                                  
                AND ACTIVE               = 1              
            )                                                                          
        AND #FIXEDDEPOSIT.FDHAIRCUT = 0                                                                          
    /*===========================================================                                                                          
    FIXED DEPOSITS - APPLYING HAIR CUT                                                                          
    ===========================================================*/                                                                          
    INSERT                                                                          
    INTO    #COLLATERALDATA                                                 
    SELECT  #C_PARTYCODE.PARTY_CODE       ,                                                                          
            CL_TYPE= ISNULL(CL_TYPE,'CLI'),                                                                          
            RECORD_TYPE                   ,                                                                          
            CASH_COMPO                    ,                                                                          
            NONCASH_COMPO  ,                                                                          
            MARGINAMT=0              ,                                                     
         TOTALCASH=                                                                          
            CASE                                                                          
          WHEN CASH_NCASH <> 'N'                                                       
                    THEN (BALANCE - (BALANCE * FDHAIRCUT/100))                                                                          
                    ELSE 0                                                                          
            END,                                                              
            ORGTOTCASH=                                                                         
            CASE                                                                          
                    WHEN CASH_NCASH <> 'N'                                                                          
                    THEN BALANCE                                                                          
                    ELSE 0                                                                          
            END,                                                                          
            TOTALNONCASH=                                                                          
            CASE                                                          
                    WHEN CASH_NCASH = 'N'                              
                    THEN (BALANCE - (BALANCE * FDHAIRCUT/100))                                         
                  ELSE 0                                                                          
            END,                                                         
            ORGTOTNONCASH=                                                                          
            CASE                            
                    WHEN CASH_NCASH = 'N'                                                                          
                    THEN BALANCE                                                                          
                    ELSE 0                                                                          
            END                                          ,                                                                          
            CASH_NCASH                                   ,                                                                          
    FDAMOUNT      = BALANCE - (BALANCE * FDHAIRCUT/100),                                                                          
    TOTALFDAMOUNT = BALANCE                            ,                               
       BGAMOUNT     = 0                 ,                                                                          
        TOTALBGAMOUNT = 0 ,                                                                          
   SECAMOUNT     =0                                   ,                                                                          
            TOTALSECAMOUNT=0                                                                          
    FROM    #C_PARTYCODE      ,                                   
            (SELECT PARTY_CODE,                                                     
                    FDHAIRCUT ,                                                                          
                    BALANCE = SUM(BALANCE)                                                                          
            FROM    #FIXEDDEPOSIT                                                           
            GROUP BY PARTY_CODE,                                                                          
                    FDHAIRCUT                                                                       
            ) #FIXEDDEPOSIT                                                                       
    WHERE   #FIXEDDEPOSIT.PARTY_CODE = #C_PARTYCODE.PARTY_CODE                                                                          
        AND RECORD_TYPE              = 'FD'                                          
    INSERT                                                                          
    INTO    #COLLATERALDETAILS SELECT EFFDATE = @EFFDATE      ,                                                                          
            EXCHANGE                          = @EXCHANGE               ,                                                                          
            SEGMENT                           = @SEGMENT                ,                                                                          
    PARTY_CODE                      = #FIXEDDEPOSIT.PARTY_CODE,                                                                          
            SCRIP_CD                          = ''                      ,                                                                          
            SERIES                            = ''                      ,                                    
            ISIN  = ''                      ,                                                                          
            CL_RATE                           = 0                       ,                                                                          
            AMOUNT = #FIXEDDEPOSIT.BALANCE   ,                                                                          
            QTY                               = 0                       ,                                                                          
            HAIRCUT      = FDHAIRCUT               ,                     
            FINALAMOUNT                       = #FIXEDDEPOSIT.BALANCE - #FIXEDDEPOSIT.BALANCE * FDHAIRCUT / 100  ,                                                                          
            PERCENTAGECASH                    = CASH_COMPO              ,                                                                          
          PERECNTAGENONCASH                 = NONCASH_COMPO           ,                                             
            RECEIVE_DATE  = RECEIVE_DATE        ,                                                                          
            MATURITY_DATE               = MATURITY_DATE           ,                                                                          
            COLL_TYPE                         = 'FD'                    ,                                                                          
            CLIENTTYPE           = #COLLATERALDATA.CL_TYPE ,                                                                          
            REMARKS        = ''                      ,                                    
            LOGINNAME                        = ''                      ,                                                                          
            LOGINTIME                         = GETDATE                                                                          
            (                                                                    
            )                                                                          
            ,                                                                          
            CASH_NCASH            ,                                                                          
            GROUP_CODE = ''       ,                                                                          
         FD_BG_NO   = FDR_NO   ,                                                             
            BANK_CODE  = BANK_CODE,                                                                         
            FD_TYPE    = FD_TYPE                                                                          
    FROM   #FIXEDDEPOSIT,                                                                          
            #COLLATERALDATA                                                                          
    WHERE   #FIXEDDEPOSIT.PARTY_CODE = #COLLATERALDATA.PARTY_CODE                                                                          
     AND RECORD_TYPE              = 'FD'                                     
                   
                      /*=======================================================================                                                                 
    CALCULATION FOR BG                                                                          
    =======================================================================*/                                 
    CREATE TABLE [#BANKGUARANTEE]                                                                          
            (                                                                          
                    [PARTY_CODE] [VARCHAR] (10)  ,                                             
                  [CL_TYPE] VARCHAR(10)        ,                                                                          
     [BALANCE] [MONEY]            ,                                                                          
                    [BANK_CODE] [VARCHAR](15)    ,                                                                          
                    [BG_NO] [VARCHAR] (20)       ,                                                                          
                    [RECEIVE_DATE]  DATETIME     ,                                                                          
                    [MATURITY_DATE] DATETIME     ,                                                            
                    [BGHAIRCUT]     NUMERIC(18,2),                                                                          
        [BGAMOUNT] MONEY                                                               
            )                                                                          
    INSERT                                                                          
    INTO    #BANKGUARANTEE                                                                
    SELECT  F.PARTY_CODE                     ,                                                                          
            CL_TYPE                          ,                                                                          
BALANCE = ISNULL(SUM(BALANCE),0) ,                                                                          
            FM.BANK_CODE                     ,                                                                          
            FM.BG_NO  ,                                                                          
            FM.RECEIVE_DATE                  ,                              
            FM.MATURITY_DATE     ,                                                                          
            0,0                                              
    FROM    BANKGUARANTEETRANS F,                                                                          
            BANKGUARANTEEMST FM ,                                                                          
            #C_PARTYCODE                                                                          
    WHERE   F.TRANS_DATE =                                                                          
    (SELECT MAX(F1.TRANS_DATE)                                                                          
            FROM    BANKGUARANTEETRANS F1                                                      
            WHERE   F.PARTY_CODE   = F1.PARTY_CODE                                                                          
              AND F.BANK_CODE    = F1.BANK_CODE                                                                          
                AND F.BG_NO     = F1.BG_NO                                             
      AND F1.TRANS_DATE <= @EFFDATE + ' 23:59'                                                                          
                AND F1.BRANCH_CODE = F1.BRANCH_CODE                                                                          
                AND F1.TCODE       = F.TCODE                                                                          
            )                                                               
        AND FM.EXCHANGE            = @EXCHANGE                                                                          
        AND FM.SEGMENT             = @SEGMENT                                                                      
        AND F.BRANCH_CODE          = FM.BRANCH_CODE                                                                          
        AND FM.PARTY_CODE          = F.PARTY_CODE                                                                          
        AND FM.BANK_CODE           = F.BANK_CODE                                                     
       AND FM.BG_NO               = F.BG_NO                                                                     
        AND FM.STATUS             <> 'C'                                                                          
        AND @EFFDATE +' 23:59:59' >= FM.RECEIVE_DATE                                                                          
        AND @EFFDATE +' 00:00:00' <= FM.MATURITY_DATE -- - ISNULL(FM.BENEFIT_REMOVAL_DAYS,0)                                                                          
        AND FM.TCODE               = F.TCODE                                                                          
        AND F.PARTY_CODE           = #C_PARTYCODE.PARTY_CODE                                                                          
        AND RECORD_TYPE            = 'BG'                                                                 
    GROUP BY FM.BANK_CODE   ,                                                                          
            FM.BG_NO        ,                                                                          
            FM.RECEIVE_DATE ,                                                                          
            FM.MATURITY_DATE,                                                                          
            CL_TYPE         ,                                                                     
            F.PARTY_CODE                                                                          
    /*===========================================================                   
    BANK GUARANTEE - SETTING AT PARTY CODE + BANK CODE LEVEL                                       
    ===========================================================*/                                                                          
    UPDATE #BANKGUARANTEE                                                                          
    SET     BGHAIRCUT = HAIRCUT                                                      
    FROM    BGHAIRCUT                                                                          
    WHERE   BGHAIRCUT.PARTY_CODE = #BANKGUARANTEE.PARTY_CODE                                                                          
        AND BGHAIRCUT.BANK_CODE  = #BANKGUARANTEE.BANK_CODE                                                  
        AND EXCHANGE             = @EXCHANGE                                                                          
        AND SEGMENT          = @SEGMENT                                                                          
        AND ACTIVE               = 1                                                                          
        AND EFFDATE              =                                                           
 (SELECT MAX(EFFDATE)                                                                          
     FROM    BGHAIRCUT                                                                          
       WHERE   EFFDATE             <= @EFFDATE + ' 23:59'                                                                          
  AND BGHAIRCUT.PARTY_CODE = #BANKGUARANTEE.PARTY_CODE                                                                          
 AND BGHAIRCUT.BANK_CODE  = #BANKGUARANTEE.BANK_CODE                                                                          
AND EXCHANGE             = @EXCHANGE                                                                          
               AND SEGMENT              = @SEGMENT                                     
    AND ACTIVE               = 1                                                                          
            )                                                                          
    /*===========================================================                                                                          
    BANK GUARANTEE - SETTING AT PARTY CODE LEVEL                                                                          
    ===========================================================*/                                                                          
    UPDATE #BANKGUARANTEE                                                                          
    SET     BGHAIRCUT = HAIRCUT                                                                          
    FROM    BGHAIRCUT                          
  WHERE   BGHAIRCUT.PARTY_CODE = #BANKGUARANTEE.PARTY_CODE                                                                          
        AND BGHAIRCUT.BANK_CODE  = ''                                                                          
        AND EXCHANGE             = @EXCHANGE                                                                          
        AND SEGMENT              = @SEGMENT                                                                          
        AND ACTIVE               = 1                                                                          
        AND EFFDATE              =                                                                          
            (SELECT MAX(EFFDATE)                                           
            FROM    BGHAIRCUT                                                                  
            WHERE   EFFDATE   <= @EFFDATE + ' 23:59'                                                                          
                AND BGHAIRCUT.PARTY_CODE = #BANKGUARANTEE.PARTY_CODE                                                                          
                AND BGHAIRCUT.BANK_CODE  = ''                                                                          
                AND EXCHANGE             = @EXCHANGE                                                                          
                AND SEGMENT              = @SEGMENT                                                                          
                AND ACTIVE               = 1                                               
            )                                                                   
        AND #BANKGUARANTEE.BGHAIRCUT = 0                                                                          
    /*===========================================================                                                                          
    BANK GUARANTEE - SETTING AT BANK CODE LEVEL                                                                          
    ===========================================================*/                                                                          
    UPDATE #BANKGUARANTEE                                                                          
    SET     BGHAIRCUT = HAIRCUT                                                                          
    FROM    BGHAIRCUT                                                                          
WHERE   BGHAIRCUT.PARTY_CODE = ''                                                           
        AND BGHAIRCUT.BANK_CODE  = #BANKGUARANTEE.BANK_CODE                                                  
    AND EXCHANGE             = @EXCHANGE                                                         
        AND SEGMENT              = @SEGMENT                                                                          
 AND ACTIVE               = 1                                               
        AND EFFDATE              =                                                                          
            (SELECT MAX(EFFDATE)                                                                          
   FROM  BGHAIRCUT               
            WHERE   EFFDATE             <= @EFFDATE + ' 23:59'                                                                          
                AND BGHAIRCUT.PARTY_CODE = ''                                                           
                AND BGHAIRCUT.BANK_CODE  = #BANKGUARANTEE.BANK_CODE                                                          
                AND EXCHANGE             = @EXCHANGE                                                                          
                AND SEGMENT              = @SEGMENT                                                                          
                AND ACTIVE               = 1                                                                          
   )                                                                          
        AND #BANKGUARANTEE.BGHAIRCUT = 0                                                                          
    /*===========================================================              
    BANK GUARANTEE - SETTING AT CLIENT TYPE LEVEL                                                                          
    ===========================================================*/                                                                          
    UPDATE #BANKGUARANTEE                                                                          
    SET BGHAIRCUT = HAIRCUT                                                                          
    FROM    BGHAIRCUT                                                                          
    WHERE   BGHAIRCUT.PARTY_CODE = ''                                                                          
        AND BGHAIRCUT.BANK_CODE  = ''                                                                          
        AND CLIENT_TYPE          = #BANKGUARANTEE.CL_TYPE                                                                          
        AND CLIENT_TYPE         <> ''                                                                          
       AND EXCHANGE             = @EXCHANGE                                                                          
        AND SEGMENT              = @SEGMENT                                                                          
        AND ACTIVE   = 1                                                                        
        AND EFFDATE              =                              
          (SELECT MAX(EFFDATE)                                                                          
            FROM    BGHAIRCUT                 
            WHERE   EFFDATE            <= @EFFDATE + ' 23:59'                                                                          
                AND BGHAIRCUT.PARTY_CODE = ''                                                                          
                AND BGHAIRCUT.BANK_CODE  = ''                                                                          
                AND CLIENT_TYPE          = #BANKGUARANTEE.CL_TYPE                                                                
                AND CLIENT_TYPE         <> ''                                                                          
                AND EXCHANGE             = @EXCHANGE                                                                          
                AND SEGMENT              = @SEGMENT                                                                          
                AND ACTIVE               = 1                              
            )                                                   
        AND #BANKGUARANTEE.BGHAIRCUT = 0                                                                          
    /*===========================================================                                                                          
    BANK GUARANTEE - SETTING AT GLOBAL LEVEL                                                                          
    ===========================================================*/                                                                          
    UPDATE #BANKGUARANTEE                                                                          
    SET     BGHAIRCUT = HAIRCUT                                                                          
    FROM    BGHAIRCUT                                                                          
    WHERE   BGHAIRCUT.PARTY_CODE  = ''                                                                          
        AND BGHAIRCUT.BANK_CODE   = ''                                                    
        AND BGHAIRCUT.CLIENT_TYPE = ''                                                                          
        AND EXCHANGE              = @EXCHANGE                                                                          
        AND SEGMENT               = @SEGMENT                                                                          
        AND ACTIVE                = 1                                                                 
        AND EFFDATE               =                                                                          
        (SELECT MAX(EFFDATE)                                                                          
            FROM  BGHAIRCUT                                                      
       WHERE EFFDATE          <= @EFFDATE + ' 23:59'                                                                          
                AND BGHAIRCUT.PARTY_CODE  = ''                                               
   AND BGHAIRCUT.BANK_CODE   = ''                                                                          
                AND BGHAIRCUT.CLIENT_TYPE = ''                                                                          
                AND EXCHANGE              = @EXCHANGE                                                                          
        AND SEGMENT               = @SEGMENT                                  
                AND ACTIVE                = 1                                                           
            )                                                                          
        AND #BANKGUARANTEE.BGHAIRCUT = 0                                                                          
    /*===========================================================                                                                      
    BANK GAURANTEE - APPLYING HAIR CUT                                        
    ===========================================================*/                                                                          
    INSERT                                                                          
    INTO    #COLLATERALDATA                                                                          
    SELECT  #C_PARTYCODE.PARTY_CODE       ,                                                                          
            CL_TYPE= ISNULL(CL_TYPE,'CLI'),                                                                          
            RECORD_TYPE                   ,                                                                          
            CASH_COMPO                    ,                                                                          
            NONCASH_COMPO                 ,                                                                          
            MARGINAMT=0                   ,                                                                          
            TOTALCASH=                                                                          
            CASE         
                    WHEN CASH_NCASH <> 'N'                
    THEN (BALANCE - (BALANCE * BGHAIRCUT/100))                                                                          
  ELSE 0                                                                          
       END,                                                                          
            ORGTOTCASH=                                                                          
            CASE                                                                          
   WHEN CASH_NCASH <> 'N'                                    
                    THEN BALANCE                                                                          
                    ELSE 0                                                                          
            END,                                                                          
            TOTALNONCASH=                                                                  
            CASE                                                                          
                    WHEN CASH_NCASH = 'N'                                                                          
          THEN (BALANCE - (BALANCE * BGHAIRCUT/100))                                                                          
                    ELSE 0                                                                    
        END,                                                                          
            ORGTOTNONCASH=                                                                          
            CASE                                                                          
                    WHEN CASH_NCASH = 'N'                                                                          
                    THEN BALANCE                                                                          
                    ELSE 0                                                        
            END                                                ,                                                                          
            CASH_NCASH                         ,                                                                          
            FDAMOUNT      =0                                   ,                                                                          
        TOTALFDAMOUNT = 0                                  ,                                             
            BGAMOUNT      = BALANCE - (BALANCE * BGHAIRCUT/100),                                                                          
            TOTALBGAMOUNT = BALANCE      ,                                                         
SECAMOUNT     =0         ,                                                                          
       TOTALSECAMOUNT=0                                                                
    FROM    #C_PARTYCODE      ,                                                                          
            (SELECT PARTY_CODE,                                   
                    BGHAIRCUT ,                                                                          
                    BALANCE = SUM(BALANCE)                                            
            FROM #BANKGUARANTEE                    
      GROUP BY PARTY_CODE,                                                                          
                    BGHAIRCUT                                                                          
            ) #BANKGUARANTEE                                                                          
    WHERE   #BANKGUARANTEE.PARTY_CODE = #C_PARTYCODE.PARTY_CODE                                                                      
        AND RECORD_TYPE               = 'BG'                                                                          
                                                                          
    INSERT                                               
    INTO    #COLLATERALDETAILS SELECT EFFDATE = @EFFDATE                 ,                                                                          
            EXCHANGE                          = @EXCHANGE                ,                                                                          
 SEGMENT                           = @SEGMENT                 ,                                                                          
            PARTY_CODE                        = #BANKGUARANTEE.PARTY_CODE,                                                                          
            SCRIP_CD                          = ''          ,                                                                          
            SERIES                            = ''             ,                                                                          
            ISIN                              = ''                       ,                                                                          
            CL_RATE                      = 0                        ,                                                                          
            AMOUNT                         = BALANCE                  ,                                                                          
            QTY                               = 0                        ,                                                                          
        HAIRCUT  = BGHAIRCUT                ,                                                                          
            FINALAMOUNT                       = BALANCE - BALANCE*BGHAIRCUT/100 ,                                                                          
            PERCENTAGECASH        = CASH_COMPO    ,                                                                   
            PERECNTAGENONCASH                 = NONCASH_COMPO            ,                                                                          
            RECEIVE_DATE                      = RECEIVE_DATE             ,                                                                          
            MATURITY_DATE                     = MATURITY_DATE       ,                                                        
            COLL_TYPE                         = 'BG'                     ,                                                                          
            CLIENTTYPE                        = #COLLATERALDATA.CL_TYPE  ,                                                                          
            REMARKS                           = ''     ,                                                                          
            LOGINNAME           = ''                       ,                                                                          
            LOGINTIME      = GETDATE                                                                          
            (                                                                          
            )                                                                          
            ,                                                                          
            CASH_NCASH            ,                                                                          
            GROUP_CODE = ''       ,                                                                          
            FD_BG_NO   = BG_NO    ,                                                                          
            BANK_CODE  = BANK_CODE,                                                                          
            FD_TYPE    = 'B'                                                                   
    FROM    #BANKGUARANTEE,                                                                  
  #COLLATERALDATA                                                                          
    WHERE   #BANKGUARANTEE.PARTY_CODE = #COLLATERALDATA.PARTY_CODE                 
     AND RECORD_TYPE               = 'BG'                                                             
                                                          
                                                                    
    /*=======================================================================                                                                          
    CALCULATION FOR SEC                                                                          
    =======================================================================*/                                                                
    /*===================================================                                                                          
    SECURITY HAIRCUT - SETTING AT PARTY + SCRIP LEVEL                                                           
    =====================================================*/                                                                 
    UPDATE #C_CALCULATESECVIEW                                                                          
    SET     SECHAIRCUT = HAIRCUT                                                                          
    FROM                                                                          
            (SELECT #C_CALCULATESECVIEW.PARTY_CODE,                                                                          
                    #C_CALCULATESECVIEW.SCRIP_CD  ,                                                                          
                    HAIRCUT = ISNULL(MAX(SECURITYHAIRCUT.HAIRCUT),0)                                                                          
     FROM    #C_CALCULATESECVIEW,                                                                         
                    SECURITYHAIRCUT                                                                          
            WHERE   SECURITYHAIRCUT.PARTY_CODE  = #C_CALCULATESECVIEW.PARTY_CODE                                                                          
             AND SECURITYHAIRCUT.SCRIP_CD = #C_CALCULATESECVIEW.SCRIP_CD                                                     
                AND SECURITYHAIRCUT.SERIES     IN ('EQ', 'BE')                                                                 
                AND #C_CALCULATESECVIEW.SERIES IN ('EQ', 'BE')                                                                          
                AND EXCHANGE                    = @EXCHANGE                                                                          
     AND SEGMENT                     = @SEGMENT                                                                          
                AND ACTIVE                      = 1                                                                          
                AND EFFDATE                     =                                                                          
                    (SELECT MAX(EFFDATE)                                                                          
                    FROM    SECURITYHAIRCUT                                                                          
                    WHERE   EFFDATE                    <= @EFFDATE + ' 23:59'                                                                          
                        AND SECURITYHAIRCUT.PARTY_CODE  = #C_CALCULATESECVIEW.PARTY_CODE                                                      
                        AND SECURITYHAIRCUT.SCRIP_CD    = #C_CALCULATESECVIEW.SCRIP_CD                                                                          
                        AND SECURITYHAIRCUT.SERIES     IN ('EQ', 'BE')                                                                          
                        AND #C_CALCULATESECVIEW.SERIES IN ('EQ', 'BE')                                                                          
                        AND EXCHANGE                    = @EXCHANGE                                                                   
                       AND SEGMENT       = @SEGMENT                                                                          
         AND ACTIVE                      = 1                                                                          
                    )                             
    GROUP BY #C_CALCULATESECVIEW.PARTY_CODE,                                             
                    #C_CALCULATESECVIEW.SCRIP_CD                                                                          
            ) S                                                                          
    WHERE   S.PARTY_CODE           = #C_CALCULATESECVIEW.PARTY_CODE                                                                          
     AND S.SCRIP_CD                  = #C_CALCULATESECVIEW.SCRIP_CD           
        AND #C_CALCULATESECVIEW.SERIES IN ('EQ', 'BE')                                                                          
    UPDATE #C_CALCULATESECVIEW                                                              
    SET     SECHAIRCUT = SECURITYHAIRCUT.HAIRCUT                                                                          
    FROM    SECURITYHAIRCUT                                                                          
    WHERE   SECURITYHAIRCUT.PARTY_CODE = #C_CALCULATESECVIEW.PARTY_CODE                                                                          
        AND SECURITYHAIRCUT.SCRIP_CD   = #C_CALCULATESECVIEW.SCRIP_CD                                                                          
        AND SECURITYHAIRCUT.SERIES     = #C_CALCULATESECVIEW.SERIES                                               
        AND EXCHANGE                   = @EXCHANGE                                                                          
        AND SEGMENT                    = @SEGMENT                                                                          
        AND ACTIVE                     = 1                                                                          
        AND EFFDATE                    =                                                                    
            (SELECT MAX(EFFDATE)                                                                          
            FROM    SECURITYHAIRCUT                                                                          
            WHERE   EFFDATE                   <= @EFFDATE + ' 23:59'                                                                          
                AND SECURITYHAIRCUT.PARTY_CODE = #C_CALCULATESECVIEW.PARTY_CODE                                                   
                AND SECURITYHAIRCUT.SCRIP_CD   = #C_CALCULATESECVIEW.SCRIP_CD                                                          
                AND SECURITYHAIRCUT.SERIES     = #C_CALCULATESECVIEW.SERIES                                                                          
         AND EXCHANGE             = @EXCHANGE                                                                  
                AND SEGMENT                    = @SEGMENT                                                                          
                AND ACTIVE                     = 1                                                                          
            )                                                               
        AND SECHAIRCUT =0                                                             
    /*===================================================                                                                          
    SECURITY HAIRCUT - SETTING AT PARTY LEVEL                                                                          
    =====================================================*/                                                                          
    UPDATE #C_CALCULATESECVIEW                                                                          
    SET     SECHAIRCUT = SECURITYHAIRCUT.HAIRCUT                                                                          
    FROM    SECURITYHAIRCUT                                                                       
    WHERE   SECURITYHAIRCUT.PARTY_CODE = #C_CALCULATESECVIEW.PARTY_CODE                                                                          
        AND SECURITYHAIRCUT.SCRIP_CD   = ''                                                                          
        AND EXCHANGE                   = @EXCHANGE                                                                          
        AND SEGMENT                    = @SEGMENT                                                                          
        AND ACTIVE                     = 1               AND EFFDATE     =                                                                          
            (SELECT MAX(EFFDATE)                                                                          
            FROM    SECURITYHAIRCUT                                                                             WHERE   EFFDATE                 <= @EFFDATE + ' 23:59'                                                                          
                AND SECURITYHAIRCUT.PARTY_CODE = #C_CALCULATESECVIEW.PARTY_CODE                                                                          
                AND SECURITYHAIRCUT.SCRIP_CD   = ''                                                                          
                AND EXCHANGE                   = @EXCHANGE                                                                          
                AND SEGMENT                    = @SEGMENT                                                                          
                AND ACTIVE   = 1                                                                          
            )                                                                          
        AND SECHAIRCUT =0                                                                          
                                                                          
 IF @SECHAIRCUTTYPE = 0                                                                          
 BEGIN                                                                          
     /*===================================================                                                                          
     SECURITY HAIRCUT - SETTING SCRIP LEVEL                                                                          
     =====================================================*/                                                                          
                                                                           
                                                                           
     UPDATE #C_CALCULATESECVIEW                                                                          
     SET SECHAIRCUT = HAIRCUT                                                                          
     FROM (                                 
     SELECT #C_CALCULATESECVIEW.SCRIP_CD, HAIRCUT = ISNULL(MAX(SECURITYHAIRCUT.HAIRCUT),0)                                                  
     FROM #C_CALCULATESECVIEW, SECURITYHAIRCUT                                                                          
     WHERE SECURITYHAIRCUT.PARTY_CODE = ''                                                                          
     AND SECURITYHAIRCUT.SCRIP_CD = #C_CALCULATESECVIEW.SCRIP_CD                          
     AND SECURITYHAIRCUT.SERIES IN ('EQ', 'BE')                                                                          
     AND #C_CALCULATESECVIEW.SERIES IN ('EQ', 'BE')                                                                          
     AND EXCHANGE = @EXCHANGE                                                                          
     AND SEGMENT = @SEGMENT                                                    
     AND ACTIVE = 1                                                            
 AND EFFDATE = (SELECT MAX(EFFDATE) FROM SECURITYHAIRCUT                                                                          
     WHERE EFFDATE <= @EFFDATE + ' 23:59'                                                                          
     AND SECURITYHAIRCUT.PARTY_CODE = ''                                                
     AND SECURITYHAIRCUT.SCRIP_CD = #C_CALCULATESECVIEW.SCRIP_CD                                                                          
     AND SECURITYHAIRCUT.SERIES IN ('EQ', 'BE')                                                                          
     AND #C_CALCULATESECVIEW.SERIES IN ('EQ', 'BE')                                                                          
     AND EXCHANGE = @EXCHANGE                                                                          
     AND SEGMENT = @SEGMENT                                                                          
     AND ACTIVE = 1)                                                                          
     GROUP BY #C_CALCULATESECVIEW.SCRIP_CD                                 
     ) S                                                                          
     WHERE S.SCRIP_CD = #C_CALCULATESECVIEW.SCRIP_CD                       
     AND #C_CALCULATESECVIEW.SERIES IN ('EQ', 'BE')                                                                          
     AND SECHAIRCUT =0                                                                          
     UPDATE #C_CALCULATESECVIEW                                                                          
     SET SECHAIRCUT = SECURITYHAIRCUT.HAIRCUT                                                              
     FROM SECURITYHAIRCUT                                                                          
     WHERE SECURITYHAIRCUT.PARTY_CODE = ''                                                                          
     AND SECURITYHAIRCUT.SCRIP_CD = #C_CALCULATESECVIEW.SCRIP_CD                                                                          
     AND SECURITYHAIRCUT.SERIES LIKE #C_CALCULATESECVIEW.SERIES  + '%'                                                                          
     AND EXCHANGE = @EXCHANGE                                                                          
     AND SEGMENT = @SEGMENT                                                                          
     AND ACTIVE = 1                                                                          
     AND EFFDATE = (SELECT MAX(EFFDATE) FROM SECURITYHAIRCUT                                                                          
     WHERE EFFDATE <= @EFFDATE + ' 23:59'                                                                          
     AND SECURITYHAIRCUT.PARTY_CODE = ''                                                                          
     AND SECURITYHAIRCUT.SCRIP_CD = #C_CALCULATESECVIEW.SCRIP_CD                                                                          
     AND SECURITYHAIRCUT.SERIES LIKE  #C_CALCULATESECVIEW.SERIES +'%'                                                                
     AND EXCHANGE = @EXCHANGE                                                                          
     AND SEGMENT = @SEGMENT                                                                          
     AND ACTIVE = 1)                                                                          
     AND SECHAIRCUT =0                                                   
                       
                                                
                                                                          
     /*===================================================                                                                          
     SECURITY HAIRCUT - SETTING SCRIP GROUP LEVEL                                                 
     =====================================================*/                                                
                                                                           
     UPDATE #C_CALCULATESECVIEW                                                                          
     SET SECHAIRCUT = SECURITYHAIRCUT.HAIRCUT                                                                          
     FROM SECURITYHAIRCUT                                                                
     WHERE SECURITYHAIRCUT.PARTY_CODE = ''                                                                          
     AND SECURITYHAIRCUT.SCRIP_CD = ''                                                                          
     AND GROUP_CODE = #C_CALCULATESECVIEW.GROUP_CODE                                                                          
     AND EXCHANGE = @EXCHANGE                                                                          
     AND SEGMENT = @SEGMENT                                           AND ACTIVE = 1                                                               
     AND EFFDATE = (SELECT MAX(EFFDATE) FROM SECURITYHAIRCUT                                                                          
     WHERE EFFDATE <= @EFFDATE + ' 23:59'                                     
     AND SECURITYHAIRCUT.PARTY_CODE = ''                                                                          
     AND SECURITYHAIRCUT.SCRIP_CD = ''                                                                          
     AND GROUP_CODE = #C_CALCULATESECVIEW.GROUP_CODE                                                       
     AND EXCHANGE = @EXCHANGE                                                                          
     AND SEGMENT = @SEGMENT                                                                          
     AND ACTIVE = 1)                                                 
     AND SECHAIRCUT =0                                                          
                                                                           
     /*===================================================                                                                          
     SECURITY HAIRCUT - SETTING CLIENT TYPE LEVEL                                                                          
     =====================================================*/                                                                          
                                                  UPDATE #C_CALCULATESECVIEW                                                                          
     SET SECHAIRCUT = SECURITYHAIRCUT.HAIRCUT                                                                          
     FROM SECURITYHAIRCUT , #C_PARTYCODE                                                                          
     WHERE #C_PARTYCODE.PARTY_CODE = #C_CALCULATESECVIEW.PARTY_CODE                                                                          
     AND #C_CALCULATESECVIEW.PARTY_CODE = ''                                                                          
     AND SECURITYHAIRCUT.SCRIP_CD = ''                                                                          
     AND CLIENT_TYPE = #C_PARTYCODE.CL_TYPE                                                                          
     AND EXCHANGE = @EXCHANGE                                                                          
     AND SEGMENT = @SEGMENT                                                                          
     AND ACTIVE = 1                                                                          
     AND EFFDATE = (SELECT MAX(EFFDATE) FROM SECURITYHAIRCUT                                                                          
     WHERE EFFDATE <= @EFFDATE + ' 23:59'                                                                          
AND #C_CALCULATESECVIEW.PARTY_CODE = ''                               
     AND SECURITYHAIRCUT.SCRIP_CD = ''                                                 
     AND CLIENT_TYPE = #C_PARTYCODE.CL_TYPE                       
     AND EXCHANGE = @EXCHANGE                                                                          
     AND SEGMENT = @SEGMENT                                                                          
     AND ACTIVE = 1)                                                                          
     AND SECHAIRCUT =0                                                                          
                                     
     /*===================================================                                                                          
     SECURITY HAIRCUT - SETTING GLOBAL LEVEL                                                                          
     =====================================================*/                                                                          
    END                                                  
                                                
                                                                       
                                                                          
                                                                           
    SELECT  V.*                                 
    INTO    #VAR                                                                          
    FROM    VARDETAIL V,                                   
            VARCONTROL C                                                                          
    WHERE   V.DETAILKEY = C.DETAILKEY                                                                          
        AND C.RECDATE   =                                                                          
            (SELECT MAX(C1.RECDATE)                                                                          
            FROM    VARDETAIL V1 (nolock),                                                                          
    VARCONTROL C1 (nolock)                                        
            WHERE   V1.DETAILKEY = C1.DETAILKEY                                                                          
                --AND V.SCRIP_CD   = V1.SCRIP_CD                                                                          
                AND V.SERIES               IN ('EQ', 'BE')                                              
                AND V1.SERIES              IN ('EQ', 'BE')                                        
            AND C1.RECDATE  <= @EFFDATE + ' 23:59'                                                                          
            )                                                
                                                                          
    INSERT                                                                          
    INTO    #VAR                                                                          
    SELECT  V.*                                                                          
    FROM    VARDETAIL V,                                                                          
            VARCONTROL C                                                                       
    WHERE   V.DETAILKEY = C.DETAILKEY                                                         
        AND C.RECDATE   =                                                             
            (SELECT MAX(C1.RECDATE)                                                                          
            FROM    VARDETAIL V1 (nolock),                                                                          
                    VARCONTROL C1 (nolock)                                                                          
            WHERE   V1.DETAILKEY   = C1.DETAILKEY                                                                          
                AND V.SCRIP_CD     = V1.SCRIP_CD                                                                          
 AND V.SERIES NOT  IN ('EQ', 'BE')            
                AND V1.SERIES NOT IN ('EQ', 'BE')                                                                          
                AND V.SERIES       = V1.SERIES                                                                          
          AND C1.RECDATE    <= @EFFDATE + ' 23:59'                                                                          
            )                                                                          
                                                                        
  INSERT INTO  #VAR                                                   
  SELECT   RECTYPE=1,SCRIP_CD,SERIES='BSE',ISIN,SECVAR=MARGIN,INDEXVAR=MARGIN,APPVAR=MARGIN,                                                          
    SECSPECVAR=MARGIN,VARMARGINRATE=MARGIN,DETAILKEY=1                                                                                
   FROM    anand.bsedb_ab.dbo.VARDETAIL V  (nolock)                                                                            
   WHERE   V.FDATE   =                                                                              
     (SELECT MAX(FDATE)                                                          
     FROM     anand.bsedb_ab.dbo.VARDETAIL V1 (nolock)                                                                           
     WHERE  V.SCRIP_CD   = V1.SCRIP_CD                                                                              
      AND V1.FDATE  <= @EFFDATE + ' 23:59'                                                                          
     )                                                                              
                                                                           
 /*IF (SELECT COUNT(1) FROM SCRIP_APPROVED (NOLOCK) WHERE EXCHANGE = @EXCHANGE ) > 0                                                                          
 BEGIN                                                                          
  UPDATE  #VAR SET SECVAR = 100, APPVAR = 100, VARMARGINRATE = 100                                       
  WHERE ISIN NOT IN ( SELECT ISIN FROM SCRIP_APPROVED WHERE EXCHANGE = @EXCHANGE)                                                                          
 END */                                                                          
                                                                           
  if (SELECT ISNULL(COUNT(1), 0) FROM SCRIP_UNAPPROVED) > 0                                                     
  begin                                                                                  
  UPDATE  #VAR SET SECVAR = 100, APPVAR = 100, VARMARGINRATE = 100                                                                          
  WHERE ISIN  IN ( SELECT ISIN FROM SCRIP_UNAPPROVED)                                                                          
  End                                              
                                          
                                                                          
                                                                           
 UPDATE #C_CALCULATESECVIEW                                                                          
    SET     SECHAIRCUT = APPVAR                                                                          
                               
    FROM                                                                          
            (SELECT SCRIP_CD,                                                                          
                    APPVAR = MAX(APPVAR)                                                                          
            FROM   #VAR                                                                          
            WHERE   SERIES IN ('EQ', 'BE')                                                                          
            GROUP BY SCRIP_CD                                                                          
            ) A                               
    WHERE  #C_CALCULATESECVIEW.SCRIP_CD = A.SCRIP_CD                                                                          
        AND SERIES                      IN ('EQ', 'BE')                                                                          
        AND SECHAIRCUT                   =0                                 
                                        
                                          
                                                                                       
                                          
                                                                          
    UPDATE #C_CALCULATESECVIEW                                                              
    SET     SECHAIRCUT = VARMARGINRATE                                                                          
    FROM                                                                          
            (SELECT SCRIP_CD,                                                                          
                    SERIES ,                                                                          
                    VARMARGINRATE = VARMARGINRATE                                  
  FROM    #VAR                                                                          
            WHERE   SERIES NOT IN ('EQ', 'BE')                                                                          
            GROUP BY SCRIP_CD,                                                                          
                    SERIES,VARMARGINRATE                                  
            ) A                          
    WHERE   #C_CALCULATESECVIEW.SCRIP_CD = A.SCRIP_CD                                                                          
        AND #C_CALCULATESECVIEW.SERIES   = A.SERIES                                                                          
        AND SECHAIRCUT                   =0                                                        
                                  
                                                            
                                                                           
                                                                          
    UPDATE #C_CALCULATESECVIEW                                                                          
 SET     SECHAIRCUT = APPVAR                                                                                                            
     FROM                                                                                 
             (SELECT isin,                                                    
     APPVAR                                                                 
             FROM    #VAR                                                                                                            
             GROUP BY isin,APPVAR                                                  
             ) A                                                                                    
     WHERE   #C_CALCULATESECVIEW.ISIN = A.ISIN                                   
     AND SECHAIRCUT                   =0                                 
                                 
                            
                                 
                                                                          
                                                                            UPDATE #C_CALCULATESECVIEW                                                                          
    SET     CL_RATE = ISNULL(#C_VALUATION.CL_RATE,0)                                                                          
    FROM    #C_VALUATION                                                                          
    WHERE   #C_VALUATION.SCRIP_CD = #C_CALCULATESECVIEW.SCRIP_CD                                                                          
        AND #C_VALUATION.SERIES   = #C_CALCULATESECVIEW.SERIES                                                                          
    UPDATE #C_CALCULATESECVIEW                                                                          
    SET  TOTALSECAMOUNT = CL_RATE * BALQTY                    
    UPDATE #C_CALCULATESECVIEW                                                                          
    SET     SECAMOUNT = (TOTALSECAMOUNT - (TOTALSECAMOUNT * SECHAIRCUT/100))                                                    
                                                
                                         
                                         
                                                                       
    INSERT                                                                    
    INTO    #COLLATERALDATA                                                                          
    SELECT  #C_PARTYCODE.PARTY_CODE       ,                                                                          
            CL_TYPE= ISNULL(CL_TYPE,'CLI'),                       
            RECORD_TYPE  ,                                                                          
            CASH_COMPO                    ,                                                                      
       NONCASH_COMPO                 ,                                                                          
            MARGINAMT=0                   ,                                                                          
  TOTALCASH=                                                                          
            CASE                                                                          
            WHEN CASH_NCASH <> 'N'                                                                          
   THEN #C_CALCULATESECVIEW.SECAMOUNT                            
                    ELSE 0                                                                          
            END,                                                                          
            ORGTOTCASH=                                                                          
            CASE                                                                          
       WHEN CASH_NCASH <> 'N'                                                          
                    THEN #C_CALCULATESECVIEW.TOTALSECAMOUNT                                                
                    ELSE 0                                                                          
            END,                                                                          
            TOTALNONCASH=                                                                          
            CASE                                                                          
                    WHEN CASH_NCASH = 'N'                                                                          
                    THEN #C_CALCULATESECVIEW.SECAMOUNT                                                    ELSE 0                                                                          
            END,                                                                          
            ORGTOTNONCASH=                                                                          
            CASE                                                                          
                    WHEN CASH_NCASH = 'N'                                                                          
                    THEN #C_CALCULATESECVIEW.TOTALSECAMOUNT                                                     
                    ELSE 0                                                                          
            END                ,                                                                          
            CASH_NCASH                                   ,                                                                          
            FDAMOUNT      =0                             ,                                                            
            TOTALFDAMOUNT = 0             ,                                         
            BGAMOUNT      = 0                            ,                                                          
            TOTALBGAMOUNT = 0                            ,                                                                          
            SECAMOUNT     = #C_CALCULATESECVIEW.SECAMOUNT,                                                                          
            TOTALSECAMOUNT=#C_CALCULATESECVIEW.TOTALSECAMOUNT                                                                          
    FROM    #C_PARTYCODE                      ,                                                                          
     (SELECT PARTY_CODE                ,                                                                          
                    SECAMOUNT      = SUM(SECAMOUNT),                                                                          
                    TOTALSECAMOUNT = SUM(TOTALSECAMOUNT)                                                                          
            FROM    #C_CALCULATESECVIEW                                                                          
            GROUP BY PARTY_CODE                                                                          
            ) #C_CALCULATESECVIEW                                                   
    WHERE   #C_CALCULATESECVIEW.PARTY_CODE = #C_PARTYCODE.PARTY_CODE                                                                          
        AND RECORD_TYPE                    = 'SEC'                                                                          
    INSERT                                                  
    INTO    #COLLATERALDETAILS SELECT EFFDATE = @EFFDATE                          ,                                                                          
            EXCHANGE                          = @EXCHANGE                         ,                                                                          
            SEGMENT                  = @SEGMENT                          ,                                                                          
            PARTY_CODE                       = #C_CALCULATESECVIEW.PARTY_CODE    ,                                                                          
            SCRIP_CD                 = SCRIP_CD                          ,                                                                          
            SERIES                            = SERIES                            ,                                                                          
            ISIN                              = ISIN                              ,                                                                          
            CL_RATE                           = CL_RATE                           ,                                                                          
         AMOUNT         = #C_CALCULATESECVIEW.TOTALSECAMOUNT,                             
            QTY                               = BALQTY                            ,                                                      
            HAIRCUT                           = SECHAIRCUT                        ,                                                                          
            FINALAMOUNT                       = #C_CALCULATESECVIEW.SECAMOUNT     ,                                                                          
            PERCENTAGECASH                    = CASH_COMPO                        ,                                                                          
            PERECNTAGENONCASH                 = NONCASH_COMPO   ,                                                                      
            RECEIVE_DATE                      = ''                                ,                                                                          
            MATURITY_DATE                     = ''                                ,                                                           
            COLL_TYPE                         = 'SEC'                             ,                                                                          
            CLIENTTYPE                        = #COLLATERALDATA.CL_TYPE           ,                                                                     
            REMARKS                           = ''                                ,                   
            LOGINNAME                      = ''                                ,                                                                          
            LOGINTIME = GETDATE                                             
            (                                           
            )                                          
            ,                                                                          
            CASH_NCASH = CASH_NCASH,                                                                          
          GROUP_CODE = ''        ,                                                                          
FD_BG_NO   = ''        ,                                                                          
            BANK_CODE  = ''        ,                                                                 
            FD_TYPE    = ''                                                                          
    FROM    #C_CALCULATESECVIEW,                                                                          
            #COLLATERALDATA                                          
    WHERE   #C_CALCULATESECVIEW.PARTY_CODE = #COLLATERALDATA.PARTY_CODE                                                                          
        AND RECORD_TYPE                    = 'SEC'                                                  
                                                
                                                
                                       
                                                          
    CREATE TABLE #COLLATERALDATA_FINAL                                                                          
            (                                                                          
                    PARTY_CODE VARCHAR(10)  ,                                                                        
CASHCOMPO  NUMERIC(18,2),                                                                          
          MARGINAMT MONEY         ,                                                                          
TOTALCASH MONEY         ,                                                                    
                    ORGTOTCASH MONEY        ,                                                                          
                    TOTALNONCASH MONEY      ,                                                                          
                    ORGTOTNONCASH MONEY     ,                                                                          
FDAMOUNT MONEY          ,                                                                          
                    TOTALFDAMOUNT MONEY     ,                                                                          
                BGAMOUNT MONEY          ,                                                                          
                    TOTALBGAMOUNT MONEY     ,                                                                          
                    SECAMOUNT MONEY         ,                                                                          
     TOTALSECAMOUNT MONEY    ,                                                                          
          ACTUALCASH MONEY        ,                                                                          
                    ACTUALNONCASH MONEY     ,                                                                          
                    EFFECTIVECOLL MONEY                   
            )                                             
    INSERT                                                                          
 INTO    #COLLATERALDATA_FINAL                                                                          
    SELECT  PARTY_CODE         ,                                                                          
            CASH_COMPO         ,                                                                          
            SUM(MARGINAMT)     ,                                                                          
            SUM(TOTALCASH)     ,         
            SUM(ORGTOTCASH)    ,                                                                          
            SUM(TOTALNONCASH)  ,                                                                          
            SUM(ORGTOTNONCASH) ,                                                                          
            SUM(FDAMOUNT)      ,                                                                          
            SUM(TOTALFDAMOUNT) ,                                                                          
            SUM(BGAMOUNT)      ,                                                                          
            SUM(TOTALBGAMOUNT) ,                    
            SUM(SECAMOUNT)     ,                                                                          
            SUM(TOTALSECAMOUNT),                                  
            0,0,0                                                                          
    FROM    #COLLATERALDATA                                                                          
    GROUP BY PARTY_CODE,                                                                          
 CASH_COMPO                                                                          
    /*=======================================================================                                                                          
    APPLY THE CASH COMPOSITION RATIO                                                                          
    =======================================================================*/                                                                          
    UPDATE #COLLATERALDATA_FINAL                                                                          
    SET     ACTUALCASH =                                                                          
            CASE                                                                          
                    WHEN CASHCOMPO > 0                                                                          
                    THEN TOTALCASH                                                  
                    ELSE 0                                                                          
            END ,                                                                  
            ACTUALNONCASH =                                                                          
            CASE                                      
                 WHEN CASHCOMPO > 0                                                                          
                    THEN                                                                          
        CASE                                                                          
                                    WHEN TOTALCASH < TOTALNONCASH                 
                      THEN                                                                          
                                            CASE                                         
                                                    WHEN CASHCOMPO >0                                   
                                                    THEN CASE WHEN (TOTALCASH * 100)/CASHCOMPO > TOTALNONCASH THEN                                                                           
                TOTALNONCASH ELSE (TOTALCASH * 100)/CASHCOMPO END                                                                          
              ELSE 0                                                 
                              END                                                                          
                                    ELSE TOTALNONCASH                                                                          
                            END                                                            
                    ELSE 0                             
            END                                                                          
    UPDATE #COLLATERALDATA_FINAL                                                                     
    SET     ACTUALCASH =                                                                          
   CASE                                                                          
                    WHEN CASHCOMPO > 0                                                                          
                    THEN TOTALCASH                                                                          
                    ELSE 0                                                                          
            END ,                                                                          
            ACTUALNONCASH =                                                                          
            CASE                                                                          
                    WHEN CASHCOMPO > 0                                                                          
   THEN                                                                          
                            CASE                                                                          
                                    WHEN TOTALCASH < TOTALNONCASH                                                                          
                      THEN                                                                          
                                            CASE                                                           
                                                    WHEN CASHCOMPO >0                          
                     THEN (TOTALCASH * 100)/CASHCOMPO                                                                          
                                                    ELSE 0                                                                          
                                            END                                                                          
                                    ELSE TOTALNONCASH                                                                          
                            END                                                                    
                    ELSE 0                                                                          
            END                                                     
    UPDATE #COLLATERALDATA_FINAL                                                                          
    SET     EFFECTIVECOLL =                                                                          
            CASE                                                               
                    WHEN CASHCOMPO > 0                                                                          
                    THEN                                                                          
                            CASE                                                      
                                    WHEN TOTALCASH < TOTALNONCASH                        
       THEN                                                            
         CASE                                                                          
         WHEN ACTUALNONCASH < TOTALCASH+ TOTALNONCASH                                                                          
                                    THEN ACTUALNONCASH                                                                          
                                                    ELSE TOTALCASH + TOTALNONCASH                                                                          
                                            END                             
                                    ELSE TOTALCASH+ TOTALNONCASH                                                                          
                            END                                                                          
       ELSE TOTALCASH+ TOTALNONCASH                                                                          
            END                                                                          
    UPDATE #COLLATERALDATA_FINAL                                                                        
    SET     ACTUALNONCASH = EFFECTIVECOLL - ACTUALCASH                                                 
                                             
                                           
                                  
                                      
                                             
                                             
    /*=======================================================================                                                                       
    DELETE ALREADY CALCULATED DATA FOR THE DATE                                                                          
    =======================================================================*/                                                                          
    DELETE                                                                   
    FROM    COLLATERALDETAILS_suresh                                                                          
    WHERE   EXCHANGE = @EXCHANGE                                                                          
        AND SEGMENT  = @SEGMENT                                                                          
        AND EFFDATE between @EFFDATE and @EFFDATE  +' 23:59'                                                                          
        AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                                                          
          
    DELETE                                                                          
    FROM    collateral_suresh                         
    WHERE   EXCHANGE = @EXCHANGE                                      
        AND SEGMENT  = @SEGMENT                                                                          
      AND TRANS_DATE  between @EFFDATE and @EFFDATE  +' 23:59'                                                                          
        AND PARTY_CODE BETWEEN @FROMPARTY AND @TOPARTY                                                  
                                                
    /*=======================================================================                                                                          
    POPULATING TO FINAL TABLE                                                                          
    =======================================================================*/                                                                          
    INSERT                                                             
    INTO    COLLATERALDETAILS_suresh                                                                          
    SELECT  *                                                                          
    FROM    #COLLATERALDETAILS                                     
                                      
                                                                            
    INSERT                                                                          
    INTO    collateral_suresh SELECT EXCHANGE = @EXCHANGE   ,                      
            SEGMENT                    = @SEGMENT    ,                                                 
            PARTY_CODE                 = PARTY_CODE  ,                                                                          
          TRANS_DATE                 = @EFFDATE    ,                                                                          
            CASH                       = TOTALCASH   ,                                                                          
            NONCASH                    = TOTALNONCASH,                                                                          
            ACTUALCASH              =                                                                          
            (                                                                          
                    CASE                                                                          
                            WHEN ACTUALCASH <> 0                                                                          
                            THEN ACTUALCASH                                                                          
                            ELSE TOTALCASH                                                                          
                    END                                                
            )                                                                          
            ,                                                                          
            ACTUALNONCASH = ACTUALNONCASH,                                                                        
            EFFECTIVECOLL = EFFECTIVECOLL,                                                                          
            ACTIVE        = 1            ,                                                                          
            TCODE = 0  ,                                                                          
            REMARKS  = ''         ,                                                                          
            LOGINNAME     = ''           ,                                                                          
            LOGINTIME     = GETDATE                                                                          
            (                                                                          
            )                                                                          
            ,                                                                          
   TOTALFD     = FDAMOUNT ,                                                                          
            TOTALBG     = BGAMOUNT ,                                                            
            TOTALSEC    = SECAMOUNT     ,                                                                          
            TOTALMARGIN = MARGINAMT     ,                                                                  
            ORGCASH     = ORGTOTCASH    ,                                                                          
       ORGNONCASH  = ORGTOTNONCASH                                                                          
    FROM    #COLLATERALDATA_FINAL                                                                          
    WHERE   TOTALCASH    <> 0                                                                          
         OR TOTALNONCASH <> 0                                                                          
            SET @STATUS   = 1                                                                          
    /*=======================================================================                                                                          
    REMOVING TEMP FILES                                                                          
    =======================================================================*/                                                                          
    DROP TABLE #COLLATERALDATA_FINAL                             
    DROP TABLE #COLLATERALDATA                                                                          
    DROP TABLE #C_CALCULATESECVIEW                             
    DROP TABLE #C_PARTYCODE                                                                      
    DROP TABLE #C_VALUATION                                                                          
    DROP TABLE #COLLATERALDETAILS                                                                          
    DROP TABLE #FIXEDDEPOSIT                                                                          
    DROP TABLE #BANKGUARANTEE                                                                          
    --DROP TABLE #VAR                                                                          
                                                                          
 /*====================================  END OF PRCEDURE =====================================*/

GO
