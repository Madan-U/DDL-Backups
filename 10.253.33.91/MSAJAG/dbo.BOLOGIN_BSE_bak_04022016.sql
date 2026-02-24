-- Object: PROCEDURE dbo.BOLOGIN_BSE_bak_04022016
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

    
--EXEC BOLOGIN_BSE 'Oct 8 2015', 'Oct 14 2015','NSE', 'U'     
    
CREATE PROC BOLOGIN_BSE         
(@FROMDATE DATETIME,@TODATE DATETIME,@EXCH VARCHAR(10),@RPT VARCHAR(10))          
AS          
--- LOGIN_DETAILS          
IF @RPT ='U'          
 BEGIN           
  IF @EXCH ='NBFC'          
    BEGIN           
    SELECT UPPER(FLDUSERNAME) AS LOGIN_ID,UPPER(FLDFIRSTNAME) AS USER_NAME, CONVERT(VARCHAR(11),ACTION_MODIFIEDDATE,120) AS CREATION_DATE          
     FROM [172.31.16.57].NBFC.DBO.TBLPRADNYAUSERS_AUDIT WHERE           
     ACTION_MODIFIEDDATE >=@FROMDATE AND ACTION_MODIFIEDDATE <=@TODATE + ' 23:59'          
 END             
 END          
-- DEACTIVATE LOGIN DETAILS          
IF @RPT ='D'          
 BEGIN           
  IF @EXCH ='NBFC'          
    BEGIN           
     SELECT DISTINCT UPPER(P.FLDUSERNAME) AS LOGIN_ID,UPPER(P.FLDFIRSTNAME) AS USER_NAME,U.FLDSTATUS,          
  CONVERT(VARCHAR(11),D.login_inactive_date,120) AS Logn_Inactive_dt,  
  CONVERT(VARCHAR(11),G.SEPARATIONDATE,120) SEPARATIONDATE ,  
  DATEDIFF(DAY, login_inactive_date,SEPARATIONDATE)  as Count_Days          
 -- INTO #TEMP4
   FROM  [196.1.115.132].risk.dbo.user_login D,
    TBLUSERCONTROLMASTER U, 
    dbo.TBLPRADNYAUSERS P,
    DEACTIVELOGIN G WHERE           
  D.login_inactive_date  >=@fromdate AND D.login_inactive_date <=@todate + ' 23:59' and  
  G.SEGMENT ='NBFC'  AND        
  D.username= left(P.FLDUSERNAME,6)   
  AND U.FLDUSERID=P.FLDAUTO
   AND D.username=G.BO_LOGINID  
  AND G.TYPE ='QUIT'          
 END             
          
 END          
 ------ LAST LOGIN DETAILS           
          
 IF @RPT ='L'          
 BEGIN           
  IF @EXCH ='NBFC'          
    BEGIN           
    SELECT UPPER(FLDUSERNAME) AS LOGIN_ID,UPPER(FLDFIRSTNAME) AS USER_NAME,          
     MAX(ADDDT) AS LAST_LOGIN          
     FROM   [172.31.16.57].NBFC.DBO.V2_REPORT_ACCESS_LOG U, [172.31.16.57].NBFC.DBO.TBLPRADNYAUSERS P WHERE           
      ADDDT  >=@FROMDATE AND ADDDT <=@TODATE + ' 23:59'          
   AND  USERNAME=FLDUSERNAME             
   GROUP BY FLDUSERNAME,FLDFIRSTNAME          
 END             
 END          
--------- CATEGORY CHANGE          
          
 IF @RPT ='C'          
 BEGIN           
  IF @EXCH ='NBFC'          
    BEGIN           
    SELECT UPPER(FLDUSERNAME) AS LOGIN_ID,FLDCATEGORY_OLD AS OLD_CATEGORY,FLDCATEGORY_NEW AS NEW_CATEOGRY,          
    ACTION_MODIFIEDDATE AS MODIFIED_DATE          
     FROM   [172.31.16.57].NBFC.DBO.TBLCATMUENU_CHANGE_AUDIT U WHERE           
      ACTION_MODIFIEDDATE  >=@FROMDATE AND ACTION_MODIFIEDDATE <=@TODATE + ' 23:59'          
 END             
          
 END          
          
  -----------------------------------for bse---------------------------------------------------------        
          
          
  --- LOGIN_DETAILS          
