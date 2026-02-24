-- Object: PROCEDURE dbo.usp_nxt_getOrderBasedBrokerageReport_Bkp24Mar2022
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

/*
EXEC usp_nxt_getOrderBasedBrokerageReport_UAT 'client','ppsu','s504271'
EXEC usp_nxt_getOrderBasedBrokerageReport_UAT 'SB','ppsu',''
EXEC usp_nxt_getOrderBasedBrokerageReport 'SB','ppsu',''
EXEC usp_nxt_getOrderBasedBrokerageReport 'client','ppsu','s504271'




*/



CREATE PROCEDURE [dbo].[usp_nxt_getOrderBasedBrokerageReport_Bkp24Mar2022]
	@ReportLevel varchar(20),
	@access_code varchar(20),
	@party_code varchar(20)= null 
	--,@from datetime ,
	--@to datetime 

AS
BEGIN
SELECT MAX(A.SP_CreatedOn) RequstedDate,A.cl_code cl_code 
INTO #Brok_detail_modifcation_VBB_nxt_mailer_log 
FROM Brok_detail_modifcation_VBB_nxt_mailer_log A WITH(NOLOCK)
WHERE A.sub_broker=@access_code 
GROUP BY A.cl_code



SELECT MAX(A.SP_CreatedOn) ApprovedDate,A.cl_code cl_code,SCHEME_NAME,sub_broker,long_name
INTO #Vw_VBB_SCHEME_NAME 
FROM Vw_VBB_SCHEME_NAME A WITH(NOLOCK)
WHERE A.sub_broker=@access_code
GROUP BY A.cl_code,SCHEME_NAME,sub_broker,long_name



IF(@ReportLevel='Client' and ISNULL(@party_code,'')<>'')
BEGIN
select distinct cl_code,
(case when exists(SELECT A.RequstedDate,B.ApprovedDate FROM #Brok_detail_modifcation_VBB_nxt_mailer_log A WITH(NOLOCK) 
LEFT JOIN #Vw_VBB_SCHEME_NAME B WITH(NOLOCK)  ON A.CL_CODE=B.CL_CODE
WHERE  B.ApprovedDate>=A.RequstedDate and a.cl_code=ml.cl_code) then 'Accepted' 
else 'Requested' end) status
,long_name,
isnull((SELECT B.ApprovedDate FROM #Brok_detail_modifcation_VBB_nxt_mailer_log A WITH(NOLOCK) 
LEFT JOIN #Vw_VBB_SCHEME_NAME B WITH(NOLOCK)  ON A.CL_CODE=B.CL_CODE
WHERE  B.ApprovedDate>=A.RequstedDate and a.cl_code=ml.cl_code),null) SP_CreatedOn,
(select top 1 SP_CreatedOn from Brok_detail_modifcation_VBB_nxt_mailer_log with(nolock) where cl_code = ml.cl_code  
order by SP_CreatedOn desc) as mailsentDate,
(case when SCHEME_NAME like '%prime%' then 'iTrade Prime Plan' else 'iTrade Plan' end ) as SCHEME_NAME,
sub_broker 
from (select distinct cl_code,long_name,SCHEME_NAME,sub_broker from Brok_detail_modifcation_VBB_nxt_mailer_log with(nolock)) ml 
where sub_broker = @access_code AND cl_code=@party_code
UNION
select distinct  cl_code,'Accepted' status,long_name,ApprovedDate as SP_CreatedOn,isnull((select top 1 RequstedDate from #Brok_detail_modifcation_VBB_nxt_mailer_log where cl_code = sn.cl_code order by RequstedDate desc),NULL) as mailsentDate,(case when SCHEME_NAME like '%prime%' then 'iTrade Prime Plan' else 'iTrade Plan' end ) as SCHEME_NAME,sub_broker 
from  #Vw_VBB_SCHEME_NAME sn with(nolock)
where sub_broker = @access_code and cl_code = @party_code

END

ELSE

BEGIN
select distinct cl_code,
(case when exists(SELECT A.RequstedDate,B.ApprovedDate FROM #Brok_detail_modifcation_VBB_nxt_mailer_log A WITH(NOLOCK) 
LEFT JOIN #Vw_VBB_SCHEME_NAME B WITH(NOLOCK)  ON A.CL_CODE=B.CL_CODE
WHERE  B.ApprovedDate>=A.RequstedDate and a.cl_code=ml.cl_code) then 'Accepted' 
else 'Requested' end) status
,long_name,
isnull((SELECT B.ApprovedDate FROM #Brok_detail_modifcation_VBB_nxt_mailer_log A WITH(NOLOCK) 
LEFT JOIN #Vw_VBB_SCHEME_NAME B WITH(NOLOCK)  ON A.CL_CODE=B.CL_CODE
WHERE  B.ApprovedDate>=A.RequstedDate and a.cl_code=ml.cl_code),null) SP_CreatedOn,
(select top 1 SP_CreatedOn from Brok_detail_modifcation_VBB_nxt_mailer_log with(nolock) where cl_code = ml.cl_code  
order by SP_CreatedOn desc) as mailsentDate,
(case when SCHEME_NAME like '%prime%' then 'iTrade Prime Plan' else 'iTrade Plan' end ) as SCHEME_NAME,
sub_broker 
from (select distinct cl_code,long_name,SCHEME_NAME,sub_broker from Brok_detail_modifcation_VBB_nxt_mailer_log with(nolock)) ml 
where sub_broker = @access_code
UNION
select distinct  cl_code,'Accepted' status,long_name,ApprovedDate as SP_CreatedOn,isnull((select top 1 RequstedDate from #Brok_detail_modifcation_VBB_nxt_mailer_log where cl_code = sn.cl_code order by RequstedDate desc),NULL) as mailsentDate,(case when SCHEME_NAME like '%prime%' then 'iTrade Prime Plan' else 'iTrade Plan' end ) as SCHEME_NAME,sub_broker 
from  #Vw_VBB_SCHEME_NAME sn with(nolock)
where sub_broker = @access_code
END

DROP TABLE #Brok_detail_modifcation_VBB_nxt_mailer_log
DROP TABLE #Vw_VBB_SCHEME_NAME
END

GO
