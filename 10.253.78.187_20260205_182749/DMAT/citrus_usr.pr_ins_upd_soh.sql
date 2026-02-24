-- Object: PROCEDURE citrus_usr.pr_ins_upd_soh
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

/*TMPSOH_DP_ID      
TMPSOH_TRANX_DT      
TMPSOH_BR_CD      
TMPSOH_BENF_ACCT_NO      
TMPSOH_BENF_CAT      
TMPSOH_ISIN      
TMPSOH_BENF_ACCT_TYP      
TMPSOH_BENF_ACCT_POS      
TMPSOH_CC_ID      
TMPSOH_MKT_TYPE      
TMPSOH_SETM_NO      
TMPSOH_BLK_LOCK_FLG      
TMPSOH_BLK_LOCK_CD      
TMPSOH_LOCK_REL_DT      
TMPSOH_FILLER      
      
      
NSDHM_BR_CODE-->TMPSOH_BR_CD      
NSDHM_DPM_ID-->dpm_id      
NSDHM_BEN_ACCT_NO-->TMPSOH_BENF_ACCT_NO      
NSDHM_DPAM_ID->dpam_id      
NSDHM_TRASTM_CD-->      
NSDHM_REQUEST_DT-->TMPSOH_TRANX_DT      
NSDHM_TRANSACTION_DT-->TMPSOH_TRANX_DT      
NSDHM_ISIN-->TMPSOH_ISIN      
NSDHM_QTY-->TMPSOH_BENF_ACCT_POS      
NSDHM_BOOK_NAAR_CD-->      
NSDHM_BOOK_TYPE      
NSDHM_CC_ID->TMPSOH_CC_ID      
NSDHM_SETT_TYPE-->TMPSOH_MKT_TYPE      
NSDHM_SETT_NO-->TMPSOH_SETM_NO      
NSDHM_BLOCK_LOG_FLAG--TMPSOH_BLK_LOCK_FLG      
NSDHM_BLOCK_LOCK_CD-->TMPSOH_BLK_LOCK_CD      
NSDHM_LOCKIN_REL_DATE-->TMPSOH_LOCK_REL_DT      
NSDHM_COUNTER_DPM_ID      
NSDHM_COUNTER_BO_ID      
NSDHM_COUNTER_CMBP_ID      
NSDHM_OTHER_SETT_TYPE      
NSDHM_OTHER_SETT_NO      
NSDHM_DPM_TRANS_NO      
NSDHM_DM_TRANS_NO      
NSDHM_INT_REF_NO      
NSDHM_REG_RSN1      
NSDHM_REG_RSN2      
NSDHM_REG_RSN3      
NSDHM_REG_RSN4      
NSDHM_BEN_CTGRY-->TMPSOH_BENF_CAT      
NSDHM_BEN_ACCT_TYPE-->TMPSOH_BENF_ACCT_TYP      
NSDHM_CREATED_BY      
NSDHM_CREATED_DT      
NSDHM_LST_UPD_BY      
NSDHM_LST_UPD_DT      
NSDHM_DELETED_IND      
*/      
--HO		47	BULK	C:\BulkInsDbfolder\DPM SOH FILE\31-03-08HOLD.FLT	*|~*	|*~|      
--pr_ins_upd_soh 'HO','IN300175','48','','','*|~*','|*~|',''  
CREATE procedure [citrus_usr].[pr_ins_upd_soh](
 @pa_login_name varchar(25)
,@pa_dpmdpid varchar(50)
,@pa_task_id numeric
,@pa_mode varchar(50)
,@pa_db_source varchar(8000)
,@RowDelimiter varchar(10)
,@ColDelimiter varchar(10)
,@pa_errmsg varchar(20) output
)      
as      
begin      
--      

