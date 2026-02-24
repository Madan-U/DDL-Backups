-- Object: PROCEDURE dbo.USP_GET_CITY_LENGTH_20_PLUS
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GET_CITY_LENGTH_20_PLUS]
AS
BEGIN
IF OBJECT_ID('tempdb..#TEMP') IS NOT NULL
Drop table #TEMP
Select 
    P_city, L_city,cl_code  
INTO #TEMP
from client_details WITH(NOLOCK)
where  
ModifidedOn > GETDATE() -30 --added the logic for 30 days instead of 1 days by Akshay M on 28 AUG 2023
--and cl_code='M50008713'
GROUP BY P_city, L_city,cl_code

 
CREATE INDEX IX_#TEMP ON #TEMP (cl_code)
IF OBJECT_ID('tempdb..#Results') IS NOT NULL
  DROP TABLE #Results
select * INTO #Results from #TEMP   where (LEN(P_city) >20 OR  LEN(L_city)>20)

select B.*,LEN(B.P_city)P_city_LENGTH ,LEN(B.L_city) L_city_Length  FROM  #Results B

END

GO
