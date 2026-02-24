-- Object: PROCEDURE citrus_usr.pr_fetch_disdata_baksep222014
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------






--begin tran
-- pr_fetch_disdata	'Fetchdataforsave','jul 01 2012','jul 10 2012','','N'	
--pr_fetch_disdata	'Feb  1 2010',	'May 24 2011','1201200000021524','E'

--rollback

--select * from slip_issue_mstr order by 1 desc
--
--delete from slip_issue_mstr where sliim_id in (2753)
--	           

create proc [citrus_usr].[pr_fetch_disdata_baksep222014](@pa_Action varchar(100)
,@pa_from_date datetime
,@pa_to_date datetime
,@pa_boid varchar(MAX)
,@pa_exist char(1)
)
as 
begin

--create table #temp1
--(
--	boid  varchar(30)
--	,slip_no numeric
--)
create table #temp2
(
	boid  varchar(30),
    yn char(1)
)

	--declare @l_counter numeric  
	--		,@l_count numeric   
			--,@l_adr varchar(8000)
  
--   set @l_counter  = 1  
--   set @l_count = citrus_usr.ufn_countstring(@pa_boid ,'|*~|') 
--print @l_count 
  
 --  while @l_count >= @l_counter  
 --  begin   
  
	--	insert into #temp1 select distinct citrus_usr.fn_splitval_by(citrus_usr.fn_splitval(@pa_boid,@l_counter),1,'|')
	--	,citrus_usr.fn_splitval_by(citrus_usr.fn_splitval(@pa_boid,@l_counter),2,'|')  
			  
	--	set @l_counter= @l_counter +1   
	--end   

select distinct convert(datetime,accp_value,103) accp_value, ACCP_CLISBA_ID , accp_accpm_prop_cd 
into #account_properties 
from account_properties where accp_accpm_prop_cd = 'BILL_START_DT' 


