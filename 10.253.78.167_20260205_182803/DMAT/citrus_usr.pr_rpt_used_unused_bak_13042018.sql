-- Object: PROCEDURE citrus_usr.pr_rpt_used_unused_bak_13042018
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--[pr_rpt_used_unused] 'UNUSED_SLIP','904_ACT','10000037',4,1,'ho','',''
create  PROC [citrus_usr].[pr_rpt_used_unused_bak_13042018]
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
declare @l_dpm_id numeric
select @l_dpm_id  = dpm_id from dp_mstr where dpm_excsm_id = default_dp and dpm_excsm_id = @pa_excsmid
and dpm_deleted_ind = 1 

declare @l_dpm_dpid varchar(20)
    ,@l_sliim_dpam_acct_no varchar(16)
    ,@l_slip_no numeric
    ,@l_slip_from numeric
    ,@l_slip_to numeric
    ,@l_trastm_desc varchar(100)
    ,@l_sliim_series_type varchar(20)
,@l_USES_CREATED_DT datetime


	declare @c_cursor cursor  

IF @pa_type = 'Canceled_SLIP'
  BEGIN
  --

declare  @temp_dp_cancel table(dpm_dpid varchar(20),sliim_dpam_acct_no varchar(16),slip_no varchar(10),trastm_desc varchar(100),sliim_series_type varchar(20),USES_CREATED_DT datetime) 

SET @c_cursor =  CURSOR fast_forward FOR 
				select distinct dpm_dpid
				,USES_DPAM_ACCT_NO
				,USES_SLIP_NO
				,USES_SLIP_NO_to 
				,trastm_desc
				,USES_SERIES_TYPE,USES_CREATED_DT
					from   used_slip_block
				      ,dp_mstr 
				      ,transaction_sub_type_mstr 
				      ,transaction_type_mstr 
				where  dpm_id = uses_dpm_id
				and    trastm_tratm_id = trantm_id
			 and    trantm_code in ('SLIP_TYPE_CDSL','SLIP_TYPE_nsdl')
    and    isnumeric(uses_slip_no)= 1
   	and   uses_trantm_id  = trastm_id
			 --and    left(uses_trantm_id,3) = left(@pa_trastm_id,3)
    and    trastm_cd = @pa_trastm_id
AND uses_dpam_acct_no = @pa_client_id

				OPEN @c_cursor            
				FETCH NEXT FROM @c_cursor   
				INTO @l_dpm_dpid 
				,@l_sliim_dpam_acct_no 
				,@l_slip_from 
				,@l_slip_to 
				,@l_trastm_desc 
				,@l_sliim_series_type ,@l_USES_CREATED_DT
			    
			    
			    
			    
				WHILE @@fetch_status = 0            
				BEGIN            
							--   
								set @l_slip_no = @l_slip_from 
								WHILE  @l_slip_no <= @l_slip_to 
								BEGIN  
									 --  
									   if not exists (select uses_id from used_slip where uses_dpam_acct_no = @l_sliim_dpam_acct_no and uses_trantm_id = @pa_trastm_id and uses_slip_no = @l_slip_no and uses_series_type = @l_sliim_series_type )
									   begin
									   --
											insert into @temp_dp_cancel
											(dpm_dpid 
											,sliim_dpam_acct_no 
											,slip_no 
											,trastm_desc 
											,sliim_series_type ,USES_CREATED_DT)
											select @l_dpm_dpid 
											,@l_sliim_dpam_acct_no 
											,@l_slip_no
											,@l_trastm_desc 
											,@l_sliim_series_type ,@l_USES_CREATED_DT
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
					,@l_sliim_series_type ,@l_USES_CREATED_DT

			   --
			   END





    
    
   

	CLOSE @c_cursor
	DEALLOCATE @c_cursor
	

  
    select distinct dpm_dpid [DPID]
					,sliim_dpam_acct_no [ACCTNO]
					--,ISNULL(sliim_series_type,'')+ slip_no [SLIPNO] --citrus_usr.fn_modify_slipno(uses_slip_no,'9') [SLIPNO]
					,ISNULL(sliim_series_type,'')+ slip_no+ '  Dt : - ' +isnull(CONVERT(VARCHAR(10), USES_CREATED_DT, 103),'') [SLIPNO]  --citrus_usr.fn_modify_slipno(uses_slip_no,'9') [SLIPNO]
					,trastm_desc [TRANSACTIONDESC]				
					,sliim_series_type [SERIES_TYPE]
					,isnull(CONVERT(VARCHAR(10), USES_CREATED_DT, 103),'') AS uses_action_dt
				from   @temp_dp_cancel
				
    
 
  --
  END
  

  IF @pa_type = 'USED_SLIP'
  BEGIN
  --
