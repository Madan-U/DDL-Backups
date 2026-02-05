-- Object: PROCEDURE citrus_usr.pr_rpt_trans_count_BAK14082012
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--nsdl_pledge_dtls--PLDT_REQUEST_DT--PLDT_BATCH_NO
--cdsl_pledge_dtls--PLDTC_REQUEST_DT--PLDTc_BATCH_NO
--exec pr_rpt_trans_count @pa_excsm_id=3,@pa_tab='N',@pa_request_dt='DEC  1 2009',@pa_request_todt='DEC  1 2009',@pa_exchange='CDSL',@pa_type='T'






--cdsl screen queries  
-- for non broking transactions  
CREATE procedure [citrus_usr].[pr_rpt_trans_count_BAK14082012](
 @pa_excsm_id int
,@pa_tab varchar(10)
,@pa_request_dt varchar(11)
,@pa_request_todt varchar(11)
,@pa_exchange varchar(10)
,@pa_type char(1)
)  
as  
begin  
--  
  declare @dpm_id numeric  
    
  select @dpm_id = dpm_id from dp_mstr where default_dp = @pa_excsm_id and dpm_deleted_ind = 1  
    
  if @pa_exchange = 'CDSL' 
	  if @pa_type='C' 
		  begin 
               select clt_cnt = count(dpam_id)
               from dp_acct_mstr  with(nolock)
               where dpam_acct_no = dpam_sba_no
               and dpam_batch_no is null
               and dpam_deleted_ind = 1 
			   --and dpam_lst_upd_by between convert(datetime,@pa_request_dt,103)               
		  end 
	  else 
          begin  
				if @pa_tab = 'N'  

				SELECT EP_cnt = SUM(EP_cnt),  
				NP_cnt = SUM(NP_cnt),  
				ID_cnt = SUM(ID_cnt),  
				OFM_cnt = SUM(OFM_cnt),  
				DMT_cnt = SUM(DMT_cnt) ,    rmt_cnt = sum(rmt_cnt) 	, pldt_cnt = sum(pldt_cnt)			
                FROM 
                (Select EP_cnt = isnull(sum(case when dptdc_internal_trastm = 'EP' then 1 else 0 end),0),  
				NP_cnt = isnull(sum(case when dptdc_internal_trastm = 'NP' then 1 else 0 end),0),  
				ID_cnt = isnull(sum(case when dptdc_internal_trastm = 'ID' then 1 else 0 end),0),  
				OFM_cnt = isnull(sum(case when dptdc_internal_trastm not in('EP','NP','ID') then 1 else 0 end),0),  
                DMT_cnt =0 ,
                rmt_cnt = 0 , pldt_cnt = 0
				from dp_trx_dtls_cdsl with(nolock), dp_acct_mstr with(nolock)  
				where dptdc_dpam_id = dpam_id and dpam_dpm_id = case when @dpm_id  ='3' then dpam_dpm_id else @dpm_id  end
                 and   dptdc_request_dt BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_request_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_request_todt,103),106)+' 23:59:59'      

				--and dptdc_request_dt between  @pa_request_dt and @pa_request_todt
				and  isnull(dptdc_batch_no,'') = ''   
				and isnull(dptdc_brokerbatch_no,'') = ''   
				and dptdc_status = 'P' and dptdc_deleted_ind = 1  
                UNION
				select EP_cnt = 0,  
				NP_cnt = 0,  
				ID_cnt = 0,  
				OFM_cnt = 0,  				
				DMT_cnt = count(demrm_id),
                rmt_cnt = 0 , pldt_cnt = 0 from demat_request_mstr,dp_acct_mstr 
				WHERE demrm_request_dt between   @pa_request_dt and @pa_request_todt
				and demrm_dpam_id = dpam_id 
and dpam_dpm_id = case when @dpm_id  ='3' then dpam_dpm_id else @dpm_id  end--@dpm_id 
				AND ISNULL(DEMRM_BATCH_NO,'') = '' 
				AND DEMRM_DELETED_IND = 1
