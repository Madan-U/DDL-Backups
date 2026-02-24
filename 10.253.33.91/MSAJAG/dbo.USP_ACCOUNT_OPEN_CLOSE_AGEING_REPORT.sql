-- Object: PROCEDURE dbo.USP_ACCOUNT_OPEN_CLOSE_AGEING_REPORT
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROCEDURE USP_ACCOUNT_OPEN_CLOSE_AGEING_REPORT      
(      
  @FromDate DATE ,      
  @EndDate  DATE ,      
  @Ageing INT      
)      
AS      
      
BEGIN      
      
--DECLARE @FromDate DATE       
--DECLARE @EndDate  DATE       
--DECLARE @Ageing INT      
      
--SET @FromDate ='2022-02-01'      
--SET @EndDate  ='2022-03-31'      
--SET @Ageing =7      
      
IF (DATEDIFF(DD,@FromDate,@EndDate) >61)      
BEGIN      
SELECT 'Data range should be 60 days '      
return ;      
END      
      
IF OBJECT_ID('tempdb..#ClientBrokDetais_Temp') IS NOT NULL      
        Drop table #ClientBrokDetais_Temp      
      
SELECT * INTO #ClientBrokDetais_Temp       
       FROM Msajag.dbo.[CLIENT_BROK_DETAILS] WITH(NOLOCK)       
WHERE Active_Date >=@FromDate  and Active_Date <= @EndDate      
      AND DATEDIFF(DD,Active_Date,InActive_From) <=@Ageing      
      
--B2B/B2C        
--SB TAG   - AIGR      
CREATE INDEX IX_#ClientBrokDetais_Temp_CL_Code ON #ClientBrokDetais_Temp (CL_Code)      
--CREATE INDEX IX_#ClientBrokDetais_Temp ON #ClientBrokDetais_Temp (Active_Date,InActive_From)      
       
        
       
IF OBJECT_ID('tempdb..#ClientBrokDetais_Temp_DTL') IS NOT NULL      
        DROP TABLE #ClientBrokDetais_Temp_DTL      
      
SELECT A.*, B.branch_cd,sub_broker        
           INTO #ClientBrokDetais_Temp_DTL      
FROM #ClientBrokDetais_Temp A       
INNER JOIN Msajag.dbo.CLIENT_DETAILS B ON A.CL_Code =B.CL_Code      
       
