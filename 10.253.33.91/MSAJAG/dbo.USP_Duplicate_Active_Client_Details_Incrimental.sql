-- Object: PROCEDURE dbo.USP_Duplicate_Active_Client_Details_Incrimental
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


--EXEC MSAJAG.DBO.USP_Duplicate_Active_Client_Details '2022-10-19'
--EXEC MSAJAG.DBO.USP_Duplicate_Active_Client_Details_Incrimental '2022-10-19'
CREATE PROCEDURE [dbo].[USP_Duplicate_Active_Client_Details_Incrimental]
(
  @OnDate Date   = null
)
AS

BEGIN


--DECLARE @OnDate Date   = null
--    SET @OnDate ='2022-10-29'

	IF (@OnDate IS NULL OR @OnDate ='' )
	  BEGIN 
	  SET @ONDATE = CONVERT(DATE,GETDATE())
	END
--SELECT DATEADD(DD,1,@ONDATE)

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
			Active_Date >=@ONDATE AND Active_Date < DATEADD(DD,1,@ONDATE)
			AND 
            InActive_From > @ONDATE
GROUP BY A.cl_code,short_name,long_name ,dob --,Active_Date
CREATE INDEX IX_#TMP ON #TMP (cl_code) 
CREATE INDEX IX_#TMP_1 ON #TMP (long_name,dob)

 
IF OBJECT_ID('tempdb..#XYZ11111') IS NOT NULL
    DROP TABLE #XYZ11111
SELECT 
A.cl_code,A.short_name,A.long_name ,A.dob ,B.Active_Date  
INTO #XYZ11111
FROM MSAJAG.dbo.CLIENT_DETAILS A WITH(NOLOCK)  
INNER JOIN  MSAJAG.dbo.CLIENT_BROK_DETAILS B WITH(NOLOCK) ON A.cl_code =B.Cl_Code
INNER JOIN  #TMP C WITH(NOLOCK) ON A.long_name =C.long_name AND  A.dob =C.dob
            WHERE  
			--B.Active_Date NOT LIKE @ONDATE  
			--AND 
            InActive_From > @ONDATE
GROUP BY A.cl_code,A.short_name,A.long_name ,A.dob ,B.Active_Date

alter table #XYZ11111 
ADD F_NAME       VARCHAR (100)
 
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

UPDATE A 
SET F_NAME = ISNULL(FHFNAME,'')	+' '+ ISNULL(FHMNAME,'') +' '+	ISNULL(FHLNAME,'')
FROm #XYZ11111 A 
INNER JOIN ABVSCITRUS.[CRMDB_A].DBO.API_KYC  B ON A.cl_code  = B.BOPARTYCODE

UPDATE A 
SET F_NAME = FIRST_HOLD_FNAME
FROm #XYZ11111 A 
INNER JOIN AngelDP4.DMAT.CITRUS_USR.TBL_CLIENT_MASTER  B WITH (NOLOCK)  ON A.cl_code =B.NISE_PARTY_CODE
WHERE STATUS = 'ACTIVE' AND  F_NAME IS NULL

update #XYZ11111
SET    Active_Date=CONVERT(DATE ,Active_Date)

DELETE from #XYZ11111  where  CONVERT(DATE ,Active_Date)='2022-10-29'

DELETE A  from #XYZ11111 A 
INNER JOIN #TMP B On A.CL_Code = B.CL_Code 
 
 UPDATE #XYZ11111
 SET Active_Date = ''

 
 
IF OBJECT_ID('tempdb..#XYZ11111_YYYY') IS NOT NULL
         DROP TABLE #XYZ11111_YYYY
SELECT  DISTINCT * INTO #XYZ11111_YYYY from #XYZ11111

--select * from #XYZ11111_YYYY  WHERE long_name ='Suraj  .' AND dob ='1996-01-01 00:00:00.000'

 UPDATE #XYZ11111_YYYY
 SET Active_Date = ''