and demrm_typeofsec = 'EQUITY'
                UNION
				select EP_cnt = 0,  
				NP_cnt = 0,  
				ID_cnt = 0,  
				OFM_cnt = 0,  				
				DMT_cnt = 0, 

                rmt_cnt = count(Remrm_id), pldt_cnt = 0 from remat_request_mstr ,dp_acct_mstr
				WHERE convert(varchar(11),remrm_request_dt,103) =  @pa_request_dt
				and REMRM_DPAM_ID =dpam_id and  dpam_dpm_id = @dpm_id 
				AND ISNULL(rEMRM_BATCH_NO,'') = '' 
				AND rEMRM_DELETED_IND = 1
                UNION
				select EP_cnt = 0,  
				NP_cnt = 0,  
				ID_cnt = 0,  
				OFM_cnt = 0,  				
				DMT_cnt = 0, 
                rmt_cnt = 0 , pldt_cnt = count(pldtC_id) --nsdl_pledge_dtls--PLDT_REQUEST_DT--PLDT_BATCH_NO
                from cdsl_pledge_dtls 
				WHERE PLDTC_REQUEST_DT between  @pa_request_dt and @pa_request_todt
				AND ISNULL(PLDTC_BATCH_NO,'') = '' 
				AND PLDTC_deleted_ind = 1
                )TMP
		  
				
				if @pa_tab = 'Y' 


				SELECT EP_cnt = SUM(EP_cnt),  
				NP_cnt = SUM(NP_cnt),  
				ID_cnt = SUM(ID_cnt),  
				OFM_cnt = SUM(OFM_cnt),  
				DMT_cnt = SUM(DMT_cnt) 		,    rmt_cnt = sum(rmt_cnt) 	, pldt_cnt = sum(pldt_cnt)				
                FROM 
                (Select EP_cnt = isnull(sum(case when dptdc_internal_trastm = 'EP' then 1 else 0 end),0),  
				NP_cnt = isnull(sum(case when dptdc_internal_trastm = 'NP' then 1 else 0 end),0),  
				ID_cnt = isnull(sum(case when dptdc_internal_trastm = 'ID' then 1 else 0 end),0),  
				OFM_cnt = isnull(sum(case when dptdc_internal_trastm not in('EP','NP','ID') then 1 else 0 end),0),  
                DMT_cnt =0 , rmt_cnt = 0 , pldt_cnt = 0
				from dp_trx_dtls_cdsl with(nolock), dp_acct_mstr with(nolock)  
				where dptdc_dpam_id = dpam_id 
and dpam_dpm_id = case when @dpm_id  ='3' then dpam_dpm_id else @dpm_id  end--@dpm_id  
			--	and  dptdc_request_dt between @pa_request_dt and @pa_request_todt
      and   dptdc_request_dt BETWEEN CONVERT(VARCHAR,CONVERT(DATETIME, @pa_request_dt,103),106)+' 00:00:00' AND CONVERT(VARCHAR,CONVERT(DATETIME,@pa_request_todt,103),106)+' 23:59:59'      
				and  isnull(dptdc_batch_no,'') = ''   
				and isnull(dptdc_brokerbatch_no,'') <> ''   

				and dptdc_status = 'P' and dptdc_deleted_ind = 1  

                UNION

				select EP_cnt = 0,  
				NP_cnt = 0,  
				ID_cnt = 0,  
				OFM_cnt = 0,  				
				DMT_cnt = count(demrm_id), rmt_cnt = 0 , pldt_cnt = 0 from demat_request_mstr,dp_acct_mstr 
				WHERE convert(varchar(11),demrm_request_dt,103) =  @pa_request_dt
				and demrm_dpam_id = dpam_id 
 and dpam_dpm_id = case when @dpm_id  ='3' then dpam_dpm_id else @dpm_id  end--@dpm_id
				AND ISNULL(DEMRM_BATCH_NO,'') = '' 
				AND DEMRM_DELETED_IND = 1
and demrm_typeofsec = 'EQUITY'
                UNION
				select EP_cnt = 0,  
				NP_cnt = 0,  
				ID_cnt = 0,  
				OFM_cnt = 0,  				
				DMT_cnt = 0, 
                rmt_cnt = count(Remrm_id), pldt_cnt = 0 from remat_request_mstr ,dp_acct_mstr 
				WHERE remrm_request_dt between  @pa_request_dt and @pa_request_todt
				and remrm_dpam_id = dpam_id 
		and dpam_dpm_id = case when @dpm_id  ='3' then dpam_dpm_id else @dpm_id  end --@dpm_id
				AND ISNULL(rEMRM_BATCH_NO,'') = '' 
				AND rEMRM_DELETED_IND = 1
                UNION
				select EP_cnt = 0,  
				NP_cnt = 0,  
				ID_cnt = 0,  
				OFM_cnt = 0,  				
				DMT_cnt = 0, 
                rmt_cnt = 0 , pldt_cnt = count(pldtC_id) --nsdl_pledge_dtls--PLDT_REQUEST_DT--PLDT_BATCH_NO
                from cdsl_pledge_dtls 
				WHERE PLDTC_REQUEST_DT between  @pa_request_dt and @pa_request_todt
				AND ISNULL(PLDTC_BATCH_NO,'') = '' 
				AND PLDTC_deleted_ind = 1
                )TMP

			  --  
          end  
  else  
	            if @pa_type='C' 
			    begin 
				   select clt_cnt = count(dpam_id)
				   from dp_acct_mstr  with(nolock)
				   where dpam_acct_no = dpam_sba_no
				   and dpam_batch_no = null
				   and dpam_deleted_ind = 1  
			    end 
	            else
                begin  
    --nsdl screen queries  
    -- for non broking transactions 
 
                
				if @pa_tab = 'N'  

                SELECT AcctTrf_del_cnt = SUM(AcctTrf_del_cnt),  
				AcctTrf_Rec_cnt = SUM(AcctTrf_Rec_cnt),  
				ID_del_cnt = SUM(ID_del_cnt),  
				ID_rec_cnt = SUM(ID_rec_cnt),  
				Int_sett_cnt = SUM(Int_sett_cnt),  
				EP_cnt = SUM(EP_cnt),
               do_cnt=sum( do_cnt) ,
                p2p_cnt = SUM(p2p_cnt),
				DMT_cnt = SUM(DMT_cnt) , rmt_cnt = sum(rmt_cnt) , pldt_cnt = sum(pldt_cnt)
				FROM 
				(
                select AcctTrf_del_cnt = isnull(sum(case when dptd_trastm_cd in( '904') then 1 else 0 end),0),  
				AcctTrf_Rec_cnt = isnull(sum(case when dptd_trastm_cd = '905' then 1 else 0 end),0),  
				ID_del_cnt = isnull(sum(case when dptd_trastm_cd = '925' then 1 else 0 end),0),  
				ID_rec_cnt = isnull(sum(case when dptd_trastm_cd = '926' then 1 else 0 end),0),  
				Int_sett_cnt = isnull(sum(case when dptd_trastm_cd = '907' then 1 else 0 end),0),  
				EP_cnt = isnull(sum(case when dptd_trastm_cd = '912'  then 1 else 0 end),0),
                do_cnt = isnull(sum(case when dptd_trastm_cd = '906' then 1 else 0 end),0),
                p2p_cnt = isnull(sum(case when dptd_trastm_cd = '934'  then 1 else 0 end),0),
				DMT_cnt = 0 , rmt_cnt = 0 , pldt_cnt = 0
				from dp_trx_dtls with(nolock), dp_acct_mstr with(nolock)  
				where dptd_dpam_id = dpam_id 
and dpam_dpm_id = case when @dpm_id  ='3' then dpam_dpm_id else @dpm_id  end --@dpm_id  
				and dptd_request_dt between  @pa_request_dt and @pa_request_todt
				and isnull(dptd_batch_no,'') = ''   
				and isnull(dptd_brokerbatch_no,'') = ''   
				and dptd_status = 'P' and dptd_deleted_ind = 1 
				UNION
				select AcctTrf_del_cnt = 0,  
				AcctTrf_Rec_cnt = 0,  
				ID_del_cnt = 0,  
				ID_rec_cnt = 0,  
				Int_sett_cnt = 0,  
				EP_cnt = 0,
                do_cnt=0 ,
                p2p_cnt = 0,
				DMT_cnt = count(demrm_id), rmt_cnt = 0 , pldt_cnt = 0  from demat_request_mstr , dp_acct_mstr
				WHERE demrm_request_dt between  @pa_request_dt and @pa_request_todt
				and demrm_dpam_id = dpam_id 
and dpam_dpm_id = case when @dpm_id  ='3' then dpam_dpm_id else @dpm_id  end --@dpm_id
				AND ISNULL(DEMRM_BATCH_NO,'') = '' 
				AND DEMRM_DELETED_IND = 1
and demrm_typeofsec = 'EQUITY'
                UNION
				select AcctTrf_del_cnt = 0,  
				AcctTrf_Rec_cnt = 0,  
				ID_del_cnt = 0,  
				ID_rec_cnt = 0,  
				Int_sett_cnt = 0,  
				EP_cnt = 0,
                do_cnt=0 ,
                p2p_cnt = 0,
				DMT_cnt = 0,
                rmt_cnt = count(Remrm_id), pldt_cnt = 0 from remat_request_mstr ,dp_acct_mstr
				WHERE remrm_request_dt between  @pa_request_dt and @pa_request_todt
				and remrm_dpam_id = dpam_id 
and dpam_dpm_id = case when @dpm_id  ='3' then dpam_dpm_id else @dpm_id  end --@dpm_id
				AND ISNULL(rEMRM_BATCH_NO,'') = '' 
				AND rEMRM_DELETED_IND = 1
                  UNION
				select AcctTrf_del_cnt = 0,  
				AcctTrf_Rec_cnt = 0,  
				ID_del_cnt = 0,  
				ID_rec_cnt = 0,  
				Int_sett_cnt = 0,  
				EP_cnt = 0,
                do_cnt=0 ,
                p2p_cnt = 0,
				DMT_cnt = 0, 
                rmt_cnt = 0 , pldt_cnt = count(pldt_id) --nsdl_pledge_dtls--PLDT_REQUEST_DT--PLDT_BATCH_NO
                from nsdl_pledge_dtls 
				WHERE PLDT_REQUEST_DT between  @pa_request_dt and @pa_request_todt
				AND ISNULL(PLDT_BATCH_NO,'') = '' 
				AND PLDT_deleted_ind = 1
				) TMP
  
			  
			  
			  
			  -- for broking transactions  
				if @pa_tab = 'Y' 
