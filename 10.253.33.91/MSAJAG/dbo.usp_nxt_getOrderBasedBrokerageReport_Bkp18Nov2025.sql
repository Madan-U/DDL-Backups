-- Object: PROCEDURE dbo.usp_nxt_getOrderBasedBrokerageReport_Bkp18Nov2025
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


     
/*       
****Client Level with Scheme Name*****     
EXEC usp_nxt_getOrderBasedBrokerageReport 
'CLIENT','CBHO','A1007193','ITrade'      
EXEC usp_nxt_getOrderBasedBrokerageReport      
'CLIENT','CBHO','S194675','ITradePrime'      
EXEC usp_nxt_getOrderBasedBrokerageReport      
'CLIENT','CBHO','A1003302','ITradePrimePlus'    
EXEC usp_nxt_getOrderBasedBrokerageReport      
'CLIENT','CBHO','Y9901','ValueAdd'     
EXEC usp_nxt_getOrderBasedBrokerageReport      
'CLIENT','CBHO','S219510','ITradePremier'     
****Client Level without Scheme Name*****     
EXEC usp_nxt_getOrderBasedBrokerageReport      
'CLIENT','CBHO','A1007193'     
EXEC usp_nxt_getOrderBasedBrokerageReport      
'CLIENT','CBHO','S194675'     
EXEC usp_nxt_getOrderBasedBrokerageReport      
'CLIENT','CBHO','A1003302'     
EXEC usp_nxt_getOrderBasedBrokerageReport      
'CLIENT','CBHO','Y9901'     
EXEC usp_nxt_getOrderBasedBrokerageReport      
'CLIENT','CBHO','S219510'     
****SB Level****     
EXEC usp_nxt_getOrderBasedBrokerageReport      
'SB','CBHO','','ITRADE',10,0      
EXEC usp_nxt_getOrderBasedBrokerageReport      
'SB','CBHO','','ITradePrime',100,0      
EXEC usp_nxt_getOrderBasedBrokerageReport      
'SB','CBHO','','ITradePrimePlus',10,0     
EXEC usp_nxt_getOrderBasedBrokerageReport      
'SB','CBHO','','ValueAdd',10,0      
EXEC usp_nxt_getOrderBasedBrokerageReport      
'SB','CBHO','','ITradePremier',10,0         
****For report Download****     
EXEC usp_nxt_getOrderBasedBrokerageReport      
'SB','CBHO','','ITRADE'     
EXEC usp_nxt_getOrderBasedBrokerageReport      
'SB','CBHO','','ITradePrime'      
EXEC usp_nxt_getOrderBasedBrokerageReport      
'SB','CBHO','','ITradePrimePlus'     
EXEC usp_nxt_getOrderBasedBrokerageReport      
'SB','CBHO','','ValueAdd'     
EXEC usp_nxt_getOrderBasedBrokerageReport      
'SB','CBHO','','ITradePremier'    
*/       
       
       
       
CREATE PROCEDURE [dbo].[usp_nxt_getOrderBasedBrokerageReport_Bkp18Nov2025]     
 --declare      
 @ReportLevel varchar(20)='Client',       
 @access_code varchar(20)='Heeh',       
 @party_code varchar(20)= 'S194675',     
 @schemeType varchar(50)= '',     
 @PageNo INT = 100000000,     
 @PageSize INT = 0     
 --,@from datetime ,       
 --@to datetime        
       
AS       
BEGIN       
SELECT MAX(A.SP_CreatedOn) RequstedDate,A.cl_code cl_code        
INTO #Brok_detail_modifcation_VBB_nxt_mailer_log        
FROM Brok_detail_modifcation_VBB_nxt_mailer_log A WITH(NOLOCK)       
--WHERE A.sub_broker=@access_code        
GROUP BY A.cl_code       
--SELECT * FROM #Brok_detail_modifcation_VBB_nxt_mailer_log     
     
--if @party_code is null     
----begin     
--select SP_CreatedOn,cl_code,SCHEME_NAME,long_name into #Vw_VBB_SCHEME_NAME_SB from Vw_VBB_SCHEME_NAME VSN WITH(NOLOCK)       
-- where sub_broker=@access_code        
--end     
--Else      
--select SP_CreatedOn,cl_code,SCHEME_NAME,long_name into #Vw_VBB_SCHEME_NAME_Client from Vw_VBB_SCHEME_NAME VSN WITH(NOLOCK)       
-- where sub_broker=@access_code   and cl_code=@party_code     
--END     
     