IF @RPT ='U'          
 BEGIN           
  IF @EXCH ='BSE'          
    BEGIN           
    SELECT UPPER(FLDUSERNAME) AS LOGIN_ID,UPPER(FLDFIRSTNAME) AS USER_NAME, CONVERT(VARCHAR(11),ACTIONDATE,120) AS CREATION_DATE          
     FROM [196.1.115.201].bsedb_ab.dbo.tblpradnyausers_Jrnl WITH (NOLOCK) WHERE           
     ACTIONDATE >=@FROMDATE AND ACTIONDATE <=@TODATE + ' 23:59'          
 END             
 END          
-- DEACTIVATE LOGIN DETAILS          
IF @RPT ='D'          
 BEGIN           
  IF @EXCH ='BSE'          
    BEGIN           
    SELECT DISTINCT UPPER(P.FLDUSERNAME) AS LOGIN_ID,UPPER(P.FLDFIRSTNAME) AS USER_NAME,U.FLDSTATUS,          
  CONVERT(VARCHAR(11),D.login_inactive_date,120) AS Logn_Inactive_dt,  
  CONVERT(VARCHAR(11),G.SEPARATIONDATE,120) SEPARATIONDATE ,  
  DATEDIFF(DAY, login_inactive_date,SEPARATIONDATE)  as Count_Days          
 -- INTO #TEMP4
   FROM  [196.1.115.132].risk.dbo.user_login D,
    [196.1.115.201].bsedb_ab.dbo.TBLUSERCONTROLMASTER U, 
    [196.1.115.201].bsedb_ab.dbo.TBLPRADNYAUSERS P,
    DEACTIVELOGIN G WHERE           
  D.login_inactive_date  >=@fromdate AND D.login_inactive_date <=@todate + ' 23:59' and  
  G.SEGMENT ='BSECM'  AND        
  D.username= left(P.FLDUSERNAME,6)   
  AND U.FLDUSERID=P.FLDAUTO
   AND D.username=G.BO_LOGINID  
  AND G.TYPE ='QUIT'          
 END             
          
 END          
 ------ LAST LOGIN DETAILS           
          
 IF @RPT ='L'          
 BEGIN           
  IF @EXCH ='BSE'          
    BEGIN           
    SELECT UPPER(FLDUSERNAME) AS LOGIN_ID,UPPER(FLDFIRSTNAME) AS USER_NAME,          
     MAX(ADDDT) AS LAST_LOGIN          
     FROM   [196.1.115.201].bsedb_ab.dbo.V2_REPORT_ACCESS_LOG U, [196.1.115.201].bsedb_ab.dbo.TBLPRADNYAUSERS P WHERE           
      ADDDT  >=@FROMDATE AND ADDDT <=@TODATE + ' 23:59'          
   AND  USERNAME=FLDUSERNAME             
   GROUP BY FLDUSERNAME,FLDFIRSTNAME          
 END             
 END          
       
       
--------------------------------------NSE-----------------------------------------------------------      
--- LOGIN_DETAILS       
IF @RPT ='U'          
 BEGIN           
  IF @EXCH ='NSE'          
    BEGIN           
    SELECT UPPER(FLDUSERNAME) AS LOGIN_ID,UPPER(FLDFIRSTNAME) AS USER_NAME, CONVERT(VARCHAR(11),ACTIONDATE,120) AS CREATION_DATE          
     FROM tblpradnyausers_Jrnl WITH (NOLOCK) WHERE           
     ACTIONDATE >=@FROMDATE AND ACTIONDATE <=@TODATE + ' 23:59'          
 END             
 END          
-- DEACTIVATE LOGIN DETAILS          
IF @RPT ='D'          
 BEGIN           
  IF @EXCH ='NSE'          
    BEGIN           
    SELECT DISTINCT UPPER(P.FLDUSERNAME) AS LOGIN_ID,UPPER(P.FLDFIRSTNAME) AS USER_NAME,U.FLDSTATUS,          
  CONVERT(VARCHAR(11),D.login_inactive_date,120) AS Logn_Inactive_dt,  
  CONVERT(VARCHAR(11),G.SEPARATIONDATE,120) SEPARATIONDATE ,  
  DATEDIFF(DAY, login_inactive_date,SEPARATIONDATE)  as Count_Days          
 -- INTO #TEMP4
   FROM  [196.1.115.132].risk.dbo.user_login D,
    TBLUSERCONTROLMASTER U, 
    dbo.TBLPRADNYAUSERS P,
    DEACTIVELOGIN G WHERE           
  D.login_inactive_date  >=@fromdate AND D.login_inactive_date <=@todate + ' 23:59' and  
  G.SEGMENT ='NSECM'  AND        
  D.username= left(P.FLDUSERNAME,6)   
  AND U.FLDUSERID=P.FLDAUTO
   AND D.username=G.BO_LOGINID  
  AND G.TYPE ='QUIT'        
 END             
          
 END      
   
 --------------------------------------NSEFO-----------------------------------------------------------      
