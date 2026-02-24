-- Object: PROCEDURE dbo.usp_nxt_getOrderBasedBrokerageReport_opti_12052022
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/*  
  
--EXEC usp_nxt_getOrderBasedBrokerageReport_UAT 'client','ppsu','s504271'  
--EXEC usp_nxt_getOrderBasedBrokerageReport 'SB','ajyc',''  
  
exec usp_nxt_getOrderBasedBrokerageReport_opti_12052022 @ReportLevel = 'SB', @access_code = 'CBHO', @party_code = null  
exec usp_nxt_getOrderBasedBrokerageReport @ReportLevel = 'Client', @access_code = 'heeh', @party_code = 'S194675'  
  

select * from Vw_VBB_SCHEME_NAME A WITH(NOLOCK)  
where CL_CODE in ('S194675' ,'A628579')
  
  
  
*/  
  
  
  
CREATE PROCEDURE usp_nxt_getOrderBasedBrokerageReport_opti_12052022
 --declare 
 @ReportLevel varchar(20)='Client',  
 @access_code varchar(20)='Heeh',  
 @party_code varchar(20)= 'S194675'
 --,@from datetime ,  
 --@to datetime   
  
AS  
BEGIN  
SELECT MAX(A.SP_CreatedOn) RequstedDate,A.cl_code cl_code   
INTO #Brok_detail_modifcation_VBB_nxt_mailer_log   
FROM Brok_detail_modifcation_VBB_nxt_mailer_log A WITH(NOLOCK)  
WHERE A.sub_broker=@access_code   
GROUP BY A.cl_code  
  

SELECT cl_code,long_name,SCHEME_NAME,sub_broker
INTO #Brok_detail_modifcation_VBB_nxt_mailer_log1   
FROM Brok_detail_modifcation_VBB_nxt_mailer_log A WITH(NOLOCK)  
WHERE A.sub_broker=@access_code   
--GROUP BY A.cl_code  

SELECT cl_code,sub_broker INTO #clientDetails FROM client_details WITH(NOLOCK) 
WHERE sub_broker= @access_code
  
SELECT MAX(VSN.SP_CreatedOn) ApprovedDate,VSN.cl_code cl_code,SCHEME_NAME,VSN.sub_broker,long_name  
INTO #Vw_VBB_SCHEME_NAME   
FROM Vw_VBB_SCHEME_NAME VSN WITH(NOLOCK)  
join #clientDetails CD WITH(NOLOCK) ON VSN.cl_code = CD.cl_code
WHERE VSN.sub_broker=@access_code  
GROUP BY VSN.cl_code,SCHEME_NAME,VSN.sub_broker,long_name 


  


  
  delete from #Brok_detail_modifcation_VBB_nxt_mailer_log where cl_code in (select cl_code  from #Vw_VBB_SCHEME_NAME )--select 'S194675'  
  delete from #Brok_detail_modifcation_VBB_nxt_mailer_log1 where cl_code in (select cl_code  from #Vw_VBB_SCHEME_NAME )--select 'S194675'  
  --select * from #Vw_VBB_SCHEME_NAME where cl_code='S194675'   
  


IF(@ReportLevel='Client' and ISNULL(@party_code,'')<>'')  
BEGIN  

