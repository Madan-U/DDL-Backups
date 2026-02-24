-- Object: PROCEDURE dbo.BOLOGIN_BSE_30012017
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

  --EXEC BOLOGIN_BSE 'Apr 1 2015', 'Mar 31 2016','MCDX', 'U' 
      
--EXEC BOLOGIN_BSE 'Oct 8 2015', 'Oct 14 2015','NSE', 'U'       
      
CREATE PROC [dbo].[BOLOGIN_BSE]           
(@FROMDATE DATETIME,@TODATE DATETIME,@EXCH VARCHAR(10),@RPT VARCHAR(10))            
AS            
--- LOGIN_DETAILS            
IF @RPT ='U'            
 BEGIN             
  IF @EXCH ='NBFC'            
    BEGIN             
		SELECT A.FLDUSERNAME,B.FLDCATEGORYNAME,A.Action_ModifiedDATE FROM 
		[172.31.16.57].NBFC.DBO.TBLPRADNYAUSERS_AUDIT A WITH (NOLOCK)  LEFT OUTER JOIN [172.31.16.57].NBFC.DBO.tblcategory  B WITH (NOLOCK)
		ON A.fldcategory = B.FLDCATEGORYCODE
		WHERE   A.Action_ModifiedDATE >=@FROMDATE AND A.Action_ModifiedDATE <=@TODATE + ' 23:59'          
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
		SELECT A.FLDUSERNAME,B.FLDCATEGORYNAME,A.ACTIONDATE 
		FROM [196.1.115.201].BSEDB_AB.DBO.tblpradnyausers_Jrnl A WITH (NOLOCK)  LEFT OUTER JOIN [196.1.115.201].BSEDB_AB.DBO.tblcategory  B WITH (NOLOCK) 
		ON A.fldcategory = B.FLDCATEGORYCODE
		WHERE A.ACTIONFLAG='I' AND  A.ActionDate >=@FROMDATE AND A.ActionDate <=@TODATE + ' 23:59' AND A.fldcategory NOT IN ('15','1369')
		ORDER BY A.fldusername           
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
		SELECT A.FLDUSERNAME,B.FLDCATEGORYNAME,A.ACTIONDATE from
		tblpradnyausers_Jrnl A WITH (NOLOCK)  LEFT OUTER JOIN tblcategory  B WITH (NOLOCK)
		ON A.fldcategory = B.FLDCATEGORYCODE
		WHERE A.ACTIONFLAG='I' AND  A.ActionDate >=@FROMDATE AND A.ActionDate <=@TODATE + ' 23:59' AND A.fldcategory NOT IN ('20','207')
		ORDER BY A.fldusername           
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
		SELECT A.FLDUSERNAME,B.FLDCATEGORYNAME,A.ACTIONDATE from
		[196.1.115.200].NSEFO.DBO.tblpradnyausers_Jrnl A WITH (NOLOCK)  LEFT OUTER JOIN [196.1.115.200].NSEFO.DBO.tblcategory  B WITH (NOLOCK)
		ON A.fldcategory = B.FLDCATEGORYCODE
		WHERE A.ACTIONFLAG='I' AND  A.ActionDate >=@FROMDATE AND A.ActionDate <=@TODATE + ' 23:59' AND A.fldcategory NOT IN ('22','272')
		ORDER BY A.fldusername          
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
		SELECT A.FLDUSERNAME,B.FLDCATEGORYNAME,A.ACTIONDATE from
		[196.1.115.204].MCDX.DBO.tblpradnyausers_Jrnl A WITH (NOLOCK)  LEFT OUTER JOIN [196.1.115.204].MCDX.DBO.tblcategory  B WITH (NOLOCK)
		ON A.fldcategory = B.FLDCATEGORYCODE
		WHERE A.ACTIONFLAG='I' AND  A.ActionDate >=@FROMDATE AND A.ActionDate <=@TODATE + ' 23:59' AND A.fldcategory NOT IN   ('16','93')
		ORDER BY A.fldusername          
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
		SELECT A.FLDUSERNAME,B.FLDCATEGORYNAME,A.ACTIONDATE from
		[196.1.115.204].NCDX.DBO.tblpradnyausers_Jrnl A WITH (NOLOCK)  LEFT OUTER JOIN [196.1.115.204].NCDX.DBO.tblcategory  B WITH (NOLOCK)
		ON A.fldcategory = B.FLDCATEGORYCODE
		WHERE A.ACTIONFLAG='I' AND  A.ActionDate >=@FROMDATE AND A.ActionDate <=@TODATE + ' 23:59' AND A.fldcategory NOT IN  ('23','236')
		ORDER BY A.fldusername          
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
            
 IF @RPT ='C'            
 BEGIN             
  IF @EXCH ='NSE'            
    BEGIN             
		SELECT UPPER(A.Fldusername) AS LOGIN_ID,action, action_modifieddate,action_modifiedby,user_ip,hostname,appname ,
		FLDCATEGORY_OLD AS OLD_CATEGORY,B.fldcategoryname,FLDCATEGORY_NEW AS NEW_CATEOGRY,ACTION_MODIFIEDDATE AS MODIFIED_DATE        
		INTO #TEMP1  FROM   TBLCATMUENU_CHANGE_AUDIT AS A ,tblcategory AS B WHERE  A.Fldcategory_old=B.fldcategorycode AND
		ACTION_MODIFIEDDATE  >=@FROMDATE AND ACTION_MODIFIEDDATE <=@TODATE + ' 23:59'  
		--
		SELECT UPPER(A.Fldusername) AS LOGIN_ID,action_modifieddate,action_modifiedby,user_ip,hostname,appname,FLDCATEGORY_OLD AS OLD_CATEGORY,
		FLDCATEGORY_NEW AS NEW_CATEOGRY,B.fldcategoryname,ACTION_MODIFIEDDATE AS MODIFIED_DATE        
		INTO #TEMP2 FROM TBLCATMUENU_CHANGE_AUDIT AS A ,tblcategory AS B 
		WHERE  A.Fldcategory_new=B.fldcategorycode AND ACTION_MODIFIEDDATE  >=@FROMDATE AND ACTION_MODIFIEDDATE <=@TODATE + ' 23:59'  
		--
		SELECT A.LOGIN_ID,a.action_modifieddate,a.action_modifiedby,a.user_ip,a.hostname ,a.appname ,A.OLD_CATEGORY,A.fldcategoryname,B.NEW_CATEOGRY,
		B.fldcategoryname AS fldcategoryname_NEW ,A.MODIFIED_DATE
		INTO #TEMP3 FROM #TEMP1 A,#TEMP2 B WHERE A.LOGIN_ID=B.LOGIN_ID
		--
		SELECT distinct LOGIN_ID,a.action_modifieddate,a.action_modifiedby,a.user_ip,a.hostname ,a.appname ,fldfirstname,fldlastname,OLD_CATEGORY,fldcategoryname,NEW_CATEOGRY,fldcategoryname_NEW,MODIFIED_DATE
		FROM #TEMP3 A,TBLPRADNYAUSERS B WHERE A.LOGIN_ID=B.fldusername
		order by 1,2        
 END               
            
 END   
 IF @RPT ='C'            
 BEGIN             
  IF @EXCH ='BSE'            
    BEGIN             
		SELECT UPPER(A.Fldusername) AS LOGIN_ID,action, action_modifieddate,action_modifiedby,user_ip,hostname,appname ,
		FLDCATEGORY_OLD AS OLD_CATEGORY,B.fldcategoryname,FLDCATEGORY_NEW AS NEW_CATEOGRY,ACTION_MODIFIEDDATE AS MODIFIED_DATE        
		INTO #BSE1 FROM [196.1.115.201].BSEDB_AB.DBO.TBLCATMUENU_CHANGE_AUDIT AS A ,[196.1.115.201].BSEDB_AB.DBO.tblcategory AS B 
		WHERE  A.Fldcategory_old=B.fldcategorycode AND ACTION_MODIFIEDDATE  >=@FROMDATE AND ACTION_MODIFIEDDATE <=@TODATE + ' 23:59'  
		--
		SELECT UPPER(A.Fldusername) AS LOGIN_ID,action_modifieddate,action_modifiedby,user_ip,hostname,appname,FLDCATEGORY_OLD AS OLD_CATEGORY,
		FLDCATEGORY_NEW AS NEW_CATEOGRY,B.fldcategoryname,ACTION_MODIFIEDDATE AS MODIFIED_DATE        
		INTO #BSE2 FROM [196.1.115.201].BSEDB_AB.DBO.TBLCATMUENU_CHANGE_AUDIT AS A ,[196.1.115.201].BSEDB_AB.DBO.tblcategory AS B 
		WHERE  A.Fldcategory_new=B.fldcategorycode AND ACTION_MODIFIEDDATE  >=@FROMDATE AND ACTION_MODIFIEDDATE <=@TODATE + ' 23:59'  
		--
		SELECT A.LOGIN_ID,a.action_modifieddate,a.action_modifiedby,a.user_ip,a.hostname ,a.appname ,A.OLD_CATEGORY,A.fldcategoryname,B.NEW_CATEOGRY,
		B.fldcategoryname AS fldcategoryname_NEW ,A.MODIFIED_DATE
		INTO #BSE3 FROM #BSE1 A,#BSE2 B WHERE A.LOGIN_ID=B.LOGIN_ID
		--
		SELECT distinct LOGIN_ID,a.action_modifieddate,a.action_modifiedby,a.user_ip,a.hostname ,a.appname ,fldfirstname,fldlastname,OLD_CATEGORY,fldcategoryname,NEW_CATEOGRY,fldcategoryname_NEW,MODIFIED_DATE
		FROM #BSE3 A,[196.1.115.201].BSEDB_AB.DBO.TBLPRADNYAUSERS B WHERE A.LOGIN_ID=B.fldusername
		order by 1,2        
 END               
            
 END   
  IF @RPT ='C'            
 BEGIN             
  IF @EXCH ='NSEFO'            
    BEGIN             
		SELECT UPPER(A.Fldusername) AS LOGIN_ID,action, action_modifieddate,action_modifiedby,user_ip,hostname,appname ,
		FLDCATEGORY_OLD AS OLD_CATEGORY,B.fldcategoryname,FLDCATEGORY_NEW AS NEW_CATEOGRY,ACTION_MODIFIEDDATE AS MODIFIED_DATE        
		INTO #NSEFO1 FROM [196.1.115.200].NSEFO.DBO.TBLCATMUENU_CHANGE_AUDIT AS A ,[196.1.115.200].NSEFO.DBO.tblcategory AS B 
		WHERE  A.Fldcategory_old=B.fldcategorycode AND ACTION_MODIFIEDDATE  >=@FROMDATE AND ACTION_MODIFIEDDATE <=@TODATE + ' 23:59'  
		--
		SELECT UPPER(A.Fldusername) AS LOGIN_ID,action_modifieddate,action_modifiedby,user_ip,hostname,appname,FLDCATEGORY_OLD AS OLD_CATEGORY,
		FLDCATEGORY_NEW AS NEW_CATEOGRY,B.fldcategoryname,ACTION_MODIFIEDDATE AS MODIFIED_DATE        
		INTO #NSEFO2 FROM [196.1.115.200].NSEFO.DBO.TBLCATMUENU_CHANGE_AUDIT AS A ,[196.1.115.200].NSEFO.DBO.tblcategory AS B 
		WHERE  A.Fldcategory_new=B.fldcategorycode AND ACTION_MODIFIEDDATE  >=@FROMDATE AND ACTION_MODIFIEDDATE <=@TODATE + ' 23:59'  
		--
		SELECT A.LOGIN_ID,a.action_modifieddate,a.action_modifiedby,a.user_ip,a.hostname ,a.appname ,A.OLD_CATEGORY,A.fldcategoryname,B.NEW_CATEOGRY,
		B.fldcategoryname AS fldcategoryname_NEW ,A.MODIFIED_DATE
		INTO #NSEFO3 FROM #NSEFO1 A,#NSEFO2 B WHERE A.LOGIN_ID=B.LOGIN_ID
		--
		SELECT distinct LOGIN_ID,a.action_modifieddate,a.action_modifiedby,a.user_ip,a.hostname ,a.appname ,fldfirstname,fldlastname,OLD_CATEGORY,fldcategoryname,NEW_CATEOGRY,fldcategoryname_NEW,MODIFIED_DATE
		FROM #NSEFO3 A,[196.1.115.200].NSEFO.DBO.TBLPRADNYAUSERS B WHERE A.LOGIN_ID=B.fldusername
		order by 1,2        
 END               
            
 END   
   IF @RPT ='C'            
 BEGIN             
  IF @EXCH ='NSECD'            
    BEGIN             
		SELECT UPPER(A.Fldusername) AS LOGIN_ID,action, action_modifieddate,action_modifiedby,user_ip,hostname,appname ,
		FLDCATEGORY_OLD AS OLD_CATEGORY,B.fldcategoryname,FLDCATEGORY_NEW AS NEW_CATEOGRY,ACTION_MODIFIEDDATE AS MODIFIED_DATE        
		INTO #NSECURFO1 FROM [196.1.115.200].NSECURFO.DBO.TBLCATMUENU_CHANGE_AUDIT AS A ,[196.1.115.200].NSECURFO.DBO.tblcategory AS B 
		WHERE  A.Fldcategory_old=B.fldcategorycode AND ACTION_MODIFIEDDATE  >=@FROMDATE AND ACTION_MODIFIEDDATE <=@TODATE + ' 23:59'  
		--
		SELECT UPPER(A.Fldusername) AS LOGIN_ID,action_modifieddate,action_modifiedby,user_ip,hostname,appname,FLDCATEGORY_OLD AS OLD_CATEGORY,
		FLDCATEGORY_NEW AS NEW_CATEOGRY,B.fldcategoryname,ACTION_MODIFIEDDATE AS MODIFIED_DATE        
		INTO #NSECURFO2 FROM [196.1.115.200].NSECURFO.DBO.TBLCATMUENU_CHANGE_AUDIT AS A ,[196.1.115.200].NSECURFO.DBO.tblcategory AS B 
		WHERE  A.Fldcategory_new=B.fldcategorycode AND ACTION_MODIFIEDDATE  >=@FROMDATE AND ACTION_MODIFIEDDATE <=@TODATE + ' 23:59'  
		--
		SELECT A.LOGIN_ID,a.action_modifieddate,a.action_modifiedby,a.user_ip,a.hostname ,a.appname ,A.OLD_CATEGORY,A.fldcategoryname,B.NEW_CATEOGRY,
		B.fldcategoryname AS fldcategoryname_NEW ,A.MODIFIED_DATE
		INTO #NSECURFO3 FROM #NSECURFO1 A,#NSECURFO2 B WHERE A.LOGIN_ID=B.LOGIN_ID
		--
		SELECT distinct LOGIN_ID,a.action_modifieddate,a.action_modifiedby,a.user_ip,a.hostname ,a.appname ,fldfirstname,fldlastname,OLD_CATEGORY,fldcategoryname,NEW_CATEOGRY,fldcategoryname_NEW,MODIFIED_DATE
		FROM #NSECURFO3 A,[196.1.115.200].NSECURFO.DBO.TBLPRADNYAUSERS B WHERE A.LOGIN_ID=B.fldusername
		order by 1,2        
 END               
            
 END 
  IF @RPT ='C'            
 BEGIN             
  IF @EXCH ='MCDX'            
    BEGIN             
		SELECT UPPER(A.Fldusername) AS LOGIN_ID,action, action_modifieddate,action_modifiedby,user_ip,hostname,appname ,
		FLDCATEGORY_OLD AS OLD_CATEGORY,B.fldcategoryname,FLDCATEGORY_NEW AS NEW_CATEOGRY,ACTION_MODIFIEDDATE AS MODIFIED_DATE        
		INTO #MCDX1 FROM [196.1.115.204].MCDX.DBO.TBLCATMUENU_CHANGE_AUDIT AS A ,[196.1.115.204].MCDX.DBO.tblcategory AS B 
		WHERE  A.Fldcategory_old=B.fldcategorycode AND ACTION_MODIFIEDDATE  >=@FROMDATE AND ACTION_MODIFIEDDATE <=@TODATE + ' 23:59'  
		--
		SELECT UPPER(A.Fldusername) AS LOGIN_ID,action_modifieddate,action_modifiedby,user_ip,hostname,appname,FLDCATEGORY_OLD AS OLD_CATEGORY,
		FLDCATEGORY_NEW AS NEW_CATEOGRY,B.fldcategoryname,ACTION_MODIFIEDDATE AS MODIFIED_DATE        
		INTO #MCDX2 FROM [196.1.115.204].MCDX.DBO.TBLCATMUENU_CHANGE_AUDIT AS A ,[196.1.115.204].MCDX.DBO.tblcategory AS B 
		WHERE  A.Fldcategory_new=B.fldcategorycode AND ACTION_MODIFIEDDATE  >=@FROMDATE AND ACTION_MODIFIEDDATE <=@TODATE + ' 23:59'  
		--
		SELECT A.LOGIN_ID,a.action_modifieddate,a.action_modifiedby,a.user_ip,a.hostname ,a.appname ,A.OLD_CATEGORY,A.fldcategoryname,B.NEW_CATEOGRY,
		B.fldcategoryname AS fldcategoryname_NEW ,A.MODIFIED_DATE
		INTO #MCDX3 FROM #MCDX1 A,#MCDX2 B WHERE A.LOGIN_ID=B.LOGIN_ID
		--
		SELECT distinct LOGIN_ID,a.action_modifieddate,a.action_modifiedby,a.user_ip,a.hostname ,a.appname ,fldfirstname,fldlastname,OLD_CATEGORY,fldcategoryname,NEW_CATEOGRY,fldcategoryname_NEW,MODIFIED_DATE
		FROM #MCDX3 A,[196.1.115.204].MCDX.DBO.TBLPRADNYAUSERS B WHERE A.LOGIN_ID=B.fldusername
		order by 1,2        
 END               
            
 END 
   IF @RPT ='C'            
 BEGIN             
  IF @EXCH ='NCDX'            
    BEGIN             
		SELECT UPPER(A.Fldusername) AS LOGIN_ID,action, action_modifieddate,action_modifiedby,user_ip,hostname,appname ,
		FLDCATEGORY_OLD AS OLD_CATEGORY,B.fldcategoryname,FLDCATEGORY_NEW AS NEW_CATEOGRY,ACTION_MODIFIEDDATE AS MODIFIED_DATE        
		INTO #NCDX1 FROM [196.1.115.204].NCDX.DBO.TBLCATMUENU_CHANGE_AUDIT AS A ,[196.1.115.204].NCDX.DBO.tblcategory AS B 
		WHERE  A.Fldcategory_old=B.fldcategorycode AND ACTION_MODIFIEDDATE  >=@FROMDATE AND ACTION_MODIFIEDDATE <=@TODATE + ' 23:59'  
		--
		SELECT UPPER(A.Fldusername) AS LOGIN_ID,action_modifieddate,action_modifiedby,user_ip,hostname,appname,FLDCATEGORY_OLD AS OLD_CATEGORY,
		FLDCATEGORY_NEW AS NEW_CATEOGRY,B.fldcategoryname,ACTION_MODIFIEDDATE AS MODIFIED_DATE        
		INTO #NCDX2 FROM [196.1.115.204].NCDX.DBO.TBLCATMUENU_CHANGE_AUDIT AS A ,[196.1.115.204].NCDX.DBO.tblcategory AS B 
		WHERE  A.Fldcategory_new=B.fldcategorycode AND ACTION_MODIFIEDDATE  >=@FROMDATE AND ACTION_MODIFIEDDATE <=@TODATE + ' 23:59'  
		--
		SELECT A.LOGIN_ID,a.action_modifieddate,a.action_modifiedby,a.user_ip,a.hostname ,a.appname ,A.OLD_CATEGORY,A.fldcategoryname,B.NEW_CATEOGRY,
		B.fldcategoryname AS fldcategoryname_NEW ,A.MODIFIED_DATE
		INTO #NCDX3 FROM #NCDX1 A,#NCDX2 B WHERE A.LOGIN_ID=B.LOGIN_ID
		--
		SELECT distinct LOGIN_ID,a.action_modifieddate,a.action_modifiedby,a.user_ip,a.hostname ,a.appname ,fldfirstname,fldlastname,OLD_CATEGORY,fldcategoryname,NEW_CATEOGRY,fldcategoryname_NEW,MODIFIED_DATE
		FROM #NCDX3 A,[196.1.115.204].NCDX.DBO.TBLPRADNYAUSERS B WHERE A.LOGIN_ID=B.fldusername
		order by 1,2        
 END               
            
 END 
 
  IF @RPT ='C'            
 BEGIN             
  IF @EXCH ='MCDXCDS'            
    BEGIN             
		SELECT UPPER(A.Fldusername) AS LOGIN_ID,action, action_modifieddate,action_modifiedby,user_ip,hostname,appname ,
		FLDCATEGORY_OLD AS OLD_CATEGORY,B.fldcategoryname,FLDCATEGORY_NEW AS NEW_CATEOGRY,ACTION_MODIFIEDDATE AS MODIFIED_DATE        
		INTO #MCDXCDS1 FROM [196.1.115.204].MCDXCDS.DBO.TBLCATMUENU_CHANGE_AUDIT AS A ,[196.1.115.204].MCDXCDS.DBO.tblcategory AS B 
		WHERE  A.Fldcategory_old=B.fldcategorycode AND ACTION_MODIFIEDDATE  >=@FROMDATE AND ACTION_MODIFIEDDATE <=@TODATE + ' 23:59'  
		--
		SELECT UPPER(A.Fldusername) AS LOGIN_ID,action_modifieddate,action_modifiedby,user_ip,hostname,appname,FLDCATEGORY_OLD AS OLD_CATEGORY,
		FLDCATEGORY_NEW AS NEW_CATEOGRY,B.fldcategoryname,ACTION_MODIFIEDDATE AS MODIFIED_DATE        
		INTO #MCDXCDS2 FROM [196.1.115.204].MCDXCDS.DBO.TBLCATMUENU_CHANGE_AUDIT AS A ,[196.1.115.204].MCDXCDS.DBO.tblcategory AS B 
		WHERE  A.Fldcategory_new=B.fldcategorycode AND ACTION_MODIFIEDDATE  >=@FROMDATE AND ACTION_MODIFIEDDATE <=@TODATE + ' 23:59'  
		--
		SELECT A.LOGIN_ID,a.action_modifieddate,a.action_modifiedby,a.user_ip,a.hostname ,a.appname ,A.OLD_CATEGORY,A.fldcategoryname,B.NEW_CATEOGRY,
		B.fldcategoryname AS fldcategoryname_NEW ,A.MODIFIED_DATE
		INTO #MCDXCDS3 FROM #MCDXCDS1 A,#MCDXCDS2 B WHERE A.LOGIN_ID=B.LOGIN_ID
		--
		SELECT distinct LOGIN_ID,a.action_modifieddate,a.action_modifiedby,a.user_ip,a.hostname ,a.appname ,fldfirstname,fldlastname,OLD_CATEGORY,fldcategoryname,NEW_CATEOGRY,fldcategoryname_NEW,MODIFIED_DATE
		FROM #MCDXCDS3 A,[196.1.115.204].MCDXCDS.DBO.TBLPRADNYAUSERS B WHERE A.LOGIN_ID=B.fldusername
		order by 1,2        
 END               
            
 END

GO