create table #temp_hold 
(dpam_id numeric(10,0)
,acct_typ varchar(20)
,isin varchar(20)
,HOLDING_DT datetime
,qty numeric(18,3)
,SETT_TYPE varchar(25)
,SETT_NO varchar(25)
,CC_ID varchar(8)
,BLK_LOCK_FLG char(1)
,BLK_LOCK_CD char(2)
,REL_DT     datetime
,cat         varchar(2)
)


       
    set nocount on
    declare @l_dpmdpid varchar(50)      
          , @l_dpm_id  varchar(50)      
          , @l_holdin_dt datetime      
          , @l_max_holding_dt datetime      
          , @l_err_string varchar(8000)  
          , @@SSQL VARCHAR(8000)
		  , @@DP_ID VARCHAR(8)
		  , @@TRX_DT DATETIME
          , @@FILE_DATE datetime
    If @pa_mode='BULK'
    Begin -- bulk
			DELETE FROM TMP_SOH_SOURCE
			SET @@SSQL = 'BULK INSERT TMP_SOH_SOURCE FROM ''' + @pa_db_source +  ''' WITH
							 (
							   FIELDTERMINATOR=''\n'',
							   ROWTERMINATOR = ''\n''  
							 )'
			EXEC(@@SSQL)
			UPDATE TMP_SOH_SOURCE SET VALUE = LTRIM(RTRIM(VALUE))

			TRUNCATE TABLE TMP_SOH_MSTR

			SELECT TOP 1 @@DP_ID =   SUBSTRING(VALUE,3,8),@@TRX_DT = CONVERT(DATETIME,(SUBSTRING(VALUE,15,2) + '/' + SUBSTRING(VALUE,17,2) + '/' + SUBSTRING(VALUE,11,4))) ,  @@FILE_DATE  =  convert(datetime,SUBSTRING(VALUE,11,8),103) FROM TMP_SOH_SOURCE WHERE VALUE LIKE '01%'


			INSERT INTO TMP_SOH_MSTR
			(
			TMPSOH_DP_ID,
			TMPSOH_TRANX_DT,
			TMPSOH_BR_CD,
			TMPSOH_BENF_ACCT_NO,
			TMPSOH_BENF_CAT,
			TMPSOH_ISIN,
			TMPSOH_BENF_ACCT_TYP,
			TMPSOH_BENF_ACCT_POS,
			TMPSOH_CC_ID,
			TMPSOH_MKT_TYPE,
			TMPSOH_SETM_NO,
			TMPSOH_BLK_LOCK_FLG,
			TMPSOH_BLK_LOCK_CD,
			TMPSOH_LOCK_REL_DT,
			TMPSOH_FILLER
			)
			SELECT @@DP_ID
				  ,@@TRX_DT
				  ,SUBSTRING(value,12,6)
				  ,SUBSTRING(value,18,8)
				  ,SUBSTRING(value,26,2)
				  ,SUBSTRING(value,28,12)
				  ,SUBSTRING(value,40,2)
				  ,ABS(SUBSTRING(value,42,15))/1000.000
				  ,SUBSTRING(value,57,8)
				  ,SUBSTRING(value,65,2)
				  ,SUBSTRING(value,67,7)
				  ,SUBSTRING(value,74,1)
				  ,SUBSTRING(value,75,2)
				  ,SUBSTRING(value,77,8)
				  ,SUBSTRING(value,85,14)
			FROM TMP_SOH_SOURCE WHERE VALUE NOT LIKE '01%'

    End   -- bulk

    If @pa_mode='BULK'
    Begin 
    select top 1 @l_dpmdpid = tmpsoh_dp_id , @l_dpm_id  = dpm_id from tmp_soh_mstr , dp_mstr where dpm_dpid = tmpsoh_dp_id and dpm_deleted_ind = 1 and dpm_dpid = @@DP_ID      
    End 
    Else
    Begin
    select top 1 @l_dpmdpid = tmpsoh_dp_id , @l_dpm_id  = dpm_id from tmp_soh_mstr , dp_mstr where dpm_dpid = tmpsoh_dp_id and dpm_deleted_ind = 1 and dpm_dpid = @pa_dpmdpid      
    End
         
    
				if isnull(@l_dpm_id ,'')= ''      
				BEGIN      
				--      
										return

								--      
				END    
    
    
    
    select top 1 @l_holdin_dt = tmpsoh_tranx_dt from tmp_soh_mstr      
      
    select top 1 @l_max_holding_dt = dpdhm_holding_dt from DP_HLDG_MSTR_NSDL      
      
    set @l_max_holding_dt  = isnull(@l_max_holding_dt ,'jan  1 2008')  
    
    
    
    BEGIN TRANSACTION      
          
    IF @l_holdin_dt >= @l_max_holding_dt      
    BEGIN      
    --      
           
       truncate table dp_hldg_mstr_nsdl 
             
       insert into dp_hldg_mstr_nsdl      
       (dpdhm_holding_dt      
       ,dpdhm_qty      
       ,dpdhm_isin      
       ,dpdhm_dpm_id      
       ,dpdhm_dpam_id      
       ,dpdhm_sett_type      
       ,dpdhm_sett_no      
       ,dpdhm_cc_id      
       ,dpdhm_blk_lock_flg      
       ,dpdhm_blk_lock_cd      
       ,dpdhm_rel_dt
       ,dpdhm_benf_acct_typ
       ,dpdhm_benf_cat
       ,dpdhm_created_by      
       ,dpdhm_created_dt      
       ,dpdhm_lst_upd_by      
       ,dpdhm_lst_upd_dt      
       ,dpdhm_deleted_ind       
       )SELECT       
        tmpsoh_tranx_dt      
       ,tmpsoh_benf_acct_pos      
       ,tmpsoh_isin      
       ,@l_dpm_id      
       ,dpam_id      
       ,tmpsoh_mkt_type      
       ,tmpsoh_setm_no      
       ,tmpsoh_cc_id      
       ,tmpsoh_blk_lock_flg      
       ,tmpsoh_blk_lock_cd      
       ,tmpsoh_lock_rel_dt
       ,tmpsoh_benf_acct_typ
       ,tmpsoh_benf_cat      
       ,@pa_login_name      
       ,getdate()      
       ,@pa_login_name      
       ,getdate()      
       ,1      
       FROM  tmp_soh_mstr      
       ,     dp_acct_mstr      
       WHERE dpam_sba_no = tmpsoh_benf_acct_no      
      
      
   --      
   END      
   
   
   				delete from dp_daily_hldg_nsdl where dpdhmd_holding_dt = @l_holdin_dt      
			   
			         
			        
			      
							insert into dp_daily_hldg_nsdl      
							(dpdhmd_holding_dt      
							,dpdhmd_qty      
							,dpdhmd_isin      
							,dpdhmd_dpm_id      
							,dpdhmd_dpam_id      
							,dpdhmd_sett_type      
							,dpdhmd_sett_no      
							,dpdhmd_cc_id      
							,dpdhmd_blk_lock_flg      
							,dpdhmd_blk_lock_cd      
							,dpdhmd_rel_dt
							,dpdhmd_benf_acct_typ
							,dpdhmd_benf_cat      
							,dpdhmd_created_by      
							,dpdhmd_created_dt      
							,dpdhmd_lst_upd_by      
							,dpdhmd_lst_upd_dt      
							,dpdhmd_deleted_ind       
							)SELECT       
								tmpsoh_tranx_dt      
							,tmpsoh_benf_acct_pos      
							,tmpsoh_isin      
							,@l_dpm_id      
							,dpam_id      
							,tmpsoh_mkt_type      
							,tmpsoh_setm_no      
							,tmpsoh_cc_id      
							,tmpsoh_blk_lock_flg      
							,tmpsoh_blk_lock_cd      
							,tmpsoh_lock_rel_dt
							,tmpsoh_benf_acct_typ
							,tmpsoh_benf_cat      
							,@pa_login_name      
							,getdate()      
							,@pa_login_name      
							,getdate()      
							,1      
							FROM  tmp_soh_mstr      
							,     dp_acct_mstr      
							WHERE dpam_sba_no = tmpsoh_benf_acct_no    
							and   tmpsoh_benf_acct_typ in ('20','40','30')
   
							insert into #temp_hold 
										(dpam_id 
										,acct_typ
										,isin
										,HOLDING_DT 
										,qty 
										,SETT_TYPE 
										,SETT_NO 
										,CC_ID 
										,BLK_LOCK_FLG
										,BLK_LOCK_CD 
										,REL_DT 
										,cat
										)
										Select d.dpdhmd_dpam_id
										,d.dpdhmd_benf_acct_typ
										,d.dpdhmd_isin
										,DPDHMD_HOLDING_DT=@l_holdin_dt
										,d.dpdhmd_qty
										,d.DPDHMD_SETT_TYPE
										,d.DPDHMD_SETT_NO
										,d.DPDHMD_CC_ID
										,d.DPDHMD_BLK_LOCK_FLG
										,d.DPDHMD_BLK_LOCK_CD
										,d.DPDHMD_REL_DT     
										,d.DPDHMD_BENF_CAT     
                                         
										from DP_DAILY_HLDG_NSDL d, (    
										Select dpdhmd_dpam_id, DPDHMD_BENF_CAT,dpdhmd_benf_acct_typ, dpdhmd_isin, DPDHMD_HOLDING_DT = max(DPDHMD_HOLDING_DT)    
										,DPDHMD_BLK_LOCK_FLG,DPDHMD_BLK_LOCK_CD,DPDHMD_REL_DT     
                                        From DP_DAILY_HLDG_NSDL    
										Where DPDHMD_HOLDING_DT  < @l_holdin_dt    
										and  Dpdhmd_benf_acct_typ not in('20','30','40')   
										group by dpdhmd_dpam_id, DPDHMD_BENF_CAT,dpdhmd_benf_acct_typ, dpdhmd_isin     
                                        ,DPDHMD_BLK_LOCK_FLG,DPDHMD_BLK_LOCK_CD,DPDHMD_REL_DT     
										) d1     
										Where d.DPDHMD_HOLDING_DT  < @l_holdin_dt        
										and d.DPDHMD_HOLDING_DT = d1.DPDHMD_HOLDING_DT    
										and d1.dpdhmd_dpam_id = d.dpdhmd_dpam_id     
										and d1.DPDHMD_BENF_CAT = d.DPDHMD_BENF_CAT    
										and d1.dpdhmd_benf_acct_typ = d.dpdhmd_benf_acct_typ    
                                        and d1.DPDHMD_BLK_LOCK_FLG =d.DPDHMD_BLK_LOCK_FLG
                                        and d1.DPDHMD_BLK_LOCK_CD  =d.DPDHMD_BLK_LOCK_CD  
                                        and d1.DPDHMD_REL_DT     = d.DPDHMD_REL_DT     
										and d1.dpdhmd_isin = d.dpdhmd_isin      
										and dpdhmd_dpm_id = @l_dpm_id     
			       and d.dpdhmd_benf_acct_typ not  in('20','30','40') 
			       and isnull(d.dpdhmd_qty,0) <> 0
			
			        insert into dp_daily_hldg_nsdl      
										(dpdhmd_holding_dt      
										,dpdhmd_qty      
										,dpdhmd_isin      
										,dpdhmd_dpm_id      
										,dpdhmd_dpam_id      
										,dpdhmd_sett_type      
										,dpdhmd_sett_no      
										,dpdhmd_cc_id      
										,dpdhmd_blk_lock_flg      
										,dpdhmd_blk_lock_cd      
										,dpdhmd_rel_dt
										,dpdhmd_benf_acct_typ
										,dpdhmd_benf_cat      
										,dpdhmd_created_by      
										,dpdhmd_created_dt      
										,dpdhmd_lst_upd_by      
										,dpdhmd_lst_upd_dt      
										,dpdhmd_deleted_ind       
										)SELECT       
											tmpsoh_tranx_dt      
										,tmpsoh_benf_acct_pos      
										,tmpsoh_isin      
										,@l_dpm_id      
										,dpam_id      
										,tmpsoh_mkt_type      
										,tmpsoh_setm_no      
										,tmpsoh_cc_id      
										,tmpsoh_blk_lock_flg      
										,tmpsoh_blk_lock_cd      
										,tmpsoh_lock_rel_dt
										,tmpsoh_benf_acct_typ
										,tmpsoh_benf_cat      
										,@pa_login_name      
										,getdate()      
										,@pa_login_name      
										,getdate()      
										,1      
										FROM  tmp_soh_mstr      
										,     dp_acct_mstr   dpam
										
										WHERE dpam_sba_no = tmpsoh_benf_acct_no    
			       and   tmpsoh_benf_acct_typ not in ('20','40','30')
			       and   not exists (select dpam_id 
										,acct_typ
										,HOLDING_DT 
										,qty 
										,SETT_TYPE 
										,SETT_NO 
										,CC_ID 
										,BLK_LOCK_FLG
										,BLK_LOCK_CD 
										,REL_DT 
										,isin
										from    #temp_hold tmp
										where    tmp.dpam_id = dpam.dpam_id 
										and tmp.acct_typ = tmpsoh_benf_acct_typ
										and tmp.qty = tmpsoh_benf_acct_pos
										and tmp.SETT_TYPE =tmpsoh_mkt_type
										and tmp.SETT_NO =tmpsoh_setm_no
										and tmp.CC_ID =tmpsoh_cc_id
										and tmp.cat         = TMPSOH_BENF_CAT
										and tmp.isin         = TMPSOH_isin
										and tmp.BLK_LOCK_FLG=tmpsoh_blk_lock_flg
										and tmp.BLK_LOCK_CD =tmpsoh_blk_lock_cd
										and tmp.REL_DT=tmpsoh_lock_rel_dt
					
										)
										
										
										
										 insert into dp_daily_hldg_nsdl      
																	(dpdhmd_holding_dt      
																	,dpdhmd_qty      
																	,dpdhmd_isin      
																	,dpdhmd_dpm_id      
																	,dpdhmd_dpam_id      
																	,dpdhmd_sett_type      
																	,dpdhmd_sett_no      
																	,dpdhmd_cc_id      
																	,dpdhmd_blk_lock_flg      
																	,dpdhmd_blk_lock_cd      
																	,dpdhmd_rel_dt
																	,dpdhmd_benf_acct_typ
																	,dpdhmd_benf_cat      
																	,dpdhmd_created_by      
																	,dpdhmd_created_dt      
																	,dpdhmd_lst_upd_by      
																	,dpdhmd_lst_upd_dt      
																	,dpdhmd_deleted_ind       
																	)SELECT HOLDING_DT            
																		, 0
																		, isin
																		, @l_dpm_id
																		, dpam_id 																		
																		, SETT_TYPE 
																		, SETT_NO 
																		, CC_ID
																		, BLK_LOCK_FLG
																		, BLK_LOCK_CD
																		, REL_DT
										        , acct_typ
										        , cat
										        , @pa_login_name
										        , getdate()
										        , @pa_login_name
										        , getdate()
										        , 1
			       							FROM  #temp_hold   tmp   
																	WHERE acct_typ not in ('20','40','30')
										       and   not exists (select dpam_id 
																	,TMPSOH_BENF_ACCT_TYP
																	,TMPSOH_TRANX_DT 
																	,TMPSOH_BENF_ACCT_POS 
																	,TMPSOH_MKT_TYPE 
																	,TMPSOH_SETM_NO 
																	,tmpsoh_CC_ID 
																	,tmpsoh_BLK_LOCK_FLG
																	,tmpsoh_BLK_LOCK_CD 
																	,TMPSOH_isin
																	,TMPSOH_LOCK_REL_DT from    tmp_soh_mstr      
										       ,     dp_acct_mstr   dpam
																	where  dpam_sba_no = tmpsoh_benf_acct_no  
																	and  tmp.dpam_id = dpam.dpam_id 
																	and tmp.acct_typ = tmpsoh_benf_acct_typ
																	and tmp.SETT_TYPE =tmpsoh_mkt_type
																	and tmp.SETT_NO =tmpsoh_setm_no
																	and tmp.CC_ID =tmpsoh_cc_id
																	and tmp.BLK_LOCK_FLG=tmpsoh_blk_lock_flg
																	and tmp.cat         = TMPSOH_BENF_CAT
																	and tmp.isin         = TMPSOH_isin
																	and tmp.BLK_LOCK_CD =tmpsoh_blk_lock_cd
																	and tmp.REL_DT=tmpsoh_lock_rel_dt
										)
		
										
										
										 select @l_err_string  = citrus_usr.fn_merge_str('SOH',0,'')    
										               
						IF isnull(@l_err_string,'') <> ''    
						BEGIN    
						--    
								UPDATE filetask    
								SET    usermsg = 'ERROR : Following Client Not Mapped ' + @l_err_string    
								WHERE  task_id = @pa_task_id    
						--    
						END    
        update filetask set TASK_FILEDATE = @@file_date   WHERE  task_id = @pa_task_id       

	    COMMIT TRANSACTION  
       
--      
end

GO
