-- Object: PROCEDURE citrus_usr.pr_transmission_letter
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------





--exec pr_transmission_letter 0,'T','nov  1 2014','nov 30 2014','','',''

CREATE procedure [citrus_usr].[pr_transmission_letter](
								@pa_id int,
								@pa_rpt_type varchar(10),
								@pa_from_dt datetime,
								@pa_to_dt datetime,
								@pa_clientid varchar(16),
								@pa_filler varchar(20),
								@pa_out   varchar(8000) out
)
as
begin

select distinct dpam_sba_no cdshm_ben_acct_no,dpam_sba_name,dphmc_isin cdshm_isin,dphmc_lockin_qty cdshm_qty,ISIN_NAME,
		  Reg_cd=entm_short_name,Reg_name=entm_name1		
		 ,Reg_adr1=LTRIM(RTRIM(LEFT([citrus_usr].[FN_SPLITVAL_BY](citrus_usr.fn_addr_value(entm_id,'OFF_ADR1'),1,'|*~|'),100)))  
		 ,Reg_adr2=LTRIM(RTRIM(LEFT([citrus_usr].[FN_SPLITVAL_BY](citrus_usr.fn_addr_value(entm_id,'OFF_ADR1'),2,'|*~|'),100)))  
		 ,Reg_adr3=LTRIM(RTRIM(LEFT([citrus_usr].[FN_SPLITVAL_BY](citrus_usr.fn_addr_value(entm_id,'OFF_ADR1'),3,'|*~|'),100)))  
		 ,Reg_adr4=LTRIM(RTRIM(LEFT([citrus_usr].[FN_SPLITVAL_BY](citrus_usr.fn_addr_value(entm_id,'OFF_ADR1'),4,'|*~|'),100)))  
		 ,Reg_adr5=LTRIM(RTRIM(LEFT([citrus_usr].[FN_SPLITVAL_BY](citrus_usr.fn_addr_value(entm_id,'OFF_ADR1'),5,'|*~|'),100)))  
		 ,Reg_adr6=LTRIM(RTRIM(LEFT([citrus_usr].[FN_SPLITVAL_BY](citrus_usr.fn_addr_value(entm_id,'OFF_ADR1'),6,'|*~|'),100)))  
		 ,Reg_adr7=LTRIM(RTRIM(LEFT([citrus_usr].[FN_SPLITVAL_BY](citrus_usr.fn_addr_value(entm_id,'OFF_ADR1'),7,'|*~|'),100)))  
		 ,Reg_phone=isnull(citrus_usr.fn_conc_value(entm_id,'OFF_PH1'),'') 
		 ,Reg_fax=isnull(citrus_usr.fn_conc_value(entm_id,'FAX'),'')  
		 ,Reg_email = isnull(citrus_usr.fn_conc_value(entm_id,'EMAIL'),'')	
from dp_acct_mstr (nolock), dp_hldg_mstr_cdsl (nolock) ,
isin_mstr(nolock) left outer join entity_mstr(nolock) on  'RTA_' + ltrim(rtrim(isin_reg_cd)) = ltrim(rtrim(entm_short_name)) 
where dpam_sba_no = @pa_clientid
and dpam_stam_cd = '04'
and dphmc_deleted_ind =1 
and dphmc_isin = isin_cd
and isnull(DPHMC_LOCKIN_QTY,0) <> 0 and dphmc_dpam_id=DPAM_ID

--full commented on 01/01/2015