insert into #temp2
select distinct left(t.boid,16),d.slip_yn from fetchdisdata t --#temp1 t
,dis_req_dtls d where left(t.boid,16) = d.boid and deleted_ind =1
--set @l_adr = citrus_usr.[fn_addr_value_vendorfilgn](@l_crn_no,'COR_ADR1')                      if @l_adr = ''                  
--        begin                  
--           set @l_adr = citrus_usr.[fn_addr_value_vendorfilgn](@l_crn_no,'PER_ADR1')                  
--        end     

		if @pa_action = 'FileGeneration'
		begin 
			if exists (select count(*) from fetchdisdata having count(*) > 0)
		begin
	
				DECLARE @series varchar(20),@id varchar(20),@entmid varchar(20),@boid varchar(20)
				,@from varchar(20),@to varchar(20),@remarks varchar(100),@dtval datetime, @l_sliim_id      NUMERIC
      , @l_sliimm_id     NUMERIC , @l_sliim_gen_id numeric,@l_dpm_id       NUMERIC,@dpam_id numeric


				set @dtval = getdate()
			

				--------------------------------------------------------
				DECLARE @MyCursor CURSOR
				SET @MyCursor = CURSOR FAST_FORWARD
				FOR
				SELECT  series_type,id,entm_id,boid,series_from,series_to,remarks,dpam_id
				FROM   fetchdisdata ,dp_acct_mstr where dpam_sba_no=boid and dpam_deleted_ind=1
				OPEN @MyCursor
				FETCH NEXT FROM @MyCursor
				INTO @series,@id,@entmid,@boid,@from,@to,@remarks,@dpam_id
				WHILE @@FETCH_STATUS = 0
				BEGIN
					--exec pr_mak_sliim_new '0','INS','MIG',454,@series,@id,@entmid,@boid,@from,@to,'0',@dtval,'',@remarks,0,'','',''
					  SELECT @l_sliim_id   = ISNULL(MAX(sliim_id),0) + 1, @l_sliim_gen_id = ISNULL(MAX(sliim_gen_id),0) + 1 
					  FROM slip_issue_mstr with (nolock)
				      -- FROM slip_issue_mstr with (nolock)
					
					  SELECT @l_dpm_id  = dpm_id FROM dp_mstr WHERE dpm_deleted_ind = 1   and default_dp = dpm_excsm_id and dpm_dpid = @id
						
				      INSERT INTO slip_issue_mstr 
				      (					sliim_id
										,sliim_tratm_id
										,sliim_dpm_id
										,sliim_series_type
										,sliim_entm_id
										,sliim_dpam_acct_no
										,sliim_slip_no_fr
										,sliim_slip_no_to
										,sliim_loose_y_n
										,sliim_no_used
										,sliim_all_used
										,sliim_created_by
										,sliim_created_dt
										,sliim_lst_upd_by
										,sliim_lst_upd_dt
										,sliim_deleted_ind, sliim_dt,sliim_book_name , sliim_rmks,sliim_gen_id,sliim_gen_date

				      )VALUES
									   (@l_sliim_id   
									    ,454
										,@l_dpm_id
										,''  
										,@dpam_id
										,@boid  
										,@from   
										,@to      
										,'0'
										,0
										,0
										,'MIG'
										,getdate()
										,'MIG'
										,getdate()
										,1,getdate(),'', @remarks,case when @series <> '0' then @series else convert(varchar,@l_sliim_gen_id) end ,getdate()
				      )
 
				FETCH NEXT FROM @MyCursor
				INTO @series,@id,@entmid,@boid,@from,@to,@remarks,@dpam_id
				END
				CLOSE @MyCursor
				DEALLOCATE @MyCursor
		end			

			if @pa_exist = 'E'
			begin						
				select  dpm_dpid
				, dpam_sba_no 
				, dpam_sba_name
				, isnull(DPHD_SH_FNAME,'') + ' ' + isnull(DPHD_SH_MNAME,'') +' ' + isnull(DPHD_SH_LNAME,'') sh_name
				, isnull(DPHD_tH_FNAME,'') + ' ' + isnull(DPHD_tH_MNAME,'') +' ' + isnull(DPHD_tH_LNAME,'') th_name
				, SLIIM_SLIP_NO_FR, SLIIM_SLIP_NO_TO
				, SLIIM_SLIP_NO_TO sliim_book_name
				--, sliim_rmks
				--,isnull((select top  1 sliim_book_name from slip_issue_mstr  innerdata where  innerdata.SLIIM_DPAM_ACCT_NO = main.SLIIM_DPAM_ACCT_NO and  innerdata.sliim_id < main.sliim_id order by sliim_id  desc) ,'')  old_book_name
				,isnull(replace(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),1),',',''),'') [ADDRESS1]
				--,isnull(replace(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),2),',',''),'') [ADDRESS2]
				,case when left(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),3),1) in ('+','-') then isnull(substring(replace(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),2),',',''),2,len(replace(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),2),',',''))),'') else isnull(replace(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),2),',',''),'') end  [ADDRESS2]
				--,isnull(replace(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),3),',',''),'') [ADDRESS3]
                ,case when left(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),3),1) in ('+','-') then isnull(substring(replace(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),3),',',''),2,len(replace(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),3),',',''))),'') else isnull(replace(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),3),',',''),'') end  [ADDRESS3]
				,isnull(replace(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),4),',',''),'') [CITY]
				,isnull(replace(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),5),',',''),'') [STATE]
				,isnull(replace(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),6),',',''),'') [COUNTRY]
				,isnull(replace(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),7),',',''),'') [PIN CODE]
				,isnull([citrus_usr].[fn_conc_value](dpam_crn_no,'OFF_PH1'),'')  [off_ph]  
				,isnull([citrus_usr].[fn_conc_value](dpam_crn_no,'MOBILE1'),'')  [mobile]  
				from slip_issue_mstr main,dp_mstr , dp_acct_mstr left outer join dp_holder_dtls on dphd_dpam_id = dpam_id 
				,#account_properties , Dis_req_Dtls dis
				--,#temp1 temp1 
				,fetchdisdata temp1
				,#temp2 temp2
				where dpam_deleted_ind =1 and sliim_deleted_ind = 1 and accp_clisba_id = dpam_id 
				and dpam_dpm_id = dpm_id  and dis.Boid = dpam_sba_no 
