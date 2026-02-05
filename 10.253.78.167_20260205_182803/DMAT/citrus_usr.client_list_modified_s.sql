-- Object: PROCEDURE citrus_usr.client_list_modified_s
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------



--exec client_list_modified_s '00000070', 'poa'

CREATE    PROCEDURE [citrus_usr].[client_list_modified_s]  
(   
@PA_FROM_ACCTNO VARCHAR(8) ,
@PA_action varchar(50)
)  
AS 


BEGIN                        

    declare @l_dpam_id varchar(15)
    declare @l_crn  varchar (12)
    declare @pa_errmsg varchar (8000)
    select @l_dpam_id = dpam_id , @l_crn = dpam_Crn_no from dp_acct_mstr 
    where     right ( dpam_sba_no,8) = @PA_FROM_ACCTNO
    
		if @PA_FROM_ACCTNO = ''
		begin 
		set  @pa_errmsg =  'PLEASE PROVIDE LAST 8 DIGIT OF BOID'
		select @pa_errmsg 
		return 
		end  
    
		if exists (select top 1 * from  dp_acct_mstr 
		where     right ( dpam_sba_no,8) = @PA_FROM_ACCTNO and  dpam_stam_cd <> 'Active')
		begin 
		set  @pa_errmsg =  'ACCOUNT IS NOT ACTIVE'
		select @pa_errmsg 
		return 
		end  
       
        if not  exists (select * from client_list_modified where right (clic_mod_dpam_sba_no,8) = @PA_FROM_ACCTNO
		and clic_mod_action like '%'+@PA_action+'%'  )
		begin 
		set  @pa_errmsg =  'NO MODIFICATION DONE'
		select @pa_errmsg 
		return 
		end  
		
        
    
       
    
    
		if @PA_action like  '%poa%'
	    
	    
		begin 
		select DPAM_ID DPAMID, DPAM_CRN_NO CRNNO,DPAM_SBA_NO,DPAM_SBA_NAME,clic_mod_action,clic_mod_created_by [MOD MAKER],clic_mod_created_dt,clic_mod_lst_upd_by [MOD CHECKER],
		clic_mod_lst_upd_dt,DPAM_STAM_CD STATUS,dpam_subcm_cd SUBCMCD,dpam_batch_no ACBATCH,clic_mod_batch_no MODBATCH
		from client_list_modified , dp_acct_mstr where right (clic_mod_dpam_sba_no,8) = @PA_FROM_ACCTNO
		and clic_mod_action like  'poa%'and DPAM_SBA_NO  = clic_mod_dpam_sba_no order by 4 desc 
		select * from client_list where CLIM_TAB like '%poa%' and clim_crn_no = @l_crn
		--select * from dp_acct_mstr where dpam_id = @l_dpam_id
		--select * from client_mstr where clim_Crn_no = @l_crn
		select * from dps8_pc5 where  right(boid,8) = right(@PA_FROM_ACCTNO,8)
		select 'MAKER',* from dp_poa_Dtls_mak where dppd_dpam_id = @l_dpam_id
		select 'MASTER',* from dp_poa_Dtls where dppd_dpam_id = @l_dpam_id
		
	     
		end 
    
     
		if @PA_action like  'bank%'
	    
		begin 
	    
		select DPAM_ID DPAMID, DPAM_CRN_NO CRNNO,DPAM_SBA_NO,DPAM_SBA_NAME,clic_mod_action,clic_mod_created_by [MOD MAKER],clic_mod_created_dt,clic_mod_lst_upd_by [MOD CHECKER],
		clic_mod_lst_upd_dt,DPAM_STAM_CD STATUS,dpam_subcm_cd SUBCMCD,dpam_batch_no ACBATCH,clic_mod_batch_no MODBATCH
		from client_list_modified , dp_acct_mstr where right (clic_mod_dpam_sba_no,8) = @PA_FROM_ACCTNO
		and clic_mod_action like  'bank%'and DPAM_SBA_NO  = clic_mod_dpam_sba_no order by 4 desc 
		select * from client_list where CLIM_TAB like  'bank%' and clim_crn_no = @l_crn
		--select * from dp_acct_mstr where dpam_id = @l_dpam_id
		--select * from client_mstr where clim_Crn_no = @l_crn
		select 'MAKER', * from client_bank_accts_mak where CLIBA_CLISBA_ID = @l_dpam_id
		select 'MASTER', * from client_bank_accts where CLIBA_CLISBA_ID = @l_dpam_id
		select * from bank_mstr where banm_id in (select cliba_banm_id  from client_bank_accts where CLIBA_CLISBA_ID = @l_dpam_id)
		
	     
		end 
    
    
    
          
        if @PA_action like  'BSDA%'
    
		begin 
	    
		select DPAM_ID DPAMID, DPAM_CRN_NO CRNNO,DPAM_SBA_NO,DPAM_SBA_NAME,clic_mod_action,clic_mod_created_by [MOD MAKER],clic_mod_created_dt,clic_mod_lst_upd_by [MOD CHECKER],
		clic_mod_lst_upd_dt,DPAM_STAM_CD STATUS,dpam_subcm_cd SUBCMCD,dpam_batch_no ACBATCH,clic_mod_batch_no MODBATCH
		from client_list_modified , dp_acct_mstr where right (clic_mod_dpam_sba_no,8) = @PA_FROM_ACCTNO
		and clic_mod_action like  'BSDA%'and DPAM_SBA_NO  = clic_mod_dpam_sba_no order by 4 desc 
		--select * from client_mstr where clim_Crn_no = @l_crn
		select * from client_list where CLIM_TAB like  'ACCOUN%'and clim_crn_no = @l_crn
		select 'MAKER', * from ACCP_MAK where accp_clisba_id = @l_dpam_id AND ACCP_ACCPM_PROP_CD = 'BSDA'
		select 'MASTER', * from account_properties where accp_clisba_id = @l_dpam_id AND ACCP_ACCPM_PROP_CD = 'BSDA'
		 
		end 
    
        if @PA_action like  'RGESS%'
    
		begin 
	    
		select DPAM_ID DPAMID, DPAM_CRN_NO CRNNO,DPAM_SBA_NO,DPAM_SBA_NAME,clic_mod_action,clic_mod_created_by [MOD MAKER],clic_mod_created_dt,clic_mod_lst_upd_by [MOD CHECKER],
		clic_mod_lst_upd_dt,DPAM_STAM_CD STATUS,dpam_subcm_cd SUBCMCD,dpam_batch_no ACBATCH,clic_mod_batch_no MODBATCH
		from client_list_modified , dp_acct_mstr where right (clic_mod_dpam_sba_no,8) = @PA_FROM_ACCTNO
		and clic_mod_action like  'RGESS%'and DPAM_SBA_NO  = clic_mod_dpam_sba_no order by 4 desc 
		--select * from client_mstr where clim_Crn_no = @l_crn
		select * from client_list where CLIM_TAB like  'ACCOUN%'and clim_crn_no = @l_crn
		select 'MAKER', * from ACCP_MAK where accp_clisba_id = @l_dpam_id AND ACCP_ACCPM_PROP_CD = 'RGESS_FLAG'
		select 'MASTER', * from account_properties where accp_clisba_id = @l_dpam_id AND ACCP_ACCPM_PROP_CD = 'RGESS_FLAG'
		 
		end 
    
    
    
        if @PA_action like  'INCOME%'
    
		begin 
	    
		select DPAM_ID DPAMID, DPAM_CRN_NO CRNNO,DPAM_SBA_NO,DPAM_SBA_NAME,clic_mod_action,clic_mod_created_by [MOD MAKER],clic_mod_created_dt,clic_mod_lst_upd_by [MOD CHECKER],
		clic_mod_lst_upd_dt,DPAM_STAM_CD STATUS,dpam_subcm_cd SUBCMCD,dpam_batch_no ACBATCH,clic_mod_batch_no MODBATCH
		from client_list_modified , dp_acct_mstr where right (clic_mod_dpam_sba_no,8) = @PA_FROM_ACCTNO
		and clic_mod_action like  'INCOME%'and DPAM_SBA_NO  = clic_mod_dpam_sba_no order by 4 desc 
		--select * from client_mstr where clim_Crn_no = @l_crn
		select * from client_list where CLIM_TAB like  'ENTITY PROPERTIES%'and clim_crn_no = @l_crn
		select 'MAKER' , * from ENTITY_PROPERTIES_MAK where ENTP_ENT_ID  = @l_crn AND ENTP_ENTPM_CD  = 'ANNUAL_INCOME'
		select 'MASTER',  * from ENTITY_PROPERTIES where ENTP_ENT_ID  = @l_crn AND ENTP_ENTPM_CD  = 'ANNUAL_INCOME'
		 
		end 
		
		
        if @PA_action like  'Nom%'
    
		begin 
	    
		select DPAM_ID DPAMID, DPAM_CRN_NO CRNNO,DPAM_SBA_NO,DPAM_SBA_NAME,clic_mod_action,clic_mod_created_by [MOD MAKER],clic_mod_created_dt,clic_mod_lst_upd_by [MOD CHECKER],
		clic_mod_lst_upd_dt,DPAM_STAM_CD STATUS,dpam_subcm_cd SUBCMCD,dpam_batch_no ACBATCH,clic_mod_batch_no MODBATCH
		from client_list_modified , dp_acct_mstr where right (clic_mod_dpam_sba_no,8) = @PA_FROM_ACCTNO
		and clic_mod_action like  'Nom%'and DPAM_SBA_NO  = clic_mod_dpam_sba_no order by 4 desc 
		--select * from client_mstr where clim_Crn_no = @l_crn
		select * from client_list where CLIM_TAB like  'Nom%'and clim_crn_no = @l_crn
		select 'MAKER' ,* from Nominee_Multi_mak  where Nom_dpam_id = @l_dpam_id
		select 'MASTER',* from Nominee_Multi   where Nom_dpam_id = @l_dpam_id
		 
		end 
		
		if @PA_action like  'Sub%'
    
		begin 
	    
		select DPAM_ID DPAMID, DPAM_CRN_NO CRNNO,DPAM_SBA_NO,DPAM_SBA_NAME,clic_mod_action,clic_mod_created_by [MOD MAKER],clic_mod_created_dt,clic_mod_lst_upd_by [MOD CHECKER],
		clic_mod_lst_upd_dt,DPAM_STAM_CD STATUS,dpam_subcm_cd SUBCMCD,dpam_batch_no ACBATCH,clic_mod_batch_no MODBATCH
		from client_list_modified , dp_acct_mstr where right (clic_mod_dpam_sba_no,8) = @PA_FROM_ACCTNO
		and clic_mod_action like  'sub%'and DPAM_SBA_NO  = clic_mod_dpam_sba_no order by 4 desc 
		--select * from client_mstr where clim_Crn_no = @l_crn
		select * from client_list where CLIM_TAB like  'dp acct%'and clim_crn_no = @l_crn
		select 'MAKER',DPAM_SBA_NO,DPAM_STAM_CD,DPAM_CREATED_BY,DPAM_CREATED_DT,DPAM_LST_UPD_BY,DPAM_LST_UPD_DT,DPAM_DELETED_IND,dpam_subcm_cd from DP_ACCT_MSTR_MAK where DPAM_ID = @l_dpam_id
		select 'MASTER',DPAM_SBA_NO,DPAM_STAM_CD,DPAM_CREATED_BY,DPAM_CREATED_DT,DPAM_LST_UPD_BY,DPAM_LST_UPD_DT,DPAM_DELETED_IND,dpam_subcm_cd from DP_ACCT_MSTR  where DPAM_ID = @l_dpam_id
		end
       
        if @PA_action =  ''
    
		begin 
		select DPAM_ID DPAMID, DPAM_CRN_NO CRNNO,DPAM_SBA_NO,DPAM_SBA_NAME,clic_mod_action,clic_mod_created_by [MOD MAKER],clic_mod_created_dt,clic_mod_lst_upd_by [MOD CHECKER],
		clic_mod_lst_upd_dt,DPAM_STAM_CD STATUS,dpam_subcm_cd SUBCMCD,dpam_batch_no ACBATCH,clic_mod_batch_no MODBATCH
		from client_list_modified , dp_acct_mstr where right (clic_mod_dpam_sba_no,8) = @PA_FROM_ACCTNO
		and DPAM_SBA_NO  = clic_mod_dpam_sba_no order by 4 desc
		select 'POA MAKER',* from dp_poa_Dtls_mak where dppd_dpam_id = @l_dpam_id
		select 'POA MASTER', * from dp_poa_Dtls where dppd_dpam_id = @l_dpam_id
		select 'BANK MAKER',* from client_bank_accts_mak where CLIBA_CLISBA_ID = @l_dpam_id
		select 'BANK MASTER',* from client_bank_accts where CLIBA_CLISBA_ID = @l_dpam_id
		select * from bank_mstr where banm_id in (select cliba_banm_id  from client_bank_accts where CLIBA_CLISBA_ID = @l_dpam_id)
		select 'CLIENT LIST',* from client_list where clim_crn_no = @l_crn
		select * from entity_properties where entp_ent_id = @l_crn
		select * from account_properties where accp_clisba_id = @l_dpam_id
		select * from entity_adr_conc where entac_ent_id = @l_crn
     
		end 
                 
END

GO
