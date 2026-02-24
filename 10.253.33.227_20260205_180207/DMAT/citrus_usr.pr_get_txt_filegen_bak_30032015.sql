-- Object: PROCEDURE citrus_usr.pr_get_txt_filegen_bak_30032015
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

create proc [citrus_usr].[pr_get_txt_filegen_bak_30032015](@pa_action varchar(100),@pa_dpid varchar(100)
,@pa_boid varchar(100)
,@pa_isin varchar(100))
as
begin

		if @pa_action = 'HOLDING'
		begin 
		print @pa_action 
		   select dpam_sba_no +'|'+dphmcd_isin+'|'+isin_name +'|'+convert(varchar,DPHMCD_CURR_QTY )
		   +'|'+convert(varchar,DPHMCD_free_QTY )
		   +'|'+CONVERT(varchar,0)
		   +'|'+CONVERT(varchar,0)
		   +'|'+CONVERT(varchar,0)
		   +'|'+CONVERT(varchar,0)
		   +'|'+CONVERT(varchar,0)
		   +'|'+CONVERT(varchar,0)
		   +'|'+CONVERT(varchar,0)
		   +'|'+CONVERT(varchar,0)
		   +'|'+CONVERT(varchar,0) from holdingallforview with (nolock), dp_acct_mstr with (nolock), ISIN_MSTR with (nolock)
		   where DPHMCD_DPAM_ID = DPAM_ID 
		   and  ISIN_CD = DPHMCD_ISIN 
		   and DPAM_DELETED_IND = 1 
		   and DPAM_SBA_NO = @pa_boid and DPHMCD_ISIN = @pa_isin 
		end 
		if @pa_action = 'TRX'
		begin 
		print @pa_action 
		
			select cdshm_ben_acct_no +'|'
			+CONVERT(varchar(11),cdshm_tras_dt,112) +'|'
			+cdshm_trans_no +'|'
			+cdshm_isin +'|'+isin_name +'|'+CDSHM_TRATM_DESC +'|'++'|'+convert(varchar,cdshm_qty)+'|'+case when CDSHM_QTY > 0 then 'C' else 'D' end 
			+'|'+''--MKTRXD
			+'|'+''--1000
			+'|'+''--1300
			+'|'++'|'+''--11
			from cdsl_holding_dtls with(nolock),ISIN_MSTR with(nolock) where cdshm_ben_acct_no = @pa_boid and cdshm_isin= @pa_isin
			and ISIN_CD = cdshm_isin
			and CDSHM_TRATM_DESC is not null
		
		end 
		if @pa_action = 'CLIENT'
		begin 
				print @pa_action 
				select dpam_bbo_code
				+'|'+dpam_sba_no
				+'|'+enttm_desc
				+'|'+stam_Cd
				+'|'+clicm_desc
				+'|'+subcm_desc
				+'|'+'' -- 2015021457401
				+'|'+--20150201-20150228
				+'|'+--20150228
				+'|'+''--20150330
				+'|'+dpam_sba_name
				+'|'+addr1 
				+'|'+addr2
				+'|'+''
				+'|'+city
				+'|'+state
				+'|'+pincode
				+'|'+''--9431009950
				+'|'+''--PATNA BR-RIP LTD~PTN
				+'|'+''
				+'|'+''--LIFE INVESTOR
				+'|'+''--11
				+'|'+''--1.3596
				+'|'+''--0
				+'|'+''--12.3596
				+'|'+''--20150228
				+'|'+''--20150228
				+'|'+''--20150201-20150228
				+'|'+''--20150201-20150228
				from dp_acct_mstr with(nolock) , client_ctgry_mstr with(nolock), ENTITY_TYPE_MSTR with(nolock), SUB_CTGRY_MSTR with(nolock), dps8_pc1 with(nolock), STATUS_MSTR with(nolock)
				where BOId = DPAM_SBA_NO and stam_cd = DPAM_STAM_CD 
				and CLICM_CD  = DPAM_CLICM_CD 
				and ENTTM_CD = DPAM_ENTTM_CD 
				and dpam_subcm_cd = SUBCM_CD 
				and DPAM_DELETED_IND = 1 
				and DPAM_SBA_NO = @pa_boid
		
		end  
		if @pa_action = 'LEDGER'
		begin 
		print @pa_action 
		
			select dpam_sba_no+'|'
			+CONVERT(varchar(11),ldg_voucher_dt,112) +'|'
			+ldg_narration+'|'
			+CONVERT(varchar,ldg_amount) +'|'
			+case when ldg_amount < 0 then 'D' else 'C' end +'|'
			+''--12.36
			+'|'--+61.8
			from LEDGER1 with(nolock)
			,dp_acct_mstr with(nolock)
			where LDG_ACCOUNT_ID = DPAM_ID and LDG_ACCOUNT_TYPE ='P'
			and LDG_DELETED_IND = 1 and DPAM_DELETED_IND = 1 and DPAM_SBA_NO = @pa_boid 
		
		end
		if @pa_action = 'SUMMARY'
		begin 
		print @pa_action 
		
			select dpam_sba_no+'|'
			+CLIC_CHARGE_NAME +'|'
			+convert(varchar,clic_charge_amt)+'|'
			from client_charges_cdsl  with(nolock)
			,dp_acct_mstr with(nolock)
			where CLIC_DPAM_ID = DPAM_ID and CLIC_DELETED_IND = 1 
			and DPAM_DELETED_IND = 1 and DPAM_SBA_NO = @pa_boid 
		
		end  

end

GO
