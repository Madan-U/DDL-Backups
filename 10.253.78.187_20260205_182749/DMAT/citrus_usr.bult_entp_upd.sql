-- Object: PROCEDURE citrus_usr.bult_entp_upd
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------



   CREATE  proc [citrus_usr].[bult_entp_upd]
   as
   begin 
   select * into #TMP_PROPERTY from (        

        SELECT DISTINCT BOID,  CONVERT(VARCHAR,'28')prop_id , UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','NATIONALITY',UPPER(ISNULL(LTRIM(RTRIM(NATCD)),'')))) value FROM DPB9_PC1  
UNION ALL SELECT DISTINCT BOID,  CONVERT(VARCHAR,'65') , UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','OCCUPATION',UPPER(ISNULL(LTRIM(RTRIM(OCCUPATION)),''))))  FROM DPB9_PC1  
UNION ALL SELECT DISTINCT BOID  , CONVERT(VARCHAR,'38') , UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','TAX_DEDUCTION',UPPER(ISNULL(LTRIM(RTRIM(BENTAXDEDSTAT)),'')))) FROM DPB9_PC1   
UNION ALL SELECT DISTINCT BOID,  CONVERT(VARCHAR,'12') , UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','GEOGRAPHICAL',UPPER(ISNULL(LTRIM(RTRIM(GEOGCD)),''))))  FROM DPB9_PC1   
UNION ALL SELECT DISTINCT BOID,  CONVERT(VARCHAR,'42') , UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','EDUCATION',UPPER(ISNULL(LTRIM(RTRIM(EDU)),''))))  FROM DPB9_PC1   
UNION ALL SELECT DISTINCT BOID,  CONVERT(VARCHAR,'40') , UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','LANGUAGE',UPPER(ISNULL(LTRIM(RTRIM(LANGCD)),''))))  FROM DPB9_PC1 
UNION ALL SELECT DISTINCT BOID,  CONVERT(VARCHAR,'64') , CASE WHEN UPPER(ISNULL(LTRIM(RTRIM(STAFF)),'')) = 'N' THEN 'NONE'   
				  WHEN UPPER(ISNULL(LTRIM(RTRIM(STAFF)),'')) = 'R' THEN 'RELATIVE'  
				  WHEN UPPER(ISNULL(LTRIM(RTRIM(STAFF)),'')) = 'S' THEN 'STAFF' ELSE '' END    FROM DPB9_PC1   
--UNION ALL SELECT DISTINCT BOID,  CONVERT(VARCHAR,'15') , UPPER([CITRUS_USR].[FN_REVERSE_MAPPING]('CDSL','ANNUAL_INCOME',UPPER(ISNULL(LTRIM(RTRIM(ANNINCOMECD)),''))))  FROM DPB9_PC1   
--UNION ALL SELECT DISTINCT BOID, CONVERT(VARCHAR,ENTPM_PROP_ID) , UPPER(ISNULL(LTRIM(RTRIM(PANGIR)),'')) FROM DPB9_PC1 ,ENTITY_PROPERTY_MSTR  WHERE  ENTPM_CD   = 'PAN_GIR_NO'                             
union all SELECT  Distinct boid  ,CONVERT(VARCHAR,ENTPM_PROP_ID) ,case when dpam_subcm_cd in ('2156','2155','2150','082104','022512','022552','102624','122624','192624','022545','512624','022567','0225105','0225104') then '' else  UPPER([CITRUS_USR].fn_get_PanBOBONA_Val_reverse('annual_income',UPPER(ISNULL(LTRIM(RTRIM(ANNINCOMECD)),'')))) end   FROM DPB9_PC1 ,ENTITY_PROPERTY_MSTR , DP_ACCT_MSTR  WHERE  ENTPM_CD   = 'ANNUAL_INCOME'  and boid = dpam_sba_no  and UPPER([CITRUS_USR].fn_get_PanBOBONA_Val_reverse('annual_income',UPPER(ISNULL(LTRIM(RTRIM(ANNINCOMECD)),''))))  <> '' 
union all select Distinct boid  ,CONVERT(VARCHAR,ENTPM_PROP_ID) , UPPER(ISNULL(LTRIM(RTRIM(PANGIR)),'')) FROM DPB9_PC1 ,ENTITY_PROPERTY_MSTR  WHERE  ENTPM_CD   = 'PAN_GIR_NO'                             
union all SELECT DISTINCT boid  ,CONVERT(VARCHAR,ENTPM_PROP_ID) , case when dpam_subcm_cd in ('2156','2155','2150','082104','022512','022552','102624','122624','192624','022545','512624','022567','0225105','0225104') then  UPPER([CITRUS_USR].fn_get_PanBOBONA_Val_reverse('annual_incomeNI',UPPER(ISNULL(LTRIM(RTRIM(ANNINCOMECD)),'')))) else '' end  FROM DPB9_PC1  ,ENTITY_PROPERTY_MSTR , DP_ACCT_MSTR  WHERE  ENTPM_CD   = 'annual_incomeNI'   and boid = dpam_sba_no  


        ) a 




