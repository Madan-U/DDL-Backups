-- Object: PROCEDURE citrus_usr.bulk_upd_accp_pend
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------



CREATE     proc [citrus_usr].[bulk_upd_accp_pend]
as
begin 


select distinct boid into #temp   from dps8_pc1 where boid  in (
select DPAM_SBA_NO  from dp_acct_mstr where DPAM_ID not  in (select accp_clisba_id from account_properties
where ACCP_ACCPM_PROP_CD = 'bill_start_Dt')
and DPAM_SBA_NO <> DPAM_ACCT_NO 
and DPAM_STAM_CD = 'ACTIVE'
)
 


drop  table Pend_data_to_import_accp_entp_dps8_pc1
select * into Pend_data_to_import_accp_entp_dps8_pc1 from dps8_pc1 where boid  in (select boid from #temp )
drop  table Pend_data_to_import_accp_entp_dps8_pc2
select * into Pend_data_to_import_accp_entp_dps8_pc2 from dps8_pc2 where boid in (select boid from #temp )
drop  table Pend_data_to_import_accp_entp_dps8_pc3
select * into Pend_data_to_import_accp_entp_dps8_pc3 from dps8_pc3 where boid in (select boid from #temp )
drop  table Pend_data_to_import_accp_entp_dps8_pc6
select * into Pend_data_to_import_accp_entp_dps8_pc6 from dps8_pc6 where boid in (select boid from #temp )



select * into #tmp_accp_value1 from ( 
SELECT DISTINCT  boid, CONVERT(VARCHAR,'38') propid, UPPER(ISNULL(LTRIM(RTRIM(SEBIREGNUM)),'')) value FROM Pend_data_to_import_accp_entp_dps8_pc1  
union all SELECT DISTINCT  boid,CONVERT(VARCHAR,'33') , UPPER(ISNULL(LTRIM(RTRIM(CLMEMID)),''))   FROM Pend_data_to_import_accp_entp_dps8_pc1 
union all SELECT DISTINCT  boid,CONVERT(VARCHAR,'94') , UPPER(ISNULL(LTRIM(RTRIM(UnqIdenNum)),''))   FROM Pend_data_to_import_accp_entp_dps8_pc1 
union all SELECT DISTINCT  boid,CONVERT(VARCHAR,'95') , UPPER(ISNULL(LTRIM(RTRIM(UniqueId)),''))   FROM Pend_data_to_import_accp_entp_dps8_pc2 
union all SELECT DISTINCT  boid,CONVERT(VARCHAR,'96') , UPPER(ISNULL(LTRIM(RTRIM(UniqueId)),''))   FROM Pend_data_to_import_accp_entp_dps8_pc3 
union all SELECT DISTINCT  boid,CONVERT(VARCHAR,'41') , UPPER(ISNULL(LTRIM(RTRIM(RBIREFNUM)),''))  FROM Pend_data_to_import_accp_entp_dps8_pc1 
union all SELECT DISTINCT  boid,CONVERT(VARCHAR,'18') , UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','BANKCCY',UPPER(ISNULL(LTRIM(RTRIM(DIVBANKCURR)),''))))  FROM Pend_data_to_import_accp_entp_dps8_pc1   
union all SELECT DISTINCT  boid,CONVERT(VARCHAR,'27') , UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','DIVBANKCCY',UPPER(ISNULL(LTRIM(RTRIM(DIVBANKCURR)),''))))  FROM Pend_data_to_import_accp_entp_dps8_pc1 
union all SELECT DISTINCT  boid,CONVERT(VARCHAR,'16') , UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','DIVIDEND_CURRENCY',UPPER(ISNULL(LTRIM(RTRIM(DIVBANKCURR)),''))))  FROM Pend_data_to_import_accp_entp_dps8_pc1   
union all SELECT DISTINCT  boid,CONVERT(VARCHAR,'46') , + LEFT(ISNULL(LTRIM(RTRIM(CLOSDT)),''),2) + '/'+ SUBSTRING(ISNULL(LTRIM(RTRIM(CLOSDT)),''),3,2) + '/' + RIGHT(ISNULL(LTRIM(RTRIM(CLOSDT)),''),4)   FROM Pend_data_to_import_accp_entp_dps8_pc1  
union all SELECT DISTINCT  boid,CONVERT(VARCHAR,'44') , CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(CONFWAIVED)),''))='Y' THEN '1' ELSE '0' END   FROM Pend_data_to_import_accp_entp_dps8_pc1  
union all SELECT DISTINCT  boid,CONVERT(VARCHAR,'25') , CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(ECS)),''))='Y' THEN '1' ELSE '0' END    FROM Pend_data_to_import_accp_entp_dps8_pc1  
union all SELECT DISTINCT  boid,CONVERT(VARCHAR,'28') , UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','BOSTMNTCYCLE',UPPER(ISNULL(LTRIM(RTRIM(BOSTATCYCLECD)),''))))  FROM Pend_data_to_import_accp_entp_dps8_pc1   
union all SELECT DISTINCT  boid,CONVERT(VARCHAR,'35') , + LEFT(ISNULL(LTRIM(RTRIM(BOActDt)),''),2) + '/'+ SUBSTRING(ISNULL(LTRIM(RTRIM(BOActDt)),''),3,2) + '/' + RIGHT(ISNULL(LTRIM(RTRIM(BOActDt)),''),4)   FROM Pend_data_to_import_accp_entp_dps8_pc1   where BOActDt <> ''
union all SELECT DISTINCT  boid,CONVERT(VARCHAR,'57') , CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(filler9)),''))='Y' THEN '1' ELSE '0' END    FROM Pend_data_to_import_accp_entp_dps8_pc1  
union all SELECT DISTINCT  boid,CONVERT(VARCHAR,'61') , CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(AnnlRep)),''))='Y' THEN '1' ELSE '0' END    FROM Pend_data_to_import_accp_entp_dps8_pc1  
union all SELECT DISTINCT  boid,CONVERT(VARCHAR,ACCPM_PROP_ID) , CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(Filler6)),''))='1' THEN 'PHYSICAL' WHEN UPPER(ISNULL(LTRIM(RTRIM(Filler6)),''))='2' THEN 'ELECTRONIC' WHEN UPPER(ISNULL(LTRIM(RTRIM(Filler6)),''))='3' THEN 'BOTH'  ELSE '0' END     FROM Pend_data_to_import_accp_entp_dps8_pc1 ,ACCOUNT_PROPERTY_MSTR WHERE ACCPM_PROP_CD  = 'ANNUAL_REPORT'
union all SELECT DISTINCT  boid,CONVERT(VARCHAR,ACCPM_PROP_ID) , CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(Filler7)),''))='Y' THEN 'YES' WHEN UPPER(ISNULL(LTRIM(RTRIM(Filler7)),''))='N' THEN 'NO'  ELSE '0' END     FROM Pend_data_to_import_accp_entp_dps8_pc1 ,ACCOUNT_PROPERTY_MSTR WHERE  ACCPM_PROP_CD  = 'PLEDGE_STANDING'
union all SELECT DISTINCT  boid,CONVERT(VARCHAR,ACCPM_PROP_ID) , CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(Filler3)),''))='PH' THEN 'PHYSICAL CAS REQUIRED' when  UPPER(ISNULL(LTRIM(RTRIM(Filler3)),''))='NO' then 'CAS NOT REQUIRED' else  UPPER(ISNULL(LTRIM(RTRIM(Filler3)),'')) END    FROM Pend_data_to_import_accp_entp_dps8_pc1 ,ACCOUNT_PROPERTY_MSTR WHERE  ACCPM_PROP_CD  = 'cas_flag' --and Filler3 <> ''
union all SELECT DISTINCT  boid,CONVERT(VARCHAR,'58') , CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(filler2)),''))='Y' THEN 'YES' WHEN UPPER(ISNULL(LTRIM(RTRIM(filler2)),''))='N' THEN 'NO' ELSE '' END    FROM Pend_data_to_import_accp_entp_dps8_pc1  
union all SELECT DISTINCT  boid,CONVERT(VARCHAR,'66') , CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(filler8)),''))='Y' THEN 'YES' WHEN UPPER(ISNULL(LTRIM(RTRIM(filler8)),''))='N' THEN 'NO' ELSE '' END    FROM Pend_data_to_import_accp_entp_dps8_pc1  
union all SELECT DISTINCT  boid,CONVERT(VARCHAR,ACCPM_PROP_ID) , CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(smart_flag)),''))='Y' THEN 'YES' ELSE 'NO' END    FROM Pend_data_to_import_accp_entp_dps8_pc1 ,ACCOUNT_PROPERTY_MSTR WHERE  ACCPM_PROP_CD  = 'SMART_REG'
union all SELECT DISTINCT  boid,CONVERT(VARCHAR,'77') , CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(rel_WITH_BO)),'')) <> '' THEN citrus_usr.fn_get_cd_rel(UPPER(ISNULL(LTRIM(RTRIM(rel_WITH_BO)),''))) ELSE '' END    FROM Pend_data_to_import_accp_entp_dps8_pc6 where  NOM_Sr_No = 1
union all SELECT DISTINCT  boid,CONVERT(VARCHAR,'78') , CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(perc_OF_SHARES)),''))<> '' THEN UPPER(ISNULL(LTRIM(RTRIM(perc_OF_SHARES)),'')) ELSE '' END    FROM Pend_data_to_import_accp_entp_dps8_pc6  WHERE   NOM_Sr_No = 1
union all SELECT DISTINCT  boid,CONVERT(VARCHAR,'79') , CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(RES_SEC_FLg)),''))='Y' THEN 'YES' WHEN UPPER(ISNULL(LTRIM(RTRIM(RES_SEC_FLg)),''))='N' THEN 'NO' ELSE '' END    FROM Pend_data_to_import_accp_entp_dps8_pc6  where  NOM_Sr_No = 1
union all SELECT DISTINCT boid, CONVERT(VARCHAR,'41') , CONVERT(VARCHAR,'6') + '|*~|'  + LEFT(ISNULL(LTRIM(RTRIM(RBIAPPDT)),''),2) + '/'+ SUBSTRING(ISNULL(LTRIM(RTRIM(RBIAPPDT)),''),3,2) + '/' + RIGHT(ISNULL(LTRIM(RTRIM(RBIAPPDT)),''),4)   FROM Pend_data_to_import_accp_entp_dps8_pc1   
where ISDATE(RIGHT(ISNULL(LTRIM(RTRIM(RBIAPPDT)),''),2) + '/'+ SUBSTRING(ISNULL(LTRIM(RTRIM(RBIAPPDT)),''),5,2) + '/' + LEFT(ISNULL(LTRIM(RTRIM(RBIAPPDT)),''),4)) = 1				
Union all SELECT DISTINCT boid,  CONVERT(VARCHAR,ACCPM_PROP_ID) , UPPER([CITRUS_USR].fn_get_PanBOBONA_Val_reverse('BOOS',UPPER(ISNULL(LTRIM(RTRIM(AFILLER4)),''))))  FROM Pend_data_to_import_accp_entp_dps8_pc1  ,ACCOUNT_PROPERTY_MSTR WHERE  ACCPM_PROP_CD  = 'BOOS'	
Union all SELECT DISTINCT boid,  CONVERT(VARCHAR,ACCPM_PROP_ID) , UPPER([CITRUS_USR].fn_get_PanBOBONA_Val_reverse('BONAFIDE',UPPER(ISNULL(LTRIM(RTRIM(AFILLER5)),''))))  FROM Pend_data_to_import_accp_entp_dps8_pc1 ,ACCOUNT_PROPERTY_MSTR WHERE  ACCPM_PROP_CD  = 'BONAFIDE'	
Union all SELECT DISTINCT boid,  CONVERT(VARCHAR,ACCPM_PROP_ID) , UPPER([CITRUS_USR].fn_get_PanBOBONA_Val_reverse('PANVC',UPPER(ISNULL(LTRIM(RTRIM(PANVerCode)),''))))   FROM Pend_data_to_import_accp_entp_dps8_pc1  ,ACCOUNT_PROPERTY_MSTR WHERE  ACCPM_PROP_CD  = 'PANVC'	
Union all SELECT DISTINCT boid,  CONVERT(VARCHAR,ACCPM_PROP_ID) , UPPER([CITRUS_USR].fn_get_PanBOBONA_Val_reverse('PANVC2',UPPER(ISNULL(LTRIM(RTRIM(PANVerCd)),''))))  FROM Pend_data_to_import_accp_entp_dps8_pc2  ,ACCOUNT_PROPERTY_MSTR WHERE  ACCPM_PROP_CD  = 'PANVC2'	
Union all SELECT DISTINCT boid,  CONVERT(VARCHAR,ACCPM_PROP_ID) , UPPER([CITRUS_USR].fn_get_PanBOBONA_Val_reverse('PANVC3',UPPER(ISNULL(LTRIM(RTRIM(PANVerCd)),''))))  FROM Pend_data_to_import_accp_entp_dps8_pc3  ,ACCOUNT_PROPERTY_MSTR WHERE  ACCPM_PROP_CD  = 'PANVC3'	
Union all SELECT DISTINCT boid, CONVERT(VARCHAR,ACCPM_PROP_ID) , 'YES'  	FROM Pend_data_to_import_accp_entp_dps8_pc6 ,ACCOUNT_PROPERTY_MSTR WHERE  ACCPM_PROP_CD  = 'MULTI_NOM_FLG' AND TypeOfTrans in ('','1','2') and  NOM_Sr_No = 1 
Union all SELECT DISTINCT boid, CONVERT(VARCHAR,ACCPM_PROP_ID) , 'NO'  	FROM Pend_data_to_import_accp_entp_dps8_pc6 ,ACCOUNT_PROPERTY_MSTR WHERE    ACCPM_PROP_CD  = 'MULTI_NOM_FLG' AND TypeOfTrans not in ('','1','2') and  NOM_Sr_No = 1 



) a 