if @pa_des_blk = ''  
set @pa_des_blk = 'U'
    if @pa_client_id <> ''
    begin
    --
    select distinct dpm_dpid [DPID]
										,uses_dpam_acct_no [ACCTNO]
										,ISNULL(USES_SERIES_TYPE,'')+citrus_usr.fn_modify_slipno(uses_slip_no,'16') + convert(varchar(11),uses_slipremarks,103)   [SLIPNO]
										,trastm_desc [TRANSACTIONDESC]
									
										,uses_series_type [SERIES_TYPE]
				from   used_slip
				      ,dp_mstr 
				      ,transaction_sub_type_mstr 
				      ,transaction_type_mstr , dptd_mak
				where  dpm_id = uses_dpm_id
				and    trastm_tratm_id = trantm_id
and dpm_id = @l_dpm_id
			 and    trantm_code in ('SLIP_TYPE_CDSL','SLIP_TYPE_nsdl')
    and    isnumeric(replace(dptd_slip_no,USES_SERIES_TYPE,''))= 1
    and    isnumeric(uses_slip_no)= 1
    and    abs(uses_slip_no) = abs(replace(dptd_slip_no,USES_SERIES_TYPE,''))
	and    case when uses_trantm_id = '904' then '904_'+ DPTD_INTERNAL_TRASTM 
                when uses_trantm_id = '905' then '905_'+ DPTD_INTERNAL_TRASTM
				when left(uses_trantm_id,3) = '912' then '906'
		   else uses_trantm_id end = trastm_cd
	and	   trastm_cd = case when dptd_trastm_cd =  '912' then '906' else dptd_trastm_cd end 
    and    case when left(uses_trantm_id,3) = '912' then '906' else left(uses_trantm_id,3) end = left(@pa_trastm_id,3)
    and    uses_dpam_acct_no  = @pa_client_id
    and    trastm_cd = @pa_trastm_id
    and    uses_used_destr like case when  @pa_des_blk = '' then '%' else @pa_des_blk end

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
and dpm_id = @l_dpm_id
				and    trantm_code in ('SLIP_TYPE_CDSL','SLIP_TYPE_nsdl')
    and    uses_trantm_id = trastm_cd
    and    uses_trantm_id = @pa_trastm_id
    and    uses_dpam_acct_no  = @pa_client_id
    and    uses_used_destr like case when  @pa_des_blk = '' then '%' else @pa_des_blk end
    
    --
    end
    else
    begin
    --
      select distinct	dpm_dpid [DPID]
								,uses_dpam_acct_no [ACCTNO]
								,ISNULL(USES_SERIES_TYPE,'')+citrus_usr.fn_modify_slipno(uses_slip_no,'16') [SLIPNO]
								,trastm_desc [TRANSACTIONDESC]
					
								,uses_series_type [SERIES_TYPE]
		from   used_slip
		      ,dp_mstr 
		      ,transaction_sub_type_mstr 
			,transaction_type_mstr , dptd_mak
		where  dpm_id = uses_dpm_id
		and    trastm_tratm_id = trantm_id
and dpm_id = @l_dpm_id
		and    trantm_code in ('SLIP_TYPE_CDSL','SLIP_TYPE_nsdl')
		and    isnumeric(replace(dptd_slip_no,USES_SERIES_TYPE,''))= 1
		and    isnumeric(uses_slip_no)= 1
		and    abs(uses_slip_no) = abs(replace(dptd_slip_no,USES_SERIES_TYPE,''))
		and    case when uses_trantm_id = '904' then '904_'+ DPTD_INTERNAL_TRASTM 
		            when uses_trantm_id = '905' then '905_'+ DPTD_INTERNAL_TRASTM 
					when left(uses_trantm_id,3) = '912' then '906'
					else uses_trantm_id end = trastm_cd
		and trastm_cd = case when dptd_trastm_cd =  '912' then '906' else dptd_trastm_cd end 
		                and    case when left(uses_trantm_id,3) = '912' then '906' else left(uses_trantm_id,3) end = left(@pa_trastm_id,3)
                        and    trastm_cd = @pa_trastm_id
						and    uses_used_destr like case when  @pa_des_blk = '' then '%' else @pa_des_blk end
				
    
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
	and    dpm_id = @l_dpm_id
	and    trantm_code in ('SLIP_TYPE_CDSL','SLIP_TYPE_nsdl')
	and    uses_trantm_id = trastm_cd
	and    uses_dpam_acct_no  = @pa_client_id
	and    uses_trantm_id = @pa_trastm_id
	and    uses_used_destr like case when  @pa_des_blk = '' then '%' else @pa_des_blk end

    end

  --
  END
