-- Object: PROCEDURE dbo.RPT_ACC_GLREPORT_SN
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------









/*  







RPT_ACC_GLREPORT '01/04/2011', '31/03/2012', 'Apr  1 2011', 'May 10 2011', '99988', '99988', 'region', 'ahmedabad', 'ahmedabad','vdt', 'Segment', 'codewise', 'GL',''  







  







*/  







CREATE PROC [dbo].[RPT_ACC_GLREPORT_SN]                  







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







 @REPORTOPT VARCHAR(10) = ''                 







                  







AS    







DECLARE                  







 @@OPENDATE AS VARCHAR(11),    







 @@COSTCODE AS SMALLINT,    







 @SHAREDB AS VARCHAR(25),    







 @@SQL AS VARCHAR(1000)    







  







SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                  







                  







SELECT @@OPENDATE = CONVERT(VARCHAR(11),SDTCUR,109) FROM PARAMETER WHERE @FDATE BETWEEN SDTCUR AND LDTCUR               







                  







SELECT CLTCODE,VAMT AS OPBAL INTO #OPBAL FROM LEDGER  WHERE 1 =2                  







            







CREATE TABLE [DBO].[#TEMPTABLE_GL] (                







  [BOOKTYPE] [CHAR] (2)  NULL ,                







  [VOUDT1] [VARCHAR] (20) NULL ,                







  [EFFDT1] [VARCHAR] (20) NULL ,                







  [SHORTDESC] [CHAR] (6) NULL ,                







  [DRAMT] [MONEY] NULL ,                







  [CRAMT] [MONEY] NULL ,                







  [VNO] [VARCHAR] (12) NULL ,                







  [NARRATION] [VARCHAR] (250) NULL ,            







  [DDNO] [VARCHAR] (15) NULL ,                







  [CLTCODE] [VARCHAR] (10) NOT NULL ,            







  [LONGNAME] [VARCHAR] (100) NULL ,            







  [VDT] [DATETIME] NULL ,                  







  [VTYP] [SMALLINT] NULL ,                







  [ACCAT] [VARCHAR] (30) NULL ,                







  [OPBAL] [MONEY] NULL ,                







  [CROSAC] [VARCHAR] (10) NULL ,                







  [ACNAME] [VARCHAR] (150) NULL ,             







  [BRANCHCODE] [VARCHAR] (20) NULL ,            







  [LNO][INT] NULL,            







 )        







 SET @SHAREDB = 'MSAJAG'  







 CREATE TABLE #COSTMAST  







 (  







  COSTCODE INT,  







  COSTNAME VARCHAR(50)  







 )  







  







 IF @STATUSID = 'REGION'  







 BEGIN  







  SET @@SQL = 'INSERT INTO #COSTMAST'  







  SET @@SQL = @@SQL + ' SELECT COSTCODE, COSTNAME FROM COSTMAST C,'+ @SHAREDB +'.DBO.REGION R WHERE REGIONCODE = RTRIM('+@STATUSNAME+') AND COSTNAME = BRANCH_CODE'  







 END  







  







 IF @STATUSID = 'AREA'  







 BEGIN  







  SET @@SQL = 'INSERT INTO #COSTMAST'  







  SET @@SQL = @@SQL + ' SELECT COSTCODE ,COSTNAME FROM COSTMAST C,'+ @SHAREDB +'.DBO.AREA A WHERE AREACODE = RTRIM('+@STATUSNAME+') AND COSTNAME = BRANCH_CODE'  







 END  







  







 IF @STATUSID = 'BRANCH'  







 BEGIN  







  SET @@SQL = 'INSERT INTO #COSTMAST'  







  SET @@SQL = @@SQL + ' SELECT COSTCODE FROM COSTMAST WHERE COSTNAME = RTRIM('+@STATUSNAME+')'  







 END  







 PRINT(@@SQL)    







 EXEC(@@SQL)  







  







  







--select @@costcode=costcode from costmast where costname=@BRANCH    







    







