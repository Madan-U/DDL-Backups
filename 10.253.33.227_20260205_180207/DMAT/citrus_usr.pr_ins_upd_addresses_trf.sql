-- Object: PROCEDURE citrus_usr.pr_ins_upd_addresses_trf
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--[pr_ins_upd_addresses_trf]  '','EDT','ho',16,'',2,'*|~*','|*~|',''
CREATE procedure [citrus_usr].[pr_ins_upd_addresses_trf] 
(@pa_id            varchar(8000)
,@pa_action        varchar(20)
,@pa_login_name    varchar(20)
,@pa_crn_no        numeric
,@pa_values        varchar(8000)
,@pa_chk_yn        numeric
,@rowdelimiter     char(4) = '*|~*'
,@coldelimiter     char(4) = '|*~|'
,@pa_msg           varchar(8000) output
)
as
begin
--
--   DECLARE @l_errorstr            varchar(8000)
--        , @remainingstring_id    varchar(8000)
--        , @currstring_id         varchar(8000)
--        , @remainingstring_val   varchar(8000)
--        , @currstring_val        varchar(8000)
--        , @delimeter             char(4)  
--        , @foundat_id            integer
--        , @foundat_val           integer
--        , @delimeterlength       int
--        , @l_excsm_id            varchar(10)
--        , @l_dpm_dpid            varchar(25) 
--        , @l_demat_id            varchar(25)
--        , @l_acct_no             varchar(25) 
--        , @l_dpam_id             numeric
--        , @l_COR_ADR1            varchar(8000)
--								, @l_PER_ADR1            varchar(8000)
--								, @l_OFF_ADR1            varchar(8000)
--								, @l_FH_ADR1            varchar(8000)
--								, @l_NRI_ADR            varchar(8000)
--								, @l_addresses_value    varchar(8000)
--,@l_TH_ADR1 VARCHAR(8000)
--,@l_SH_ADR1 VARCHAR(8000)
--,@l_POA_ADR1 VARCHAR(8000)
--,@l_NOMINEE_ADR1 VARCHAR(8000)
--,@l_TH_POA_ADR VARCHAR(8000)
--,@l_SH_POA_ADR VARCHAR(8000)
--,@l_GUARD_ADR VARCHAR(8000)
--,@l_NOM_GUARDIAN_ADDR VARCHAR(8000)
--
--								, @l_dpm_id bigint
--							
--							declare @c_cursor cursor
--							
--			if @pa_chk_yn = 0 
--			begin
--			--
--			  set @c_cursor = cursor for SELECT dpam_id , dpam_sba_no FROM dp_acct_mstr WHERE DPAM_CRN_NO = @pa_crn_no
--		 --
--		 end
--		 if @pa_chk_yn = 1 OR @pa_chk_yn = 2
--						begin
--						--
--						  set @c_cursor = cursor for SELECT dpam_id , dpam_sba_no FROM dp_acct_mstr_mak WHERE DPAM_CRN_NO = @pa_crn_no
--					 --
--		 end
--		 
--		 
--		 OPEN @c_cursor
--		 
--		 FETCH NEXT FROM @c_cursor into @l_dpam_id,@l_demat_id
--			WHILE @@FETCH_STATUS = 0
--			BEGIN
--			
--			
--		 
--
-- 
--    
--         
--				
--               
--  --
--		if @pa_chk_yn = 1 OR @pa_chk_yn = 2  
--		begin
--		--
--		   SET @pa_chk_yn = 1
--		
--				select @l_COR_ADR1 = case when citrus_usr.[fn_acct_addr_value](@l_dpam_id,'AC_COR_ADR1') = '' then citrus_usr.fn_addr_value_chkyn(@pa_crn_no,'COR_ADR1',@pa_chk_yn) else '' END
--				select @l_PER_ADR1 = case when citrus_usr.[fn_acct_addr_value](@l_dpam_id,'AC_PER_ADR1') = '' then citrus_usr.fn_addr_value_chkyn(@pa_crn_no,'PER_ADR1',@pa_chk_yn) else '' end
--				select @l_OFF_ADR1 = case when citrus_usr.[fn_acct_addr_value](@l_dpam_id,'AC_OFF_ADR1') = '' then citrus_usr.fn_addr_value_chkyn(@pa_crn_no,'OFF_ADR1',@pa_chk_yn) else '' end
--				select @l_FH_ADR1  = case when citrus_usr.[fn_acct_addr_value](@l_dpam_id,'AC_FH_ADR1') = '' then citrus_usr.fn_addr_value_chkyn(@pa_crn_no,'FH_ADR1',@pa_chk_yn)  else '' end
--				select @l_NRI_ADR  = case when citrus_usr.[fn_acct_addr_value](@l_dpam_id,'AC_NRI_ADR') = '' then citrus_usr.fn_addr_value_chkyn(@pa_crn_no,'NRI_ADR',@pa_chk_yn)  else '' end
--				select @l_TH_ADR1  = case when citrus_usr.[fn_acct_addr_value](@l_dpam_id,'TH_ADR1') <> '' then citrus_usr.[fn_acct_addr_value](@l_dpam_id,'TH_ADR1')  else '' end
--				select @l_SH_ADR1  = case when citrus_usr.[fn_acct_addr_value](@l_dpam_id,'SH_ADR1') <> '' then citrus_usr.[fn_acct_addr_value](@l_dpam_id,'SH_ADR1')  else '' end
--				select @l_POA_ADR1  = case when citrus_usr.[fn_acct_addr_value](@l_dpam_id,'POA_ADR1') <> '' then citrus_usr.[fn_acct_addr_value](@l_dpam_id,'POA_ADR1')  else '' end
--				select @l_NOMINEE_ADR1  = case when citrus_usr.[fn_acct_addr_value](@l_dpam_id,'NOMINEE_ADR1') <> '' then citrus_usr.[fn_acct_addr_value](@l_dpam_id,'NOMINEE_ADR1')  else '' end
--				select @l_TH_POA_ADR  = case when citrus_usr.[fn_acct_addr_value](@l_dpam_id,'TH_POA_ADR') <> '' then citrus_usr.[fn_acct_addr_value](@l_dpam_id,'TH_POA_ADR')  else '' end
--				select @l_SH_POA_ADR  = case when citrus_usr.[fn_acct_addr_value](@l_dpam_id,'SH_POA_ADR') <> '' then citrus_usr.[fn_acct_addr_value](@l_dpam_id,'SH_POA_ADR')  else '' end
--				select @l_GUARD_ADR  = case when citrus_usr.[fn_acct_addr_value](@l_dpam_id,'GUARD_ADR') <> '' then citrus_usr.[fn_acct_addr_value](@l_dpam_id,'GUARD_ADR')  else '' end
--				select @l_NOM_GUARDIAN_ADDR  = case when citrus_usr.[fn_acct_addr_value](@l_dpam_id,'NOM_GUARDIAN_ADDR') <> '' then citrus_usr.[fn_acct_addr_value](@l_dpam_id,'NOM_GUARDIAN_ADDR')  else '' end
--				
--               
--                set @l_addresses_value = case when @l_COR_ADR1 <> '' then 'AC_COR_ADR1|*~|' + ISNULL(@l_COR_ADR1,'') + '*|~*' ELSE '' END
--         		set @l_addresses_value = isnull(@l_addresses_value,'') + case when ltrim(rtrim(@l_PER_ADR1)) <> '' then 'AC_PER_ADR1|*~|' +ISNULL(@l_PER_ADR1,'') + '*|~*' ELSE ''END
--         		
--         		set @l_addresses_value = isnull(@l_addresses_value,'') + case when ltrim(rtrim(@l_OFF_ADR1)) <> '' then 'AC_OFF_ADR1|*~|' + ISNULL(@l_OFF_ADR1,'') + '*|~*' ELSE ''END
--				set @l_addresses_value = isnull(@l_addresses_value,'') + case when ltrim(rtrim(@l_FH_ADR1)) <> '' then 'AC_FH_ADR1|*~|' +ISNULL(@l_FH_ADR1,'') + '*|~*' ELSE ''END
--				set @l_addresses_value = isnull(@l_addresses_value,'') + case when ltrim(rtrim(@l_NRI_ADR)) <> '' then 'AC_NRI_ADR|*~|' +ISNULL(@l_NRI_ADR,'') + '*|~*' ELSE ''END
--				set @l_addresses_value = isnull(@l_addresses_value,'') + case when ltrim(rtrim(@l_TH_ADR1)) <> '' then 'TH_ADR1|*~|' +ISNULL(@l_TH_ADR1,'') + '*|~*' ELSE ''end
--				set @l_addresses_value = isnull(@l_addresses_value,'') + case when ltrim(rtrim(@l_SH_ADR1))<> '' then 'SH_ADR1|*~|' + ISNULL(@l_SH_ADR1,'') + '*|~*' ELSE ''end
--				set @l_addresses_value = isnull(@l_addresses_value,'') + case when ltrim(rtrim(@l_POA_ADR1)) <> '' then 'POA_ADR1|*~|' +ISNULL(@l_POA_ADR1,'')+ '*|~*' ELSE ''END
--				set @l_addresses_value = isnull(@l_addresses_value,'') + case when ltrim(rtrim(@l_NOMINEE_ADR1)) <> '' then 'NOMINEE_ADR1|*~|' +ISNULL(@l_NOMINEE_ADR1,'') + '*|~*' ELSE ''end
--             	set @l_addresses_value = isnull(@l_addresses_value,'') + case when ltrim(rtrim(@l_TH_POA_ADR)) <> '' then 'TH_POA_ADR|*~|' +ISNULL(@l_TH_POA_ADR,'') + '*|~*' ELSE ''end
--				set @l_addresses_value = isnull(@l_addresses_value,'') + case when ltrim(rtrim(@l_SH_POA_ADR)) <> '' then 'SH_POA_ADR|*~|' + ISNULL(@l_SH_POA_ADR,'') + '*|~*' ELSE ''end
--				set @l_addresses_value = isnull(@l_addresses_value,'') + case when ltrim(rtrim(@l_NOM_GUARDIAN_ADDR)) <> '' then 'NOM_GUARDIAN_ADDR|*~|' +ISNULL(@l_NOM_GUARDIAN_ADDR,'') + '*|~*' ELSE '' end
--
--
--                exec [pr_dp_ins_upd_addr] '0','EDT',@pa_login_name,@l_dpam_id,@l_demat_id,'DP',@l_addresses_value,1,'*|~*','|*~|',''
--			  --
--			  end
--			  if @pa_chk_yn = 0
--			  begin
--			  --
--				select @l_COR_ADR1 = case when citrus_usr.[fn_acct_addr_value](@l_dpam_id,'AC_COR_ADR1') = '' then citrus_usr.fn_addr_value_chkyn(@pa_crn_no,'COR_ADR1',@pa_chk_yn) else '' end
--				select @l_PER_ADR1 = case when citrus_usr.[fn_acct_addr_value](@l_dpam_id,'AC_PER_ADR1') = '' then citrus_usr.fn_addr_value_chkyn(@pa_crn_no,'PER_ADR1',@pa_chk_yn) else '' end
--				select @l_OFF_ADR1 = case when citrus_usr.[fn_acct_addr_value](@l_dpam_id,'AC_OFF_ADR1') = '' then citrus_usr.fn_addr_value_chkyn(@pa_crn_no,'OFF_ADR1',@pa_chk_yn) else '' end
--				select @l_FH_ADR1  = case when citrus_usr.[fn_acct_addr_value](@l_dpam_id,'AC_FH_ADR1') = '' then citrus_usr.fn_addr_value_chkyn(@pa_crn_no,'FH_ADR1',@pa_chk_yn)  else '' end
--				select @l_NRI_ADR  = case when citrus_usr.[fn_acct_addr_value](@l_dpam_id,'AC_NRI_ADR') = '' then citrus_usr.fn_addr_value_chkyn(@pa_crn_no,'NRI_ADR',@pa_chk_yn)  else '' end
--                select @l_TH_ADR1  = case when citrus_usr.[fn_acct_addr_value](@l_dpam_id,'TH_ADR1') <> '' then citrus_usr.[fn_acct_addr_value](@l_dpam_id,'TH_ADR1')  else '' end
--				select @l_SH_ADR1  = case when citrus_usr.[fn_acct_addr_value](@l_dpam_id,'SH_ADR1') <> '' then citrus_usr.[fn_acct_addr_value](@l_dpam_id,'SH_ADR1')  else '' end
--				select @l_POA_ADR1  = case when citrus_usr.[fn_acct_addr_value](@l_dpam_id,'POA_ADR1') <> '' then citrus_usr.[fn_acct_addr_value](@l_dpam_id,'POA_ADR1')  else '' end
--				select @l_NOMINEE_ADR1  = case when citrus_usr.[fn_acct_addr_value](@l_dpam_id,'NOMINEE_ADR1') <> '' then citrus_usr.[fn_acct_addr_value](@l_dpam_id,'NOMINEE_ADR1')  else '' end
--				select @l_TH_POA_ADR  = case when citrus_usr.[fn_acct_addr_value](@l_dpam_id,'TH_POA_ADR') <> '' then citrus_usr.[fn_acct_addr_value](@l_dpam_id,'TH_POA_ADR')  else '' end
--				select @l_SH_POA_ADR  = case when citrus_usr.[fn_acct_addr_value](@l_dpam_id,'SH_POA_ADR') <> '' then citrus_usr.[fn_acct_addr_value](@l_dpam_id,'SH_POA_ADR')  else '' end
--				select @l_GUARD_ADR  = case when citrus_usr.[fn_acct_addr_value](@l_dpam_id,'GUARD_ADR') <> '' then citrus_usr.[fn_acct_addr_value](@l_dpam_id,'GUARD_ADR')  else '' end
--				select @l_NOM_GUARDIAN_ADDR  = case when citrus_usr.[fn_acct_addr_value](@l_dpam_id,'NOM_GUARDIAN_ADDR') <> '' then citrus_usr.[fn_acct_addr_value](@l_dpam_id,'NOM_GUARDIAN_ADDR')  else '' end
--				 
--               
--                set @l_addresses_value = case when @l_COR_ADR1 <> '' then 'AC_COR_ADR1|*~|' + ISNULL(@l_COR_ADR1,'') + '*|~*' ELSE '' end
--				set @l_addresses_value = ISNULL(@l_addresses_value,'') + case when @l_PER_ADR1 <> '' then 'AC_PER_ADR1|*~|' +ISNULL(@l_PER_ADR1,'') + '*|~*' ELSE '' end
--				set @l_addresses_value = ISNULL(@l_addresses_value,'')+ case when @l_OFF_ADR1 <> '' then 'AC_OFF_ADR1|*~|' + ISNULL(@l_OFF_ADR1,'') + '*|~*' ELSE '' end
--				set @l_addresses_value = ISNULL(@l_addresses_value,'') + case when @l_FH_ADR1 <> '' then 'AC_FH_ADR1|*~|' +ISNULL(@l_FH_ADR1,'') + '*|~*' ELSE '' end
--				set @l_addresses_value = ISNULL(@l_addresses_value,'') + case when @l_NRI_ADR <> '' then 'AC_NRI_ADR|*~|' +ISNULL(@l_NRI_ADR,'') + '*|~*' ELSE '' end
--               	set @l_addresses_value = ISNULL(@l_addresses_value,'') + case when @l_TH_ADR1 <> '' then 'TH_ADR1|*~|' +ISNULL(@l_TH_ADR1,'') + '*|~*' ELSE '' end
--				set @l_addresses_value = ISNULL(@l_addresses_value,'') + case when @l_SH_ADR1<> '' then 'SH_ADR1|*~|' + ISNULL(@l_SH_ADR1,'') + '*|~*' ELSE '' end
--				set @l_addresses_value = ISNULL(@l_addresses_value,'') + case when @l_POA_ADR1 <> '' then 'POA_ADR1|*~|' +ISNULL(@l_POA_ADR1,'')+ '*|~*' ELSE '' end
--				set @l_addresses_value = ISNULL(@l_addresses_value,'') + case when @l_NOMINEE_ADR1 <> '' then 'NOMINEE_ADR1|*~|' +ISNULL(@l_NOMINEE_ADR1,'') + '*|~*' ELSE '' end
--             	set @l_addresses_value = ISNULL(@l_addresses_value,'') + case when @l_TH_POA_ADR <> '' then 'TH_POA_ADR|*~|' +ISNULL(@l_TH_POA_ADR,'') + '*|~*' ELSE '' end
--				set @l_addresses_value = ISNULL(@l_addresses_value,'') + case when @l_SH_POA_ADR <> '' then 'SH_POA_ADR|*~|' + ISNULL(@l_SH_POA_ADR,'') + '*|~*' ELSE '' end
--                set @l_addresses_value = ISNULL(@l_addresses_value,'') + case when @l_GUARD_ADR <> '' then 'GUARD_ADR|*~|' + ISNULL(@l_GUARD_ADR,'') + '*|~*' ELSE '' end
--				set @l_addresses_value = ISNULL(@l_addresses_value,'') + case when @l_NOM_GUARDIAN_ADDR <> '' then 'NOM_GUARDIAN_ADDR|*~|' +ISNULL(@l_NOM_GUARDIAN_ADDR,'') + '*|~*' ELSE '' end
--
--
--
--                exec [pr_dp_ins_upd_addr] '0','EDT',@pa_login_name,@l_dpam_id,@l_demat_id,'DP',@l_addresses_value,@pa_chk_yn,'*|~*','|*~|',''
--			  --
--			  end
--   
--   
--   FETCH NEXT FROM @c_cursor into @l_dpam_id,@l_demat_id
--			END
--			
--			CLOSE @c_cursor
--   DEALLOCATE @c_cursor
		 
         print '1'
--
end

GO
