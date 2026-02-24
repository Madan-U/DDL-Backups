-- Object: PROCEDURE dbo.Api_Cli_AD_Process
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE  PROC [dbo].[Api_Cli_AD_Process] (@cl_code varchar(10) ,@flag varchar(1))
AS 
    DECLARE @MSG VARCHAR(100) 
	Declare @CNT Int

	select @cnt = count(1) FROM   client_brok_details C 
    WHERE  C.cl_code = @cl_code


	IF (@cnt =0)
	  Begin 
	   Print 'Please Enter Valid Code'
      END 
  


    INSERT INTO client_brok_details_log 
    SELECT C.cl_code, 
           C.exchange, 
           C.segment, 
           brok_scheme, 
           trd_brok, 
           del_brok, 
           ser_tax, 
           ser_tax_method, 
           credit_limit, 
           inactive_from, 
           print_options, 
           no_of_copies, 
           participant_code, 
           custodian_code, 
           inst_contract, 
           round_style, 
           stp_provider, 
           stp_rp_style, 
           market_type, 
           multiplier, 
           charged, 
           maintenance, 
           reqd_by_exch, 
           reqd_by_broker, 
           client_rating, 
           debit_balance, 
           inter_sett, 
           trd_stt, 
           trd_tran_chrgs, 
           trd_sebi_fees, 
           trd_stamp_duty, 
           trd_other_chrgs, 
           trd_eff_dt, 
           del_stt, 
           del_tran_chrgs, 
           del_sebi_fees, 
           del_stamp_duty, 
           del_other_chrgs, 
           del_eff_dt, 
           rounding_method, 
           round_to_digit, 
           round_to_paise, 
           fut_brok, 
           fut_opt_brok, 
           fut_fut_fin_brok, 
           fut_opt_exc, 
           fut_brok_applicable, 
           fut_stt, 
           fut_tran_chrgs, 
           fut_sebi_fees, 
           fut_stamp_duty, 
           fut_other_chrgs, 
           C.status, 
           modifiedon, 
           modifiedby, 
           imp_status, 
           pay_b3b_payment, 
           pay_bank_name, 
           pay_branch_name, 
           pay_ac_no, 
           pay_payment_mode, 
           brok_eff_date, 
           inst_trd_brok, 
           inst_del_brok, 
           EDIT_BY='Diet-Stp', 
           EDIT_ON=Getdate(), 
           systemdate, 
           active_date, 
           checkactiveclient, 
           deactive_remarks, 
           deactive_value 
    FROM   client_brok_details C 
    WHERE  C.cl_code = @cl_code 
    --  UPDATE C FROM  EMAIL_API E, CLIENT_DETAILS CD    
    --  SET C.EMAIL = E.EMAIL, IMP_STATUS = 0, MODIFIEDON = GETDATE(), MODIFIEDBY = 'EMAIL-API'     
    --  WHERE C.CL_CODE = E.PARTY_CODE   
    --        AND E.STATUS=0   
	INSERT INTO ANGELFO.BSEMFSS.DBO.MFSS_CLIENT_LOG (

			PARTY_CODE,PARTY_NAME,CL_TYPE,CL_BALANCE,CL_STATUS,BRANCH_CD,SUB_BROKER,TRADER,AREA,REGION,SBU,FAMILY,GENDER,OCCUPATION_CODE,TAX_STATUS,
	PAN_NO,KYC_FLAG,ADDR1,ADDR2,ADDR3,CITY,STATE,ZIP,NATION,OFFICE_PHONE,RES_PHONE,MOBILE_NO,EMAIL_ID,BANK_NAME,BANK_BRANCH,BANK_CITY,ACC_NO,PAYMODE,
	MICR_NO,DOB,GAURDIAN_NAME,GAURDIAN_PAN_NO,NOMINEE_NAME,NOMINEE_RELATION,BANK_AC_TYPE,STAT_COMM_MODE,DP_TYPE,DPID,CLTDPID,MODE_HOLDING,HOLDER2_CODE,
	HOLDER2_NAME,HOLDER2_PAN_NO,HOLDER2_KYC_FLAG,HOLDER3_CODE,HOLDER3_NAME,HOLDER3_PAN_NO,HOLDER3_KYC_FLAG,BUY_BROK_TABLE_NO,SELL_BROK_TABLE_NO,BROK_EFF_DATE,
	NEFTCODE,CHEQUENAME,RESIFAX,OFFICEFAX,MAPINID,REMARK,UCC_STATUS,ADDEDBY,ADDEDON,EDITEDBY,EDITEDON,ACTIVE_FROM,INACTIVE_FROM,POAFLAG,DEACTIVE_REMARKS,DEACTIVE_VALUE
	)SELECT  PARTY_CODE,PARTY_NAME,CL_TYPE,CL_BALANCE,CL_STATUS,BRANCH_CD,SUB_BROKER,TRADER,AREA,REGION,SBU,FAMILY,GENDER,OCCUPATION_CODE,TAX_STATUS,
	PAN_NO,KYC_FLAG,ADDR1,ADDR2,ADDR3,CITY,STATE,ZIP,NATION,OFFICE_PHONE,RES_PHONE,MOBILE_NO,EMAIL_ID,BANK_NAME,BANK_BRANCH,BANK_CITY,ACC_NO,PAYMODE,
	MICR_NO,DOB,GAURDIAN_NAME,GAURDIAN_PAN_NO,NOMINEE_NAME,NOMINEE_RELATION,BANK_AC_TYPE,STAT_COMM_MODE,DP_TYPE,DPID,CLTDPID,MODE_HOLDING,HOLDER2_CODE,
	HOLDER2_NAME,HOLDER2_PAN_NO,HOLDER2_KYC_FLAG,HOLDER3_CODE,HOLDER3_NAME,HOLDER3_PAN_NO,HOLDER3_KYC_FLAG,BUY_BROK_TABLE_NO,SELL_BROK_TABLE_NO,BROK_EFF_DATE,
	NEFTCODE,CHEQUENAME,RESIFAX,OFFICEFAX,MAPINID,REMARK,UCC_STATUS,ADDEDBY,ADDEDON,EDIT_BY='Diet-Stp',EDIT_ON=Getdate(),ACTIVE_FROM,INACTIVE_FROM,POAFLAG,DEACTIVE_REMARKS,DEACTIVE_VALUE
	FROM  ANGELFO.BSEMFSS.DBO.MFSS_CLIENT M WITH (NOLOCK)
	 WHERE  M.PARTY_CODE = @cl_code 














 IF (@flag ='D')
  BEGIN 
    UPDATE CB 
    SET    INACTIVE_FROM =GETDATE(),
		   IMP_STATUS = 0, 
           MODIFIEDON = Getdate(), 
           MODIFIEDBY = 'Diet-Stp',
		   Deactive_Remarks ='STP case – document Required',
		   Deactive_Value ='I'
    FROM   client_brok_details CB           
    WHERE  CB.cl_code =  @cl_code

	  UPDATE CBM 
    SET    INACTIVE_FROM =GETDATE(),
		   REMARK ='STP case – document Required',
		   Deactive_Remarks ='STP case – document Required',
		   Deactive_Value ='I'
    FROM   ANGELFO.BSEMFSS.DBO.MFSS_CLIENT CBM           
    WHERE  CBM.Party_code =  @cl_code

 Set @MSG = 'Client Deactiveted SUCCESSFULLY' 


  END

 ELSE IF (@FLAG ='A')
   BEGIN 

       UPDATE CB 
		SET  INACTIVE_FROM = '2049-12-31 23:59:00.000',
		   IMP_STATUS = 0, 
           MODIFIEDON = Getdate(), 
           MODIFIEDBY = 'Diet-Stp',
		   Deactive_Remarks ='',
		   Deactive_Value =''
		 FROM   client_brok_details CB           
		 WHERE  CB.cl_code =  @cl_code


		   UPDATE CBM 
    SET    INACTIVE_FROM = '2049-12-31 23:59:00.000',
		   REMARK ='',
		   Deactive_Remarks ='',
		   Deactive_Value =''
    FROM   ANGELFO.BSEMFSS.DBO.MFSS_CLIENT CBM           
    WHERE  CBM.Party_code =  @cl_code

   Set @MSG = 'Client Activated SUCCESSFULLY' 

   END
  ELSE
    Begin
	 Print 'Enter Valid Flag'  
	 
	 End

GO
