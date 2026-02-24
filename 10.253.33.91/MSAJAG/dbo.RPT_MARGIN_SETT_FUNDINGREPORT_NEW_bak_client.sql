-- Object: PROCEDURE dbo.RPT_MARGIN_SETT_FUNDINGREPORT_NEW_bak_client
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROC [DBO].[RPT_MARGIN_SETT_FUNDINGREPORT_NEW_bak_client]                

@FDATE VARCHAR(11),                

@TDATE VARCHAR(11),                

@REPOPTION VARCHAR(1)                

AS                

                

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                

              

SELECT *, CL_TYPE = CONVERT(VARCHAR(3), '') INTO #V2_CLIENTFUNDINGDATA              

FROM V2_CLIENTFUNDINGDATA              

WHERE RUNDATE BETWEEN @FDATE AND @TDATE + ' 23:59:59'                

              

UPDATE #V2_CLIENTFUNDINGDATA               

SET PARTY_CODE = PARENTCODE, CL_TYPE = C1.CL_TYPE              

FROM CLIENT1 C1, CLIENT2 C2              

WHERE C1.CL_CODE = C2.CL_CODE              

AND C2.PARTY_CODE = #V2_CLIENTFUNDINGDATA.PARTY_CODE              

              

DELETE FROM #V2_CLIENTFUNDINGDATA               

WHERE CL_TYPE='PRO'        

        

/* TO SELECT MAX FUNDING DATE */        

SELECT                 

   BILLAMOUNT = 0.00,                 

   INSTAMT = CONVERT(NUMERIC(18,2), MAX(INS_TOTALFUNDING)),                 

   NONINSTAMT = CONVERT(NUMERIC(18,2), MAX(NRM_TOTALFUNDING)),                 

   EXTFUND = 0.00,                 

   TOTALAMOUNT = CONVERT(NUMERIC(18,2), MAX(INS_TOTALFUNDING) + MAX(NRM_TOTALFUNDING)),                 

   PARTY_CODE_CNT = MAX(PARTY_CODE_CNT),          

 RUNDATE = RUNDATE        

INTO #V2_CLIENTFUNDINGDATA1              

  FROM                 

   (                 

     SELECT                 

      RUNDATE = CONVERT(VARCHAR(11), RUNDATE, 109),                 

      NRM_TOTALFUNDING = ABS(SUM(CASE WHEN CL_TYPE <> 'INS' THEN TOTALFUNDING ELSE 0 END)),                 

      INS_TOTALFUNDING= ABS(SUM(CASE WHEN CL_TYPE = 'INS' THEN TOTALFUNDING ELSE 0 END)),                 

      PARTY_CODE_CNT = 0                 

     FROM #V2_CLIENTFUNDINGDATA V                 

     WHERE RUNDATE BETWEEN @FDATE AND @TDATE + ' 23:59:59'                 

     -- AND (VARMARGIN < -100000 OR BILLAMOUNT < -100000)           

 AND TOTALFUNDING < -100000                 

     GROUP BY CONVERT(VARCHAR(11), RUNDATE, 109)                 

    UNION ALL                 

     SELECT                 

      RUNDATE = '',                 

      NRM_TOTALFUNDING = 0,                 

      INS_TOTALFUNDING = 0,              

      PARTY_CODE_CNT = COUNT(DISTINCT PARTY_CODE)                 

     FROM #V2_CLIENTFUNDINGDATA V                 

     WHERE RUNDATE BETWEEN @FDATE AND @TDATE + ' 23:59:59'                 

      AND TOTALFUNDING < -100000                 

   )                 

   A         

GROUP BY RUNDATE         

        

        

SELECT  RUNDATE,MAX(TOTALAMOUNT)AS AMT INTO #V2_CLIENTFUNDINGDATA2 FROM #V2_CLIENTFUNDINGDATA1        

GROUP BY RUNDATE        

ORDER BY AMT DESC        

/*------------------------------------*/        

             

              

