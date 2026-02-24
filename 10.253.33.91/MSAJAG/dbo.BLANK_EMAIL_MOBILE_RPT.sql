-- Object: PROCEDURE dbo.BLANK_EMAIL_MOBILE_RPT
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



---EXEC BLANK_EMAIL_MOBILE_RPT 'DEC  1 2021'
  
CREATE PROCEDURE [dbo].[BLANK_EMAIL_MOBILE_RPT]  
(  
@DATE VARCHAR(20)  
)  
AS  
BEGIN  
  
TRUNCATE TABLE SSRS_BLANK_EMAIL_DATA  
TRUNCATE TABLE SSRS_BLANK_EMAIL_DATA_1  
TRUNCATE TABLE SSRS_BLANK_EMAIL_DUMP  
TRUNCATE TABLE SSRS_BLANK_EMAIL_DATA_ACTIVE_1
TRUNCATE TABLE SSRS_BLANK_EMAIL_DATA_ACTIVE
  
  
SELECT A.cl_code,long_name,EMAIL,mobile_pager,Exchange,SEGMENT,Active_Date,InActive_From,Deactive_Remarks,Deactive_value,  
branch_cd,sub_broker,REGION---,(CASE WHEN B2C='Y'THEN 'B2C'ELSE 'B2B'END)AS B2B_B2C,COMB_LAST_DATE  
INTO  #CLI5  
 FROM  CLIENT_DETAILS A,CLIENT_BROK_DETAILS B  
WHERE A.cl_code=B.Cl_Code  
AND EMAIL='' AND mobile_pager=''  
  
SELECT A.cl_code,long_name,EMAIL,mobile_pager,Exchange,SEGMENT,Active_Date,InActive_From,Deactive_Remarks,Deactive_value,  
branch_cd,sub_broker,REGION---,(CASE WHEN B2C='Y'THEN 'B2C'ELSE 'B2B'END)AS B2B_B2C,COMB_LAST_DATE  
INTO  #CLI6  
 FROM  CLIENT_DETAILS A,CLIENT_BROK_DETAILS B  
WHERE A.cl_code=B.Cl_Code  
AND EMAIL=''    
  
SELECT A.cl_code,long_name,EMAIL,mobile_pager,Exchange,SEGMENT,Active_Date,InActive_From,Deactive_Remarks,Deactive_value,  
branch_cd,sub_broker,REGION---,(CASE WHEN B2C='Y'THEN 'B2C'ELSE 'B2B'END)AS B2B_B2C,COMB_LAST_DATE  
INTO  #CLI7  
 FROM  CLIENT_DETAILS A,CLIENT_BROK_DETAILS B  
WHERE A.cl_code=B.Cl_Code  
AND   mobile_pager=''  
  
  
   
  
SELECT * INTO #FIN1 FROM #CLI5  
UNION ALL  
SELECT * FROM #CLI6  
UNION ALL  
SELECT * FROM #CLI7  
  
SELECT DISTINCT * INTO #FIN2 FROM #FIN1  
  
CREATE INDEX idx_cl_Code  
ON #FIN2 (cl_Code);  
  
  
SELECT A.*,CLIENT_CODE ,STATUS AS DP_STATUS INTO #DP2 FROM #FIN2 A  
LEFT OUTER JOIN  
AGMUBODPL3.DMAT.CITRUS_USR.TBL_CLIENT_MASTER B  
ON A.CL_cODE=B.NISE_PARTY_CODE  
  
CREATE INDEX idx_CLIENT_cODE  
ON #DP2 (CLIENT_cODE);  
  
    SELECT * into #HOLD2  FROM  AGMUBODPL3.DMAT.dbo.holdingdata WHERE HLD_HOLD_DATE =@DATE  and HLD_AC_CODE in (select client_Code from #DP2)  
    
  SELECT * INTO #CLOSIN1 FROM  AGMUBODPL3.DMAT.CITRUS_USR.VW_ISIN_RATE_MASTER A,  
  (SELECT ISIN AS ISIN_NO,MAX(RATE_DATE) RATE  FROM  AGMUBODPL3.DMAT.CITRUS_USR.VW_ISIN_RATE_MASTER WHERE  RATE_DATE <=@DATE GROUP BY ISIN )B  
  WHERE A.ISIN=B.ISIN_NO  AND A.RATE_DATE =B.RATE   
  
    
   
 SELECT HLD_AC_CODE,SUM(HLD_AC_POS*CLOSE_PRICE)VALUE into #holding_aug  FROM #HOLD2 H, #CLOSIN1 WHERE ISIN=HLD_ISIN_CODE  
 ---and HLD_AC_CODE='1203320005663611'  
   GROUP BY HLD_AC_CODE  
     
     
   SELECT A.*,VALUE into #dpfin2 FROM #DP2 A  
   LEFT OUTER JOIN  
   #holding_aug B  
   ON A.CLIENT_cODE=B.HLD_AC_CODE  
     
   CREATE INDEX idx_cl_code_1  