SELECT BOID , PROPID , mAX(VALUE ) VALUE  INTO  #tmp_accp_value FROM #tmp_accp_value1
GROUP BY BOID , PROPID

sELECT dpam_id,dpam_sba_no  acno,'DP' accttype , (select top 1 ACCPM_PROP_CD from account_property_mstr where accpm_prop_ID = propid) code , propid, value ,'TMIG' cb,getdate() cd ,'TMIG' lb,getdate() ld ,1  delind 
into #tempprop1_old_todelete FROM (select distinct * from #tmp_accp_value ) a , dp_acct_mstr where dpam_sba_no = boid
and exists (select 1 from account_properties where dpam_id = accp_clisba_id  and accp_accpm_prop_id = propid and accp_deleted_ind = 1) 
and value =  ''

update accp set  accp_deleted_ind = 0 , accp_lst_upd_by ='BULK' , accp_lst_upd_dt = getdate() from account_properties  accp , #tempprop1_old_todelete 
where dpam_id = accp_clisba_id  and accp_accpm_prop_id = propid
and accp_value <>  value 
and value =  ''



sELECT dpam_id,dpam_sba_no  acno,'DP' accttype , (select top 1 ACCPM_PROP_CD from account_property_mstr where accpm_prop_ID = propid) code , propid, value ,'TMIG' cb,getdate() cd ,'TMIG' lb,getdate() ld ,1  delind 
into #tempprop1_old_deleted_revert FROM (select distinct * from #tmp_accp_value ) a , dp_acct_mstr where dpam_sba_no = boid
and exists (select 1 from account_properties where dpam_id = accp_clisba_id  and accp_accpm_prop_id = propid and accp_deleted_ind = 0) 
and value <> ''


