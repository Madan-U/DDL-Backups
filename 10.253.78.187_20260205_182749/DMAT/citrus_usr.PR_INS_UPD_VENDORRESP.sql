-- Object: PROCEDURE citrus_usr.PR_INS_UPD_VENDORRESP
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[PR_INS_UPD_VENDORRESP]
(
	@pa_id				numeric(18,0),
	@pa_dpid            varchar(20),
	@pa_boid			varchar(16),
	@pa_reqslip_no		varchar(30),
	@pa_pod_no			varchar(20),
	@pa_courier_name	varchar(150),
	@pa_disp_date		varchar(20),
	@pa_old_bookno		varchar(20),
	@pa_weight			numeric(18,2),
	@pa_login_name		varchar(50),
	@pa_action			varchar(20),
	@pa_out				varchar(8000) output
)
AS
BEGIN

	--DECLARE @l_id INT	  
	declare @boname varchar(500), @bo1 varchar(100),@bo2 varchar(100),@bo3 varchar(100)    

	IF @pa_action = 'INS'
	BEGIN

		 SELECT @boname = DPAM_SBA_NAME + '|*~|'+ DPHD_SH_FNAME + ' ' + DPHD_SH_MNAME + ' ' + DPHD_SH_LNAME + '|*~|'+ DPHD_TH_FNAME + ' ' + DPHD_TH_MNAME + ' ' + DPHD_TH_LNAME  
		 FROM DP_ACCT_MSTR, DP_HOLDER_DTLS 
		 WHERE DPAM_SBA_NO = DPHD_DPAM_SBA_NO
         AND DPAM_SBA_NO = @pa_id
         And DPAM_DELETED_IND = 1 
         AND DPHD_DELETED_IND = 1
        
        set @bo1 = citrus_usr.FN_SPLITVAL(@boname,1)
        set @bo2 = citrus_usr.FN_SPLITVAL(@boname,2)
        set @bo3 = citrus_usr.FN_SPLITVAL(@boname,3)
        
		--select @l_id = ISNULL(MAX(VR_id),0) + 1 from  Vendor_Response

		INSERT INTO Vendor_Response
		(	VR_DPID	
		,	VR_boid
		,	VR_hldnm
		,	VR_sechldnm
		,	VR_thhldnm
		,	VR_reqslip_fr
		,	VR_reqslip_to
		,	VR_old_bookno
		,	VR_courier_name
		,	VR_pod_no
		,	VR_disp_date
		,	VR_reqslip_no
		,	VR_weight
		,	VR_created_dt
		,	VR_created_by
		,	VR_lst_upd_dt
		,	VR_lst_upd_by
		,	VR_deleted_ind		
		)
		VALUES
		(	@pa_dpid	
		,	@pa_boid	
		,	@bo1
		,	@bo2
		,	@bo3	
		,	@pa_reqslip_no	
		,	@pa_reqslip_no
		,	@pa_old_bookno
		,	@pa_courier_name
		,	@pa_pod_no				
		,	@pa_disp_date	
		,	@pa_reqslip_no
		,	@pa_weight
		,	GETDATE()	
		,	@pa_login_name	
		,	GETDATE()	
		,	@pa_login_name
		,	1
		)

	END

	IF @pa_action = 'EDT'
	BEGIN
		UPDATE Vendor_Response
		SET VR_pod_no			=	@pa_pod_no		
		,	VR_courier_name		=	@pa_courier_name
		,	VR_disp_date		=	@pa_disp_date	
		,	VR_old_bookno		=	@pa_old_bookno	
		,	VR_weight			=	@pa_weight
		,	VR_lst_upd_dt		=	getdate()		
		,	VR_lst_upd_by		=	@pa_login_name
		WHERE VR_id = @pa_id
		AND VR_deleted_ind = 1
	END
	
	IF @PA_ACTION = 'DEL'
	BEGIN

		UPDATE Vendor_Response
		SET VR_deleted_ind = 0
		,	VR_lst_upd_by = @PA_LOGIN_NAME
		,	VR_lst_upd_dt = GETDATE()
		WHERE VR_id = @pa_id
		AND VR_deleted_ind = 1

	--
	END

	IF @PA_ACTION = 'SEL'
	BEGIN
		SELECT * FROM  VENDOR_RESPONSE
		WHERE right(VR_boid,8) = @pa_boid 
		AND VR_deleted_ind = 1
	END

END

GO