--	if @pa_rpt_type = 'A' -- account transfer
--	begin
--		--select top 2 * from tempdatafetchshilpa
--	--select * from temp_trans
--	--		return
--		
--		select distinct cdshm_ben_acct_no,dpam_sba_name,cdshm_tras_dt,cdshm_isin,cdshm_qty,cdshm_counter_boid,ISIN_NAME,cdshm_counter_boid,counternm=(select dpam_sba_name from dp_acct_mstr where dpam_sba_no = cdshm_counter_boid),
--		  Reg_cd=entm_short_name,Reg_name=entm_name1
--		  --,Reg_adr=ltrim(rtrim(replace(citrus_usr.fn_addr_value(entm_id,'OFF_ADR1'),'|*~|',', ')))  
--		  ,Reg_adr1=LTRIM(RTRIM(LEFT([citrus_usr].[FN_SPLITVAL_BY](citrus_usr.fn_addr_value(entm_id,'OFF_ADR1'),1,'|*~|'),100)))  
--		 ,Reg_adr2=LTRIM(RTRIM(LEFT([citrus_usr].[FN_SPLITVAL_BY](citrus_usr.fn_addr_value(entm_id,'OFF_ADR1'),2,'|*~|'),100)))  
--		 ,Reg_adr3=LTRIM(RTRIM(LEFT([citrus_usr].[FN_SPLITVAL_BY](citrus_usr.fn_addr_value(entm_id,'OFF_ADR1'),3,'|*~|'),100)))  
--		 ,Reg_adr4=LTRIM(RTRIM(LEFT([citrus_usr].[FN_SPLITVAL_BY](citrus_usr.fn_addr_value(entm_id,'OFF_ADR1'),4,'|*~|'),100)))  
--		 ,Reg_adr5=LTRIM(RTRIM(LEFT([citrus_usr].[FN_SPLITVAL_BY](citrus_usr.fn_addr_value(entm_id,'OFF_ADR1'),5,'|*~|'),100)))  
--		 ,Reg_adr6=LTRIM(RTRIM(LEFT([citrus_usr].[FN_SPLITVAL_BY](citrus_usr.fn_addr_value(entm_id,'OFF_ADR1'),6,'|*~|'),100)))  
--		 ,Reg_adr7=LTRIM(RTRIM(LEFT([citrus_usr].[FN_SPLITVAL_BY](citrus_usr.fn_addr_value(entm_id,'OFF_ADR1'),7,'|*~|'),100)))  
--		 ,Reg_phone=isnull(citrus_usr.fn_conc_value(entm_id,'OFF_PH1'),'') 
--		 ,Reg_fax=isnull(citrus_usr.fn_conc_value(entm_id,'FAX'),'')  
--		 ,Reg_email = isnull(citrus_usr.fn_conc_value(entm_id,'EMAIL'),'')		 
--		from cdsl_holding_dtls ,dp_acct_mstr
--		,isin_mstr left outer join entity_mstr on  'RTA_' + ltrim(rtrim(isin_reg_cd)) = ltrim(rtrim(entm_short_name)) 
--		
--		where --cdshm_ben_acct_no ='1201090005245315'
--		citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,27,'~') in(0,1)
--		and cdshm_tratm_cd = '2277'
--		and cdshm_cdas_tras_type = '18'
--		and dpam_sba_no = cdshm_ben_acct_no
--		and dpam_id = CDSHM_DPAM_ID
--		and dpam_stam_cd = '04'
--		and isin_cd = cdshm_isin 
--		and exists(select dphmc_dpam_id from dp_hldg_mstr_cdsl where dphmc_deleted_ind =1 
--					and isnull(dphmc_free_qty,0) <> 0 and dphmc_dpam_id = CDSHM_DPAM_ID and cdshm_isin =DPHMC_ISIN ) -- transmission without lockin -- acct transfer
--		and cdshm_tras_dt between @pa_from_dt and @pa_to_dt
--		and cdshm_ben_acct_no like case when isnull(@pa_clientid,'') <> '' then @pa_clientid else '%' end
--		order by cdshm_ben_acct_no,cdshm_isin
--	end
--
--	if @pa_rpt_type = 'T' -- account transmission with lockin 
--	begin
--	--select top 2 * from tempdatafetchshilpa
----select * from temp_trans
----	return
--	
--		select distinct cdshm_ben_acct_no,dpam_sba_name,cdshm_tras_dt,cdshm_isin,cdshm_qty,cdshm_counter_boid,ISIN_NAME,cdshm_counter_boid,counternm=(select dpam_sba_name from dp_acct_mstr where dpam_sba_no = cdshm_counter_boid),
--		 Reg_cd=entm_short_name,Reg_name=entm_name1
--		 --,Reg_adr=ltrim(rtrim(replace(citrus_usr.fn_addr_value(entm_id,'OFF_ADR1'),'|*~|',', ')))  
--		 ,Reg_adr1=LTRIM(RTRIM(LEFT([citrus_usr].[FN_SPLITVAL_BY](citrus_usr.fn_addr_value(entm_id,'OFF_ADR1'),1,'|*~|'),100)))  
--		 ,Reg_adr2=LTRIM(RTRIM(LEFT([citrus_usr].[FN_SPLITVAL_BY](citrus_usr.fn_addr_value(entm_id,'OFF_ADR1'),2,'|*~|'),100)))  
--		 ,Reg_adr3=LTRIM(RTRIM(LEFT([citrus_usr].[FN_SPLITVAL_BY](citrus_usr.fn_addr_value(entm_id,'OFF_ADR1'),3,'|*~|'),100)))  
--		 ,Reg_adr4=LTRIM(RTRIM(LEFT([citrus_usr].[FN_SPLITVAL_BY](citrus_usr.fn_addr_value(entm_id,'OFF_ADR1'),4,'|*~|'),100)))  
--		 ,Reg_adr5=LTRIM(RTRIM(LEFT([citrus_usr].[FN_SPLITVAL_BY](citrus_usr.fn_addr_value(entm_id,'OFF_ADR1'),5,'|*~|'),100)))  
--		 ,Reg_adr6=LTRIM(RTRIM(LEFT([citrus_usr].[FN_SPLITVAL_BY](citrus_usr.fn_addr_value(entm_id,'OFF_ADR1'),6,'|*~|'),100)))  
--		 ,Reg_adr7=LTRIM(RTRIM(LEFT([citrus_usr].[FN_SPLITVAL_BY](citrus_usr.fn_addr_value(entm_id,'OFF_ADR1'),7,'|*~|'),100)))  
--		 ,Reg_phone=isnull(citrus_usr.fn_conc_value(entm_id,'OFF_PH1'),'') 
--		 ,Reg_fax=isnull(citrus_usr.fn_conc_value(entm_id,'FAX'),'')  
--		 ,Reg_email = isnull(citrus_usr.fn_conc_value(entm_id,'EMAIL'),'')	
--		from cdsl_holding_dtls ,dp_acct_mstr
--		,isin_mstr left outer join entity_mstr on  'RTA_' + ltrim(rtrim(isin_reg_cd)) = ltrim(rtrim(entm_short_name)) 
--		where --cdshm_ben_acct_no ='1201090005245315'
--		citrus_usr.fn_splitval_by(cdshm_trans_cdas_code,27,'~') in(0,1)
--		and cdshm_tratm_cd = '2277'
--		and cdshm_cdas_tras_type = '18'
--		and dpam_sba_no = cdshm_ben_acct_no
--		and dpam_id = CDSHM_DPAM_ID
--		and dpam_stam_cd = '04'
--		and isin_cd = cdshm_isin 
--		and exists(select dphmc_dpam_id from dp_hldg_mstr_cdsl where dphmc_deleted_ind =1 
--					and isnull(DPHMC_LOCKIN_QTY,0) <> 0 and dphmc_dpam_id= CDSHM_DPAM_ID and cdshm_isin =DPHMC_ISIN ) -- transmission with lockin 
--		and cdshm_tras_dt between @pa_from_dt and @pa_to_dt
--		and cdshm_ben_acct_no like case when isnull(@pa_clientid,'') <> '' then @pa_clientid else '%' end
--		order by cdshm_ben_acct_no,cdshm_isin
--	end

end

GO
