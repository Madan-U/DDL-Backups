-- Object: PROCEDURE citrus_usr.pr_import_missingdata_KYC2
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE  proc [citrus_usr].[pr_import_missingdata_KYC2]
as
begin

 
 

select IDENTITY(numeric,1,1) id , DPAM_SBA_NO into #data from dp_Acct_mstr (Nolock) where isnull(dpam_bbo_code ,'')=''
and exists(select 1 from  VW_CITRUS_DPACCACTIVATION_For_new_dp_Router (Nolock)  where dp_id = DPAM_sba_no)
-- where dp_id in   ('1203320009855566','1203320009860371','1203320009861107'))
 --and dpam_sba_no in  ('1203320011495651')
--select * from client_dp_brkg where clidb_dpam_id=917395
--select * from entity_relationship where entr_sba ='1203320009734135'
--select * from  ABVSCITRUS.crmdb_a.dbo.VW_CITRUS_DPACCACTIVATIOn where dp_id = '1203320009734135'

select * into #CITRUS_DPACCACTIVATION from VW_CITRUS_DPACCACTIVATION_For_new_dp_Router (Nolock)  where dp_id in (select DPAM_SBA_NO from #data)

Create index #dp on #CITRUS_DPACCACTIVATION (DP_ID)


declare @l_count numeric
declare @l_counter numeric
declare @l_cur_boid varchar(16)

declare @l_br numeric
,@l_sb numeric
,@l_trd numeric
,@l_re numeric
,@l_ar numeric
,@l_bl numeric
,@l_crn_no  numeric
,@l_dpam_id  numeric
declare @L_ENTP_VALUE varchar(1000)
declare @L_ACCP_VALUE varchar(1000)
set @l_counter = 1 
select @l_count=COUNT(1) from #data 

while @l_counter <= @l_count 
begin 

select @l_cur_boid = DPAM_SBA_NO from #data  where id = @l_counter 
select @L_CRN_NO = dpam_Crn_no ,@l_dpam_id = dpam_id from dp_acct_mstr where DPAM_SBA_NO  = @l_cur_boid