--  IF @pa_type = 'Canceled_SLIP'
--  BEGIN
--  --
  
--    select distinct dpm_dpid [DPID]
--					,uses_dpam_acct_no [ACCTNO]
--					,ISNULL(USES_SERIES_TYPE,'')+ uses_slip_no+ '  Dt : - ' +isnull(CONVERT(VARCHAR(10), USES_CREATED_DT, 103),'') [SLIPNO]  --citrus_usr.fn_modify_slipno(uses_slip_no,'9') [SLIPNO]
--					,trastm_desc [TRANSACTIONDESC]				
--					,uses_series_type [SERIES_TYPE]
--					,isnull(CONVERT(VARCHAR(10), USES_CREATED_DT, 103),'') AS uses_action_dt
--				from   used_slip_block
--				      ,dp_mstr 
--				      ,transaction_sub_type_mstr 
--				      ,transaction_type_mstr 
--				where  dpm_id = uses_dpm_id
--				and    trastm_tratm_id = trantm_id
--			 and    trantm_code in ('SLIP_TYPE_CDSL','SLIP_TYPE_nsdl')
--    and    isnumeric(uses_slip_no)= 1
--   	and   uses_trantm_id  = trastm_id AND USES_DPAM_ACCT_NO = left(@pa_client_id,16)
--			 --and    left(uses_trantm_id,3) = left(@pa_trastm_id,3)
--    and    trastm_cd = @pa_trastm_id
----    and    uses_used_destr like case when  @pa_des_blk = '' then '%' else @pa_des_blk end
    
 
--  --
--  END
IF @pa_type = 'DESTROYED_SLIP'
  BEGIN
  --
  print @l_dpm_id
  
    select distinct dpm_dpid [DPID]
										,uses_dpam_acct_no [ACCTNO]
										,ISNULL(USES_SERIES_TYPE,'')+citrus_usr.fn_modify_slipno(uses_slip_no,'16') + ' Date:- ' +  convert(varchar(11),isnull(uses_slipremarks,'1-1-1900'),103) [SLIPNO]
										,trastm_desc [TRANSACTIONDESC]
									
										,uses_series_type [SERIES_TYPE]
				from   used_slip
				      ,dp_mstr 
				      ,transaction_sub_type_mstr 
				      ,transaction_type_mstr 
				where  dpm_id = uses_dpm_id
				and    trastm_tratm_id = trantm_id
			 and    trantm_code in ('SLIP_TYPE_CDSL','SLIP_TYPE_nsdl')
and dpm_id = @l_dpm_id
    and    isnumeric(uses_slip_no)= 1
   	and   uses_trantm_id  = trastm_cd
			 and    left(uses_trantm_id,3) = left(@pa_trastm_id,3)
 and    uses_dpam_acct_no  = @pa_client_id
    and    trastm_cd = @pa_trastm_id
    and    uses_used_destr like case when  @pa_des_blk = '' then '%' else @pa_des_blk end
    
 
  --
  END

  IF @pa_type = 'BLOCKED_SLIP'
  BEGIN
  --
  
    select distinct dpm_dpid [DPID]
										,uses_dpam_acct_no [ACCTNO]
										--ISNULL(USES_SERIES_TYPE,'')+citrus_usr.fn_modify_slipno(uses_slip_no,'16') [SLIPNO]
										,ISNULL(USES_SERIES_TYPE,'')+ citrus_usr.fn_modify_slipno(uses_slip_no,'16')+ '  Dt : - ' +isnull(CONVERT(VARCHAR(10), USES_CREATED_DT, 103),'')  [SLIPNO]
										,trastm_desc [TRANSACTIONDESC]
									
										,uses_series_type [SERIES_TYPE]
				from   used_slip
				      ,dp_mstr 
				      ,transaction_sub_type_mstr 
				      ,transaction_type_mstr 
				where  dpm_id = uses_dpm_id
				and    trastm_tratm_id = trantm_id
