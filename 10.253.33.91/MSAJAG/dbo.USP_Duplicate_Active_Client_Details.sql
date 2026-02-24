-- Object: PROCEDURE dbo.USP_Duplicate_Active_Client_Details
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROCEDURE [dbo].[USP_Duplicate_Active_Client_Details]
(
  @OnDate Date   
)
AS
BEGIN

	IF (@OnDate IS NULL OR @OnDate ='' )
	  BEGIN 
	     SET @ONDATE = CONVERT(DATE,GETDATE()-1)
	  END

IF OBJECT_ID('tempdb..#TMP') IS NOT NULL
    DROP TABLE #TMP
CREATE TABLE #TMP
(
  cl_code      VARCHAR (100),
  short_name   VARCHAR (100),
  long_name    VARCHAR (100),
  dob          DATE ,
  Active_Date  DATE,
  F_NAME       VARCHAR (100)
)
INSERT INTO #TMP
(
 cl_code     
,short_name  
,long_name   
,dob         
--,Active_Date  
)
SELECT 
A.cl_code,short_name,long_name ,dob --,Active_Date  
FROM MSAJAG.dbo.CLIENT_DETAILS A WITH(NOLOCK)  
INNER JOIN  MSAJAG.dbo.CLIENT_BROK_DETAILS B WITH(NOLOCK) ON A.cl_code =B.Cl_Code
            WHERE  
			--Active_Date >=@ONDATE
			--AND 
            InActive_From >= @ONDATE
GROUP BY A.cl_code,short_name,long_name ,dob --,Active_Date
CREATE INDEX IX_#TMP ON #TMP (cl_code)

--delete from #TMP where Active_Date  <CONVERT(DATE,GETDATE())
--select Status,* from #TMP



UPDATE A 
SET F_NAME = ISNULL(FHFNAME,'')	+' '+ ISNULL(FHMNAME,'') +' '+	ISNULL(FHLNAME,'')
FROm #TMP A 
INNER JOIN ABVSCITRUS.[CRMDB_A].DBO.API_KYC  B ON A.cl_code  = B.BOPARTYCODE

UPDATE A 
SET F_NAME = FIRST_HOLD_FNAME
FROm #TMP A 
INNER JOIN AngelDP4.DMAT.CITRUS_USR.TBL_CLIENT_MASTER  B WITH (NOLOCK)  ON A.cl_code =B.NISE_PARTY_CODE
WHERE STATUS = 'ACTIVE' AND  F_NAME IS NULL
;
IF OBJECT_ID('tempdb..#XYZ') IS NOT NULL
drop table #XYZ
;
WIth A
AS
(
SELECT 
cl_code,long_name ,dob ,F_NAME,Active_Date,RANK() OVER(Order By dob ,F_NAME,long_name  )RNK  
FROM #TMP 
)
SELECT  * INTO #XYZ FROM A
  
   
IF OBJECT_ID('tempdb..#YYYY') IS NOT NULL
DROP TABLE #YYYY
 SELECT  RNK,COUNT(RNK)NEW_CNT INTO  #YYYY FROM #XYZ
       GROUP BY RNK
 HAVING COUNT(RNK)>1


IF OBJECT_ID('tempdb..#XYZ_11') IS NOT NULL
drop table #XYZ_11
;
WIth A
AS
(
SELECT 
* ,ROW_NUMBER() OVER(Partition by long_name,F_NAME ,dob Order By long_name )RNK_1  
FROM #XYZ
)
Select * INTO #XYZ_11 from A where RNK_1 >1

--select *from #XYZ  where RNK=3225527
--select * from #XYZ_11
--select * from #YYYY


IF OBJECT_ID('tempdb..#XYZ_ActivationDT') IS NOT NULL
drop table #XYZ_ActivationDT
Select @OnDate ONDATE, A.cl_code Party_Code,A.long_name AS Name,A.dob DOB,A.F_NAME AS Father_Name-- ,Active_Date
INTO #XYZ_ActivationDT
       FROM #XYZ_11 B 
       INNER JOIN #XYZ A ON A.RNK=B.RNK
       --group by A.cl_code,A.long_name,A.dob,A.F_NAME --,Active_Date
ORDER BY A.long_name,A.dob,A.F_NAME 

 
--IF OBJECT_ID('tempdb..#XYZ_ActivationDT') IS NOT NULL
--drop table #XYZ_ActivationDT
--Select CONVERT(DATE,GETDATE()-1) ONDATE, cl_code Party_Code,long_name AS Name,dob DOB,F_NAME AS Father_Name-- ,Active_Date
--INTO #XYZ_ActivationDT
--       FROM #YYYY B 
--       INNER JOIN #XYZ A ON A.RNK=B.RNK
--       group by cl_code,A.long_name,A.dob,A.F_NAME --,Active_Date
--ORDER BY A.long_name,A.dob,A.F_NAME 
 
--;
--WIth CTE1
--AS
--(
--SELECT 
--* ,ROW_NUMBER() OVER(Partition by Party_Code	,Name	,DOB	,Father_Name  Order By Active_Date  ASC)RNK_1  
--FROM #XYZ_ActivationDT
--)
--DELETE from CTE1 where RNK_1 >1
--and Party_Code='A1163240'

ALTER TABLE #XYZ_ActivationDT 
ADD Active_Date DATE

IF OBJECT_ID('tempdb..#ClActiveCode') IS NOT NULL
       DROP TABLE #ClActiveCode
SELECT * INTO #ClActiveCode FROM MSAJAG.dbo.CLIENT_BROK_DETAILS B
WHERE EXISTS (SELECT * FROM #XYZ_ActivationDT A where A.Party_Code=B.Cl_Code)

IF OBJECT_ID('tempdb..#Minimum_ActiveDT') IS NOT NULL
       drop table #Minimum_ActiveDT
SELECT MIN(Active_Date) Active_Date , Cl_Code Party_Code INTO #Minimum_ActiveDT FROM #ClActiveCode Y
group by Cl_Code

UPDATE A 
   SET A.Active_Date = Y.Active_Date
FROM #XYZ_ActivationDT A 
INNER JOIN #Minimum_ActiveDT Y ON Y.Party_Code=A.Party_Code

SELECT DISTINCT * FROM #XYZ_ActivationDT
ORDER BY [Name] 

 END

GO