--select * from #TMP  WHERE long_name ='Suraj  .' AND dob ='1996-01-01 00:00:00.000'

update #TMP
set dob = CONVERT(DATE,dob)

update #XYZ11111_YYYY
set dob = CONVERT(DATE,dob)

 
	INSERT INTO #TMP
	(
	 cl_code     
	,short_name  
	,long_name   
	,dob         
	,F_NAME  
	)

	select  DISTINCT
	A.cl_code     
	,A.short_name  
	,A.long_name   
	,A.dob, A.F_NAME from #XYZ11111_YYYY A 
	inner join #TMP B On A.long_name =B.long_name AND A.dob =B.dob AND  A.F_NAME = B.F_NAME 
	INNER JOIN  MSAJAG.dbo.CLIENT_BROK_DETAILS C WITH(NOLOCK) ON A.cl_code =C.Cl_Code
	WHERE 
	InActive_From > GETDATE()
	ORDER BY A.long_name

	--select * from #TMP  where long_name ='AAKASH  KHANDELWAL' AND DOB='1997-07-12 00:00:00.000' and F_NAME ='SATENDRA  KHANDELWAL'



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

--select * from #XYZ_11

	IF OBJECT_ID('tempdb..#XYZ_ActivationDT') IS NOT NULL
	drop table #XYZ_ActivationDT
	Select 
	@OnDate ONDATE,
	--'2022-10-29' ONDATE ,
	A.cl_code Party_Code,A.long_name AS Name,A.dob DOB,A.F_NAME AS Father_Name-- ,Active_Date
	INTO #XYZ_ActivationDT
		FROM #XYZ_11 B 
		INNER JOIN #XYZ A ON A.RNK=B.RNK
		--group by A.cl_code,A.long_name,A.dob,A.F_NAME --,Active_Date
	ORDER BY A.long_name,A.dob,A.F_NAME 
 

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


IF OBJECT_ID('tempdb..#SINGLEDAYClient') IS NOT NULL
drop table #SINGLEDAYClient
SELECT ONDATE	,Party_Code	,Name	,DOB	,Father_Name	,Active_Date INTO #SINGLEDAYClient  
	FROM #XYZ_ActivationDT
group by ONDATE	,Party_Code	,Name	,DOB	,Father_Name	,Active_Date
 
 SELECT * FROM #SINGLEDAYClient   
 --where Active_Date ='2022-10-29'
 --ORDER BY NAME



---------------------------------- END SAME DAY

--select * from #SINGLEDAYClient

--create index IX_#SINGLEDAYClient On #SINGLEDAYClient (Name,DOB)
 
--IF OBJECT_ID('tempdb..#TMP_11') IS NOT NULL
--    DROP TABLE #TMP_11
--CREATE TABLE #TMP_11
--(
--  cl_code      VARCHAR (100),
--  short_name   VARCHAR (100),
--  long_name    VARCHAR (100),
--  dob          DATE ,
--  Active_Date  DATE,
--  F_NAME       VARCHAR (100)  
--)

--INSERT INTO #TMP_11
--(
-- cl_code     
--,short_name  
--,long_name   
--,dob         
--,Active_Date  
--)
--SELECT 
--A.cl_code,short_name,long_name ,A.dob ,B.Active_Date  
--FROM MSAJAG.dbo.CLIENT_DETAILS A WITH(NOLOCK)  
--INNER JOIN  MSAJAG.dbo.CLIENT_BROK_DETAILS B WITH(NOLOCK) ON A.cl_code =B.Cl_Code
--INNER JOIN  #SINGLEDAYClient C WITH(NOLOCK) ON A.long_name =C.Name AND  A.dob =C.dob --AND C.Active_Date <> B.Active_Date
-- --WHERE   
-- --           InActive_From >= @ONDATE
--GROUP BY A.cl_code,short_name,long_name ,A.dob   ,B.Active_Date

--CREATE INDEX IX_#TMP_11 ON #TMP_11 (cl_code)

--select * from #TMP_11

