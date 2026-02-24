-- Object: PROCEDURE citrus_usr.pr_upd_dp_new
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------



--Exec pr_upd_dp '10|*~|NSDL|*~|12033300|*~|1203330000009190|*~|430001|*~|1234|*~|0001|*~|*|~*10|*~|NSDL|*~|12033300|*~|1203330000009191|*~|430002|*~|1234|*~|0002|*~|*|~*','HO','*|~*','|*~|',''  
CREATE PROCEDURE [citrus_usr].[pr_upd_dp_new](@pa_id           varchar(8000)  
                         ,@pa_login_name   varchar(20)                       
                         ,@rowdelimiter    char(4)      = '*|~*'  
                         ,@coldelimiter    char(4)      = '|*~|'  
                         ,@pa_errmsg       varchar(8000) OUTPUT  
                         )  
AS  
/*  
********************************************************************************  
 SYSTEM         : CITRUS  
 MODULE NAME    : pr_upd_dp  
 DESCRIPTION    : THIS PROCEDURE WILL CREATE UPDATE DEMAT ID IN DP_ACCT_MSTR  
 COPYRIGHT(C)   : MARKETPLACE TECHNOLOGIES PVT. LTD.  
 VERSION HISTORY: 1.0  
 VERS.  AUTHOR            DATE          REASON  
 -----  -------------     ------------  ----------------------------------------  
 2.0    Sukhvinder        10-Aug-2007   2.0.  
 -------------------------------------------------------------------------------  
********************************************************************************  
*/  
--  

