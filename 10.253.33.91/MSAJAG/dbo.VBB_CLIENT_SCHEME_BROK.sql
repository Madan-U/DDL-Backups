-- Object: PROCEDURE dbo.VBB_CLIENT_SCHEME_BROK
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROC [dbo].[VBB_CLIENT_SCHEME_BROK]
( 
 @PARTY_CODE VARCHAR(20)
 )
 AS 

 

BEGIN

SELECT CL_CODE,EXCHANGE,SEGMENT INTO #CLIENT  FROM CLIENT_BROK_DETAILS WITH (NOLOCK)
WHERE CL_CODE = @PARTY_CODE
--AND InActive_From >= GETDATE()

CREATE INDEX #CL ON #CLIENT (CL_CODE) 
 

 

SELECT DISTINCT SP_PARTY_CODE FROM 
( select distinct  SP_Party_Code   from  Scheme_Mapping  WITH (NOLOCK) , #CLIENT C WHERE  
SP_Computation_Level = 'o'  AND SP_DATE_TO >= GETDATE() AND SP_Party_Code = @PARTY_CODE  And SP_Party_Code=cl_code and exchange='NSE' and Segment ='Capital'
UNION ALL
select distinct  SP_PARTY_CODE  from AngelBSECM.BSEDB_AB.DBO.Scheme_Mapping WITH (NOLOCK) , #CLIENT C 
WHERE  SP_Computation_Level = 'o'  AND SP_DATE_TO >= GETDATE() AND SP_Party_Code = @PARTY_CODE And SP_Party_Code=cl_code and exchange='BSE' and Segment ='Capital'
UNION ALL
select distinct  SP_PARTY_CODE  from  ANGELFO.NSEFO.DBO.Scheme_Mapping N WITH (NOLOCK) , #CLIENT C 
 WHERE SP_Computation_Level = 'o'  AND SP_DATE_TO >= GETDATE() AND SP_Party_Code = @PARTY_CODE And SP_Party_Code=cl_code and exchange='NSE' and Segment ='Futures'
UNION ALL
select distinct  SP_PARTY_CODE  from  ANGELFO.NSECURFO.DBO.Scheme_Mapping WITH (NOLOCK) , #CLIENT C 
WHERE SP_Computation_Level = 'o'  AND SP_DATE_TO >= GETDATE() AND SP_Party_Code = @PARTY_CODE And SP_Party_Code=cl_code and exchange='NSX' and Segment ='Futures'
UNION ALL
select distinct  SP_PARTY_CODE  from  ANGELCOMMODITY.BSECURFO.DBO.Scheme_Mapping  WITH (NOLOCK) , #CLIENT C 
WHERE  SP_Computation_Level = 'o'  AND SP_DATE_TO >= GETDATE() AND SP_Party_Code = @PARTY_CODE And SP_Party_Code=cl_code and exchange='BSX' and Segment ='Futures'
UNION ALL
select distinct  SP_PARTY_CODE  from  ANGELCOMMODITY.MCDX.DBO.Scheme_Mapping WITH (NOLOCK) , #CLIENT C 
WHERE SP_Computation_Level = 'o'  AND SP_DATE_TO >= GETDATE() AND SP_Party_Code = @PARTY_CODE And SP_Party_Code=cl_code and exchange='MCX' and Segment ='Futures'
 
UNION ALL
select distinct  SP_Party_Code  from ANGELCOMMODITY.NCDX.DBO.Scheme_Mapping WITH (NOLOCK) , #CLIENT C 
WHERE SP_Computation_Level = 'o'  AND SP_DATE_TO >= GETDATE() AND SP_Party_Code = @PARTY_CODE And SP_Party_Code=cl_code and exchange='NCX' and Segment ='Futures'
) A  


END

GO