--	Delete from #TMP_11   where  Active_Date ='2022-10-29'

--	UPDATE #TMP_11
--	SET Active_Date = null 

--	UPDATE A 
--	SET F_NAME = ISNULL(FHFNAME,'')	+' '+ ISNULL(FHMNAME,'') +' '+	ISNULL(FHLNAME,'')
--	FROm #TMP_11 A 
--	INNER JOIN ABVSCITRUS.[CRMDB_A].DBO.API_KYC  B ON A.cl_code  = B.BOPARTYCODE

--	UPDATE A 
--	SET F_NAME = FIRST_HOLD_FNAME
--	FROm #TMP_11 A 
--	INNER JOIN AngelDP4.DMAT.CITRUS_USR.TBL_CLIENT_MASTER  B WITH (NOLOCK)  ON A.cl_code =B.NISE_PARTY_CODE
--	WHERE STATUS = 'ACTIVE' AND  F_NAME IS NULL


--;
--IF OBJECT_ID('tempdb..#XYZ') IS NOT NULL
--drop table #XYZ
--;
--WIth A
--AS
--(
--SELECT 
--cl_code,long_name ,dob ,F_NAME,Active_Date,RANK() OVER(Order By dob ,F_NAME,long_name  )RNK  
--FROM #TMP 
--)
--SELECT  * INTO #XYZ FROM A
  
   
--IF OBJECT_ID('tempdb..#YYYY') IS NOT NULL
--DROP TABLE #YYYY
-- SELECT  RNK,COUNT(RNK)NEW_CNT INTO  #YYYY FROM #XYZ
--       GROUP BY RNK
-- HAVING COUNT(RNK)>1


--IF OBJECT_ID('tempdb..#XYZ_11') IS NOT NULL
--drop table #XYZ_11
--;
--WIth A
--AS
--(
--SELECT 
--* ,ROW_NUMBER() OVER(Partition by long_name,F_NAME ,dob Order By long_name )RNK_1  
--FROM #XYZ
--)
--Select * INTO #XYZ_11 from A where RNK_1 >1


--IF OBJECT_ID('tempdb..#XYZ_ActivationDT') IS NOT NULL
--	drop table #XYZ_ActivationDT
--Select
----@OnDate ONDATE, 
--GETDATE() ONDATE, 
--A.cl_code Party_Code,A.long_name AS Name,A.dob DOB,A.F_NAME AS Father_Name-- ,Active_Date
--INTO #XYZ_ActivationDT
--       FROM #XYZ_11 B 
--       INNER JOIN #XYZ A ON A.RNK=B.RNK
--       --group by A.cl_code,A.long_name,A.dob,A.F_NAME --,Active_Date
--ORDER BY A.long_name,A.dob,A.F_NAME 


--ALTER TABLE #XYZ_ActivationDT 
--ADD Active_Date DATE

--IF OBJECT_ID('tempdb..#ClActiveCode') IS NOT NULL
--       DROP TABLE #ClActiveCode
--SELECT * INTO #ClActiveCode FROM MSAJAG.dbo.CLIENT_BROK_DETAILS B WITH(NOLOCK)
--WHERE EXISTS (SELECT * FROM #XYZ_ActivationDT A where A.Party_Code=B.Cl_Code)

--IF OBJECT_ID('tempdb..#Minimum_ActiveDT') IS NOT NULL
--       drop table #Minimum_ActiveDT
--SELECT MIN(Active_Date) Active_Date , Cl_Code Party_Code INTO #Minimum_ActiveDT FROM #ClActiveCode Y
--group by Cl_Code

 
--UPDATE A 
--   SET A.Active_Date = Y.Active_Date
--FROM #XYZ_ActivationDT A 
--INNER JOIN #Minimum_ActiveDT Y ON Y.Party_Code=A.Party_Code

--	SELECT DISTINCT * FROM #XYZ_ActivationDT
--	ORDER BY [Name]
--	Select * from #SINGLEDAYClient

 END

GO
