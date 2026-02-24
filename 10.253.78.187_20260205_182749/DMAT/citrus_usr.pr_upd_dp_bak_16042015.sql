-- Object: PROCEDURE citrus_usr.pr_upd_dp_bak_16042015
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--Exec pr_upd_dp '10|*~|NSDL|*~|12033300|*~|1203330000009190|*~|430001|*~|1234|*~|0001|*~|*|~*10|*~|NSDL|*~|12033300|*~|1203330000009191|*~|430002|*~|1234|*~|0002|*~|*|~*','HO','*|~*','|*~|',''  
create PROCEDURE [citrus_usr].[pr_upd_dp_bak_16042015](@pa_id           varchar(8000)  
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
  WHILE isnull(@remainingstring_id,'') <> ''  
  BEGIN --while_id  
  --  
    SET @foundat_id = 0  
    SET @foundat_id =  patindex('%'+@delimeter_id+'%', @remainingstring_id)  
  
    IF @foundat_id > 0  
    BEGIN  
    --  
      SET @currstring_id      = substring(@remainingstring_id, 0, @foundat_id)  
      SET @remainingstring_id = substring(@remainingstring_id, @foundat_id+@delimeterlength_id, len(@remainingstring_id) - @foundat_id+@delimeterlength_id)  
    --  
    END  
    ELSE  
    BEGIN  
    --  
      SET @currstring_id      = @remainingstring_id  
      SET @remainingstring_id = ''  
    --  
    END  
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

			IF citrus_usr.fn_splitval(@currstring_id,2)= 'CDSL'  
				BEGIN
					INSERT INTO TMP_CDSL_BATCH_STATUS
					VALUES
					(
					  citrus_usr.fn_splitval(@currstring_id,4),
					  citrus_usr.fn_splitval(@currstring_id,7),
					  citrus_usr.fn_splitval(@currstring_id,6),
					  GETDATE()
					)          
					
					
					select @L_DP_ID = DPM_ID FROM DP_MSTR WHERE DPM_DPID = citrus_usr.fn_splitval(@currstring_id,3)

				INSERT INTO CDSL_DPM_RESPONSE 
				(
						CDSL_ACCT_ID ,
						CDSL_LINE_NO ,
						CDSL_BATCHNO ,
						CDSL_CREATED_BY ,
						CDSL_CREATED_DT ,
						CDSL_LST_UPD_BY ,
						CDSL_LST_UPD_DT ,
						CDSL_DELETED_IND 
				)
					SELECT TMPC_ACCT_ID
					,TMPC_LINE_NO
					,TMPC_BATCHNO
					,@pa_login_name
					,GETDATE()
					,@pa_login_name
					,GETDATE()
					,1
					FROM TMP_CDSL_BATCH_STATUS WHERE TMPC_ACCT_ID 
					NOT IN (SELECT CDSL_ACCT_ID FROM CDSL_DPM_RESPONSE WHERE CDSL_DELETED_IND=1)
					
					
					UPDATE BATCHNO_CDSL_MSTR SET BATCHC_STATUS='A' 
					WHERE  BATCHC_NO = citrus_usr.fn_splitval(@currstring_id,6) AND BATCHC_TYPE = 'C'
					AND BATCHC_DELETED_IND = 1 AND BATCHC_DPM_ID = @L_DP_ID
					
                   
				END

			


				
        
    /* INSERT LOGIC FOR BATCH STATUS TABLE */

    IF isnull(@currstring_id,'') <> ''  
    BEGIN  
    --  
      BEGIN TRANSACTION  
      --      
				IF citrus_usr.fn_splitval(@currstring_id,2)= 'CDSL'
				BEGIN
							Update clim
							SET    clim_stam_cd = 'ACTIVE'
							FROM                 CLIENT_MSTR               clim
												,dp_acct_mstr              dpam     
												, dp_mstr                   dp       
												, exch_seg_mstr             excsm   
							WHERE  dpam.dpam_dpm_id        = dp.dpm_id  
							AND    excsm.excsm_id          = dp.dpm_excsm_id  
							AND    excsm.excsm_exch_cd     = citrus_usr.fn_splitval(@currstring_id,2)  
							AND    dp.dpm_dpid             = citrus_usr.fn_splitval(@currstring_id,3)  
							AND    dpam.dpam_excsm_id      = convert(numeric, citrus_usr.fn_splitval(@currstring_id,1))  
							AND    dpam.dpam_acct_no       = citrus_usr.fn_splitval(@currstring_id,5)  
							AND    clim.clim_crn_no        = dpam.dpam_crn_no
							AND    dpam.dpam_deleted_ind   = 1  
							AND    dp.dpm_deleted_ind      = 1  
							AND    excsm.excsm_deleted_ind = 1 
      

							UPDATE dpam                      WITH (ROWLOCK)  
							SET    dpam.dpam_sba_no        = convert(varchar(20), citrus_usr.fn_splitval(@currstring_id,4))  
							,dpam.dpam_lst_upd_by    = @pa_login_name  
							,dpam.dpam_lst_upd_dt    = getdate()
							,dpam.dpam_stam_cd       = 'ACTIVE'
							FROM   dp_acct_mstr              dpam     
							, dp_mstr                   dp       
							, exch_seg_mstr             excsm  
							WHERE  dpam.dpam_dpm_id        = dp.dpm_id  
							AND    excsm.excsm_id          = dp.dpm_excsm_id  
							AND    excsm.excsm_exch_cd     = citrus_usr.fn_splitval(@currstring_id,2)  
							AND    dp.dpm_dpid             = citrus_usr.fn_splitval(@currstring_id,3)  
							AND    dpam.dpam_excsm_id      = convert(numeric, citrus_usr.fn_splitval(@currstring_id,1))  
							AND    dpam.dpam_acct_no       = citrus_usr.fn_splitval(@currstring_id,5)  
							AND    dpam.dpam_deleted_ind   = 1  
							AND    dp.dpm_deleted_ind      = 1  
							AND    excsm.excsm_deleted_ind      = 1  
					END
					ELSE
					BEGIN
							Update clim
							SET    clim_stam_cd =  '06' -- REGISTERED STATUS FOR NSDL--'ACTIVE'
							FROM                 CLIENT_MSTR               clim
												,dp_acct_mstr              dpam     
												, dp_mstr                   dp       
												, exch_seg_mstr             excsm   
							WHERE  dpam.dpam_dpm_id        = dp.dpm_id  
							AND    excsm.excsm_id          = dp.dpm_excsm_id  
							AND    excsm.excsm_exch_cd     = citrus_usr.fn_splitval(@currstring_id,2)  
							AND    dp.dpm_dpid             = citrus_usr.fn_splitval(@currstring_id,3)  
							AND    dpam.dpam_excsm_id      = convert(numeric, citrus_usr.fn_splitval(@currstring_id,1))  
							AND    dpam.dpam_acct_no       = citrus_usr.fn_splitval(@currstring_id,5)  
							AND    clim.clim_crn_no        = dpam.dpam_crn_no
							AND    dpam.dpam_deleted_ind   = 1  
							AND    dp.dpm_deleted_ind      = 1  
							AND    excsm.excsm_deleted_ind = 1 


      

							UPDATE dpam                      WITH (ROWLOCK)  
							SET    dpam.dpam_sba_no        = convert(varchar(20), citrus_usr.fn_splitval(@currstring_id,4))  
							,dpam.dpam_lst_upd_by    = @pa_login_name  
							,dpam.dpam_lst_upd_dt    = getdate()
							,dpam.dpam_stam_cd       = 'ACTIVE'--'06' -- REGISTERED STATUS FOR NSDL
							FROM   dp_acct_mstr              dpam     
							, dp_mstr                   dp       
							, exch_seg_mstr             excsm  
							WHERE  dpam.dpam_dpm_id        = dp.dpm_id  
							AND    excsm.excsm_id          = dp.dpm_excsm_id  
							AND    excsm.excsm_exch_cd     = citrus_usr.fn_splitval(@currstring_id,2)  
							AND    dp.dpm_dpid             = citrus_usr.fn_splitval(@currstring_id,3)  
							AND    dpam.dpam_excsm_id      = convert(numeric, citrus_usr.fn_splitval(@currstring_id,1))  
							AND    dpam.dpam_acct_no       = citrus_usr.fn_splitval(@currstring_id,5)  
							AND    dpam.dpam_deleted_ind   = 1  
							AND    dp.dpm_deleted_ind      = 1  
							AND    excsm.excsm_deleted_ind = 1 
     
  
					END



					SET @l_records = @@rowcount
      
      
							UPDATE ACCP                      WITH (ROWLOCK)  
							SET    accp_value              = CONVERT(VARCHAR,CONVERT(DATETIME,citrus_usr.fn_splitval(@currstring_id,8),103),103)   
							FROM   dp_acct_mstr              dpam     
							LEFT OUTER JOIN
							ACCOUNT_PROPERTIES    ACCP ON ACCP_CLISBA_ID =   DPAM_ID AND  ACCP_ACCPM_PROP_CD = 'BILL_START_DT'
							, dp_mstr                   dp       
							, exch_seg_mstr             excsm  
							WHERE  dpam.dpam_dpm_id        = dp.dpm_id  
							AND    excsm.excsm_id          = dp.dpm_excsm_id  
							AND    excsm.excsm_exch_cd     = citrus_usr.fn_splitval(@currstring_id,2)  
							AND    dp.dpm_dpid             = citrus_usr.fn_splitval(@currstring_id,3)  
							AND    dpam.dpam_excsm_id      = convert(numeric, citrus_usr.fn_splitval(@currstring_id,1))  
							AND    dpam.dpam_acct_no       = citrus_usr.fn_splitval(@currstring_id,5)  
							AND    dpam.dpam_deleted_ind   = 1  
							AND    dp.dpm_deleted_ind      = 1  
							AND    excsm.excsm_deleted_ind      = 1  --ONLY FOR DP PROJECT 
      
      --  
       
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
      SET    dphd.dphd_dpam_sba_no   = convert(varchar(20), citrus_usr.fn_splitval(@currstring_id,4))  
           , dphd.dphd_lst_upd_by    = @pa_login_name  
           , dphd.dphd_lst_upd_dt    = getdate()     
      FROM   dp_acct_mstr              dpam      
           , dp_mstr                   dp  
           , dp_holder_dtls            dphd  
           , exch_seg_mstr             excsm  
      WHERE  dpam.dpam_dpm_id        = dp.dpm_id  
      AND    dpam.dpam_id            = dphd.dphd_dpam_id  
      AND    excsm.excsm_id            = dp.dpm_excsm_id  
      AND    excsm.excsm_exch_cd            = citrus_usr.fn_splitval(@currstring_id,2)  
      AND    dp.dpm_dpid             = citrus_usr.fn_splitval(@currstring_id,3)  
      AND    dpam.dpam_excsm_id      = convert(numeric, citrus_usr.fn_splitval(@currstring_id,1))  
      AND    dpam.dpam_acct_no       = citrus_usr.fn_splitval(@currstring_id,5)  
      AND    dphd.dphd_deleted_ind   = 1  
      AND    dpam.dpam_deleted_ind   = 1  
      AND    dp.dpm_deleted_ind      = 1  
      AND    excsm.excsm_deleted_ind      = 1  
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
						SET    dpentr.entr_sba           = convert(varchar(20), citrus_usr.fn_splitval(@currstring_id,4))  
											, dpentr.entr_lst_upd_by    = @pa_login_name  
											, dpentr.entr_lst_upd_dt    = getdate()     
						FROM   dp_acct_mstr              dpam      
											, dp_mstr                   dp  
											, entity_relationship       dpentr 
											, exch_seg_mstr             excsm  
						WHERE  dpam.dpam_dpm_id        = dp.dpm_id  
						AND    dpam.dpam_acct_no       = dpentr.entr_acct_no
						AND    excsm.excsm_id          = dp.dpm_excsm_id  
						AND    excsm.excsm_exch_cd     = citrus_usr.fn_splitval(@currstring_id,2)  
						AND    dp.dpm_dpid             = citrus_usr.fn_splitval(@currstring_id,3)  
						AND    dpam.dpam_excsm_id      = convert(numeric, citrus_usr.fn_splitval(@currstring_id,1))  
						AND    dpam.dpam_acct_no       = citrus_usr.fn_splitval(@currstring_id,5)  
						AND    dpentr.entr_deleted_ind   = 1  
						AND    dpam.dpam_deleted_ind   = 1  
						AND    dp.dpm_deleted_ind      = 1  
						AND    excsm.excsm_deleted_ind      = 1  
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
      SET    accac.accac_acct_no     = convert(varchar(20), citrus_usr.fn_splitval(@currstring_id,4))  
           , accac.accac_lst_upd_by  = @pa_login_name  
           , accac.accac_lst_upd_dt  = getdate()     
      FROM   dp_acct_mstr              dpam     
           , dp_mstr                   dp  
           , account_adr_conc          accac  
           , exch_seg_mstr             excsm  
      WHERE  dpam.dpam_dpm_id        = dp.dpm_id  
      AND    dpam.dpam_id            = accac.accac_clisba_id  
      AND    excsm.excsm_id            = dp.dpm_excsm_id  
      AND    excsm.excsm_exch_cd            = citrus_usr.fn_splitval(@currstring_id,2)  
      AND    dp.dpm_dpid             = citrus_usr.fn_splitval(@currstring_id,3)  
      AND    dpam.dpam_excsm_id      = convert(numeric, citrus_usr.fn_splitval(@currstring_id,1))  
      AND    dpam.dpam_acct_no       = citrus_usr.fn_splitval(@currstring_id,5)  
      AND    dpam.dpam_deleted_ind   = 1  
      AND    dp.dpm_deleted_ind      = 1  
      AND    accac.accac_deleted_ind = 1  
      AND    excsm.excsm_deleted_ind   = 1  
      --  
      IF @l_records > 1  
      BEGIN   
      --  
        SET @pa_errmsg = isnull(@pa_errmsg,'') + isnull(@currstring_id,'') +  convert(varchar,@l_records)+@coldelimiter+@rowdelimiter  
        --  
        ROLLBACK TRANSACTION  
        --  
        RETURN  
      --  
      END  
      ELSE IF @l_records = 0   
      BEGIN  
      --  
        SET @pa_errmsg = isnull(@pa_errmsg,'') + isnull(@currstring_id,'') + '0'+@coldelimiter+@rowdelimiter  
        --  
        COMMIT TRANSACTION    
      --  
      END  
      ELSE IF @l_records = 1  
      BEGIN  
      --  
        SET @pa_errmsg = isnull(@pa_errmsg,'') + isnull(@currstring_id,'') + '1'+@coldelimiter+@rowdelimiter  
        --  
        COMMIT TRANSACTION    
      --  
      END  
    --  
    END  
  --    
  END    
  --print @pa_errmsg  
--    
END

GO