ON #dpfin2 (cl_code);  
     
   select a.*,(CASE WHEN B2C='Y'THEN 'B2C'ELSE 'B2B'END)AS B2B_B2C,COMB_LAST_DATE INTO #FINAL from #dpfin2 a  
   left outer join  
   INTRANET.risk.dbo.client_details b  
   on a.cl_code=b.cl_Code  
   
    
       
     BEGIN      
INSERT INTO SSRS_BLANK_EMAIL_DATA      
select * FROM #FINAL  WHERE CL_cODE BETWEEN 'AO'AND 'MZZZZZ'  AND INACTIVE_FROM<=GETDATE()
  
--    SELECT *   FROM SSRS_BLANK_EMAIL_DATA WHERE CL_cODE BETWEEN 'AO'AND 'MZZZZZ'  
      
DECLARE @FILE VARCHAR(MAX),@PATH VARCHAR(MAX) = 'J:\BackOffice\test\AUTOMATION\'                           
SET @FILE = @PATH + 'BLANK_EMAIL_MOBILE_INACTIVE_1' +'_'+ CONVERT(VARCHAR(11),GETDATE() , 112) + '.csv' --Folder Name         
DECLARE @S VARCHAR(MAX)                                  
SET @S = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''cl_code'''',''''long_name'''',''''EMAIL'''',''''mobile_pager'''',''''Exchange'''',''''SEGMENT'''',''''Active_Date'''',''''InActive_From'''',''''Deactive_Remarks'''',''''Deactive_value'''',''''branch_cd'''',''''sub_broker'''',''''REGION'''',''''CLIENT_CODE'''',''''DP_STATUS'''',''''VALUE'''',''''B2B_B2C'''',''''COMB_LAST_DATE'''''    --Column Name        
SET @S = @S + ' UNION ALL SELECT    cast([cl_code] as varchar), cast([long_name] as varchar), cast([EMAIL] as varchar), cast([mobile_pager] as varchar), cast([Exchange] as varchar), cast([SEGMENT] as varchar),   CONVERT (VARCHAR (11),Active_Date,109) as Active_Date,   CONVERT (VARCHAR (11),InActive_From,109) as InActive_From, cast([Deactive_Remarks] as varchar), cast([Deactive_value] as varchar), cast([branch_cd] as varchar), cast([sub_broker] as varchar), cast([REGION] as varchar), cast([CLIENT_CODE] as varchar), cast([DP_STATUS] as varchar), cast([VALUE] as varchar), cast([B2B_B2C] as varchar), cast([COMB_LAST_DATE] as varchar) FROM [MSAJAG].[dbo].[SSRS_BLANK_EMAIL_DATA]    " QUERYOUT ' --Convert data type if required        
        
 +@file+ ' -c -SABVSNSECM.angelone.in -uaolinhouse -Pe$$gnfDTVs2455GZAcc'''         
--       PRINT  (@S)         
EXEC(@S)          
end       
  
       
     BEGIN      
INSERT INTO SSRS_BLANK_EMAIL_DATA_1      
select * FROM #FINAL  WHERE CL_cODE BETWEEN 'M0'AND 'ZZZZZZZ'  AND INACTIVE_FROM<=GETDATE()
  
--    SELECT *   FROM SSRS_BLANK_EMAIL_DATA WHERE CL_cODE BETWEEN 'AO'AND 'MZZZZZ'  
      
