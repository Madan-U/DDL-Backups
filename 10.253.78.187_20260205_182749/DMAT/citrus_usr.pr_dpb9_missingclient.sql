-- Object: PROCEDURE citrus_usr.pr_dpb9_missingclient
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------




CREATE    procedure [citrus_usr].[pr_dpb9_missingclient]
(
-- exec pr_dpb9_missingclient 'Apr 15 2020' , 'Apr 15 2020' , 'Ho'

------begin tran
------insert into client_mstr
------select CLIM_CRN_NO,CLIM_NAME1,CLIM_NAME2,CLIM_NAME3,CLIM_SHORT_NAME,CLIM_GENDER,CLIM_DOB,CLIM_ENTTM_CD,
------CLIM_STAM_CD,CLIM_CLICM_CD,CLIM_SBUM_ID,CLIM_RMKS,CLIM_CREATED_BY,CLIM_CREATED_DT,CLIM_LST_UPD_BY,CLIM_LST_UPD_DT,
------'1',null,null from clim_hst where CLIM_CRN_NO = '30006732' and CLIM_ACTION = 'D'

------commit

----------- Delete Duplicate Data-------------------
--select BOID , count(1) CT INTO #T1 from dps8_pc1 
--GROUP BY BOId 
--HAVING COUNT (1)> 1 

--SELECT * INTO dps8_pc1_BAK27102022 FROM dps8_pc1 WHERE BOId IN (SELECT BOId  FROM #T1)

--SELECT  *  FROM dps8_pc1_BAK27102022 
--drop table tmpdata1
--select boid  into tmpdata1
--from dps8_pc1
--group by boid 
--having count(boid)>1
 

--WITH CTE (boid, DuplicateCount)
--AS
--(
--SELECT boid ,
--ROW_NUMBER() OVER(PARTITION BY BOID  ORDER BY BOID  ) ASDuplicateCount
--FROM dps8_pc1 

--WHERE BOID in (select BOID from tmpdata1)
--)
--delete   
--FROM CTE
--WHERE DuplicateCount >1
----------- Delete Duplicate Data-------------------



@pa_from_dt datetime
,@pa_to_dt datetime
,@pa_login_name varchar(100)
)
AS
BEGIN

select  ''''+ boid MISSINGBOID,'main table missing' descr
   from    dps8_pc1 where boid not in (select  dpam_sba_no from dp_acct_mstr) 
   union all

   
select ''''+ boid  ,'account opening date missing'  from dps8_pc1 where boid  in (
select DPAM_SBA_NO  from dp_acct_mstr where DPAM_ID not  in (select accp_clisba_id from account_properties
where ACCP_ACCPM_PROP_CD = 'bill_start_Dt')
and DPAM_SBA_NO <> DPAM_ACCT_NO 
and DPAM_STAM_CD = 'ACTIVE')
UNION ALL

select ''''+ DPAM_SBA_NO BOID , 'Active Client Deleted From Client Master' descr from dp_acct_mstr  WHERE DPAM_CRN_NO NOT IN (SELECT CLIM_CRN_NO FROM CLIENT_MSTR)
and exists (select 1 from clim_hst where CLIM_CRN_NO=DPAM_CRN_NO and CLIM_ACTION='D')
and DPAM_SBA_NO <> DPAM_ACCT_NO and DPAM_DELETED_IND = 1 

 union all

   select  ''''+ DPAM_SBA_NO MISSINGBOID,'CDSL table missing' descr
   from    dp_acct_mstr  where DPAM_SBA_NO  not in (select  boid  from dps8_pc1 ) 
   and DPAM_ACCT_NO <> DPAM_SBA_NO 
   and DPAM_DELETED_IND = 1 
   and DPAM_SBA_NO like '12033201%'
   and DPAM_STAM_CD = 'active'
   and DPAM_CREATED_BY <> 'citrusa' 

union all
select ''''+ boid  ,'DUPLICATE DATA FOUND IN DPB9 FILE, PLEASE CONTACT ADMINISTRATOR'   from dps8_pc1 
where boid like '120%'
group by boid 
having count (1) > 1 


   order by 1 


end

GO