--and isnull(reco_yn,'') = ''  --commented on 04102013 as per MOSL request
				and SLIIM_DPAM_ACCT_NO = dpam_sba_no 
				and isnumeric(req_slip_no) = 1 
				and convert(numeric,req_slip_no) < convert(numeric,SLIIM_SLIP_NO_FR)
				and slip_no between SLIIM_SLIP_NO_FR and SLIIM_SLIP_NO_TO
				--and accp_value between @pa_from_date and @pa_to_date 
				--and req_date between @pa_from_date and @pa_to_date + ' 23:59:59'
				and lst_upd_dt between @pa_from_date and @pa_to_date + ' 23:59:59'
				and left(temp1.Boid,16) = dpam_sba_no
                and temp2.boid = left(temp1.boid,16) and temp2.yn='S' and temp2.yn <> 'D'
				and slip_yn <> 'D'
                and dpam_stam_cd in('ACTIVE','04')
				and left(dpam_sba_no,2) <> '22'  --to eliminate poa 
				and left(sliim_dpam_acct_no,2) <> '22'   --to eliminate poa 
                union
				select dpm_dpid
				, dpam_sba_no 
				, dpam_sba_name
				, isnull(DPHD_SH_FNAME,'') + ' ' + isnull(DPHD_SH_MNAME,'') +' ' + isnull(DPHD_SH_LNAME,'') sh_name
				, isnull(DPHD_tH_FNAME,'') + ' ' + isnull(DPHD_tH_MNAME,'') +' ' + isnull(DPHD_tH_LNAME,'') th_name
				, SLIIM_SLIP_NO_FR, SLIIM_SLIP_NO_TO
				, SLIIM_SLIP_NO_TO sliim_book_name
				--, sliim_rmks
				--,isnull((select top  1 sliim_book_name from slip_issue_mstr  innerdata where  innerdata.SLIIM_DPAM_ACCT_NO = main.SLIIM_DPAM_ACCT_NO and  innerdata.sliim_id < main.sliim_id order by sliim_id  desc) ,'')  old_book_name
			  	,isnull(replace(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),1),',',''),'') [ADDRESS1]
				--,isnull(replace(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),2),',',''),'') [ADDRESS2]
				,case when left(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),3),1) in ('+','-') then isnull(substring(replace(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),2),',',''),2,len(replace(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),2),',',''))),'') else isnull(replace(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),2),',',''),'') end  [ADDRESS2]
				--,isnull(replace(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),3),',',''),'') [ADDRESS3]
                ,case when left(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),3),1) in ('+','-') then isnull(substring(replace(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),3),',',''),2,len(replace(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),3),',',''))),'') else isnull(replace(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),3),',',''),'') end  [ADDRESS3]
				,isnull(replace(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),4),',',''),'') [CITY]
				,isnull(replace(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),5),',',''),'') [STATE]
				,isnull(replace(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),6),',',''),'') [COUNTRY]
				,isnull(replace(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),7),',',''),'') [PIN CODE]
				,isnull([citrus_usr].[fn_conc_value](dpam_crn_no,'OFF_PH1'),'')  [off_ph]  
				,isnull([citrus_usr].[fn_conc_value](dpam_crn_no,'MOBILE1'),'')  [mobile]  
				from slip_issue_mstr main,dp_mstr , dp_acct_mstr left outer join dp_holder_dtls on dphd_dpam_id = dpam_id 
				,#account_properties , Dis_req_Dtls dis
				--,#temp1 temp1 
				,fetchdisdata temp1
				,#temp2 temp2
				where dpam_deleted_ind =1 and sliim_deleted_ind = 1 and accp_clisba_id = dpam_id 
				and dpam_dpm_id = dpm_id  and dis.Boid = dpam_sba_no 
