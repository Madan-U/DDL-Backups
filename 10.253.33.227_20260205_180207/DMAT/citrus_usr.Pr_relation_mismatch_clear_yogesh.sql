-- Object: PROCEDURE citrus_usr.Pr_relation_mismatch_clear_yogesh
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE   procedure [citrus_usr].[Pr_relation_mismatch_clear_yogesh]
as
begin
 
-- insert into entity_relationship_bak_dnd
--select *, 'MISMATCH CLEAR'   , getdate ()   
-- from entity_relationship 

-- DELETE DATA FOR BLANK FORM NUMBER
delete  from ENTITY_RELATIONSHIP where   ENTR_ACCT_NO = ''
 
-- INSERT DATA FOR MISSING RELATIONSHIP
select boid ,BOActDt  into #temp from dps8_pc1  where BOActDt <> '' 

select DPAM_SBA_NO ,DPAM_ID , DPAM_ACCT_NO,DPAM_CRN_NO  ,substring(BOActDt,5,4)+'-'+substring(BOActDt,3,2)+'-'+substring(BOActDt,1,2)+' 00:00:00.000' BOActDt 
 into #temp1 from #temp,dp_acct_mstr   where boid not in (select entr_sba from entity_relationship)
and boid = DPAM_SBA_NO 
and DPAM_SBA_NO like '120%'

		if exists (select top 1 *  from #temp1 )
 	    begin  
		insert into ENTITY_RELATIONSHIP
		select dpam_crn_no , dpam_acct_no , DPAM_SBA_NO, '1',NULL,	NULL,	NULL,	NULL,	NULL,	NULL,
			NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,	NULL,
		BOActDt ,'2100-12-31 00:00:00.000','MIG',GETDATE (),'MIG',GETDATE (),'1','3'
		from #temp1 
		where DPAM_CRN_NO not in (select entr_crn_no from entity_relationship where ENTR_DELETED_IND = '1'
		and getdate () between ENTR_FROM_DT and isnull(entr_to_dt,'Dec 31 2900') )
		end 
		else 
		begin 
		SELECT 'NO DATA FOUND IN MISSING CLIENT FOR RELATIONSHIP'
		end
		

--- MISSING BASE LOCATION
select boid , state, pincode , entm_id into #temp2 
 from dps8_pc1 ,entity_mstr  
where state = case when entm_name1 =  'TAMILNADU' then 'TAMIL NADU'
--when entm_name1 =  'PUDUCHERRY' then 'PONDICHERRY'
when entm_name1 =  'PONDICHERRY' then 'PUDUCHERRY'
when entm_name1 =  'CHATTISGARH' then 'CHHATTISGARH'
when entm_name1 =  'UTTARAKHAND' then 'UTTARAKHAND'
when entm_name1 =  'ORISSA' then 'ODISHA'
when entm_name1 =  'UTTARAKHAND' then 'UTTARANCHAL'
when entm_name1 =  'DADRA AND NAGAR HAVELI' then 'DADRA-NGR-HVELI-DAMAN-DIU'
when entm_name1 =  'ANDAMAN AND NICOBAR ISLANDS' then 'ANDAMAN & NICOBAR ISLANDS'
else entm_name1 end 
 and   boid in (select entr_sba from entity_relationship,dp_acct_mstr where entr_deleted_ind = '1'
and getdate () between ENTR_FROM_DT and isnull(entr_to_dt,'Dec 31 2900')  
and isnull(entr_dummy5, '0')= '0' 
and dpam_sba_no=entr_sba and dpam_stam_cd='active')
and entm_enttm_cd = 'BL'



--select * from #temp2, entity_relationship,dp_acct_mstr where entr_deleted_ind = '1'
--and getdate () between ENTR_FROM_DT and isnull(entr_to_dt,'Dec 31 2900')  
--and isnull(entr_dummy5, '0')= '0' 
--and dpam_sba_no=entr_sba and dpam_stam_cd='active'
--and boid = entr_sba and boid = dpam_sba_no

 
update   a 
set entr_dummy5 = entm_id 
 from #temp2, entity_relationship a,dp_acct_mstr where entr_deleted_ind = '1'
and getdate () between ENTR_FROM_DT and isnull(entr_to_dt,'Dec 31 2900')  
and isnull(entr_dummy5, '0')= '0' 
and dpam_sba_no=entr_sba and dpam_stam_cd='active'
and boid = entr_sba and boid = dpam_sba_no


		
end

GO