IF @SELECTIONBY = 'VDT'                  







 BEGIN                  







  IF RTRIM(@BRANCH) = '' OR RTRIM(@BRANCH) = '%'               







   BEGIN           







  INSERT INTO #OPBAL      







  SELECT CLTCODE, SUM(OPBAL) FROM                 







  (      







   SELECT                  







   CLTCODE,                  







   OPBAL = SUM(CASE DRCR WHEN 'D' THEN VAMT ELSE -VAMT END)                  







   FROM                  







   LEDGER      







   WHERE          







    CLTCODE BETWEEN @FCODE AND @TCODE                  







    AND VDT LIKE @@OPENDATE + '%' AND VTYP = 18              







   GROUP BY       







    CLTCODE    







       







   UNION ALL      







   SELECT                  







    CLTCODE,                  







    OPBAL = SUM(CASE DRCR WHEN 'D' THEN VAMT ELSE -VAMT END)       







   FROM                  







    LEDGER                  







   WHERE                  







    CLTCODE BETWEEN @FCODE AND @TCODE                  







    AND VDT >= @@OPENDATE AND VDT < @FDATE AND VTYP <> 18              







   GROUP BY CLTCODE       







   ) A      







   GROUP BY      







    CLTCODE      







   ORDER BY       







    CLTCODE          







               







                  







  INSERT INTO #TEMPTABLE_GL                  







  SELECT                  







   L.BOOKTYPE,                  







   VOUDT1=L.VDT,                  







   EFFDT1=L.EDT,                  







   ISNULL(SHORTDESC,'') SHORTDESC,                  







   DRAMT=(CASE WHEN UPPER(L.DRCR) = 'D' THEN VAMT ELSE 0 END),                  







   CRAMT=(CASE WHEN UPPER(L.DRCR) = 'C' THEN VAMT ELSE 0 END),                  







   L.VNO,                  







   REPLACE( L.NARRATION,'"','') NARRATION,                  







   DDNO=ISNULL((SELECT TOP 1 DDNO FROM LEDGER1 WHERE VTYP = L.VTYP AND VNO = L.VNO AND BOOKTYPE = L.BOOKTYPE AND LNO = L.LNO),''),                  







   L.CLTCODE,                  







   A.LONGNAME,                  







   VDT,                  







   L.VTYP,                  







   ACCAT,                  







   OPBAL=0,                  







   CROSAC='',                  







   A.ACNAME,            







   A.BRANCHCODE,                  







   L.LNO                  







  FROM                  







   LEDGER L,                  







   ACMAST A,                  







   VMAST V                  







  WHERE                  







   L.VDT BETWEEN @FDATE AND @TDATE + ' 23:59:59'                  







   AND VTYP = VTYPE                  







   AND L.CLTCODE = A.CLTCODE                  







   AND L.CLTCODE BETWEEN @FCODE AND @TCODE                  







   AND (A.ACCAT LIKE '3%'  OR A.ACCAT LIKE '14%'  OR A.ACCAT LIKE '103%')                  







  ORDER BY                  







   L.CLTCODE,                  







   VOUDT1,                  







   L.VTYP DESC,                  







   L.VNO                  







    END                  







   ELSE                  







    BEGIN         







     INSERT INTO #OPBAL                  







  SELECT                  







   CLTCODE,                  







   SUM(OPBAL) FROM     







   (    







   SELECT L2.CLTCODE ,SUM(CASE L2.DRCR WHEN 'D' THEN CAMT ELSE -CAMT END) AS OPBAL                  







  FROM                  







   LEDGER2 L2,                  







   LEDGER L  







  WHERE                  







   L2.CLTCODE BETWEEN @FCODE AND @TCODE                  







   AND L.VTYP=L2.VTYPE                  







   AND L.BOOKTYPE=L2.BOOKTYPE                  







   AND L.VNO=L2.VNO                  







   AND L.LNO=L2.LNO         







   --AND L2.COSTCODE = @@costcode                   







   --AND C.COSTNAME = @BRANCH               







   AND EXISTS(SELECT COSTCODE FROM #COSTMAST C WHERE L2.COSTCODE = C.COSTCODE)  







   AND VDT LIKE @@OPENDATE + '%' AND L2.VTYPE = 18          







  GROUP BY L2.CLTCODE                  







    







    UNION ALL    







         







    SELECT                  







     L2.CLTCODE,                  







     SUM(CASE L2.DRCR WHEN 'D' THEN CAMT ELSE -CAMT END) AS OPBAL                  







    FROM                  







     LEDGER2 L2,                  







     LEDGER L  







    WHERE                  







     L2.CLTCODE BETWEEN @FCODE AND @TCODE                  







     AND L.VTYP=L2.VTYPE                  







     AND L.BOOKTYPE=L2.BOOKTYPE                  







     AND L.VNO=L2.VNO                  







     AND L.LNO=L2.LNO       







 --AND L2.COSTCODE = @@costcode                  







 --AND C.COSTNAME = @BRANCH     







  AND EXISTS(SELECT COSTCODE FROM #COSTMAST C WHERE L2.COSTCODE = C.COSTCODE)             







     AND VDT >= @@OPENDATE AND VDT < @FDATE AND VTYPE <> 18                  







    GROUP BY L2.CLTCODE                  







    ) T1       







    GROUP BY CLTCODE                  







 ORDER BY CLTCODE           







    







                  







    INSERT INTO #TEMPTABLE_GL  







    SELECT                  







     L.BOOKTYPE,                  







     VOUDT1=L.VDT,                  







     EFFDT1=L.EDT,                  







     ISNULL(SHORTDESC,'') SHORTDESC,                  







     DRAMT=(CASE WHEN UPPER(L2.DRCR) = 'D' THEN CAMT ELSE 0 END),                  







     CRAMT=(CASE WHEN UPPER(L2.DRCR) = 'C' THEN CAMT ELSE 0 END),                  







     L.VNO,                  







     REPLACE( L.NARRATION,'"','') NARRATION,                  







     DDNO=ISNULL((SELECT TOP 1 DDNO FROM LEDGER1 WHERE VTYP = L.VTYP AND VNO = L.VNO AND BOOKTYPE = L.BOOKTYPE AND LNO = L.LNO),''),                  







     L2.CLTCODE,                  







     A.LONGNAME,                  







     VDT,                  







     L.VTYP,                  







     ACCAT,                  







     OPBAL=0,                  







     CROSAC='',                  







     A.ACNAME,                  







     A.BRANCHCODE,                  







     L.LNO                  







    FROM                  







     LEDGER L,                  







     VMAST V,                  







     LEDGER2 L2,                  







     ACMAST A/*,                  







     COSTMAST C*/   







    WHERE                  







     L.VDT BETWEEN @FDATE AND @TDATE + ' 23:59:59'                  







     AND L.VTYP = L2.VTYPE                  







     AND  L.VNO = L2.VNO                  







     AND L.LNO = L2.LNO                  







     AND L.BOOKTYPE = L2.BOOKTYPE                  







     AND L2.CLTCODE=A.CLTCODE                  







     AND L.VTYP = V.VTYPE                  







     AND L2.CLTCODE BETWEEN @FCODE AND  @TCODE                  







     AND A.ACCAT <> '4'                  







     --AND COSTNAME = RTRIM(@BRANCH)                  







     --AND L2.COSTCODE = C.COSTCODE     







  AND EXISTS(SELECT COSTCODE FROM #COSTMAST C WHERE L2.COSTCODE = C.COSTCODE)  







     AND  L2.VTYPE <> 18                  







    ORDER BY                  







     L2.CLTCODE,                  







     VOUDT1,          







     L.VTYP DESC,                  







     L.VNO                  







   END                  







 END                  







ELSE                  







 BEGIN                  







  IF RTRIM(@BRANCH) = '' OR RTRIM(@BRANCH) = '%'                  







   BEGIN                  







    INSERT INTO #OPBAL                  







    SELECT                  







     CLTCODE,                  







     SUM(OPBAL) OPBAL                  







    FROM                  







     (                  







      SELECT                  







       CLTCODE,                  






       SUM(CASE DRCR WHEN 'D' THEN VAMT ELSE -VAMT END) AS OPBAL                  







      FROM                  







       LEDGER                  







      WHERE                  







       CLTCODE BETWEEN @FCODE AND @TCODE                  







       AND VDT LIKE @@OPENDATE + '%' AND VTYP = 18       







              







      GROUP BY                  







       CLTCODE                  







  UNION ALL          







  SELECT                  







       CLTCODE,                  







       SUM(CASE DRCR WHEN 'D' THEN VAMT ELSE -VAMT END) AS OPBAL                  







      FROM                  







       LEDGER                  







      WHERE                  







       CLTCODE BETWEEN @FCODE AND @TCODE                  







       AND EDT >= @@OPENDATE AND EDT < @FDATE AND VTYP <> 18                  







      GROUP BY                  







       CLTCODE             







     UNION ALL                  







      SELECT                  







       CLTCODE,                  







       SUM(CASE DRCR WHEN 'C' THEN VAMT ELSE -VAMT END) AS OPBAL                  







      FROM                  







       LEDGER                  







      WHERE                  







       CLTCODE BETWEEN  @FCODE AND  @TCODE                  







       AND VDT < @@OPENDATE                  







       AND EDT >= @@OPENDATE                  







       GROUP BY CLTCODE                  







     ) T                  







    GROUP BY CLTCODE                  







    ORDER BY CLTCODE                  







                  







    INSERT INTO #TEMPTABLE_GL                  







    SELECT       







     L.BOOKTYPE,                  







     VOUDT1=L.VDT,                  







     EFFDT1=L.EDT,                  







     ISNULL(SHORTDESC,'') SHORTDESC,                  







     DRAMT=(CASE WHEN UPPER(L.DRCR) = 'D' THEN VAMT ELSE 0 END),                  







     CRAMT=(CASE WHEN UPPER(L.DRCR) = 'C' THEN VAMT ELSE 0 END),                  







     L.VNO,                  







     REPLACE( L.NARRATION,'"','') NARRATION,                  







     DDNO=ISNULL((SELECT TOP 1 DDNO FROM LEDGER1 WHERE VTYP = L.VTYP AND VNO = L.VNO AND BOOKTYPE = L.BOOKTYPE AND LNO = L.LNO),''),               







     L.CLTCODE,                  







     A.LONGNAME,                  







     VDT,                  







     L.VTYP,                  







     ACCAT,                  







     OPBAL=0,                  







     CROSAC='',                  







     A.ACNAME,                  







     A.BRANCHCODE,                  







     L.LNO                  







    FROM                  







     LEDGER L,                  







     ACMAST A,                  







     VMAST V                  







    WHERE                  







     VTYP = VTYPE                  







     AND A.CLTCODE = L.CLTCODE                  







     AND L.CLTCODE BETWEEN @FCODE AND @TCODE                  







     AND  L.EDT BETWEEN @FDATE AND @TDATE + ' 23:59:59'                  







     AND L.VTYP <> 18                  







     AND (A.ACCAT LIKE '3%'  OR A.ACCAT LIKE '14%'  OR A.ACCAT LIKE '103%')                  







    ORDER BY                  







     L.CLTCODE,                  







     VOUDT1,                  







     L.VTYP DESC,                  







     L.VNO                  







   END                  







  ELSE                  







   BEGIN         







print 'nse'             







    INSERT INTO #OPBAL                  







    SELECT                  







     CLTCODE,                  







     SUM(OPBAL) OPBAL                  







    FROM                  







     (                  







      SELECT                  







       L2.CLTCODE,                  







  SUM(CASE L2.DRCR WHEN 'D' THEN CAMT ELSE -CAMT END) AS OPBAL                  







      FROM                  







       LEDGER2 L2,                  







       LEDGER L --, COSTMAST C                







      WHERE                  







       VDT LIKE @@OPENDATE + '%' AND VTYPE = 18          







       AND L.VNO=L2.VNO                  







       AND L.VTYP=L2.VTYPE                  







       AND L.BOOKTYPE=L2.BOOKTYPE                  







       AND L.LNO=L2.LNO       







  --AND L2.COSTCODE = @@costcode                  







        --AND C.COSTNAME = @BRANCH                







  AND EXISTS(SELECT COSTCODE FROM #COSTMAST C WHERE L2.COSTCODE = C.COSTCODE)  







        AND L2.CLTCODE BETWEEN @FCODE AND @TCODE                  







      GROUP BY                  







       L2.CLTCODE                  







      UNION ALL                  







   SELECT                  







       L2.CLTCODE,                  







       SUM(CASE L2.DRCR WHEN 'D' THEN CAMT ELSE -CAMT END) AS OPBAL                  







      FROM                  







       LEDGER2 L2,                  







       LEDGER L    --, COSTMAST C                           







      WHERE                  







       EDT >= @@OPENDATE AND EDT < @FDATE AND VTYPE <> 18          







       AND L.VNO=L2.VNO                  







       AND L.VTYP=L2.VTYPE                  







       AND L.BOOKTYPE=L2.BOOKTYPE                







       AND L.LNO=L2.LNO            







       --AND L2.COSTCODE = @@costcode                







       --AND C.COSTNAME = @BRANCH                







       AND EXISTS(SELECT COSTCODE FROM #COSTMAST C WHERE L2.COSTCODE = C.COSTCODE)  







       AND L2.CLTCODE BETWEEN @FCODE AND @TCODE                  







      GROUP BY                  







       L2.CLTCODE                  







      UNION ALL          







       SELECT                  







        L2.CLTCODE,                  







        SUM(CASE L2.DRCR WHEN 'C' THEN CAMT ELSE -CAMT END) AS OPBAL                  







       FROM                  







        LEDGER2 L2,                  







        LEDGER L , COSTMAST C   







       WHERE                  







        L.VNO=L2.VNO                  







        AND L.VTYP=L2.VTYPE                  







        AND L.BOOKTYPE=L2.BOOKTYPE                  







        AND L.LNO=L2.LNO                  







        AND VDT < @@OPENDATE                  







        AND EDT >= @@OPENDATE       







  AND L2.COSTCODE = @@costcode                   







  AND C.COSTNAME = @BRANCH                







        AND L2.CLTCODE BETWEEN @FCODE AND @TCODE                  







       GROUP BY                  







        L2.CLTCODE                  







     ) T                  







    GROUP BY                  







     CLTCODE                  







    ORDER BY                  







    CLTCODE                  







    INSERT INTO #TEMPTABLE_GL                  







    SELECT                  







     L.BOOKTYPE,          







     VOUDT1=L.VDT,                  







     EFFDT1=L.EDT,                  







     ISNULL(SHORTDESC,'') SHORTDESC,                  







     DRAMT=(CASE WHEN UPPER(L2.DRCR) = 'D' THEN CAMT ELSE 0 END),                  







     CRAMT=(CASE WHEN UPPER(L2.DRCR) = 'C' THEN CAMT ELSE 0 END),                  







     L.VNO,                  







     REPLACE(L.NARRATION,'"','') NARRATION,                  







     DDNO=ISNULL((SELECT TOP 1 DDNO FROM LEDGER1 WHERE VTYP = L.VTYP AND VNO = L.VNO AND BOOKTYPE = L.BOOKTYPE AND LNO = L.LNO),''),                  







     L2.CLTCODE,                  







     A.LONGNAME,                  







     VDT,                  







     L.VTYP,                  







     ACCAT,               







     OPBAL=0,                  







     CROSAC='',                  







     A.ACNAME,                  







     A.BRANCHCODE,                  







     L.LNO                  







    FROM                  







     LEDGER L,                  







     VMAST V,                  







     LEDGER2 L2,                  







     ACMAST A/*,                  







     COSTMAST C */                 







    WHERE                  







     L.VNO = L2.VNO                  







     AND L.VTYP = L2.VTYPE                  







     AND L.BOOKTYPE = L2.BOOKTYPE                  







     AND L.LNO = L2.LNO                  







     AND A.CLTCODE = L2.CLTCODE                  







     AND L2.CLTCODE BETWEEN @FCODE AND @TCODE                  







     AND L.VTYP = V.VTYPE                  







     AND A.ACCAT <> '4'                  







     AND L2.CLTCODE=A.CLTCODE                  







     --AND COSTNAME = RTRIM(@BRANCH)                  







  AND EXISTS(SELECT COSTCODE FROM #COSTMAST C WHERE L2.COSTCODE = C.COSTCODE)     







     AND L2.VTYPE <> 18                  







     AND L2.COSTCODE = C.COSTCODE                  







     AND  L.EDT BETWEEN @FDATE AND @TDATE + ' 23:59:59'                  







    ORDER BY                  







     L2.CLTCODE,                  







     VOUDT1,                  







     L.VTYP DESC,                  







     L.VNO                  







   END                  







 END                  







                  







UPDATE                  







 #TEMPTABLE_GL                  







SET                  







 OPBAL = L.OPBAL                  







FROM                  







 #OPBAL L            







WHERE                  







 #TEMPTABLE_GL.CLTCODE = L.CLTCODE                  







             







UPDATE                  







 #TEMPTABLE_GL                  







SET                  







 CROSAC = L.CLTCODE                  







FROM                  







 LEDGER L                  







WHERE                  







 L.VTYP IN('2','3')                  







 AND #TEMPTABLE_GL.VTYP = L.VTYP                  







 AND #TEMPTABLE_GL.BOOKTYPE = L.BOOKTYPE                  







 AND #TEMPTABLE_GL.VNO = L.VNO                  







 AND #TEMPTABLE_GL.CLTCODE <> L.CLTCODE                  







                  







UPDATE                  







 #TEMPTABLE_GL                  







SET                  







 BRANCHCODE = COSTNAME                  







FROM                  







 LEDGER2 L2,                  







 #COSTMAST C                  







WHERE                  







 #TEMPTABLE_GL.VNO = L2.VNO                  







 AND #TEMPTABLE_GL.VTYP = L2.VTYPE                  







 AND #TEMPTABLE_GL.BOOKTYPE = L2.BOOKTYPE               







 AND #TEMPTABLE_GL.LNO = L2.LNO                  







 AND #TEMPTABLE_GL.CLTCODE = L2.CLTCODE                  







 AND L2.COSTCODE = C.COSTCODE              







        







DELETE #TEMPTABLE_GL WHERE  VTYP=18      



 



 IF @FCODE ='61310' 







	BEGIN 



	DELETE #TEMPTABLE_GL WHERE  CLTCODE ='61310' AND vtyp=8 AND NARRATION LIKE 'Subscription Based Brokerage Debited for the per%'



	



	SELECT                  







    OPBALT = ISNULL(SUM(CASE DRCR WHEN 'D' THEN VAMT ELSE -VAMT END) *-1,0)    INTO  #T  



	 



	   FROM                  







	 LEDGER                  







	 WHERE                  







	 CLTCODE ='61310'                







	 AND VDT >= @@OPENDATE AND VDT < @FDATE AND VTYP =8     AND NARRATION LIKE 'Subscription Based Brokerage Debited for the per%'



	



	UPDATE   #OPBAL SET OPBAL=OPBAL+OPBALT FROM  #T



	UPDATE #TEMPTABLE_GL SET OPBAL=OPBAL+OPBALT  FROM  #T



  END 



        







INSERT INTO #TEMPTABLE_GL        







SELECT '','','','',0,0,'','','',CLTCODE,'','',18,'',OPBAL,CLTCODE,'','',''                    







FROM #OPBAL WHERE CLTCODE NOT IN (SELECT CLTCODE FROM #TEMPTABLE_GL WHERE VTYP<>18)             







               







SELECT                  







 BOOKTYPE,                  







 VOUDT = CONVERT(VARCHAR(11),CONVERT(DATETIME, CONVERT(VARCHAR(11), VOUDT1, 109)), 103),        







 EFFDT = CONVERT(VARCHAR(11), CONVERT(DATETIME, CONVERT(VARCHAR(11), EFFDT1, 109)), 103),        







 SHORTDESC,                  







 DRAMT,                  







 CRAMT,                  







 VNO,                  







 NARRATION,                  







 DDNO,                  







 CLTCODE,                  







 LONGNAME,                  







 VDT,          







 VTYP,                  







 ACCAT,                  







 OPBAL,                  







 CROSAC,                  







 ACNAME,                  







 BRANCHCODE,                  







 LNO                  







FROM                  







 #TEMPTABLE_GL        







ORDER BY                  







 CLTCODE,







VDT

GO