--and isnull(reco_yn,'') = '' --commented on 04102013 as per MOSL request
				and SLIIM_DPAM_ACCT_NO = dpam_sba_no 
				and slip_no between SLIIM_SLIP_NO_FR and SLIIM_SLIP_NO_TO -- commented on 5th July 2013 activated on 10th jul 2013
				--and accp_value between @pa_from_date and @pa_to_date 
				--and req_date between @pa_from_date and @pa_to_date + ' 23:59:59'
				and lst_upd_dt between @pa_from_date and @pa_to_date + ' 23:59:59'
				and left(temp1.Boid,16) = dpam_sba_no
                and temp2.boid = left(temp1.boid,16) and temp2.yn='L' and temp2.yn <> 'D'
				and slip_yn <> 'D'
                and dpam_stam_cd in('ACTIVE','04')
				and left(dpam_sba_no,2) <> '22'  --to eliminate poa 
				and left(sliim_dpam_acct_no,2) <> '22'   --to eliminate poa 
				--and sliim_book_name <> ''				
			 end
			 else
			 begin			
				select  dpm_dpid
				, dpam_sba_no 
				, dpam_sba_name
				, isnull(DPHD_SH_FNAME,'') + ' ' + isnull(DPHD_SH_MNAME,'') +' ' + isnull(DPHD_SH_LNAME,'') sh_name
				, isnull(DPHD_tH_FNAME,'') + ' ' + isnull(DPHD_tH_MNAME,'') +' ' + isnull(DPHD_tH_LNAME,'') th_name
				, SLIIM_SLIP_NO_FR, SLIIM_SLIP_NO_TO
				, SLIIM_SLIP_NO_TO sliim_book_name
				--, sliim_rmks
				--,isnull((select top  1 sliim_book_name from slip_issue_mstr  innerdata where  innerdata.SLIIM_DPAM_ACCT_NO = main.SLIIM_DPAM_ACCT_NO and  innerdata.sliim_id < main.sliim_id order by sliim_id  desc) ,'')  old_book_name
				,isnull(replace(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),1),',',''),'') [ADDRESS1]
				--,isnull(replace(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),2),',',''),'') [ADDRESS2]
				,case when left(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),3),1) in ('+','-') then isnull(substring(replace(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),2),',',''),2,len(replace(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),2),',',''))),'') else isnull(replace(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),2),',',''),'') end  [ADDRESS2]
				--,isnull(replace(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),3),',',''),'') [ADDRESS3]
                ,case when left(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),3),1) in ('+','-') then isnull(substring(replace(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),3),',',''),2,len(replace(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),3),',',''))),'') else isnull(replace(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),3),',',''),'') end  [ADDRESS3]
				,isnull(replace(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),4),',',''),'') [CITY]
				,isnull(replace(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),5),',',''),'') [STATE]
				,isnull(replace(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),6),',',''),'') [COUNTRY]
				,isnull(replace(citrus_usr.fn_splitval(citrus_usr.[fn_addr_value_vendorfilgn](DPAM_CRN_NO,'COR_ADR1'),7),',',''),'') [PIN CODE]
				,isnull([citrus_usr].[fn_conc_value](dpam_crn_no,'OFF_PH1'),'')  [off_ph]  
				,isnull([citrus_usr].[fn_conc_value](dpam_crn_no,'MOBILE1'),'')  [mobile]  
				from slip_issue_mstr main,dp_mstr , dp_acct_mstr left outer join dp_holder_dtls on dphd_dpam_id = dpam_id 
				,#account_properties --, Dis_req_Dtls
				--,#temp1
				,fetchdisdata
				where dpam_deleted_ind =1 and sliim_deleted_ind = 1 and accp_clisba_id = dpam_id 
				and dpam_dpm_id = dpm_id  --and Boid = dpam_sba_no and isnull(reco_yn,'') = ''
				and SLIIM_DPAM_ACCT_NO = dpam_sba_no
				and slip_no between SLIIM_SLIP_NO_FR and SLIIM_SLIP_NO_TO 
				--and isnumeric(req_slip_no) = 1
				--and convert(numeric,req_slip_no) <= convert(numeric,SLIIM_SLIP_NO_FR)
				--and accp_value between @pa_from_date and @pa_to_date + ' 23:59:59'
				and Boid = dpam_sba_no
				and sliim_book_name = ''
				and dpam_stam_cd in ('ACTIVE','04')
				and left(dpam_sba_no,2) <> '22'  --to eliminate poa 
				and left(sliim_dpam_acct_no,2) <> '22'   --to eliminate poa 
			 end
				
				
       end 
       if @pa_action = 'Fetchdataforsave'
	   begin 	

				if @pa_exist = 'E'
              
					select  dpm_dpid
						,dpam_sba_no 
						, dpam_sba_name
						, isnull(DPHD_SH_FNAME,'') + ' ' + isnull(DPHD_SH_MNAME,'') +' ' + isnull(DPHD_SH_LNAME,'') sh_name
						, isnull(DPHD_tH_FNAME,'') + ' ' + isnull(DPHD_tH_MNAME,'') +' ' + isnull(DPHD_tH_LNAME,'') th_name
						,convert(varchar,gen_id) refno
						from dp_mstr , dp_acct_mstr left outer join dp_holder_dtls on dphd_dpam_id = dpam_id 
						,#account_properties , Dis_req_Dtls
						--,#temp1
						where dpam_deleted_ind =1 and accp_clisba_id = dpam_id 
						and dpam_dpm_id = dpm_id  and Boid = dpam_sba_no 