--- LOGIN_DETAILS       
IF @RPT ='U'          
 BEGIN           
  IF @EXCH ='NSEFO'          
    BEGIN           
    SELECT UPPER(FLDUSERNAME) AS LOGIN_ID,UPPER(FLDFIRSTNAME) AS USER_NAME, CONVERT(VARCHAR(11),ACTIONDATE,120) AS CREATION_DATE          
     FROM [196.1.115.200].NSEFO.dbo.tblpradnyausers_Jrnl WITH (NOLOCK) WHERE           
     ACTIONDATE >=@FROMDATE AND ACTIONDATE <=@TODATE + ' 23:59'          
 END             
 END          
-- DEACTIVATE LOGIN DETAILS          
IF @RPT ='D'          
 BEGIN           
  IF @EXCH ='NSEFO'          
    BEGIN           
     SELECT DISTINCT UPPER(P.FLDUSERNAME) AS LOGIN_ID,UPPER(P.FLDFIRSTNAME) AS USER_NAME,U.FLDSTATUS,          
  CONVERT(VARCHAR(11),D.login_inactive_date,120) AS Logn_Inactive_dt,  
  CONVERT(VARCHAR(11),G.SEPARATIONDATE,120) SEPARATIONDATE ,  
  DATEDIFF(DAY, login_inactive_date,SEPARATIONDATE)  as Count_Days          
 -- INTO #TEMP4
   FROM  [196.1.115.132].risk.dbo.user_login D,
     [196.1.115.200].NSEFO.dbo.TBLUSERCONTROLMASTER U, 
     [196.1.115.200].NSEFO.dbo.TBLPRADNYAUSERS P,
    DEACTIVELOGIN G WHERE           
  D.login_inactive_date  >=@fromdate AND D.login_inactive_date <=@todate + ' 23:59' and  
  G.SEGMENT ='NSEFO'  AND        
  D.username= left(P.FLDUSERNAME,6)   
  AND U.FLDUSERID=P.FLDAUTO
   AND D.username=G.BO_LOGINID  
  AND G.TYPE ='QUIT'      
 END   
 END       
 --------------------------------------MCDX-----------------------------------------------------------      
--- LOGIN_DETAILS       
IF @RPT ='U'          
 BEGIN           
  IF @EXCH ='MCDX'          
    BEGIN           
    SELECT UPPER(FLDUSERNAME) AS LOGIN_ID,UPPER(FLDFIRSTNAME) AS USER_NAME, CONVERT(VARCHAR(11),ACTIONDATE,120) AS CREATION_DATE          
     FROM [196.1.115.204].MCDX.dbo.tblpradnyausers_Jrnl WITH (NOLOCK) WHERE           
     ACTIONDATE >=@FROMDATE AND ACTIONDATE <=@TODATE + ' 23:59'          
 END             
 END          
-- DEACTIVATE LOGIN DETAILS          
IF @RPT ='D'          
 BEGIN           
  IF @EXCH ='MCDX'          
    BEGIN           
     SELECT DISTINCT UPPER(P.FLDUSERNAME) AS LOGIN_ID,UPPER(P.FLDFIRSTNAME) AS USER_NAME,U.FLDSTATUS,          
  CONVERT(VARCHAR(11),D.login_inactive_date,120) AS Logn_Inactive_dt,  
  CONVERT(VARCHAR(11),G.SEPARATIONDATE,120) SEPARATIONDATE ,  
  DATEDIFF(DAY, login_inactive_date,SEPARATIONDATE)  as Count_Days          
 -- INTO #TEMP4
   FROM  [196.1.115.132].risk.dbo.user_login D,
    [196.1.115.204].MCDX.dbo.TBLUSERCONTROLMASTER U, 
    [196.1.115.204].MCDX.dbo.TBLPRADNYAUSERS P,
    DEACTIVELOGIN G WHERE           
  D.login_inactive_date  >=@fromdate AND D.login_inactive_date <=@todate + ' 23:59' and  
  G.SEGMENT ='MCX'  AND        
  D.username= left(P.FLDUSERNAME,6)   
  AND U.FLDUSERID=P.FLDAUTO
   AND D.username=G.BO_LOGINID  
  AND G.TYPE ='QUIT'           
 END   
 END       
  --------------------------------------NCDX-----------------------------------------------------------      
