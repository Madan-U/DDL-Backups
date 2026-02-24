-- Object: PROCEDURE dbo.BOLOGIN_BSE_bak_02052016
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



    
--EXEC BOLOGIN_BSE 'Oct 8 2015', 'Oct 14 2015','NSE', 'U'     
    
CREATE PROC [dbo].[BOLOGIN_BSE_bak_02052016]         
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
			CONVERT(VARCHAR(11),max(D.login_inactive_date),120) AS Logn_Inactive_dt,
			CONVERT(VARCHAR(11),max(G.SEPARATIONDATE),120) SEPARATIONDATE ,
			DATEDIFF(DAY, login_inactive_date,SEPARATIONDATE)  as Count_Days        
			INTO #NBFC FROM  [196.1.115.132].risk.dbo.user_login D, 
			[172.31.16.57].NBFC.DBO.TBLUSERCONTROLMASTER U, [172.31.16.57].NBFC.DBO.TBLPRADNYAUSERS P,
			[196.1.115.132].risk.dbo.emp_info G 
			WHERE         
			G.SEPARATIONDATE  >=@FROMDATE AND G.SEPARATIONDATE <=@TODATE + ' 23:59' and
			D.login_inactive_date  >=@FROMDATE AND D.login_inactive_date <=@TODATE + ' 23:59' and
			--G.SEGMENT ='BSECM'  AND      
			G.EMP_NO= left(P.FLDUSERNAME,6) 
			AND U.FLDUSERID=P.FLDAUTO AND D.username=G.EMP_NO
			group by FLDUSERNAME,FLDFIRSTNAME,FLDSTATUS,login_inactive_date,SEPARATIONDATE
			--AND G.TYPE ='QUIT' and

			SELECT * FROM #NBFC ORDER BY COUNT_DAYS DESC      
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
			CONVERT(VARCHAR(11),max(D.login_inactive_date),120) AS Logn_Inactive_dt,
			CONVERT(VARCHAR(11),max(G.SEPARATIONDATE),120) SEPARATIONDATE ,
			DATEDIFF(DAY, login_inactive_date,SEPARATIONDATE)  as Count_Days        
			INTO #BSE FROM  [196.1.115.132].risk.dbo.user_login D, 
			[196.1.115.201].BSEDB_AB.DBO.TBLUSERCONTROLMASTER U, [196.1.115.201].BSEDB_AB.DBO.TBLPRADNYAUSERS P,
			[196.1.115.132].risk.dbo.emp_info G 
			WHERE         
			G.SEPARATIONDATE  >=@FROMDATE AND G.SEPARATIONDATE <=@TODATE + ' 23:59' and
			D.login_inactive_date  >=@FROMDATE AND D.login_inactive_date <=@TODATE + ' 23:59' and
			--G.SEGMENT ='BSECM'  AND      
			G.EMP_NO= left(P.FLDUSERNAME,6) 
			AND U.FLDUSERID=P.FLDAUTO AND D.username=G.EMP_NO
			group by FLDUSERNAME,FLDFIRSTNAME,FLDSTATUS,login_inactive_date,SEPARATIONDATE
			--AND G.TYPE ='QUIT' and

			SELECT * FROM #BSE ORDER BY COUNT_DAYS DESC
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
			CONVERT(VARCHAR(11),max(D.login_inactive_date),120) AS Logn_Inactive_dt,
			CONVERT(VARCHAR(11),max(G.SEPARATIONDATE),120) SEPARATIONDATE ,
			DATEDIFF(DAY, login_inactive_date,SEPARATIONDATE)  as Count_Days        
			INTO #NSE FROM  [196.1.115.132].risk.dbo.user_login D, 
			DBO.TBLUSERCONTROLMASTER U, DBO.TBLPRADNYAUSERS P,
			[196.1.115.132].risk.dbo.emp_info G 
			WHERE         
			G.SEPARATIONDATE  >=@FROMDATE AND G.SEPARATIONDATE <=@TODATE + ' 23:59' and
			D.login_inactive_date  >=@FROMDATE AND D.login_inactive_date <=@TODATE + ' 23:59' and
			--G.SEGMENT ='BSECM'  AND      
			G.EMP_NO= left(P.FLDUSERNAME,6) 
			AND U.FLDUSERID=P.FLDAUTO AND D.username=G.EMP_NO
			group by FLDUSERNAME,FLDFIRSTNAME,FLDSTATUS,login_inactive_date,SEPARATIONDATE
			--AND G.TYPE ='QUIT' and

			SELECT * FROM #NSE ORDER BY COUNT_DAYS DESC
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
			CONVERT(VARCHAR(11),max(D.login_inactive_date),120) AS Logn_Inactive_dt,
			CONVERT(VARCHAR(11),max(G.SEPARATIONDATE),120) SEPARATIONDATE ,
			DATEDIFF(DAY, login_inactive_date,SEPARATIONDATE)  as Count_Days        
			INTO #NSEFO FROM  [196.1.115.132].risk.dbo.user_login D, 
			[196.1.115.200].NSEFO.DBO.TBLUSERCONTROLMASTER U, [196.1.115.200].NSEFO.DBO.TBLPRADNYAUSERS P,
			[196.1.115.132].risk.dbo.emp_info G 
			WHERE         
			G.SEPARATIONDATE  >=@FROMDATE AND G.SEPARATIONDATE <=@TODATE + ' 23:59' and
			D.login_inactive_date  >=@FROMDATE AND D.login_inactive_date <=@TODATE + ' 23:59' and
			--G.SEGMENT ='BSECM'  AND      
			G.EMP_NO= left(P.FLDUSERNAME,6) 
			AND U.FLDUSERID=P.FLDAUTO AND D.username=G.EMP_NO
			group by FLDUSERNAME,FLDFIRSTNAME,FLDSTATUS,login_inactive_date,SEPARATIONDATE
			--AND G.TYPE ='QUIT' and

			SELECT * FROM #NSEFO ORDER BY COUNT_DAYS DESC 
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
			CONVERT(VARCHAR(11),max(D.login_inactive_date),120) AS Logn_Inactive_dt,
			CONVERT(VARCHAR(11),max(G.SEPARATIONDATE),120) SEPARATIONDATE ,
			DATEDIFF(DAY, login_inactive_date,SEPARATIONDATE)  as Count_Days        
			INTO #MCDX FROM  [196.1.115.132].risk.dbo.user_login D, 
			[196.1.115.204].MCDX.DBO.TBLUSERCONTROLMASTER U, [196.1.115.204].MCDX.DBO.TBLPRADNYAUSERS P,
			[196.1.115.132].risk.dbo.emp_info G 
			WHERE         
			G.SEPARATIONDATE  >=@FROMDATE AND G.SEPARATIONDATE <=@TODATE + ' 23:59' and
			D.login_inactive_date  >=@FROMDATE AND D.login_inactive_date <=@TODATE + ' 23:59' and
			--G.SEGMENT ='BSECM'  AND      
			G.EMP_NO= left(P.FLDUSERNAME,6) 
			AND U.FLDUSERID=P.FLDAUTO AND D.username=G.EMP_NO
			group by FLDUSERNAME,FLDFIRSTNAME,FLDSTATUS,login_inactive_date,SEPARATIONDATE
			--AND G.TYPE ='QUIT' and

			SELECT * FROM #MCDX ORDER BY COUNT_DAYS DESC      
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
			CONVERT(VARCHAR(11),max(D.login_inactive_date),120) AS Logn_Inactive_dt,
			CONVERT(VARCHAR(11),max(G.SEPARATIONDATE),120) SEPARATIONDATE ,
			DATEDIFF(DAY, login_inactive_date,SEPARATIONDATE)  as Count_Days        
			INTO #NCDX FROM  [196.1.115.132].risk.dbo.user_login D, 
			[196.1.115.204].NCDX.DBO.TBLUSERCONTROLMASTER U, [196.1.115.204].NCDX.DBO.TBLPRADNYAUSERS P,
			[196.1.115.132].risk.dbo.emp_info G 
			WHERE         
			G.SEPARATIONDATE  >=@FROMDATE AND G.SEPARATIONDATE <=@TODATE + ' 23:59' and
			D.login_inactive_date  >=@FROMDATE AND D.login_inactive_date <=@TODATE + ' 23:59' and
			--G.SEGMENT ='BSECM'  AND      
			G.EMP_NO= left(P.FLDUSERNAME,6) 
			AND U.FLDUSERID=P.FLDAUTO AND D.username=G.EMP_NO
			group by FLDUSERNAME,FLDFIRSTNAME,FLDSTATUS,login_inactive_date,SEPARATIONDATE
			--AND G.TYPE ='QUIT' and

			SELECT * FROM #NCDX ORDER BY COUNT_DAYS DESC   
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