and dpm_id = @l_dpm_id
			 and    trantm_code in ('SLIP_TYPE_CDSL','SLIP_TYPE_nsdl')
    and    isnumeric(uses_slip_no)= 1
   	and   uses_trantm_id  = trastm_cd
			 and    left(uses_trantm_id,3) = left(@pa_trastm_id,3)
    and    trastm_cd = @pa_trastm_id
 and    uses_dpam_acct_no  = @pa_client_id
    and    uses_used_destr like case when  @pa_des_blk = '' then '%' else @pa_des_blk end
    
 
  --
  END
  ELSE IF @pa_type = 'UNUSED_SLIP'
  BEGIN
  --
  
    declare  @temp_dp table(dpm_dpid varchar(20),sliim_dpam_acct_no varchar(16),slip_no varchar(10),trastm_desc varchar(100),sliim_series_type varchar(20)) 
    
    
 --   declare @l_dpm_dpid varchar(20)
 --   ,@l_sliim_dpam_acct_no varchar(16)
 --   ,@l_slip_no numeric
 --   ,@l_slip_from numeric
 --   ,@l_slip_to numeric
 --   ,@l_trastm_desc varchar(100)
 --   ,@l_sliim_series_type varchar(20)
    
	--declare @c_cursor cursor  
				
  
  
    if @pa_client_id <> ''
	begin
	--

				CREATE TABLE #TEMPSLIP(uses_dpam_acct_no VARCHAR(20),uses_trantm_id VARCHAR(10),uses_slip_no VARCHAR(20),uses_series_type VARCHAR(10))
				INSERT INTO #TEMPSLIP SELECT uses_dpam_acct_no,uses_trantm_id,uses_slip_no,uses_series_type FROM used_slip WHERE uses_dpam_acct_no = @pa_client_id
				--select * from #TEMPSLIP				
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
and dpm_id = @l_dpm_id
				and    trantm_code in ('SLIP_TYPE_CDSL','SLIP_TYPE_nsdl')
				and   sliim_tratm_id = trastm_id
				and   trastm_cd = @pa_trastm_id
				and   sliim_dpam_acct_no  = @pa_client_id
                and   sliim_deleted_ind = 1
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
and dpm_id = @l_dpm_id
				and    trantm_code in ('SLIP_TYPE_CDSL','SLIP_TYPE_nsdl')
				and   sliim_tratm_id = trastm_id
				and   trastm_cd = @pa_trastm_id
				and   sliim_dpam_acct_no  =case when @pa_client_id like '%nse%' then  'NSE POA' when @pa_client_id like '%bse%' then 'BSE POA' else 'BOTH' end 
                and   sliim_deleted_ind = 1


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

									   if not exists (select uses_slip_no from #TEMPSLIP where uses_dpam_acct_no = @l_sliim_dpam_acct_no and case when left(uses_trantm_id,3) = '912' then '906' else left(uses_trantm_id,3) end = left(@pa_trastm_id,3) and isnumeric(replace(uses_slip_no ,@l_sliim_series_type ,'')) = 1 and  abs(replace(uses_slip_no ,@l_sliim_series_type ,'')) = abs(@l_slip_no))
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
and dpm_id = @l_dpm_id
				and   sliim_tratm_id = trastm_id
				and   trastm_cd = @pa_trastm_id
                and   sliim_deleted_ind = 1
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
and dpm_id = @l_dpm_id
				and   sliim_tratm_id = trastm_id
				and   trastm_cd = @pa_trastm_id
                and   sliim_deleted_ind = 1

                --
				OPEN @c_cursor            
				FETCH NEXT FROM @c_cursor   
				INTO @l_dpm_dpid 
				,@l_sliim_dpam_acct_no 
				,@l_slip_from 
				,@l_slip_to 
				,@l_trastm_desc 
				,@l_sliim_series_type 
			    --
			    --
			    WHILE @@fetch_status = 0            
				BEGIN            
							--   
								set @l_slip_no = @l_slip_from 
								WHILE  @l_slip_no <= @l_slip_to 
								BEGIN  
									 --  
									   if not exists (select uses_id from used_slip where uses_dpam_acct_no = @l_sliim_dpam_acct_no and  case when left(uses_trantm_id,3) = '912' then '906' else left(uses_trantm_id,3) end= left(@pa_trastm_id,3) and isnumeric(replace(uses_slip_no ,@l_sliim_series_type ,'')) = 1 and  abs(replace(uses_slip_no ,@l_sliim_series_type ,'')) = @l_slip_no )
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
	
   --select * from @temp_dp
   
   select dpm_dpid [DPID]
						   ,sliim_dpam_acct_no [ACCTNO]
						   ,ISNULL(sliim_series_type,'') + slip_no  [SLIPNO]
						   ,trastm_desc  [TRANSACTIONDESC]
						 
						   ,sliim_series_type [SERIES_TYPE]
			from @temp_dp where not exists(select ltrim(rtrim(USES_SERIES_TYPE)) + ltrim(rtrim(USES_SLIP_NO ))  from used_slip where ltrim(rtrim(USES_SERIES_TYPE)) + ltrim(rtrim(USES_SLIP_NO ))  = ISNULL(sliim_series_type,'') + slip_no)


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
and dpm_id = @l_dpm_id
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
and dpm_id = @l_dpm_id
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