update accp set accp_deleted_ind = 1 , accp_value = value, accp_lst_upd_by ='BULK' , accp_lst_upd_dt = getdate() from account_properties  accp , #tempprop1_old_deleted_revert 
where dpam_id = accp_clisba_id  and accp_accpm_prop_id = propid
and value <> ''



sELECT dpam_id,dpam_sba_no  acno,'DP' accttype , (select top 1 ACCPM_PROP_CD from account_property_mstr where accpm_prop_ID = propid) code , propid, value ,'TMIG' cb,getdate() cd ,'TMIG' lb,getdate() ld ,1  delind 
into #tempprop1_old FROM (select distinct * from #tmp_accp_value ) a , dp_acct_mstr where dpam_sba_no = boid
and exists (select 1 from account_properties where dpam_id = accp_clisba_id  and accp_accpm_prop_id = propid and accp_deleted_ind = 1) 
and value <> ''


update accp set accp_value = value, accp_lst_upd_by ='BULK' , accp_lst_upd_dt = getdate() from account_properties  accp , #tempprop1_old 
where dpam_id = accp_clisba_id  and accp_accpm_prop_id = propid
and accp_value <>  value 
and value <> ''



sELECT identity(numeric,1,1) id , dpam_id,dpam_sba_no  acno,'DP' accttype , (select top 1 ACCPM_PROP_CD from account_property_mstr where accpm_prop_ID = propid) code , propid, value ,'TMIG' cb,getdate() cd ,'TMIG' lb,getdate() ld ,1  delind 
into #tempprop1_new FROM (select distinct * from #tmp_accp_value ) a , dp_acct_mstr where dpam_sba_no = boid
and not exists (select 1 from account_properties where dpam_id = accp_clisba_id  and accp_accpm_prop_id = propid and accp_deleted_ind = 1) 
and value <> ''


declare @l_id numeric 
set @l_id  = 0 
sELECT @l_id  = MAX(accp_id) from (select accp_id from account_PROPERTIES 
union all 
select accp_id from accp_mak ) a 


insert into Account_PROPERTIES 
select @l_id + id 
,dpam_id
,acno
,accttype
,code
,propid 
,value
,cb
,cd
,lb
,ld
,delind from #tempprop1_new




drop table #temp

end

GO