Print 'BBB'
select distinct 2 test, cl_code,  
(case when exists(
SELECT A.RequstedDate,B.ApprovedDate FROM #Brok_detail_modifcation_VBB_nxt_mailer_log A WITH(NOLOCK)   
LEFT JOIN #Vw_VBB_SCHEME_NAME B WITH(NOLOCK)  ON A.CL_CODE=B.CL_CODE  
WHERE  B.ApprovedDate>=A.RequstedDate and a.cl_code=ml.cl_code) then 'Accepted'   
else 'Requested' end) status  
,long_name,  
isnull((SELECT B.ApprovedDate FROM #Brok_detail_modifcation_VBB_nxt_mailer_log A WITH(NOLOCK)   
LEFT JOIN #Vw_VBB_SCHEME_NAME B WITH(NOLOCK)  ON A.CL_CODE=B.CL_CODE  
WHERE  B.ApprovedDate>=A.RequstedDate and a.cl_code=ml.cl_code),null) SP_CreatedOn,  
(select top 1 SP_CreatedOn from Brok_detail_modifcation_VBB_nxt_mailer_log with(nolock) where cl_code = ml.cl_code    
order by SP_CreatedOn desc) as mailsentDate,  
(  
case when SCHEME_NAME like '%PLUS%' then 'iTrade Prime Plus Plan'   
else   
case when SCHEME_NAME like '%Prime%' then 'iTrade Prime Plan'   
else 'iTrade Plan' end end) as SCHEME_NAME,  
sub_broker   
from (select distinct cl_code,long_name,SCHEME_NAME,sub_broker from #Brok_detail_modifcation_VBB_nxt_mailer_log1 with(nolock)) ml   
where sub_broker = @access_code AND cl_code=@party_code 
--and  B.ApprovedDate>=A.RequstedDate 
UNION  
select distinct  1 test, cl_code,'Accepted' status,long_name,ApprovedDate as SP_CreatedOn,isnull((select top 1 RequstedDate from #Brok_detail_modifcation_VBB_nxt_mailer_log where cl_code = sn.cl_code order by RequstedDate desc),NULL) as mailsentDate,  
(  
case when SCHEME_NAME like '%PLUS%' then 'iTrade Prime Plus Plan'   
else   
case when SCHEME_NAME like '%prime%' then 'iTrade Prime Plan'   
else 'iTrade Plan' end end ) as SCHEME_NAME,sub_broker   
from  #Vw_VBB_SCHEME_NAME sn with(nolock)  
where sub_broker = @access_code and cl_code = @party_code  
  
END  
ELSE  
  
BEGIN  

Print 'AAA'

select distinct cl_code,  
(case when exists(SELECT A.RequstedDate,B.ApprovedDate 
FROM #Brok_detail_modifcation_VBB_nxt_mailer_log A WITH(NOLOCK)   
LEFT JOIN #Vw_VBB_SCHEME_NAME B WITH(NOLOCK)  ON A.CL_CODE=B.CL_CODE  
WHERE  B.ApprovedDate>=A.RequstedDate and a.cl_code=ml.cl_code) then 'Accepted'   
else 'Requested' end) status  
,long_name,  
isnull((SELECT B.ApprovedDate FROM #Brok_detail_modifcation_VBB_nxt_mailer_log A WITH(NOLOCK)   
LEFT JOIN #Vw_VBB_SCHEME_NAME B WITH(NOLOCK)  ON A.CL_CODE=B.CL_CODE  
WHERE  B.ApprovedDate>=A.RequstedDate and a.cl_code=ml.cl_code),null) SP_CreatedOn,  
(select top 1 SP_CreatedOn from Brok_detail_modifcation_VBB_nxt_mailer_log with(nolock) where cl_code = ml.cl_code    
order by SP_CreatedOn desc) as mailsentDate,  
(  
case when SCHEME_NAME like '%PLUS%' then 'iTrade Prime Plus Plan'   
else  
case when SCHEME_NAME like '%prime%' then 'iTrade Prime Plan' else 'iTrade Plan' end  end ) as SCHEME_NAME,  
sub_broker   
INTO #SchemeNameSBWise
from (select distinct CD.cl_code,long_name,SCHEME_NAME,CD.sub_broker from Brok_detail_modifcation_VBB_nxt_mailer_log A with(nolock)
JOIN #clientDetails CD ON A.cl_code=CD.cl_code) ml   
where sub_broker = @access_code  
UNION  
select distinct  cl_code,'Accepted' status,long_name,ApprovedDate as SP_CreatedOn,  
isnull((select top 1 RequstedDate from #Brok_detail_modifcation_VBB_nxt_mailer_log where cl_code = sn.cl_code order by RequstedDate desc),NULL) as mailsentDate,  
(  
case when SCHEME_NAME like '%PLUS%' then 'iTrade Prime Plus Plan'   
else  
case when SCHEME_NAME like '%prime%' then 'iTrade Prime Plan' else 'iTrade Plan' end end ) as SCHEME_NAME,sub_broker   
from  #Vw_VBB_SCHEME_NAME sn with(nolock)  
where sub_broker = @access_code  

select *, ROW_NUMBER() OVER(Partition by cl_code order by SP_CREATEDON DESC) AS RANKING 
INTO #SchemeNameSBWiseTemp
FROM #SchemeNameSBWise

select cl_code,status,long_name,SP_CreatedOn,mailsentDate,SCHEME_NAME,sub_broker from #SchemeNameSBWiseTemp with(nolock) 
where RANKING = 1

END  
  
 DROP TABLE #Brok_detail_modifcation_VBB_nxt_mailer_log1  
 DROP TABLE #Brok_detail_modifcation_VBB_nxt_mailer_log  
 DROP TABLE #Vw_VBB_SCHEME_NAME  
  
END

GO