--and isnull(reco_yn,'') = ''  --commented on 04102013 as per MOSL request
						--and accp_value between @pa_from_date and @pa_to_date 
						and dpam_stam_cd in ('ACTIVE','04')
						and left(dpam_sba_no,2) <> '22'  --to eliminate poa 
						and slip_yn <> 'D'
						--and req_date between @pa_from_date and @pa_to_date + ' 23:59:59'
						and lst_upd_dt between @pa_from_date and @pa_to_date + ' 23:59:59'
						and (not exists(select SLIIM_DPAM_ACCT_NO  from slip_issue_mstr 
                        where SLIIM_DPAM_ACCT_NO =  dpam_sba_no and sliim_deleted_ind= 1
                        and sliim_dt between @pa_from_date and @pa_to_date + ' 23:59:59'
						and case when req_slip_no <> '' then  convert(numeric,req_slip_no)+1  else 1 end between case when req_slip_no <> '' then  convert(numeric,SLIIM_SLIP_NO_FR ) else 1 end and case when req_slip_no <> '' then  convert(numeric,SLIIM_SLIP_NO_To ) else 1 end 
						 )	or 	req_slip_no = ''
							)
											
			
				
				if @pa_exist <> 'E'

	            select  dpm_dpid
				,dpam_sba_no 
				, dpam_sba_name
				, isnull(DPHD_SH_FNAME,'') + ' ' + isnull(DPHD_SH_MNAME,'') +' ' + isnull(DPHD_SH_LNAME,'') sh_name
				, isnull(DPHD_tH_FNAME,'') + ' ' + isnull(DPHD_tH_MNAME,'') +' ' + isnull(DPHD_tH_LNAME,'') th_name
				--,convert(varchar,gen_id) refno
, 0 refno
				from dp_mstr , dp_acct_mstr left outer join dp_holder_dtls on dphd_dpam_id = dpam_id 
				,#account_properties --, Dis_req_Dtls
				--,#temp1
				where dpam_deleted_ind =1 and accp_clisba_id = dpam_id 
				and dpam_dpm_id = dpm_id  --and Boid = dpam_sba_no 
--and isnull(reco_yn,'') = ''
				and accp_value between @pa_from_date and @pa_to_date + ' 23:59:59'
				and dpam_stam_cd in ('ACTIVE','04')
				and left(dpam_sba_no,2) <> '22'  --to eliminate poa 
				--and slip_yn <> 'D'
				and not exists(select SLIIM_DPAM_ACCT_NO  from slip_issue_mstr where SLIIM_DPAM_ACCT_NO =  dpam_sba_no 
                and sliim_deleted_ind= 1
                --and sliim_dt between convert(datetime,@pa_from_date) and convert(datetime,@pa_to_date)
) 
				order by dpam_sba_no 
				

				--and Boid = dpam_sba_no
				 
	   
	   end  

end

GO
