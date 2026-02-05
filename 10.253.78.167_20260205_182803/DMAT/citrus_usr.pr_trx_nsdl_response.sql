-- Object: PROCEDURE citrus_usr.pr_trx_nsdl_response
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--pr_trx_nsdl_response '','','bulk','c:\BulkInsDbfolder\inst10483offmarket.txt','*|~*','|*~|',''
--CHANGE IN STATUS LOGIC
 --DEMRM_STATUS = CASE WHEN  TMPDPRESP_ACCPREJFLG = 'A' THEN 'A2' WHEN TMPDPRESP_ACCPREJFLG = 'R' THEN 'R2' WHEN TMPDPRESP_TRANFLG = 'A' THEN 'A1' WHEN TMPDPRESP_TRANFLG = 'R' THEN 'R1' END  
CREATE procedure [citrus_usr].[pr_trx_nsdl_response](    @pa_exch          VARCHAR(20)  
										,@pa_login_name    VARCHAR(20)  
										,@pa_mode          VARCHAR(10)  																																
										,@pa_db_source     VARCHAR(250)  
                                        ,@pa_excsm_Id      Integer
										,@pa_batchno       varchar(10)
										,@pa_batchstatus   Char(1)
                                        ,@pa_trx_mode      VarChar(10) 
										,@rowdelimiter     CHAR(4) =     '*|~*'    
										,@coldelimiter     CHAR(4) =     '|*~|'    
										,@pa_errmsg        VARCHAR(8000) output  
									)    
AS  
begin
--
Declare @L_DPM_ID int
Declare @@l_count integer
Declare @@ssql varchar(8000)
,@l_slip_no_rmks_yn char(1)

select   @l_slip_no_rmks_yn  = BITRM_BIT_LOCATION from bitmap_ref_mstr where bitrm_parent_cd = 'SLIPNO_IN_RMKS' and bitrm_deleted_ind = 1
   

 SELECT @L_DPM_ID = DPM_ID FROM DP_MSTR WHERE DEFAULT_DP = @PA_EXCSM_ID AND DPM_DELETED_IND =1  
