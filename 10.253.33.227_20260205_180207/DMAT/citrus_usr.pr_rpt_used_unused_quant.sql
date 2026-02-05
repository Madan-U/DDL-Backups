-- Object: PROCEDURE citrus_usr.pr_rpt_used_unused_quant
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--[pr_rpt_used_unused] 'UNUSED_SLIP','904_ACT','10016076',4,1,'ho','',''
CREATE procedure  [citrus_usr].[pr_rpt_used_unused_quant]
(@pa_type varchar(50)
,@pa_trastm_id varchar(20)
,@pa_client_id varchar(16)
,@pa_excsmid int
,@pa_login_pr_entm_id numeric                        
,@pa_login_entm_cd_chain  varchar(8000)
,@pa_des_blk  VARCHAR(20)
,@pa_output varchar(8000) output )
as
begin
--
  IF @pa_type = 'USED_SLIP'
   BEGIN
   --
     if @pa_client_id <> ''
     begin
     --
     select distinct dpm_dpid [DPID]
 										,uses_dpam_acct_no [ACCTNO]
 										,ISNULL(USES_SERIES_TYPE,'')+ citrus_usr.fn_modify_slipno(uses_slip_no,'9') [SLIPNO]
 										,trastm_desc [TRANSACTIONDESC]
 									
 										,uses_series_type [SERIES_TYPE]
 				from   used_slip
 				      ,dp_mstr 
 				      ,transaction_sub_type_mstr 
 				      ,transaction_type_mstr , dp_trx_dtls
 				where  dpm_id = uses_dpm_id
 				and    trastm_tratm_id = trantm_id
 			 and    trantm_code in ('SLIP_TYPE_CDSL','SLIP_TYPE_nsdl')
			 and    isnumeric(replace(dptd_slip_no,USES_SERIES_TYPE,''))= 1
			 and    isnumeric(uses_slip_no)= 1
			 and    abs(uses_slip_no) = abs(replace(dptd_slip_no,USES_SERIES_TYPE,''))
 			 and    case when uses_trantm_id = '904' then '904_'+ DPTD_INTERNAL_TRASTM 
                         when uses_trantm_id = '905' then '905_'+ DPTD_INTERNAL_TRASTM  
						 when left(uses_trantm_id,3) = '912' then '906'
                         else uses_trantm_id end = trastm_cd
			 and trastm_cd = case when dptd_trastm_cd =  '912' then '906' else dptd_trastm_cd end 
 	         and     case when left(uses_trantm_id,3) = '912' then '906' else left(uses_trantm_id,3) end = left(@pa_trastm_id,3)
			 and    uses_dpam_acct_no  = @pa_client_id
			 and    trastm_cd = @pa_trastm_id
			 and    uses_used_destr like case when  @pa_des_blk = '' then '%' else @pa_des_blk end

     		 --Added on 23 Aug, 2010
				union

				select distinct dpm_dpid [DPID]
													,uses_dpam_acct_no [ACCTNO]
													,ISNULL(USES_SERIES_TYPE,'')+uses_slip_no [SLIPNO]
													,trastm_desc [TRANSACTIONDESC]
												
													,uses_series_type [SERIES_TYPE]
							from   used_slip
								  ,dp_mstr 
								  ,transaction_sub_type_mstr 
								  ,transaction_type_mstr 
							where  dpm_id = uses_dpm_id
							and    trastm_tratm_id = trantm_id
							and    trantm_code in ('SLIP_TYPE_CDSL','SLIP_TYPE_nsdl')
				and    uses_trantm_id = trastm_cd
				and    uses_trantm_id = @pa_trastm_id
				and    uses_dpam_acct_no  = @pa_client_id
				and    uses_used_destr like case when  @pa_des_blk = '' then '%' else @pa_des_blk end
    
			 --End
     --
     end
     else
     begin
     --
       select distinct dpm_dpid [DPID]
 												,uses_dpam_acct_no [ACCTNO]
 												,ISNULL(USES_SERIES_TYPE,'')+citrus_usr.fn_modify_slipno(uses_slip_no,'9') [SLIPNO]
 												,trastm_desc [TRANSACTIONDESC]
 									
 												,uses_series_type [SERIES_TYPE]
 						from   used_slip
 						      ,dp_mstr 
 						      ,transaction_sub_type_mstr 
 				        ,transaction_type_mstr , dp_trx_dtls
 						where  dpm_id = uses_dpm_id
 						and    trastm_tratm_id = trantm_id
 			            and    trantm_code in ('SLIP_TYPE_CDSL','SLIP_TYPE_nsdl')
                        and    isnumeric(replace(dptd_slip_no,USES_SERIES_TYPE,''))= 1
 						and    isnumeric(uses_slip_no)= 1
 						and    abs(uses_slip_no) = abs(replace(dptd_slip_no,USES_SERIES_TYPE,''))
 						and    case when uses_trantm_id = '904' then '904_'+ DPTD_INTERNAL_TRASTM 
 									when uses_trantm_id = '905' then '905_'+ DPTD_INTERNAL_TRASTM  
						when left(uses_trantm_id,3) = '912' then '906'
                                    else uses_trantm_id end = trastm_cd
						and trastm_cd = case when dptd_trastm_cd =  '912' then '906' else dptd_trastm_cd end 
 						and     case when left(uses_trantm_id,3) = '912' then '906' else left(uses_trantm_id,3) end = left(@pa_trastm_id,3)
                        and    trastm_cd = @pa_trastm_id
 						and    uses_used_destr like case when  @pa_des_blk = '' then '%' else @pa_des_blk end

						--Added on 23 Aug, 2010
						union

							select distinct dpm_dpid [DPID]
													,uses_dpam_acct_no [ACCTNO]
													,ISNULL(USES_SERIES_TYPE,'')+uses_slip_no [SLIPNO]
													,trastm_desc [TRANSACTIONDESC]
										
													,uses_series_type [SERIES_TYPE]
							from   used_slip
								  ,dp_mstr 
								  ,transaction_sub_type_mstr 
								,transaction_type_mstr 
							where  dpm_id = uses_dpm_id
							and    trastm_tratm_id = trantm_id
							and    trantm_code in ('SLIP_TYPE_CDSL','SLIP_TYPE_nsdl')
							and    uses_trantm_id = trastm_cd
							and    uses_trantm_id = @pa_trastm_id
							and    uses_used_destr like case when  @pa_des_blk = '' then '%' else @pa_des_blk end
						--End
 				
     --
     end
   --
  END
  
  ELSE IF @pa_type = 'UNUSED_SLIP'
  BEGIN
  --
  
    declare  @temp_dp table(dpm_dpid varchar(20),sliim_dpam_acct_no varchar(16),slip_no varchar(10),trastm_desc varchar(100),sliim_series_type varchar(20)) 
        
    declare @l_dpm_dpid varchar(20)
    ,@l_sliim_dpam_acct_no varchar(16)
    ,@l_slip_no numeric
    ,@l_slip_from numeric
    ,@l_slip_to numeric
    ,@l_trastm_desc varchar(100)
    ,@l_sliim_series_type varchar(20)
    
	declare @c_cursor cursor  
				
  
  
    if @pa_client_id <> ''
	begin

	--

				CREATE TABLE #TEMPSLIP(uses_dpam_acct_no VARCHAR(20),uses_trantm_id VARCHAR(10),uses_slip_no VARCHAR(20),uses_series_type VARCHAR(10))
				INSERT INTO #TEMPSLIP SELECT uses_dpam_acct_no,uses_trantm_id,uses_slip_no,uses_series_type FROM used_slip WHERE uses_dpam_acct_no = @pa_client_id
				SET @c_cursor =  CURSOR fast_forward FOR            
				select distinct dpm_dpid
				,sliim_dpam_acct_no
				,sliim_slip_no_fr
				,sliim_slip_no_to 
				,trastm_desc
				,sliim_series_type
				from  slip_issue_mstr 
				,dp_mstr 
				,transaction_sub_type_mstr 
				,transaction_type_mstr 
				where dpm_id = sliim_dpm_id
				and   trastm_tratm_id = trantm_id
				and    trantm_code in ('SLIP_TYPE_CDSL','SLIP_TYPE_nsdl')
				and   sliim_tratm_id = trastm_id
				and   trastm_cd = @pa_trastm_id
				and   sliim_dpam_acct_no  = @pa_client_id
                and   sliim_deleted_ind = 1

				--Added on 23 Aug 2010
				union
				select distinct dpm_dpid
				,case when @pa_client_id like '%nse%' then  'NSE POA' when @pa_client_id like '%bse%' then 'BSE POA' else 'BOTH' end 
				,sliim_slip_no_fr
				,sliim_slip_no_to 
				,trastm_desc
				,sliim_series_type
				from  slip_issue_mstr_poa 
				,dp_mstr 
				,transaction_sub_type_mstr 
				,transaction_type_mstr 
				where dpm_id = sliim_dpm_id
				and   trastm_tratm_id = trantm_id
				and    trantm_code in ('SLIP_TYPE_CDSL','SLIP_TYPE_nsdl')
				and   sliim_tratm_id = trastm_id
				and   trastm_cd = @pa_trastm_id
				and   sliim_dpam_acct_no  =case when @pa_client_id like '%nse%' then  'NSE POA' when @pa_client_id like '%bse%' then 'BSE POA' else 'BOTH' end 
                and   sliim_deleted_ind = 1
				--End

				OPEN @c_cursor            
				FETCH NEXT FROM @c_cursor   
				INTO @l_dpm_dpid 
				,@l_sliim_dpam_acct_no 
				,@l_slip_from 
				,@l_slip_to 
				,@l_trastm_desc 
				,@l_sliim_series_type 
			    
			    
			    
			    
				WHILE @@fetch_status = 0            
				BEGIN            
							--   
								set @l_slip_no = @l_slip_from 
								WHILE  @l_slip_no <= @l_slip_to 
								BEGIN  

									 --  

									   if not exists (select uses_slip_no from #TEMPSLIP where uses_dpam_acct_no = @l_sliim_dpam_acct_no and case when left(uses_trantm_id,3) = '912' then '906' else left(uses_trantm_id,3) end = left(@pa_trastm_id,3) and isnumeric(replace(uses_slip_no,ltrim(rtrim(@l_sliim_series_type)),''))=1 and convert(numeric,replace(uses_slip_no,ltrim(rtrim(@l_sliim_series_type)),'')) = @l_slip_no)
									   begin
									   --
											insert into @temp_dp
											(dpm_dpid 
											,sliim_dpam_acct_no 
											,slip_no 
											,trastm_desc 
											,sliim_series_type )
											select @l_dpm_dpid 
											,@l_sliim_dpam_acct_no 
											,@l_slip_no
											,@l_trastm_desc 
											,@l_sliim_series_type 
									   --
									   end
									   set @l_slip_no = @l_slip_no + 1
							   --
							   END
			       
					FETCH NEXT FROM @c_cursor   
					INTO @l_dpm_dpid 
					,@l_sliim_dpam_acct_no 
					,@l_slip_from 
					,@l_slip_to 
					,@l_trastm_desc 
					,@l_sliim_series_type 

			   --
			   END

    TRUNCATE TABLE #TEMPSLIP
	DROP TABLE #TEMPSLIP

    --
    end
    else
    begin
    -- 
				
SET @c_cursor =  CURSOR fast_forward FOR 
				select distinct dpm_dpid
				,sliim_dpam_acct_no
				,sliim_slip_no_fr
				,sliim_slip_no_to 
				,trastm_desc
				,sliim_series_type
				from  slip_issue_mstr 
				,dp_mstr 
				,transaction_sub_type_mstr 
				,transaction_type_mstr 
				where dpm_id = sliim_dpm_id
				and    trantm_code in ('SLIP_TYPE_CDSL','SLIP_TYPE_nsdl')
				and   trastm_tratm_id = trantm_id
				and   sliim_tratm_id = trastm_id
				and   trastm_cd = @pa_trastm_id
                and   sliim_deleted_ind = 1

				--Added on 23 Aug 2010
				union
                select distinct dpm_dpid
				,sliim_dpam_acct_no
				,sliim_slip_no_fr
				,sliim_slip_no_to 
				,trastm_desc
				,sliim_series_type
				from  slip_issue_mstr_poa
				,dp_mstr 
				,transaction_sub_type_mstr 
				,transaction_type_mstr 
				where dpm_id = sliim_dpm_id
				and    trantm_code in ('SLIP_TYPE_CDSL','SLIP_TYPE_nsdl')
				and   trastm_tratm_id = trantm_id
				and   sliim_tratm_id = trastm_id
				and   trastm_cd = @pa_trastm_id
                and   sliim_deleted_ind = 1
				--End

				OPEN @c_cursor            
				FETCH NEXT FROM @c_cursor   
				INTO @l_dpm_dpid 
				,@l_sliim_dpam_acct_no 
				,@l_slip_from 
				,@l_slip_to 
				,@l_trastm_desc 
				,@l_sliim_series_type 
			    
			    
			    
			    
				WHILE @@fetch_status = 0            
				BEGIN            
							--   
								set @l_slip_no = @l_slip_from 
								WHILE  @l_slip_no <= @l_slip_to 
								BEGIN  
									 --  

									   if not exists (select uses_id from used_slip where uses_dpam_acct_no = @l_sliim_dpam_acct_no and case when left(uses_trantm_id,3) = '912' then '906' else left(uses_trantm_id,3) end = LEFT(@pa_trastm_id,3)  and isnumeric(replace(uses_slip_no,ltrim(rtrim(@l_sliim_series_type)),''))=1 and convert(numeric,replace(uses_slip_no,ltrim(rtrim(@l_sliim_series_type)),'')) = @l_slip_no )
									   begin
									   --
											insert into @temp_dp
											(dpm_dpid 
											,sliim_dpam_acct_no 
											,slip_no 
											,trastm_desc 
											,sliim_series_type )
											select @l_dpm_dpid 
											,@l_sliim_dpam_acct_no 
											,@l_slip_no
											,@l_trastm_desc 
											,@l_sliim_series_type 
									   --
									   end
									   set @l_slip_no = @l_slip_no + 1
							   --
							   END
			       
					FETCH NEXT FROM @c_cursor   
					INTO @l_dpm_dpid 
					,@l_sliim_dpam_acct_no 
					,@l_slip_from 
					,@l_slip_to 
					,@l_trastm_desc 
					,@l_sliim_series_type 

			   --
			   END





    --
    end
    
    
    
   

	CLOSE @c_cursor
	DEALLOCATE @c_cursor
	
 
   
   select dpm_dpid [DPID]
						   ,sliim_dpam_acct_no [ACCTNO]
						   ,ISNULL(LTRIM(RTRIM(sliim_series_type)),'') + LTRIM(RTRIM(citrus_usr.fn_modify_slipno(slip_no,'9')))  [SLIPNO]
						   ,trastm_desc  [TRANSACTIONDESC]
						 
						   ,sliim_series_type [SERIES_TYPE]
			from @temp_dp


  --
  END
  IF @pa_type = 'SLIP_ISSUE_TO_CLIENT'
  begin

				if @pa_client_id <> ''
								begin
								--

							            
								select distinct dpm_dpid [DPID]
														,sliim_dpam_acct_no [ACCTNO]
														,ISNULL(sliim_series_type,'') +convert(varchar,sliim_slip_no_fr) + '-' + ISNULL(sliim_series_type,'') +convert(varchar,sliim_slip_no_to) [SLIPNO] 
														,trastm_desc [TRANSACTIONDESC]
														,sliim_series_type  [SERIES_TYPE]
								from  slip_issue_mstr 
													,dp_mstr 
													,transaction_sub_type_mstr 
													,transaction_type_mstr 
								where dpm_id = sliim_dpm_id
								and   trastm_tratm_id = trantm_id
								and    trantm_code in ('SLIP_TYPE_CDSL','SLIP_TYPE_nsdl')
								and   sliim_tratm_id = trastm_id
								and   trastm_cd = @pa_trastm_id
								and   sliim_dpam_acct_no  = @pa_client_id
                                and   sliim_deleted_ind = 1
								--
								end
								else
								begin
								-- 
							
										select distinct dpm_dpid [DPID]
																,sliim_dpam_acct_no  [ACCTNO]
															,ISNULL(sliim_series_type,'') +convert(varchar,sliim_slip_no_fr) + '-' + ISNULL(sliim_series_type,'') +convert(varchar,sliim_slip_no_to) [SLIPNO]
																,trastm_desc [TRANSACTIONDESC]
																,sliim_series_type [SERIES_TYPE]
										from  slip_issue_mstr 
															,dp_mstr 
															,transaction_sub_type_mstr 
															,transaction_type_mstr 
										where dpm_id = sliim_dpm_id
										and    trantm_code in ('SLIP_TYPE_CDSL','SLIP_TYPE_nsdl')
										and   trastm_tratm_id = trantm_id
										and   sliim_tratm_id = trastm_id
										and   trastm_cd = @pa_trastm_id
                                        and   sliim_deleted_ind = 1
								--
						end
				--
				END
  
--
end

GO
