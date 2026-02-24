-- Object: PROCEDURE citrus_usr.PR_INS_UPD_INWSR_MSTR
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--PR_INS_UPD_INWSR_MSTR '233','DEL','HO','','','','','','','','','','','','','','','','','','','','','','*|~*','|*~|',''	
--	27	EDT	VISHAL	IN300175	901	011	10000061	33	29/12/2008	2	50.00	29/12/2008	HAND DELIVERY	4	CASH			
--PR_INS_UPD_INWSR_MSTR '27','EDT','VISHAL','IN300175','10000061','901','011','1828092','29/12/2008','1','400.500','08/10/2008','HAND DELIVERY','1','CHEQUE','1123','232133',0,'0','ERTERTR','*|~*','|*~|',''
CREATE PROCEDURE [citrus_usr].[PR_INS_UPD_INWSR_MSTR] (@pa_id VARCHAR(50)          
                                        , @pa_action         VARCHAR(20)          
                                        , @pa_login_name     VARCHAR(20)          
                                        , @pa_dpm_dpid       VARCHAR(50)        
                                        , @pa_boid           VARCHAR(50)        
                                        , @pa_trans_cd       VARCHAR(10)
										, @pa_transub_cd     VARCHAR(10)        
                                        , @pa_slip_no        VARCHAR(50)        
                                        , @pa_rece_dt        VARCHAR(11)        
                                        , @pa_no_of_entries  VARCHAR(20)
										, @pa_ufcharge       VARCHAR(20)        
                                        , @pa_exe_dt         VARCHAR(10)        
                                        , @pa_receipt_mode   VARCHAR(20)
										, @pa_bankid		 VARCHAR(10)
										, @pa_pay_mode		 VARCHAR(10)
										, @pa_cheque_no		 VARCHAR(20)
										, @pa_bankaccno_no   VARCHAR(20) 
										, @pa_received_from_bank  varchar(1000)
                                        , @pa_inwsr_cheque_dt DATETIME  
										, @pa_inwsr_bankbranch varchar(500)  
                                        , @pa_inwsr_modestatus varchar(20)    
                                        , @pa_chk_yn         INT          
                                        , @pa_values         VARCHAR(8000)        
                                        , @pa_rmks           VARCHAR(250)  
										, @pa_no_of_images   INT   
										, @PA_INWSR_IMAGE_FLG CHAR(1)   
                                        , @rowdelimiter      CHAR(4)       = '*|~*'          
                                        , @coldelimiter      CHAR(4)       = '|*~|'          
                                        , @pa_errmsg         VARCHAR(8000) output          
                                       )        
                                               
AS        
        
