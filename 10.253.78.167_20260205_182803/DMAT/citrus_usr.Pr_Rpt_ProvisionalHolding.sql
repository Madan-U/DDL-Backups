-- Object: PROCEDURE citrus_usr.Pr_Rpt_ProvisionalHolding
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--pr_rpt_provisionalholding 'NSDL',4,'N','Aug 25 2009','10000004','10000004','','Y',1,'','','','','N',''
--pr_rpt_provisionalholding 'cdsl',3,'Y','JUN 30 2008','','','','N',1,'basispoint|*~|','B',''

/*
DECLARE @@TID BIGINT
SELECT @@TID = TRANTM_ID FROM TRANSACTION_TYPE_MSTR WHERE TRANTM_CODE = 'BEN_ACCT_TYPE_NSDL'
INSERT INTO TRANSACTION_SUB_TYPE_MSTR 
SELECT MAX(TRASTM_ID) + 1,2,@@TID,'99','EARMARKED IN BACKOFFICE',GETDATE(),'HO',GETDATE(),'HO',1
FROM TRANSACTION_SUB_TYPE_MSTR
*/

CREATE Proc [citrus_usr].[Pr_Rpt_ProvisionalHolding]
@pa_dptype varchar(4),                  
@pa_excsmid int,                  
@pa_asondate char(1),                  
@pa_fordate datetime,                  
@pa_fromaccid varchar(16),                  
@pa_toaccid varchar(16),                  
@pa_isincd varchar(12),            
@pa_withvalue char(1), --Y/N                  
@pa_login_pr_entm_id numeric,                    
@pa_login_entm_cd_chain  varchar(8000),
@pa_settm_type varchar(100),
@PA_SETTM_NO_FR   VARCHAR(100),
@PA_SETTM_NO_TO   VARCHAR(100),
@pa_setting_mode char(1), -- B for Backoffice entries, N for no backoffice entries                  
@pa_output varchar(8000) output                    
as                        
begin                        

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED                       
declare @@dpmid int,                        
@@tmpholding_dt datetime

  

select @@dpmid = dpm_id from dp_mstr where default_dp = @pa_excsmid and dpm_deleted_ind =1                        
declare @@l_child_entm_id      numeric                    
select @@l_child_entm_id    =  citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)                    
CREATE TABLE #ACLIST(dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150),eff_from DATETIME,eff_to DATETIME)
INSERT INTO #ACLIST SELECT DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO 
FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id)		


                  
                  
if @pa_fromaccid = ''                  
begin                  
	 set @pa_fromaccid = '0'                  
	 set @pa_toaccid = '99999999999999999'                  
end                    
if @pa_toaccid = ''                  
begin                  
	set @pa_toaccid = @pa_fromaccid                  
