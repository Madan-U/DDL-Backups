-- Object: PROCEDURE citrus_usr.pr_checkslipno_demat
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------




--BEGIN TRAN
--[pr_checkslipno_demat] 'N','DEMRM_SEL','IN300175','10610199','Q123','VISHAL',''
--ROLLBACK
CREATE procedure [citrus_usr].[pr_checkslipno_demat]      
(      
		@validateonly char(1), -- Y to validate only, N to process slip      
		@trans_code varchar(50),      
		@dpid varchar(8),      
		@accountno varchar(20),      
		@slipno varchar(20),      
		@pa_login_name  varchar(50),      
		@pa_errmsg  varchar(8000) output      
)      
AS      

BEGIN       
      
DECLARE @@AllSlipused char(1),      
@@series varchar(10),      
@@date_cr   datetime,      
@l_dpm_id   varchar(20),      
@@sr_no     varchar(25),      
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
 
     
 SELECT @l_dpm_id  = dpm_id from dp_mstr where dpm_dpid  = @dpid and dpm_deleted_ind  = 1      
       
 
      
 SET @@sr_no = REPLACE(@slipno,@@series,'')      
  --commented in case of angel where preverification maker n checker not require by Latesh P W on May 24 2016

--if not exists(select boid from dis_req_dtls_mak where slip_yn = 'D' and req_slip_no = @slipno)
--begin
--	set @pa_errmsg = 'Request not entered in preverification window! ' + '|*~|'
--end   
--else
--if not exists(select boid from dis_req_dtls where slip_yn = 'D' and req_slip_no = @slipno)
--begin
--	set @pa_errmsg = 'Preverification request is not yet authorised by HO! Entry not allowed! ' + '|*~|'
--end   
--else 
--if  exists(select boid from dis_req_dtls where slip_yn = 'D' and req_slip_no = @slipno)
--begin
--	 select @pa_errmsg = right(boid,8) from dis_req_dtls where slip_yn = 'D' and req_slip_no = @slipno
--set @pa_errmsg = @pa_errmsg + '|*~|0'
--end
--commented in case of angel where preverification maker n checker not require by Latesh P W on May 24 2016
   

	if @validateonly ='N'
	begin 
		
--if exists (select demrm_slip_serial_no from demrm_mak where demrm_slip_serial_no=@slipno and demrm_deleted_ind in (0,1) and isnull(demrm_res_cd_intobj,'') = '')
--	begin
		insert into used_slip 
		(
			USES_ID,
			USES_DPM_ID,
			USES_DPAM_ACCT_NO,
			USES_SLIP_NO,
			USES_TRANTM_ID,
			USES_SERIES_TYPE,
			USES_USED_DESTR,
			USES_CREATED_BY,
			USES_CREATED_DT,
			USES_LST_UPD_BY,
			USES_LST_UPD_DT,
			USES_DELETED_IND 
		)
		select	MAX(USES_ID) + 1
		,		@l_dpm_id
		,		@accountno       
		,		@slipno	
		,		@trans_code
		,		''
		,		'U'
		,		@pa_login_name
		,		getdate()
		,		@pa_login_name
		,		getdate()
		,		1
		from used_slip
	--end
  end
 

	if @validateonly ='Y'
	begin		
		select @accountno = USES_DPAM_ACCT_NO from used_slip where uses_slip_no = @slipno and uses_trantm_id = @trans_code
		if exists(select uses_slip_no from used_slip where uses_dpam_acct_no = @accountno and uses_slip_no = @slipno and uses_trantm_id = @trans_code)
		begin
			set @pa_errmsg = 'Slip no. already exists'
		end
	end


END

GO
