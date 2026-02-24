-- Object: PROCEDURE citrus_usr.pr_fetch_disdata_BAK_19052012
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

-- pr_fetch_disdata	'Fetchdataforsave','feb 01 2010','dec 12 2011','','E'	
	--pr_fetch_disdata	'Feb  1 2010',	'May 24 2011','1201200000021524','E'

--select * from slip_issue_mstr order by 1 desc
--
--delete from slip_issue_mstr where sliim_id in (2753)
--	           
CREATE proc [citrus_usr].[pr_fetch_disdata_BAK_19052012](@pa_Action varchar(100)
,@pa_from_date datetime
,@pa_to_date datetime
,@pa_boid varchar(8000)
,@pa_exist char(1)
)
as 
begin

create table #temp1
(
	boid  varchar(30)
	,slip_no numeric
)
create table #temp2
(
	boid  varchar(30),
    yn char(1)
)

	declare @l_counter numeric  
			,@l_count numeric   
			--,@l_adr varchar(8000)
  
   set @l_counter  = 1  
   set @l_count = citrus_usr.ufn_countstring(@pa_boid ,'|*~|') 
print @l_count 
  
   while @l_count >= @l_counter  
   begin   
  
		insert into #temp1 select citrus_usr.fn_splitval_by(citrus_usr.fn_splitval(@pa_boid,@l_counter),1,'|')
		,citrus_usr.fn_splitval_by(citrus_usr.fn_splitval(@pa_boid,@l_counter),2,'|')  
			  
		set @l_counter= @l_counter +1   
	end   

select distinct convert(datetime,accp_value,103) accp_value, ACCP_CLISBA_ID , accp_accpm_prop_cd 
into #account_properties 
from account_properties where accp_accpm_prop_cd = 'BILL_START_DT' 


