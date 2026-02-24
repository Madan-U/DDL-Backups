-- Object: PROCEDURE citrus_usr.PR_NSDL_IMP_TRX_quant
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--begin tran
--ROLLBACK TRAN
--PR_NSDL_IMP_TRX 'HO','0005780' ,'4','','','',11366,''
--update tmp_dp_trx_dtls set tmpdptd_acct_id ='12345678' , TMPDPTD_INTERNAL_REF_NO = ''
--DELETE  FROM DPTD_MAK
--insert into bitmap_ref_mstr 
--select max(bitrm_id) + 1 , 'BRK_VLD_YN_NSDL','BRK_VLD_YN_NSDL','1','1','','ho',getdate(),'ho',getdate(),1 from bitmap_ref_mstr
 
CREATE  PROCEDURE [citrus_usr].[PR_NSDL_IMP_TRX_quant] (  
@PA_LOGIN_NAME VARCHAR(20),  
@PA_BATCH_NO VARCHAR(30)  ,
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
  
DECLARE  @L_MAX_DPTD_ID1 BIGINT 
, @L_MAX_DPTD_ID2 BIGINT 
, @L_MAX_DPTD_DTLS_ID1 BIGINT 
, @L_MAX_DPTD_DTLS_ID2 BIGINT
, @L_DPM_ID BIGINT 
, @l_err_mstr  VARCHAR(8000)
, @l_uses_id numeric(10,0)
,@l_id1 numeric(10,0)
,@l_id2 numeric(10,0)
,@l_err_MISSING_ISIN VARCHAR(8000)
  
SELECT @l_dpm_id = DPM_ID FROM DP_MSTR WHERE DPM_EXCSM_ID = @PA_EXCSM_ID AND DEFAULT_DP = @PA_EXCSM_ID AND DPM_DELETED_IND = 1   --

IF EXISTS(SELECT TOP 1 ISNULL(DPTD_ID,0) FROM DP_TRX_DTLS , DP_ACCT_MSTR WHERE DPTD_BROKERBATCH_NO IN (SELECT TMPDPTD_BROKERBATCH_NO FROM TMP_DP_TRX_DTLS) AND DPAM_ID = DPTD_DPAM_ID AND DPAM_DPM_ID = @l_dpm_id AND DPAM_DELETED_IND = 1 AND DPTD_DELETED_IND = 1 ) 
  OR EXISTS(SELECT TOP 1 ISNULL(DPTD_ID,0) FROM DPTD_MAK, DP_ACCT_MSTR WHERE DPTD_BROKERBATCH_NO IN (SELECT TMPDPTD_BROKERBATCH_NO FROM TMP_DP_TRX_DTLS) AND DPAM_ID = DPTD_DPAM_ID AND DPAM_DPM_ID = @l_dpm_id AND DPAM_DELETED_IND  = 1 AND DPTD_DELETED_IND = 0 )
BEGIN
--
  /*SET @PA_ERRMSG = 'SELECTED BATCH NO ALREADY EXISTS.'
  SELECT ERRMSG =  @PA_ERRMSG, ERROR ='B'
  */
  UPDATE filetask
		SET    usermsg = 'File Could Not Be Uploaded Please Verify. ERROR : Selected Batch No Already Exists: ' + @PA_BATCH_NO
  ,      STATUS = 'FAILED' 
		WHERE  task_id = @pa_task_id

		return

--
END
/*ELSE IF NOT EXISTS(SELECT TOP 1 ISNULL(DPAM_ID,0) FROM DP_ACCT_MSTR WHERE DPAM_SBA_NO IN (SELECT TMPDPTD_ACCT_ID FROM TMP_DP_TRX_DTLS) AND DPAM_DPM_ID = @L_DPM_ID AND DPAM_DELETED_IND =1)
BEGIN
--  
  SELECT DISTINCT TMPDPTD_ACCT_ID , ERROR = 'C' FROM TMP_DP_TRX_DTLS
  WHERE TMPDPTD_ACCT_ID NOT IN (SELECT DPAM_sba_NO FROM DP_ACCT_MSTR WHERE DPAM_DELETED_IND = 1 )
--
END
ELSE*/

    select @l_err_mstr = isnull(replace(citrus_usr.fn_merge_str('NSDL_IMP',0,''),',',''),'')

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
				

    select @l_err_mstr = isnull(replace(citrus_usr.fn_merge_str('NSDL_CMBP',0,''),',',''),'')
    print @l_err_mstr
				IF @l_err_mstr  <> ''
				BEGIN
				--
						UPDATE filetask
						SET    usermsg = 'File Could Not Be Uploaded Please Verify. ERROR : Slip not issued to following Pool Client : ' + @l_err_mstr
						,      STATUS = 'FAILED' 
						WHERE  task_id = @pa_task_id

						return

				--
    END

   select @l_err_mstr = isnull(replace(citrus_usr.fn_merge_str('NSDL_SLIP_LEN',0,''),',',''),'')
   print @l_err_mstr
   IF @l_err_mstr  <> ''
   BEGIN
			--
			UPDATE filetask
			SET    usermsg = 'File Could Not Be Uploaded Please Verify. ERROR : Slip is not in currect format : ' + @l_err_mstr
			,      STATUS = 'FAILED' 
			WHERE  task_id = @pa_task_id

			return
			--
    END 

    select @l_err_mstr = isnull(replace(citrus_usr.fn_merge_str('NSDL_ACCT',0,''),',',''),'')
				
	IF @l_err_mstr  <> ''
	BEGIN
	--
			UPDATE filetask
			SET    usermsg = 'File Could Not Be Uploaded Please Verify. ERROR : Following Client are Missing Or Inactive : ' + @l_err_mstr
			,      STATUS = 'FAILED' 
			WHERE  task_id = @pa_task_id

			return
	--
    END

    select @l_err_MISSING_ISIN = isnull(replace(citrus_usr.fn_merge_str('NSDL_ISIN',0,''),',',''),'')
				
	IF @l_err_MISSING_ISIN  <> ''
	BEGIN
	--
			UPDATE filetask
			SET    usermsg = 'File Could Not Be Uploaded Please Verify. ERROR : Following ISINs are Missing : ' + @l_err_MISSING_ISIN
			,      STATUS = 'FAILED' 
			WHERE  task_id = @pa_task_id

			return

	--
    END

    
    
BEGIN
--
  SELECT distinct IDENTITY(INT, 1, 1) ID1,  TMPDPTD_SLIP_NO DPTD_SLIP_NO INTO #tmp_dptd FROM tmp_dp_trx_dtls

--  SELECT @L_MAX_DPTD_ID1 = ISNULL(MAX(DPTD_ID),0),@L_MAX_DPTD_DTLS_ID1 = ISNULL(MAX(DPTD_DTLS_ID),0)  FROM DPTD_MAK WHERE DPTD_DELETED_IND = 0  
--  
--  SELECT @L_MAX_DPTD_ID2 = ISNULL(MAX(DPTD_ID),0) , @L_MAX_DPTD_DTLS_ID2 = ISNULL(MAX(DPTD_DTLS_ID),0) FROM DP_TRX_DTLS WHERE DPTD_DELETED_IND = 1
--  
--  IF @L_MAX_DPTD_ID1 < @L_MAX_DPTD_ID2 
--  BEGIN
--  --
--    SET @L_MAX_DPTD_ID1 = @L_MAX_DPTD_ID2 
--  --
--  END
--  
--  IF @L_MAX_DPTD_DTLS_ID1 < @L_MAX_DPTD_DTLS_ID2 
--		BEGIN
--		--
--				SET @L_MAX_DPTD_DTLS_ID1 = @L_MAX_DPTD_DTLS_ID2 
--		--
--  END

begin transaction

select @L_MAX_DPTD_ID1 = bitrm_bit_location from bitmap_ref_mstr where bitrm_parent_cd = 'DPTD_ID' 
select @L_MAX_DPTD_DTLS_ID1 = bitrm_bit_location from bitmap_ref_mstr where bitrm_parent_cd = 'DPTD_DTLS_ID' 




select @l_id1 = count (distinct TMPDPTD_SLIP_NO) from TMP_DP_TRX_DTLS
select @l_id2 = count (*) from TMP_DP_TRX_DTLS

update bitmap_ref_mstr set bitrm_bit_location =  @L_MAX_DPTD_DTLS_ID1+@l_id1+1  where bitrm_parent_cd = 'DPTD_DTLS_ID' 
update bitmap_ref_mstr set bitrm_bit_location =  @L_MAX_DPTD_ID1+@l_id2+1  where bitrm_parent_cd = 'DPTD_ID' 



commit transaction

  UPDATE  TMP
  SET     TMPDPTD_ACCT_ID = DPAM_ID
         ,TMPDPTD_INTERNAL_REF_NO =  convert(varchar,(@L_MAX_DPTD_ID1  + TMPDPTD_ID))
  FROM    DP_ACCT_MSTR 
         ,TMP_DP_TRX_DTLS TMP
  WHERE   DPam_sba_NO = convert(varchar,TMPDPTD_ACCT_ID)
  AND     DPAM_DPM_ID  = @L_DPM_ID 


  create table #temp_pool_acct(dpamid numeric, cmbp_id VARCHAR(8))

insert into #temp_pool_acct 
select ACCP_CLISBA_ID, accp_value from account_properties, dp_acct_mstr  where dpam_id = accp_clisba_id 
and ACCP_ACCPM_PROP_CD = 'CMBP_ID' and isnull(accp_value ,'') <> '' 
and dpam_enttm_cd = '03'

  UPDATE  TMP
  SET     TMPDPTD_INTERNAL_TRASTM = 'P2C'
  FROM    #temp_pool_acct 
         ,TMP_DP_TRX_DTLS TMP
  WHERE  dpamid = TMPDPTD_ACCT_ID 
  and    TMPDPTD_TRASTM_CD = '904' 
  



  UPDATE  TMP
  SET     TMPDPTD_INTERNAL_TRASTM = 'C2P'
  FROM    TMP_DP_TRX_DTLS TMP
  WHERE  NOT EXISTS (SELECT DPAMID FROM #temp_pool_acct WHERE dpamid = TMPDPTD_ACCT_ID )
  AND TMPDPTD_COUNTER_CMBP_ID IN (SELECT cmbp_id FROM #temp_pool_acct)
  and    TMPDPTD_TRASTM_CD = '904' 
  
  UPDATE  TMP
  SET     TMPDPTD_INTERNAL_TRASTM = 'C2C'
  FROM    TMP_DP_TRX_DTLS TMP
  WHERE  TMPDPTD_INTERNAL_TRASTM = ''
  and    TMPDPTD_TRASTM_CD = '904' 

set @L_ERR_MISSING_ISIN = ''
    if exists(select TMPDPTD_SLIP_NO from TMP_DP_TRX_DTLS, used_slip where USES_TRANTM_ID = TMPDPTD_TRASTM_CD  and rtrim(ltrim(TMPDPTD_SLIP_NO)) = ltrim(rtrim(USES_SLIP_NO)))
    begin

     SELECT distinct @L_ERR_MISSING_ISIN = ISNULL(@L_ERR_MISSING_ISIN,'')  + TMPDPTD_SLIP_NO + ',' from TMP_DP_TRX_DTLS, used_slip where LEFT(USES_TRANTM_ID,3) = TMPDPTD_TRASTM_CD  and rtrim(ltrim(TMPDPTD_SLIP_NO)) = ltrim(rtrim(USES_SLIP_NO))

        UPDATE filetask
		SET    usermsg = 'File Could Not Be Uploaded Please Verify. ERROR : Following Slips are already used : ' + @L_ERR_MISSING_ISIN
		,      status = 'FAILED'
		WHERE  task_id = @pa_task_id

    return 
  
    end 

--    set @L_ERR_MISSING_ISIN = ''
--	if exists(select bitrm_id from bitmap_ref_mstr where bitrm_parent_cd = 'BRK_VLD_YN_NSDL' and BITRM_BIT_LOCATION = 1)
--	begin
--	  if exists(select TMPDPTD_INTERNAL_TRASTM from TMP_DP_TRX_DTLS where TMPDPTD_INTERNAL_TRASTM <> 'C2P')
--	  begin
--	   if exists(select TMPDPTD_SLIP_NO from TMP_DP_TRX_DTLS where not exists(select sliim_id from slip_issue_mstr , transaction_sub_type_mstr 
--                 where trastm_id = SLIIM_TRATM_ID and left(trastm_cd,3) = TMPDPTD_TRASTM_CD  
--                 and ( convert(bigint,TMPDPTD_SLIP_NO) between SLIIM_SLIP_NO_FR and SLIIM_SLIP_NO_TO )  
--                 and SLIIM_ENTM_ID = TMPDPTD_ACCT_ID 
--                 and sliim_deleted_ind = 1 and trastm_deleted_ind = 1))
--	   begin
--
--        SELECT distinct @L_ERR_MISSING_ISIN = ISNULL(@L_ERR_MISSING_ISIN,'')  +  TMPDPTD_SLIP_NO + ':' + dpam_sba_no  + ',' from TMP_DP_TRX_DTLS , dp_Acct_mstr 
--                 where not exists(select sliim_id from slip_issue_mstr , transaction_sub_type_mstr 
--                 where trastm_id = SLIIM_TRATM_ID and left(trastm_cd,3) = TMPDPTD_TRASTM_CD  
--                 and ( convert(bigint,TMPDPTD_SLIP_NO) between SLIIM_SLIP_NO_FR and SLIIM_SLIP_NO_TO )  
--                 and SLIIM_ENTM_ID = TMPDPTD_ACCT_ID 
--                 and sliim_deleted_ind = 1 and trastm_deleted_ind = 1)
--        and dpam_id = TMPDPTD_ACCT_ID
--
--        UPDATE filetask
--		SET    usermsg = 'File Could Not Be Uploaded Please Verify. ERROR : Following Slips are not Issued to clients : ' + @L_ERR_MISSING_ISIN
--		,      status = 'FAILED'
--		WHERE  task_id = @pa_task_id
--
--         
--		   return
--	   end 
--	  end
--	end  


  INSERT INTO DPTD_MAK
		(DPTD_ID
		,DPTD_DPAM_ID
		,DPTD_REQUEST_DT
		,DPTD_SLIP_NO
		,DPTD_ISIN
	 ,DPTD_BATCH_NO
		,DPTD_LINE_NO
		,DPTD_QTY
		,DPTD_INTERNAL_REF_NO
		,DPTD_TRANS_NO
		,DPTD_MKT_TYPE
		,DPTD_SETTLEMENT_NO
		,DPTD_EXECUTION_DT
		,DPTD_OTHER_SETTLEMENT_TYPE
		,DPTD_OTHER_SETTLEMENT_NO
		,DPTD_COUNTER_DP_ID
		,DPTD_COUNTER_CMBP_ID
		,DPTD_COUNTER_DEMAT_ACCT_NO
		,DPTD_CREATED_BY
		,DPTD_CREATED_DT
		,DPTD_LST_UPD_BY
		,DPTD_LST_UPD_DT
		,DPTD_DELETED_IND
		,DPTD_TRASTM_CD
		,dptd_dtls_id
		,DPTD_BOOKING_NARRATION
		,DPTD_BOOKING_TYPE
		,DPTD_CONVERTED_QTY
		,DPTD_REASON_CD
		,DPTD_STATUS
		,DPTD_INTERNAL_TRASTM
		,DPTD_OTHERS_CL_NAME
		,DPTD_RMKS
		,DPTD_BROKERBATCH_NO
		,DPTD_BROKER_INTERNAL_REF_NO
		)                   
		SELECT    
		@L_MAX_DPTD_ID1  + TMPDPTD_ID,  
		convert(numeric,TMPDPTD_ACCT_ID),  
		CONVERT(DATETIME,TMPDPTD_REQUEST_DT,103),  
		TMPDPTD_SLIP_NO,  
		TMPDPTD_ISIN,     
		TMPDPTD_BATCH_NO ,  
	    TMPDPTD_LINE_NO,  
		TMPDPTD_QTY ,  
		TMPDPTD_INTERNAL_REF_NO,  
		TMPDPTD_TRANS_NO ,  
		CASE WHEN TMPDPTD_TRASTM_CD  = '904'  THEN cASE WHEN TMPDPTD_INTERNAL_TRASTM = 'P2C' THEN  citrus_usr.fn_merge_str( 'settm_type_NSDL',0,TMPDPTD_MKT_TYPE)  ELSE '' END ELSE  citrus_usr.fn_merge_str( 'settm_type_NSDL',0,TMPDPTD_MKT_TYPE) END,  
		CASE WHEN TMPDPTD_TRASTM_CD  = '904'  THEN CASE WHEN TMPDPTD_INTERNAL_TRASTM = 'P2C' THEN  TMPDPTD_SETTLEMENT_NO ELSE '' END ELSE TMPDPTD_SETTLEMENT_NO  END,  
		CONVERT(DATETIME,TMPDPTD_EXECUTION_DT,103), 
        CASE WHEN TMPDPTD_TRASTM_CD  = '904'  THEN CASE WHEN TMPDPTD_INTERNAL_TRASTM = 'C2P' THEN   citrus_usr.fn_merge_str( 'settm_type_NSDL',0,TMPDPTD_MKT_TYPE) ELSE '' END ELSE  citrus_usr.fn_merge_str( 'settm_type_NSDL',0,TMPDPTD_OTHER_SETTLEMENT_TYPE) END,  
		CASE WHEN TMPDPTD_TRASTM_CD  = '904'  THEN CASE WHEN TMPDPTD_INTERNAL_TRASTM = 'C2P' THEN  TMPDPTD_SETTLEMENT_NO ELSE '' END ELSE TMPDPTD_OTHER_SETTLEMENT_NO  END, 
		TMPDPTD_COUNTER_DP_ID  ,  
		TMPDPTD_COUNTER_CMBP_ID ,  
		TMPDPTD_COUNTER_DEMAT_ACCT_NO ,  
		@PA_LOGIN_NAME,  
		GETDATE(),  
		@PA_LOGIN_NAME,  
		GETDATE() ,  
		0,--case when case when citrus_usr.fn_get_high_val('',0,'DORMANT',TMPDPTD_ACCT_ID,convert(datetime,TMPDPTD_REQUEST_DT,103)) = 'Y' then 'Y' else citrus_usr.fn_get_high_val(TMPDPTD_ISIN,abs(TMPDPTD_QTY),'HIGH_VALUE','','') end = 'Y' then -1 else 0 end,
		TMPDPTD_TRASTM_CD ,  
		id1+@L_MAX_DPTD_DTLS_ID1,  
		NULL, 
		NULL,
		NULL,
		NULL,
		'P' ,  
		TMPDPTD_INTERNAL_TRASTM ,  
								'',  
								'',  
 TMPDPTD_BROKERBATCH_NO,
 TMPDPTD_BROKER_INTERNAL_REF_NO  
 FROM TMP_DP_TRX_DTLS  
    , #tmp_dptd
 WHERE  DPTD_SLIP_NO =  TMPDPTD_SLIP_NO order by TMPDPTD_ID


  select @l_uses_id = ISNULL(max(uses_id),0) from used_slip 




select identity(bigint,1,1) id  , a.dpm_id , a.dpam_sba_no, a.slip , a.DPTD_TRASTM_CD ,a.series into #dptd 
from (select distinct  @l_dpm_id dpm_id 
,dpam_sba_no
,replace(dptd_slip_no, ltrim(rtrim(SLIIM_SERIES_TYPE)),'') slip
,DPTD_TRASTM_CD
,ltrim(rtrim(SLIIM_SERIES_TYPE)) series 
from dptd_mak 
, dp_acct_mstr , slip_issue_mstr , transaction_sub_type_mstr
where isnumeric(isnull(dpam_sba_no,''))=1 and dptd_dpam_id = dpam_id and SLIIM_DPAM_ACCT_NO = dpam_sba_no and SLIIM_TRATM_ID = TRASTM_ID 
--and dptd_trastm_cd = left(TRASTM_CD,3) 
and SLIIM_SERIES_TYPE not like 'poa%'
and CASE WHEN dptd_trastm_cd = '912' THEN '906' when (dptd_trastm_cd='925' and DPTD_INTERNAL_TRASTM='IDD') THEN '904' ELSE dptd_trastm_cd END = left(TRASTM_CD,3) 
and   DPTD_BROKERBATCH_NO = @PA_BATCH_NO
and ltrim(rtrim(SLIIM_SERIES_TYPE)) = left(dptd_slip_no,5)
and   abs(convert(numeric,replace(dptd_slip_no, ltrim(rtrim(SLIIM_SERIES_TYPE)),''))) between convert(numeric,SLIIM_SLIP_NO_FR) and convert(numeric,SLIIM_SLIP_NO_TO))  a 


declare @l_slip varchar(100)
select @l_slip  = TMPDPTD_SLIP_NO from TMP_DP_TRX_DTLS 										
insert into #dptd
select dpm_id,'',@l_slip,'',''
from dp_mstr , exch_seg_mstr where dpm_excsm_id  = default_dp 
and dpm_deleted_ind = 1 
and excsm_id = dpm_excsm_id 
and excsm_exch_cd = 'NSDl'
and @l_slip like 'poa%'

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
											)select  @l_uses_id + id , a.dpm_id , a.dpam_sba_no, a.slip , a.DPTD_TRASTM_CD ,a.series,'U',@pa_login_name
											,getdate()
											,@pa_login_name
											,getdate()
											,1
                                            from #dptd a 
					 	
 SELECT TMPDPTD_INTERNAL_REF_NO AS INTERNAL_REF_NO , TMPDPTD_BROKER_INTERNAL_REF_NO AS BROKER_INTERNAL_REF_NO, TMPDPTD_BROKERBATCH_NO AS BROKER_BATCH_NO,ERROR = ''
 FROM   TMP_DP_TRX_DTLS
  
--
END





  
END

GO