--                
                SELECT AcctTrf_del_cnt = SUM(AcctTrf_del_cnt),  
				AcctTrf_Rec_cnt = SUM(AcctTrf_Rec_cnt),  
				ID_del_cnt = SUM(ID_del_cnt),  
				ID_rec_cnt = SUM(ID_rec_cnt),  
				Int_sett_cnt = SUM(Int_sett_cnt),  
				EP_cnt = SUM(EP_cnt),
               do_cnt=sum( do_cnt) ,
                p2p_cnt = SUM(p2p_cnt),
				DMT_cnt = SUM(DMT_cnt) , rmt_cnt = sum(rmt_cnt) , pldt_cnt = sum(pldt_cnt)
				FROM 
				(
                select AcctTrf_del_cnt = isnull(sum(case when dptd_trastm_cd in( '904','934') then 1 else 0 end),0),  
				AcctTrf_Rec_cnt = isnull(sum(case when dptd_trastm_cd = '905' then 1 else 0 end),0),  
				ID_del_cnt = isnull(sum(case when dptd_trastm_cd = '925' then 1 else 0 end),0),  
				ID_rec_cnt = isnull(sum(case when dptd_trastm_cd = '926' then 1 else 0 end),0),  
				Int_sett_cnt = isnull(sum(case when dptd_trastm_cd = '907' then 1 else 0 end),0),  
				EP_cnt = isnull(sum(case when dptd_trastm_cd = '912'  then 1 else 0 end),0),
                do_cnt = isnull(sum(case when dptd_trastm_cd = '906' then 1 else 0 end),0),
                p2p_cnt = isnull(sum(case when dptd_trastm_cd = '934'  then 1 else 0 end),0),
				DMT_cnt = 0, rmt_cnt = 0 , pldt_cnt = 0
				from dp_trx_dtls with(nolock), dp_acct_mstr with(nolock)  
				where dptd_dpam_id = dpam_id 
and dpam_dpm_id = case when @dpm_id  ='3' then dpam_dpm_id else @dpm_id  end --@dpm_id  
				and dptd_request_dt between  @pa_request_dt and @pa_request_todt
				and isnull(dptd_batch_no,'') = ''   
				and isnull(dptd_brokerbatch_no,'') <> ''   
				and dptd_status = 'P' and dptd_deleted_ind = 1 
				UNION
				select AcctTrf_del_cnt = 0,  
				AcctTrf_Rec_cnt = 0,  
				ID_del_cnt = 0,  
				ID_rec_cnt = 0,  
				Int_sett_cnt = 0,  
				EP_cnt = 0,
                do_cnt=0 ,
                p2p_cnt = 0,
				DMT_cnt = count(demrm_id), rmt_cnt = 0 , pldt_cnt = 0 from demat_request_mstr ,dp_acct_mstr
				WHERE demrm_request_dt between  @pa_request_dt and @pa_request_todt
				and demrm_dpam_id = dpam_id 
and dpam_dpm_id = case when @dpm_id  ='3' then dpam_dpm_id else @dpm_id  end --@dpm_id
				AND ISNULL(DEMRM_BATCH_NO,'') = '' 
				AND DEMRM_DELETED_IND = 1
and demrm_typeofsec = 'EQUITY'
                UNION
				select AcctTrf_del_cnt = 0,  
				AcctTrf_Rec_cnt = 0,  
				ID_del_cnt = 0,  
				ID_rec_cnt = 0,  
				Int_sett_cnt = 0,  
				EP_cnt = 0,
                do_cnt=0 ,
                p2p_cnt = 0,
				DMT_cnt = 0,
                rmt_cnt = count(Remrm_id), pldt_cnt = 0 from remat_request_mstr,dp_acct_mstr 
				WHERE remrm_request_dt between  @pa_request_dt and @pa_request_todt
				and remrm_dpam_id = dpam_id 
and dpam_dpm_id = case when @dpm_id  ='3' then dpam_dpm_id else @dpm_id  end --@dpm_id
				AND ISNULL(rEMRM_BATCH_NO,'') = '' 
				AND rEMRM_DELETED_IND = 1
                  UNION
				select AcctTrf_del_cnt = 0,  
				AcctTrf_Rec_cnt = 0,  
				ID_del_cnt = 0,  
				ID_rec_cnt = 0,  
				Int_sett_cnt = 0,  
				EP_cnt = 0,
                do_cnt=0 ,
                p2p_cnt = 0,
				DMT_cnt = 0, 
                rmt_cnt = 0 , pldt_cnt = count(pldt_id) --nsdl_pledge_dtls--PLDT_REQUEST_DT--PLDT_BATCH_NO
                from nsdl_pledge_dtls 
				WHERE PLDT_REQUEST_DT between  @pa_request_dt and @pa_request_todt
				AND ISNULL(PLDT_BATCH_NO,'') = '' 
				AND PLDT_deleted_ind = 1
				) TMP

