-- Object: PROCEDURE dbo.Api_ecn_update
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROC Api_ecn_update 
AS 
    DECLARE @MSG VARCHAR(100) 

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
           EDIT_BY='EMAIL-API', 
           EDIT_ON=Getdate(), 
           systemdate, 
           active_date, 
           checkactiveclient, 
           deactive_remarks, 
           deactive_value 
    FROM   client_brok_details C, 
           email_api E 
    WHERE  C.cl_code = E.cl_code 
           AND C.exchange = E.exchange 
           AND C.segment = E.segment 
           AND E.status = 0 

    --  UPDATE C FROM  EMAIL_API E, CLIENT_DETAILS CD    
    --  SET C.EMAIL = E.EMAIL, IMP_STATUS = 0, MODIFIEDON = GETDATE(), MODIFIEDBY = 'EMAIL-API'     
    --  WHERE C.CL_CODE = E.PARTY_CODE   
    --        AND E.STATUS=0   
    UPDATE CB 
    SET    CB.print_options = 2, 
           IMP_STATUS = 0, 
           MODIFIEDON = Getdate(), 
           MODIFIEDBY = 'EMAIL-API' 
    FROM   client_brok_details CB, 
           email_api E 
    WHERE  CB.cl_code = E.cl_code 
           AND CB.exchange = E.exchange 
           AND CB.segment = E.segment 
           AND E.status = 0 

    UPDATE E 
    SET    E.status = 1 
    FROM   email_api E, 
           client_brok_details CB 
    WHERE  CB.cl_code = E.cl_code 
           AND CB.modifiedby = 'EMAIL-API' 
           AND CB.print_options = 2 
           AND E.status = 0 

    SET @MSG = 'RECORD UPDATED SUCCESSFULLY'

GO