insert into #temp2
select distinct left(t.boid,16),d.slip_yn from #temp1 t,dis_req_dtls d where left(t.boid,16) = d.boid and deleted_ind =1
--set @l_adr = citrus_usr.fn_addr_value(@l_crn_no,'COR_ADR1')                      if @l_adr = ''                  
--        begin                  
--           set @l_adr = citrus_usr.fn_addr_value(@l_crn_no,'PER_ADR1')                  
--        end     

		if @pa_action = 'FileGeneration'
		begin 
			
			if @pa_exist = 'E'
			begin						
				select dpm_dpid
				, dpam_sba_no 
				, dpam_sba_name
				, isnull(DPHD_SH_FNAME,'') + ' ' + isnull(DPHD_SH_MNAME,'') +' ' + isnull(DPHD_SH_LNAME,'') sh_name
				, isnull(DPHD_tH_FNAME,'') + ' ' + isnull(DPHD_tH_MNAME,'') +' ' + isnull(DPHD_tH_LNAME,'') th_name
				, SLIIM_SLIP_NO_FR, SLIIM_SLIP_NO_TO
				, sliim_book_name
				--, sliim_rmks
				--,isnull((select top  1 sliim_book_name from slip_issue_mstr  innerdata where  innerdata.SLIIM_DPAM_ACCT_NO = main.SLIIM_DPAM_ACCT_NO and  innerdata.sliim_id < main.sliim_id order by sliim_id  desc) ,'')  old_book_name
				,isnull(replace(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(DPAM_CRN_NO,'COR_ADR1'),1),',',''),'') [ADDRESS1]
				,isnull(replace(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(DPAM_CRN_NO,'COR_ADR1'),2),',',''),'') [ADDRESS2]
				,isnull(replace(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(DPAM_CRN_NO,'COR_ADR1'),3),',',''),'') [ADDRESS3]
				,isnull(replace(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(DPAM_CRN_NO,'COR_ADR1'),4),',',''),'') [CITY]
				,isnull(replace(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(DPAM_CRN_NO,'COR_ADR1'),5),',',''),'') [STATE]
				,isnull(replace(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(DPAM_CRN_NO,'COR_ADR1'),6),',',''),'') [COUNTRY]
				,isnull(replace(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(DPAM_CRN_NO,'COR_ADR1'),7),',',''),'') [PIN CODE]
				,isnull([citrus_usr].[fn_conc_value](dpam_crn_no,'OFF_PH1'),'')  [off_ph]  
				,isnull([citrus_usr].[fn_conc_value](dpam_crn_no,'MOBILE1'),'')  [mobile]  
				from slip_issue_mstr main,dp_mstr , dp_acct_mstr left outer join dp_holder_dtls on dphd_dpam_id = dpam_id 
				,#account_properties , Dis_req_Dtls dis
				,#temp1 temp1 ,#temp2 temp2
				where dpam_deleted_ind =1 and sliim_deleted_ind = 1 and accp_clisba_id = dpam_id 
				and dpam_dpm_id = dpm_id  and dis.Boid = dpam_sba_no and isnull(reco_yn,'') = ''
				and SLIIM_DPAM_ACCT_NO = dpam_sba_no 
				and isnumeric(req_slip_no) = 1 
				and convert(numeric,req_slip_no) < convert(numeric,SLIIM_SLIP_NO_FR)
				and slip_no between SLIIM_SLIP_NO_FR and SLIIM_SLIP_NO_TO
				--and accp_value between @pa_from_date and @pa_to_date 
				and req_date between @pa_from_date and @pa_to_date + ' 23:59:59'
				and left(temp1.Boid,16) = dpam_sba_no
                and temp2.boid = left(temp1.boid,16) and temp2.yn='S'
                union
				select dpm_dpid
				, dpam_sba_no 
				, dpam_sba_name
				, isnull(DPHD_SH_FNAME,'') + ' ' + isnull(DPHD_SH_MNAME,'') +' ' + isnull(DPHD_SH_LNAME,'') sh_name
				, isnull(DPHD_tH_FNAME,'') + ' ' + isnull(DPHD_tH_MNAME,'') +' ' + isnull(DPHD_tH_LNAME,'') th_name
				, SLIIM_SLIP_NO_FR, SLIIM_SLIP_NO_TO
				, sliim_book_name
				--, sliim_rmks
				--,isnull((select top  1 sliim_book_name from slip_issue_mstr  innerdata where  innerdata.SLIIM_DPAM_ACCT_NO = main.SLIIM_DPAM_ACCT_NO and  innerdata.sliim_id < main.sliim_id order by sliim_id  desc) ,'')  old_book_name
			  	,isnull(replace(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(DPAM_CRN_NO,'COR_ADR1'),1),',',''),'') [ADDRESS1]
				,isnull(replace(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(DPAM_CRN_NO,'COR_ADR1'),2),',',''),'') [ADDRESS2]
				,isnull(replace(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(DPAM_CRN_NO,'COR_ADR1'),3),',',''),'') [ADDRESS3]
				,isnull(replace(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(DPAM_CRN_NO,'COR_ADR1'),4),',',''),'') [CITY]
				,isnull(replace(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(DPAM_CRN_NO,'COR_ADR1'),5),',',''),'') [STATE]
				,isnull(replace(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(DPAM_CRN_NO,'COR_ADR1'),6),',',''),'') [COUNTRY]
				,isnull(replace(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(DPAM_CRN_NO,'COR_ADR1'),7),',',''),'') [PIN CODE]
				,isnull([citrus_usr].[fn_conc_value](dpam_crn_no,'OFF_PH1'),'')  [off_ph]  
				,isnull([citrus_usr].[fn_conc_value](dpam_crn_no,'MOBILE1'),'')  [mobile]  
				from slip_issue_mstr main,dp_mstr , dp_acct_mstr left outer join dp_holder_dtls on dphd_dpam_id = dpam_id 
				,#account_properties , Dis_req_Dtls dis
				,#temp1 temp1 ,#temp2 temp2
				where dpam_deleted_ind =1 and sliim_deleted_ind = 1 and accp_clisba_id = dpam_id 
				and dpam_dpm_id = dpm_id  and dis.Boid = dpam_sba_no and isnull(reco_yn,'') = ''
				and SLIIM_DPAM_ACCT_NO = dpam_sba_no 
				and slip_no between SLIIM_SLIP_NO_FR and SLIIM_SLIP_NO_TO
				--and accp_value between @pa_from_date and @pa_to_date 
				and req_date between @pa_from_date and @pa_to_date + ' 23:59:59'
				and left(temp1.Boid,16) = dpam_sba_no
                and temp2.boid = left(temp1.boid,16) and temp2.yn='L'
				--and sliim_book_name <> ''				
			 end
			 else
			 begin
				select dpm_dpid
				, dpam_sba_no 
				, dpam_sba_name
				, isnull(DPHD_SH_FNAME,'') + ' ' + isnull(DPHD_SH_MNAME,'') +' ' + isnull(DPHD_SH_LNAME,'') sh_name
				, isnull(DPHD_tH_FNAME,'') + ' ' + isnull(DPHD_tH_MNAME,'') +' ' + isnull(DPHD_tH_LNAME,'') th_name
				, SLIIM_SLIP_NO_FR, SLIIM_SLIP_NO_TO
				, sliim_book_name
				--, sliim_rmks
				--,isnull((select top  1 sliim_book_name from slip_issue_mstr  innerdata where  innerdata.SLIIM_DPAM_ACCT_NO = main.SLIIM_DPAM_ACCT_NO and  innerdata.sliim_id < main.sliim_id order by sliim_id  desc) ,'')  old_book_name
					,isnull(replace(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(DPAM_CRN_NO,'COR_ADR1'),1),',',''),'') [ADDRESS1]
				,isnull(replace(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(DPAM_CRN_NO,'COR_ADR1'),2),',',''),'') [ADDRESS2]
				,isnull(replace(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(DPAM_CRN_NO,'COR_ADR1'),3),',',''),'') [ADDRESS3]
				,isnull(replace(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(DPAM_CRN_NO,'COR_ADR1'),4),',',''),'') [CITY]
				,isnull(replace(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(DPAM_CRN_NO,'COR_ADR1'),5),',',''),'') [STATE]
				,isnull(replace(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(DPAM_CRN_NO,'COR_ADR1'),6),',',''),'') [COUNTRY]
				,isnull(replace(citrus_usr.fn_splitval(citrus_usr.fn_addr_value(DPAM_CRN_NO,'COR_ADR1'),7),',',''),'') [PIN CODE]
				,isnull([citrus_usr].[fn_conc_value](dpam_crn_no,'OFF_PH1'),'')  [off_ph]  
				,isnull([citrus_usr].[fn_conc_value](dpam_crn_no,'MOBILE1'),'')  [mobile]  
				from slip_issue_mstr main,dp_mstr , dp_acct_mstr left outer join dp_holder_dtls on dphd_dpam_id = dpam_id 
				,#account_properties --, Dis_req_Dtls
				,#temp1
				where dpam_deleted_ind =1 and sliim_deleted_ind = 1 and accp_clisba_id = dpam_id 
				and dpam_dpm_id = dpm_id  --and Boid = dpam_sba_no and isnull(reco_yn,'') = ''
				and SLIIM_DPAM_ACCT_NO = dpam_sba_no
				and slip_no between SLIIM_SLIP_NO_FR and SLIIM_SLIP_NO_TO 
				--and isnumeric(req_slip_no) = 1
				--and convert(numeric,req_slip_no) <= convert(numeric,SLIIM_SLIP_NO_FR)
				and accp_value between @pa_from_date and @pa_to_date + ' 23:59:59'
				and Boid = dpam_sba_no
				and sliim_book_name = ''
			 end
				
				
       end 
       if @pa_action = 'Fetchdataforsave'
	   begin 	
				if @pa_exist = 'E'
              
					select dpm_dpid
						,dpam_sba_no 
						, dpam_sba_name
						, isnull(DPHD_SH_FNAME,'') + ' ' + isnull(DPHD_SH_MNAME,'') +' ' + isnull(DPHD_SH_LNAME,'') sh_name
						, isnull(DPHD_tH_FNAME,'') + ' ' + isnull(DPHD_tH_MNAME,'') +' ' + isnull(DPHD_tH_LNAME,'') th_name
						from dp_mstr , dp_acct_mstr left outer join dp_holder_dtls on dphd_dpam_id = dpam_id 
						,#account_properties , Dis_req_Dtls
						--,#temp1
						where dpam_deleted_ind =1 and accp_clisba_id = dpam_id 
						and dpam_dpm_id = dpm_id  and Boid = dpam_sba_no and isnull(reco_yn,'') = ''
						--and accp_value between @pa_from_date and @pa_to_date 
						and req_date between @pa_from_date and @pa_to_date + ' 23:59:59'
						and (not exists(select SLIIM_DPAM_ACCT_NO  from slip_issue_mstr 
                        where SLIIM_DPAM_ACCT_NO =  dpam_sba_no and sliim_deleted_ind= 1
                        and sliim_dt between @pa_from_date and @pa_to_date + ' 23:59:59'
						and case when req_slip_no <> '' then  convert(numeric,req_slip_no)+1  else 1 end between case when req_slip_no <> '' then  convert(numeric,SLIIM_SLIP_NO_FR ) else 1 end and case when req_slip_no <> '' then  convert(numeric,SLIIM_SLIP_NO_To ) else 1 end 
						 )	or 	req_slip_no = ''
							)
								
			
				
				if @pa_exist <> 'E'
	            select dpm_dpid
				,dpam_sba_no 
				, dpam_sba_name
				, isnull(DPHD_SH_FNAME,'') + ' ' + isnull(DPHD_SH_MNAME,'') +' ' + isnull(DPHD_SH_LNAME,'') sh_name
				, isnull(DPHD_tH_FNAME,'') + ' ' + isnull(DPHD_tH_MNAME,'') +' ' + isnull(DPHD_tH_LNAME,'') th_name
				from dp_mstr , dp_acct_mstr left outer join dp_holder_dtls on dphd_dpam_id = dpam_id 
				,#account_properties --, Dis_req_Dtls,
				--,#temp1
				where dpam_deleted_ind =1 and accp_clisba_id = dpam_id 
				and dpam_dpm_id = dpm_id  --and Boid = dpam_sba_no and isnull(reco_yn,'') = ''
				and accp_value between @pa_from_date and @pa_to_date + ' 23:59:59'
				and not exists(select SLIIM_DPAM_ACCT_NO  from slip_issue_mstr where SLIIM_DPAM_ACCT_NO =  dpam_sba_no 
                and sliim_deleted_ind= 1
                --and sliim_dt between convert(datetime,@pa_from_date) and convert(datetime,@pa_to_date)
) 
				order by dpam_sba_no 
				

				--and Boid = dpam_sba_no
				 
	   
	   end  

end

GO