BEGIN  
--    
  DECLARE @l_records           numeric  
        , @remainingstring_id  varchar(8000)  
        , @currstring_id       varchar(8000)  
        , @foundat_id          integer  
        , @delimeterlength_id  int   
        , @delimeter_id        char(4)  
        , @l_error             numeric  
        , @L_DP_ID             NUMERIC
             ,@l_rej varchar(8000)
  --  
  /*  
  UPDATE client_dp_accts   
  SET    clidpa_dp_id       = citrus_usr.fn_splitval(@pa_id,4)  
  FROM   client_dp_accts  
        ,dp_mstr  
        ,exch_seg_mstr    
        ,client_sub_Accts  
  WHERE  clidpa_dpm_id      = dpm_id   
  AND    clidpa_compm_id    = excsm_compm_id  
  AND    clidpa_clisba_id   = clisba_id   
  AND    excsm_id           = citrus_usr.fn_splitval(@pa_id,1)  
  AND    dpm_type           = citrus_usr.fn_splitval(@pa_id,2)  
  AND    clisba_no          = citrus_usr.fn_splitval(@pa_id,5)  
  --AND    dpm_dpid           = citrus_usr.fn_splitval(@pa_id,3)  
  AND    clidpa_deleted_ind = 1  
  AND    dpm_deleted_ind    = 1  
  AND    clisba_deleted_ind = 1  
  AND    excsm_deleted_ind  = 1  
  'excsm_id |*~| dp_type |*~| dp_id |*~|dpam_sba_no(dmat a/c no.) |*~| dpam_acct_no(form no.)|*~|*|~*  
   11|*~|NSDL|*~|IN302527|*~|10096258|*~|000000|*~|*|~*  
  */  
  SET @delimeter_id           = @rowdelimiter  
  SET @delimeterlength_id     = len(@rowdelimiter)  
  SET @remainingstring_id     = @pa_id  
  
  --  
  --WHILE isnull(@remainingstring_id,'') <> ''  
  --BEGIN --while_id  
  ----  
  --  SET @foundat_id = 0  
  --  SET @foundat_id =  patindex('%'+@delimeter_id+'%', @remainingstring_id)  
  
  --  IF @foundat_id > 0  
  --  BEGIN  
  --  --  
  --    SET @currstring_id      = substring(@remainingstring_id, 0, @foundat_id)  
  --    SET @remainingstring_id = substring(@remainingstring_id, @foundat_id+@delimeterlength_id, len(@remainingstring_id) - @foundat_id+@delimeterlength_id)  
  --  --  
  --  END  
  --  ELSE  
  --  BEGIN  
  --  --  
  --    SET @currstring_id      = @remainingstring_id  
  --    SET @remainingstring_id = ''  
  --  --  
  --  END  
    -- 
    /* INSERT LOGIC FOR BATCH STATUS TABLE */    
			IF citrus_usr.fn_splitval(@currstring_id,2)= 'NSDL'  
				BEGIN
					INSERT INTO TMP_NSDL_BATCH_STATUS
					VALUES
					(
					  citrus_usr.fn_splitval(@currstring_id,4),
					  citrus_usr.fn_splitval(@currstring_id,7),
					  citrus_usr.fn_splitval(@currstring_id,6),
					  GETDATE()
					)             
					
					select @L_DP_ID = DPM_ID FROM DP_MSTR WHERE DPM_DPID = citrus_usr.fn_splitval(@currstring_id,3)
					
				INSERT INTO NSDL_DPM_RESPONSE 
				(
					NSDL_ACCT_ID ,
					NSDL_LINE_NO ,
					NSDL_BATCHNO ,
					NSDL_CREATED_BY ,
					NSDL_CREATED_DT ,
					NSDL_LST_UPD_BY ,
					NSDL_LST_UPD_DT ,
					NSDL_DELETED_IND 
				 )
					SELECT TMPN_ACCT_ID
				,TMPN_LINE_NO
				,TMPN_BATCHNO
				,@pa_login_name
				,GETDATE()
				,@pa_login_name
				,GETDATE()
				,1
				FROM TMP_NSDL_BATCH_STATUS WHERE TMPN_ACCT_ID 
				NOT IN (SELECT NSDL_ACCT_ID FROM NSDL_DPM_RESPONSE WHERE NSDL_DELETED_IND=1)
				
				 UPDATE BATCHNO_NSDL_MSTR SET BATCHN_STATUS='A' 
				 WHERE  BATCHN_NO = citrus_usr.fn_splitval(@currstring_id,6) AND BATCHN_TYPE = 'C'
			     AND BATCHN_DELETED_IND = 1 AND BATCHN_DPM_ID = @L_DP_ID
					


				END

			--IF citrus_usr.fn_splitval(@currstring_id,2)= 'CDSL'  
			--	BEGIN
				
					--INSERT INTO TMP_CDSL_BATCH_STATUS
					--VALUES
					--(
					--  citrus_usr.fn_splitval(@currstring_id,4),
					--  citrus_usr.fn_splitval(@currstring_id,7),
					--  citrus_usr.fn_splitval(@currstring_id,6),
					--  GETDATE()
					--)          
					
					
					select @L_DP_ID = '3' -- DPM_ID FROM DP_MSTR WHERE DPM_DPID = citrus_usr.fn_splitval(@currstring_id,3)

				--INSERT INTO CDSL_DPM_RESPONSE 
				--(
				--		CDSL_ACCT_ID ,
				--		CDSL_LINE_NO ,
				--		CDSL_BATCHNO ,
				--		CDSL_CREATED_BY ,
				--		CDSL_CREATED_DT ,
				--		CDSL_LST_UPD_BY ,
				--		CDSL_LST_UPD_DT ,
				--		CDSL_DELETED_IND 
				--)
				--	SELECT TMPC_ACCT_ID
				--	,TMPC_LINE_NO
				--	,TMPC_BATCHNO
				--	,@pa_login_name
				--	,GETDATE()
				--	,@pa_login_name
				--	,GETDATE()
				--	,1
				--	FROM TMP_CDSL_BATCH_STATUS WHERE TMPC_ACCT_ID 
				--	NOT IN (SELECT CDSL_ACCT_ID FROM CDSL_DPM_RESPONSE WHERE CDSL_DELETED_IND=1)
					
					
					UPDATE BATCHNO_CDSL_MSTR SET BATCHC_STATUS='A' from BATCHNO_CDSL_MSTR,tmp_client_res
					WHERE  BATCHC_NO = tmp_batchno --citrus_usr.fn_splitval(@currstring_id,6) 
					AND BATCHC_TYPE = 'C'
					AND BATCHC_DELETED_IND = 1 AND BATCHC_DPM_ID = @L_DP_ID and ISNULL(tmp_errmsg,'')=''
					
                   
				--END

			


				
        
    /* INSERT LOGIC FOR BATCH STATUS TABLE */

    IF isnull(@currstring_id,'') = ''  
    BEGIN  
    --  
     -- BEGIN TRANSACTION  
      --      
				IF 'CDSL'= 'CDSL'
				BEGIN
				      
				      
				      

							Update clim
							SET    clim_stam_cd = 'ACTIVE'
							FROM                 CLIENT_MSTR               clim
												,dp_acct_mstr              dpam     
												,tmp_client_res
							WHERE DPAM_CRN_NO=CLIM_CRN_NO AND DPAM_ACCT_NO=tmp_formno and ISNULL(tmp_errmsg,'')=''
      

							UPDATE dpam                      WITH (ROWLOCK)  
							SET    dpam.dpam_sba_no        = tmp_boid --convert(varchar(20), citrus_usr.fn_splitval(@currstring_id,4))  
							,dpam.dpam_lst_upd_by    = @pa_login_name  
							,dpam.dpam_lst_upd_dt    = getdate()
							,dpam.dpam_stam_cd       = 'ACTIVE'
							FROM   dp_acct_mstr              dpam     
							,tmp_client_res
							WHERE  DPAM_ACCT_NO=tmp_formno and ISNULL(tmp_errmsg,'')=''
							
							

							Update D set Dpam_bbo_code=kit_no from dp_acct_mstr D, API_CLIENT_MASTER_SYNERGY_DP,tmp_client_res where DP_INTERNAL_REF=DPAM_ACCT_NO
							--and DPAM_ACCT_NO=DPAM_SBA_NO
							and ISNULL(DPAM_BBO_CODE,'')=''		and DPAM_SBA_NO  like '120332%' and tmp_formno=DPAM_ACCT_NO and ISNULL(tmp_errmsg,'')=''
							
							
							
				      
					END
					ELSE
					BEGIN
							Update clim
							SET    clim_stam_cd =  '06' -- REGISTERED STATUS FOR NSDL--'ACTIVE'
							FROM                 CLIENT_MSTR               clim
												,dp_acct_mstr              dpam     
												
												,tmp_client_res
							WHERE DPAM_CRN_NO=CLIM_CRN_NO AND DPAM_ACCT_NO=tmp_formno and ISNULL(tmp_errmsg,'')=''


      

							UPDATE dpam                      WITH (ROWLOCK)  
							SET    dpam.dpam_sba_no        = convert(varchar(20), citrus_usr.fn_splitval(@currstring_id,4))  
							,dpam.dpam_lst_upd_by    = @pa_login_name  
							,dpam.dpam_lst_upd_dt    = getdate()
							,dpam.dpam_stam_cd       = 'ACTIVE'--'06' -- REGISTERED STATUS FOR NSDL
							FROM   dp_acct_mstr              dpam     
							,tmp_client_res
							WHERE  DPAM_ACCT_NO=tmp_formno and ISNULL(tmp_errmsg,'')=''
     
  
					END



					SET @l_records = @@rowcount
      
     
							UPDATE ACCP                      WITH (ROWLOCK)  
							SET    accp_value              = convert(varchar(10),convert(datetime,CONVERT(varchar(11),tmp_date,109),103),103) --tmp_date --CONVERT(VARCHAR,CONVERT(DATETIME,citrus_usr.fn_splitval(@currstring_id,8),103),103)  
							--,ACCP_ACCT_NO=DPAM_SBA_NO 
							FROM   dp_acct_mstr              dpam     
							LEFT OUTER JOIN
							ACCOUNT_PROPERTIES    ACCP ON ACCP_CLISBA_ID =   DPAM_ID AND  ACCP_ACCPM_PROP_CD = 'BILL_START_DT'
							,tmp_client_res
							WHERE  DPAM_ACCT_NO=tmp_formno  and ISNULL(tmp_errmsg,'')=''
      
      --  
       ---select * from tmp_client_res
      --  
      IF @l_error > 0  
      BEGIN  
      --  
        SET @pa_errmsg = isnull(@pa_errmsg,'') + @currstring_id +  convert(varchar,@l_records)+@coldelimiter+@rowdelimiter  
        --  
        ROLLBACK TRANSACTION  
        --  
        RETURN  
      --  
      END  
      --  
      UPDATE dphd                      WITH (ROWLOCK)  
      SET    dphd.dphd_dpam_sba_no   = tmp_boid--convert(varchar(20), citrus_usr.fn_splitval(@currstring_id,4))  
           , dphd.dphd_lst_upd_by    = @pa_login_name  
           , dphd.dphd_lst_upd_dt    = getdate()     
      FROM   dp_acct_mstr              dpam      
          ,tmp_client_res
           , dp_holder_dtls            dphd  
           where DPAM_ID=DPHD_DPAM_ID and DPAM_ACCT_NO=tmp_formno  and ISNULL(tmp_errmsg,'')=''
         
      --  
      SET    @l_error                = @@error  
      --  
      IF @l_error > 0  
      BEGIN  
      --  
        SET @pa_errmsg = isnull(@pa_errmsg,'') + isnull(@currstring_id,'') +  convert(varchar,@l_records)+@coldelimiter+@rowdelimiter  
        --  
        ROLLBACK TRANSACTION  
        --  
        RETURN  
      --  
      END  
      --  
      UPDATE dpentr     WITH (ROWLOCK)  
						SET    dpentr.entr_sba           = tmp_boid --convert(varchar(20), citrus_usr.fn_splitval(@currstring_id,4))  
											, dpentr.entr_lst_upd_by    = @pa_login_name  
											, dpentr.entr_lst_upd_dt    = getdate()     
						FROM   dp_acct_mstr              dpam      											 
											, entity_relationship       dpentr , tmp_client_res
											 
						WHERE DPAM_ACCT_NO=ENTR_SBA and DPAM_ACCT_NO=tmp_formno and ISNULL(tmp_errmsg,'')=''
						
						--  
						SET    @l_error                = @@error  
						--  
						IF @l_error > 0  
						BEGIN  
						--  
								SET @pa_errmsg = isnull(@pa_errmsg,'') + isnull(@currstring_id,'') +  convert(varchar,@l_records)+@coldelimiter+@rowdelimiter  
								--  
								ROLLBACK TRANSACTION  
								--  
								RETURN  
						--  
						END  
						      
						UPDATE accac                     WITH (ROWLOCK)  
      SET    accac.accac_acct_no     = tmp_boid-- convert(varchar(20), citrus_usr.fn_splitval(@currstring_id,4))  
           , accac.accac_lst_upd_by  = @pa_login_name  
           , accac.accac_lst_upd_dt  = getdate()     
      FROM   dp_acct_mstr              dpam     
            ,tmp_client_res
           , account_adr_conc          accac  
           WHERE ACCAC_CLISBA_ID=DPAM_ID and DPAM_ACCT_NO=tmp_formno and ISNULL(tmp_errmsg,'')=''
      --  
      --IF @l_records > 1  
      --BEGIN   
      ----  
      --  SET @pa_errmsg = isnull(@pa_errmsg,'') + isnull(@currstring_id,'') +  convert(varchar,@l_records)+@coldelimiter+@rowdelimiter  
      --  --  
      --  print '34343'
      --  print @pa_errmsg
      --  ROLLBACK TRANSACTION  
      --  --  
      --  RETURN  
      ----  
      --END  
      --ELSE 
      --IF @l_records = 0   
      --BEGIN  
      ----  
      --  SET @pa_errmsg = isnull(@pa_errmsg,'') + isnull(@currstring_id,'') + '0'+@coldelimiter+@rowdelimiter  
      --  --  
      --  COMMIT TRANSACTION    
      ----  
      --END  
      --ELSE IF @l_records = 1  
      --BEGIN  
      ----  
      --  SET @pa_errmsg = isnull(@pa_errmsg,'') + isnull(@currstring_id,'') + '1'+@coldelimiter+@rowdelimiter  
      --  --  
      --  COMMIT TRANSACTION    
      ----  
      --END  
    --  
    END  
  --    
 -- END    
  --print @pa_errmsg  
  

update a set client_code = dpam_sba_no,ENTITY='CDSL',DATE_TIME=convert(varchar(19),tmp_date,120) from kyc.dbo.CDSLAPI_REJECTION a 
, dp_acct_mstr 
, tmp_client_res
where  DPAM_ACCT_NO=tmp_formno							
and status ='A'  and DPAM_BBO_CODE=KIT_NO and ISNULL(tmp_errmsg,'')=''

insert into tmp_client_res_mstr
select *from tmp_client_res

--select @l_rej= tmp_formno + @coldelimiter + tmp_boid + @coldelimiter+ tmp_errmsg  from dp_acct_mstr,tmp_client_res t where DPAM_ACCT_NO=tmp_formno and ISNULL(tmp_errmsg,'')<>'' 

--SET @pa_errmsg = isnull(@pa_errmsg,'') + @l_rej +  @coldelimiter+@rowdelimiter  


--delete from tmp_client_res

--    
END

GO