IF @pa_trx_mode ='DPMNRM' 
 BEGIN -- Start for trx_mode (DPMTRX)
	  IF @pa_mode = 'BULK'
			BEGIN
			--
					delete from tmp_dpmresponse_source
					SET @@ssql ='BULK INSERT tmp_dpmresponse_source from ''' + @pa_db_source + ''' WITH 
					(
						FIELDTERMINATOR = ''\n'',
						ROWTERMINATOR = ''\n''
									
					)'

					EXEC(@@ssql)
		set rowcount 1
		delete from tmp_dpmresponse_source 
		set rowcount 0
					update tmp_dpmresponse_source set value = ltrim(rtrim(value)) 

		select @@l_count = count(*) from tmp_dpmresponse_source 
	   
		set @@l_count = @@l_count - 1 
	   
		set rowcount @@l_count

					TRUNCATE TABLE tmp_dpmresponse

					insert into tmp_dpmresponse 
					select substring(value,1,7)
											,substring(value,8,2)
											,substring(value,10,5)
											,substring(value,15,3)
											,substring(value,18,1)
											,substring(value,19,9)
											,substring(value,28,20)
											,substring(value,48,35)
											,substring(value,83,35)
											,substring(value,118,12)
											,substring(value,130,1)
											,substring(value,131,7)
											,substring(value,138,20)
						FROM  tmp_dpmresponse_source   


			--
			END


			IF EXISTS (SELECT DISTINCT TMPDPMRESP_TRANTYP FROM TMP_DPMRESPONSE WHERE TMPDPMRESP_TRANTYP='901')
			BEGIN
			--
					UPDATE D 
					SET    DEMRM_STATUS = CASE WHEN  TMPDPMRESP_ACCPREJFLG = 'A' THEN 'A2' WHEN TMPDPMRESP_ACCPREJFLG = 'R' THEN 'R2' WHEN TMPDPMRESP_TRANFLG = 'A' THEN 'A1' WHEN TMPDPMRESP_TRANFLG = 'R' THEN 'R1' END  
						  ,DEMRM_TRANSACTION_NO = TMPDPMRESP_INSTID
					FROM   DEMAT_REQUEST_MSTR D 
						  ,TMP_DPMRESPONSE T 
						  ,DP_ACCT_MSTR DPAM
					WHERE (DEMRM_ID = TMPDPMRESP_SENDREFNO1)
					AND    DEMRM_SLIP_SERIAL_NO = TMPDPMRESP_INTREFNO 
					AND    DEMRM_DPAM_ID = DPAM.DPAM_ID
					AND    DPAM.DPAM_DPM_ID   = @L_DPM_ID
			--
			End
            IF EXISTS (SELECT DISTINCT TMPDPMRESP_TRANTYP FROM TMP_DPMRESPONSE WHERE TMPDPMRESP_TRANTYP='902')
			BEGIN
			--
					UPDATE D 
					SET    REMRM_TRANSACTION_NO = TMPDPMRESP_INSTID
 						  ,REMRM_STATUS = CASE WHEN  TMPDPMRESP_ACCPREJFLG = 'A' THEN 'A2' WHEN TMPDPMRESP_ACCPREJFLG = 'R' THEN 'R2' WHEN TMPDPMRESP_TRANFLG = 'A' THEN 'A1' WHEN TMPDPMRESP_TRANFLG = 'R' THEN 'R1' END  
					FROM   REMAT_REQUEST_MSTR D ,DP_ACCT_MSTR DPAM
						  ,TMP_DPMRESPONSE    T 
					WHERE  REMRM_ID             = TMPDPMRESP_SENDREFNO1
					AND    REMRM_SLIP_SERIAL_NO = TMPDPMRESP_INTREFNO 
					AND    REMRM_DPAM_ID        = DPAM.DPAM_ID
					AND    DPAM.DPAM_DPM_ID     = @L_DPM_ID
			--		
			End
			

            IF EXISTS (SELECT DISTINCT TMPDPMRESP_TRANTYP FROM TMP_DPMRESPONSE WHERE TMPDPMRESP_TRANTYP='900')
			BEGIN
			--
					UPDATE D 
					SET    REMRM_TRANSACTION_NO = TMPDPMRESP_INSTID
 						  ,REMRM_STATUS = CASE WHEN  TMPDPMRESP_ACCPREJFLG = 'A' THEN 'A2' WHEN TMPDPMRESP_ACCPREJFLG = 'R' THEN 'R2' WHEN TMPDPMRESP_TRANFLG = 'A' THEN 'A1' WHEN TMPDPMRESP_TRANFLG = 'R' THEN 'R1' END  
					FROM   REMAT_REQUEST_MSTR D ,DP_ACCT_MSTR DPAM
						  ,TMP_DPMRESPONSE    T 
					WHERE  REMRM_ID             = TMPDPMRESP_SENDREFNO1
					AND    REMRM_SLIP_SERIAL_NO = TMPDPMRESP_INTREFNO 
					AND    REMRM_DPAM_ID        = DPAM.DPAM_ID
					AND    DPAM.DPAM_DPM_ID     = @L_DPM_ID
			--		
			End
			IF EXISTS (SELECT DISTINCT TMPDPMRESP_TRANTYP FROM TMP_DPMRESPONSE WHERE TMPDPMRESP_TRANTYP NOT IN ('901','902'))
			BEGIN
			--	               
                    
			   		UPDATE D 
					SET    DPTD_TRANS_NO = TMPDPMRESP_INSTID
						  ,DPTD_STATUS   = CASE WHEN @pa_batchstatus='R' THEN 'R1' ELSE CASE WHEN  TMPDPMRESP_ACCPREJFLG = 'A' THEN 'A2' WHEN TMPDPMRESP_ACCPREJFLG = 'R' THEN 'R2' WHEN TMPDPMRESP_TRANFLG = 'A' THEN 'A1' WHEN TMPDPMRESP_TRANFLG = 'R' THEN 'R1' END  END				      
					FROM   DP_TRX_DTLS     D 
						  ,TMP_DPMRESPONSE T  
						  ,DP_ACCT_MSTR DPAM
							WHERE  TMPDPMRESP_TRANTYP   = DPTD_TRASTM_CD 
							AND    DPTD_INTERNAL_REF_NO = case when @l_slip_no_rmks_yn = '1' then TMPDPMRESP_SENDREFNO1        else TMPDPMRESP_INTREFNO end 
						                         
							--AND    DPTD_SLIP_NO         = TMPDPMRESP_INTREFNO 
							--AND    DPTD_ID              = TMPDPMRESP_INTREFNO 
							AND    DPTD_TRASTM_CD NOT IN ('901','902')
							AND    DPTD_DPAM_ID         = DPAM.DPAM_ID
							AND    DPAM.DPAM_DPM_ID     = @L_DPM_ID
                   
			--		
			End
            IF EXISTS (SELECT DISTINCT TMPDPMRESP_TRANTYP FROM TMP_DPMRESPONSE WHERE TMPDPMRESP_TRANTYP in ('908','909','911','910','916','917','919','918','999'))
			BEGIN
			--
					UPDATE D 
					SET    PLDT_TRANS_NO = TMPDPMRESP_INSTID
						  ,PLDT_STATUS   = CASE WHEN  TMPDPMRESP_ACCPREJFLG = 'A' THEN 'A2' WHEN TMPDPMRESP_ACCPREJFLG = 'R' THEN 'R2' WHEN TMPDPMRESP_TRANFLG = 'A' THEN 'A1' WHEN TMPDPMRESP_TRANFLG = 'R' THEN 'R1' END  				      
					FROM   nsdl_pledge_dtls  D 
						  ,TMP_DPMRESPONSE T 
						  ,DP_ACCT_MSTR DPAM
					WHERE (PLDT_ID = TMPDPMRESP_SENDREFNO1)
					AND    PLDT_SLIP_NO = TMPDPMRESP_INTREFNO 
					AND    PLDT_DPAM_ID = DPAM.DPAM_ID
					AND    DPAM.dpam_DPM_ID   = @L_DPM_ID
			--
			End
 
					/*For Update of batch no in Nsdl Batch No */   
					UPDATE BATCHNO_NSDL_MSTR SET BATCHN_STATUS = @PA_BATCHSTATUS				
					WHERE BATCHN_NO = @PA_BATCHNO AND BATCHN_DPM_ID = @L_DPM_ID AND BATCHN_TYPE = 'T'
 
--
   END -- end for trx_mode (DPMTRX)
Else
	BEGIN -- Start for trx_mode (DPMVR)
     	  IF @pa_mode = 'BULK'
			BEGIN
			--					
					delete from tmp_dpmresponse_source_vr					
					SET @@ssql ='BULK INSERT tmp_dpmresponse_source from ''' + @pa_db_source + ''' WITH 
					(
						FIELDTERMINATOR = ''\n'',
						ROWTERMINATOR = ''\n''
									
					)'

					EXEC(@@ssql)
		set rowcount 1
		delete from tmp_dpmresponse_source_vr 
		set rowcount 0
					update tmp_dpmresponse_source_vr set value = ltrim(rtrim(value)) 

		select @@l_count = count(*) from tmp_dpmresponse_source_vr 
	   
		set @@l_count = @@l_count - 1 
	   
		set rowcount @@l_count

					TRUNCATE TABLE tmp_dpmvr_response

					insert into tmp_dpmvr_response 
					select substring(value,1,7)
											,substring(value,8,2)
											,substring(value,10,5)
											,substring(value,15,3)
											,substring(value,18,1)
											,substring(value,19,9)
											,substring(value,28,20)
											,substring(value,48,35)
											,substring(value,83,35)
											,substring(value,117,2)
											,substring(value,119,11)
						FROM  tmp_dpmresponse_source_vr   


			--
			END


			IF EXISTS (SELECT DISTINCT TMPDPMVR_TRANTYP FROM TMP_DPMVR_RESPONSE WHERE TMPDPMVR_TRANTYP='901')
			BEGIN
			--
					UPDATE D 
					SET    DEMRM_DRF_NO = TMPDPMVR_INSTID
						  ,DEMRM_STATUS = TMPDPMVR_TRANSTAT
						  ,DEMRM_TRANSACTION_NO = TMPDPMVR_INSTID
					FROM   DEMAT_REQUEST_MSTR D 
						  ,TMP_DPMVR_RESPONSE T 
						  ,DP_ACCT_MSTR DPAM
					WHERE (DEMRM_ID = TMPDPMVR_SENDREFNO1)
					AND    DEMRM_SLIP_SERIAL_NO = TMPDPMVR_INTREFNO 
					AND    DEMRM_DPAM_ID = DPAM.DPAM_ID
					AND    DPAM.DPAM_DPM_ID   = @L_DPM_ID
			--
			End
			IF EXISTS (SELECT DISTINCT TMPDPMVR_TRANTYP FROM TMP_DPMVR_RESPONSE WHERE TMPDPMVR_TRANTYP='902')
			BEGIN
			--
					UPDATE D 
					SET    REMRM_RRF_NO = TMPDPMVR_INSTID
						  ,REMRM_TRANSACTION_NO = TMPDPMVR_INSTID
 						  ,REMRM_STATUS = TMPDPMVR_TRANSTAT
					FROM   REMAT_REQUEST_MSTR D ,DP_ACCT_MSTR DPAM
						  ,TMP_DPMVR_RESPONSE    T 
					WHERE  REMRM_ID             = TMPDPMVR_SENDREFNO1
					AND    REMRM_SLIP_SERIAL_NO = TMPDPMVR_INTREFNO 
					AND    REMRM_DPAM_ID        = DPAM.DPAM_ID
					AND    DPAM.DPAM_DPM_ID     = @L_DPM_ID
			--		
			End
			
			IF EXISTS (SELECT DISTINCT TMPDPMVR_TRANTYP FROM TMP_DPMVR_RESPONSE WHERE TMPDPMVR_TRANTYP NOT IN ('901','902'))
			BEGIN
			--
	    
			   		UPDATE D 
					SET    DPTD_TRANS_NO = TMPDPMVR_INSTID
						  ,DPTD_STATUS   = TMPDPMVR_TRANSTAT
					FROM   DP_TRX_DTLS     D 
						  ,TMP_DPMVR_RESPONSE T  
						  ,DP_ACCT_MSTR DPAM
							WHERE  TMPDPMVR_TRANTYP   = DPTD_TRASTM_CD 
							AND    DPTD_INTERNAL_REF_NO = case when @l_slip_no_rmks_yn = '1' then TMPDPMVR_SENDREFNO1        else TMPDPMVR_INTREFNO end 
							--AND    DPTD_SLIP_NO         = TMPDPMRESP_INTREFNO 
							--AND    DPTD_ID              = TMPDPMVR_INTREFNOS 
							AND    DPTD_TRASTM_CD NOT IN ('901','902')
							AND    DPTD_DPAM_ID         = DPAM.DPAM_ID
							AND    DPAM.DPAM_DPM_ID     = @L_DPM_ID
			--		
			End
					/*For Update of batch no in Nsdl Batch No */   
					UPDATE BATCHNO_NSDL_MSTR SET BATCHN_STATUS = 'VR'+ @PA_BATCHSTATUS				
					WHERE BATCHN_NO = @PA_BATCHNO AND BATCHN_DPM_ID = @L_DPM_ID AND BATCHN_TYPE = 'T'
	END   -- End for trx_mode (DPMVR)
END

GO
