-- Object: PROCEDURE citrus_usr.PR_CDSL_IMP_TRX_poa
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--begin tran
--PR_CDSL_IMP_TRX 'HO','50' ,3,'','','EP','1',''
--rollback
--select * from used_slip where ltrim(rtrim(USES_SLIP_NO)) = '5036'
--update tmp_dp_trx_dtls set tmpdptd_acct_id ='12345678' , TMPDPTD_INTERNAL_REF_NO = ''
--DELETE  FROM DPTD_MAK

CREATE PROCEDURE [citrus_usr].[PR_CDSL_IMP_TRX_poa] (  
@PA_LOGIN_NAME VARCHAR(20),  
@PA_BATCH_NO VARCHAR(10)  ,
@PA_EXCSM_ID INT,
@pa_mode          VARCHAR(10),  																																
@pa_db_source     VARCHAR(250),  
@PA_TRX_TAB VARCHAR(100),
@pa_task_id  NUMERIC,
@PA_ERRMSG   VARCHAR(1000) output

)  
AS   
BEGIN  
SET NOCOUNT ON  
  
DECLARE  @L_MAX_DPTDC_ID1 BIGINT 
, @L_MAX_DPTDC_ID2 BIGINT 
, @L_MAX_DPTDC_DTLS_ID1 BIGINT 
, @L_MAX_DPTDC_DTLS_ID2 BIGINT
, @L_DPM_ID BIGINT 
, @l_err_mstr varchar(8000)
, @l_uses_id numeric(10,0)
, @L_ERR_MISSING_ISIN varchar(8000)

 declare @l_id1 numeric(10,0)
, @l_id2 numeric(10,0)

DECLARE @@ssql varchar(8000)

SELECT @l_dpm_id = DPM_ID FROM DP_MSTR WHERE DPM_EXCSM_ID = @PA_EXCSM_ID AND DEFAULT_DP = @PA_EXCSM_ID AND DPM_DELETED_IND = 1   --