sELECT dpam_crn_no,'' acno,pROP_ID 
,(select top 1 entpm_cd from entity_property_mstr where ENTPM_PROP_ID = pROP_ID) code , value ,'TMIG' cb,getdate() cd ,'TMIG' lb,getdate() ld ,1  delind 
into #tempprop_old FROM #TMP_PROPERTY , dp_acct_mstr where dpam_sba_no = boid
and exists (select 1 from entity_properties where entp_ent_id = dpam_crn_no and entp_entpm_prop_id = prop_id and entp_deleted_ind = 1) 
and value = ''

update entp set ENTP_DELETED_IND= 0 , ENTP_LST_UPD_BY='BULK' , ENTP_LST_UPD_DT= getdate() from entity_properties  entp , #tempprop_old 
where entp_ent_id = dpam_crn_no 
and entp_entpm_prop_id = prop_id 
and entp_value <>  value 
and value = ''

  


sELECT dpam_crn_no,'' acno,pROP_ID 
,(select top 1 entpm_cd from entity_property_mstr where ENTPM_PROP_ID = pROP_ID) code , value ,'TMIG' cb,getdate() cd ,'TMIG' lb,getdate() ld ,1  delind 
into #tempprop_old_todelete FROM #TMP_PROPERTY , dp_acct_mstr where dpam_sba_no = boid
and exists (select 1 from entity_properties where entp_ent_id = dpam_crn_no and entp_entpm_prop_id = prop_id and entp_deleted_ind = 1) 
and value <> ''

update entp set entp_value = value , ENTP_LST_UPD_BY='BULK' , ENTP_LST_UPD_DT= getdate() from entity_properties  entp , #tempprop_old_todelete 
where entp_ent_id = dpam_crn_no 
and entp_entpm_prop_id = prop_id 
and entp_value <>  value 
and value <> ''




sELECT identity(numeric,1,1) id , dpam_crn_no,'' acno,pROP_ID 
,(select top 1 entpm_cd from entity_property_mstr where ENTPM_PROP_ID = pROP_ID) code , value ,'TMIG' cb,getdate() cd ,'TMIG' lb,getdate() ld ,1  delind 
into #tempprop_new FROM #TMP_PROPERTY , dp_acct_mstr where dpam_sba_no = boid
and not exists (select 1 from entity_properties where entp_ent_id = dpam_crn_no and entp_entpm_prop_id = prop_id and entp_deleted_ind = 1 ) 
and value <> ''

declare @l_id numeric 
set @l_id  = 0 
sELECT @l_id  = MAX(entp_id) from (select entp_id from ENTITY_PROPERTIES 
union all 
select entp_id from ENTITY_PROPERTIES_mak ) a 



insert into ENTITY_PROPERTIES 
select @l_id + id ,dpam_crn_no	,acno	,pROP_ID	,code	,value	,cb	,cd	,lb	,ld	,delind from #tempprop_new 

end

GO
