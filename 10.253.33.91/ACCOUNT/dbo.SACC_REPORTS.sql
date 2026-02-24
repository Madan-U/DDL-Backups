-- Object: PROCEDURE dbo.SACC_REPORTS
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


CREATE PROCEDURE [dbo].[SACC_REPORTS]                                  
@SDATE VARCHAR(11),            /* AS MMM DD YYYY */                                  
@EDATE VARCHAR(11),            /* AS MMM DD YYYY */                                  
@FDATE VARCHAR(11),            /* AS MMM DD YYYY */                                  
@TDATE VARCHAR(11),            /* AS MMM DD YYYY */                                  
@FCODE VARCHAR(10),                                  
@TCODE VARCHAR(10),                                  
@STATUSID VARCHAR(30),                                  
@STATUSNAME VARCHAR(30),                                  
@BRANCH VARCHAR(10),                                  
@SELECTIONBY VARCHAR(3),                                  
@GROUPBY VARCHAR(10),                                  
@SORTBY VARCHAR(50),                                  
@REPORTNAME VARCHAR(30),                                  
@REPORTOPT VARCHAR(10),                                  
@FLD1 VARCHAR(50),  /*  TO BE USED FOR SHAREDB IN CASE OF PARTY LEDGER */                                  
@FLD2 VARCHAR(10),                                  
@FLD3 VARCHAR(10)                                  
                                  
AS        
DECLARE                                  
@@OPENDATE   AS VARCHAR(11),                                           
@@SELECTQURY AS VARCHAR(8000),                                  
@@FROMTABLES AS VARCHAR(2000),                                  
@@WHEREPART  AS VARCHAR(8000),                                  
@@GROUPBY    AS VARCHAR(200),                                  
@@SORTBY     AS VARCHAR(200),                                  
@@UALL       AS VARCHAR(20),                                  
@@USELECTQURY AS VARCHAR(8000),                                  
@@UFROMTABLES AS VARCHAR(2000),                                  
@@UWHEREPART  AS VARCHAR(8000),                                  
@@UGROUPBY    AS VARCHAR(200),                                  
@@USORTBY     VARCHAR(200),                                  
@@DATEFILTER AS VARCHAR(500),                                  
@@DATEFILTER1 AS VARCHAR(500),                                  
@@REPORTFROM AS VARCHAR(1)                                  
                                  
/* -------------------------------------------------------------------------- */                                  
IF @FDATE = " "                                   
BEGIN                                  
   SELECT @FDATE = @SDATE                                  
END                                  
                                  
IF @TDATE = " "                                  
BEGIN                                  
   SELECT @TDATE = @EDATE                                  
END                                  
                                  
/* GET FILTER CONDITION ON DATES BASED ON THE VALUE OF @SELECTIONBY */                                  
                                  
IF @SELECTIONBY = 'VDT'                                  
BEGIN                                  
   SELECT @@DATEFILTER = " WHERE L.VDT >= '" + @FDATE + " 00:00:00' AND L.VDT <= '" + @TDATE +" 23:59:59'"                                  
   SELECT @@DATEFILTER1 = "  VDT >= '" + @FDATE + " 00:00:00' AND VDT <= '" + @TDATE +" 23:59:59'"                                  
END                                  
ELSE IF @SELECTIONBY = 'EDT'                                  
BEGIN                                  
   SELECT @@DATEFILTER = " WHERE L.EDT >= '" + @FDATE + " 00:00:00' AND L.EDT <= '" + @TDATE +" 23:59:59'"                                  
   SELECT @@DATEFILTER1 = " EDT >= '" + @FDATE + " 00:00:00' AND EDT <= '" + @TDATE +" 23:59:59'"                                  
END                                  
/* -------------------------------------------------------------------------- */                                       
                                  
IF @REPORTNAME = 'CASH BOOK'                                   
BEGIN             
                                  
	IF UPPER(@SORTBY) = 'VDT'                                  
		SELECT @@SORTBY = " ORDER BY VOUDT, L.VTYP, L.VNO"                                  
	ELSE IF UPPER(@SORTBY) = 'EDT'                                  
		SELECT @@SORTBY = " ORDER BY EFFDT, L.VTYP, L.VNO"                                  
	ELSE IF UPPER(@SORTBY) = 'VTYPE'                     
		SELECT @@SORTBY = " ORDER BY L.VTYP, L.VDT, L.VNO"                                  
	ELSE IF UPPER(@SORTBY) = 'ACCODE'                              
		SELECT @@SORTBY = " ORDER BY L.CLTCODE, L.VDT, L.VTYP, L.VNO"                                  
	ELSE IF UPPER(@SORTBY) = 'ACNAME'                                  
		SELECT @@SORTBY = " ORDER BY L.ACNAME, L.VDT, L.VTYP, L.VNO"                                  
	ELSE IF UPPER(@SORTBY) = 'BOOKTYPE'                                  
		SELECT @@SORTBY = " ORDER BY L.BOOKTYPE, L.VDT, L.VTYP, L.VNO"                                  
	ELSE IF UPPER(@SORTBY) = 'VNO'                                  
		SELECT @@SORTBY = " ORDER BY L.VNO, L.VDT, L.VTYP"                                  
	ELSE IF UPPER(@SORTBY) = 'DRCR'                                  
		SELECT @@SORTBY = " ORDER BY L.DRCR, L.VDT, L.VTYP, L.VNO"                                  
	ELSE IF UPPER(@SORTBY) = 'AMOUNT'                                  
		SELECT @@SORTBY = " ORDER BY L.VAMT, L.VDT, L.VTYP, L.VNO"                                  
                                  
                                  
                                  
   IF RTRIM(@BRANCH) = '' OR RTRIM(@BRANCH) = '%'                                   
      BEGIN         
        
		print 'vin111'                                 
        SELECT @@SELECTQURY = "SELECT L.BOOKTYPE, L.VTYP, L.VNO, VDT=CONVERT(VARCHAR,VDT,103), EDT = CONVERT(VARCHAR,L.EDT,103), l.CLTCODE,ACNAME=ISNULL(ACNAME,''), VOUDT=L.VDT, EFFDT=L.EDT, DEBIT = (CASE WHEN UPPER(L.DRCR) = 'D' THEN  VAMT  ELSE  0 END),CREDIT = (CASE WHEN UPPER(L.DRCR) = 'C' THEN  VAMT   ELSE  0 END), NARRATION = REPLACE(REPLACE(L.NARRATION,'''',''),'""','') , L.DRCR"             
        SELECT @@FROMTABLES = " FROM (SELECT DISTINCT VTYP, VNO, BOOKTYPE FROM Sledger_Vw_Final (NOLOCK) WHERE CLTCODE = '" + @FCODE + "' AND " + @@DATEFILTER1 + " AND VTYP <> 18) T, Sledger_Vw_Final L "            
        SELECT @@WHEREPART = @@DATEFILTER + " AND L.VTYP <> 18 AND L.CLTCODE >= '" + @FCODE + "' AND L.CLTCODE <= '" + @TCODE + "'  AND L.VTYP = T.VTYP AND L.VNO = T.VNO AND L.BOOKTYPE = T.BOOKTYPE "SELECT @@GROUPBY = " " END  --ELSE                      
  
    
      
            
 ELSE IF UPPER(@STATUSID) = 'REGION'                              
      BEGIN                                  
                             
