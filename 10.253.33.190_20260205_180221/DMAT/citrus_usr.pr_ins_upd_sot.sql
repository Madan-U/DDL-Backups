-- Object: PROCEDURE citrus_usr.pr_ins_upd_sot
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--alter table tmp_sot_mstr alter column TMPSOT_DPM_TRX_REFNO varchar(1000)
--alter table tmp_sot_mstr alter column TMPSOT_DM_TRX_REFNO varchar(1000)
--pr_ins_upd_sot 'HO','IN300175','49','BULK','C:\SOT1603200901','*|~*','|*~|',''          
  
 CREATE procedure [citrus_usr].[pr_ins_upd_sot](@pa_login_name varchar(25)            
                               ,@pa_dpmdpid    varchar(25)            
                               ,@pa_task_id    numeric(10)  
							   ,@pa_mode varchar(50)  
							   ,@pa_db_source varchar(8000)  
							   ,@RowDelimiter varchar(10)  
							   ,@ColDelimiter varchar(10)  
							   ,@pa_errmsg varchar(20) output            
                                )            
 as            
 begin           
        
 --            
   --logic select * from nsdl_holding_dtls where date is current date(in file)            
   --insert into nsdl_holding_dtls_daily table             
   --update data into nsdl_holding_dtls_daily             
   --effect into main table             
  
   --structure of temp table             
  
   /*            
   TMPSOT_RECTYP -->            
   TMPSOT_LNNO-->            
   TMPSOT_BR_CD-->  NSDHM_BR_CODE            
   TMPSOT_BEN_ACCTNO-->NSDHM_BEN_ACCT_NO            
   TMPSOT_BEN_CTRY-->NSDHM_BEN_CTGRY            
   TMPSOT_BOOKING_DT-->NSDHM_TRANSACTION_DT            
   TMPSOT_ISIN-->NSDHM_ISIN            
   TMPSOT_BEN_ACCTTYP-->NSDHM_BEN_ACCT_TYPE            
   TMPSOT_DEBIT_CREDIT_IND-->C/D            
   TMPSOT_POS_BOOKED-->NSDHM_QTY            
   TMPSOT_BOOKING_NARR_CD-->NSDHM_BOOK_NAAR_CD            
   TMPSOT_BOOKING_TYP-->NSDHM_BOOK_TYPE            
   TMPSOT_CC_ID-->NSDHM_CC_ID            
   TMPSOT_MKT_TYP-->NSDHM_SETT_TYPE            
   TMPSOT_SETTNO-->NSDHM_SETT_NO            
   TMPSOT_BLOCK_LOCK_FLG-->NSDHM_BLOCK_LOG_FLAG            
   TMPSOT_BLOCK_LOCK_CD-->NSDHM_BLOCK_LOCK_CD            
   TMPSOT_LOCKIN_RELEASE_DATE-->NSDHM_LOCKIN_REL_DATE            
   TMPSOT_CTR_DPID_OTHERDPID-->NSDHM_COUNTER_DPM_ID            
   TMPSOT_CTR_BENID-->NSDHM_COUNTER_BO_ID            
   TMPSOT_DPM_TRX_REFNO-->NSDHM_DPM_TRANS_NO            
   TMPSOT_DM_TRX_REFNO-->NSDHM_DM_TRANS_NO            
   TMPSOT_INT_REFNO_RMKS-->NSDHM_INT_REF_NO            
   TMPSOT_TRX_CREATION_DTTIME-->NSDHM_REQUEST_DT            
   TMPSOT_CTR_CMBPID-->NSDHM_COUNTER_CMBP_ID            
   TMPSOT_REJ_REASON1-->NSDHM_REG_RSN1            
   TMPSOT_REJ_REASON2-->NSDHM_REG_RSN2            
   TMPSOT_REJ_REASON3-->NSDHM_REG_RSN3            
   TMPSOT_REJ_REASON4-->NSDHM_REG_RSN4            
   TMPSOT_OTHER_CLT_CD-->            
   TMPSOT_OTHER_SETT_DTLS-->NSDHM_OTHER_SETT_NO            
   TMPSOT_FILLER-->            
   */            
  
   /*            
   NSDHM_BR_CODE            
   NSDHM_DPM_ID            
   NSDHM_BEN_ACCT_NO            
   NSDHM_DPAM_ID            
   NSDHM_TRASTM_CD            
   NSDHM_REQUEST_DT            
   NSDHM_TRANSACTION_DT            
   NSDHM_ISIN            
   NSDHM_QTY            
   NSDHM_BOOK_NAAR_CD            
   NSDHM_BOOK_TYPE            
   NSDHM_CC_ID            
   NSDHM_SETT_TYPE            
   NSDHM_SETT_NO            
   NSDHM_BLOCK_LOG_FLAG            
   NSDHM_BLOCK_LOCK_CD            
   NSDHM_LOCKIN_REL_DATE            
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
   NSDHM_BEN_CTGRY            
   NSDHM_BEN_ACCT_TYPE            
   NSDHM_CREATED_BY            
   NSDHM_CREATED_DT            
   NSDHM_LST_UPD_BY            
   NSDHM_LST_UPD_DT            
   NSDHM_DELETED_IND            
   */            
  
     declare @l_dpmdpid varchar(50)            
           , @l_dpm_id  varchar(50)            
           , @@SSQL VARCHAR(8000)  
     , @@DP_ID VARCHAR(8)  
     , @@TRX_DT DATETIME   
                    , @@FILE_DATE datetime  
  
   If @pa_mode='BULK'  
     Begin -- bulk  
    DELETE FROM TMP_SOT_SOURCE  
    SET @@SSQL = 'BULK INSERT TMP_SOT_SOURCE FROM ''' + @pa_db_source +  ''' WITH  
         (  
           FIELDTERMINATOR=''\n'',  
           ROWTERMINATOR = ''\n''    
         )'  
    EXEC(@@SSQL)  
    UPDATE TMP_SOT_SOURCE SET VALUE = LTRIM(RTRIM(VALUE))  
  
    TRUNCATE TABLE TMP_SOT_MSTR  
  
    SELECT TOP 1 @@DP_ID =   SUBSTRING(VALUE,3,8) ,@@file_date = convert(datetime,SUBSTRING(VALUE,27,8),103)  
                FROM TMP_SOT_SOURCE WHERE VALUE LIKE '01%'  
  
    INSERT INTO TMP_SOT_MSTR  
     (  
      TMPSOT_RECTYP,  
      TMPSOT_LNNO,  
      TMPSOT_BR_CD,  
      TMPSOT_BEN_ACCTNO,  
      TMPSOT_BEN_CTRY,  
      TMPSOT_BOOKING_DT,  
      TMPSOT_ISIN,  
      TMPSOT_BEN_ACCTTYP,  
      TMPSOT_DEBIT_CREDIT_IND,  
      TMPSOT_POS_BOOKED,  
      TMPSOT_BOOKING_NARR_CD,  
      TMPSOT_BOOKING_TYP,  
      TMPSOT_CC_ID,  
      TMPSOT_MKT_TYP,  
      TMPSOT_SETTNO,  
      TMPSOT_BLOCK_LOCK_FLG,  
      TMPSOT_BLOCK_LOCK_CD,  
      TMPSOT_LOCKIN_RELEASE_DATE,  
      TMPSOT_CTR_DPID_OTHERDPID,  
      TMPSOT_CTR_BENID,  
      TMPSOT_DPM_TRX_REFNO,  
      TMPSOT_DM_TRX_REFNO,  
      TMPSOT_INT_REFNO_RMKS,  
      TMPSOT_TRX_CREATION_DTTIME,  
      TMPSOT_CTR_CMBPID,  
      TMPSOT_REJ_REASON1,  
      TMPSOT_REJ_REASON2,  
      TMPSOT_REJ_REASON3,  
      TMPSOT_REJ_REASON4,  
      TMPSOT_OTHER_CLT_CD,  
      TMPSOT_OTHER_SETT_DTLS,  
      TMPSOT_FILLER,  
      TMPSOT_DPID  
     )  
     SELECT        
         SUBSTRING(value,1,2)  
        ,SUBSTRING(value,3,9)  
        ,SUBSTRING(value,12,6)  
        ,SUBSTRING(value,18,8)  
        ,SUBSTRING(value,26,2)  
        ,CONVERT(DATETIME,(SUBSTRING(VALUE,32,2) + '/' + SUBSTRING(VALUE,34,2) + '/' + SUBSTRING(VALUE,28,4)))--SUBSTRING(value,28,8)  
        ,SUBSTRING(value,36,12)  
        ,SUBSTRING(value,48,2)  
        ,SUBSTRING(value,50,1)  
        ,ABS(SUBSTRING(value,51,15))/1000.000  
        ,SUBSTRING(value,66,3)  
        ,SUBSTRING(value,69,2)  
        ,SUBSTRING(value,71,8)  
        ,SUBSTRING(value,79,2)  
        ,SUBSTRING(value,81,7)  
        ,SUBSTRING(value,88,1)  
        ,SUBSTRING(value,89,2)  
        ,SUBSTRING(VALUE,91,8)--CONVERT(DATETIME,(SUBSTRING(VALUE,95,2) + '/' + SUBSTRING(VALUE,97,2) + '/' + SUBSTRING(VALUE,91,4)))--SUBSTRING(value,91,8)  
        ,SUBSTRING(value,99,8)  
        ,SUBSTRING(value,107,8)  
        ,CONVERT(NUMERIC,SUBSTRING(value,115,9))
        ,CONVERT(NUMERIC,SUBSTRING(value,124,9))
        ,SUBSTRING(value,133,9)  
        ,CONVERT(DATETIME,(SUBSTRING(VALUE,157,2) + '/' + SUBSTRING(VALUE,159,2) + '/' + SUBSTRING(VALUE,153,4)) +' '+ SUBSTRING(value,161,2) + ':' +  SUBSTRING(value,163,2) + ':' +  SUBSTRING(value,165,2))  
        ,SUBSTRING(value,167,8)  
        ,SUBSTRING(value,175,4)  
        ,SUBSTRING(value,179,4)  
        ,SUBSTRING(value,183,4)  
        ,SUBSTRING(value,187,4)  
        ,SUBSTRING(value,191,16)       
        ,SUBSTRING(value,207,13)  
        ,SUBSTRING(value,220,9)  
        ,@@DP_ID   
     FROM TMP_SOT_SOURCE WHERE VALUE NOT LIKE '01%'  
  
   End   -- bulk  
  
     If @pa_mode='BULK'  
     Begin   
     select top 1 @l_dpmdpid = tmpsot_dpid , @l_dpm_id  = dpm_id from tmp_sot_mstr , dp_mstr where dpm_dpid = tmpsot_dpid and dpm_deleted_ind = 1 and dpm_dpid = @@DP_ID            
     End  
     Else  
     Begin  
     select top 1 @l_dpmdpid = tmpsot_dpid , @l_dpm_id  = dpm_id from tmp_sot_mstr , dp_mstr where dpm_dpid = tmpsot_dpid and dpm_deleted_ind = 1 and dpm_dpid = @pa_dpmdpid            
     End            


     if isnull(@l_dpmdpid,'') <> '' and isnull(@l_dpm_id ,'') <> ''            
     BEGIN            
     --            
       BEGIN TRANSACTION            
  

        update  tmp_sot_mstr              
        set     tmpsot_trastm_cd       = case when TMPSOT_BOOKING_NARR_CD = '082' then '922' when TMPSOT_BOOKING_NARR_CD = '083' then '921' else '' end  
        where   TMPSOT_BOOKING_NARR_CD in('082','083')  
  
  
        update sot   
        set tmpsot_trn_descp = CASE WHEN credit_debit_ind = 'C' THEN 'By ' ELSE 'To ' end + CA_Desc   
        from nsdl_corp_action,tmp_sot_mstr sot  
        where DM_Order_No = TMPSOT_DPM_TRX_REFNO  
        AND ISIN = TMPSOT_ISIN AND TMPSOT_BOOKING_NARR_CD in('082','083')     
    

        update sot   
        set tmpsot_trn_descp = case when tmpsot_debit_credit_ind = 'C'  then 'By ' else 'To ' end + ACA_DESC   
        from tmp_sot_mstr sot , ACC_CORP_ACTION_EX   
        where ltrim(rtrim(isnull(tmpsot_trn_descp,''))) = ''  
		and DM_ORD_NO = TMPSOT_DPM_TRX_REFNO
		and convert(varchar(11),TMPSOT_BOOKING_DT,103) = convert(varchar(11),ACA_EXE_DT,103)   
        and (TMPSOT_ISIN = CR_ISIN or TMPSOT_ISIN =DB_ISIN)  
		and TMPSOT_BOOKING_NARR_CD in('082','083')

   
        update   tmp_sot_mstr              
        set      tmpsot_trn_descp  = case when tmpsot_debit_credit_ind = 'C'  then 'By ' else 'To ' end + isnull(CODD_INT_REF_NOS,'')   
        from     cod_dtls            
        where  ltrim(rtrim(isnull(tmpsot_trn_descp,''))) = ''    
        and    codd_trx_no            =  convert(varchar(20),TMPSOT_DPM_TRX_REFNO)                    
        and    codd_isin              = TMPSOT_ISIN          
        --and    convert(varchar(11),codd_status_chng_dttime,103) = convert(varchar(11),TMPSOT_BOOKING_DT,103)                           
        and convert(varchar(11),CODD_EXEC_CLOSURE_DT,103)=convert(varchar(11),TMPSOT_BOOKING_DT,103)
        and    CODD_TRX_TYP in ('922','921')        
        and    codd_lst_r= 1        
  
  
        update t      
        set tmpsot_trn_descp = case when t.tmpsot_debit_credit_ind = 'C'  then 'By ' else 'To ' end       
        + lower(  
         case when LTRIM(RTRIM(isnull(tmpsot_Ctr_CMBPID,''))) = '' then   
         case when ltrim(rtrim(tmpsot_other_clt_cd)) <> '' AND len(ltrim(rtrim(tmpsot_other_clt_cd))) = 16 then  
            'Inter Depository transfer CDSL/' + ltrim(rtrim(tmpsot_other_clt_cd))   
              when LTRIM(RTRIM(TMPSOT_CTR_DPID_OTHERDPID)) <> '' THEN  
           LTRIM(RTRIM(ISNULL(DPM_NAME,''))) + '/' + LTRIM(RTRIM(ISNULL(TMPSOT_CTR_BENID,'')))  
              when LTRIM(RTRIM(ISNULL(CCM_NAME,''))) <> '' THEN  
           LTRIM(RTRIM(CCM_NAME)) + ' - CC'  
              else   
          NARR.DESCP   
              end  
  
        ELSE  'CM - ' + LTRIM(RTRIM(ISNULL(ENTM_NAME1,tmpsot_Ctr_CMBPID))) END       
        + case when isnull(settm_desc,'') <> '' and TMPSOT_BEN_ACCTTYP not in ('20','30','40')  then ', ' + isnull(settm_desc,'') +'/' + isnull(tmpsot_settno,'') else '' end    
        )    
        from       
        settlement_type_mstr right outer join      
        tmp_sot_mstr t on settm_type = t.tmpsot_mkt_typ and settm_type <> '' and SETTM_EXCM_ID  in( '3','4')      
        left outer join entity_mstr on t.tmpsot_Ctr_CMBPID = entm_short_name   
        LEFT OUTER JOIN DP_MSTR ON TMPSOT_CTR_DPID_OTHERDPID =  DPM_DPID AND  ISNULL(TMPSOT_CTR_DPID_OTHERDPID,'') <> ''  
        left outer join cc_mstr on TMPSOT_CC_ID = CCM_CD AND LTRIM(RTRIM(ISNULL(TMPSOT_CC_ID,''))) <> ''  
        ,citrus_usr.FN_GETSUBTRANSDTLS('NARR_CODE') NARR      
        where ltrim(rtrim(isnull(tmpsot_trn_descp,''))) = '' and abs(tmpsot_Booking_Narr_cd) = abs(NARR.CD)  


       update   tmp_sot_mstr              
       set      TMPSOT_trastm_cd  = dptd_trastm_cd          
              , TMPSOT_SLIP_NO          = dptd_slip_no            
       from    dp_trx_dtls            
       where   dptd_trans_no          = convert(varchar(20),TMPSOT_DPM_TRX_REFNO)                      
       and     dptd_dpam_id            =tmpsot_dpam_id            
       and     dptd_isin              = TMPSOT_ISIN            
       and     dptd_execution_dt      = TMPSOT_BOOKING_DT                            
       and     dptd_deleted_ind = 1      
  
  
        update   tmp_sot_mstr      
        set      TMPSOT_trastm_cd          = codd_trx_typ  
        from     cod_dtls,dp_acct_mstr    
        where    CODD_CLT_ID     = dpam_sba_no  
        and    dpam_id = tmpsot_dpam_id  
        and    codd_trx_no              = convert(varchar(20),TMPSOT_DPM_TRX_REFNO)           
        and      codd_isin                = TMPSOT_ISIN  
        and      convert(varchar,codd_status_chng_dttime,103) = convert(varchar,TMPSOT_BOOKING_DT,103)                   
        and      isnull(TMPSOT_trastm_cd,'') = ''     
        and      codd_lst_r= 1    


       update tmp_sot_mstr   
       set  tmpsot_dpam_id  = dpam_id ,   
       tmpsot_dpm_id  = @l_dpm_id,  
       tmpsot_pos_booked = case when ltrim(rtrim(tmpsot_debit_credit_ind)) = 'D' then  isnull(tmpsot_pos_booked,0) * -1  else Abs(tmpsot_pos_booked) end  
       from dp_acct_mstr where dpam_sba_no = tmpsot_ben_acctno    
  
  
  



-- added for adding settlement details in narration of inersettlement transactions
 

		update   t1              
		set      t1.tmpsot_trn_descp  = ltrim(rtrim(t1.tmpsot_trn_descp)) + '/' + 
			CASE WHEN LEFT(ltrim(rtrim(t2.TMPSOT_SETTNO)),1) = '0'  THEN --BSE
					CASE WHEN ltrim(rtrim(isnull(t2.TMPSOT_MKT_TYP,''))) = '05' THEN 'ROLLING NORMAL'
						 WHEN ltrim(rtrim(isnull(t2.TMPSOT_MKT_TYP,''))) = '04' THEN 'ROLLING AUCTION'	
						 WHEN ltrim(rtrim(isnull(t2.TMPSOT_MKT_TYP,''))) = '16' THEN 'ROLLING NORMAL'
						 ELSE ltrim(rtrim(isnull(t2.TMPSOT_MKT_TYP,''))) 
					END
				ELSE -- NSE
					CASE WHEN ltrim(rtrim(isnull(t2.TMPSOT_MKT_TYP,''))) = '13' THEN 'NORMAL'
						 WHEN ltrim(rtrim(isnull(t2.TMPSOT_MKT_TYP,''))) = '14' THEN 'AUCTION'	
						 WHEN ltrim(rtrim(isnull(t2.TMPSOT_MKT_TYP,''))) = '22' THEN 'TRADE TO TRADE'
						 WHEN ltrim(rtrim(isnull(t2.TMPSOT_MKT_TYP,''))) = '16' THEN 'TRADE TO TRADE AUCTION'
						 ELSE ltrim(rtrim(isnull(t2.TMPSOT_MKT_TYP,''))) 
					END
				END
					+ ' ' + ltrim(rtrim(isnull(t2.TMPSOT_SETTNO,'')))
		from     tmp_sot_mstr t1, tmp_sot_mstr t2           
		where  ltrim(rtrim(isnull(t1.tmpsot_trn_descp,''))) <> ''   
		and	   t1.tmpsot_dpam_id = t2.tmpsot_dpam_id
		and    LTRIM(RTRIM(t1.TMPSOT_DPM_TRX_REFNO)) =  LTRIM(RTRIM(t2.TMPSOT_DPM_TRX_REFNO))                    
		and    LTRIM(RTRIM(t1.TMPSOT_ISIN))   = LTRIM(RTRIM(t2.TMPSOT_ISIN))          
		and    convert(varchar(11),t1.TMPSOT_BOOKING_DT,103) = convert(varchar(11),t2.TMPSOT_BOOKING_DT,103)  
		and	   Abs(t1.TMPSOT_POS_BOOKED) = Abs(t2.TMPSOT_POS_BOOKED)
		and    LTRIM(RTRIM(t1.TMPSOT_BEN_ACCTTYP)) = LTRIM(RTRIM(t2.TMPSOT_BEN_ACCTTYP))
		and    t1.TMPSOT_BOOKING_NARR_CD <> t2.TMPSOT_BOOKING_NARR_CD
		and    LTRIM(RTRIM(t1.TMPSOT_BOOKING_NARR_CD)) in('071','072')
		and    LTRIM(RTRIM(t2.TMPSOT_BOOKING_NARR_CD)) in('071','072')
		and    LTRIM(RTRIM(t1.TMPSOT_BEN_ACCTTYP)) = '20'    
  
-- added for adding settlement details in narration of inersettlement transactions


/*  
        update sot   
        set tmpsot_trn_descp = ACA_DESC   
        from tmp_sot_mstr sot , ACC_CORP_ACTION_EX   
        where TMPSOT_BOOKING_DT = ACA_EXE_DT   
        and (TMPSOT_ISIN = CR_ISIN or TMPSOT_ISIN =DB_ISIN)  
*/  
  
  /*update t    
  set tmpsot_trn_descp = case when t.tmpsot_debit_credit_ind = 'C'  then 'By ' else 'To ' end     
     + case when isnull(tmpsot_Ctr_CMBPID,'') = '' then NARR.DESCP + case when ltrim(rtrim(tmpsot_other_clt_cd)) <> '' then '/' + ltrim(rtrim(tmpsot_other_clt_cd)) else '' end    
     ELSE  ISNULL(ENTM_NAME1,'CM - ' + tmpsot_Ctr_CMBPID) END     
     + case when isnull(settm_desc,'') <> '' and TMPSOT_BEN_ACCTTYP not in ('20','30','40')  then ', ' + isnull(settm_desc,'') +'/' + isnull(tmpsot_settno,'') else '' end    
  from     
  settlement_type_mstr right outer join    
  tmp_sot_mstr t on settm_type = t.tmpsot_mkt_typ and settm_type <> '' and SETTM_EXCM_ID  in( '3','4')    
  left outer join entity_mstr on t.tmpsot_Ctr_CMBPID = entm_short_name    
  ,citrus_usr.FN_GETSUBTRANSDTLS('NARR_CODE') NARR    
  where abs(tmpsot_Booking_Narr_cd) = abs(NARR.CD)  */  
  
  truncate table tmp_nsdl_holding_dtls          
  
       INSERT INTO  tmp_nsdl_holding_dtls            
       (nsdhmd_br_code            
       ,nsdhmd_dpm_id            
       ,nsdhmd_ben_acct_no            
       ,nsdhmd_dpam_id            
       ,nsdhmd_trastm_cd            
       ,nsdhmd_request_dt            
       ,nsdhmd_transaction_dt     
       ,nsdhmd_isin            
       ,nsdhmd_qty            
       ,nsdhmd_book_naar_cd            
       ,nsdhmd_book_type            
       ,nsdhmd_cc_id            
       ,nsdhmd_sett_type            
       ,nsdhmd_block_log_flag            
       ,nsdhmd_block_lock_cd            
       ,nsdhmd_lockin_rel_date            
       ,nsdhmd_counter_dpm_id            
       ,nsdhmd_counter_bo_id            
       ,nsdhmd_counter_cmbp_id            
       ,nsdhmd_other_sett_type            
       ,nsdhmd_other_sett_no            
       ,nsdhmd_dpm_trans_no            
       ,nsdhmd_dm_trans_no            
       ,nsdhmd_int_ref_no            
       ,nsdhmd_reg_rsn1            
       ,nsdhmd_reg_rsn2            
       ,nsdhmd_reg_rsn3            
       ,nsdhmd_reg_rsn4            
       ,nsdhmd_ben_ctgry            
       ,nsdhmd_ben_acct_type            
       ,nsdhmd_created_by            
       ,nsdhmd_created_dt            
       ,nsdhmd_lst_upd_by            
       ,nsdhmd_lst_upd_dt            
       ,nsdhmd_deleted_ind            
       ,nsdhmd_slip_no            
       ,nsdhmd_sett_no            
       ,nsdhmd_ln_no    
       ,nsdhmd_trn_descp          
       )            
       SELECT nsdhm_br_code            
             ,nsdhm_dpm_id            
             ,nsdhm_ben_acct_no            
             ,nsdhm_dpam_id            
             ,nsdhm_trastm_cd            
             ,nsdhm_request_dt            
             ,nsdhm_transaction_dt            
             ,nsdhm_isin            
             ,nsdhm_qty            
             ,nsdhm_book_naar_cd            
             ,nsdhm_book_type            
             ,nsdhm_cc_id            
             ,nsdhm_sett_type            
             ,nsdhm_block_log_flag            
             ,nsdhm_block_lock_cd            
             ,nsdhm_lockin_rel_date            
             ,nsdhm_counter_dpm_id            
             ,nsdhm_counter_bo_id            
             ,nsdhm_counter_cmbp_id            
             ,nsdhm_other_sett_type            
             ,nsdhm_other_sett_no            
             ,nsdhm_dpm_trans_no            
             ,nsdhm_dm_trans_no            
             ,nsdhm_int_ref_no            
             ,nsdhm_reg_rsn1            
             ,nsdhm_reg_rsn2            
             ,nsdhm_reg_rsn3            
             ,nsdhm_reg_rsn4            
             ,nsdhm_ben_ctgry            
             ,nsdhm_ben_acct_type            
             ,nsdhm_created_by            
             ,nsdhm_created_dt            
             ,nsdhm_lst_upd_by            
             ,nsdhm_lst_upd_dt            
             ,nsdhm_deleted_ind            
             ,nsdhm_slip_no            
             ,nsdhm_sett_no            
             ,nsdhm_ln_no    
             ,nsdhm_trn_descp              
       FROM   nsdl_holding_dtls            
       WHERE nsdhm_transaction_dt         in  (select tmpsot_booking_dt  from tmp_sot_mstr )             
       AND    nsdhm_dpm_id               = @l_dpm_id             
  
      
     
  
        
  
  
  
       insert into nsdl_holding_dtls            
       (nsdhm_br_code            
       ,nsdhm_dpm_id            
       ,nsdhm_ben_acct_no            
       ,nsdhm_dpam_id            
       ,nsdhm_trastm_cd            
       ,nsdhm_request_dt            
       ,nsdhm_transaction_dt            
       ,nsdhm_isin            
       ,nsdhm_qty            
       ,nsdhm_book_naar_cd            
       ,nsdhm_book_type            
       ,nsdhm_cc_id            
       ,nsdhm_sett_type            
       ,nsdhm_sett_no            
       ,nsdhm_block_log_flag            
       ,nsdhm_block_lock_cd            
       ,nsdhm_lockin_rel_date            
       ,nsdhm_counter_dpm_id            
       ,nsdhm_counter_bo_id            
       ,nsdhm_counter_cmbp_id            
       ,nsdhm_other_sett_type            
       ,nsdhm_other_sett_no            
       ,nsdhm_dpm_trans_no            
       ,nsdhm_dm_trans_no            
       ,nsdhm_int_ref_no            
       ,nsdhm_reg_rsn1            
       ,nsdhm_reg_rsn2            
       ,nsdhm_reg_rsn3            
       ,nsdhm_reg_rsn4            
       ,nsdhm_ben_ctgry            
       ,nsdhm_ben_acct_type            
       ,nsdhm_created_by            
       ,nsdhm_created_dt            
       ,nsdhm_lst_upd_by            
       ,nsdhm_lst_upd_dt            
       ,nsdhm_deleted_ind            
       ,nsdhm_ln_no          
       ,nsdhm_trn_descp  
       ,NSDHM_SLIP_NO  
       )SELECT             
        tmpsot_br_cd            
       ,tmpsot_dpm_id            
       ,tmpsot_ben_acctno-->nsdhm_ben_acct_no            
       ,tmpsot_dpam_id            
       ,isnull(tmpsot_trastm_cd,'')           
       ,tmpsot_trx_creation_dttime-->nsdhm_request_dt            
       ,tmpsot_booking_dt-->nsdhm_transaction_dt            
       ,tmpsot_isin-->nsdhm_isin            
       ,tmpsot_pos_booked-->nsdhm_qty            
       ,tmpsot_booking_narr_cd-->nsdhm_book_naar_cd            
       ,tmpsot_booking_typ-->nsdhm_book_type              
       ,tmpsot_cc_id-->nsdhm_cc_id            
       ,tmpsot_mkt_typ-->nsdhm_sett_type            
       ,tmpsot_settno-->nsdhm_sett_no            
       ,tmpsot_block_lock_flg-->nsdhm_block_log_flag            
       ,tmpsot_block_lock_cd-->nsdhm_block_lock_cd            
       ,tmpsot_lockin_release_date-->nsdhm_lockin_rel_date            
       ,tmpsot_ctr_dpid_otherdpid-->nsdhm_counter_dpm_id            
       --,case when tmpsot_ctr_benid = '' then tmpsot_other_clt_cd else tmpsot_ctr_benid  end  -->nsdhm_counter_bo_id            
       ,case when ltrim(rtrim(tmpsot_other_clt_cd)) = '' then tmpsot_ctr_benid else tmpsot_other_clt_cd  end  -->nsdhm_counter_bo_id            
       ,tmpsot_ctr_cmbpid-->nsdhm_counter_cmbp_id            
       ,''            
       ,tmpsot_other_sett_dtls-->nsdhm_other_sett_no            
       ,tmpsot_dpm_trx_refno-->nsdhm_dpm_trans_no            
       ,tmpsot_dm_trx_refno-->nsdhm_dm_trans_no            
       ,tmpsot_int_refno_rmks-->nsdhm_int_ref_no            
       ,tmpsot_rej_reason1-->nsdhm_reg_rsn1            
       ,tmpsot_rej_reason2-->nsdhm_reg_rsn2            
       ,tmpsot_rej_reason3-->nsdhm_reg_rsn3            
       ,tmpsot_rej_reason4-->nsdhm_reg_rsn4            
       ,tmpsot_ben_ctry-->nsdhm_ben_ctgry            
       ,tmpsot_ben_accttyp-->nsdhm_ben_acct_type          
       ,@pa_login_name            
       ,getdate()            
       ,@pa_login_name            
       ,getdate()            
       ,1            
       ,tmpsot_lnno    
       ,tmpsot_trn_descp  
       ,TMPSOT_SLIP_NO              
       FROM  tmp_sot_mstr a            
       WHERE NOT EXISTS(select tmpsot_settno             
           , tmpsot_isin             
           , tmpsot_pos_booked             
           , tmpsot_booking_narr_cd             
           , tmpsot_booking_typ              
           , tmpsot_trx_creation_dttime                        
           , tmpsot_booking_dt            
           , tmpsot_dpm_trx_refno            
           , tmpsot_dm_trx_refno            
           , tmpsot_int_refno_rmks ,NSDHMD_DPAM_ID           
           from   tmp_nsdl_holding_dtls            
           where  nsdhmd_transaction_dt = a.tmpsot_booking_dt        
           AND    nsdhmd_ben_ctgry = a.tmpsot_ben_ctry                  
           AND    nsdhmd_ben_acct_type = a.tmpsot_ben_accttyp      
           AND    nsdhmd_isin  = a.tmpsot_isin       
           AND    nsdhmd_book_naar_cd =a.tmpsot_booking_narr_cd                
           AND    nsdhmd_book_type  = a.tmpsot_booking_typ           
           AND    nsdhmd_dpm_trans_no = convert(varchar,a.tmpsot_dpm_trx_refno)        
           AND    nsdhmd_dm_trans_no = convert(varchar,a.tmpsot_dm_trx_refno)            
           AND    nsdhmd_int_ref_no = a.tmpsot_int_refno_rmks                  
           AND    nsdhmd_request_dt = a.tmpsot_trx_creation_dttime         
           AND    nsdhmd_sett_no  = a.tmpsot_settno                     
           AND    nsdhmd_qty = a.tmpsot_pos_booked
           and    NSDHMD_DPAM_ID           = a.tmpsot_dpam_id)             
           AND    isnull(tmpsot_dpam_id,0) <> 0             
  
  
  print 'success'
        IF EXISTS(SELECT tmpsot_ben_acctno FROM tmp_sot_mstr WHERE isnull(tmpsot_dpam_id,0) = 0 )                                  
        BEGIN            
        --            
          UPDATE filetask            
          SET    usermsg = 'ERROR : Following Client Not Mapped ' + citrus_usr.fn_merge_str('SOT',0,'')            
          WHERE  task_id = @pa_task_id            
        --            
        END            
  print 'success1' 
  
       update filetask set TASK_FILEDATE = @@file_date   WHERE  task_id = @pa_task_id            
  print 'success2'

       update dp_trx_dtls            
       set    dptd_status = 'E'            
       from   tmp_sot_mstr            
       where  convert(varchar(20),TMPSOT_DPM_TRX_REFNO)   = dptd_trans_no            
       and    tmpsot_dpam_id        = dptd_dpam_id                       
       and    TMPSOT_ISIN           = dptd_isin                       
       and    TMPSOT_BOOKING_DT     = dptd_execution_dt            
       and    dptd_deleted_ind      = 1             
       and    dptd_status           IN ('A1','A2')             
  print 'success3'
  
  
       update demat_request_mstr            
       set    demrm_status = 'E'            
             ,demrm_execution_dt    = TMPSOT_BOOKING_DT    
             ,DEMRM_CREDIT_RECD     = CASE WHEN isnull(DEMRM_CREDIT_RECD,'N') = 'N' THEN CASE WHEN TMPSOT_BOOKING_NARR_CD = '012' THEN 'Y' ELSE 'N' END     ELSE    isnull(DEMRM_CREDIT_RECD,'N') end
			 ,DEMRM_COMPANY_OBJ		= CASE WHEN isnull(TMPSOT_BOOKING_NARR_CD,'') = '013'  and convert(varchar,TMPSOT_REJ_REASON1) <> '0' then convert(varchar,TMPSOT_REJ_REASON1) else DEMRM_COMPANY_OBJ end
       from   tmp_sot_mstr            
       where convert(numeric,demrm_transaction_no) = convert(numeric,TMPSOT_DPM_TRX_REFNO)                      
       and    demrm_dpam_id          = tmpsot_dpam_id            
       and    demrm_isin             = TMPSOT_ISIN            
       and    TMPSOT_BOOKING_NARR_CD    IN ('011','012','013')            
       and    demrm_deleted_ind      = 1             
       and    demrm_status           IN ('A1','A2')             
  print 'success4'
       update remat_request_mstr            
       set    remrm_status = 'E'            
          ,remrm_execution_dt    = TMPSOT_BOOKING_DT            
         ,REMRM_CREDIT_RECD     = CASE WHEN isnull(REMRM_CREDIT_RECD,'N') = 'N' THEN CASE WHEN TMPSOT_BOOKING_NARR_CD = '022' THEN 'Y' ELSE 'N' END     ELSE    isnull(REMRM_CREDIT_RECD,'N') end
		 ,REMRM_COMPANY_OBJ		= CASE WHEN isnull(TMPSOT_BOOKING_NARR_CD,'') = '023'  and convert(varchar,TMPSOT_REJ_REASON1) <> '0' then convert(varchar,TMPSOT_REJ_REASON1) else REMRM_COMPANY_OBJ end
       from   tmp_sot_mstr            
       where  convert(numeric,remrm_transaction_no)   = convert(numeric,TMPSOT_DPM_TRX_REFNO)                      
       and    remrm_dpam_id          = tmpsot_dpam_id            
       and    remrm_isin             = TMPSOT_ISIN            
       and    TMPSOT_BOOKING_NARR_CD    IN ('021','022','023')            
       and    remrm_deleted_ind      = 1             
       and    remrm_status           IN ('A1','A2')             
  print 'success5'
       COMMIT TRANSACTION            
     --            
     END            
     ELSE            
     BEGIN            
     --            
       return            
     --            
     END            
  
 --     
 end

GO