SELECT cl_code,long_name,SCHEME_NAME,sub_broker     
INTO #Brok_detail_modifcation_VBB_nxt_mailer_log1        
FROM Brok_detail_modifcation_VBB_nxt_mailer_log A WITH(NOLOCK)       
WHERE A.sub_broker=@access_code        
--GROUP BY A.cl_code       
     
IF(@ReportLevel='Client' and ISNULL(@party_code,'')<>'')       
BEGIN       
	PRINT @party_code     
	IF (ISNULL(@schemeType,'')<>'')     
	BEGIN     
		PRINT @SCHEMETYPE     
		select distinct cl_code,'Accepted' as status,long_name,max(a.SP_CreatedOn) SP_CreatedOn,     
		max(a.SP_CreatedOn) mailsentDate     
		,sub_broker,     
		case when a.SCHEME_NAME like '%PLUS%' then 'iTrade Prime Plus Plan'         
		when a.SCHEME_NAME like '%Prime%' then 'iTrade Prime Plan'        
		when a.SCHEME_NAME like '%Value%' then 'Value Add Plan'        
		when a.SCHEME_NAME like '%ITrade Premier%' then 'ITrade Premier'        
        else 'iTrade Plan' end as SCHEME_NAME       
		from Vw_VBB_SCHEME_NAME a (nolock)     
		where a.sub_broker= @access_code and a.cl_code= @party_code and      
		SCHEME_NAME = case      
		when @schemeType = 'ITrade' then 'ANGEL CLASSIC 10000 VBB'      
		when @schemeType = 'ITradePrime' then 'Itrade Prime VBB'     
		when @schemeType = 'ValueAdd' then 'Value Add Plan'     
		when @schemeType = 'ITradePremier' then 'ITrade Premier VBB'     
		else 'Itrade Prime PLUS' end     
		group by a.cl_code,a.long_name,a.SCHEME_NAME,a.sub_broker     
	END     
	ELSE     
	BEGIN     
		PRINT 'Blank Scheme Type'     
		select distinct cl_code,'Accepted' as status,long_name,max(a.SP_CreatedOn) SP_CreatedOn,     
		max(a.SP_CreatedOn) mailsentDate     
		,sub_broker,     
		case when a.SCHEME_NAME like '%PLUS%' then 'iTrade Prime Plus Plan'         
		when a.SCHEME_NAME like '%Prime%' then 'iTrade Prime Plan'        
		when a.SCHEME_NAME like '%Value%' then 'Value Add Plan'        
		when a.SCHEME_NAME like '%ITrade Premier%' then 'ITrade Premier'        
		else 'iTrade Plan' end as SCHEME_NAME       
		from Vw_VBB_SCHEME_NAME a (nolock)     
		where a.sub_broker= @access_code and a.cl_code= @party_code      
		group by a.cl_code,a.long_name,a.SCHEME_NAME,a.sub_broker     
	END     
     
--select SP_CreatedOn,cl_code,SCHEME_NAME,long_name into #Vw_VBB_SCHEME_NAME_Client from Vw_VBB_SCHEME_NAME VSN WITH(NOLOCK)       
-- where sub_broker=@access_code and cl_code=@party_code     
     
-- SELECT MAX(VSN.SP_CreatedOn) ApprovedDate,VSN.cl_code cl_code,SCHEME_NAME,@access_code sub_broker,long_name       
--INTO #Vw_VBB_SCHEME_NAME1        
--FROM #Vw_VBB_SCHEME_NAME_Client VSN WITH(NOLOCK)       
--where cl_code=@party_code     
----join #clientDetails CD WITH(NOLOCK) ON VSN.cl_code = CD.cl_code     
----WHERE VSN.sub_broker=@access_code       
--GROUP BY VSN.cl_code,SCHEME_NAME,long_name --,VSN.sub_broker     
     
