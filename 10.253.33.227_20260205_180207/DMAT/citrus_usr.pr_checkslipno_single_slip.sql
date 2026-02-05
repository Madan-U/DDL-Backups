-- Object: PROCEDURE citrus_usr.pr_checkslipno_single_slip
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--19076




--SELECT * FROM DP_MSTR
--pr_checkslipno 'Y','ONc2p_DP_TRX_SEL','IN300175','','2679501','',''  
create   procedure [citrus_usr].[pr_checkslipno_single_slip]  
(  
@validateonly char(1), -- Y to validate only, N to process slip  
@trans_code varchar(50),  
@dpid varchar(8),  
@accountno varchar(20),  
@slipno varchar(20),  
@pa_login_name  varchar(50),  
@pa_errmsg  varchar(8000) output  
)  
as  
begin   
  
DECLARE @@AllSlipused char(1),  
@@series varchar(10),  
@@date_cr   datetime,  
@l_dpm_id   varchar(20),  
@@sr_no     varchar(20),  
@@acct_no   varchar(50) ,
@@cmbp_id   varchar(25),
@l_uses_id  numeric(10,0),
@l_trans    varchar(50)

  
SET @@series = ''  
 IF @trans_code = '1'      
	BEGIN      
	--      
	SET @trans_code  = '1'       
	--      
	END      
 ELSE IF @trans_code = 'DEMRM_SEL'  
 BEGIN  
 --  
 SET @trans_code  = '901'   
 --  
 END  
 ELSE IF @trans_code = 'REMRM_SEL'  
 BEGIN  
 --  
 SET @trans_code  = '902'   
 --  
 END  
 ELSE IF @trans_code = 'INT_DP_TRX_SEL'  
 BEGIN  
 --  
 SET @trans_code  = '904_ACT'  

 --  
 END  
 ELSE IF @trans_code = 'INT_DP_R_TRX_SEL'  
  BEGIN  
  --  
  SET @trans_code  = '926'  
 
  --  
 END  
 ELSE IF @trans_code = 'P2P_DP_TRX_SEL'  
 BEGIN  
 --  
 SET @trans_code  = '934' 
 SET @l_trans     = 'P2P_DP_TRX_SEL'  
 --  
 END  
 ELSE IF @trans_code = 'ONC2P_DP_TRX_SEL'  
 BEGIN  
 --  
 SET @trans_code  = '904_ACT'  
 --  
 END   
 ELSE IF @trans_code = 'ONC2P_R_DP_TRX_SEL'  
 BEGIN  
  --  
  SET @trans_code  = '905_ACT'  
  --  
 END   
 ELSE IF @trans_code = 'ONP2C_DP_TRX_SEL'  
 BEGIN  
 --  
 SET @trans_code  = '904_P2C'  
 SET @l_trans     = 'ONP2C_DP_TRX_SEL'  
 --  
 END  
 ELSE IF @trans_code = 'OFFM_DP_TRX_SEL'  
 BEGIN  
 --  
 SET @trans_code  = '904_ACT'   
 --  
 END
 ELSE IF @trans_code = 'OFFM_R_DP_TRX_SEL'  
  BEGIN  
  --  
  SET @trans_code  = '905_ACT'   
  --  
 END  
 ELSE IF @trans_code = 'DELOUT_DP_TRX_SEL_R'  
 BEGIN  
 --  
 SET @trans_code  = '906'   
 --  
 END  
 ELSE IF @trans_code = 'DELOUT_DP_TRX_SEL_I'  
 BEGIN  
 --  
 SET @trans_code  = '906'   
 --  
 END  
 ELSE IF @trans_code = 'INTERSETM_TRX_SEL'  
 BEGIN  
 --  
 SET @trans_code  = '907' 
 SET @l_trans     = 'INTERSETM_TRX_SEL'  
 --  
 END  
 ELSE
 BEGIN
 --
   SET @trans_code  = '' 
 --
 END
 
 SELECT @l_dpm_id  = dpm_id from dp_mstr where dpm_dpid  = @dpid and dpm_deleted_ind  = 1  
   
 IF @trans_code  = '1' 
 BEGIN
 --
   SELECT @@series=ltrim(rtrim(ISNULL(SLIBM_SERIES_TYPE,'')))   
			from slip_book_mstr  
								,transaction_sub_type_mstr  
								,transaction_type_mstr
			WHERE  trastm_cd          = @trans_code   
			AND    SLIBM_tratm_id     = trastm_id  
			AND    trantm_id          = trastm_tratm_id
			AND    trantm_code        = 'SLIP_TYPE_CDSL'
			AND    SLIBM_DPM_ID    = @l_dpm_id   
			AND @slipno like ltrim(rtrim(slibm_series_type)) + '%' AND SLIBM_DELETED_IND =1  
			AND  ISNULL(SLIBM_SERIES_TYPE,'')    <> ''

 --
 END
 ELSE IF @trans_code not in ('901','902')
 BEGIN
 --
			SELECT @@series=ltrim(rtrim(ISNULL(SLIBM_SERIES_TYPE,'')))   
			from slip_book_mstr  
								,transaction_sub_type_mstr   
								,transaction_type_mstr
			WHERE  trastm_cd          = @trans_code   
			AND    SLIBM_tratm_id     = trastm_id 
			AND    trantm_id          = trastm_tratm_id
			AND    trantm_code        = 'SLIP_TYPE_NSDL'
			AND    SLIBM_DPM_ID    = @l_dpm_id   
			AND   @slipno like ltrim(rtrim(slibm_series_type)) + '%' AND SLIBM_DELETED_IND =1 
			and   ltrim(rtrim(isnull(slibm_series_type,'')))  <> ''

	--
	END
  
 SET @@sr_no = REPLACE(@slipno,@@series,'')  
  
 IF ISNUMERIC(@@sr_no) = 0  and @trans_code not in ('901','902')
 BEGIN  
  SET @pa_errmsg =  'Invalid Slip No.' + '|*~|1'   
  RETURN  
 END  
   
 IF @accountno <> ''  
 BEGIN  
  SELECT distinct @@AllSlipused = sliim_all_used  
       , @@cmbp_id     = accp_value      
  FROM   slip_issue_mstr   
  ,      transaction_sub_type_mstr  
  ,      dp_acct_mstr  left outer join
         account_properties on accp_clisba_id = dpam_id and accp_deleted_ind = 1  and accp_accpm_prop_cd = 'CMBP_iD'  and isnull(accp_value ,'') <> ''
  WHERE  trastm_cd          = @trans_code    
  AND    sliim_dpam_acct_no = @accountno 
  AND    sliim_tratm_id     = trastm_id  
  AND    sliim_dpam_acct_no = dpam_sba_no
  AND    sliim_dpm_id       = @l_dpm_id  
  AND    sliim_series_type  = @@series  
  AND    convert(bigint,@@sr_no) between convert(bigint,sliim_slip_no_fr) and convert(bigint,sliim_slip_no_to)  
  AND    sliim_deleted_ind  = 1  
  AND    trastm_deleted_ind = 1 
  
   
  IF isnull(@@AllSlipused,'') = '' and @trans_code not in ('901','902')
  BEGIN  
  set @pa_errmsg = 'Slip no. not issued to selected client' + '|*~|1' 
  
  RETURN
  END  
  IF @@AllSlipused = '1'  and @trans_code not in ('901','902')
  BEGIN  
  set @pa_errmsg = 'Slip no. has already been used' + '|*~|1'  

  RETURN
  END  
  ELSE  
  BEGIN  
   IF EXISTS(SELECT uses_slip_no FROM used_slip WHERE  uses_dpam_acct_no = @accountno AND uses_trantm_id = @trans_code and USES_SLIP_NO = @@sr_no  and uses_dpm_id = @l_dpm_id and USES_SERIES_TYPE = @@series and USES_DELETED_IND = 1)  
   BEGIN  
    set @pa_errmsg =  'Slip no. has already been used' + '|*~|1'   

    RETURN
   END  
   ELSE  
   BEGIN
    IF @trans_code = 'INTERSETM_TRX_SEL' 
    BEGIN
    --
      set @pa_errmsg = ISNULL(@accountno,'') + '|*~|0'  + '|*~|' + isnull(@@cmbp_id ,'')
      
    --
    END
    ELSE
    BEGIN
    --
      set @pa_errmsg = ISNULL(@accountno,'') + '|*~|0'  
      
    --
    END
   END  
  END  
   
  IF (@validateonly <> 'Y')  
  BEGIN  
   select @l_uses_id = isnull(max(uses_id),0) + 1 from used_slip 
   
   INSERT INTO used_slip(USES_ID,USES_DPM_ID,USES_DPAM_ACCT_NO,USES_SLIP_NO,USES_TRANTM_ID,USES_SERIES_TYPE,USES_USED_DESTR,USES_CREATED_BY,USES_CREATED_DT,USES_LST_UPD_BY,USES_LST_UPD_DT,USES_DELETED_IND)  
   VALUES(@l_uses_id,@l_dpm_id,@accountno,@@sr_no,@trans_code,@@series,'U',@pa_login_name,getdate(),@pa_login_name,getdate(),1)   
   -- USES_ID IS HARDCODED, SHOULD BE INCREMENTAL   
   set @pa_errmsg =''  
  END  
 END  
 ELSE    if  @accountno = ''   AND @trans_code not in ('901','902')
 BEGIN  
   SELECT distinct @@acct_no = Right(ltrim(rtrim(sliim_dpam_acct_no)),8)  
        , @@cmbp_id     = accp_value        
   FROM   slip_issue_mstr   
   ,      transaction_sub_type_mstr  
   ,      dp_acct_mstr  left outer join
          account_properties on accp_clisba_id = dpam_id and accp_deleted_ind = 1  and accp_accpm_prop_cd = 'CMBP_iD'  AND    isnull(accp_value ,'') <> ''
   WHERE  trastm_cd          = @trans_code   
   AND    sliim_tratm_id     = trastm_id  
   AND    dpam_sba_no       = sliim_dpam_acct_no
   AND    sliim_dpm_id       = @l_dpm_id  
   AND    sliim_series_type  = @@series  
   AND    convert(bigint,@@sr_no) between convert(bigint,sliim_slip_no_fr) and convert(bigint,sliim_slip_no_to)  
   AND    sliim_deleted_ind  = 1  
   AND    trastm_deleted_ind = 1 

   
      
      
   if ltrim(rtrim(isnull(@@acct_no,''))) = ''  
   BEGIN  
    set @pa_errmsg = 'Slip no. not issued to client|*~|1'  
    RETURN
   END  
   ELSE  
   BEGIN  

    IF EXISTS(SELECT uses_slip_no FROM used_slip WHERE   uses_trantm_id = @trans_code and USES_SLIP_NO = @@sr_no  and uses_dpm_id = @l_dpm_id and USES_SERIES_TYPE = @@series and USES_DELETED_IND = 1)  
   
						BEGIN  
        set @pa_errmsg =  'Slip no. has already been used' + '|*~|1'  
       
        RETURN
						END  


    IF @l_trans     = 'INTERSETM_TRX_SEL'    or @l_trans     = 'ONP2C_DP_TRX_SEL'   or @l_trans     = 'P2P_DP_TRX_SEL'   
				BEGIN
				--
                  
						set @pa_errmsg = ISNULL(@@acct_no,'') + '|*~|0' + '|*~|' + isnull(@@cmbp_id ,'') 


      RETURN
				--
				END
				ELSE
				BEGIN
				--
						  SET @pa_errmsg = ISNULL(@@acct_no,'') + '|*~|0'  

        RETURN
     
      
				--
    END
   END  
   
 END  

END

GO