BEGIN        
--        
DECLARE @t_errorstr      VARCHAR(8000)        
    , @l_error           BIGINT        
    , @l_dpam_id         NUMERIC        
    , @l_id              INT        
    , @l_dpm_id          NUMERIC
	, @@vch_no bigint
	, @@FINID INT
	, @@SSQL VARCHAR(8000)
	, @@refno VARCHAR(20)
	, @@vch_values varchar(8000)
	, @l_pay_mode char(1)
	, @L_COUNT_OF_TOTAL_IMAGES_IN_INWARD_REG INT

    SELECT @l_dpm_id     = dpm_id FROM dp_mstr WHERE dpm_deleted_ind = 1   and dpm_dpid = @pa_dpm_dpid        

	CREATE TABLE #VOUCHERNO(VCHNO BIGINT)
	SELECT @@FINID = FIN_ID FROM FINANCIAL_YR_MSTR WHERE CONVERT(DATETIME,@pa_rece_dt,103) BETWEEN FIN_START_DT AND FIN_END_DT AND FIN_DPM_ID = @l_dpm_id AND FIN_DELETED_IND = 1

    if @pa_trans_cd = 'GENERAL' and @pa_action  in ('EDT','DEL') and @pa_action not in ('INS')
	SET @@refno = ltrim(rtrim(isnull(@pa_trans_cd,''))) + '_' + ltrim(rtrim(isnull(@pa_id,'')))   
    else if @pa_action <> 'DEL'
	SET @@refno = ltrim(rtrim(isnull(@pa_trans_cd,''))) + '_' + ltrim(rtrim(isnull(@pa_slip_no,'')))




    set @l_pay_mode = ''
	SET @@vch_no = 0     
            

    if @pa_action  = ('DEL') 
    begin 

    SELECT @l_dpm_id     = INWSR_DPM_ID from INWARD_SLIP_REG where INWSR_ID = @pa_id and INWSR_DELETED_IND = 1
 
    select @pa_rece_dt = INWSR_RECD_DT  from INWARD_SLIP_REG where INWSR_ID = @pa_id and INWSR_DELETED_IND = 1

    SELECT @@FINID = FIN_ID FROM FINANCIAL_YR_MSTR WHERE CONVERT(DATETIME,@pa_rece_dt,103) BETWEEN FIN_START_DT AND FIN_END_DT AND FIN_DPM_ID = @l_dpm_id AND FIN_DELETED_IND = 1


    select @@refno       = inwsr_trastm_cd + '_'+ case when inwsr_trastm_cd = 'GENERAL' then convert(varchar,INWSR_ID) else INWSR_SLIP_NO end from INWARD_SLIP_REG where INWSR_ID = @pa_id and INWSR_DELETED_IND = 1
    
    end 


    IF @pa_chk_yn = 0            
    BEGIN          
    --        

      if @pa_trans_cd not in ('904_P2C','907')
      begin
      SELECT  @l_dpam_id  = dpam_id FROM dp_acct_mstr ,dp_mstr WHERE dpm_deleted_ind = 1  and dpm_id = dpam_dpm_id and dpm_dpid = @pa_dpm_dpid and dpam_sba_no  LIKE CASE WHEN ISNULL(@pa_boid,'') = '' THEN '%' ELSE @pa_boid  END           
      end
      else
      begin
      SELECT  @l_dpam_id  = dpam_id FROM dp_acct_mstr, account_properties ,dp_mstr WHERE dpm_deleted_ind = 1  and dpm_id = dpam_dpm_id and dpm_dpid = @pa_dpm_dpid and dpam_id = accp_clisba_id and ACCP_ACCPM_PROP_CD = 'CMBP_ID' and accp_value = @pa_boid
      end
       
              
                   
      IF @pa_action = 'INS'        
      BEGIN        
      --      
      	IF EXISTS(SELECT TOP 1 INWSR_SLIP_NO FROM INWARD_SLIP_REG WHERE INWSR_SLIP_NO = @pa_slip_no AND @pa_trans_cd <> 'GENERAL' AND INWSR_DELETED_IND =1 )
      	BEGIN
      	--
      			SELECT @pa_errmsg = 'ERROR : '+'Entry for the slip no : ' + convert(varchar,@pa_slip_no) + ' already exists, Please verify '
      			return
      	--
      	END
                
        BEGIN TRANSACTION        
                 
        SELECT @l_id = ISNULL(MAX(INWSR_ID),0) + 1 FROM INWARD_SLIP_REG        


  if @pa_trans_cd = 'GENERAL' and @pa_action  in ('INS')
  SET @@refno = ltrim(rtrim(isnull(@pa_trans_cd,''))) + '_' + ltrim(rtrim(isnull(@l_id,'')))   

        INSERT INTO INWARD_SLIP_REG        
        (        
         INWSR_ID        
         ,INWSR_SLIP_NO        
         ,INWSR_DPM_ID        
         ,INWSR_DPAM_ID        
         ,INWSR_RECD_DT        
         ,INWSR_EXEC_DT        
         ,INWSR_NO_OF_TRANS        
         ,INWSR_RECEIVED_MODE        
         ,INWSR_TRASTM_CD 
		 ,inwsr_transubtype_cd
	     ,inwsr_ufcharge_collected
		 ,inwsr_bankid	
		 ,inwsr_PAY_MODE
		 ,inwsr_cheque_no
		 ,inwsr_clibank_accno
		 ,inwsr_clibank_name 
		 ,inwsr_cheque_dt
         ,inwsr_bank_branch 
         ,inwsr_fax_scan_status						      
         ,INWSR_CREATED_BY        
         ,INWSR_CREATED_DT        
         ,INWSR_LST_UPD_BY        
         ,INWSR_LST_UPD_DT        
         ,INWSR_DELETED_IND        
         ,INWSR_RMKS 
		 ,INWSR_NO_OF_IMAGES  
		 ,INWSR_IMAGE_FLG     
        )        
        VALUES        
        ( @l_id        
         , @pa_slip_no        
         , @l_dpm_id        
         , @l_dpam_id        
         , CONVERT(DATETIME,@pa_rece_dt,103)         
         , CONVERT(DATETIME,@pa_exe_dt,103)         
         , @pa_no_of_entries        
         , @pa_receipt_mode        
         , @pa_trans_cd 
		 , @pa_transub_cd
		 , convert(numeric(18,2),@pa_ufcharge)
		 , convert(numeric,@pa_bankid)
		 , @pa_pay_mode
	     , @pa_cheque_no
		 , @pa_bankaccno_no	
		 , @pa_received_from_bank 
		 , @pa_inwsr_cheque_dt  
         ,@pa_inwsr_bankbranch  
		,@pa_inwsr_modestatus		       
         , @pa_login_name        
         , getdate()        
         , @pa_login_name        
         , getdate()        
         , 1        
         , @pa_rmks        
		 , @pa_no_of_images
		 , @PA_INWSR_IMAGE_FLG
        )        
         
		
		      
        SET @l_error = @@error        
        IF @l_error <> 0        
        BEGIN        
        --        
          IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)        
          BEGIN        
          --        
            SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)        
          --        
          END        
          ELSE        
          BEGIN        
         --        
            SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'        
          --        
          END      
        
          ROLLBACK TRANSACTION         
        
          RETURN        
        --        
        END        
        ELSE        
        BEGIN        
        --      
	        SET  @t_errorstr  = CONVERT(VARCHAR,@l_id)+'-'+CONVERT(VARCHAR,@l_dpam_id)  
		  
			if ltrim(rtrim(isnull(@pa_ufcharge,''))) <> '' 
			begin
				if convert(numeric(18,2),ltrim(rtrim(isnull(@pa_ufcharge,'0')))) > 0 
				begin 
					SET @l_pay_mode = CASE WHEN @pa_pay_mode = 'CASH' THEN 'C' ELSE 'B' END
					  SET @@vch_values = @l_pay_mode + '|*~|' +  convert(varchar,ISNULL(@pa_bankid,0)) + '|*~|' + CONVERT(VARCHAR,@pa_ufcharge) + '|*~|*|~*P|*~|' + convert(varchar,isnull(@l_dpam_id,'0')) + '|*~|0|*~||*~|' + CONVERT(VARCHAR,@pa_ufcharge) + '|*~|' + ISNULL(@pa_cheque_no,'') + '|*~|' + LEFT(ISNULL(@pa_rmks,''),250) + '|*~|' + isnull(@pa_bankaccno_no,'') + '|*~|*|~*'

                      select '0','INS','INWARDENTRY',@l_dpm_id,2,'01','',@@refno ,@pa_rece_dt,@@vch_values,0,'*|~*','|*~|',''      
					  Exec pr_ins_upd_ledgerR '0','INS','INWARDENTRY',@l_dpm_id,2,'01','',@@refno,@pa_rece_dt,@@vch_values,0,'*|~*','|*~|',''      
				end
			end



         COMMIT TRANSACTION        
        --        
      END        
      --        
      END        
    --        
    END   --ins end        
            
  IF @pa_action = 'EDT'        
    BEGIN        
    --        
      BEGIN TRANSACTION        
        
      UPDATE INWARD_SLIP_REG        
      SET INWSR_EXEC_DT           = CONVERT(DATETIME,@pa_exe_dt ,103)        
         ,INWSR_NO_OF_TRANS       = @pa_no_of_entries        
         ,INWSR_RECEIVED_MODE     = @pa_receipt_mode        
         ,INWSR_TRASTM_CD         = @pa_trans_cd 
		 ,inwsr_transubtype_cd    = @pa_transub_cd 	       
		 ,inwsr_ufcharge_collected = convert(numeric(18,2),@pa_ufcharge)
	     ,inwsr_bankid			   = convert(numeric,@pa_bankid)			
		 ,inwsr_PAY_MODE		   = @pa_pay_mode	
		 ,inwsr_cheque_no		   = @pa_cheque_no	
		 ,inwsr_clibank_accno	   = @pa_bankaccno_no
		 ,inwsr_clibank_name = @pa_received_from_bank 
         ,inwsr_cheque_dt = @pa_inwsr_cheque_dt 	
         ,inwsr_bank_branch = @pa_inwsr_bankbranch
         ,inwsr_fax_scan_status= @pa_inwsr_modestatus
         ,INWSR_LST_UPD_BY        = @pa_login_name        
         ,INWSR_LST_UPD_DT        = getdate()        
         ,INWSR_RMKS              = @pa_rmks
		 ,INWSR_NO_OF_IMAGES	  = @pa_no_of_images
		 ,INWSR_IMAGE_FLG		  = @PA_INWSR_IMAGE_FLG
        
      WHERE  INWSR_ID            = CONVERT(INT,@pa_id)             
      AND    INWSR_deleted_ind   = 1        
      
	  ---------ADDED BY PANKAJ FOR OTHER SLIP IMAGE DELETE IF COUNT IS 1  
	  SELECT @L_COUNT_OF_TOTAL_IMAGES_IN_INWARD_REG = INWSR_NO_OF_IMAGES FROM INWARD_SLIP_REG
	  WHERE INWSR_ID = CONVERT(INT,@pa_id)
	
	  IF @L_COUNT_OF_TOTAL_IMAGES_IN_INWARD_REG = '1'
	  BEGIN
		DELETE FROM INWARD_DOC_PATH_OTHERS 
		WHERE INDPO_INWARD_ID = CONVERT(INT,@pa_id)
	  END
	  ---------ADDED BY PANKAJ FOR OTHER SLIP IMAGE DELETE IF COUNT IS 1

      SET @l_error = @@error        
      IF @l_error <> 0        
      BEGIN        
      --        
        IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)        
        BEGIN        
        --        
          SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)        
        --        
        END        
        ELSE        
        BEGIN        
        --        
          SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'        
        --        
        END        
        
        ROLLBACK TRANSACTION         
        
        RETURN        
      --        
      END        
      ELSE        
      BEGIN        
      --    
				SET @@SSQL = 'TRUNCATE TABLE #VOUCHERNO'
				SET @@SSQL = @@SSQL + ' INSERT INTO #VOUCHERNO SELECT TOP 1 LDG_VOUCHER_NO from ledger' + convert(varchar,@@FINID) + ' where LDG_VOUCHER_TYPE = 2 AND LDG_VOUCHER_DT = convert(datetime,''' + @pa_rece_dt + ''',103) AND LDG_REF_NO = ''' + @@refno + ''' AND LDG_CREATED_BY = ''INWARDENTRY'' AND LDG_DELETED_IND = 1 and LDG_DPM_ID = ' + CONVERT(VARCHAR,@l_dpm_id)
				EXEC(@@SSQL)
				
				SELECT TOP 1 @@vch_no = ISNULL(VCHNO,0) FROM #VOUCHERNO
				SET @l_pay_mode = CASE WHEN @pa_pay_mode = 'CASH' THEN 'C' ELSE 'B' END
				SET @@vch_values = @l_pay_mode + '|*~|' +  convert(varchar,ISNULL(@pa_bankid,0)) + '|*~|' + CONVERT(VARCHAR,@pa_ufcharge) + '|*~|*|~*P|*~|' + convert(varchar,@l_dpam_id) + '|*~|0|*~||*~|' + CONVERT(VARCHAR,@pa_ufcharge) + '|*~|' + ISNULL(@pa_cheque_no,'') + '|*~|' + LEFT(ISNULL(@pa_rmks,''),250) + '|*~|' + isnull(@pa_bankaccno_no,'') + '|*~|*|~*'
				IF (ISNULL(@@vch_no,0) = 0)
				BEGIN
					  if ltrim(rtrim(isnull(@pa_ufcharge,''))) <> '' 
					  begin
							if convert(numeric(18,2),ltrim(rtrim(isnull(@pa_ufcharge,'0')))) > 0 
							begin 
								Exec pr_ins_upd_ledgerR '0','INS','INWARDENTRY',@l_dpm_id,2,'01','',@@refno,@pa_rece_dt,@@vch_values,0,'*|~*','|*~|',''      
							end
					  end
				END
				ELSE
				BEGIN
					Exec pr_ins_upd_ledgerR '0','EDT','INWARDENTRY',@l_dpm_id,2,'01',@@vch_no,@@refno,@pa_rece_dt,@@vch_values,0,'*|~*','|*~|',''      
				END
				--set @t_errorstr = ' ' 
                  SET  @t_errorstr  = CONVERT(VARCHAR,@pa_id)+'-'+CONVERT(VARCHAR,@l_dpam_id) 

        COMMIT TRANSACTION        
      --        
      END        
    --        
    END   --EDIT ENDS        
            
    IF @PA_ACTION = 'DEL'        
    BEGIN        
    --        
      BEGIN TRANSACTION        
        
      UPDATE INWARD_SLIP_REG        
      SET    INWSR_deleted_ind   = 0        
            ,INWSR_lst_upd_dt    = getdate()        
            ,INWSR_lst_upd_by    = @pa_login_name         
      WHERE  INWSR_id            = CONVERT(INT,@pa_id)             
      AND    INWSR_deleted_ind   = 1        
        
      SET @l_error = @@error        
      IF @l_error <> 0        
      BEGIN        
      --        
        IF EXISTS(SELECT Err_Description FROM tblerror WHERE Err_Code = @l_error)        
        BEGIN        
        --        
          SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': '+ Err_Description FROM tblerror WHERE Err_Code = CONVERT(VARCHAR,@l_error)        
        --        
        END        
        ELSE        
        BEGIN        
        --        
          SELECT @t_errorstr = 'ERROR '+CONVERT(VARCHAR,@l_error) + ': Can not process, Please contact your administrator!'        
        --        
        END        
        
        ROLLBACK TRANSACTION         
        
        RETURN        
      --        
      END        
      ELSE        
      BEGIN        
      --        

print @@FINID
print @@refno
print @l_dpm_id
print @@SSQL


			SET @@SSQL = 'TRUNCATE TABLE #VOUCHERNO'
			SET @@SSQL = @@SSQL + ' INSERT INTO #VOUCHERNO SELECT TOP 1 LDG_VOUCHER_NO from ledger' + convert(varchar,@@FINID) + ' where LDG_VOUCHER_TYPE = 2  AND LDG_REF_NO = ''' + @@refno + ''' AND LDG_CREATED_BY = ''INWARDENTRY'' AND LDG_DELETED_IND = 1 and LDG_DPM_ID = ' + CONVERT(VARCHAR,@l_dpm_id)

			EXEC(@@SSQL)

			SELECT TOP 1 @@vch_no = ISNULL(VCHNO,0) FROM #VOUCHERNO



			

			IF (ISNULL(@@vch_no,0) <> 0)
			BEGIN
				Exec pr_ins_upd_ledgerR '0','DEL','INWARDENTRY',@l_dpm_id,2,'01',@@vch_no,@@refno,@pa_rece_dt,'',0,'*|~*','|*~|',''      
			END


        COMMIT TRANSACTION        
      --        
      END        
    --        
END        
  SET @pa_errmsg = @t_errorstr  
-- IF left(ltrim(rtrim(@pa_errmsg)),5) <> 'ERROR'  
--  BEGIN  
--    
--    --exec pr_checkslipno '','1', @pa_dpm_dpid,@pa_boid,@pa_slip_no,@pa_login_name,''  
--    
--  END       
--        
END

GO