--  delete from #Brok_detail_modifcation_VBB_nxt_mailer_log where cl_code in (select cl_code  from #Vw_VBB_SCHEME_NAME1 )--select 'S194675'       
--  delete from #Brok_detail_modifcation_VBB_nxt_mailer_log1 where cl_code in (select cl_code  from #Vw_VBB_SCHEME_NAME1 )--select 'S194675'       
     
     
--Print 'BBB'     
--select distinct 2 test, cl_code,       
--(case when exists(     
--SELECT A.RequstedDate,B.ApprovedDate FROM #Brok_detail_modifcation_VBB_nxt_mailer_log A WITH(NOLOCK)        
--LEFT JOIN #Vw_VBB_SCHEME_NAME1 B WITH(NOLOCK)  ON A.CL_CODE=B.CL_CODE       
--WHERE  B.ApprovedDate>=A.RequstedDate and a.cl_code=ml.cl_code) then 'Accepted'        
--else 'Requested' end) status       
--,long_name,       
--isnull((SELECT B.ApprovedDate FROM #Brok_detail_modifcation_VBB_nxt_mailer_log A WITH(NOLOCK)        
--LEFT JOIN #Vw_VBB_SCHEME_NAME1 B WITH(NOLOCK)  ON A.CL_CODE=B.CL_CODE       
--WHERE  B.ApprovedDate>=A.RequstedDate and a.cl_code=ml.cl_code),null) SP_CreatedOn,       
--(select top 1 SP_CreatedOn from Brok_detail_modifcation_VBB_nxt_mailer_log with(nolock) where cl_code = ml.cl_code         
--order by SP_CreatedOn desc) as mailsentDate,       
--(       
--case when SCHEME_NAME like '%PLUS%' then 'iTrade Prime Plus Plan'        
--else        
--case when SCHEME_NAME like '%Prime%' then 'iTrade Prime Plan'        
--else 'iTrade Plan' end end) as SCHEME_NAME,       
--sub_broker        
--from (select distinct cl_code,long_name,SCHEME_NAME,sub_broker from #Brok_detail_modifcation_VBB_nxt_mailer_log1 with(nolock)) ml        
--where sub_broker = @access_code AND cl_code=@party_code      
----and  B.ApprovedDate>=A.RequstedDate      
--UNION       
--select distinct  1 test, cl_code,'Accepted' status,long_name,ApprovedDate as SP_CreatedOn,     
--isnull((select top 1  SP_CreatedOn from Brok_detail_modifcation_VBB_nxt_mailer_log     
--where cl_code = sn.cl_code order by SP_CreatedOn desc),NULL) as mailsentDate,       
--(       
--case when SCHEME_NAME like '%PLUS%' then 'iTrade Prime Plus Plan'        
--else        
--case when SCHEME_NAME like '%prime%' then 'iTrade Prime Plan'        
--else 'iTrade Plan' end end ) as SCHEME_NAME,sub_broker        
--from  #Vw_VBB_SCHEME_NAME1 sn with(nolock)       
--where sub_broker = @access_code and cl_code = @party_code       
     
-- DROP TABLE #Vw_VBB_SCHEME_NAME1       
       
END       
ELSE       
       
BEGIN       
     
Print 'Blank Party code'     
SELECT cl_code,sub_broker,long_name INTO #clientDetails     
FROM client_details WITH(NOLOCK)      
WHERE sub_broker= @access_code      
     
     
select SP_CreatedOn,cl_code,SCHEME_NAME into #Vw_VBB_SCHEME_NAME_SB     
from Vw_VBB_SCHEME_NAME VSN WITH(NOLOCK)       
 where sub_broker=@access_code       
     
SELECT MAX(VSN.SP_CreatedOn) ApprovedDate,VSN.cl_code cl_code,SCHEME_NAME,    
@access_code sub_broker--,'' long_name       
INTO #Vw_VBB_SCHEME_NAME        
FROM #Vw_VBB_SCHEME_NAME_SB VSN WITH(NOLOCK)       
--join #clientDetails CD WITH(NOLOCK) ON VSN.cl_code = CD.cl_code     
--WHERE VSN.sub_broker=@access_code       
GROUP BY VSN.cl_code,SCHEME_NAME--,long_name --,VSN.sub_broker     
     
  delete from #Brok_detail_modifcation_VBB_nxt_mailer_log where cl_code in (select cl_code  from #Vw_VBB_SCHEME_NAME )--select 'S194675'       
  delete from #Brok_detail_modifcation_VBB_nxt_mailer_log1 where cl_code in (select cl_code  from #Vw_VBB_SCHEME_NAME )--select 'S194675'       
     
     
select distinct cl_code,       
(case when exists(SELECT A.RequstedDate,B.ApprovedDate      
FROM #Brok_detail_modifcation_VBB_nxt_mailer_log A WITH(NOLOCK)        
LEFT JOIN #Vw_VBB_SCHEME_NAME B WITH(NOLOCK)  ON A.CL_CODE=B.CL_CODE       
WHERE  B.ApprovedDate>=A.RequstedDate and a.cl_code=ml.cl_code) then 'Accepted'        
else 'Requested' end) status       
,ml.long_name,       
isnull((SELECT B.ApprovedDate FROM #Brok_detail_modifcation_VBB_nxt_mailer_log A WITH(NOLOCK)        
LEFT JOIN #Vw_VBB_SCHEME_NAME B WITH(NOLOCK)  ON A.CL_CODE=B.CL_CODE       
WHERE  B.ApprovedDate>=A.RequstedDate and a.cl_code=ml.cl_code),null) SP_CreatedOn,       
ISNULL((select top 1 SP_CreatedOn from Brok_detail_modifcation_VBB_nxt_mailer_log with(nolock)      
where cl_code = ml.cl_code         
order by SP_CreatedOn desc),NULL) as mailSentDate,       
(       
case when SCHEME_NAME like '%PLUS%' then 'iTrade Prime Plus Plan'        
else       
case when SCHEME_NAME like '%prime%' then 'iTrade Prime Plan'     
	when SCHEME_NAME like '%Value%' then 'Value Add Plan'        
	when SCHEME_NAME like '%ITrade Premier VBB%' then 'ITrade Premier'        
else 'iTrade Plan' end  end ) as SCHEME_NAME,       
sub_broker        
INTO #SchemeNameSBWise     
from (select distinct CD.cl_code,cd.long_name,SCHEME_NAME,CD.sub_broker from Brok_detail_modifcation_VBB_nxt_mailer_log A with(nolock)     
JOIN #clientDetails CD ON A.cl_code=CD.cl_code) ml        
where sub_broker = @access_code       
UNION       
select distinct  sn.cl_code,'Accepted' status,CD.long_name,ApprovedDate as SP_CreatedOn,       
isnull((select top 1 SP_CreatedOn from Brok_detail_modifcation_VBB_nxt_mailer_log      
where cl_code = sn.cl_code order by SP_CreatedOn desc),NULL) as mailsentDate,       
(       
case when SCHEME_NAME like '%PLUS%' then 'iTrade Prime Plus Plan'        
else       
case when SCHEME_NAME like '%prime%' then 'iTrade Prime Plan'     
	 when SCHEME_NAME like '%Value%' then 'Value Add Plan'     
		when SCHEME_NAME like '%ITrade Premier VBB%' then 'ITrade Premier'        
else 'iTrade Plan' end end ) as SCHEME_NAME,sn.sub_broker        
from  #Vw_VBB_SCHEME_NAME sn with(nolock)       
inner join #clientDetails CD ON sn.cl_code=CD.cl_code     
where sn.sub_broker = @access_code       
--select * from #SchemeNameSBWise     
     
select *, ROW_NUMBER() OVER(Partition by cl_code order by SP_CREATEDON DESC) AS RANKING      
INTO #SchemeNameSBWiseTemp     
FROM #SchemeNameSBWise     
     
select ROW_NUMBER() OVER(Partition by cl_code order by cl_code DESC) AS rn,     
cl_code,status,long_name,SP_CreatedOn,mailsentDate,SCHEME_NAME,sub_broker      
INTO #final     
from #SchemeNameSBWiseTemp with(nolock)      
where RANKING = 1 and      
SCHEME_NAME = case      
when @schemeType = 'ITrade' then 'iTrade Plan'      
when @schemeType = 'ITradePrime' then 'iTrade Prime Plan'     
when @schemeType = 'ValueAdd' then 'Value Add Plan'     
when @schemeType = 'ITradePremier' then 'ITrade Premier'        
else 'iTrade Prime Plus Plan' end     
     
print @pagesize     
print @pageno     
if @pagesize = 0 and @pageno = 0      
begin     
set @pagesize = 0      
set @pageno = 100000000     
end     
select rn,(select count(*) from #final (nolock)) as totalClients,cl_code,status,long_name,SP_CreatedOn,mailsentDate,     
SCHEME_NAME,sub_broker FROM #final (nolock)     
ORDER BY rn  offset @PageSize ROWS FETCH NEXT  @pageno ROWS ONLY     
     
 DROP TABLE #Vw_VBB_SCHEME_NAME       
     
END       
       
 DROP TABLE #Brok_detail_modifcation_VBB_nxt_mailer_log1       
 DROP TABLE #Brok_detail_modifcation_VBB_nxt_mailer_log       
       
END

GO