end   

	if @pa_dptype = 'NSDL'
	begin               
			                      
			create table #tmpprovisonal
			(dpam_id bigint,
			ben_acct_type varchar(3),
			isin_cd varchar(12),
			Qty numeric(18,3),
			sett_type varchar(5),
			sett_no varchar(10),
			blk_lock_flg varchar(5),
			)

			create table #nsdltran                         
			(
			exec_dt datetime,                          
			dpam_id bigint,                          
			Ben_ctgry varchar(2),                    
			Ben_acct_type varchar(2),                         
			isin_cd varchar(12),  
			sett_type varchar(5),    
			sett_no varchar(10),
			blk_lock_flg varchar(5),
			dpm_trans_no varchar(20),            
			Qty numeric(19,3),                          
			Book_Narr_cd varchar(3),                          
			trans_type int,            
			)    

			                      
	                      
	            
	         
			select top 1 @pa_fordate = DPDHM_HOLDING_DT 
			from DP_HLDG_MSTR_NSDL where dpdhm_deleted_ind =1    and DPDHM_DPM_ID = @@dpmid

			set @@tmpholding_dt = dateadd(d,1,@pa_fordate) 

	        
			insert into #tmpprovisonal            
			select dpam_id,DPDHM_BENF_ACCT_TYP,DPDHM_ISIN ISINCD,DPDHM_QTY,DPDHM_SETT_TYPE= case when DPDHM_SETT_TYPE = '00' then '' else DPDHM_SETT_TYPE end ,DPDHM_SETT_NO                  
			,DPDHM_BLK_LOCK_FLG
			from DP_HLDG_MSTR_NSDL WITH(NOLOCK), 
			#ACLIST account 
			where DPDHM_HOLDING_DT = @pa_fordate and DPDHM_DPM_ID = @@dpmid                        
			and DPDHM_dpam_id = account.dpam_id                    
			and (DPDHM_HOLDING_DT between eff_from and eff_to)                  
            AND ISNUMERIC(DPAM_sba_NO)=1
			and (convert(numeric,DPAM_sba_NO) between convert(numeric,@pa_fromaccid) AND  convert(numeric,@pa_toaccid))                        
			and DPDHM_ISIN LIKE @pa_isincd + '%'  

			insert into #nsdltran(exec_dt,dpam_id,ben_ctgry,ben_acct_type,isin_cd,sett_type,sett_no,blk_lock_flg,dpm_trans_no,Qty,Book_Narr_cd,trans_type)                         
			select NSDHM_TRANSACTION_DT,NSDHM_dpam_id,NSDHM_BEN_CTGRY,NSDHM_BEN_ACCT_TYPE,NSDHM_ISIN,nsdhm_sett_type=case when nsdhm_sett_type = '00' then '' else nsdhm_sett_type end,nsdhm_sett_no,nsdhm_block_log_flag,nsdhm_dpm_trans_no,NSDHM_QTY,NSDHM_BOOK_NAAR_CD,0            
			from NSDL_HOLDING_DTLS WITH(NOLOCK),
			#ACLIST account        
			where                       
			NSDHM_TRANSACTION_DT >= @@tmpholding_dt     
			and nsdhm_dpam_id = account.dpam_id                    
			and (nsdhm_transaction_dt between eff_from and eff_to)                  
            AND ISNUMERIC(DPAM_sba_NO)=1
			and (convert(numeric,DPAM_sba_NO) between convert(numeric,@pa_fromaccid) AND  convert(numeric,@pa_toaccid))                        
			and nsdhm_ISIN LIKE @pa_isincd + '%'
			and nsdhm_dpm_id = @@dpmid   


			--for non pool accounts   
			delete from #nsdltran where Ben_acct_type not in('20','30','40') and book_narr_cd in ('031','032','041','043','053','054','055','056','057','061','076','073','074','075','095','098','099','121','123','124','153','156','163','173','183','193','201','203','213','101')                 

			update m set trans_type = 1               
			from #nsdltran m                
			where Ben_acct_type not in('20','30','40') and convert(int,m.book_narr_cd) = isnull((select max(convert(int,book_narr_cd)) from #nsdltran m1 where m.dpm_trans_no = m1.dpm_trans_no and m.isin_cd = m1.isin_cd and m.dpam_id = m1.dpam_id and m.Ben_acct_type = m1.Ben_acct_type),0)             
			--for non pool accounts              

			-- for pool accounts  
			delete from #nsdltran where Ben_acct_type in('20','30','40') and book_narr_cd in ('031','032','041','043','053','054','055','056','057','061','076','073','074','075','095','098','099','121','123','124','153','156','163','173','183','193','201','203','213')  

			update #nsdltran set trans_type = 1 where  Ben_acct_type in('20','30','40') and  sett_type <> '00'  
			-- for pool accounts 


			-- for backoffice entries
			if @pa_setting_mode = 'B'
			begin
				insert into #nsdltran(dpam_id,ben_ctgry,ben_acct_type,isin_cd,sett_type,sett_no,blk_lock_flg,dpm_trans_no,Qty,Book_Narr_cd,trans_type)                         
				select dptd_dpam_id,'99','99',dptd_isin,sett_type='',sett_no='',block_log_flag='',DPTD_TRANS_NO,dptd_qty,'',0            
				from dp_trx_dtls with(nolock),
				#ACLIST account             
				where dptd_execution_dt >= @@tmpholding_dt     
				and dptd_dpam_id = account.dpam_id                    
				and (dptd_request_dt between eff_from and eff_to)                  
                AND ISNUMERIC(DPAM_sba_NO)=1
				and (convert(numeric,DPAM_sba_NO) between convert(numeric,@pa_fromaccid) AND  convert(numeric,@pa_toaccid))                        
				and dptd_ISIN LIKE @pa_isincd + '%'
				and dptd_deleted_ind = 1
				and not exists(select isnull(dpm_trans_no,'XXX') from #nsdltran where exec_dt = dptd_execution_dt and dpam_id = dptd_dpam_id and isin_cd = dptd_isin and dpm_trans_no=DPTD_TRANS_NO )
			end
			-- for backoffice entries



		  insert into #tmpprovisonal
		  select dpam_id,ben_acct_type,isin_cd,sum(Qty),sett_type,sett_no,blk_lock_flg 
		  from #nsdltran
		  group by dpam_id,ben_acct_type,isin_cd,sett_type,sett_no,blk_lock_flg

		  if @pa_withvalue = 'N'
		  begin
				select t.dpam_id,DPAM_SBA_NAME AcctName,DPAM_sba_NO AcctNo,BEN_TYPE=BEN.DESCP + CASE WHEN LTRIM(RTRIM(sett_type)) <> '00' AND ISNULL(LTRIM(RTRIM(sett_type)),'') <> '' THEN ' (' + sett_type + '/' + sett_no + ')' ELSE '' END 
				,t.isin_cd ISINCD,isin_name ,convert(numeric(18,3),QTY) Qty               
				, CASE WHEN blk_lock_flg = 'F' THEN 'FREE' WHEN blk_lock_flg = 'L' THEN 'LOCK' WHEN blk_lock_flg = 'B' THEN 'BLOCK' ELSE '' END LockFlg
				,holding_dt=convert(varchar(11),@@tmpholding_dt,109)
				from 
				(
					select dpam_id,ben_acct_type,isin_cd,sum(QTY) Qty,sett_type,sett_no
					,blk_lock_flg 
					from #tmpprovisonal  
					group by dpam_id,ben_acct_type,isin_cd,sett_type,sett_no,blk_lock_flg  
				) t
				LEFT OUTER JOIN ISIN_MSTR I ON t.isin_cd = I.ISIN_CD,                  
				#ACLIST account,
				citrus_usr.FN_GETSUBTRANSDTLS('BEN_ACCT_TYPE_NSDL') BEN  
				where t.dpam_id = account.dpam_id                    
				and (@@tmpholding_dt between eff_from and eff_to) 
				and Ben_acct_type = BEN.CD
				and t.QTY <> 0
				order by DPAM_sba_NO,ISIN_NAME,t.isin_cd,Ben_acct_type 
		  end
		  else
		  begin
				select t.dpam_id,DPAM_SBA_NAME AcctName,DPAM_sba_NO AcctNo,BEN_TYPE=BEN.DESCP + CASE WHEN LTRIM(RTRIM(sett_type)) <> '00' AND ISNULL(LTRIM(RTRIM(sett_type)),'') <> '' THEN ' (' + sett_type + '/' + sett_no + ')' ELSE '' END 
				,t.isin_cd ISINCD,isin_name ,convert(numeric(18,3),Qty) Qty            
				,CASE WHEN blk_lock_flg = 'F' THEN 'FREE' WHEN blk_lock_flg = 'L' THEN 'LOCK' WHEN blk_lock_flg = 'B' THEN 'BLOCK' ELSE '' END LockFlg
				,Valuation= convert(numeric(18,3),QTY*isnull(clopm_nsdl_rt,0)),holding_dt=convert(varchar(11),@@tmpholding_dt,109),cmp=isnull(clopm_nsdl_rt,0.00)
				from 
				(
					select dpam_id,ben_acct_type,isin_cd,sum(QTY) Qty,sett_type,sett_no
					,blk_lock_flg 
					from #tmpprovisonal  
					group by dpam_id,ben_acct_type,isin_cd,sett_type,sett_no,blk_lock_flg 
				) t 
				LEFT OUTER JOIN ISIN_MSTR I ON t.isin_cd = I.ISIN_CD
				LEFT OUTER JOIN CLOSING_LAST_NSDL on t.isin_cd = CLOPM_ISIN_CD,                  
				#ACLIST account,
				citrus_usr.FN_GETSUBTRANSDTLS('BEN_ACCT_TYPE_NSDL') BEN  
				where t.dpam_id = account.dpam_id                    
				and (@@tmpholding_dt between eff_from and eff_to)     
				and Ben_acct_type = BEN.CD
				and t.QTY <> 0
				order by DPAM_sba_NO,ISIN_NAME,t.isin_cd,Ben_acct_type 
		  end

	          
		  TRUNCATE TABLE #nsdltran
		  DROP TABLE #nsdltran 
		  TRUNCATE TABLE #tmpprovisonal
		  DROP TABLE #tmpprovisonal
    
	end
	else -- CDSL
	begin

			create table #tmpprovisonalcdsl
			(prov_dpam_id bigint,
			prov_isin_cd varchar(12),
			curr_qty numeric(18,3),
			free_qty numeric(18,3),
			freeze_qty numeric(18,3),
			pledge_qty numeric(18,3),
			dmat_pnd_vrf_qty numeric(18,3),
			rmat_pnd_vrf_qty numeric(18,3),
			dmat_pnd_conf_qty numeric(18,3),
			safekeep_qty numeric(18,3),
			lockin_qty numeric(18,3),
			elimnation_qty numeric(18,3),
			earmark_qty numeric(18,3),
			avail_lend_qty numeric(18,3),
			lend_qty numeric(18,3),
			borrow_qty numeric(18,3)
			)

			select top 1 @pa_fordate = max(cdshm_tras_dt)
			from cdsl_holding_dtls where cdshm_DPM_ID = @@dpmid
		  	
			set @@tmpholding_dt = dateadd(d,1,@pa_fordate) 

			insert into #tmpprovisonalcdsl(prov_dpam_id,prov_isin_cd,curr_qty,free_qty,freeze_qty,pledge_qty,dmat_pnd_vrf_qty,rmat_pnd_vrf_qty,dmat_pnd_conf_qty,safekeep_qty,lockin_qty,elimnation_qty,earmark_qty,avail_lend_qty,lend_qty,borrow_qty)
			select DPHMCd_dpam_id,DPHMCd_ISIN,convert(numeric(18,3),DPHMCd_CURR_QTY),convert(numeric(18,3),DPHMCd_FREE_QTY),convert(numeric(18,3),DPHMCd_FREEZE_QTY),convert(numeric(18,3),DPHMCd_PLEDGE_QTY),convert(numeric(18,3),DPHMCd_DEMAT_PND_VER_QTY)    
			,convert(numeric(18,3),DPHMCd_REMAT_PND_CONF_QTY),convert(numeric(18,3),DPHMCd_DEMAT_PND_CONF_QTY),convert(numeric(18,3),DPHMCd_SAFE_KEEPING_QTY),convert(numeric(18,3),DPHMCd_LOCKIN_QTY)      
			,convert(numeric(18,3),DPHMCd_ELIMINATION_QTY) ,convert(numeric(18,3),DPHMCd_EARMARK_QTY),convert(numeric(18,3),DPHMCd_AVAIL_LEND_QTY),convert(numeric(18,3),DPHMCd_LEND_QTY),convert(numeric(18,3),DPHMCd_BORROW_QTY)                       
			from [vw_fetchclientholding] WITH(NOLOCK),                  
			#ACLIST account                              
			where DPHMCd_HOLDING_DT = @pa_fordate and DPHMCd_DPM_ID = @@dpmid                        
			and DPHMCd_dpam_id = account.dpam_id                    
			and (DPHMCd_HOLDING_DT between eff_from and eff_to)     
            and isnumeric(DPAM_sba_NO) = 1              
			AND (convert(numeric,DPAM_sba_NO) between convert(numeric,@pa_fromaccid) AND  convert(numeric,@pa_toaccid))
			AND ISNULL(DPHMCd_CURR_QTY,0) <> 0                         
			AND DPHMCd_ISIN LIKE @pa_isincd + '%'                        


 
			-- for backoffice entries
			if @pa_setting_mode = 'B'
			begin
				insert into #tmpprovisonalcdsl(prov_dpam_id,prov_isin_cd,curr_qty,free_qty,freeze_qty,pledge_qty,dmat_pnd_vrf_qty,rmat_pnd_vrf_qty,dmat_pnd_conf_qty,safekeep_qty,lockin_qty,elimnation_qty,earmark_qty,avail_lend_qty,lend_qty,borrow_qty)                         
				select dptdc_dpam_id,dptdc_isin,curr_qty=sum(dptdc_qty),free_qty=0.000,freeze_qty=0.000,pledge_qty=0.000,dmat_pnd_vrf_qty=0.000,rmat_pnd_vrf_qty=0.000,dmat_pnd_conf_qty=0.000,safekeep_qty=0.000,lockin_qty=0.000,elimnation_qty=0.000,earmark_qty=0.000,avail_lend_qty=0.000,lend_qty=0.000,borrow_qty=0.000
				from dp_trx_dtls_cdsl with(nolock),
				#ACLIST account             
				where dptdc_execution_dt >= @@tmpholding_dt     
				and dptdc_dpam_id = account.dpam_id                    
				and (dptdc_request_dt between eff_from and eff_to)                  
				and (convert(numeric,DPAM_sba_NO) between convert(numeric,@pa_fromaccid) AND  convert(numeric,@pa_toaccid))                        
				and dptdc_ISIN LIKE @pa_isincd + '%'
				and dptdc_deleted_ind = 1
				and not exists(select isnull(CDSHM_TRANS_NO,'XXX') from cdsl_holding_dtls where CDSHM_TRAS_DT = DPTDC_EXECUTION_DT and dpam_id = dptdc_dpam_id and cdshm_isin = dptdc_isin and CDSHM_TRANS_NO=DPTDC_TRANS_NO and cdshm_tras_dt >=@@tmpholding_dt)
				group by dptdc_dpam_id,dptdc_isin
			end
			-- for backoffice entries


		  if @pa_withvalue = 'N'
		  begin
				select DPAM_SBA_NAME,DPAM_sba_NO,prov_isin_cd,isin_name,convert(numeric(18,3),curr_qty) DPHMC_CURR_QTY,convert(numeric(18,3),free_qty) DPHMC_FREE_QTY,convert(numeric(18,3),freeze_qty) DPHMC_FREEZE_QTY,convert(numeric(18,3),pledge_qty) DPHMC_PLEDGE_QTY,convert(numeric(18,3),dmat_pnd_vrf_qty) DPHMC_DEMAT_PND_VER_QTY   
				,convert(numeric(18,3),rmat_pnd_vrf_qty) DPHMC_REMAT_PND_CONF_QTY,convert(numeric(18,3),dmat_pnd_conf_qty) DPHMC_DEMAT_PND_CONF_QTY,convert(numeric(18,3),safekeep_qty) DPHMC_SAFE_KEEPING_QTY,convert(numeric(18,3),lockin_qty) DPHMC_LOCKIN_QTY     
				,convert(numeric(18,3),elimnation_qty) DPHMC_ELIMINATION_QTY,convert(numeric(18,3),earmark_qty) DPHMC_EARMARK_QTY,convert(numeric(18,3),avail_lend_qty) DPHMC_AVAIL_LEND_QTY,convert(numeric(18,3),lend_qty) DPHMC_LEND_QTY,convert(numeric(18,3),borrow_qty) DPHMC_BORROW_QTY,account.dpam_id, holding_dt=convert(varchar(11),@pa_fordate,109) 
				from (
				select prov_dpam_id,prov_isin_cd,curr_qty=sum(curr_qty),free_qty=sum(free_qty),freeze_qty=sum(freeze_qty),pledge_qty=sum(pledge_qty),dmat_pnd_vrf_qty=sum(dmat_pnd_vrf_qty),rmat_pnd_vrf_qty=sum(rmat_pnd_vrf_qty),dmat_pnd_conf_qty=sum(dmat_pnd_conf_qty),safekeep_qty=sum(safekeep_qty),lockin_qty=sum(lockin_qty),elimnation_qty=sum(elimnation_qty),earmark_qty=sum(earmark_qty),avail_lend_qty=sum(avail_lend_qty),lend_qty=sum(lend_qty),borrow_qty=sum(borrow_qty)
				from #tmpprovisonalcdsl 
				group by prov_dpam_id,prov_isin_cd
				) t
				LEFT OUTER JOIN ISIN_MSTR WITH(NOLOCK) ON t.prov_isin_cd = ISIN_CD,                  
				#ACLIST account                              
				where prov_dpam_id = account.dpam_id                    
				and (@pa_fordate between eff_from and eff_to)  
				and t.curr_qty <> 0                
				order by DPAM_sba_NO,ISIN_NAME,prov_isin_cd   
		  end
		  else
		  begin
print @@TMPHOLDING_DT
				select DPAM_SBA_NAME,DPAM_sba_NO,prov_isin_cd,isin_name,convert(numeric(18,3),curr_qty) DPHMC_CURR_QTY,Valuation=convert(numeric(18,3),curr_qty*isnull(clopm_cdsl_rt,0)),convert(numeric(18,3),free_qty) DPHMC_FREE_QTY,convert(numeric(18,3),freeze_qty) DPHMC_FREEZE_QTY,convert(numeric(18,3),pledge_qty) DPHMC_PLEDGE_QTY,convert(numeric(18,3),dmat_pnd_vrf_qty) DPHMC_DEMAT_PND_VER_QTY   
				,convert(numeric(18,3),rmat_pnd_vrf_qty) DPHMC_REMAT_PND_CONF_QTY,convert(numeric(18,3),dmat_pnd_conf_qty) DPHMC_DEMAT_PND_CONF_QTY,convert(numeric(18,3),safekeep_qty) DPHMC_SAFE_KEEPING_QTY,convert(numeric(18,3),lockin_qty) DPHMC_LOCKIN_QTY     
				,convert(numeric(18,3),elimnation_qty) DPHMC_ELIMINATION_QTY,convert(numeric(18,3),earmark_qty) DPHMC_EARMARK_QTY,convert(numeric(18,3),avail_lend_qty) DPHMC_AVAIL_LEND_QTY,convert(numeric(18,3),lend_qty) DPHMC_LEND_QTY,convert(numeric(18,3),borrow_qty) DPHMC_BORROW_QTY,account.dpam_id, holding_dt=convert(varchar(11),@pa_fordate,109),cmp=isnull(clopm_cdsl_rt,0.00) 
				from (
				select prov_dpam_id,prov_isin_cd,curr_qty=sum(curr_qty),free_qty=sum(free_qty),freeze_qty=sum(freeze_qty),pledge_qty=sum(pledge_qty),dmat_pnd_vrf_qty=sum(dmat_pnd_vrf_qty),rmat_pnd_vrf_qty=sum(rmat_pnd_vrf_qty),dmat_pnd_conf_qty=sum(dmat_pnd_conf_qty),safekeep_qty=sum(safekeep_qty),lockin_qty=sum(lockin_qty),elimnation_qty=sum(elimnation_qty),earmark_qty=sum(earmark_qty),avail_lend_qty=sum(avail_lend_qty),lend_qty=sum(lend_qty),borrow_qty=sum(borrow_qty)
				from #tmpprovisonalcdsl 
				group by prov_dpam_id,prov_isin_cd
				) t
				LEFT OUTER JOIN ISIN_MSTR WITH(NOLOCK) ON t.prov_isin_cd = ISIN_CD
				--LEFT OUTER JOIN CLOSING_LAST_CDSL WITH(NOLOCK) ON t.prov_isin_cd = CLOPM_ISIN_CD,
				LEFT OUTER JOIN CLOSING_PRICE_MSTR_CDSL ON t.prov_isin_cd = CLOPM_ISIN_CD AND ISNULL(CLOPM_DT,'01/01/1900') = ( select top 1 CLOPM_DT from CLOSING_PRICE_MSTR_CDSL WHERE CLOPM_ISIN_CD = t.prov_isin_cd and CLOPM_DT <= @@TMPHOLDING_DT and CLOPM_DELETED_IND = 1  order by CLOPM_DT desc),                     
				#ACLIST account                              
				where t.prov_dpam_id = account.dpam_id                    
				and (@pa_fordate between eff_from and eff_to)                  
				and t.curr_qty <> 0
				order by DPAM_sba_NO,ISIN_NAME,prov_isin_cd  
		  end

	          

		  TRUNCATE TABLE #tmpprovisonalcdsl
		  DROP TABLE #tmpprovisonalcdsl

                     

	end     

		  TRUNCATE TABLE #ACLIST
		  DROP TABLE #ACLIST      
                        
END

GO