DECLARE @FILE1 VARCHAR(MAX),@PATH1 VARCHAR(MAX) = 'J:\BackOffice\test\AUTOMATION\'                           
SET @FILE1 = @PATH1 + 'BLANK_EMAIL_MOBILE_INACTIVE_2' +'_'+ CONVERT(VARCHAR(11),GETDATE() , 112) + '.csv' --Folder Name         
DECLARE @S1 VARCHAR(MAX)                                  
SET @S1 = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''cl_code'''',''''long_name'''',''''EMAIL'''',''''mobile_pager'''',''''Exchange'''',''''SEGMENT'''',''''Active_Date'''',''''InActive_From'''',''''Deactive_Remarks'''',''''Deactive_value'''',''''branch_cd'''',''''sub_broker'''',''''REGION'''',''''CLIENT_CODE'''',''''DP_STATUS'''',''''VALUE'''',''''B2B_B2C'''',''''COMB_LAST_DATE'''''    --Column Name        
SET @S1 = @S1 + ' UNION ALL SELECT    cast([cl_code] as varchar), cast([long_name] as varchar), cast([EMAIL] as varchar), cast([mobile_pager] as varchar), cast([Exchange] as varchar), cast([SEGMENT] as varchar),   CONVERT (VARCHAR (11),Active_Date,109) as Active_Date,   CONVERT (VARCHAR (11),InActive_From,109) as InActive_From, cast([Deactive_Remarks] as varchar), cast([Deactive_value] as varchar), cast([branch_cd] as varchar), cast([sub_broker] as varchar), cast([REGION] as varchar), cast([CLIENT_CODE] as varchar), cast([DP_STATUS] as varchar), cast([VALUE] as varchar), cast([B2B_B2C] as varchar), cast([COMB_LAST_DATE] as varchar) FROM [MSAJAG].[dbo].[SSRS_BLANK_EMAIL_DATA_1]    " QUERYOUT ' --Convert data type if required        
        
 +@file1+ ' -c -SABVSNSECM.angelone.in -uaolinhouse -Pe$$gnfDTVs2455GZAcc'''         
--       PRINT  (@S)         
EXEC(@S1)          
end     
  
  
     BEGIN      
INSERT INTO SSRS_BLANK_EMAIL_DUMP      
SELECT DISTINCT   
cl_code,long_name,EMAIL,mobile_pager,branch_cd,sub_broker,REGION,B2B_B2C  
----INTO SSRS_BLANK_EMAIL_DUMP  
 FROM #FINAL WHERE CL_cODE BETWEEN 'A0'AND 'ZZZZZ'  
  
   
      
DECLARE @FILE2 VARCHAR(MAX),@PATH2 VARCHAR(MAX) = 'J:\BackOffice\test\AUTOMATION\'                           
SET @FILE2 = @PATH2 + 'BLANK_EMAIL_MOBILE_DUMP' +'_'+ CONVERT(VARCHAR(11),GETDATE() , 112) + '.csv' --Folder Name         
DECLARE @S2 VARCHAR(MAX)                                  
SET @S2 = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''cl_code'''',''''long_name'''',''''EMAIL'''',''''mobile_pager'''',''''branch_cd'''',''''sub_broker'''',''''REGION'''',''''B2B_B2C'''''    --Column Name        
SET @S2 = @S2 + ' UNION ALL SELECT    cast([cl_code] as varchar), cast([long_name] as varchar), cast([EMAIL] as varchar), cast([mobile_pager] as varchar), cast([branch_cd] as varchar), cast([sub_broker] as varchar), cast([REGION] as varchar), cast([B2B_B2C] as varchar)FROM [MSAJAG].[dbo].[SSRS_BLANK_EMAIL_DUMP]    " QUERYOUT ' --Convert data type if required        
        
 +@file2+ ' -c -SABVSNSECM.angelone.in -uaolinhouse -Pe$$gnfDTVs2455GZAcc'''         
--       PRINT  (@S)         
EXEC(@S2)          
end      
  
       BEGIN      
INSERT INTO SSRS_BLANK_EMAIL_DATA_ACTIVE_1      
select * FROM #FINAL  WHERE CL_cODE BETWEEN 'A0'AND 'MZZZZZZZ'  AND INACTIVE_FROM>GETDATE()
  
--    SELECT *   FROM SSRS_BLANK_EMAIL_DATA_ACTIVE_1 WHERE CL_cODE BETWEEN 'AO'AND 'MZZZZZ'  
      