IF @REPOPTION <> 'M' AND @REPOPTION <> 'B' AND @REPOPTION <> 'T'                

 BEGIN                

  SELECT                 

   MARGINFUNDING = 0,                

   INSTAMT = 0,                 

   NONINSTAMT = 0,                 

   TOTALAMOUNT = 0,                 

   EXTFUND = 0,                 

   PARTY_CODE_CNT = 0                

 END                

                

IF @REPOPTION = 'M'                

 BEGIN                

  SELECT                 
   party_code,
   BILLFUNDING = 0.00,                 

   INSTAMT = CONVERT(NUMERIC(18,2), MAX(INS_MARGINFUNDING)),                 

   NONINSTAMT = CONVERT(NUMERIC(18,2), MAX(NRM_MARGINFUNDING)),                 

   EXTFUND = 0.00,                 

   TOTALAMOUNT = CONVERT(NUMERIC(18,2), MAX(INS_MARGINFUNDING) + MAX(NRM_MARGINFUNDING)),                 

   PARTY_CODE_CNT = MAX(PARTY_CODE_CNT)          

  FROM                 

   (                 

     SELECT                 
	  party_code,
      RUNDATE = CONVERT(VARCHAR(11), RUNDATE, 109),                 

      NRM_MARGINFUNDING = ABS(SUM(CASE WHEN CL_TYPE <> 'INS' THEN MARGINFUNDING ELSE 0 END)),                 

   INS_MARGINFUNDING = ABS(SUM(CASE WHEN CL_TYPE = 'INS' THEN MARGINFUNDING ELSE 0 END)),                  

      PARTY_CODE_CNT = 0               

     FROM #V2_CLIENTFUNDINGDATA V                 

     WHERE  /*RUNDATE BETWEEN @FDATE AND @TDATE + ' 23:59:59' */        

RUNDATE  IN (SELECT TOP 1 RUNDATE FROM #V2_CLIENTFUNDINGDATA2)               

      --AND VARMARGIN < -100000           

--AND MARGINFUNDING < -100000  

 AND TOTALFUNDING < -100000                

     GROUP BY CONVERT(VARCHAR(11), RUNDATE, 109)    ,party_code                 

    UNION ALL          

     SELECT                 
	  party_code,
      RUNDATE = '',                 

      NRM_MARGINFUNDING = 0,              

   INS_MARGINFUNDING = 0,              

      PARTY_CODE_CNT = COUNT(DISTINCT PARTY_CODE)                 

     FROM #V2_CLIENTFUNDINGDATA V                 

     WHERE RUNDATE BETWEEN @FDATE AND @TDATE + ' 23:59:59'                 

      --AND VARMARGIN < -100000                 

AND MARGINFUNDING < -100000                 
GROUP BY CONVERT(VARCHAR(11), RUNDATE, 109)    ,party_code   
   )                 

   A                 
   GROUP BY CONVERT(VARCHAR(11), RUNDATE, 109)    ,party_code   
 END                

                

IF @REPOPTION = 'B'                

 BEGIN                

  SELECT                 
  party_code  ,
   BILLAMOUNT = 0.00,                 

   INSTAMT = CONVERT(NUMERIC(18,2), MAX(INS_BILLAMOUNT)),                 

   NONINSTAMT = CONVERT(NUMERIC(18,2), MAX(NRM_BILLAMOUNT)),                 

   EXTFUND = 0.00,                 

   TOTALAMOUNT = CONVERT(NUMERIC(18,2), MAX(INS_BILLAMOUNT) + MAX(NRM_BILLAMOUNT)),                 

   PARTY_CODE_CNT = MAX(PARTY_CODE_CNT)                 

  FROM                 

   (                 

     SELECT     party_code  ,            

      RUNDATE = CONVERT(VARCHAR(11), RUNDATE, 109),                 

      NRM_BILLAMOUNT = ABS(SUM(CASE WHEN CL_TYPE <> 'INS' THEN BILLFUNDING ELSE 0 END)),                 

   INS_BILLAMOUNT = ABS(SUM(CASE WHEN CL_TYPE = 'INS' THEN BILLFUNDING ELSE 0 END)),                 

      PARTY_CODE_CNT = 0                 

     FROM #V2_CLIENTFUNDINGDATA V                

     WHERE /*RUNDATE BETWEEN @FDATE AND @TDATE + ' 23:59:59' */        

RUNDATE  IN (SELECT TOP 1 RUNDATE FROM #V2_CLIENTFUNDINGDATA2)                   

      --AND BILLAMOUNT < -100000                 

--AND BILLFUNDING < -100000

 AND TOTALFUNDING < -100000                   

      GROUP BY CONVERT(VARCHAR(11), RUNDATE, 109)   ,Party_Code                

    UNION ALL              

     SELECT                 
	 party_code , 
      RUNDATE = '',                 

      NRM_BILLAMOUNT = 0,              

   INS_BILLAMOUNT = 0,              

      PARTY_CODE_CNT=ISNULL(COUNT(1),0 ) FROM (SELECT DISTINCT PARTY_CODE                  

     FROM #V2_CLIENTFUNDINGDATA V                 

     WHERE RUNDATE BETWEEN @FDATE AND @TDATE + ' 23:59:59'                 

--      AND BILLAMOUNT < -100000     

      AND BILLFUNDING < -100000     
	  GROUP BY CONVERT(VARCHAR(11), RUNDATE, 109)   ,Party_Code  
    

) V                

    )                 

   A                 
   GROUP BY CONVERT(VARCHAR(11), RUNDATE, 109)   ,Party_Code  
 END          

IF @REPOPTION = 'T'                

 BEGIN                

  SELECT                 
  party_code  ,
   BILLAMOUNT = 0.00,                 

   INSTAMT = CONVERT(NUMERIC(18,2), MAX(INS_TOTALFUNDING)),                 

   NONINSTAMT = CONVERT(NUMERIC(18,2), MAX(NRM_TOTALFUNDING)),                 

   EXTFUND = 0.00,                 

   TOTALAMOUNT = CONVERT(NUMERIC(18,2), MAX(INS_TOTALFUNDING) + MAX(NRM_TOTALFUNDING)),                 

  PARTY_CODE_CNT = MAX(PARTY_CODE_CNT)              

  FROM                 

   (                 

     SELECT                 
	 party_code,
      RUNDATE = CONVERT(VARCHAR(11), RUNDATE, 109),                 

      NRM_TOTALFUNDING = ABS(SUM(CASE WHEN CL_TYPE <> 'INS' THEN TOTALFUNDING ELSE 0 END)),                 

   INS_TOTALFUNDING= ABS(SUM(CASE WHEN CL_TYPE = 'INS' THEN TOTALFUNDING ELSE 0 END)),                 

      PARTY_CODE_CNT = 0                 

     FROM #V2_CLIENTFUNDINGDATA V                 

     WHERE RUNDATE BETWEEN @FDATE AND @TDATE + ' 23:59:59'         

      --AND (VARMARGIN < -100000 OR BILLAMOUNT < -100000)      

AND TOTALFUNDING <-100000                

     GROUP BY CONVERT(VARCHAR(11), RUNDATE, 109)   ,Party_Code              

    UNION ALL                 

     SELECT                 
	 party_code,
      RUNDATE = '',                 

      NRM_TOTALFUNDING = 0,                 

      INS_TOTALFUNDING = 0,              

      PARTY_CODE_CNT = COUNT(DISTINCT PARTY_CODE)                 

     FROM #V2_CLIENTFUNDINGDATA V                 

     WHERE RUNDATE BETWEEN @FDATE AND @TDATE + ' 23:59:59'                 

      AND TOTALFUNDING < -100000                 
	  GROUP BY CONVERT(VARCHAR(11), RUNDATE, 109)   ,Party_Code  
   )                 

   A                
   GROUP BY CONVERT(VARCHAR(11), RUNDATE, 109)   ,Party_Code  
 END

GO