if exists (select 1 from dp_acct_mstr (Nolock)  where DPAM_SBA_NO = @l_cur_boid and ISNULL(DPAM_BBO_CODE ,'')='') 
begin 
print @l_cur_boid
	/*brokerage*/
	update  [CLIENT_DP_BRKG] set clidb_deleted_ind = 0 
	where CLIDB_DPAM_ID in (select dpam_id from dp_acct_mstr (Nolock)  where DPAM_SBA_NO = @l_cur_boid ) 

	insert into client_dp_brkg
	select DPAM_ID  ,brom_id, 'TMIG',GETDATE(),'TMIG',GETDATE(),1,CONVERT(varchar(11),creation_date,109),'dec 31 2100' 
	from #CITRUS_DPACCACTIVATION  , dp_Acct_mstr (Nolock) , brokerage_mstr (Nolock)  where dp_id = @l_cur_boid
	and DPAM_SBA_NO = dp_id and template_code = BROM_DESC 
    /*brokerage*/
    
	/*relationship*/
	select @l_br = ENTM_ID  from #CITRUS_DPACCACTIVATION , entity_mstr where ENTM_ENTTM_CD ='BR'and replace(entm_short_name,'_br','') = branch_cd and dp_id = @l_cur_boid
	select @l_sb = ENTM_ID  from #CITRUS_DPACCACTIVATION , entity_mstr where ENTM_ENTTM_CD ='sb'and replace(entm_short_name,'_sb','') = subbroker  and dp_id = @l_cur_boid
	--select @l_trd = ENTM_ID  from ABVSCITRUS.crmdb_a.dbo.VW_CITRUS_DPACCACTIVATIOn, entity_mstr where ENTM_ENTTM_CD ='trd'and replace(entm_short_name,'_trd','') = trader   and dp_id = @l_cur_boid
	select @l_re = ENTM_ID  from #CITRUS_DPACCACTIVATION , entity_mstr where ENTM_ENTTM_CD ='re'and replace(entm_short_name,'_re','') = region   and dp_id = @l_cur_boid
	select @l_ar  = ENTM_ID  from #CITRUS_DPACCACTIVATION , entity_mstr 
	where ENTM_ENTTM_CD ='ar'and replace(entm_short_name,'_ar','') = area  and dp_id = @l_cur_boid
	
	--select @l_bl  = ENTM_ID  from ABVSCITRUS.crmdb_a.dbo.VW_CITRUS_DPACCACTIVATIOn, entity_mstr ,
	--statecountrylist_kyc
	--where ENTM_ENTTM_CD ='BL'and replace(entm_short_name,'_bl','') = BL  and dp_id = @l_cur_boid
	
	
	/*relationship*/
    if 1 =  (select count(1) from entity_relationship where ENTR_SBA =@l_cur_boid and GETDATE() between ENTR_FROM_DT and isnull(ENTR_TO_DT ,'dec 31 2100')) 
    begin 
    
    update entr set entr_from_dt = CONVERT(varchar(11),creation_date,109) 
    , entr_re = @l_re
	,entr_ar =  @l_ar
	,entr_br = @l_br
	,entr_dummy4 = @l_sb
	--,entr_dummy5 = @l_bl
	from entity_relationship entr (Nolock) ,  #CITRUS_DPACCACTIVATION (Nolock) 
	where ENTR_SBA = dp_id and ENTR_SBA  = @l_cur_boid
	and GETDATE() between ENTR_FROM_DT and isnull(ENTR_TO_DT ,'dec 31 2100')
	
	
    end 
    /*relationship*/
    /*dis_flag*/
    SELECT DISTINCT @L_ENTP_VALUE = CONVERT(VARCHAR,ENTPM_PROP_ID) + '|*~|' + Dis_flag + '|*~|*|~*' 
    FROM #CITRUS_DPACCACTIVATION 
     ,ENTITY_PROPERTY_MSTR  WHERE dp_id = @l_cur_boid AND ENTPM_CD   = 'DIS_REQ'  
       print @L_ENTP_VALUE
   EXEC PR_INS_UPD_ENTP '1','EDT','MIG',@L_CRN_NO,'',@L_ENTP_VALUE,'',0,'*|~*','|*~|',''    
	/*dis_flag*/
	/*ecs,ecn */
	SELECT DISTINCT  @L_ACCP_VALUE = CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' + UPPER(ISNULL(LTRIM(RTRIM(ECN_FLAG)),'')) + '|*~|*|~*' 
	FROM #CITRUS_DPACCACTIVATION  
	,ACCOUNT_PROPERTY_MSTR WHERE dp_id = @l_cur_boid AND ACCPM_PROP_CD = 'ECN_FLAG'  
         SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' +case when  UPPER(ISNULL(LTRIM(RTRIM(ECs_FLAG)),''))='yes' then '1' else '0' end  + '|*~|*|~*' 
          FROM #CITRUS_DPACCACTIVATION  ,ACCOUNT_PROPERTY_MSTR 
          WHERE dp_id = @l_cur_boid AND ACCPM_PROP_CD  = 'ECS_FLG'  
            SELECT DISTINCT @L_ACCP_VALUE = ISNULL(@L_ACCP_VALUE,'')+ CONVERT(VARCHAR,ACCPM_PROP_ID) + '|*~|' 
            + UPPER(ISNULL(LTRIM(RTRIM(bo_partycode )),'')) + '|*~|*|~*' 
          FROM #CITRUS_DPACCACTIVATION  ,ACCOUNT_PROPERTY_MSTR 
          WHERE dp_id = @l_cur_boid AND ACCPM_PROP_CD  = 'bbo_code'  
         print @L_ENTP_VALUE
          EXEC PR_INS_UPD_ACCP @L_CRN_NO ,'EDT','MIG',@L_DPAM_ID,@l_cur_boid,'DP',@L_ACCP_VALUE,'' ,0,'*|~*','|*~|',''  
          
	/*ecs,ecn */
	
end 



set @l_counter  = @l_counter + 1 

end 


update a set dpam_bbo_code=accp_value from dp_acct_mstr  a (Nolock) 
,account_properties (Nolock) 
where isnull(dpam_bbo_code,'')<>accp_value
--and accp_lst_upd_dt >='sep  1 2012'
and accp_clisba_id = dpam_id 
and ACCP_ACCPM_PROP_CD = 'bbo_code' 
--and isnull(dpam_bbo_code,'')<>accp_value

Update T Set NISE_PARTY_CODE =DPAM_BBO_CODE  from TBL_CLIENT_MASTER T (Nolock) ,DP_ACCT_MSTR D  (Nolock)  where isnull(NISE_PARTY_CODE,'') =''
and DPAM_SBA_NO =Client_Code and isnull(DPAM_BBO_CODE,'')<>'' 

UPDATE S Set CM_BLSAVINGCD= DPAM_BBO_CODE from Synergy_Client_Master S (Nolock) ,DP_ACCT_MSTR D (Nolock)  where  
 DPAM_SBA_NO =CM_CD  and isnull(CM_BLSAVINGCD,'')=''  and isnull(DPAM_BBO_CODE,'')<>'' 



end

GO