DECLARE @FILE4 VARCHAR(MAX),@PATH4 VARCHAR(MAX) = 'J:\BackOffice\test\AUTOMATION\'                           
SET @FILE4 = @PATH4 + 'BLANK_EMAIL_MOBILE_ACTIVE_1' +'_'+ CONVERT(VARCHAR(11),GETDATE() , 112) + '.csv' --Folder Name         
DECLARE @S4 VARCHAR(MAX)                                  
SET @S4 = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''cl_code'''',''''long_name'''',''''EMAIL'''',''''mobile_pager'''',''''Exchange'''',''''SEGMENT'''',''''Active_Date'''',''''InActive_From'''',''''Deactive_Remarks'''',''''Deactive_value'''',''''branch_cd'''',''''sub_broker'''',''''REGION'''',''''CLIENT_CODE'''',''''DP_STATUS'''',''''VALUE'''',''''B2B_B2C'''',''''COMB_LAST_DATE'''''    --Column Name        
SET @S4 = @S4 + ' UNION ALL SELECT    cast([cl_code] as varchar), cast([long_name] as varchar), cast([EMAIL] as varchar), cast([mobile_pager] as varchar), cast([Exchange] as varchar), cast([SEGMENT] as varchar),   CONVERT (VARCHAR (11),Active_Date,109) as Active_Date,   CONVERT (VARCHAR (11),InActive_From,109) as InActive_From, cast([Deactive_Remarks] as varchar), cast([Deactive_value] as varchar), cast([branch_cd] as varchar), cast([sub_broker] as varchar), cast([REGION] as varchar), cast([CLIENT_CODE] as varchar), cast([DP_STATUS] as varchar), cast([VALUE] as varchar), cast([B2B_B2C] as varchar), cast([COMB_LAST_DATE] as varchar) FROM [MSAJAG].[dbo].[SSRS_BLANK_EMAIL_DATA_ACTIVE_1]    " QUERYOUT ' --Convert data type if required        
        
 +@FILE4+ ' -c -SABVSNSECM.angelone.in -uaolinhouse -Pe$$gnfDTVs2455GZAcc'''         
--       PRINT  (@S)         
EXEC(@S4)          
end  


     BEGIN      
INSERT INTO SSRS_BLANK_EMAIL_DATA_ACTIVE      
select * FROM #FINAL  WHERE CL_cODE BETWEEN 'N0'AND 'ZZZZZZZ'  AND INACTIVE_FROM>GETDATE()
  
--    SELECT *   FROM SSRS_BLANK_EMAIL_DATA_ACTIVE_1 WHERE CL_cODE BETWEEN 'AO'AND 'MZZZZZ'  
      
DECLARE @FILE5 VARCHAR(MAX),@PATH5 VARCHAR(MAX) = 'J:\BackOffice\test\AUTOMATION\'                           
SET @FILE5 = @PATH5 + 'BLANK_EMAIL_MOBILE_ACTIVE_2' +'_'+ CONVERT(VARCHAR(11),GETDATE() , 112) + '.csv' --Folder Name         
DECLARE @S5 VARCHAR(MAX)                                  
SET @S5 = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''cl_code'''',''''long_name'''',''''EMAIL'''',''''mobile_pager'''',''''Exchange'''',''''SEGMENT'''',''''Active_Date'''',''''InActive_From'''',''''Deactive_Remarks'''',''''Deactive_value'''',''''branch_cd'''',''''sub_broker'''',''''REGION'''',''''CLIENT_CODE'''',''''DP_STATUS'''',''''VALUE'''',''''B2B_B2C'''',''''COMB_LAST_DATE'''''    --Column Name        
SET @S5 = @S5 + ' UNION ALL SELECT    cast([cl_code] as varchar), cast([long_name] as varchar), cast([EMAIL] as varchar), cast([mobile_pager] as varchar), cast([Exchange] as varchar), cast([SEGMENT] as varchar),   CONVERT (VARCHAR (11),Active_Date,109) as Active_Date,   CONVERT (VARCHAR (11),InActive_From,109) as InActive_From, cast([Deactive_Remarks] as varchar), cast([Deactive_value] as varchar), cast([branch_cd] as varchar), cast([sub_broker] as varchar), cast([REGION] as varchar), cast([CLIENT_CODE] as varchar), cast([DP_STATUS] as varchar), cast([VALUE] as varchar), cast([B2B_B2C] as varchar), cast([COMB_LAST_DATE] as varchar) FROM [MSAJAG].[dbo].[SSRS_BLANK_EMAIL_DATA_ACTIVE]    " QUERYOUT ' --Convert data type if required        
        
 +@FILE5+ ' -c -SABVSNSECM.angelone.in -uaolinhouse -Pe$$gnfDTVs2455GZAcc'''         
--       PRINT  (@S)         
EXEC(@S5)          
end  

  
END

GO