--WHERE Exists (select * from #ClientBrokDetais_Temp X where  X.CL_Code=A.CL_Code)      
--and branch_cd like '%DIY%'      
       
--select X.*,branch_cd,sub_broker  from #ClientBrokDetais_Temp X       
--WHERE Exists (select branch_cd,sub_broker from Msajag.dbo.CLIENT_DETAILS A where  X.CL_Code=A.CL_Code) Y      
--and branch_cd like '%DIY%'      
       
CREATE INDEX IX#ClientBrokDetais_Temp_DTL ON  #ClientBrokDetais_Temp_DTL(Cl_Code) INCLUDE (Active_Date,InActive_From)      
      
IF OBJECT_ID(N'TEMPDB..#PARTYDETAILS', N'U') IS NOT NULL        
        DROP TABLE #PARTYDETAILS;        
select CL_Code CLCode INTO #PARTYDETAILS from #ClientBrokDetais_Temp_DTL      
GROUP BY CL_Code      
CREATE INDEX IX_#PARTYDETAILS On #PARTYDETAILS(CLCode)      
       
IF OBJECT_ID(N'TEMPDB..#TEMP1', N'U') IS NOT NULL        
   DROP TABLE #TEMP1;       
SELECT PARTY_CODE,MAX(SAUDA_DATE) AS LAST_TRADE_DT,MIN(SAUDA_DATE) AS FIRST_TRADE_DT,'NSE' AS SEG       
      INTO #TEMP1       
      FROM MSAJAG.DBO.CMBILLVALAN WITH (NOLOCK)       
      WHERE EXISTS (SELECT X.CLCode from #PARTYDETAILS X where X.CLCode=PARTY_CODE)      
      GROUP BY PARTY_CODE      
ALTER TABLE #TEMP1      
ALTER COLUMN PARTY_CODE VARCHAR(20)       
ALTER TABLE #TEMP1      
ALTER COLUMN SEG VARCHAR(10)      
             
INSERT INTO #TEMP1      
SELECT PARTY_CODE,MAX(SAUDA_DATE) AS LAST_TRADE_DT,MIN(SAUDA_DATE) AS FIRST_TRADE_DT ,'BSE' AS SEG       
      FROM [AngelBSECM].BSEDB_AB.DBO.CMBILLVALAN Y WITH (NOLOCK)      
      WHERE EXISTS (SELECT X.CLCode from #PARTYDETAILS X where X.CLCode=Y.PARTY_CODE)      
      GROUP BY PARTY_CODE      
      
            
INSERT INTO #TEMP1      
SELECT PARTY_CODE,MAX(SAUDA_DATE) AS LAST_TRADE_DT,MIN(SAUDA_DATE) AS FIRST_TRADE_DT ,'NSEFO' AS SEG       
      FROM [AngelFO].NSEFO.DBO.FOBILLVALAN Y WITH (NOLOCK)       
      WHERE EXISTS (SELECT X.CLCode from #PARTYDETAILS X where X.CLCode=Y.PARTY_CODE)      
      GROUP BY PARTY_CODE      
      
INSERT INTO #TEMP1      
SELECT Y.PARTY_CODE,MAX(SAUDA_DATE) AS LAST_TRADE_DT,MIN(SAUDA_DATE) AS FIRST_TRADE_DT ,'NSX' AS SEG       
      FROM [AngelFO].NSECURFO.DBO.FOBILLVALAN Y WITH (NOLOCK)       
      WHERE EXISTS (SELECT X.CLCode from #PARTYDETAILS X where X.CLCode=Y.PARTY_CODE)      
      GROUP BY Y.PARTY_CODE      
      
INSERT INTO #TEMP1      
SELECT PARTY_CODE,MAX(SAUDA_DATE) AS LAST_TRADE_DT,MIN(SAUDA_DATE) AS FIRST_TRADE_DT ,'MCDX' AS SEG       
      FROM [AngelCommodity].MCDX.DBO.FOBILLVALAN WITH (NOLOCK)       
      WHERE EXISTS (SELECT X.CLCode from #PARTYDETAILS X where X.CLCode=PARTY_CODE)      
      GROUP BY PARTY_CODE      
      
INSERT INTO #TEMP1      
SELECT PARTY_CODE,MAX(SAUDA_DATE) AS LAST_TRADE_DT,MIN(SAUDA_DATE) AS FIRST_TRADE_DT ,'NCDX' AS SEG       
      FROM [AngelCommodity].NCDX.DBO.FOBILLVALAN WITH (NOLOCK)       
      WHERE EXISTS (SELECT X.CLCode from #PARTYDETAILS X where X.CLCode=PARTY_CODE)      
      GROUP BY PARTY_CODE      
      
INSERT INTO #TEMP1      
SELECT PARTY_CODE,MAX(SAUDA_DATE) AS LAST_TRADE_DT,MIN(SAUDA_DATE) AS FIRST_TRADE_DT ,'MCD' AS SEG       
      FROM [AngelCommodity].MCDXCDS.DBO.FOBILLVALAN WITH (NOLOCK)       
      WHERE EXISTS (SELECT X.CLCode from #PARTYDETAILS X where X.CLCode=PARTY_CODE)      
      GROUP BY PARTY_CODE      
      
IF OBJECT_ID(N'TEMPDB..#TEMP2', N'U') IS NOT NULL        
   DROP TABLE #TEMP2;       
SELECT PARTY_CODE,MAX(SAUDA_DATE) AS LAST_TRADE_DT,MIN(SAUDA_DATE) AS FIRST_TRADE_DT ,'NSE' AS SEG       
INTO #TEMP2 FROM [172.31.16.30].MSAJAG.DBO.CMBILLVALAN WITH (NOLOCK)       
WHERE EXISTS (SELECT X.CLCode from #PARTYDETAILS X where X.CLCode=PARTY_CODE)      
GROUP BY PARTY_CODE      
      
ALTER TABLE #TEMP2      
ALTER COLUMN PARTY_CODE VARCHAR(20)       
ALTER TABLE #TEMP2      
ALTER COLUMN SEG VARCHAR(10)      
      
      
INSERT INTO #TEMP2      
SELECT PARTY_CODE,MAX(SAUDA_DATE) AS LAST_TRADE_DT,MIN(SAUDA_DATE) AS FIRST_TRADE_DT ,'BSE' AS SEG       
FROM  [172.31.16.30].BSEDB_AB.DBO.CMBILLVALAN WITH (NOLOCK)       
WHERE EXISTS (SELECT X.CLCode from #PARTYDETAILS X where X.CLCode=PARTY_CODE)      
GROUP BY PARTY_CODE      
UNION      
SELECT PARTY_CODE,MAX(SAUDA_DATE) AS LAST_TRADE_DT,MIN(SAUDA_DATE) AS FIRST_TRADE_DT ,'NSEFO' AS SEG       
FROM  [172.31.16.30].NSEFO.DBO.FOBILLVALAN WITH (NOLOCK)       
WHERE EXISTS (SELECT X.CLCode from #PARTYDETAILS X where X.CLCode=PARTY_CODE)      
GROUP BY PARTY_CODE      
UNION      
SELECT PARTY_CODE,MAX(SAUDA_DATE) AS LAST_TRADE_DT,MIN(SAUDA_DATE) AS FIRST_TRADE_DT ,'NSX' AS SEG       
FROM  [172.31.16.30].NSECURFO.DBO.FOBILLVALAN WITH (NOLOCK)       
WHERE EXISTS (SELECT X.CLCode from #PARTYDETAILS X where X.CLCode=PARTY_CODE)      
GROUP BY PARTY_CODE      
UNION      
SELECT PARTY_CODE,MAX(SAUDA_DATE) AS LAST_TRADE_DT,MIN(SAUDA_DATE) AS FIRST_TRADE_DT ,'MCD' AS SEG       
FROM  [172.31.16.30].MCDXCDS.DBO.FOBILLVALAN WITH (NOLOCK)       
WHERE EXISTS (SELECT X.CLCode from #PARTYDETAILS X where X.CLCode=PARTY_CODE)      
GROUP BY PARTY_CODE      
UNION      
SELECT PARTY_CODE,MAX(SAUDA_DATE) AS LAST_TRADE_DT,MIN(SAUDA_DATE) AS FIRST_TRADE_DT ,'MCDX' AS SEG       
FROM  [196.1.115.206].MCDX.DBO.FOBILLVALAN WITH (NOLOCK)       
WHERE EXISTS (SELECT X.CLCode from #PARTYDETAILS X where X.CLCode=PARTY_CODE)      
GROUP BY PARTY_CODE      
UNION      
SELECT PARTY_CODE,MAX(SAUDA_DATE) AS LAST_TRADE_DT,MIN(SAUDA_DATE) AS FIRST_TRADE_DT ,'NCDX' AS SEG       
FROM  [196.1.115.206].NCDX.DBO.FOBILLVALAN WITH (NOLOCK)       
WHERE EXISTS (SELECT X.CLCode from #PARTYDETAILS X where X.CLCode=PARTY_CODE)      
GROUP BY PARTY_CODE      
      
         
  ;WITH A      
  AS      
  (      
  SELECT * , ROW_NUMBER() OVER(PARTITION BY PARTY_CODE ,LAST_TRADE_DT ,FIRST_TRADE_DT, SEG ORDER BY LAST_TRADE_DT DESC) RNK      
             FROM #TEMP1      
  )      
  DELETE from A where RNK>1      
      
  IF OBJECT_ID(N'TEMPDB..#XYZZZ', N'U') IS NOT NULL        
     DROP TABLE #XYZZZ;      
  SELECT * INTO #XYZZZ FROM #TEMP1      
  UNION      
  SELECT * FROM #TEMP2      
       
  create INDEX ix_#XYZZZ ON #XYZZZ (PARTY_CODE)      
      
--select * from #XYZZZ      
  ;WITH A      
  AS      
  (      
  SELECT * , ROW_NUMBER() OVER(PARTITION BY PARTY_CODE ,LAST_TRADE_DT ,FIRST_TRADE_DT, SEG ORDER BY LAST_TRADE_DT DESC) RNK      
  from #XYZZZ      
  )      
  DELETE from A where RNK>1      
      
--select * from #ClientBrokDetais_Temp_DTL      
          
  ;WITH A      
  AS      
  (      
  SELECT * , ROW_NUMBER() OVER(PARTITION BY Cl_Code ,Active_Date,InActive_From,Deactive_Remarks,branch_cd,sub_broker        
              ORDER BY InActive_From DESC) RNK      
  from #ClientBrokDetais_Temp_DTL      
  )      
 DELETE from A where RNK>1      
      
      
  SELECT       
      Cl_Code[ClientId],branch_cd Branch,sub_broker   SB,Active_Date  , InActive_From  CloseDT,      
      Deactive_Remarks [Reason_of_accountclosure] ,Deactive_value ,      
      FIRST_TRADE_DT,LAST_TRADE_DT, SEG , DATEDIFF(DD,Active_Date  , InActive_From) Ageing       
  FROM #ClientBrokDetais_Temp_DTL  A       
  LEFT OUTER JOIN #TEMP1 B On A.Cl_Code=B.PARTY_CODE      
  WHERE Deactive_value ='C'      
       
END

GO