--- LOGIN_DETAILS       
IF @RPT ='U'          
 BEGIN           
  IF @EXCH ='NCDX'          
    BEGIN           
    SELECT UPPER(FLDUSERNAME) AS LOGIN_ID,UPPER(FLDFIRSTNAME) AS USER_NAME, CONVERT(VARCHAR(11),ACTIONDATE,120) AS CREATION_DATE          
     FROM [196.1.115.204].NCDX.dbo.tblpradnyausers_Jrnl WITH (NOLOCK) WHERE           
     ACTIONDATE >=@FROMDATE AND ACTIONDATE <=@TODATE + ' 23:59'          
 END             
 END          
-- DEACTIVATE LOGIN DETAILS          
IF @RPT ='D'          
 BEGIN           
  IF @EXCH ='NCDX'          
    BEGIN           
     SELECT DISTINCT UPPER(P.FLDUSERNAME) AS LOGIN_ID,UPPER(P.FLDFIRSTNAME) AS USER_NAME,U.FLDSTATUS,          
  CONVERT(VARCHAR(11),D.login_inactive_date,120) AS Logn_Inactive_dt,  
  CONVERT(VARCHAR(11),G.SEPARATIONDATE,120) SEPARATIONDATE ,  
  DATEDIFF(DAY, login_inactive_date,SEPARATIONDATE)  as Count_Days          
 -- INTO #TEMP4
   FROM  [196.1.115.132].risk.dbo.user_login D,
    [196.1.115.204].NCDX.dbo.TBLUSERCONTROLMASTER U, 
    [196.1.115.204].NCDX.dbo.TBLPRADNYAUSERS P,
    DEACTIVELOGIN G WHERE           
  D.login_inactive_date  >=@fromdate AND D.login_inactive_date <=@todate + ' 23:59' and  
  G.SEGMENT ='NSECM'  AND        
  D.username= left(P.FLDUSERNAME,6)   
  AND U.FLDUSERID=P.FLDAUTO
   AND D.username=G.BO_LOGINID  
  AND G.TYPE ='QUIT'    
 END   
 END       
      
 ------ LAST LOGIN DETAILS           
          
 IF @RPT ='L'          
 BEGIN           
  IF @EXCH ='NSE'          
    BEGIN           
    SELECT UPPER(FLDUSERNAME) AS LOGIN_ID,UPPER(FLDFIRSTNAME) AS USER_NAME,          
     MAX(ADDDT) AS LAST_LOGIN          
     FROM   V2_REPORT_ACCESS_LOG U, TBLPRADNYAUSERS P WHERE           
      ADDDT  >=@FROMDATE AND ADDDT <=@TODATE + ' 23:59'          
   AND  USERNAME=FLDUSERNAME             
   GROUP BY FLDUSERNAME,FLDFIRSTNAME          
 END             
 END          
      
--------- CATEGORY CHANGE          
          
 --IF @RPT ='C'          
 --BEGIN           
 -- IF @EXCH ='BSE'          
 --   BEGIN           
 --   SELECT UPPER(FLDUSERNAME) AS LOGIN_ID,FLDCATEGORY_OLD AS OLD_CATEGORY,FLDCATEGORY_NEW AS NEW_CATEOGRY,          
 --   ACTION_MODIFIEDDATE AS MODIFIED_DATE          
 --    FROM   [196.1.115.201].bsedb_ab.dbo.TBLCATMUENU_CHANGE_AUDIT U WHERE           
 --     ACTION_MODIFIEDDATE  >=@FROMDATE AND ACTION_MODIFIEDDATE <=@TODATE + ' 23:59'          
 --END             
          
 --END

GO