--                select AcctTrf_del_cnt ,
--				AcctTrf_Rec_cnt ,
--				ID_del_cnt ,
--				ID_rec_cnt ,
--				Int_sett_cnt,
--				EP_cnt ,
--				DMT_cnt = count(demrm_id) from (
--                select DISTINCT AcctTrf_del_cnt = isnull(sum(case when dptd_trastm_cd = '904' then 1 else 0 end),0),  
--				AcctTrf_Rec_cnt = isnull(sum(case when dptd_trastm_cd = '905' then 1 else 0 end),0),  
--				ID_del_cnt = isnull(sum(case when dptd_trastm_cd = '925' then 1 else 0 end),0),  
--				ID_rec_cnt = isnull(sum(case when dptd_trastm_cd = '926' then 1 else 0 end),0),  
--				Int_sett_cnt = isnull(sum(case when dptd_trastm_cd = '907' then 1 else 0 end),0),  
--				EP_cnt = isnull(sum(case when dptd_trastm_cd = '906' OR dptd_trastm_cd = '912' then 1 else 0 end),0),
--                convert(varchar(11),dptd_request_dt,103) dptd_request_dt
--				from dp_trx_dtls with(nolock), dp_acct_mstr with(nolock)  
--				where dptd_dpam_id = dpam_id and dpam_dpm_id = @dpm_id  
--                AND convert(varchar(11),dptd_request_dt,103) = @pa_request_dt				
--				and isnull(dptd_batch_no,'') = ''   
--				and isnull(dptd_brokerbatch_no,'') <> ''   
--				and dptd_status = 'P' and dptd_deleted_ind = 1 group by convert(varchar(11),dptd_request_dt,103)) a
--                , demat_request_mstr 
--                where (convert(varchar(11),demrm_request_dt,103) = @pa_request_dt or convert(varchar(11),dptd_request_dt,103) = @pa_request_dt )
--                group by AcctTrf_del_cnt ,
--				AcctTrf_Rec_cnt ,
--				ID_del_cnt ,
--				ID_rec_cnt ,
--				Int_sett_cnt,
--				EP_cnt 

               
  --  
  end  
--  
end

GO