PRINT UPPER(@STATUSNAME)         
print 'vin222'                             
        SELECT @@SELECTQURY = "SELECT L.BOOKTYPE, L.VTYP, L.VNO, VDT=CONVERT(VARCHAR,VDT,103), EDT = CONVERT(VARCHAR,L.EDT,103), L.CLTCODE, ACNAME=ISNULL(L.ACNAME,''), VOUDT=L.VDT, EFFDT=L.EDT, DEBIT = (CASE WHEN UPPER(L2.DRCR) = 'D' THEN  CAMT  ELSE  0 E
  
    
      
ND),CREDIT = (CASE WHEN UPPER(L2.DRCR) = 'C' THEN  CAMT   ELSE  0 END), NARRATION = REPLACE(REPLACE(L.NARRATION,'''',''),'""','') , L.DRCR"                                  
        SELECT @@FROMTABLES = " FROM Sledger_Vw_Final L  (NOLOCK) ,VMAST V (NOLOCK) , LEDGER2 L2  (NOLOCK) LEFT OUTER JOIN sacmast_view A  (NOLOCK) ON L2.CLTCODE = A.CLTCODE, COSTMAST C (NOLOCK), (SELECT BRANCH_CODE FROM BSEDB_AB.DBO.REGION WHERE UPPER(RE
GIONCODE)   
    
= '" +      
 @STATUSNAME + "') R "                                  
        SELECT @@WHEREPART = @@DATEFILTER + " AND L2.VTYPE <> 18 AND L2.CLTCODE >= '" + @FCODE + "' AND L2.CLTCODE <= '" + @TCODE + "' AND L.VTYP = V.VTYPE AND A.CLTCODE = L2.CLTCODE /* AND A.ACCAT <> '4' */ AND L.VTYP = L2.VTYPE AND L.BOOKTYPE = L2.BOOKTYPE AN
  
    
      
D L.VNO = L2.VNO AND L.LNO = L2.LNO AND UPPER(COSTNAME) = UPPER(R.BRANCH_CODE) AND L2.COSTCODE = C.COSTCODE "                                  
        SELECT @@GROUPBY = " "                                   
        SELECT @@SORTBY = " ORDER BY L2.CLTCODE, VOUDT, L.VTYP DESC, L.VNO"                                    
  PRINT @@SELECTQURY+@@FROMTABLES+@@WHEREPART+@@GROUPBY                                         
      END                                
ELSE                        
      BEGIN                        
                       
        
print 'vin333'        
PRINT @@SELECTQURY                   
         SELECT @@SELECTQURY = "SELECT L.BOOKTYPE, L.VTYP, L.VNO, VDT=CONVERT(VARCHAR,VDT,103), EDT = CONVERT(VARCHAR,L.EDT,103), CLTCODE=L2.CLTCODE, ACNAME=ISNULL(L.ACNAME,''),VOUDT=L.VDT, EFFDT=L.EDT, DEBIT = (CASE WHEN UPPER(L2.DRCR) = 'D' THEN  CAMT  
  
   
E      
LSE  0 END), CREDIT = (CASE WHEN UPPER(L2.DRCR) = 'C' THEN  CAMT   ELSE  0 END),NARRATION = REPLACE(REPLACE(L.NARRATION,'''',''),'""','') , L2.DRCR"                                  
  SELECT @@FROMTABLES = " FROM (SELECT DISTINCT VTYP, VNO, BOOKTYPE, LNO FROM Sledger_Vw_Final (NOLOCK)  WHERE CLTCODE = '" + @FCODE + "'  AND " + @@DATEFILTER1 + " AND VTYP <> 18) T, LEDGER2 L2, COSTMAST C, Sledger_Vw_Final L "               
        SELECT @@WHEREPART = @@DATEFILTER + " AND L.VTYP <> 18 AND L.CLTCODE = '" + @FCODE + "' AND L2.CLTCODE >= '" + @FCODE + "' AND L2.CLTCODE <= '" + @TCODE + "'  AND L.VTYP = T.VTYP AND L.VNO = T.VNO AND L.BOOKTYPE = T.BOOKTYPE AND L.LNO = T.LNO AND 
  
    
      
L2.VTYPE = L.VTYP AND L2.VNO = L.VNO AND L2.BOOKTYPE= L.BOOKTYPE AND L2.LNO = L.LNO AND COSTNAME = RTRIM('" + @BRANCH + "') AND L2.COSTCODE = C.COSTCODE "             
SELECT @@GROUPBY = " "          
PRINT @@SELECTQURY + @@FROMTABLES+ @@WHEREPART+@@GROUPBY                             
      END                                  
END                                  
                                  
IF @REPORTNAME = 'BANK BOOK'                                   
BEGIN                                  
   IF UPPER(@SORTBY) = 'VDT'                                  
         SELECT @@SORTBY = " ORDER BY VOUDT, L.VTYP, L.VNO"                                  
   ELSE IF UPPER(@SORTBY) = 'EDT'                                  
         SELECT @@SORTBY = " ORDER BY EFFDT, L.VTYP, L.VNO"                                  
    ELSE IF UPPER(@SORTBY) = 'VTYPE'                                  
          SELECT @@SORTBY = " ORDER BY L.VTYP, L.VDT, L.VNO"                                  
  ELSE IF UPPER(@SORTBY) = 'ACCODE'                                  
       SELECT @@SORTBY = " ORDER BY L.CLTCODE, L.VDT, L.VTYP, L.VNO"                                  
   ELSE IF UPPER(@SORTBY) = 'ACNAME'                                  
        SELECT @@SORTBY = " ORDER BY L.ACNAME, L.VDT, L.VTYP, L.VNO"                                  
      ELSE IF UPPER(@SORTBY) = 'BOOKTYPE'                              
            SELECT @@SORTBY = " ORDER BY L.BOOKTYPE, L.VDT, L.VTYP, L.VNO"                                  
       ELSE IF UPPER(@SORTBY) = 'VNO'                                  
             SELECT @@SORTBY = " ORDER BY L.VNO, L.VDT, L.VTYP"                                  
        ELSE IF UPPER(@SORTBY) = 'DRCR'                                  
              SELECT @@SORTBY = " ORDER BY L.DRCR, L.VDT, L.VTYP, L.VNO"                                  
         ELSE IF UPPER(@SORTBY) = 'AMOUNT'                                  
               SELECT @@SORTBY = " ORDER BY L.VAMT, L.VDT, L.VTYP, L.VNO"                                  
                                  
   IF RTRIM(@BRANCH) = '' OR RTRIM(@BRANCH) = '%'                                   
      BEGIN                                  
         SELECT @@SELECTQURY = "SELECT L.BOOKTYPE, VDT = CONVERT(VARCHAR,L.VDT,103), EFFDT = L.EDT, EDT = CONVERT(VARCHAR,L.EDT,103), CLTCODE, ACNAME, L.VNO, L.VTYP, VOUDT=L.VDT, DDNO= ISNULL((SELECT MAX(DDNO) FROM LEDGER1 L1 WHERE L1.VNO=L.VNO AND L1.VTY
  
    
      
P=L.VTYP AND L1.BOOKTYPE=L.BOOKTYPE AND L1.LNO = L.LNO),''), DEBIT = (CASE WHEN UPPER(L.DRCR) = 'C' THEN  VAMT  ELSE  0 END), CREDIT = (CASE WHEN UPPER(L.DRCR) ='D' THEN  VAMT   ELSE  0 END),NARRATION = REPLACE(REPLACE(L.NARRATION,'''',''),'""','')  "    
  
    
      
        
          
            
        SELECT @@FROMTABLES = " FROM (SELECT DISTINCT VTYP, VNO, BOOKTYPE FROM Sledger_Vw_Final (NOLOCK)  WHERE CLTCODE = '" + @FCODE + "'  AND " + @@DATEFILTER1 + " AND VTYP <> 18) T, Sledger_Vw_Final L "                                  
         SELECT @@WHEREPART = @@DATEFILTER + " AND L.VTYP <> 18 AND L.CLTCODE <> '" + @FCODE + "' AND L.VTYP = T.VTYP AND L.VNO = T.VNO AND L.BOOKTYPE = T.BOOKTYPE "                             
         SELECT @@GROUPBY = " "                                  
      END                                  
   ELSE                                  
      BEGIN                                  
/*         SELECT @@SELECTQURY = "SELECT L.BOOKTYPE, VDT = CONVERT(VARCHAR,L.VDT,103), EFFDT = L.EDT, EDT = CONVERT(VARCHAR,L.EDT,103), L2.CLTCODE, ACNAME, L.VNO, L.VTYP, VOUDT=L.VDT, DDNO= ISNULL((SELECT DDNO FROM LEDGER1 L1 WHERE L1.VNO=L.VNO AND L1.VT 
 
    
Y      
        
                             
P=L.VTYP AND L1.BOOKTYPE=L.BOOKTYPE AND L1.LNO = L.LNO),''), DEBIT = (CASE WHEN UPPER(L2.DRCR) = 'C' THEN  CAMT  ELSE  0 END), CREDIT = (CASE WHEN UPPER(L2.DRCR) ='D' THEN  CAMT   ELSE  0 END), L.NARRATION "                                  
         SELECT @@FROMTABLES = " FROM (SELECT DISTINCT VTYP, VNO, BOOKTYPE FROM Sledger_Vw_Final WHERE CLTCODE = '" + @FCODE + "') T, LEDGER2 L2, COSTMAST C, Sledger_Vw_Final L " */                                  
/*         SELECT @@WHEREPART = @@DATEFILTER + " AND L.VTYP <> 18 AND L.CLTCODE <> '" + @FCODE + "' AND L.VTYP = T.VTYP AND L.VNO = T.VNO AND L.BOOKTYPE = T.BOOKTYPE AND L2.VTYPE = L.VTYP AND L2.VNO = L.VNO AND L2.LNO = L.LNO AND L2.BOOKTYPE = L.BOOKTYPE 
  
    
      
       
           
            
                                
AND RTRIM(COSTNAME) = RTRIM('" + @BRANCH + "') AND L2.COSTCODE = C.COSTCODE AND L2.CLTCODE NOT IN ( SELECT BRCONTROLAC FROM BRANCHACCOUNTS ) " */                                  
/*         SELECT @@WHEREPART = @@DATEFILTER + " AND L.VTYP <> 18 AND L.CLTCODE <> '" + @FCODE + "' AND L.VTYP = T.VTYP AND L.VNO = T.VNO AND L.BOOKTYPE = T.BOOKTYPE AND L2.VTYPE = L.VTYP AND L2.VNO = L.VNO AND L2.LNO = L.LNO AND L2.BOOKTYPE = L.BOOKTYPE 
  
    
      
        
          
                
                                  
AND RTRIM(COSTNAME) = RTRIM('" + @BRANCH + "') AND L2.COSTCODE = C.COSTCODE AND L2.CLTCODE =L.CLTCODE "                                   
         SELECT @@GROUPBY = " " */                                  
         SELECT @@SELECTQURY = "SELECT L.BOOKTYPE, VDT = CONVERT(VARCHAR,L.VDT,103), EFFDT = L.EDT, EDT = CONVERT(VARCHAR,L.EDT,103), L2.CLTCODE, ACNAME, L.VNO, L.VTYP, VOUDT=L.VDT, DDNO= ISNULL((SELECT MAX(DDNO) FROM LEDGER1 L1 WHERE L1.VNO=L.VNO AND L1.
  
    
      
VTYP=L.VTYP AND L1.BOOKTYPE=L.BOOKTYPE AND L1.LNO = L.LNO),''), DEBIT = (CASE WHEN UPPER(L2.DRCR) = 'C' THEN  CAMT  ELSE  0 END), CREDIT = (CASE WHEN UPPER(L2.DRCR) ='D' THEN  CAMT   ELSE  0 END), NARRATION = REPLACE(REPLACE(L.NARRATION,'''',''),'""','')"
  
    
      
        
          
            
            
        SELECT @@FROMTABLES = " FROM (SELECT DISTINCT VTYPE, VNO, BOOKTYPE FROM LEDGER2 (NOLOCK)  WHERE CLTCODE = '" + @FCODE + "' ) T, LEDGER2 L2 (NOLOCK) , COSTMAST C (NOLOCK) , Sledger_Vw_Final L  (NOLOCK) "                 
/*         SELECT @@WHEREPART = @@DATEFILTER + " AND L.VTYP <> 18 AND L.CLTCODE <> '" + @FCODE + "' AND L.VTYP = T.VTYP AND L.VNO = T.VNO AND L.BOOKTYPE = T.BOOKTYPE AND L2.VTYPE = L.VTYP AND L2.VNO = L.VNO AND L2.LNO = L.LNO AND L2.BOOKTYPE = L.BOOKTYPE 
  
    
      
        
          
            
                                   
AND RTRIM(COSTNAME) = RTRIM('" + @BRANCH + "') AND L2.COSTCODE = C.COSTCODE AND L2.CLTCODE NOT IN ( SELECT BRCONTROLAC FROM BRANCHACCOUNTS ) " */                                  
         SELECT @@WHEREPART = @@DATEFILTER + " AND L.VTYP <> 18 AND L2.CLTCODE<> 'HOCTRL' AND L2.CLTCODE <> '" + @FCODE + "' AND L.VTYP = T.VTYPE AND L.VNO = T.VNO AND L.BOOKTYPE = T.BOOKTYPE AND L2.VTYPE = L.VTYP AND L2.VNO = L.VNO AND L2.LNO = L.LNO AND
  
    
      
 L2.BOOKTYPE = L.BOOKTYPE AND RTRIM(COSTNAME) = RTRIM('" + @BRANCH + "') AND L2.COSTCODE = C.COSTCODE " SELECT @@GROUPBY = " "  END                
END                                  
    
IF @REPORTNAME = 'GL'                                   
BEGIN                                  
                                  
/* ASSIGN FROM AND TO ACCOUNT CODES. */                                  
   IF @FCODE = ""                                   
      BEGIN                                  
         SELECT @FCODE = (SELECT MIN(CLTCODE) FROM sacmast_view /* WHERE ACCAT <> 4 */)                                  
END                                               
   IF @TCODE = ""                                   
      BEGIN                                  
         SELECT @TCODE = (SELECT MAX(CLTCODE) FROM sacmast_view /* WHERE ACCAT <> 4 */)                                  
END                
                                  
   IF RTRIM(@BRANCH) = '' OR RTRIM(@BRANCH) = '%'                                   
      BEGIN                                  
        SELECT @@SELECTQURY = "SELECT L.BOOKTYPE, VOUDT=L.VDT, EFFDT=L.EDT, ISNULL(SHORTDESC,'') SHORTDESC, DRAMT=(CASE WHEN UPPER(L.DRCR) = 'D' THEN VAMT ELSE 0 END),  CRAMT=(CASE WHEN UPPER(L.DRCR) = 'C' THEN VAMT ELSE 0 END), L.VNO, NARRATION = REPLACE
  
    
      
(REPLACE(L.NARRATION,'''',''),'""','') , DDNO=ISNULL((SELECT MAX(DDNO) FROM LEDGER1 WHERE VTYP = L.VTYP AND VNO = L.VNO AND BOOKTYPE = L.BOOKTYPE AND LNO = L.LNO),''), L.CLTCODE , A.LONGNAME,VDT, L.VTYP, L.BOOKTYPE, VDT = CONVERT(VARCHAR,L.VDT,103), EDT =
  
    
      
 CONVERT(VARCHAR,L.EDT,103), ACCAT "                                  
SELECT @@FROMTABLES = " FROM Sledger_Vw_Final L  (NOLOCK) LEFT OUTER JOIN sacmast_view A  (NOLOCK) ON L.CLTCODE = A.CLTCODE ,VMAST V  (NOLOCK) "                
SELECT @@WHEREPART = @@DATEFILTER + " AND L.VTYP <> 18 AND L.CLTCODE >= '" + @FCODE + "' AND L.CLTCODE <= '" + @TCODE + "' AND VTYP = VTYPE AND A.CLTCODE = L.CLTCODE /* AND A.ACCAT <> '4' */ "                                  
SELECT @@GROUPBY = " "                                  
SELECT @@SORTBY = " ORDER BY L.CLTCODE, VOUDT, L.VTYP DESC, L.VNO"                                    
      END                                
 ELSE IF UPPER(@STATUSID) = 'REGION'                              
      BEGIN                                  
PRINT 'VIN'                   
PRINT UPPER(@STATUSNAME)                              
        SELECT @@SELECTQURY = "SELECT L.BOOKTYPE, VOUDT=L.VDT, EFFDT=L.EDT, ISNULL(SHORTDESC,'') SHORTDESC, DRAMT=(CASE WHEN UPPER(L2.DRCR) = 'D' THEN CAMT ELSE 0 END),  CRAMT=(CASE WHEN UPPER(L2.DRCR) = 'C' THEN CAMT ELSE 0 END), L.VNO,NARRATION = REPLAC
  
    
      
E(REPLACE(L.NARRATION,'''',''),'""','') , DDNO=ISNULL((SELECT MAX(DDNO) FROM LEDGER1 WHERE VTYP = L.VTYP AND VNO = L.VNO AND BOOKTYPE = L.BOOKTYPE AND LNO = L.LNO),''), L2.CLTCODE , A.LONGNAME,VDT, L.VTYP, L.BOOKTYPE, VDT = CONVERT(VARCHAR,L.VDT,103), EDT
  
    
      
 = CONVERT(VARCHAR,L.EDT,103), ACCAT "                                  
SELECT @@FROMTABLES = " FROM Sledger_Vw_Final L  (NOLOCK) ,VMAST V (NOLOCK) , LEDGER2 L2  (NOLOCK) LEFT OUTER JOIN sacmast_view A  (NOLOCK) ON L2.CLTCODE = A.CLTCODE, COSTMAST C (NOLOCK), (SELECT BRANCH_CODE FROM BSEDB_AB.DBO.REGION WHERE UPPER(REGIONCODE
) = '" +    
    
     
@STATUSNAME + "') R   "                
SELECT @@WHEREPART = @@DATEFILTER + " AND L2.VTYPE <> 18 AND L2.CLTCODE >= '" + @FCODE + "' AND L2.CLTCODE <= '" + @TCODE + "' AND L.VTYP = V.VTYPE AND A.CLTCODE = L2.CLTCODE /* AND  A.ACCAT <> '4' */ AND L.VTYP = L2.VTYPE AND L.BOOKTYPE = L2.BOOKTYPE AND L.VNO 
  
    
      
= L2.VNO AND L.LNO = L2.LNO AND UPPER(COSTNAME) = UPPER(R.BRANCH_CODE) AND L2.COSTCODE = C.COSTCODE "                              
        
SELECT @@GROUPBY = " "            
                
        SELECT @@SORTBY = " ORDER BY L2.CLTCODE, VOUDT, L.VTYP DESC, L.VNO"                                    
  PRINT @@SELECTQURY+@@FROMTABLES+@@WHEREPART+@@GROUPBY                                         
      END                                
   ELSE                                  
      BEGIN                                  
                                  
        SELECT @@SELECTQURY = "SELECT L.BOOKTYPE, VOUDT=L.VDT, EFFDT=L.EDT, ISNULL(SHORTDESC,'') SHORTDESC, DRAMT=(CASE WHEN UPPER(L2.DRCR) = 'D' THEN CAMT ELSE 0 END),  CRAMT=(CASE WHEN UPPER(L2.DRCR) = 'C' THEN CAMT ELSE 0 END), L.VNO,NARRATION = REPLAC
  
    
      
E(REPLACE(L.NARRATION,'''',''),'""','') , DDNO=ISNULL((SELECT MAX(DDNO) FROM LEDGER1 WHERE VTYP = L.VTYP AND VNO = L.VNO AND BOOKTYPE = L.BOOKTYPE AND LNO = L.LNO),''), L2.CLTCODE , A.LONGNAME,VDT, L.VTYP, L.BOOKTYPE, VDT = CONVERT(VARCHAR,L.VDT,103), EDT
  
    
      
= CONVERT(VARCHAR,L.EDT,103), ACCAT "                                  
        SELECT @@FROMTABLES = " FROM Sledger_Vw_Final L  (NOLOCK) ,VMAST V (NOLOCK) , LEDGER2 L2  (NOLOCK) LEFT OUTER JOIN sacmast_view A  (NOLOCK) ON L2.CLTCODE = A.CLTCODE, COSTMAST C (NOLOCK)   "                                  
        SELECT @@WHEREPART = @@DATEFILTER + " AND L2.VTYPE <> 18 AND L2.CLTCODE >= '" + @FCODE + "' AND L2.CLTCODE <= '" + @TCODE + "' AND L.VTYP = V.VTYPE AND A.CLTCODE = L2.CLTCODE /* AND A.ACCAT <> '4' */ AND L.VTYP = L2.VTYPE AND L.BOOKTYPE = L2.BOOKTYPE AN
  
    
      
D L.VNO = L2.VNO AND L.LNO = L2.LNO AND COSTNAME = RTRIM('" + @BRANCH + "') AND L2.COSTCODE = C.COSTCODE "                      SELECT @@GROUPBY = " "                          SELECT @@SORTBY = " ORDER BY L2.CLTCODE, VOUDT, L.VTYP DESC, L.VNO"            
  
    
      
        
        
          
            
          PRINT @@SELECTQURY+@@FROMTABLES+@@WHEREPART+@@GROUPBY                                         
      END                                  
END                                  
                                  
IF @REPORTNAME = 'PARTYLEDGER'                                  
BEGIN                                  
                                  
 SELECT @@SORTBY = " VOUDT, L.VTYP DESC, L.VNO"                                   
 IF UPPER(@SORTBY) = 'VDT'                                  
    SELECT @@SORTBY = " VOUDT, L.VTYP DESC, L.VNO"                   
   ELSE IF UPPER(@SORTBY) = 'EDT'                                  
           SELECT @@SORTBY = " EFFDT, L.VTYP DESC, L.VNO"                                   
                                  
 IF RTRIM(@BRANCH) = '' OR RTRIM(@BRANCH) = '%'                                   
 SELECT @@SORTBY = " L.CLTCODE," + @@SORTBY                                  
 ELSE                                  
 SELECT @@SORTBY = " L2.CLTCODE," + @@SORTBY                                  
                                  
 IF UPPER(RTRIM(@GROUPBY)) = 'FAMILY'                                  
    SELECT @@SORTBY = " ORDER BY CM.FAMILY, " + @@SORTBY                                  
 ELSE IF UPPER(RTRIM(@GROUPBY)) = 'SUBBROKER'                                  
       SELECT @@SORTBY = " ORDER BY C1.SUB_BROKER, " + @@SORTBY                                  
                                  
 IF LEFT(@@SORTBY,6) <> ' ORDER'                                   
    SELECT @@SORTBY = " ORDER BY " + @@SORTBY                                  
                                        
   IF UPPER(RTRIM(@GROUPBY)) = 'FAMILY'                                  
   BEGIN                                  
      IF RTRIM(@BRANCH) = '' OR RTRIM(@BRANCH) = '%'                                   
         BEGIN                                  
            SELECT @@SELECTQURY = "SELECT L.BOOKTYPE, VOUDT=L.VDT, EFFDT=L.EDT, ISNULL(SHORTDESC,'') SHORTDESC, DRAMT=(CASE WHEN UPPER(L.DRCR) = 'D' THEN VAMT ELSE 0 END),  CRAMT=(CASE WHEN UPPER(L.DRCR) = 'C' THEN VAMT ELSE 0 END), L.VNO,DDNO= ISNULL((SE
  
    
      
LECT MAX(DDNO) FROM LEDGER1 L1 WHERE L1.VNO=L.VNO AND L1.VTYP=L.VTYP AND L1.BOOKTYPE=L.BOOKTYPE AND L1.LNO = L.LNO),''), NARRATION = REPLACE(REPLACE(L.NARRATION,'''',''),'""','') , L.CLTCODE, A.LONGNAME, VTYP, L.BOOKTYPE, CONVERT(VARCHAR,L.VDT,103) VDT, C
  
    
      
ONVERT(VARCHAR,L.EDT,103) EDT, L.ACNAME, EDIFF=DATEDIFF(D,L.EDT,GETDATE()) "                               SELECT @@FROMTABLES = " FROM Sledger_Vw_Final L (NOLOCK)  LEFT OUTER JOIN sacmast_view A  (NOLOCK) ON L.CLTCODE = A.CLTCODE , VMAST, MSAJAG.DBO.CLIE
NTMASTER C  
    
M "         
       
           
            
            SELECT @@WHEREPART = @@DATEFILTER + " AND L.VTYP <> 18 AND L.CLTCODE = A.CLTCODE AND ACCAT = '4' AND L.CLTCODE >= '" + @FCODE + "' AND L.CLTCODE <= '" + @TCODE + "' AND L.VTYP = VTYPE AND L.CLTCODE = CM.PARTY_CODE"                             
  
    
     
            SELECT @@GROUPBY = " "                                  
         END                                  
      ELSE                                  
         BEGIN                                  
                                  
            SELECT @@SELECTQURY = "SELECT L.BOOKTYPE, VOUDT=L.VDT, EFFDT=L.EDT, ISNULL(SHORTDESC,'') SHORTDESC, DRAMT=(CASE WHEN UPPER(L.DRCR) = 'D' THEN VAMT ELSE 0 END),  CRAMT=(CASE WHEN UPPER(L.DRCR) = 'C' THEN VAMT ELSE 0 END), L.VNO,DDNO= ISNULL((SE
  
    
      
LECT MAX(DDNO) FROM LEDGER1 L1 WHERE L1.VNO=L.VNO AND L1.VTYP=L.VTYP AND L1.BOOKTYPE=L.BOOKTYPE AND L1.LNO = L.LNO),''),NARRATION = REPLACE(REPLACE(L.NARRATION,'''',''),'""','') , L.CLTCODE, A.LONGNAME, VTYP, L.BOOKTYPE, CONVERT(VARCHAR,L.VDT,103) VDT, CO
  
    
      
NVERT(VARCHAR,L.EDT,103) EDT, L.ACNAME, EDIFF=DATEDIFF(D,L.EDT,GETDATE()) "                            SELECT @@FROMTABLES = " FROM Sledger_Vw_Final L  (NOLOCK) ,VMAST V (NOLOCK) , LEDGER2 L2 (NOLOCK)  LEFT OUTER JOIN sacmast_view A ON L2.CLTCODE = A.CLTC
ODE, COSTM  
    
AST C       
(NOLOCK) , MSAJAG.DBO.CLIENTMASTER CM   (NOLOCK)  "                                    
            SELECT @@WHEREPART = @@DATEFILTER + " AND L.VTYP <> 18 AND L2.CLTCODE >= '" + @FCODE + "' AND L2.CLTCODE <= '" + @TCODE + "' AND L.VTYP = V.VTYPE AND A.CLTCODE = L2.CLTCODE AND A.ACCAT = '4' AND L.VTYP = L2.VTYPE AND L.BOOKTYPE = L2.BOOKTYPE A
  
    
      
ND L.VNO = L2.VNO AND L.LNO = L2.LNO  AND COSTNAME = RTRIM('" + @BRANCH + "') AND L2.COSTCODE = C.COSTCODE AND L2.CLTCODE = CM.PARTY_CODE "                                         
          SELECT @@GROUPBY = " "                                   
                                  
         END                                    
   END                                  
   ELSE IF UPPER(RTRIM(@GROUPBY)) = 'SUBBROKER'                                  
   BEGIN                                  
      IF RTRIM(@BRANCH) = '' OR RTRIM(@BRANCH) = '%'                                   
      BEGIN                                  
            SELECT @@SELECTQURY = "SELECT L.BOOKTYPE, VOUDT=L.VDT, EFFDT=L.EDT, ISNULL(SHORTDESC,'') SHORTDESC, DRAMT=(CASE WHEN UPPER(L.DRCR) = 'D' THEN VAMT ELSE 0 END),  CRAMT=(CASE WHEN UPPER(L.DRCR) = 'C' THEN VAMT ELSE 0 END), L.VNO,DDNO= ISNULL((SE
  
    
      
LECT MAX(DDNO) FROM LEDGER1 L1 WHERE L1.VNO=L.VNO AND L1.VTYP=L.VTYP AND L1.BOOKTYPE=L.BOOKTYPE AND L1.LNO = L.LNO),''),NARRATION = REPLACE(REPLACE(L.NARRATION,'''',''),'""','') , L.CLTCODE, A.LONGNAME, VTYP, L.BOOKTYPE, CONVERT(VARCHAR,L.VDT,103) VDT, CO
  
    
      
NVERT(VARCHAR,L.EDT,103) EDT, L.ACNAME, EDIFF=DATEDIFF(D,L.EDT,GETDATE()) "                              SELECT @@FROMTABLES = " FROM Sledger_Vw_Final L  (NOLOCK) LEFT OUTER JOIN sacmast_view A  (NOLOCK) ON L.CLTCODE = A.CLTCODE , VMAST, " + RTRIM(@FLD1) 
+ ".DBO.CL  
    
IENT1       
C1 (NOLOCK) , " + RTRIM(@FLD1) + ".DBO.CLIENT2 C2  (NOLOCK) "                                  
           SELECT @@WHEREPART = @@DATEFILTER + " AND L.VTYP <> 18 AND L.CLTCODE = A.CLTCODE AND ACCAT = '4' AND L.CLTCODE >= '" + @FCODE + "' AND L.CLTCODE <= '" + @TCODE + "' AND L.VTYP = VTYPE AND L.CLTCODE = C2.PARTY_CODE AND C2.CL_CODE = C1.CL_CODE " 
  
    
      
        
          
           
             SELECT @@GROUPBY = " "                                  
         END                                  
      ELSE                                  
         BEGIN                                  
            SELECT @@SELECTQURY = "SELECT L.BOOKTYPE, VOUDT=L.VDT, EFFDT=L.EDT, ISNULL(SHORTDESC,'') SHORTDESC, DRAMT=(CASE WHEN UPPER(L.DRCR) = 'D' THEN VAMT ELSE 0 END),  CRAMT=(CASE WHEN UPPER(L.DRCR) = 'C' THEN VAMT ELSE 0 END), L.VNO,DDNO= ISNULL((SE
  
    
      
LECT MAX(DDNO) FROM LEDGER1 L1 WHERE L1.VNO=L.VNO AND L1.VTYP=L.VTYP AND L1.BOOKTYPE=L.BOOKTYPE AND L1.LNO = L.LNO),''),NARRATION = REPLACE(REPLACE(L.NARRATION,'''',''),'""','') , L.CLTCODE, A.LONGNAME, VTYP, L.BOOKTYPE, CONVERT(VARCHAR,L.VDT,103) VDT, CO
  
    
      
NVERT(VARCHAR,L.EDT,103) EDT, L.ACNAME, EDIFF=DATEDIFF(D,L.EDT,GETDATE()) "                    SELECT @@FROMTABLES = " FROM Sledger_Vw_Final L  (NOLOCK) ,VMAST V (NOLOCK) , LEDGER2 L2 (NOLOCK)  LEFT OUTER JOIN sacmast_view A ON L2.CLTCODE = A.CLTCODE, COS
TMAST C (N  
    
OLOCK)      
 ,  " + RTRIM(@FLD1) + ".DBO.CLIENT1 C1 (NOLOCK) , " + RTRIM(@FLD1) + ".DBO.CLIENT2 C2  (NOLOCK) "                    SELECT @@WHEREPART = @@DATEFILTER + " AND L.VTYP <> 18 AND L2.CLTCODE >= '" + @FCODE + "' AND L2.CLTCODE <= '" + @TCODE + "' AND L.VTYP =
  
    
      
 V.VTYPE AND A.CLTCODE = L2.CLTCODE AND A.ACCAT = '4' AND L.VTYP = L2.VTYPE AND L.BOOKTYPE = L2.BOOKTYPE AND L.VNO = L2.VNO AND L.LNO = L2.LNO  AND COSTNAME = RTRIM('" + @BRANCH + "') AND L2.COSTCODE = C.COSTCODE AND L2.CLTCODE = C2.PARTY_CODE AND C2.CL_C
  
    
      
ODE = C1.CL_CODE "                                  
           SELECT @@GROUPBY = " "                                  
         END                                    
   END                                  
   ELSE                                  
   BEGIN                                  
   IF UPPER(@STATUSID) = 'BROKER' OR UPPER(@STATUSID) = 'BRANCH'                                   
   BEGIN                                  
      IF RTRIM(@BRANCH) = '' OR RTRIM(@BRANCH) = '%'                                   
         BEGIN                                  
         SELECT @@SELECTQURY = "SELECT L.BOOKTYPE, VOUDT=L.VDT, EFFDT=L.EDT, ISNULL(SHORTDESC,'') SHORTDESC, DRAMT=(CASE WHEN UPPER(L.DRCR) = 'D' THEN VAMT ELSE 0 END),  CRAMT=(CASE WHEN UPPER(L.DRCR) = 'C' THEN VAMT ELSE 0 END), L.VNO,DDNO= ISNULL((SELEC
  
    
      
T MAX(DDNO) FROM LEDGER1 L1 WHERE L1.VNO=L.VNO AND L1.VTYP=L.VTYP AND L1.BOOKTYPE=L.BOOKTYPE AND L1.LNO = L.LNO),''),NARRATION = REPLACE(REPLACE(L.NARRATION,'''',''),'""','') , L.CLTCODE, A.LONGNAME, VTYP, L.BOOKTYPE, CONVERT(VARCHAR,L.VDT,103) VDT, CONVE
  
    
      
RT(VARCHAR,L.EDT,103) EDT, L.ACNAME, EDIFF=DATEDIFF(D,L.EDT,GETDATE()) "                            SELECT @@FROMTABLES = " FROM Sledger_Vw_Final L  (NOLOCK) LEFT OUTER JOIN sacmast_view A  (NOLOCK) ON L.CLTCODE = A.CLTCODE , VMAST  (NOLOCK) "            
            
    
            
          
            
  SELECT @@WHEREPART = @@DATEFILTER + " AND L.VTYP <> 18 AND L.CLTCODE = A.CLTCODE AND ACCAT = '4' AND L.CLTCODE >= '" + @FCODE + "' AND L.CLTCODE <= '" + @TCODE + "' AND L.VTYP = VTYPE "                                  
            SELECT @@GROUPBY = " "                                  
         END                                  
      ELSE                                  
         BEGIN                                  
                                  
           SELECT @@SELECTQURY = "SELECT L.BOOKTYPE, VOUDT=L.VDT, EFFDT=L.EDT, ISNULL(SHORTDESC,'') SHORTDESC, DRAMT=(CASE WHEN UPPER(L.DRCR) = 'D' THEN VAMT ELSE 0 END),  CRAMT=(CASE WHEN UPPER(L.DRCR) = 'C' THEN VAMT ELSE 0 END), L.VNO,DDNO= ISNULL((SEL
  
    
      
ECT MAX(DDNO) FROM LEDGER1 L1 WHERE L1.VNO=L.VNO AND L1.VTYP=L.VTYP AND L1.BOOKTYPE=L.BOOKTYPE AND L1.LNO = L.LNO),''),NARRATION = REPLACE(REPLACE(L.NARRATION,'''',''),'""','') , L.CLTCODE, A.LONGNAME, VTYP, L.BOOKTYPE, CONVERT(VARCHAR,L.VDT,103) VDT, CON
  
    
      
VERT(VARCHAR,L.EDT,103) EDT, L.ACNAME, EDIFF=DATEDIFF(D,L.EDT,GETDATE()) "                            SELECT @@FROMTABLES = " FROM Sledger_Vw_Final L  (NOLOCK) ,VMAST V (NOLOCK) , LEDGER2 L2  (NOLOCK) LEFT OUTER JOIN sacmast_view A ON L2.CLTCODE = A.CLTCO
DE, COSTMA  
    
ST C (      
NOLOCK)   "                                  
            
            SELECT @@WHEREPART = @@DATEFILTER + " AND L.VTYP <> 18 AND L2.CLTCODE >= '" + @FCODE + "' AND L2.CLTCODE <= '" + @TCODE + "' AND L.VTYP = V.VTYPE AND A.CLTCODE = L2.CLTCODE AND A.ACCAT = '4' AND L.VTYP = L2.VTYPE AND L.BOOKTYPE = L2.BOOKTYPE A
  
    
      
ND L.VNO = L2.VNO AND L.LNO = L2.LNO  AND COSTNAME = RTRIM('" + @BRANCH + "') AND L2.COSTCODE = C.COSTCODE "                                     SELECT @@GROUPBY = " "                                  
            SELECT @@SORTBY = " ORDER BY L2.CLTCODE, VOUDT, L.VTYP DESC, L.VNO"                                  
                                  
                                 
         END                                  
   END                                  
   ELSE                                  
   IF UPPER(@STATUSID) = 'SUB_BROKER'                                  
   BEGIN                                  
      SELECT @@SELECTQURY = "SELECT L.BOOKTYPE, VOUDT=L.VDT, EFFDT=L.EDT, ISNULL(SHORTDESC,'') SHORTDESC, DRAMT=(CASE WHEN UPPER(L.DRCR) = 'D' THEN VAMT ELSE 0 END),  CRAMT=(CASE WHEN UPPER(L.DRCR) = 'C' THEN VAMT ELSE 0 END), L.VNO,DDNO= ISNULL((SELECT M
  
    
      
AX(DDNO) FROM LEDGER1 L1 WHERE L1.VNO=L.VNO AND L1.VTYP=L.VTYP AND L1.BOOKTYPE=L.BOOKTYPE AND L1.LNO = L.LNO),''), L.NARRATION, L.CLTCODE, A.LONGNAME, VTYP, L.BOOKTYPE, CONVERT(VARCHAR,L.VDT,103) VDT, CONVERT(VARCHAR,L.EDT,103) EDT, L.ACNAME, EDIFF=DATEDI
  
    
      
FF(D,L.EDT,GETDATE()) "                      SELECT @@FROMTABLES = " FROM Sledger_Vw_Final L  (NOLOCK) LEFT OUTER JOIN sacmast_view A  (NOLOCK) ON L.CLTCODE = A.CLTCODE , VMAST (NOLOCK) , MSAJAG.DBO.CLIENT1 C1 (NOLOCK) , MSAJAG.DBO.CLIENT2 C2  (NOLOCK) " 
            
    
            
        
          
            
                 
      SELECT @@WHEREPART = @@DATEFILTER + " AND L.VTYP <> 18 AND ACCAT = '4' AND L.CLTCODE >= '" + @FCODE + "' AND L.CLTCODE <= '" + @TCODE + "' AND L.CLTCODE = C2.PARTY_CODE AND C2.CL_CODE = C1.CL_CODE AND UPPER(SUB_BROKER) = UPPER(@STATUSNAME) AND L.VTY
  
    
      
P = VTYPE "              SELECT @@GROUPBY = " "                END                     ELSE                     BEGIN                        SELECT @@SELECTQURY = "SELECT L.BOOKTYPE, VOUDT=L.VDT, EFFDT=L.EDT, ISNULL(SHORTDESC,'') SHORTDESC, DRAMT=(CASE WH
  
    
      
EN UPPER(L.DRCR) = 'D' THEN VAMT ELSE 0 END),  CRAMT=(CASE WHEN UPPER(L.DRCR) = 'C' THEN VAMT ELSE 0 END), L.VNO,DDNO= ISNULL((SELECT MAX(DDNO) FROM LEDGER1 L1 WHERE L1.VNO=L.VNO AND L1.VTYP=L.VTYP AND L1.BOOKTYPE=L.BOOKTYPE AND L1.LNO = L.LNO),''), L.NAR
  
    
      
RATION, L.CLTCODE, A.LONGNAME, VTYP, L.BOOKTYPE, CONVERT(VARCHAR,L.VDT,103) VDT, CONVERT(VARCHAR,L.EDT,103) EDT, L.ACNAME, EDIFF=DATEDIFF(D,L.EDT,GETDATE()) "                               SELECT @@FROMTABLES = " FROM Sledger_Vw_Final L  (NOLOCK) LEFT OUT
ER JOIN AC  
    
      
MAST A  (NOLOCK) ON L.CLTCODE = A.CLTCODE , VMAST  (NOLOCK) "                                  
      SELECT @@WHEREPART = @@DATEFILTER + " AND L.VTYP <> 18 AND ACCAT = '4' AND L.CLTCODE >= '" + @FCODE + "' AND L.CLTCODE <= '" + @TCODE + "' AND L.VTYP = VTYPE "                                  
      SELECT @@GROUPBY = " "                     
   END                                  
   END                                  
END                                  
                                  
IF @REPORTNAME = 'MARGINLEDGER'                                  
BEGIN                                  
   IF @SELECTIONBY = 'VDT'                                  
      BEGIN                                  
         SELECT @@SORTBY = " ORDER BY L.CLTCODE, VOUDT, L.VTYP DESC, L.VNO"                                  
      END                                  
   ELSE                                  
      BEGIN                                  
         SELECT @@SORTBY = " ORDER BY L.CLTCODE, EFFDT, L.VTYP DESC, L.VNO"                                  
      END                            
   IF RTRIM(@BRANCH) = '' OR RTRIM(@BRANCH) = '%'                                   
      BEGIN                                  
         SELECT @@SELECTQURY = "SELECT M.BOOKTYPE, VOUDT=M.VDT, EFFDT=L.EDT, L.ACNAME, ISNULL(SHORTDESC,'') SHORTDESC, DRMARGIN = (CASE WHEN UPPER(M.DRCR) = 'D' THEN AMOUNT ELSE 0 END ), CRMARGIN = (CASE WHEN UPPER(M.DRCR) = 'C' THEN AMOUNT ELSE 0 END ), 
  
    
      
 M.VNO,DDNO= ISNULL((SELECT MAX(DDNO) FROM LEDGER1 L1 WHERE L1.VNO=M.VNO AND L1.VTYP=M.VTYP AND L1.BOOKTYPE=M.BOOKTYPE AND L1.LNO = M.LNO),''), L.NARRATION, M.PARTY_CODE, A.LONGNAME, M.VTYP, CONVERT(VARCHAR,L.VDT,103) VDT, CONVERT(VARCHAR,L.EDT,103) EDT "
  
    
      
            
         SELECT @@FROMTABLES = " FROM MARGINLEDGER M (NOLOCK)  LEFT OUTER JOIN Sledger_Vw_Final L  (NOLOCK) ON M.VTYP = L.VTYP AND M.BOOKTYPE = L.BOOKTYPE AND M.VNO = L.VNO AND M.LNO = L.LNO LEFT OUTER JOIN sacmast_view A  (NOLOCK) ON M.PARTY_CODE = A.CLT
CODE , VMA  
    
ST V        
(NOLOCK) "                          SELECT @@WHEREPART = @@DATEFILTER + " AND M.PARTY_CODE >= '" + @FCODE + "' AND M.PARTY_CODE <= '" + @TCODE + "' AND M.VTYP <> 18 AND ACCAT = '4' AND M.VTYP = V.VTYPE "                                  
         SELECT @@GROUPBY = " "                                  
         SELECT @@SORTBY = " ORDER BY M.PARTY_CODE, VOUDT, M.VTYP DESC, M.VNO"                                  
      END                                  
   ELSE                                  
      BEGIN                                  
                                  
         SELECT @@SELECTQURY = "SELECT M.BOOKTYPE, VOUDT=M.VDT, EFFDT=L.EDT, L.ACNAME, ISNULL(SHORTDESC,'') SHORTDESC, DRMARGIN = (CASE WHEN UPPER(M.DRCR) = 'D' THEN AMOUNT ELSE 0 END ), CRMARGIN = (CASE WHEN UPPER(M.DRCR) = 'C' THEN AMOUNT ELSE 0 END ), 
  
    
      
M.VNO, DDNO= ISNULL((SELECT MAX(DDNO) FROM LEDGER1 L1 WHERE L1.VNO=M.VNO AND L1.VTYP=M.VTYP AND L1.BOOKTYPE=M.BOOKTYPE AND L1.LNO = M.LNO),''), L.NARRATION, M.PARTY_CODE, A.LONGNAME, M.VTYP, CONVERT(VARCHAR,L.VDT,103) VDT, CONVERT(VARCHAR,L.EDT,103) EDT "
  
    
      
        
          
            
    SELECT @@FROMTABLES = " FROM Sledger_Vw_Final L, COSTMAST C, MARGINLEDGER M (NOLOCK)  LEFT OUTER JOIN LEDGER2 L2  (NOLOCK) ON M.VTYP = L2.VTYPE AND M.BOOKTYPE = L2.BOOKTYPE AND M.VNO = L2.VNO AND M.LNO = L2.LNO LEFT OUTER JOIN sacmast_view A  (NOLOCK)
 ON M.PART  
    
Y_CODE      
 = A.CLTCODE , VMAST  V (NOLOCK)  "                        SELECT @@WHEREPART = @@DATEFILTER + " AND M.PARTY_CODE >= '" + @FCODE + "' AND M.PARTY_CODE <= '" + @TCODE + "' AND M.VTYP <> 18 AND ACCAT = '4' AND M.VTYP = V.VTYPE AND M.VTYP = L.VTYP AND M.BOOK
  
    
      
TYPE = L.BOOKTYPE AND M.VNO = L.VNO AND M.LNO = L.LNO AND COSTNAME = RTRIM('" + @BRANCH + "') AND L2.COSTCODE = C.COSTCODE "                                       
SELECT @@GROUPBY = " "                                  
         SELECT @@SORTBY = " ORDER BY M.PARTY_CODE, VOUDT, L.VTYP DESC, L.VNO"                                  
                                  
                                            
      END                                  
END                                  
                                  
--PRINT @@SELECTQURY + @@FROMTABLES + @@WHEREPART + @@GROUPBY + @@SORTBY                                   
--SELECT @@WHEREPART = @@WHEREPART + " AND L.VTYP IN (15,21) "                                  
                                  
                                  
--IF @STATUSID = 'BROKER'                                   
--PRINT ('SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED ' + @@SELECTQURY + @@FROMTABLES + @@WHEREPART + @@GROUPBY + @@SORTBY )                           
EXEC ('SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED ' + @@SELECTQURY + @@FROMTABLES + @@WHEREPART + @@GROUPBY + @@SORTBY )           
          
          
SET QUOTED_IDENTIFIER OFF

GO