IF @pa_mode = 'BULK'  
BEGIN
--
  IF @PA_TRX_TAB  = 'OFFM'
  BEGIN
  --
    
    truncate table tmp_brok_import_cdsl
    
				SET @@ssql ='BULK INSERT tmp_brok_import_cdsl from ''' + @pa_db_source + ''' WITH 
				(
							FIELDTERMINATOR = '''',
								ROWTERMINATOR =  ''' +nchar(32) + '''
				)'
				
				EXEC(@@ssql)
				
				
				
				
				INSERT INTO TMP_DP_OFFM_DTLS_CDSL
				(TMPOFFM_ACCT_ID
				,TMPOFFM_REQUEST_DT
				,TMPOFFM_SLIP_NO
				,TMPOFFM_ISIN
				,TMPOFFM_BATCH_NO
				,TMPOFFM_LINE_NO
				,TMPOFFM_QTY
				,TMPOFFM_INTERNAL_REF_NO
				,TMPOFFM_TRANS_NO
				,TMPOFFM_MKT_TYPE
				,TMPOFFM_SETTLEMENT_NO
				,TMPOFFM_EXECUTION_DT
				,TMPOFFM_OTHER_SETTLEMENT_TYPE
				,TMPOFFM_OTHER_SETTLEMENT_NO
				,TMPOFFM_COUNTER_DP_ID
				,TMPOFFM_COUNTER_CMBP_ID
				,TMPOFFM_COUNTER_DEMAT_ACCT_NO
				,TMPOFFM_TRASTM_CD
				,TMPOFFM_DTLS_ID
				,TMPOFFM_STATUS
				,TMPOFFM_INTERNAL_TRASTM
				,TMPOFFM_BROKERBATCH_NO
				,TMPOFFM_BROKER_INTERNAL_REF_NO 
				)
				select Substring(value,9, 16) 
				,Getdate()
				,Substring(value,57, 16)
				,Substring(value,40, 12) 
				,'' 
				,0 
				,Substring(value,52, 15)
				,'' 
				,'' 
				,case when len(value) > 86 Then Substring(value,86, 1) Else '' end
				,case when len(value) > 86 Then Substring(value,87, 7) else '' end
				,Substring(value,1, 8)
				,''
				,''
				,Substring(value,93, 8) 
				,Substring(value,111, 8) 
				,Substring(value,24, 16) 
				,''
				,0 
				,'P' 
				,'OFFM'
				,'' 
				,Substring(value,67, 16)
    from tmp_brok_import_cdsl
  --
  END
  IF @PA_TRX_TAB  = 'INTERDP'
		BEGIN
		--
     truncate table tmp_brok_import_cdsl
								
					
					SET @@ssql ='BULK INSERT tmp_brok_import_cdsl	 from ''' + @pa_db_source + ''' WITH 
					(
								FIELDTERMINATOR = ''\n'',
								ROWTERMINATOR = ''\n''
					)'
								
				 EXEC(@@ssql)
		--
  END
  IF @PA_TRX_TAB  = 'EP'
		BEGIN
		--
     truncate table tmp_brok_import_cdsl
												
					
					SET @@ssql ='BULK INSERT tmp_brok_import_cdsl	 from ''' + @pa_db_source + ''' WITH 
					(
								FIELDTERMINATOR = ''' +char(32) + ''',
								ROWTERMINATOR =  ''' +char(32) + '''
					)'
												
				 EXEC(@@ssql)
		--
  END
  IF @PA_TRX_TAB  = 'ONM'
		BEGIN
		--
     truncate table tmp_brok_import_cdsl
												
					
					SET @@ssql ='BULK INSERT tmp_brok_import_cdsl	 from ''' + @pa_db_source + ''' WITH 
					(
							FIELDTERMINATOR = ''' +char(32) + ''',
								ROWTERMINATOR =  ''' +char(32) + '''
					)'
												
				 EXEC(@@ssql)
		--
  END
--
END

SELECT @l_dpm_id = DPM_ID FROM DP_MSTR WHERE DPM_EXCSM_ID = @PA_EXCSM_ID AND DEFAULT_DP = @PA_EXCSM_ID AND DPM_DELETED_IND = 1   --
	
	
create table #tmp_dptdc (ID1 bigint  IDENTITY( 1, 1),DPTDC_SLIP_NO varchar(20))	
create table #tmp_dptdc_intdp (ID1 bigint  IDENTITY(1, 1),DPTDC_SLIP_NO varchar(20))	
create table #tmp_dptdc_np (ID1 bigint  IDENTITY(1, 1),DPTDC_SLIP_NO varchar(20))	
create table #tmp_dptdc_ep (ID1 bigint IDENTITY(1, 1),DPTDC_SLIP_NO varchar(20))	




	
IF @PA_TRX_TAB  = 'OFFM'
BEGIN
--
		
		BEGIN
		--

               UPDATE TMP_DP_OFFM_DTLS_CDSL SET  TMPOFFM_SLIP_NO=ltrim(rtrim(TMPOFFM_SLIP_NO))

		  
		        UPDATE TMP_DP_OFFM_DTLS_CDSL SET  TMPOFFM_SETTLEMENT_NO='',TMPOFFM_MKT_TYPE='' 
                WHERE TMPOFFM_SETTLEMENT_NO='0000000' OR TMPOFFM_MKT_TYPE='000000'
				
                 insert INTO #tmp_dptdc(DPTDC_SLIP_NO)
				select distinct TMPOFFM_SLIP_NO   FROM TMP_DP_OFFM_DTLS_CDSL

                

				/*SELECT @L_MAX_DPTDC_ID1 = ISNULL(MAX(DPTDC_ID),0),@L_MAX_DPTDC_DTLS_ID1 = ISNULL(MAX(DPTDC_DTLS_ID),0)  FROM DPTDC_MAK WHERE DPTDC_DELETED_IND = 0  

				SELECT @L_MAX_DPTDC_ID2 = ISNULL(MAX(DPTDC_ID),0) , @L_MAX_DPTDC_DTLS_ID2 = ISNULL(MAX(DPTDC_DTLS_ID),0) FROM DP_TRX_DTLS_CDSL WHERE DPTDC_DELETED_IND = 1

				IF @L_MAX_DPTDC_ID1 < @L_MAX_DPTDC_ID2 
				BEGIN
				--
						SET @L_MAX_DPTDC_ID1 = @L_MAX_DPTDC_ID2 
				--
				END

				IF @L_MAX_DPTDC_DTLS_ID1 < @L_MAX_DPTDC_DTLS_ID2 
				BEGIN
				--
						SET @L_MAX_DPTDC_DTLS_ID1 = @L_MAX_DPTDC_DTLS_ID2 
				--
				END*/

               

				IF EXISTS(SELECT TOP 1 ISNULL(DPTDC_ID,0) FROM DP_TRX_DTLS_CDSL , DP_ACCT_MSTR WHERE DPTDC_BROKERBATCH_NO IN (SELECT TMPOFFM_BROKERBATCH_NO FROM TMP_DP_OFFM_DTLS_CDSL) AND DPAM_ID = DPTDC_DPAM_ID AND DPAM_DPM_ID = @l_dpm_id AND DPAM_DELETED_IND = 1 AND DPTDC_DELETED_IND = 1 and DPTDC_INTERNAL_TRASTM like '%BO%') 
						OR EXISTS(SELECT TOP 1 ISNULL(DPTDC_ID,0) FROM DPTDC_MAK, DP_ACCT_MSTR WHERE DPTDC_BROKERBATCH_NO IN (SELECT TMPOFFM_BROKERBATCH_NO FROM TMP_DP_OFFM_DTLS_CDSL) AND DPAM_ID = DPTDC_DPAM_ID AND DPAM_DPM_ID = @l_dpm_id AND DPAM_DELETED_IND  = 1 AND DPTDC_DELETED_IND = 0 and DPTDC_INTERNAL_TRASTM like '%BO%')
				BEGIN
				--
						SET @PA_ERRMSG = 'SELECTED BATCH NO ALREADY EXISTS.'
						SELECT ERRMSG =  @PA_ERRMSG, ERROR ='B'

						UPDATE filetask
						SET    usermsg = 'File Could Not Be Uploaded Please Verify. ERROR : Selected Batch No Already Exists: ' + @PA_BATCH_NO
						,      STATUS = 'FAILED' 
						WHERE  task_id = @pa_task_id

						return

				--
				END


    
				
    
    select @l_err_mstr = isnull(replace(citrus_usr.fn_merge_str('CDSL_ACCT_OFFM',0,''),',',''),'')
    SELECT @L_ERR_MISSING_ISIN = isnull(replace(citrus_usr.fn_merge_str('CDSL_ISIN_OFFM',0,''),',',''),'')

    IF @l_err_mstr <> ''
	BEGIN
	--
			UPDATE filetask
			SET    usermsg = 'File Could Not Be Uploaded Please Verify. ERROR : Following Client are Missing Or Inactive : ' + @l_err_mstr
			,      status = 'FAILED'
			WHERE  task_id = @pa_task_id

			
			
			return
	--
    END
    IF @L_ERR_MISSING_ISIN <> ''
    BEGIN
            UPDATE filetask
			SET    usermsg = 'File Could Not Be Uploaded Please Verify. ERROR : Following ISINs are Missing : ' + @L_ERR_MISSING_ISIN
			,      status = 'FAILED'
			WHERE  task_id = @pa_task_id

          RETURN 
    END 
   
    if exists(select TMPOFFM_SLIP_NO from TMP_DP_OFFM_DTLS_CDSL, used_slip 
              where  isnumeric(replace(rtrim(ltrim(TMPOFFM_SLIP_NO)),ltrim(rtrim(USES_SERIES_TYPE)),'')) = 1
              and    ltrim(rtrim(USES_SERIES_TYPE)) + convert(varchar,convert(numeric,replace(rtrim(ltrim(TMPOFFM_SLIP_NO)),ltrim(rtrim(USES_SERIES_TYPE)),''))) = ltrim(rtrim(USES_SERIES_TYPE)) + ltrim(rtrim(USES_SLIP_NO))
              )
    begin

     SELECT distinct @L_ERR_MISSING_ISIN = ISNULL(@L_ERR_MISSING_ISIN,'')  +  TMPOFFM_SLIP_NO  + ',' from TMP_DP_OFFM_DTLS_CDSL, used_slip 
	  where  isnumeric(replace(rtrim(ltrim(TMPOFFM_SLIP_NO)),ltrim(rtrim(USES_SERIES_TYPE)),'')) = 1
      and    ltrim(rtrim(USES_SERIES_TYPE)) +  convert(varchar,convert(numeric,replace(rtrim(ltrim(TMPOFFM_SLIP_NO)),ltrim(rtrim(USES_SERIES_TYPE)),''))) = ltrim(rtrim(USES_SERIES_TYPE)) + ltrim(rtrim(USES_SLIP_NO))

        UPDATE filetask
		SET    usermsg = 'File Could Not Be Uploaded Please Verify. ERROR : Following Slips are already used : ' + @L_ERR_MISSING_ISIN
		,      status = 'FAILED'
		WHERE  task_id = @pa_task_id

    return 
  
    end 

-- Slip Issue Validation 

set @L_ERR_MISSING_ISIN = ''


    if not exists(select TMPOFFM_SLIP_NO,TMPOFFM_BO_ID 
                  from   TMP_DP_OFFM_DTLS_CDSL
                       , slip_issue_mstr  
                       , dp_acct_mstr 
                  where  rtrim(ltrim(TMPOFFM_SLIP_NO)) like ltrim(rtrim(SLIIM_SERIES_TYPE)) + '%' 
                  and isnumeric(replace(rtrim(ltrim(TMPOFFM_SLIP_NO)),ltrim(rtrim(SLIIM_SERIES_TYPE)),'')) = 1
                  and    convert(numeric,replace(rtrim(ltrim(TMPOFFM_SLIP_NO)),ltrim(rtrim(SLIIM_SERIES_TYPE)),'')) between convert(numeric,SLIIM_SLIP_NO_FR) and convert(numeric,SLIIM_SLIP_NO_TO) 
                  and SLIIM_ENTM_ID = dpam_crn_no 
                  and dpam_sba_no = TMPOFFM_BO_ID
                  union 
                  select TMPOFFM_SLIP_NO
                        ,TMPOFFM_BO_ID 
                  from   TMP_DP_OFFM_DTLS_CDSL
                       , slip_issue_mstr_POA  
                  where rtrim(ltrim(TMPOFFM_SLIP_NO)) like ltrim(rtrim(SLIIM_SERIES_TYPE)) + '%' 
                  and isnumeric(replace(rtrim(ltrim(TMPOFFM_SLIP_NO)),ltrim(rtrim(SLIIM_SERIES_TYPE)),'')) = 1  
                  and   convert(numeric,replace(rtrim(ltrim(TMPOFFM_SLIP_NO)),ltrim(rtrim(SLIIM_SERIES_TYPE)),'')) between convert(numeric,SLIIM_SLIP_NO_FR) and convert(numeric,SLIIM_SLIP_NO_TO) 
                  AND SLIIM_DELETED_IND = 1 
                  )
    begin

        SELECT distinct @L_ERR_MISSING_ISIN = ISNULL(@L_ERR_MISSING_ISIN,'')  +   TMPOFFM_SLIP_NO + ':' + TMPOFFM_BO_ID + ',' from TMP_DP_OFFM_DTLS_CDSL

        UPDATE filetask
		SET    usermsg = 'File Could Not Be Uploaded Please Verify. ERROR : Following Slips are not Issued : ' + @L_ERR_MISSING_ISIN
		,      status = 'FAILED'
		WHERE  task_id = @pa_task_id

        return 
  
    end 


                begin transaction

                select @L_MAX_DPTDC_ID1 = bitrm_bit_location from bitmap_ref_mstr where bitrm_parent_cd = 'DPTDC_ID' 
                select @L_MAX_DPTDC_DTLS_ID1 = bitrm_bit_location from bitmap_ref_mstr where bitrm_parent_cd = 'DPTDC_DTLS_ID' 
                

              

                select @l_id1 = count (distinct TMPOFFM_SLIP_NO) from TMP_DP_OFFM_DTLS_CDSL
                select @l_id2 = count (*) from TMP_DP_OFFM_DTLS_CDSL

                update bitmap_ref_mstr set bitrm_bit_location =  @L_MAX_DPTDC_DTLS_ID1+@l_id1+1  where bitrm_parent_cd = 'DPTDC_DTLS_ID' 
                update bitmap_ref_mstr set bitrm_bit_location =  @L_MAX_DPTDC_ID1+@l_id2  where bitrm_parent_cd = 'DPTDC_ID' 
                
                

                commit transaction

-- Slip Issue Validation 

/*
 select @l_err_mstr = isnull(replace(citrus_usr.fn_merge_str('CDSL_CMBP_OFFM',0,''),',',''),'')
				
						IF @l_err_mstr  <> ''
						BEGIN
						--
								UPDATE filetask
								SET    usermsg = 'File Could Not Be Uploaded Please Verify. ERROR : Following Slip nos are not issued Please Verify : ' + @l_err_mstr
								,      STATUS = 'FAILED' 
								WHERE  task_id = @pa_task_id

								return

						--
						END
    
    select @l_err_mstr = isnull(replace(citrus_usr.fn_merge_str('CDSL_IMP_OFF',0,''),',',''),'')
    
    IF @l_err_mstr <> ''
				BEGIN
				--
						UPDATE filetask
						SET    usermsg = 'ERROR : Following Slip nos are Already Used Please Verify : ' + @l_err_mstr
						,      status = 'FAILED'
						WHERE  task_id = @pa_task_id

						
						
						return
				--
    END

*/

    UPDATE  TMP
				SET     TMPOFFM_CMBP_YN = CASE WHEN isnull(citrus_usr.fn_acct_entp(A.dpam_id,'CMBP_ID'),'') ='' THEN 'N' ELSE 'Y' END
				FROM    DP_ACCT_MSTR A
    							,TMP_DP_OFFM_DTLS_CDSL TMP
				WHERE   A.DPam_SBA_NO = convert(varchar,TMPOFFM_ACCT_ID)
			 AND     A.DPAM_DPM_ID  = @l_dpm_id
				AND     A.DPAM_DELETED_IND = 1
				


				UPDATE  TMP
				SET     TMPOFFM_COUNTER_CMBP_YN = CASE WHEN isnull(citrus_usr.fn_acct_entp(B.dpam_id,'CMBP_ID'),'') = '' THEN 'N' ELSE 'Y' END
                FROM    DP_ACCT_MSTR B 
											,TMP_DP_OFFM_DTLS_CDSL TMP
				WHERE   B.DPam_SBA_NO = convert(varchar,TMPOFFM_COUNTER_DEMAT_ACCT_NO)
				AND     B.DPAM_DELETED_IND = 1
				

                UPDATE  TMP
				SET     TMPOFFM_ACCT_ID = DPAM_ID
				,TMPOFFM_INTERNAL_REF_NO =  convert(varchar,(@L_MAX_DPTDC_ID1  + (TMPOFFM_ID)))
											
				FROM    DP_ACCT_MSTR A
											,TMP_DP_OFFM_DTLS_CDSL TMP
				WHERE   A.DPAM_SBA_NO = convert(varchar,TMPOFFM_ACCT_ID)
				AND     A.DPAM_DPM_ID  = @l_dpm_id
				AND     A.DPAM_DELETED_IND = 1


   


				INSERT INTO DPTDC_MAK  
				(DPTDC_ID
				,DPTDC_DPAM_ID
				,DPTDC_REQUEST_DT
				,DPTDC_SLIP_NO
				,DPTDC_ISIN
				,DPTDC_BATCH_NO
				,DPTDC_LINE_NO
				,DPTDC_QTY
				,DPTDC_INTERNAL_REF_NO
				,DPTDC_TRANS_NO
				,DPTDC_MKT_TYPE
				,DPTDC_SETTLEMENT_NO
				,DPTDC_EXECUTION_DT
				,DPTDC_OTHER_SETTLEMENT_TYPE
				,DPTDC_OTHER_SETTLEMENT_NO
				,DPTDC_COUNTER_DP_ID
				,DPTDC_COUNTER_CMBP_ID
				,DPTDC_COUNTER_DEMAT_ACCT_NO
				,DPTDC_CREATED_BY
				,DPTDC_CREATED_DT
				,DPTDC_LST_UPD_BY
				,DPTDC_LST_UPD_DT
				,DPTDC_DELETED_IND
				,DPTDC_TRASTM_CD
				,dptdC_dtls_id
				,DPTDC_BOOKING_NARRATION
				,DPTDC_BOOKING_TYPE
				,DPTDC_CONVERTED_QTY
				,DPTDC_REASON_CD
				,DPTDC_STATUS
				,DPTDC_INTERNAL_TRASTM
				,DPTDC_RMKS
				,DPTDC_BROKERBATCH_NO
				,DPTDC_BROKER_INTERNAL_REF_NO
				,DPTDC_CASH_TRF
				)                   
				SELECT    
				@L_MAX_DPTDC_ID1  + (TMPOFFM_ID),  
				convert(numeric,TMPOFFM_ACCT_ID),  
				CONVERT(DATETIME,TMPOFFM_REQUEST_DT,103),  
				TMPOFFM_SLIP_NO,  
				TMPOFFM_ISIN,     
				TMPOFFM_BATCH_NO ,  
				TMPOFFM_LINE_NO,  
				TMPOFFM_QTY ,  
				TMPOFFM_INTERNAL_REF_NO,  
				TMPOFFM_TRANS_NO ,  
				citrus_usr.fn_merge_str( 'settm_type_cdsl',0,TMPOFFM_MKT_TYPE),  
				TMPOFFM_SETTLEMENT_NO,  
				CONVERT(DATETIME,TMPOFFM_EXECUTION_DT,103),  
				Case when TMPOFFM_OTHER_SETTLEMENT_TYPE<>'' then citrus_usr.fn_merge_str('settm_type_cdsl',0,TMPOFFM_OTHER_SETTLEMENT_TYPE) else citrus_usr.fn_merge_str('settm_type_cdsl',0,TMPOFFM_TRG_SETTLEMENT_TYPE) END ,  
				CASE WHEN TMPOFFM_OTHER_SETTLEMENT_NO<>'' THEN TMPOFFM_OTHER_SETTLEMENT_NO ELSE TMPOFFM_TRG_SETTLEMENT_NO END ,  
				TMPOFFM_COUNTER_DP_ID  ,  
				TMPOFFM_COUNTER_CMBP_ID ,  
				TMPOFFM_COUNTER_DEMAT_ACCT_NO ,  
				@PA_LOGIN_NAME,  
				GETDATE(),  
				@PA_LOGIN_NAME,  
				GETDATE() ,  
				case when case when citrus_usr.fn_get_high_val('',0,'DORMANT',TMPOFFM_ACCT_ID,convert(datetime,TMPOFFM_REQUEST_DT,103)) = 'Y' then 'Y' else citrus_usr.fn_get_high_val(TMPOFFM_ISIN,abs(TMPOFFM_QTY),'HIGH_VALUE','','') end = 'Y' then 0 else 0 end,  
				CASE WHEN (TMPOFFM_CMBP_YN = 'N' AND isnull(TMPOFFM_MKT_TYPE,'') = '' ) THEN 'BOBO'
				     WHEN (TMPOFFM_CMBP_YN = 'Y' AND isnull(TMPOFFM_B_S_FLAG,'')IN ('S','B') ) THEN 'CMBO'
				     WHEN (TMPOFFM_CMBP_YN = 'N' AND isnull(TMPOFFM_MKT_TYPE,'') <> '' ) THEN 'BOCM' 
				     WHEN (TMPOFFM_CMBP_YN = 'Y' AND isnull(TMPOFFM_MKT_TYPE,'') <> '' ) THEN 'CMCM' END,
				id1+@L_MAX_DPTDC_DTLS_ID1,  
				NULL, 
				NULL,
				NULL,
				NULL,
				'P' ,  
			CASE WHEN (TMPOFFM_CMBP_YN = 'N' AND isnull(TMPOFFM_MKT_TYPE,'') = '' ) THEN 'BOBO'
				     WHEN (TMPOFFM_CMBP_YN = 'Y' AND isnull(TMPOFFM_B_S_FLAG,'') IN ('S','B')) THEN 'CMBO'
				     WHEN (TMPOFFM_CMBP_YN = 'N' AND isnull(TMPOFFM_MKT_TYPE,'') <> '' ) THEN 'BOCM' 
				     WHEN (TMPOFFM_CMBP_YN = 'Y' AND isnull(TMPOFFM_MKT_TYPE,'') <> '' ) THEN 'CMCM' END,  
										
										'',  
			TMPOFFM_BROKERBATCH_NO,
			TMPOFFM_BROKER_INTERNAL_REF_NO  ,
			TMPOFFM_CASH_TRFX
			
			FROM TMP_DP_OFFM_DTLS_CDSL  
			, #tmp_dptdc
			WHERE  DPTDC_SLIP_NO =  TMPOFFM_SLIP_NO  order by TMPOFFM_ID

			/*
			select @l_uses_id = max(uses_id) from used_slip 
			
			insert into used_slip
			(USES_ID
			,USES_DPM_ID
			,USES_DPAM_ACCT_NO
			,USES_SLIP_NO
			,USES_TRANTM_ID
			,USES_SERIES_TYPE
			,USES_USED_DESTR
			,USES_CREATED_BY
			,USES_CREATED_DT
			,USES_LST_UPD_BY
			,USES_LST_UPD_DT
			,USES_DELETED_IND 
			)select DISTINCT @l_uses_id+TMPOFFM_ID
			,@l_dpm_id
			,TMPOFFM_BO_ID
			,TMPOFFM_SLIP_NO
			,CASE WHEN (TMPOFFM_CMBP_YN = 'N' AND isnull(TMPOFFM_MKT_TYPE,'') = '' ) THEN 'BOBO'
				     WHEN (TMPOFFM_CMBP_YN = 'Y' AND isnull(TMPOFFM_B_S_FLAG,'') = 'B' ) THEN 'CMBO'
				     WHEN (TMPOFFM_CMBP_YN = 'N' AND isnull(TMPOFFM_MKT_TYPE,'') <> '' ) THEN 'BOCM' 
				     WHEN (TMPOFFM_CMBP_YN = 'Y' AND isnull(TMPOFFM_MKT_TYPE,'') <> '' ) THEN 'CMCM' END
			,''
			,'U'
			,@pa_login_name
			,getdate()
			,@pa_login_name
			,getdate()
			,1
			from TMP_DP_OFFM_DTLS_CDSL
			where TMPOFFM_BROKERBATCH_NO = @PA_BATCH_NO
			
   */
   
 
			SELECT TMPOFFM_INTERNAL_REF_NO INTERNAL_REF_NO , TMPOFFM_BROKER_INTERNAL_REF_NO BROKER_INTERNAL_REF_NO, TMPOFFM_BROKERBATCH_NO BROKER_BATCH_NO,ERROR = ''
			FROM   TMP_DP_OFFM_DTLS_CDSL

		--
		END
--
END
ELSE IF @PA_TRX_TAB  = 'INTERDP'
BEGIN
--
 
		BEGIN
		--
                UPDATE TMP_DP_INTDP_DTLS_CDSL SET  TMPINTDP_SLIP_NO=ltrim(rtrim(TMPINTDP_SLIP_NO))
				insert INTO #tmp_dptdc_intdp(DPTDC_SLIP_NO)
				select distinct  TMPINTDP_SLIP_NO FROM TMP_DP_INTDP_DTLS_CDSL

				/*SELECT @L_MAX_DPTDC_ID1 = ISNULL(MAX(DPTDC_ID),0),@L_MAX_DPTDC_DTLS_ID1 = ISNULL(MAX(DPTDC_DTLS_ID),0)  FROM DPTDC_MAK WHERE DPTDC_DELETED_IND = 0  

				SELECT @L_MAX_DPTDC_ID2 = ISNULL(MAX(DPTDC_ID),0) , @L_MAX_DPTDC_DTLS_ID2 = ISNULL(MAX(DPTDC_DTLS_ID),0) FROM DP_TRX_DTLS_CDSL WHERE DPTDC_DELETED_IND = 1

				IF @L_MAX_DPTDC_ID1 < @L_MAX_DPTDC_ID2 
				BEGIN
				--
						SET @L_MAX_DPTDC_ID1 = @L_MAX_DPTDC_ID2 
				--
				END

				IF @L_MAX_DPTDC_DTLS_ID1 < @L_MAX_DPTDC_DTLS_ID2 
				BEGIN
				--
						SET @L_MAX_DPTDC_DTLS_ID1 = @L_MAX_DPTDC_DTLS_ID2 
				--
				END*/
               
				
                



				IF EXISTS(SELECT TOP 1 ISNULL(DPTDC_ID,0) FROM DP_TRX_DTLS_CDSL , DP_ACCT_MSTR WHERE DPTDC_BROKERBATCH_NO IN (SELECT TMPINTDP_BROKERBATCH_NO FROM TMP_DP_INTDP_DTLS_CDSL) AND DPAM_ID = DPTDC_DPAM_ID AND DPAM_DPM_ID = @l_dpm_id AND DPAM_DELETED_IND = 1 AND DPTDC_DELETED_IND = 1 and DPTDC_INTERNAL_TRASTM like 'ID') 
						OR EXISTS(SELECT TOP 1 ISNULL(DPTDC_ID,0) FROM DPTDC_MAK, DP_ACCT_MSTR WHERE DPTDC_BROKERBATCH_NO IN (SELECT TMPINTDP_BROKERBATCH_NO FROM TMP_DP_INTDP_DTLS_CDSL) AND DPAM_ID = DPTDC_DPAM_ID AND DPAM_DPM_ID = @l_dpm_id AND DPAM_DELETED_IND  = 1 AND DPTDC_DELETED_IND = 0 and DPTDC_INTERNAL_TRASTM like 'ID')
				BEGIN
				--
						SET @PA_ERRMSG = 'SELECTED BATCH NO ALREADY EXISTS.'
						SELECT ERRMSG =  @PA_ERRMSG, ERROR ='B'

						UPDATE filetask
						SET    usermsg = 'File Could Not Be Uploaded Please Verify. ERROR : Selected Batch No Already Exists: ' + @PA_BATCH_NO
						,      STATUS = 'FAILED' 
						WHERE  task_id = @pa_task_id

						return

				--
				END


 
    
     select @l_err_mstr = isnull(replace(citrus_usr.fn_merge_str('CDSL_ACCT_INTDP',0,''),',',''),'')
     select @L_ERR_MISSING_ISIN= isnull(replace(citrus_usr.fn_merge_str('CDSL_ISIN_INTDP',0,''),',',''),'')
     IF @l_err_mstr <> ''
	 BEGIN
	 --
			UPDATE filetask
			SET    usermsg = 'File Could Not Be Uploaded Please Verify. ERROR : Following Client are Missing Or Inactive : ' + @l_err_mstr
			,      status = 'FAILED'
			WHERE  task_id = @pa_task_id

							
       return
	--
    END

     IF @L_ERR_MISSING_ISIN <> ''
	 BEGIN
	 --
			UPDATE filetask
			SET    usermsg = 'File Could Not Be Uploaded Please Verify. ERROR : Following ISINs are Missing : ' + @L_ERR_MISSING_ISIN
			,      status = 'FAILED'
			WHERE  task_id = @pa_task_id

							
       return
	--
    END

   if exists(select TMPINTDP_SLIP_NO from TMP_DP_INTDP_DTLS_CDSL, used_slip 
            where  isnumeric(replace(rtrim(ltrim(TMPINTDP_SLIP_NO)),ltrim(rtrim(USES_SERIES_TYPE)),'')) = 1
            and    ltrim(rtrim(USES_SERIES_TYPE)) +  convert(varchar,convert(numeric,replace(rtrim(ltrim(TMPINTDP_SLIP_NO)),ltrim(rtrim(USES_SERIES_TYPE)),''))) = ltrim(rtrim(USES_SERIES_TYPE)) + ltrim(rtrim(USES_SLIP_NO))
            )
    begin

     SELECT distinct @L_ERR_MISSING_ISIN = ISNULL(@L_ERR_MISSING_ISIN,'')  + TMPINTDP_SLIP_NO + ',' from TMP_DP_INTDP_DTLS_CDSL, used_slip 
     where  isnumeric(replace(rtrim(ltrim(TMPINTDP_SLIP_NO)),ltrim(rtrim(USES_SERIES_TYPE)),'')) = 1
     and    ltrim(rtrim(USES_SERIES_TYPE)) +  convert(varchar,convert(numeric,replace(rtrim(ltrim(TMPINTDP_SLIP_NO)),ltrim(rtrim(USES_SERIES_TYPE)),''))) = ltrim(rtrim(USES_SERIES_TYPE)) + ltrim(rtrim(USES_SLIP_NO))

        UPDATE filetask
		SET    usermsg = 'File Could Not Be Uploaded Please Verify. ERROR : Following Slips are already used : ' + @L_ERR_MISSING_ISIN
		,      status = 'FAILED'
		WHERE  task_id = @pa_task_id

    return 
  
    end 


                begin transaction

                select @L_MAX_DPTDC_ID1 = bitrm_bit_location from bitmap_ref_mstr where bitrm_parent_cd = 'DPTDC_ID' 
                select @L_MAX_DPTDC_DTLS_ID1 = bitrm_bit_location from bitmap_ref_mstr where bitrm_parent_cd = 'DPTDC_DTLS_ID' 
                

               
                select @l_id1 = count (distinct TMPINTDP_SLIP_NO) from TMP_DP_INTDP_DTLS_CDSL
                select @l_id2 = count (*) from TMP_DP_INTDP_DTLS_CDSL

                update bitmap_ref_mstr set bitrm_bit_location =  @L_MAX_DPTDC_DTLS_ID1+@l_id1+1  where bitrm_parent_cd = 'DPTDC_DTLS_ID' 
                update bitmap_ref_mstr set bitrm_bit_location =  @L_MAX_DPTDC_ID1+@l_id2 where bitrm_parent_cd = 'DPTDC_ID' 
                
                

                commit transaction


    set @L_ERR_MISSING_ISIN = ''


    if not exists(select TMPINTDP_SLIP_NO,TMPINTDP_BO_ID 
                  from TMP_DP_INTDP_DTLS_CDSL
                     , slip_issue_mstr  
                     , dp_acct_mstr 
                  where rtrim(ltrim(TMPINTDP_SLIP_NO)) like ltrim(rtrim(SLIIM_SERIES_TYPE)) + '%' 
                  and isnumeric(replace(rtrim(ltrim(TMPINTDP_SLIP_NO)),ltrim(rtrim(SLIIM_SERIES_TYPE)),'')) = 1
                  and   convert(numeric,replace(rtrim(ltrim(TMPINTDP_SLIP_NO)),ltrim(rtrim(SLIIM_SERIES_TYPE)),'')) between convert(numeric,SLIIM_SLIP_NO_FR) and   convert(numeric,SLIIM_SLIP_NO_TO) 
                  and SLIIM_ENTM_ID = dpam_crn_no 
                  and dpam_sba_no = TMPINTDP_BO_ID
                  union
                  select TMPINTDP_SLIP_NO,TMPINTDP_BO_ID 
                  from TMP_DP_INTDP_DTLS_CDSL
                     , slip_issue_mstr_POA  
                    
                  where rtrim(ltrim(TMPINTDP_SLIP_NO)) like ltrim(rtrim(SLIIM_SERIES_TYPE)) + '%' 
                  and isnumeric(replace(rtrim(ltrim(TMPINTDP_SLIP_NO)),ltrim(rtrim(SLIIM_SERIES_TYPE)),'')) = 1
                  and   convert(numeric,replace(rtrim(ltrim(TMPINTDP_SLIP_NO)),ltrim(rtrim(SLIIM_SERIES_TYPE)),'')) between convert(numeric,SLIIM_SLIP_NO_FR) and   convert(numeric,SLIIM_SLIP_NO_TO) 
				  AND SLIIM_DELETED_IND = 1 
                  )
    begin

     SELECT distinct @L_ERR_MISSING_ISIN = ISNULL(@L_ERR_MISSING_ISIN,'')  +   TMPINTDP_SLIP_NO  +' : '+ TMPINTDP_BO_ID +',' from TMP_DP_INTDP_DTLS_CDSL

        UPDATE filetask
		SET    usermsg = 'File Could Not Be Uploaded Please Verify. ERROR : Following Slips are not Issued : ' + @L_ERR_MISSING_ISIN
		,      status  = 'FAILED'
		WHERE  task_id = @pa_task_id

    return 
  
   end 

-- if exists(select TMPINTDP_SLIP_NO from TMP_DP_INTDP_DTLS_CDSL, used_slip where rtrim(ltrim(TMPINTDP_SLIP_NO)) = ltrim(rtrim(USES_SLIP_NO)))
--    begin
--    return 
--    end 

    /*
select @l_err_mstr = isnull(replace(citrus_usr.fn_merge_str('CDSL_IMP_INTDP',0,''),',',''),'')


    IF @l_err_mstr <> ''
				BEGIN
				--
						UPDATE filetask
						SET    usermsg = 'File Could Not Uploaded Please Varify. ERROR : Following Slip nos are Already Used Please Verify : ' + @l_err_mstr 
						,      status = 'FAILED'
						WHERE  task_id = @pa_task_id

						return

				--
    END

     select @l_err_mstr = isnull(replace(citrus_usr.fn_merge_str('CDSL_CMBP_INTDP',0,''),',',''),'')
								
										IF @l_err_mstr  <> ''
										BEGIN
										--
												UPDATE filetask
												SET    usermsg = 'File Could Not Be Uploaded Please Verify. ERROR : Following Slip nos are not issued Please Verify : ' + @l_err_mstr
												,      STATUS = 'FAILED' 
												WHERE  task_id = @pa_task_id
				
												return
				
										--
						END
    */


				UPDATE  TMP
				SET     TMPINTDP_ACCT_ID = DPAM_ID
											,TMPINTDP_INTERNAL_REF_NO =  convert(varchar,(@L_MAX_DPTDC_ID1  + (TMPINTDP_ID)))
											,TMPINTDP_OTHER_SETTLEMENT_TYPE = CITRUS_USR.GetCDSLinterdpSettType('U',TMPINTDP_OTHER_SETTLEMENT_NO,TMPINTDP_OTHER_SETTLEMENT_TYPE)
				FROM    DP_ACCT_MSTR 
											,TMP_DP_INTDP_DTLS_CDSL TMP
				WHERE   DPam_SBA_NO = convert(varchar,TMPINTDP_ACCT_ID)
				AND     DPAM_DPM_ID  = @l_dpm_id
				AND     DPAM_DELETED_IND = 1




				INSERT INTO DPTDC_MAK  
				(DPTDC_ID
				,DPTDC_DPAM_ID
				,DPTDC_REQUEST_DT
				,DPTDC_SLIP_NO
				,DPTDC_ISIN
				,DPTDC_BATCH_NO
				,DPTDC_LINE_NO
				,DPTDC_QTY
				,DPTDC_INTERNAL_REF_NO
				,DPTDC_TRANS_NO
				,DPTDC_MKT_TYPE
				,DPTDC_SETTLEMENT_NO
				,DPTDC_EXECUTION_DT
				,DPTDC_OTHER_SETTLEMENT_TYPE
				,DPTDC_OTHER_SETTLEMENT_NO
				,DPTDC_COUNTER_DP_ID
				,DPTDC_COUNTER_CMBP_ID
				,DPTDC_COUNTER_DEMAT_ACCT_NO
				,DPTDC_CREATED_BY
				,DPTDC_CREATED_DT
				,DPTDC_LST_UPD_BY
				,DPTDC_LST_UPD_DT
				,DPTDC_DELETED_IND
				,DPTDC_TRASTM_CD
				,dptdC_dtls_id
				,DPTDC_BOOKING_NARRATION
				,DPTDC_BOOKING_TYPE
				,DPTDC_CONVERTED_QTY
				,DPTDC_REASON_CD
				,DPTDC_STATUS
				,DPTDC_INTERNAL_TRASTM
				
				,DPTDC_RMKS
				,DPTDC_BROKERBATCH_NO
				,DPTDC_BROKER_INTERNAL_REF_NO
				,DPTDC_CASH_TRF
				)                   
				SELECT    
				@L_MAX_DPTDC_ID1  + (TMPINTDP_ID),  
				convert(numeric,TMPINTDP_ACCT_ID),  
				CONVERT(DATETIME,TMPINTDP_REQUEST_DT,103),  
				TMPINTDP_SLIP_NO,  
				TMPINTDP_ISIN,     
				TMPINTDP_BATCH_NO ,  
				TMPINTDP_LINE_NO,  
				TMPINTDP_QTY ,  
				TMPINTDP_INTERNAL_REF_NO,  
				TMPINTDP_TRANS_NO ,  
				citrus_usr.fn_merge_str('settm_type_cdsl', 0,TMPINTDP_MKT_TYPE),  
				TMPINTDP_SETTLEMENT_NO,  
				CONVERT(DATETIME,TMPINTDP_EXECUTION_DT,103),  
				case when TMPINTDP_OTHER_SETTLEMENT_TYPE <> '' then citrus_usr.fn_merge_str('settm_type_cdsl',0,TMPINTDP_OTHER_SETTLEMENT_TYPE ) else citrus_usr.fn_merge_str('settm_type_cdsl',0,TMPINTDP_TRG_SETTLEMENT_TYPE ) end ,  
				case when TMPINTDP_OTHER_SETTLEMENT_NO <> '' then TMPINTDP_OTHER_SETTLEMENT_NO else TMPINTDP_TRG_SETTLEMENT_NO end  ,  
				TMPINTDP_COUNTER_DP_ID  ,  
				TMPINTDP_COUNTER_CMBP_ID ,  
				TMPINTDP_COUNTER_DEMAT_ACCT_NO ,  
				@PA_LOGIN_NAME,  
				GETDATE(),  
				@PA_LOGIN_NAME,  
				GETDATE() ,  
			    case when case when citrus_usr.fn_get_high_val('',0,'DORMANT',TMPINTDP_ACCT_ID,convert(datetime,TMPINTDP_REQUEST_DT,103)) = 'Y' then 'Y' else citrus_usr.fn_get_high_val(TMPINTDP_ISIN,abs(TMPINTDP_QTY),'HIGH_VALUE','','') end = 'Y' then 0 else 0 end,  
				TMPINTDP_TRASTM_CD ,  
				id1+@L_MAX_DPTDC_DTLS_ID1,  
				NULL, 
				NULL,
				NULL,
				NULL,
				'P' ,  
				TMPINTDP_TRASTM_CD ,  

										'',  
			TMPINTDP_BROKERBATCH_NO,
			TMPINTDP_BROKER_INTERNAL_REF_NO  ,
			TMPINTDP_CASHTRX
			FROM TMP_DP_INTDP_DTLS_CDSL  
				, #tmp_dptdc_intdp
			WHERE  DPTDC_SLIP_NO =  TMPINTDP_SLIP_NO  order by TMPINTDP_ID

		 /*
		   select @l_uses_id = max(uses_id) from used_slip 
								
				insert into used_slip
				(USES_ID
				,USES_DPM_ID
				,USES_DPAM_ACCT_NO
				,USES_SLIP_NO
				,USES_TRANTM_ID
				,USES_SERIES_TYPE
				,USES_USED_DESTR
				,USES_CREATED_BY
				,USES_CREATED_DT
				,USES_LST_UPD_BY
				,USES_LST_UPD_DT
				,USES_DELETED_IND 
				)select  DISTINCT @l_uses_id+TMPINTDP_ID
				,@l_dpm_id
				,TMPINTDP_BO_ID
				,TMPINTDP_SLIP_NO
				,'INTDP'
				,''
				,'U'
				,@pa_login_name
				,getdate()
				,@pa_login_name
				,getdate()
				,1
				from TMP_DP_INTDP_DTLS_CDSL
				where TMPINTDP_BROKERBATCH_NO = @PA_BATCH_NO
*/
		
			SELECT TMPINTDP_INTERNAL_REF_NO INTERNAL_REF_NO , TMPINTDP_BROKER_INTERNAL_REF_NO BROKER_INTERNAL_REF_NO, TMPINTDP_BROKERBATCH_NO BROKER_BATCH_NO,ERROR = ''
			FROM   TMP_DP_INTDP_DTLS_CDSL
--
END


--
END

ELSE IF @PA_TRX_TAB  = 'NP'
BEGIN
--
  
		BEGIN
		--


           UPDATE TMP_DP_NP_DTLS_CDSL SET  TMPNP_SLIP_NO=ltrim(rtrim(TMPNP_SLIP_NO))


		  insert INTO #tmp_dptdc_np(DPTDC_SLIP_NO)
				SELECT distinct TMPNP_SLIP_NO FROM TMP_DP_NP_DTLS_CDSL

--				SELECT @L_MAX_DPTDC_ID1 = ISNULL(MAX(DPTDC_ID),0),@L_MAX_DPTDC_DTLS_ID1 = ISNULL(MAX(DPTDC_DTLS_ID),0)  FROM DPTDC_MAK WHERE DPTDC_DELETED_IND = 0  
--
--				SELECT @L_MAX_DPTDC_ID2 = ISNULL(MAX(DPTDC_ID),0) , @L_MAX_DPTDC_DTLS_ID2 = ISNULL(MAX(DPTDC_DTLS_ID),0) FROM DP_TRX_DTLS_CDSL WHERE DPTDC_DELETED_IND = 1
--
--				IF @L_MAX_DPTDC_ID1 < @L_MAX_DPTDC_ID2 
--				BEGIN
--				--
--						SET @L_MAX_DPTDC_ID1 = @L_MAX_DPTDC_ID2 
--				--
--				END
--
--				IF @L_MAX_DPTDC_DTLS_ID1 < @L_MAX_DPTDC_DTLS_ID2 
--				BEGIN
--				--
--						SET @L_MAX_DPTDC_DTLS_ID1 = @L_MAX_DPTDC_DTLS_ID2 
--				--
--				END

               
				
						IF EXISTS(SELECT TOP 1 ISNULL(DPTDC_ID,0) FROM DP_TRX_DTLS_CDSL , DP_ACCT_MSTR WHERE DPTDC_BROKERBATCH_NO IN (SELECT TMPNP_BROKERBATCH_NO FROM TMP_DP_NP_DTLS_CDSL) AND DPAM_ID = DPTDC_DPAM_ID AND DPAM_DPM_ID = @l_dpm_id AND DPAM_DELETED_IND = 1 AND DPTDC_DELETED_IND = 1 and DPTDC_INTERNAL_TRASTM like 'NP') 
									OR EXISTS(SELECT TOP 1 ISNULL(DPTDC_ID,0) FROM DPTDC_MAK, DP_ACCT_MSTR WHERE DPTDC_BROKERBATCH_NO IN (SELECT TMPNP_BROKERBATCH_NO FROM TMP_DP_NP_DTLS_CDSL) AND DPAM_ID = DPTDC_DPAM_ID AND DPAM_DPM_ID = @l_dpm_id AND DPAM_DELETED_IND  = 1 AND DPTDC_DELETED_IND = 0 and DPTDC_INTERNAL_TRASTM like 'NP')
								BEGIN
								--
										SET @PA_ERRMSG = 'SELECTED BATCH NO ALREADY EXISTS.'
										SELECT ERRMSG =  @PA_ERRMSG, ERROR ='B'
				
										UPDATE filetask
										SET    usermsg = 'File Could Not Be Uploaded Please Verify. ERROR : Selected Batch No Already Exists: ' + @PA_BATCH_NO
										,      STATUS = 'FAILED' 
										WHERE  task_id = @pa_task_id
				
										return
				
								--
				END
				
/*
select @l_err_mstr = isnull(replace(citrus_usr.fn_merge_str('CDSL_CMBP_NP',0,''),',',''),'')
								
										IF @l_err_mstr  <> ''
										BEGIN
										--
												UPDATE filetask
												SET    usermsg = 'File Could Not Be Uploaded Please Verify. ERROR : Following Slip nos are Already Used Please Verify : ' + @l_err_mstr
												,      STATUS = 'FAILED' 
												WHERE  task_id = @pa_task_id
				
												return
				
										--
						END
						

select @l_err_mstr = isnull(replace(citrus_usr.fn_merge_str('CDSL_IMP_NP',0,''),',',''),'')

     IF @l_err_mstr <> ''
					BEGIN
					--
							UPDATE filetask
							SET    usermsg = 'File Could Not Uploaded Please Varify.ERROR : Following Slip nos are Already Used Please Verify : ' + @l_err_mstr
							,      status = 'FAILED'
							WHERE  task_id = @pa_task_id
							
							return
							
					--
     END
*/


     
select @l_err_mstr = isnull(replace(citrus_usr.fn_merge_str('CDSL_ACCT_NP',0,''),',',''),'')
SELECT @L_ERR_MISSING_ISIN  =  isnull(replace(citrus_usr.fn_merge_str('CDSL_ISIN_NP',0,''),',',''),'')    
     IF @l_err_mstr <> ''
	BEGIN
	--
			UPDATE filetask
			SET    usermsg = 'File Could Not Be Uploaded Please Verify. ERROR : Following Client are Missing Or Inactive : ' + @l_err_mstr
			,      status = 'FAILED'
			WHERE  task_id = @pa_task_id

			return

	--
     END


     IF @L_ERR_MISSING_ISIN <> ''
	 BEGIN
	 --
			UPDATE filetask
			SET    usermsg = 'File Could Not Be Uploaded Please Verify. ERROR : Following ISINs are Missing : ' + @L_ERR_MISSING_ISIN
			,      status = 'FAILED'
			WHERE  task_id = @pa_task_id

							
       return
	 --
     END


--    if exists(select TMPNP_SLIP_NO from TMP_DP_NP_DTLS_CDSL, used_slip where rtrim(ltrim(TMPNP_SLIP_NO)) = ltrim(rtrim(USES_SLIP_NO)))
--    begin
--    return 
--    end 

  if exists(select TMPNP_SLIP_NO from TMP_DP_NP_DTLS_CDSL, used_slip 
            where  isnumeric(replace(rtrim(ltrim(TMPNP_SLIP_NO)),ltrim(rtrim(USES_SERIES_TYPE)),'')) = 1
            and    ltrim(rtrim(USES_SERIES_TYPE)) +  convert(varchar,convert(numeric,replace(rtrim(ltrim(TMPNP_SLIP_NO)),ltrim(rtrim(USES_SERIES_TYPE)),''))) = ltrim(rtrim(USES_SERIES_TYPE)) + ltrim(rtrim(USES_SLIP_NO)))
    begin

     SELECT distinct @L_ERR_MISSING_ISIN = ISNULL(@L_ERR_MISSING_ISIN,'')  + TMPNP_SLIP_NO + ',' from TMP_DP_NP_DTLS_CDSL, used_slip 
     where  isnumeric(replace(rtrim(ltrim(TMPNP_SLIP_NO)),ltrim(rtrim(USES_SERIES_TYPE)),'')) = 1
     and    ltrim(rtrim(USES_SERIES_TYPE)) +  convert(varchar,convert(numeric,replace(rtrim(ltrim(TMPNP_SLIP_NO)),ltrim(rtrim(USES_SERIES_TYPE)),''))) = ltrim(rtrim(USES_SERIES_TYPE)) + ltrim(rtrim(USES_SLIP_NO))

        UPDATE filetask
		SET    usermsg = 'File Could Not Be Uploaded Please Verify. ERROR : Following Slips are already used : ' + @L_ERR_MISSING_ISIN
		,      status = 'FAILED'
		WHERE  task_id = @pa_task_id

    return 
  
    end 

if not exists(select TMPNP_SLIP_NO,TMPNP_BO_ID
              from TMP_DP_NP_DTLS_CDSL
                 , slip_issue_mstr  
                 , dp_acct_mstr 
              where rtrim(ltrim(TMPNP_SLIP_NO)) like ltrim(rtrim(SLIIM_SERIES_TYPE)) + '%' 
              and isnumeric(replace(rtrim(ltrim(TMPNP_SLIP_NO)),ltrim(rtrim(SLIIM_SERIES_TYPE)),'')) = 1
              and convert(numeric,replace(rtrim(ltrim(TMPNP_SLIP_NO)),ltrim(rtrim(SLIIM_SERIES_TYPE)),'') ) between convert(numeric,SLIIM_SLIP_NO_FR ) and convert(numeric,SLIIM_SLIP_NO_TO ) 
              and SLIIM_ENTM_ID = dpam_crn_no 
              and dpam_sba_no = TMPNP_BO_ID 
              union
              select TMPNP_SLIP_NO,TMPNP_BO_ID
              from TMP_DP_NP_DTLS_CDSL
                 , slip_issue_mstr_POA  
                 --, dp_acct_mstr 
              where rtrim(ltrim(TMPNP_SLIP_NO)) like ltrim(rtrim(SLIIM_SERIES_TYPE)) + '%' 
              and isnumeric(replace(rtrim(ltrim(TMPNP_SLIP_NO)),ltrim(rtrim(SLIIM_SERIES_TYPE)),'')) = 1
              and convert(numeric,replace(rtrim(ltrim(TMPNP_SLIP_NO)),ltrim(rtrim(SLIIM_SERIES_TYPE)),'') ) between convert(numeric,SLIIM_SLIP_NO_FR ) and convert(numeric,SLIIM_SLIP_NO_TO ) 
              --and SLIIM_ENTM_ID = dpam_crn_no 
              --and dpam_enttm_cd in ('14_CDSL','02_CDSL','12_CDSL','03_CDSL','11_CDSL')
              AND SLIIM_DELETED_IND = 1 
              )
    begin

     SELECT distinct  @L_ERR_MISSING_ISIN = ISNULL(@L_ERR_MISSING_ISIN,'')  +   TMPNP_SLIP_NO +' : ' + TMPNP_BO_ID +',' from TMP_DP_NP_DTLS_CDSL

        UPDATE filetask
		SET    usermsg = 'File Could Not Be Uploaded Please Verify. ERROR : Following Slips are not Issued : ' + @L_ERR_MISSING_ISIN
		,      status = 'FAILED'
		WHERE  task_id = @pa_task_id

    return 
  
    end 

                begin transaction

                select @L_MAX_DPTDC_ID1 = bitrm_bit_location from bitmap_ref_mstr where bitrm_parent_cd = 'DPTDC_ID' 
                select @L_MAX_DPTDC_DTLS_ID1 = bitrm_bit_location from bitmap_ref_mstr where bitrm_parent_cd = 'DPTDC_DTLS_ID' 
                

                

                select @l_id1 = count (distinct TMPNP_SLIP_NO) from TMP_DP_NP_DTLS_CDSL
                select @l_id2 = count (*) from TMP_DP_NP_DTLS_CDSL

                update bitmap_ref_mstr set bitrm_bit_location =  @L_MAX_DPTDC_DTLS_ID1+@l_id1+1  where bitrm_parent_cd = 'DPTDC_DTLS_ID' 
                update bitmap_ref_mstr set bitrm_bit_location =  @L_MAX_DPTDC_ID1+@l_id2  where bitrm_parent_cd = 'DPTDC_ID' 
                
                

                commit transaction
				


				UPDATE  TMP
				SET     TMPNP_ACCT_ID = DPAM_ID
											,TMPNP_INTERNAL_REF_NO =  convert(varchar,(@L_MAX_DPTDC_ID1  + TMPNP_ID))
											,TMPNP_MKT_TYPE = CITRUS_USR.GetCDSLinterdpSettType('U',TMPNP_SETTLEMENT_ID,TMPNP_MKT_TYPE)
				FROM    DP_ACCT_MSTR 
											,TMP_DP_NP_DTLS_CDSL TMP
				WHERE   DPam_SBA_NO = convert(varchar,TMPNP_ACCT_ID)
				AND     DPAM_DPM_ID  = @l_dpm_id
				AND     DPAM_DELETED_IND = 1


				INSERT INTO DPTDC_MAK  
				(DPTDC_ID
				,DPTDC_DPAM_ID
				,DPTDC_REQUEST_DT
				,DPTDC_SLIP_NO
				,DPTDC_ISIN
				,DPTDC_BATCH_NO
				,DPTDC_LINE_NO
				,DPTDC_QTY
				,DPTDC_INTERNAL_REF_NO
				,DPTDC_TRANS_NO
				,DPTDC_MKT_TYPE
				,DPTDC_SETTLEMENT_NO
				,DPTDC_EXECUTION_DT
				,DPTDC_OTHER_SETTLEMENT_TYPE
				,DPTDC_OTHER_SETTLEMENT_NO
				,DPTDC_COUNTER_DP_ID
				,DPTDC_COUNTER_CMBP_ID
				,DPTDC_COUNTER_DEMAT_ACCT_NO
				,DPTDC_CREATED_BY
				,DPTDC_CREATED_DT
				,DPTDC_LST_UPD_BY
				,DPTDC_LST_UPD_DT
				,DPTDC_DELETED_IND
				,DPTDC_TRASTM_CD
				,dptdC_dtls_id
				,DPTDC_BOOKING_NARRATION
				,DPTDC_BOOKING_TYPE
				,DPTDC_CONVERTED_QTY
				,DPTDC_REASON_CD
				,DPTDC_STATUS
				,DPTDC_INTERNAL_TRASTM

				,DPTDC_RMKS
				,DPTDC_BROKERBATCH_NO
				,DPTDC_BROKER_INTERNAL_REF_NO
				,dptdc_excm_id 
			    ,dptdc_cm_id
				)                   
				SELECT    
				@L_MAX_DPTDC_ID1  + TMPNP_ID,  
				convert(numeric,TMPNP_ACCT_ID),  
				CONVERT(DATETIME,TMPNP_REQUEST_DT,103),  
				TMPNP_SLIP_NO,  
				TMPNP_ISIN,     
				'' ,  
				0,  
				TMPNP_QTY ,  
				TMPNP_INTERNAL_REF_NO,  
				'' ,  
				'',  
				'',  
				'',  
				citrus_usr.fn_merge_str('settm_type_cdsl',0 ,TMPNP_mkt_type) ,  
				TMPNP_SETTLEMENT_ID ,  
				''  ,  
				'' ,  
				'' ,  
				@PA_LOGIN_NAME,  
				GETDATE(),  
				@PA_LOGIN_NAME,  
				GETDATE() ,  
				case when case when citrus_usr.fn_get_high_val('',0,'DORMANT',TMPNP_ACCT_ID,convert(datetime,TMPNP_REQUEST_DT,103)) = 'Y' then 'Y' else citrus_usr.fn_get_high_val(TMPNP_ISIN,abs(TMPNP_QTY),'HIGH_VALUE','','') end = 'Y' then 0 else 0 end,  
				TMPNP_TRASTM_CD ,  
				id1+@L_MAX_DPTDC_DTLS_ID1,  
				NULL, 
				NULL,
				NULL,
				NULL,
				'P' ,  
				TMPNP_INTERNAL_TRASTM ,  

										'',  
			TMPNP_BROKERBATCH_NO,
			TMPNP_INTERNAL_REF_NO 
			,excm_id
            ,TMPNP_CM_ID
			FROM TMP_DP_NP_DTLS_CDSL  
						, #tmp_dptdc_np
						,exchange_mstr 
			WHERE  DPTDC_SLIP_NO =  TMPNP_SLIP_NO 
			and    excm_short_name  = CONVERT(VARCHAR,tmpnp_exch_id) order by TMPNP_ID
/*
		 
		   select @l_uses_id = max(uses_id) from used_slip 
											
							insert into used_slip
							(USES_ID
							,USES_DPM_ID
							,USES_DPAM_ACCT_NO
							,USES_SLIP_NO
							,USES_TRANTM_ID
							,USES_SERIES_TYPE
							,USES_USED_DESTR
							,USES_CREATED_BY
							,USES_CREATED_DT
							,USES_LST_UPD_BY
							,USES_LST_UPD_DT
							,USES_DELETED_IND 
							)select DISTINCT @l_uses_id+TMPNP_ID
							,@l_dpm_id
							,TMPNP_BO_ID
							,TMPNP_SLIP_NO
							,'NP'
							,''
							,'U'
							,@pa_login_name
							,getdate()
							,@pa_login_name
							,getdate()
							,1
							from TMP_DP_NP_DTLS_CDSL
							where TMPNP_BROKERBATCH_NO = @PA_BATCH_NO
*/		
		
		   
			SELECT TMPNP_INTERNAL_REF_NO INTERNAL_REF_NO , TMPNP_INTERNAL_REF_NO	 BROKER_INTERNAL_REF_NO, TMPNP_BROKERBATCH_NO BROKER_BATCH_NO,ERROR = ''
			FROM   TMP_DP_NP_DTLS_CDSL
--
END


--
END
ELSE IF @PA_TRX_TAB  = 'EP'
BEGIN
--
  
		BEGIN
		--

              UPDATE TMP_DP_EP_DTLS_CDSL SET  TMPEP_SLIP_NO=ltrim(rtrim(TMPEP_SLIP_NO))


        		  insert INTO #tmp_dptdc_ep(DPTDC_SLIP_NO) 
				SELECT distinct TMPEP_SLIP_NO FROM TMP_DP_EP_DTLS_CDSL

--				SELECT @L_MAX_DPTDC_ID1 = ISNULL(MAX(DPTDC_ID),0),@L_MAX_DPTDC_DTLS_ID1 = ISNULL(MAX(DPTDC_DTLS_ID),0)  FROM DPTDC_MAK WHERE DPTDC_DELETED_IND = 0  
--
--				SELECT @L_MAX_DPTDC_ID2 = ISNULL(MAX(DPTDC_ID),0) , @L_MAX_DPTDC_DTLS_ID2 = ISNULL(MAX(DPTDC_DTLS_ID),0) FROM DP_TRX_DTLS_CDSL WHERE DPTDC_DELETED_IND = 1
--
--				IF @L_MAX_DPTDC_ID1 < @L_MAX_DPTDC_ID2 
--				BEGIN
--				--
--						SET @L_MAX_DPTDC_ID1 = @L_MAX_DPTDC_ID2 
--				--
--				END
--
--				IF @L_MAX_DPTDC_DTLS_ID1 < @L_MAX_DPTDC_DTLS_ID2 
--				BEGIN
--				--
--						SET @L_MAX_DPTDC_DTLS_ID1 = @L_MAX_DPTDC_DTLS_ID2 
--				--
--				END
                


				
					IF EXISTS(SELECT TOP 1 ISNULL(DPTDC_ID,0) FROM DP_TRX_DTLS_CDSL , DP_ACCT_MSTR WHERE DPTDC_BROKERBATCH_NO IN (SELECT TMPEP_BROKERBATCH_NO FROM TMP_DP_EP_DTLS_CDSL) AND DPAM_ID = DPTDC_DPAM_ID AND DPAM_DPM_ID = @l_dpm_id AND DPAM_DELETED_IND = 1 AND DPTDC_DELETED_IND = 1 and DPTDC_INTERNAL_TRASTM like 'EP') 
														OR EXISTS(SELECT TOP 1 ISNULL(DPTDC_ID,0) FROM DPTDC_MAK, DP_ACCT_MSTR WHERE DPTDC_BROKERBATCH_NO IN (SELECT TMPEP_BROKERBATCH_NO FROM TMP_DP_EP_DTLS_CDSL) AND DPAM_ID = DPTDC_DPAM_ID AND DPAM_DPM_ID = @l_dpm_id AND DPAM_DELETED_IND  = 1 AND DPTDC_DELETED_IND = 0 and DPTDC_INTERNAL_TRASTM like 'EP')
								BEGIN
								--
										SET @PA_ERRMSG = 'SELECTED BATCH NO ALREADY EXISTS.'
										SELECT ERRMSG =  @PA_ERRMSG, ERROR ='B'

										UPDATE filetask
										SET    usermsg = 'File Could Not Be Uploaded Please Verify. ERROR : Selected Batch No Already Exists: ' + @PA_BATCH_NO
										,      STATUS = 'FAILED' 
										WHERE  task_id = @pa_task_id

										return

								--
								END
		/*						
				
			select @l_err_mstr = isnull(replace(citrus_usr.fn_merge_str('CDSL_CMBP_EP',0,''),',',''),'')
								
										IF @l_err_mstr  <> ''
										BEGIN
										--
												UPDATE filetask
												SET    usermsg = 'File Could Not Be Uploaded Please Verify. ERROR : Following Slip nos are not issued, Please Verify : ' + @l_err_mstr
												,      STATUS = 'FAILED' 
												WHERE  task_id = @pa_task_id
				
												return
				
										--
						END	

select @l_err_mstr = isnull(replace(citrus_usr.fn_merge_str('CDSL_IMP_EP',0,''),',',''),'')

    IF @l_err_mstr  <> ''
				BEGIN
				--
						UPDATE filetask
						SET    usermsg = 'File Could Not Uploaded Please Varify. ERROR : Following Slip nos are Already Used Please Verify : ' + @l_err_mstr
						,      status = 'FAILED'
						WHERE  task_id = @pa_task_id

						return

				--
				END
*/				
				
select @l_err_mstr = isnull(replace(citrus_usr.fn_merge_str('CDSL_ACCT_EP',0,''),',',''),'')
SELECT @L_ERR_MISSING_ISIN  = isnull(replace(citrus_usr.fn_merge_str('CDSL_ISIN_EP',0,''),',',''),'')
	IF @l_err_mstr  <> ''
	BEGIN
	--
			UPDATE filetask
			SET    usermsg = 'File Could Not Be Uploaded Please Verify. ERROR : Following Client are Missing Or Inactive : ' + @l_err_mstr
			,      status = 'FAILED'
			WHERE  task_id = @pa_task_id

			return

	--
    END

    IF @L_ERR_MISSING_ISIN <> ''
	 BEGIN
	 --
			UPDATE filetask
			SET    usermsg = 'File Could Not Be Uploaded Please Verify. ERROR : Following ISINs are Missing : ' + @L_ERR_MISSING_ISIN
			,      status = 'FAILED'
			WHERE  task_id = @pa_task_id

							
       return
	 --
     END
     

--    if exists(select TMPEP_SLIP_NO from TMP_DP_EP_DTLS_CDSL, used_slip where rtrim(ltrim(TMPEP_SLIP_NO)) = ltrim(rtrim(USES_SLIP_NO)))
--    begin
--    return 
--    end 


  if exists(select TMPEP_SLIP_NO from TMP_DP_EP_DTLS_CDSL, used_slip 
            where  isnumeric(replace(rtrim(ltrim(TMPEP_SLIP_NO)),ltrim(rtrim(USES_SERIES_TYPE)),'')) = 1
            and    ltrim(rtrim(USES_SERIES_TYPE)) +  convert(varchar,convert(numeric,replace(rtrim(ltrim(TMPEP_SLIP_NO)),ltrim(rtrim(USES_SERIES_TYPE)),''))) = ltrim(rtrim(USES_SERIES_TYPE)) + ltrim(rtrim(USES_SLIP_NO))
            )
    begin

     SELECT distinct @L_ERR_MISSING_ISIN = ISNULL(@L_ERR_MISSING_ISIN,'')  + TMPEP_SLIP_NO + ',' from TMP_DP_EP_DTLS_CDSL, used_slip 
     where  isnumeric(replace(rtrim(ltrim(TMPEP_SLIP_NO)),ltrim(rtrim(USES_SERIES_TYPE)),'')) = 1
     and    ltrim(rtrim(USES_SERIES_TYPE)) +  convert(varchar,convert(numeric,replace(rtrim(ltrim(TMPEP_SLIP_NO)),ltrim(rtrim(USES_SERIES_TYPE)),''))) = ltrim(rtrim(USES_SERIES_TYPE)) + ltrim(rtrim(USES_SLIP_NO))

        UPDATE filetask
		SET    usermsg = 'File Could Not Be Uploaded Please Verify. ERROR : Following Slips are already used : ' + @L_ERR_MISSING_ISIN
		,      status = 'FAILED'
		WHERE  task_id = @pa_task_id

    return 
  
    end 

if not exists(select TMPEP_SLIP_NO,TMPEP_BO_ID 
              from TMP_DP_EP_DTLS_CDSL
                 , slip_issue_mstr  
                 , dp_acct_mstr 
              where rtrim(ltrim(TMPEP_SLIP_NO)) like ltrim(rtrim(SLIIM_SERIES_TYPE)) + '%' 
              and isnumeric(replace(rtrim(ltrim(TMPEP_SLIP_NO)),ltrim(rtrim(SLIIM_SERIES_TYPE)),'')) = 1
              and convert(numeric,replace(rtrim(ltrim(TMPEP_SLIP_NO)),ltrim(rtrim(SLIIM_SERIES_TYPE)),'')) between convert(numeric,SLIIM_SLIP_NO_FR) and convert(numeric,SLIIM_SLIP_NO_TO) 
              and SLIIM_ENTM_ID = dpam_crn_no 
              and dpam_sba_no = TMPEP_BO_ID
              union
              select TMPEP_SLIP_NO,TMPEP_BO_ID 
              from TMP_DP_EP_DTLS_CDSL
                 , slip_issue_mstr_POA  
                 --, dp_acct_mstr 
              where rtrim(ltrim(TMPEP_SLIP_NO)) like ltrim(rtrim(SLIIM_SERIES_TYPE)) + '%' 
              and isnumeric(replace(rtrim(ltrim(TMPEP_SLIP_NO)),ltrim(rtrim(SLIIM_SERIES_TYPE)),'')) = 1
              and convert(numeric,replace(rtrim(ltrim(TMPEP_SLIP_NO)),ltrim(rtrim(SLIIM_SERIES_TYPE)),'')) between convert(numeric,SLIIM_SLIP_NO_FR) and convert(numeric,SLIIM_SLIP_NO_TO) 
              AND SLIIM_DELETED_IND = 1 
              --and SLIIM_ENTM_ID = dpam_crn_no 
              --and dpam_enttm_cd in ('14_CDSL','02_CDSL','12_CDSL','03_CDSL','11_CDSL')                         
              )
    begin

        SELECT distinct @L_ERR_MISSING_ISIN = ISNULL(@L_ERR_MISSING_ISIN,'')  +   TMPEP_SLIP_NO + ' : ' + TMPEP_BO_ID + ',' from TMP_DP_EP_DTLS_CDSL

        UPDATE filetask
		SET    usermsg = 'File Could Not Be Uploaded Please Verify. ERROR : Following Slips are not Issued : ' + @L_ERR_MISSING_ISIN
		,      status = 'FAILED'
		WHERE  task_id = @pa_task_id

    return 
  
    end 


 begin transaction

                select @L_MAX_DPTDC_ID1 = bitrm_bit_location from bitmap_ref_mstr where bitrm_parent_cd = 'DPTDC_ID' 
                select @L_MAX_DPTDC_DTLS_ID1 = bitrm_bit_location from bitmap_ref_mstr where bitrm_parent_cd = 'DPTDC_DTLS_ID' 
                

               

                select @l_id1 = count (distinct TMPEP_SLIP_NO) from TMP_DP_EP_DTLS_CDSL
                select @l_id2 = count (*) from TMP_DP_EP_DTLS_CDSL

                update bitmap_ref_mstr set bitrm_bit_location =  @L_MAX_DPTDC_DTLS_ID1+@l_id1+1  where bitrm_parent_cd = 'DPTDC_DTLS_ID' 
                update bitmap_ref_mstr set bitrm_bit_location =  @L_MAX_DPTDC_ID1+@l_id2  where bitrm_parent_cd = 'DPTDC_ID' 
                
                

                commit transaction



				UPDATE  TMP
				SET     TMPEP_ACCT_ID = DPAM_ID
											,TMPEP_INTERNAL_REF_NO =  convert(varchar,(@L_MAX_DPTDC_ID1  + TMPEP_ID))
											,TMPEP_MKT_TYPE = CITRUS_USR.GetCDSLinterdpSettType('U',TMPEP_SETTLEMENT_ID,TMPEP_MKT_TYPE)
				FROM    DP_ACCT_MSTR 
											,TMP_DP_EP_DTLS_CDSL TMP
				WHERE   DPam_SBA_NO = convert(varchar,TMPEP_ACCT_ID)
				AND     DPAM_DPM_ID  = @l_dpm_id
				AND     DPAM_DELETED_IND = 1


				INSERT INTO DPTDC_MAK  
				(DPTDC_ID
				,DPTDC_DPAM_ID
				,DPTDC_REQUEST_DT
				,DPTDC_SLIP_NO
				,DPTDC_ISIN
				,DPTDC_BATCH_NO
				,DPTDC_LINE_NO
				,DPTDC_QTY
				,DPTDC_INTERNAL_REF_NO
				,DPTDC_TRANS_NO
				,DPTDC_MKT_TYPE
				,DPTDC_SETTLEMENT_NO
				,DPTDC_EXECUTION_DT
				,DPTDC_OTHER_SETTLEMENT_TYPE
				,DPTDC_OTHER_SETTLEMENT_NO
				,DPTDC_COUNTER_DP_ID
				,DPTDC_COUNTER_CMBP_ID
				,DPTDC_COUNTER_DEMAT_ACCT_NO
				,DPTDC_CREATED_BY
				,DPTDC_CREATED_DT
				,DPTDC_LST_UPD_BY
				,DPTDC_LST_UPD_DT
				,DPTDC_DELETED_IND
				,DPTDC_TRASTM_CD
				,dptdC_dtls_id
				,DPTDC_BOOKING_NARRATION
				,DPTDC_BOOKING_TYPE
				,DPTDC_CONVERTED_QTY
				,DPTDC_REASON_CD
				,DPTDC_STATUS
				,DPTDC_INTERNAL_TRASTM

				,DPTDC_RMKS
				,DPTDC_BROKERBATCH_NO
				,DPTDC_BROKER_INTERNAL_REF_NO
				,dptdc_excm_id
			 ,dptdc_cm_id
				)                   
				SELECT    
				@L_MAX_DPTDC_ID1  + TMPEP_ID,
				convert(numeric,TMPEP_ACCT_ID),  
				CONVERT(DATETIME,TMPEP_REQUEST_DT,103),  
				TMPEP_SLIP_NO,  
				TMPEP_ISIN,     
				'' ,  
				0,  
				TMPEP_QTY ,  
				TMPEP_INTERNAL_REF_NO,  
				'' ,  
				'',  
				'',  
				CONVERT(DATETIME,TMPEP_BUSMDT,103),  
				citrus_usr.fn_merge_str('settm_type_cdsl',0 ,TMPEP_mkt_type),  
				TMPEP_SETTLEMENT_ID ,  
				''  ,  
				'' ,  
				TMPEP_COUNTER_DEMAT_ACCT_NO,  
				@PA_LOGIN_NAME,  
				GETDATE(),  
				@PA_LOGIN_NAME,  
				GETDATE() ,  
				case when case when citrus_usr.fn_get_high_val('',0,'DORMANT',TMPEP_ACCT_ID,convert(datetime,TMPEP_REQUEST_DT,103)) = 'Y' then 'Y' else citrus_usr.fn_get_high_val(TMPEP_ISIN,abs(TMPEP_QTY),'HIGH_VALUE','','') end = 'Y' then 0 else 0 end,  
				TMPEP_TRASTM_CD ,  
				id1+@L_MAX_DPTDC_DTLS_ID1,  
				NULL, 
				NULL,
				NULL,
				NULL,
				'P' ,  
				TMPEP_INTERNAL_TRASTM ,  

										'',  
			TMPEP_BROKERBATCH_NO,
			TMPEP_INTERNAL_REF_NO 
			,excm_id
			,tmpep_cm_id
			FROM TMP_DP_EP_DTLS_CDSL  
						, #tmp_dptdc_ep
						, exchange_mstr 
			WHERE  DPTDC_SLIP_NO =  TMPEP_SLIP_NO 
			and    excm_short_name  = CONVERT(VARCHAR,tmpep_exch_id) order by TMPEP_ID

/*		 
		 
		 select @l_uses_id = max(uses_id) from used_slip 
														
										insert into used_slip
										(USES_ID
										,USES_DPM_ID
										,USES_DPAM_ACCT_NO
										,USES_SLIP_NO
										,USES_TRANTM_ID
										,USES_SERIES_TYPE
										,USES_USED_DESTR
										,USES_CREATED_BY
										,USES_CREATED_DT
										,USES_LST_UPD_BY
										,USES_LST_UPD_DT
										,USES_DELETED_IND 
										)select DISTINCT  @l_uses_id+TMPEP_ID
										,@l_dpm_id
										,TMPEP_BO_ID
										,TMPEP_SLIP_NO
										,'EP'
										,''
										,'U'
										,@pa_login_name
										,getdate()
										,@pa_login_name
										,getdate()
										,1
										from TMP_DP_EP_DTLS_CDSL
										where TMPEP_BROKERBATCH_NO = @PA_BATCH_NO
*/
					 	
			SELECT TMPEP_INTERNAL_REF_NO INTERNAL_REF_NO , TMPEP_INTERNAL_REF_NO BROKER_INTERNAL_REF_NO, TMPEP_BROKERBATCH_NO BROKER_BATCH_NO,ERROR = ''
			FROM   TMP_DP_EP_DTLS_CDSL
--
END


--
END

DECLARE @l_id_used_slip numeric
DECLARE @l_dpm_id1 numeric

SELECT @l_dpm_id1 = dpm_id FROM dp_mstr , exch_seg_mstr 
WHERE dpm_excsm_id = excsm_id 
AND default_dp = dpm_excsm_id 
AND dpm_deleted_ind = 1 
AND excsm_exch_cd = 'cdsl'




SELECT @l_id_used_slip = max(uses_id) FROM used_slip WHERE uses_deleted_ind = 1



IF @PA_TRX_TAB  = 'OFFM'
BEGIN 
INSERT INTO used_slip
SELECT distinct @l_id_used_slip + ID1 , @l_dpm_id1 , TMPOFFM_BO_ID , convert(numeric,replace(rtrim(ltrim(TMPOFFM_SLIP_NO)),ltrim(rtrim(SLIIM_SERIES_TYPE)),''))
,'1',SLIIM_SERIES_TYPE,'U','HO',getdate(),'HO',getdate(),1 
FROM #tmp_dptdc,TMP_DP_OFFM_DTLS_CDSL , slip_issue_mstr WHERE TMPOFFM_SLIP_NO = DPTDC_SLIP_NO 
and rtrim(ltrim(TMPOFFM_SLIP_NO)) like ltrim(rtrim(SLIIM_SERIES_TYPE)) + '%' 
and isnumeric(replace(rtrim(ltrim(TMPOFFM_SLIP_NO)),ltrim(rtrim(SLIIM_SERIES_TYPE)),'')) = 1
and convert(numeric,replace(rtrim(ltrim(TMPOFFM_SLIP_NO)),ltrim(rtrim(SLIIM_SERIES_TYPE)),'')) between convert(numeric,SLIIM_SLIP_NO_FR) and convert(numeric,SLIIM_SLIP_NO_TO) 
UNION
SELECT distinct @l_id_used_slip + ID1 , @l_dpm_id1 , SLIIM_DPAM_ACCT_NO , convert(numeric,replace(rtrim(ltrim(TMPOFFM_SLIP_NO)),ltrim(rtrim(SLIIM_SERIES_TYPE)),''))
,SLIIM_TRATM_ID,SLIIM_SERIES_TYPE,'U','HO',getdate(),'HO',getdate(),1 
FROM #tmp_dptdc,TMP_DP_OFFM_DTLS_CDSL , slip_issue_mstr_POA WHERE TMPOFFM_SLIP_NO = DPTDC_SLIP_NO 
and rtrim(ltrim(TMPOFFM_SLIP_NO)) like ltrim(rtrim(SLIIM_SERIES_TYPE)) + '%' 
and isnumeric(replace(rtrim(ltrim(TMPOFFM_SLIP_NO)),ltrim(rtrim(SLIIM_SERIES_TYPE)),'')) = 1
and convert(numeric,replace(rtrim(ltrim(TMPOFFM_SLIP_NO)),ltrim(rtrim(SLIIM_SERIES_TYPE)),'')) between convert(numeric,SLIIM_SLIP_NO_FR) and convert(numeric,SLIIM_SLIP_NO_TO) 
END
IF @PA_TRX_TAB  = 'INTERDP'
BEGIN
INSERT INTO used_slip
SELECT distinct  @l_id_used_slip + ID1 , @l_dpm_id1 , TMPINTDP_BO_ID , convert(numeric,replace(rtrim(ltrim(TMPINTDP_SLIP_NO)),ltrim(rtrim(SLIIM_SERIES_TYPE)),'')),'1',SLIIM_SERIES_TYPE,'U','HO',getdate(),'HO',getdate(),1 
FROM #tmp_dptdc_intdp,TMP_DP_INTDP_DTLS_CDSL , slip_issue_mstr WHERE TMPINTDP_SLIP_NO = DPTDC_SLIP_NO 
and rtrim(ltrim(TMPINTDP_SLIP_NO)) like ltrim(rtrim(SLIIM_SERIES_TYPE)) + '%' 
and isnumeric(replace(rtrim(ltrim(TMPINTDP_SLIP_NO)),ltrim(rtrim(SLIIM_SERIES_TYPE)),'')) = 1
and convert(numeric,replace(rtrim(ltrim(TMPINTDP_SLIP_NO)),ltrim(rtrim(SLIIM_SERIES_TYPE)),'')) between convert(numeric,SLIIM_SLIP_NO_FR) and convert(numeric,SLIIM_SLIP_NO_TO) 
UNION
SELECT distinct  @l_id_used_slip + ID1 , @l_dpm_id1 , SLIIM_DPAM_ACCT_NO , convert(numeric,replace(rtrim(ltrim(TMPINTDP_SLIP_NO)),ltrim(rtrim(SLIIM_SERIES_TYPE)),'')),SLIIM_TRATM_ID,SLIIM_SERIES_TYPE,'U','HO',getdate(),'HO',getdate(),1 
FROM #tmp_dptdc_intdp,TMP_DP_INTDP_DTLS_CDSL , slip_issue_mstr_POA WHERE TMPINTDP_SLIP_NO = DPTDC_SLIP_NO 
and rtrim(ltrim(TMPINTDP_SLIP_NO)) like ltrim(rtrim(SLIIM_SERIES_TYPE)) + '%' 
and isnumeric(replace(rtrim(ltrim(TMPINTDP_SLIP_NO)),ltrim(rtrim(SLIIM_SERIES_TYPE)),'')) = 1
and convert(numeric,replace(rtrim(ltrim(TMPINTDP_SLIP_NO)),ltrim(rtrim(SLIIM_SERIES_TYPE)),'')) between convert(numeric,SLIIM_SLIP_NO_FR) and convert(numeric,SLIIM_SLIP_NO_TO) 

END
IF @PA_TRX_TAB  = 'NP'
BEGIN 
INSERT INTO used_slip
SELECT distinct @l_id_used_slip + ID1 , @l_dpm_id1 , TMPNP_BO_ID , convert(numeric,replace(rtrim(ltrim(TMPNP_SLIP_NO)),ltrim(rtrim(SLIIM_SERIES_TYPE)),'')),'1',SLIIM_SERIES_TYPE,'U','HO',getdate(),'HO',getdate(),1 
FROM #tmp_dptdc_np,TMP_DP_NP_DTLS_CDSL, slip_issue_mstr WHERE TMPNP_SLIP_NO = DPTDC_SLIP_NO 
and rtrim(ltrim(TMPNP_SLIP_NO)) like ltrim(rtrim(SLIIM_SERIES_TYPE)) + '%' 
and isnumeric(replace(rtrim(ltrim(TMPNP_SLIP_NO)),ltrim(rtrim(SLIIM_SERIES_TYPE)),'')) = 1
and convert(numeric,replace(rtrim(ltrim(TMPNP_SLIP_NO)),ltrim(rtrim(SLIIM_SERIES_TYPE)),'')) between convert(numeric,SLIIM_SLIP_NO_FR) and convert(numeric,SLIIM_SLIP_NO_TO) 
UNION
SELECT distinct @l_id_used_slip + ID1 , @l_dpm_id1 , SLIIM_DPAM_ACCT_NO , convert(numeric,replace(rtrim(ltrim(TMPNP_SLIP_NO)),ltrim(rtrim(SLIIM_SERIES_TYPE)),'')),SLIIM_TRATM_ID,SLIIM_SERIES_TYPE,'U','HO',getdate(),'HO',getdate(),1 
FROM #tmp_dptdc_np,TMP_DP_NP_DTLS_CDSL, slip_issue_mstr_POA WHERE TMPNP_SLIP_NO = DPTDC_SLIP_NO 
and rtrim(ltrim(TMPNP_SLIP_NO)) like ltrim(rtrim(SLIIM_SERIES_TYPE)) + '%' 
and isnumeric(replace(rtrim(ltrim(TMPNP_SLIP_NO)),ltrim(rtrim(SLIIM_SERIES_TYPE)),'')) = 1
and convert(numeric,replace(rtrim(ltrim(TMPNP_SLIP_NO)),ltrim(rtrim(SLIIM_SERIES_TYPE)),'')) between convert(numeric,SLIIM_SLIP_NO_FR) and convert(numeric,SLIIM_SLIP_NO_TO) 
END
IF @PA_TRX_TAB  = 'EP'
BEGIN
INSERT INTO used_slip
SELECT distinct @l_id_used_slip + ID1 , @l_dpm_id1 , TMPEP_BO_ID , convert(numeric,replace(rtrim(ltrim(TMPEP_SLIP_NO)),ltrim(rtrim(SLIIM_SERIES_TYPE)),'')),'1',SLIIM_SERIES_TYPE,'U','HO',getdate(),'HO',getdate(),1 
FROM #tmp_dptdc_ep,TMP_DP_EP_DTLS_CDSL , slip_issue_mstr WHERE TMPEP_SLIP_NO = DPTDC_SLIP_NO 
and rtrim(ltrim(TMPEP_SLIP_NO)) like ltrim(rtrim(SLIIM_SERIES_TYPE)) + '%' 
and isnumeric(replace(rtrim(ltrim(TMPEP_SLIP_NO)),ltrim(rtrim(SLIIM_SERIES_TYPE)),'')) = 1
and convert(numeric,replace(rtrim(ltrim(TMPEP_SLIP_NO)),ltrim(rtrim(SLIIM_SERIES_TYPE)),'')) between convert(numeric,SLIIM_SLIP_NO_FR) and convert(numeric,SLIIM_SLIP_NO_TO) 
UNION
SELECT distinct @l_id_used_slip + ID1 , @l_dpm_id1 , SLIIM_DPAM_ACCT_NO , convert(numeric,replace(rtrim(ltrim(TMPEP_SLIP_NO)),ltrim(rtrim(SLIIM_SERIES_TYPE)),'')),SLIIM_TRATM_ID,SLIIM_SERIES_TYPE,'U','HO',getdate(),'HO',getdate(),1 
FROM #tmp_dptdc_ep,TMP_DP_EP_DTLS_CDSL , slip_issue_mstr_POA WHERE TMPEP_SLIP_NO = DPTDC_SLIP_NO 
and rtrim(ltrim(TMPEP_SLIP_NO)) like ltrim(rtrim(SLIIM_SERIES_TYPE)) + '%' 
and isnumeric(replace(rtrim(ltrim(TMPEP_SLIP_NO)),ltrim(rtrim(SLIIM_SERIES_TYPE)),'')) = 1
and convert(numeric,replace(rtrim(ltrim(TMPEP_SLIP_NO)),ltrim(rtrim(SLIIM_SERIES_TYPE)),'')) between convert(numeric,SLIIM_SLIP_NO_FR) and convert(numeric,SLIIM_SLIP_NO_TO) 
END 

END

GO
