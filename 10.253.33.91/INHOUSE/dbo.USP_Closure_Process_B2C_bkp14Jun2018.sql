-- Object: PROCEDURE dbo.USP_Closure_Process_B2C_bkp14Jun2018
-- Server: 10.253.33.91 | DB: INHOUSE
--------------------------------------------------


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_Closure_Process_B2C_bkp14Jun2018]
	-- Add the parameters for the stored procedure here
	(@party_Code varchar(20),
	@segment varchar(20),
	@empNo varchar(20))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
DECLARE @Deactive_Remarks VARCHAR(500);
DECLARE @RowCount1 BIGINT;
DECLARE @ErrorFlag NVARCHAR(MAX);
DECLARE @tableHTML VARCHAR(MAX);
DECLARE @Subject VARCHAR(200);   



BEGIN TRY
    PRINT 'TRY';

IF(@Segment LIKE '%BSE%')
    BEGIN

        SET @Deactive_Remarks =(SELECT TOP 1 ISNULL(Deactive_value, '1')
						  FROM msajag.dbo.client_brok_details
						  WHERE cl_code = @party_Code
							   AND Exchange IN('BSE')
						  AND Segment = 'CAPITAL');

        PRINT 'Deactivate Remark: '+@Deactive_Remarks;
        IF(ISNULL(@Deactive_Remarks, '') <> 'C' OR ISNULL(@Deactive_Remarks, '') = '1')
            BEGIN

                PRINT 'Deactivate Update in BO: '+@party_Code+' '+@segment;

                INSERT INTO msajag.dbo.client_brok_details_log(Cl_Code, Exchange, Segment, Brok_Scheme, Trd_Brok, Del_Brok, Ser_Tax, Ser_Tax_Method, Credit_Limit, InActive_From, Print_Options, No_Of_Copies, Participant_Code, Custodian_Code, Inst_Contract, Round_Style, STP_Provider, STP_Rp_Style, Market_Type, Multiplier, Charged, Maintenance, Reqd_By_Exch, Reqd_By_Broker, Client_Rating, Debit_Balance, Inter_Sett, TRD_STT, Trd_Tran_Chrgs, Trd_Sebi_Fees, Trd_Stamp_Duty, Trd_Other_Chrgs, Trd_Eff_Dt, Del_Stt, Del_Tran_Chrgs, Del_SEBI_Fees, Del_Stamp_Duty, Del_Other_Chrgs, Del_Eff_Dt, Rounding_Method, Round_To_Digit, Round_To_Paise, Fut_Brok, Fut_Opt_Brok, Fut_Fut_Fin_Brok, Fut_Opt_Exc, Fut_Brok_Applicable, Fut_Stt, Fut_Tran_Chrgs, Fut_Sebi_Fees, Fut_Stamp_Duty, Fut_Other_Chrgs, Status, Modifiedon, Modifiedby, Imp_Status, Pay_B3B_Payment, Pay_Bank_name, Pay_Branch_name, Pay_AC_No, Pay_payment_Mode, Brok_Eff_Date, Inst_Trd_Brok, Inst_Del_Brok, Edit_By, Edit_on, SYSTEMDATE, Active_Date, CheckActiveClient, Deactive_Remarks, Deactive_value)
                       SELECT Cl_Code, Exchange, Segment, Brok_Scheme, Trd_Brok, Del_Brok, Ser_Tax, Ser_Tax_Method, Credit_Limit, InActive_From, Print_Options, No_Of_Copies, Participant_Code, Custodian_Code, Inst_Contract, Round_Style, STP_Provider, STP_Rp_Style, Market_Type, Multiplier, Charged, Maintenance, Reqd_By_Exch, Reqd_By_Broker, Client_Rating, Debit_Balance, Inter_Sett, TRD_STT, Trd_Tran_Chrgs, Trd_Sebi_Fees, Trd_Stamp_Duty, Trd_Other_Chrgs, Trd_Eff_Dt, Del_Stt, Del_Tran_Chrgs, Del_SEBI_Fees, Del_Stamp_Duty, Del_Other_Chrgs, Del_Eff_Dt, Rounding_Method, Round_To_Digit, Round_To_Paise, Fut_Brok, Fut_Opt_Brok, Fut_Fut_Fin_Brok, Fut_Opt_Exc, Fut_Brok_Applicable, Fut_Stt, Fut_Tran_Chrgs, Fut_Sebi_Fees, Fut_Stamp_Duty, Fut_Other_Chrgs, Status, Modifiedon, Modifiedby, Imp_Status, Pay_B3B_Payment, Pay_Bank_name, Pay_Branch_name, Pay_AC_No, Pay_payment_Mode, Brok_Eff_Date, Inst_Trd_Brok, Inst_Del_Brok, 'E36024', GETDATE(), SYSTEMDATE, Active_Date, CheckActiveClient, Deactive_Remarks, Deactive_value
                       FROM msajag.dbo.client_brok_details WITH (nolock)
                       WHERE cl_code = @party_Code
                             AND Exchange IN('BSE')
                       AND Segment = 'CAPITAL';


                UPDATE msajag.dbo.client_brok_details
                 SET
                     Deactive_Remarks = 'AS PER CLIENT CLOSURE REQUEST RECEIVED',
                     InActive_From = GETDATE(),
                     Deactive_value = 'C',
                     Imp_Status = 0,
                     Modifiedon = GETDATE(),
                     Modifiedby = @empNo
                WHERE cl_code = @party_Code
                      AND Exchange IN('BSE')
                      AND Segment = 'CAPITAL';

                INSERT INTO mimansa.CRM.dbo.tbl_EKYC_AutoDeactivate_Log_AutoClosure(party_Code, segment, ActDeact, updatedOn, Processed, MailSent, Reprocess)
                       SELECT CAST(@party_Code AS VARCHAR(30)) AS party_code, CAST('BSE' AS VARCHAR(30)) AS segment, 'DEACTIVATE', GETDATE() AS updatedOn, 'Y' AS Processed, 'N', 'N';

				   select 'Successful Deactivate Update in BO: '+@party_Code+' '+@segment;
            END;
            ELSE
            BEGIN

                PRINT 'Already Deactivated: '+@party_Code+' '+@segment;

                INSERT INTO mimansa.CRM.dbo.tbl_EKYC_AutoDeactivate_Log_AutoClosure(party_Code, segment, ActDeact, updatedOn, Processed, MailSent, Reprocess)
                       SELECT CAST(@party_Code AS VARCHAR(30)) AS party_code, CAST('BSE' AS VARCHAR(30)) AS segment, 'ALREADY DEACTIVATE', GETDATE() AS updatedOn, 'N' AS Processed, 'N', 'N';
				   select 'Successful Already Deactivated: '+@party_Code+' '+@segment;
            END;
    END;

    	

IF(@Segment LIKE '%NSE%')
    BEGIN

        SET @Deactive_Remarks =(SELECT TOP 1 ISNULL(Deactive_value, '1')
						  FROM msajag.dbo.client_brok_details
						  WHERE cl_code = @party_Code
							   AND Exchange IN('NSE')
						  AND Segment = 'CAPITAL');

        PRINT 'Deactivate Remark: '+@Deactive_Remarks;
        IF(ISNULL(@Deactive_Remarks, '') <> 'C' OR ISNULL(@Deactive_Remarks, '') = '1') 
            BEGIN

                PRINT 'Deactivate Update in BO: '+@party_Code+' '+@segment;

                INSERT INTO msajag.dbo.client_brok_details_log(Cl_Code, Exchange, Segment, Brok_Scheme, Trd_Brok, Del_Brok, Ser_Tax, Ser_Tax_Method, Credit_Limit, InActive_From, Print_Options, No_Of_Copies, Participant_Code, Custodian_Code, Inst_Contract, Round_Style, STP_Provider, STP_Rp_Style, Market_Type, Multiplier, Charged, Maintenance, Reqd_By_Exch, Reqd_By_Broker, Client_Rating, Debit_Balance, Inter_Sett, TRD_STT, Trd_Tran_Chrgs, Trd_Sebi_Fees, Trd_Stamp_Duty, Trd_Other_Chrgs, Trd_Eff_Dt, Del_Stt, Del_Tran_Chrgs, Del_SEBI_Fees, Del_Stamp_Duty, Del_Other_Chrgs, Del_Eff_Dt, Rounding_Method, Round_To_Digit, Round_To_Paise, Fut_Brok, Fut_Opt_Brok, Fut_Fut_Fin_Brok, Fut_Opt_Exc, Fut_Brok_Applicable, Fut_Stt, Fut_Tran_Chrgs, Fut_Sebi_Fees, Fut_Stamp_Duty, Fut_Other_Chrgs, Status, Modifiedon, Modifiedby, Imp_Status, Pay_B3B_Payment, Pay_Bank_name, Pay_Branch_name, Pay_AC_No, Pay_payment_Mode, Brok_Eff_Date, Inst_Trd_Brok, Inst_Del_Brok, Edit_By, Edit_on, SYSTEMDATE, Active_Date, CheckActiveClient, Deactive_Remarks, Deactive_value)
                       SELECT Cl_Code, Exchange, Segment, Brok_Scheme, Trd_Brok, Del_Brok, Ser_Tax, Ser_Tax_Method, Credit_Limit, InActive_From, Print_Options, No_Of_Copies, Participant_Code, Custodian_Code, Inst_Contract, Round_Style, STP_Provider, STP_Rp_Style, Market_Type, Multiplier, Charged, Maintenance, Reqd_By_Exch, Reqd_By_Broker, Client_Rating, Debit_Balance, Inter_Sett, TRD_STT, Trd_Tran_Chrgs, Trd_Sebi_Fees, Trd_Stamp_Duty, Trd_Other_Chrgs, Trd_Eff_Dt, Del_Stt, Del_Tran_Chrgs, Del_SEBI_Fees, Del_Stamp_Duty, Del_Other_Chrgs, Del_Eff_Dt, Rounding_Method, Round_To_Digit, Round_To_Paise, Fut_Brok, Fut_Opt_Brok, Fut_Fut_Fin_Brok, Fut_Opt_Exc, Fut_Brok_Applicable, Fut_Stt, Fut_Tran_Chrgs, Fut_Sebi_Fees, Fut_Stamp_Duty, Fut_Other_Chrgs, Status, Modifiedon, Modifiedby, Imp_Status, Pay_B3B_Payment, Pay_Bank_name, Pay_Branch_name, Pay_AC_No, Pay_payment_Mode, Brok_Eff_Date, Inst_Trd_Brok, Inst_Del_Brok, 'E36024', GETDATE(), SYSTEMDATE, Active_Date, CheckActiveClient, Deactive_Remarks, Deactive_value
                       FROM msajag.dbo.client_brok_details WITH (nolock)
                       WHERE cl_code = @party_Code
                             AND Exchange IN('NSE')
                       AND Segment = 'CAPITAL';


                UPDATE msajag.dbo.client_brok_details
                 SET
                     Deactive_Remarks = 'AS PER CLIENT CLOSURE REQUEST RECEIVED',
                     InActive_From = GETDATE(),
                     Deactive_value = 'C',
                     Imp_Status = 0,
                     Modifiedon = GETDATE(),
                     Modifiedby = @empNo
                WHERE cl_code = @party_Code
                      AND Exchange IN('NSE')
                      AND Segment = 'CAPITAL';

                INSERT INTO mimansa.CRM.dbo.tbl_EKYC_AutoDeactivate_Log_AutoClosure(party_Code, segment, ActDeact, updatedOn, Processed, MailSent, Reprocess)
                       SELECT CAST(@party_Code AS VARCHAR(30)) AS party_code, CAST('NSE' AS VARCHAR(30)) AS segment, 'DEACTIVATE', GETDATE() AS updatedOn, 'Y' AS Processed, 'N', 'N';

                SELECT 'Successful Deactivate Update in BO: '+@party_Code+' '+@segment;
            END;
            ELSE
            BEGIN

                PRINT 'Already Deactivated: '+@party_Code+' '+@segment;

                INSERT INTO mimansa.CRM.dbo.tbl_EKYC_AutoDeactivate_Log_AutoClosure(party_Code, segment, ActDeact, updatedOn, Processed, MailSent, Reprocess)
                       SELECT CAST(@party_Code AS VARCHAR(30)) AS party_code, CAST('NSE' AS VARCHAR(30)) AS segment, 'ALREADY DEACTIVATE', GETDATE() AS updatedOn, 'N' AS Processed, 'N', 'N';

                SELECT 'Successful Already Deactivated: '+@party_Code+' '+@segment;
            END;
    END;

	

IF(@Segment LIKE '%NSEFO%')
    BEGIN

        SET @Deactive_Remarks =(SELECT TOP 1 ISNULL(Deactive_value, '1')
						  FROM msajag.dbo.client_brok_details
						  WHERE cl_code = @party_Code
							   AND Exchange IN('NSE')
						  AND Segment = 'FUTURES');

        PRINT 'Deactivate Remark: '+@Deactive_Remarks;
        IF(ISNULL(@Deactive_Remarks, '') <> 'C'OR ISNULL(@Deactive_Remarks, '') = '1') 
            BEGIN

                PRINT 'Deactivate Update in BO: '+@party_Code+' '+@segment;

                INSERT INTO msajag.dbo.client_brok_details_log(Cl_Code, Exchange, Segment, Brok_Scheme, Trd_Brok, Del_Brok, Ser_Tax, Ser_Tax_Method, Credit_Limit, InActive_From, Print_Options, No_Of_Copies, Participant_Code, Custodian_Code, Inst_Contract, Round_Style, STP_Provider, STP_Rp_Style, Market_Type, Multiplier, Charged, Maintenance, Reqd_By_Exch, Reqd_By_Broker, Client_Rating, Debit_Balance, Inter_Sett, TRD_STT, Trd_Tran_Chrgs, Trd_Sebi_Fees, Trd_Stamp_Duty, Trd_Other_Chrgs, Trd_Eff_Dt, Del_Stt, Del_Tran_Chrgs, Del_SEBI_Fees, Del_Stamp_Duty, Del_Other_Chrgs, Del_Eff_Dt, Rounding_Method, Round_To_Digit, Round_To_Paise, Fut_Brok, Fut_Opt_Brok, Fut_Fut_Fin_Brok, Fut_Opt_Exc, Fut_Brok_Applicable, Fut_Stt, Fut_Tran_Chrgs, Fut_Sebi_Fees, Fut_Stamp_Duty, Fut_Other_Chrgs, Status, Modifiedon, Modifiedby, Imp_Status, Pay_B3B_Payment, Pay_Bank_name, Pay_Branch_name, Pay_AC_No, Pay_payment_Mode, Brok_Eff_Date, Inst_Trd_Brok, Inst_Del_Brok, Edit_By, Edit_on, SYSTEMDATE, Active_Date, CheckActiveClient, Deactive_Remarks, Deactive_value)
                       SELECT Cl_Code, Exchange, Segment, Brok_Scheme, Trd_Brok, Del_Brok, Ser_Tax, Ser_Tax_Method, Credit_Limit, InActive_From, Print_Options, No_Of_Copies, Participant_Code, Custodian_Code, Inst_Contract, Round_Style, STP_Provider, STP_Rp_Style, Market_Type, Multiplier, Charged, Maintenance, Reqd_By_Exch, Reqd_By_Broker, Client_Rating, Debit_Balance, Inter_Sett, TRD_STT, Trd_Tran_Chrgs, Trd_Sebi_Fees, Trd_Stamp_Duty, Trd_Other_Chrgs, Trd_Eff_Dt, Del_Stt, Del_Tran_Chrgs, Del_SEBI_Fees, Del_Stamp_Duty, Del_Other_Chrgs, Del_Eff_Dt, Rounding_Method, Round_To_Digit, Round_To_Paise, Fut_Brok, Fut_Opt_Brok, Fut_Fut_Fin_Brok, Fut_Opt_Exc, Fut_Brok_Applicable, Fut_Stt, Fut_Tran_Chrgs, Fut_Sebi_Fees, Fut_Stamp_Duty, Fut_Other_Chrgs, Status, Modifiedon, Modifiedby, Imp_Status, Pay_B3B_Payment, Pay_Bank_name, Pay_Branch_name, Pay_AC_No, Pay_payment_Mode, Brok_Eff_Date, Inst_Trd_Brok, Inst_Del_Brok, 'E36024', GETDATE(), SYSTEMDATE, Active_Date, CheckActiveClient, Deactive_Remarks, Deactive_value
                       FROM msajag.dbo.client_brok_details WITH (nolock)
                       WHERE cl_code = @party_Code
                             AND Exchange IN('NSE')
                       AND Segment = 'FUTURES';


                UPDATE msajag.dbo.client_brok_details
                 SET
                     Deactive_Remarks = 'AS PER CLIENT CLOSURE REQUEST RECEIVED',
                     InActive_From = GETDATE(),
                     Deactive_value = 'C',
                     Imp_Status = 0,
                     Modifiedon = GETDATE(),
                     Modifiedby = @empNo
                WHERE cl_code = @party_Code
                      AND Exchange IN('NSE')
                      AND Segment = 'FUTURES';

                INSERT INTO mimansa.CRM.dbo.tbl_EKYC_AutoDeactivate_Log_AutoClosure(party_Code, segment, ActDeact, updatedOn, Processed, MailSent, Reprocess)
                       SELECT CAST(@party_Code AS VARCHAR(30)) AS party_code, CAST('NSEFO' AS VARCHAR(30)) AS segment, 'DEACTIVATE', GETDATE() AS updatedOn, 'Y' AS Processed, 'N', 'N';

                SELECT 'Successful Deactivate Update in BO: '+@party_Code+' '+@segment;
            END;
            ELSE
            BEGIN

                PRINT 'Already Deactivated: '+@party_Code+' '+@segment;

                INSERT INTO mimansa.CRM.dbo.tbl_EKYC_AutoDeactivate_Log_AutoClosure(party_Code, segment, ActDeact, updatedOn, Processed, MailSent, Reprocess)
                       SELECT CAST(@party_Code AS VARCHAR(30)) AS party_code, CAST('NSEFO' AS VARCHAR(30)) AS segment, 'ALREADY DEACTIVATE', GETDATE() AS updatedOn, 'N' AS Processed, 'N', 'N';

                SELECT 'Successful Already Deactivated: '+@party_Code+' '+@segment;
            END;
    END;

    	

IF(@Segment LIKE '%BSEFO%')
    BEGIN

        SET @Deactive_Remarks =(SELECT TOP 1 ISNULL(Deactive_value, '1')
						  FROM msajag.dbo.client_brok_details
						  WHERE cl_code = @party_Code
							   AND Exchange IN('BSE')
						  AND Segment = 'FUTURES');

        PRINT 'Deactivate Remark: '+@Deactive_Remarks;
        IF(ISNULL(@Deactive_Remarks, '') <> 'C' OR ISNULL(@Deactive_Remarks, '') = '1') 
            BEGIN

                PRINT 'Deactivate Update in BO: '+@party_Code+' '+@segment;

                INSERT INTO msajag.dbo.client_brok_details_log(Cl_Code, Exchange, Segment, Brok_Scheme, Trd_Brok, Del_Brok, Ser_Tax, Ser_Tax_Method, Credit_Limit, InActive_From, Print_Options, No_Of_Copies, Participant_Code, Custodian_Code, Inst_Contract, Round_Style, STP_Provider, STP_Rp_Style, Market_Type, Multiplier, Charged, Maintenance, Reqd_By_Exch, Reqd_By_Broker, Client_Rating, Debit_Balance, Inter_Sett, TRD_STT, Trd_Tran_Chrgs, Trd_Sebi_Fees, Trd_Stamp_Duty, Trd_Other_Chrgs, Trd_Eff_Dt, Del_Stt, Del_Tran_Chrgs, Del_SEBI_Fees, Del_Stamp_Duty, Del_Other_Chrgs, Del_Eff_Dt, Rounding_Method, Round_To_Digit, Round_To_Paise, Fut_Brok, Fut_Opt_Brok, Fut_Fut_Fin_Brok, Fut_Opt_Exc, Fut_Brok_Applicable, Fut_Stt, Fut_Tran_Chrgs, Fut_Sebi_Fees, Fut_Stamp_Duty, Fut_Other_Chrgs, Status, Modifiedon, Modifiedby, Imp_Status, Pay_B3B_Payment, Pay_Bank_name, Pay_Branch_name, Pay_AC_No, Pay_payment_Mode, Brok_Eff_Date, Inst_Trd_Brok, Inst_Del_Brok, Edit_By, Edit_on, SYSTEMDATE, Active_Date, CheckActiveClient, Deactive_Remarks, Deactive_value)
                       SELECT Cl_Code, Exchange, Segment, Brok_Scheme, Trd_Brok, Del_Brok, Ser_Tax, Ser_Tax_Method, Credit_Limit, InActive_From, Print_Options, No_Of_Copies, Participant_Code, Custodian_Code, Inst_Contract, Round_Style, STP_Provider, STP_Rp_Style, Market_Type, Multiplier, Charged, Maintenance, Reqd_By_Exch, Reqd_By_Broker, Client_Rating, Debit_Balance, Inter_Sett, TRD_STT, Trd_Tran_Chrgs, Trd_Sebi_Fees, Trd_Stamp_Duty, Trd_Other_Chrgs, Trd_Eff_Dt, Del_Stt, Del_Tran_Chrgs, Del_SEBI_Fees, Del_Stamp_Duty, Del_Other_Chrgs, Del_Eff_Dt, Rounding_Method, Round_To_Digit, Round_To_Paise, Fut_Brok, Fut_Opt_Brok, Fut_Fut_Fin_Brok, Fut_Opt_Exc, Fut_Brok_Applicable, Fut_Stt, Fut_Tran_Chrgs, Fut_Sebi_Fees, Fut_Stamp_Duty, Fut_Other_Chrgs, Status, Modifiedon, Modifiedby, Imp_Status, Pay_B3B_Payment, Pay_Bank_name, Pay_Branch_name, Pay_AC_No, Pay_payment_Mode, Brok_Eff_Date, Inst_Trd_Brok, Inst_Del_Brok, 'E36024', GETDATE(), SYSTEMDATE, Active_Date, CheckActiveClient, Deactive_Remarks, Deactive_value
                       FROM msajag.dbo.client_brok_details WITH (nolock)
                       WHERE cl_code = @party_Code
                             AND Exchange IN('BSE')
                       AND Segment = 'FUTURES';


                UPDATE msajag.dbo.client_brok_details
                 SET
                     Deactive_Remarks = 'AS PER CLIENT CLOSURE REQUEST RECEIVED',
                     InActive_From = GETDATE(),
                     Deactive_value = 'C',
                     Imp_Status = 0,
                     Modifiedon = GETDATE(),
                     Modifiedby = @empNo
                WHERE cl_code = @party_Code
                      AND Exchange IN('BSE')
                      AND Segment = 'FUTURES';

                INSERT INTO mimansa.CRM.dbo.tbl_EKYC_AutoDeactivate_Log_AutoClosure(party_Code, segment, ActDeact, updatedOn, Processed, MailSent, Reprocess)
                       SELECT CAST(@party_Code AS VARCHAR(30)) AS party_code, CAST('BSEFO' AS VARCHAR(30)) AS segment, 'DEACTIVATE', GETDATE() AS updatedOn, 'Y' AS Processed, 'N', 'N';

                SELECT 'Successful Deactivate Update in BO: '+@party_Code+' '+@segment;
            END;
            ELSE
            BEGIN

                PRINT 'Already Deactivated: '+@party_Code+' '+@segment;

                INSERT INTO mimansa.CRM.dbo.tbl_EKYC_AutoDeactivate_Log_AutoClosure(party_Code, segment, ActDeact, updatedOn, Processed, MailSent, Reprocess)
                       SELECT CAST(@party_Code AS VARCHAR(30)) AS party_code, CAST('BSEFO' AS VARCHAR(30)) AS segment, 'ALREADY DEACTIVATE', GETDATE() AS updatedOn, 'N' AS Processed, 'N', 'N';

                SELECT 'Successful Already Deactivated: '+@party_Code+' '+@segment;
            END;
    END;

    	

IF(@Segment LIKE '%NCX%')
    BEGIN

        SET @Deactive_Remarks =(SELECT TOP 1 ISNULL(Deactive_value, '1')
						  FROM msajag.dbo.client_brok_details
						  WHERE cl_code = @party_Code
							   AND Exchange IN('NCX')
						  AND Segment = 'FUTURES');
        PRINT 'Deactivate Remark: '+@Deactive_Remarks;
        IF(ISNULL(@Deactive_Remarks, '') <> 'C' OR ISNULL(@Deactive_Remarks, '') = '1') 
            BEGIN

                PRINT 'Deactivate Update in BO: '+@party_Code+' '+@segment;

                INSERT INTO msajag.dbo.client_brok_details_log(Cl_Code, Exchange, Segment, Brok_Scheme, Trd_Brok, Del_Brok, Ser_Tax, Ser_Tax_Method, Credit_Limit, InActive_From, Print_Options, No_Of_Copies, Participant_Code, Custodian_Code, Inst_Contract, Round_Style, STP_Provider, STP_Rp_Style, Market_Type, Multiplier, Charged, Maintenance, Reqd_By_Exch, Reqd_By_Broker, Client_Rating, Debit_Balance, Inter_Sett, TRD_STT, Trd_Tran_Chrgs, Trd_Sebi_Fees, Trd_Stamp_Duty, Trd_Other_Chrgs, Trd_Eff_Dt, Del_Stt, Del_Tran_Chrgs, Del_SEBI_Fees, Del_Stamp_Duty, Del_Other_Chrgs, Del_Eff_Dt, Rounding_Method, Round_To_Digit, Round_To_Paise, Fut_Brok, Fut_Opt_Brok, Fut_Fut_Fin_Brok, Fut_Opt_Exc, Fut_Brok_Applicable, Fut_Stt, Fut_Tran_Chrgs, Fut_Sebi_Fees, Fut_Stamp_Duty, Fut_Other_Chrgs, Status, Modifiedon, Modifiedby, Imp_Status, Pay_B3B_Payment, Pay_Bank_name, Pay_Branch_name, Pay_AC_No, Pay_payment_Mode, Brok_Eff_Date, Inst_Trd_Brok, Inst_Del_Brok, Edit_By, Edit_on, SYSTEMDATE, Active_Date, CheckActiveClient, Deactive_Remarks, Deactive_value)
                       SELECT Cl_Code, Exchange, Segment, Brok_Scheme, Trd_Brok, Del_Brok, Ser_Tax, Ser_Tax_Method, Credit_Limit, InActive_From, Print_Options, No_Of_Copies, Participant_Code, Custodian_Code, Inst_Contract, Round_Style, STP_Provider, STP_Rp_Style, Market_Type, Multiplier, Charged, Maintenance, Reqd_By_Exch, Reqd_By_Broker, Client_Rating, Debit_Balance, Inter_Sett, TRD_STT, Trd_Tran_Chrgs, Trd_Sebi_Fees, Trd_Stamp_Duty, Trd_Other_Chrgs, Trd_Eff_Dt, Del_Stt, Del_Tran_Chrgs, Del_SEBI_Fees, Del_Stamp_Duty, Del_Other_Chrgs, Del_Eff_Dt, Rounding_Method, Round_To_Digit, Round_To_Paise, Fut_Brok, Fut_Opt_Brok, Fut_Fut_Fin_Brok, Fut_Opt_Exc, Fut_Brok_Applicable, Fut_Stt, Fut_Tran_Chrgs, Fut_Sebi_Fees, Fut_Stamp_Duty, Fut_Other_Chrgs, Status, Modifiedon, Modifiedby, Imp_Status, Pay_B3B_Payment, Pay_Bank_name, Pay_Branch_name, Pay_AC_No, Pay_payment_Mode, Brok_Eff_Date, Inst_Trd_Brok, Inst_Del_Brok, 'E36024', GETDATE(), SYSTEMDATE, Active_Date, CheckActiveClient, Deactive_Remarks, Deactive_value
                       FROM msajag.dbo.client_brok_details WITH (nolock)
                       WHERE cl_code = @party_Code
                             AND Exchange IN('NCX')
                       AND Segment = 'FUTURES';

		/*******Changes by Priyanka bhagat  on May 22 2017 added Modifiedon and Modifiedby ********/

                UPDATE msajag.dbo.client_brok_details
                 SET
                     Deactive_Remarks = 'AS PER CLIENT CLOSURE REQUEST RECEIVED',
                     InActive_From = GETDATE(),
                     Deactive_value = 'C',
                     Imp_Status = 0,
                     Modifiedon = GETDATE(),
                     Modifiedby = @empNo
                WHERE cl_code = @party_Code
                      AND Exchange IN('NCX')
                      AND Segment = 'FUTURES';

                INSERT INTO mimansa.CRM.dbo.tbl_EKYC_AutoDeactivate_Log_AutoClosure(party_Code, segment, ActDeact, updatedOn, Processed, MailSent, Reprocess)
                       SELECT CAST(@party_Code AS VARCHAR(30)) AS party_code, CAST('NCX' AS VARCHAR(30)) AS segment, 'DEACTIVATE', GETDATE() AS updatedOn, 'Y' AS Processed, 'N', 'N';

                SELECT 'Successful Deactivate Update in BO: '+@party_Code+' '+@segment;
            END;
            ELSE
            BEGIN

                PRINT 'Already Deactivated: '+@party_Code+' '+@segment;

                INSERT INTO mimansa.CRM.dbo.tbl_EKYC_AutoDeactivate_Log_AutoClosure(party_Code, segment, ActDeact, updatedOn, Processed, MailSent, Reprocess)
                       SELECT CAST(@party_Code AS VARCHAR(30)) AS party_code, CAST('NCX' AS VARCHAR(30)) AS segment, 'ALREADY DEACTIVATE', GETDATE() AS updatedOn, 'N' AS Processed, 'N', 'N';

                SELECT 'Successful Already Deactivated: '+@party_Code+' '+@segment;
            END;
    END;

    	

IF(@Segment LIKE '%MCX%')
    BEGIN

        SET @Deactive_Remarks =(SELECT TOP 1 ISNULL(Deactive_value, '1')
						  FROM msajag.dbo.client_brok_details
						  WHERE cl_code = @party_Code
							   AND Exchange IN('MCX')
						  AND Segment = 'FUTURES');
        PRINT 'Deactivate Remark: '+@Deactive_Remarks;
        IF(ISNULL(@Deactive_Remarks, '') <> 'C' OR ISNULL(@Deactive_Remarks, '') = '1')
            BEGIN

                PRINT 'Deactivate Update in BO: '+@party_Code+' '+@segment;

                INSERT INTO msajag.dbo.client_brok_details_log(Cl_Code, Exchange, Segment, Brok_Scheme, Trd_Brok, Del_Brok, Ser_Tax, Ser_Tax_Method, Credit_Limit, InActive_From, Print_Options, No_Of_Copies, Participant_Code, Custodian_Code, Inst_Contract, Round_Style, STP_Provider, STP_Rp_Style, Market_Type, Multiplier, Charged, Maintenance, Reqd_By_Exch, Reqd_By_Broker, Client_Rating, Debit_Balance, Inter_Sett, TRD_STT, Trd_Tran_Chrgs, Trd_Sebi_Fees, Trd_Stamp_Duty, Trd_Other_Chrgs, Trd_Eff_Dt, Del_Stt, Del_Tran_Chrgs, Del_SEBI_Fees, Del_Stamp_Duty, Del_Other_Chrgs, Del_Eff_Dt, Rounding_Method, Round_To_Digit, Round_To_Paise, Fut_Brok, Fut_Opt_Brok, Fut_Fut_Fin_Brok, Fut_Opt_Exc, Fut_Brok_Applicable, Fut_Stt, Fut_Tran_Chrgs, Fut_Sebi_Fees, Fut_Stamp_Duty, Fut_Other_Chrgs, Status, Modifiedon, Modifiedby, Imp_Status, Pay_B3B_Payment, Pay_Bank_name, Pay_Branch_name, Pay_AC_No, Pay_payment_Mode, Brok_Eff_Date, Inst_Trd_Brok, Inst_Del_Brok, Edit_By, Edit_on, SYSTEMDATE, Active_Date, CheckActiveClient, Deactive_Remarks, Deactive_value)
                       SELECT Cl_Code, Exchange, Segment, Brok_Scheme, Trd_Brok, Del_Brok, Ser_Tax, Ser_Tax_Method, Credit_Limit, InActive_From, Print_Options, No_Of_Copies, Participant_Code, Custodian_Code, Inst_Contract, Round_Style, STP_Provider, STP_Rp_Style, Market_Type, Multiplier, Charged, Maintenance, Reqd_By_Exch, Reqd_By_Broker, Client_Rating, Debit_Balance, Inter_Sett, TRD_STT, Trd_Tran_Chrgs, Trd_Sebi_Fees, Trd_Stamp_Duty, Trd_Other_Chrgs, Trd_Eff_Dt, Del_Stt, Del_Tran_Chrgs, Del_SEBI_Fees, Del_Stamp_Duty, Del_Other_Chrgs, Del_Eff_Dt, Rounding_Method, Round_To_Digit, Round_To_Paise, Fut_Brok, Fut_Opt_Brok, Fut_Fut_Fin_Brok, Fut_Opt_Exc, Fut_Brok_Applicable, Fut_Stt, Fut_Tran_Chrgs, Fut_Sebi_Fees, Fut_Stamp_Duty, Fut_Other_Chrgs, Status, Modifiedon, Modifiedby, Imp_Status, Pay_B3B_Payment, Pay_Bank_name, Pay_Branch_name, Pay_AC_No, Pay_payment_Mode, Brok_Eff_Date, Inst_Trd_Brok, Inst_Del_Brok, 'E36024', GETDATE(), SYSTEMDATE, Active_Date, CheckActiveClient, Deactive_Remarks, Deactive_value
                       FROM msajag.dbo.client_brok_details WITH (nolock)
                       WHERE cl_code = @party_Code
                             AND Exchange IN('MCX')
                       AND Segment = 'FUTURES';


                UPDATE msajag.dbo.client_brok_details
                 SET
                     Deactive_Remarks = 'AS PER CLIENT CLOSURE REQUEST RECEIVED',
                     InActive_From = GETDATE(),
                     Deactive_value = 'C',
                     Imp_Status = 0,
                     Modifiedon = GETDATE(),
                     Modifiedby = @empNo
                WHERE cl_code = @party_Code
                      AND Exchange IN('MCX')
                      AND Segment = 'FUTURES';

                INSERT INTO mimansa.CRM.dbo.tbl_EKYC_AutoDeactivate_Log_AutoClosure(party_Code, segment, ActDeact, updatedOn, Processed, MailSent, Reprocess)
                       SELECT CAST(@party_Code AS VARCHAR(30)) AS party_code, CAST('MCX' AS VARCHAR(30)) AS segment, 'DEACTIVATE', GETDATE() AS updatedOn, 'Y' AS Processed, 'N', 'N';

                SELECT 'Successful Deactivate Update in BO: '+@party_Code+' '+@segment;
            END;
            ELSE
            BEGIN

                PRINT 'Already Deactivated: '+@party_Code+' '+@segment;

                INSERT INTO mimansa.CRM.dbo.tbl_EKYC_AutoDeactivate_Log_AutoClosure(party_Code, segment, ActDeact, updatedOn, Processed, MailSent, Reprocess)
                       SELECT CAST(@party_Code AS VARCHAR(30)) AS party_code, CAST('MCX' AS VARCHAR(30)) AS segment, 'ALREADY DEACTIVATE', GETDATE() AS updatedOn, 'N' AS Processed, 'N', 'N';

                SELECT 'Successful Already Deactivated: '+@party_Code+' '+@segment;
            END;
    END;

   	

IF(@Segment LIKE '%NSX%')
    BEGIN

        SET @Deactive_Remarks =(SELECT TOP 1 ISNULL(Deactive_value, '1')
						  FROM msajag.dbo.client_brok_details
						  WHERE cl_code = @party_Code
							   AND Exchange IN('NSX')
						  AND Segment = 'FUTURES');
        PRINT 'Deactivate Remark: '+@Deactive_Remarks;
        IF(ISNULL(@Deactive_Remarks, '') <> 'C' OR ISNULL(@Deactive_Remarks, '') = '1') 
            BEGIN

                PRINT 'Deactivate Update in BO: '+@party_Code+' '+@segment;

                INSERT INTO msajag.dbo.client_brok_details_log(Cl_Code, Exchange, Segment, Brok_Scheme, Trd_Brok, Del_Brok, Ser_Tax, Ser_Tax_Method, Credit_Limit, InActive_From, Print_Options, No_Of_Copies, Participant_Code, Custodian_Code, Inst_Contract, Round_Style, STP_Provider, STP_Rp_Style, Market_Type, Multiplier, Charged, Maintenance, Reqd_By_Exch, Reqd_By_Broker, Client_Rating, Debit_Balance, Inter_Sett, TRD_STT, Trd_Tran_Chrgs, Trd_Sebi_Fees, Trd_Stamp_Duty, Trd_Other_Chrgs, Trd_Eff_Dt, Del_Stt, Del_Tran_Chrgs, Del_SEBI_Fees, Del_Stamp_Duty, Del_Other_Chrgs, Del_Eff_Dt, Rounding_Method, Round_To_Digit, Round_To_Paise, Fut_Brok, Fut_Opt_Brok, Fut_Fut_Fin_Brok, Fut_Opt_Exc, Fut_Brok_Applicable, Fut_Stt, Fut_Tran_Chrgs, Fut_Sebi_Fees, Fut_Stamp_Duty, Fut_Other_Chrgs, Status, Modifiedon, Modifiedby, Imp_Status, Pay_B3B_Payment, Pay_Bank_name, Pay_Branch_name, Pay_AC_No, Pay_payment_Mode, Brok_Eff_Date, Inst_Trd_Brok, Inst_Del_Brok, Edit_By, Edit_on, SYSTEMDATE, Active_Date, CheckActiveClient, Deactive_Remarks, Deactive_value)
                       SELECT Cl_Code, Exchange, Segment, Brok_Scheme, Trd_Brok, Del_Brok, Ser_Tax, Ser_Tax_Method, Credit_Limit, InActive_From, Print_Options, No_Of_Copies, Participant_Code, Custodian_Code, Inst_Contract, Round_Style, STP_Provider, STP_Rp_Style, Market_Type, Multiplier, Charged, Maintenance, Reqd_By_Exch, Reqd_By_Broker, Client_Rating, Debit_Balance, Inter_Sett, TRD_STT, Trd_Tran_Chrgs, Trd_Sebi_Fees, Trd_Stamp_Duty, Trd_Other_Chrgs, Trd_Eff_Dt, Del_Stt, Del_Tran_Chrgs, Del_SEBI_Fees, Del_Stamp_Duty, Del_Other_Chrgs, Del_Eff_Dt, Rounding_Method, Round_To_Digit, Round_To_Paise, Fut_Brok, Fut_Opt_Brok, Fut_Fut_Fin_Brok, Fut_Opt_Exc, Fut_Brok_Applicable, Fut_Stt, Fut_Tran_Chrgs, Fut_Sebi_Fees, Fut_Stamp_Duty, Fut_Other_Chrgs, Status, Modifiedon, Modifiedby, Imp_Status, Pay_B3B_Payment, Pay_Bank_name, Pay_Branch_name, Pay_AC_No, Pay_payment_Mode, Brok_Eff_Date, Inst_Trd_Brok, Inst_Del_Brok, 'E36024', GETDATE(), SYSTEMDATE, Active_Date, CheckActiveClient, Deactive_Remarks, Deactive_value
                       FROM msajag.dbo.client_brok_details WITH (nolock)
                       WHERE cl_code = @party_Code
                             AND Exchange IN('NSX')
                       AND Segment = 'FUTURES';


                UPDATE msajag.dbo.client_brok_details
                 SET
                     Deactive_Remarks = 'AS PER CLIENT CLOSURE REQUEST RECEIVED',
                     InActive_From = GETDATE(),
                     Deactive_value = 'C',
                     Imp_Status = 0,
                     Modifiedon = GETDATE(),
                     Modifiedby = @empNo
                WHERE cl_code = @party_Code
                      AND Exchange IN('NSX')
                      AND Segment = 'FUTURES';

                INSERT INTO mimansa.CRM.dbo.tbl_EKYC_AutoDeactivate_Log_AutoClosure(party_Code, segment, ActDeact, updatedOn, Processed, MailSent, Reprocess)
                       SELECT CAST(@party_Code AS VARCHAR(30)) AS party_code, CAST('NSX' AS VARCHAR(30)) AS segment, 'DEACTIVATE', GETDATE() AS updatedOn, 'Y' AS Processed, 'N', 'N';

                SELECT 'Successful Deactivate Update in BO: '+@party_Code+' '+@segment;
            END;
            ELSE
            BEGIN

                PRINT 'Already Deactivated: '+@party_Code+' '+@segment;

                INSERT INTO mimansa.CRM.dbo.tbl_EKYC_AutoDeactivate_Log_AutoClosure(party_Code, segment, ActDeact, updatedOn, Processed, MailSent, Reprocess)
                       SELECT CAST(@party_Code AS VARCHAR(30)) AS party_code, CAST('NSX' AS VARCHAR(30)) AS segment, 'ALREADY DEACTIVATE', GETDATE() AS updatedOn, 'N' AS Processed, 'N', 'N';

                SELECT 'Successful Already Deactivated: '+@party_Code+' '+@segment;
            END;
    END;

    

IF(@Segment LIKE '%MCD%')
    BEGIN
        SET @Deactive_Remarks =(SELECT TOP 1 ISNULL(Deactive_value, '1')
						  FROM msajag.dbo.client_brok_details
						  WHERE cl_code = @party_Code
							   AND Exchange IN('MCD')
						  AND Segment = 'FUTURES');
        PRINT 'Deactivate Remark: '+@Deactive_Remarks;
        IF(ISNULL(@Deactive_Remarks, '') <> 'C' OR ISNULL(@Deactive_Remarks, '') = '1') 
            BEGIN

                PRINT 'Deactivate Update in BO: '+@party_Code+' '+@segment;

                INSERT INTO msajag.dbo.client_brok_details_log(Cl_Code, Exchange, Segment, Brok_Scheme, Trd_Brok, Del_Brok, Ser_Tax, Ser_Tax_Method, Credit_Limit, InActive_From, Print_Options, No_Of_Copies, Participant_Code, Custodian_Code, Inst_Contract, Round_Style, STP_Provider, STP_Rp_Style, Market_Type, Multiplier, Charged, Maintenance, Reqd_By_Exch, Reqd_By_Broker, Client_Rating, Debit_Balance, Inter_Sett, TRD_STT, Trd_Tran_Chrgs, Trd_Sebi_Fees, Trd_Stamp_Duty, Trd_Other_Chrgs, Trd_Eff_Dt, Del_Stt, Del_Tran_Chrgs, Del_SEBI_Fees, Del_Stamp_Duty, Del_Other_Chrgs, Del_Eff_Dt, Rounding_Method, Round_To_Digit, Round_To_Paise, Fut_Brok, Fut_Opt_Brok, Fut_Fut_Fin_Brok, Fut_Opt_Exc, Fut_Brok_Applicable, Fut_Stt, Fut_Tran_Chrgs, Fut_Sebi_Fees, Fut_Stamp_Duty, Fut_Other_Chrgs, Status, Modifiedon, Modifiedby, Imp_Status, Pay_B3B_Payment, Pay_Bank_name, Pay_Branch_name, Pay_AC_No, Pay_payment_Mode, Brok_Eff_Date, Inst_Trd_Brok, Inst_Del_Brok, Edit_By, Edit_on, SYSTEMDATE, Active_Date, CheckActiveClient, Deactive_Remarks, Deactive_value)
                       SELECT Cl_Code, Exchange, Segment, Brok_Scheme, Trd_Brok, Del_Brok, Ser_Tax, Ser_Tax_Method, Credit_Limit, InActive_From, Print_Options, No_Of_Copies, Participant_Code, Custodian_Code, Inst_Contract, Round_Style, STP_Provider, STP_Rp_Style, Market_Type, Multiplier, Charged, Maintenance, Reqd_By_Exch, Reqd_By_Broker, Client_Rating, Debit_Balance, Inter_Sett, TRD_STT, Trd_Tran_Chrgs, Trd_Sebi_Fees, Trd_Stamp_Duty, Trd_Other_Chrgs, Trd_Eff_Dt, Del_Stt, Del_Tran_Chrgs, Del_SEBI_Fees, Del_Stamp_Duty, Del_Other_Chrgs, Del_Eff_Dt, Rounding_Method, Round_To_Digit, Round_To_Paise, Fut_Brok, Fut_Opt_Brok, Fut_Fut_Fin_Brok, Fut_Opt_Exc, Fut_Brok_Applicable, Fut_Stt, Fut_Tran_Chrgs, Fut_Sebi_Fees, Fut_Stamp_Duty, Fut_Other_Chrgs, Status, Modifiedon, Modifiedby, Imp_Status, Pay_B3B_Payment, Pay_Bank_name, Pay_Branch_name, Pay_AC_No, Pay_payment_Mode, Brok_Eff_Date, Inst_Trd_Brok, Inst_Del_Brok, 'E36024', GETDATE(), SYSTEMDATE, Active_Date, CheckActiveClient, Deactive_Remarks, Deactive_value
                       FROM msajag.dbo.client_brok_details WITH (nolock)
                       WHERE cl_code = @party_Code
                             AND Exchange IN('MCD')
                       AND Segment = 'FUTURES';


                UPDATE msajag.dbo.client_brok_details
                 SET
                     Deactive_Remarks = 'AS PER CLIENT CLOSURE REQUEST RECEIVED',
                     InActive_From = GETDATE(),
                     Deactive_value = 'C',
                     Imp_Status = 0,
                     Modifiedon = GETDATE(),
                     Modifiedby = @empNo
                WHERE cl_code = @party_Code
                      AND Exchange IN('MCD')
                      AND Segment = 'FUTURES';

                INSERT INTO mimansa.CRM.dbo.tbl_EKYC_AutoDeactivate_Log_AutoClosure(party_Code, segment, ActDeact, updatedOn, Processed, MailSent, Reprocess)
                       SELECT CAST(@party_Code AS VARCHAR(30)) AS party_code, CAST('MCD' AS VARCHAR(30)) AS segment, 'DEACTIVATE', GETDATE() AS updatedOn, 'Y' AS Processed, 'N', 'N';

                SELECT 'Successful Deactivate Update in BO: '+@party_Code+' '+@segment;
            END;
            ELSE
            BEGIN

                PRINT 'Already Deactivated: '+@party_Code+' '+@segment;

                INSERT INTO mimansa.CRM.dbo.tbl_EKYC_AutoDeactivate_Log_AutoClosure(party_Code, segment, ActDeact, updatedOn, Processed, MailSent, Reprocess)
                       SELECT CAST(@party_Code AS VARCHAR(30)) AS party_code, CAST('MCD' AS VARCHAR(30)) AS segment, 'ALREADY DEACTIVATE', GETDATE() AS updatedOn, 'N' AS Processed, 'N', 'N';

                SELECT 'Successful Already Deactivated: '+@party_Code+' '+@segment;
            END;
    END;

  

IF(@Segment LIKE '%ALL%')
    BEGIN

        INSERT INTO msajag.dbo.client_brok_details_log(Cl_Code, Exchange, Segment, Brok_Scheme, Trd_Brok, Del_Brok, Ser_Tax, Ser_Tax_Method, Credit_Limit, InActive_From, Print_Options, No_Of_Copies, Participant_Code, Custodian_Code, Inst_Contract, Round_Style, STP_Provider, STP_Rp_Style, Market_Type, Multiplier, Charged, Maintenance, Reqd_By_Exch, Reqd_By_Broker, Client_Rating, Debit_Balance, Inter_Sett, TRD_STT, Trd_Tran_Chrgs, Trd_Sebi_Fees, Trd_Stamp_Duty, Trd_Other_Chrgs, Trd_Eff_Dt, Del_Stt, Del_Tran_Chrgs, Del_SEBI_Fees, Del_Stamp_Duty, Del_Other_Chrgs, Del_Eff_Dt, Rounding_Method, Round_To_Digit, Round_To_Paise, Fut_Brok, Fut_Opt_Brok, Fut_Fut_Fin_Brok, Fut_Opt_Exc, Fut_Brok_Applicable, Fut_Stt, Fut_Tran_Chrgs, Fut_Sebi_Fees, Fut_Stamp_Duty, Fut_Other_Chrgs, Status, Modifiedon, Modifiedby, Imp_Status, Pay_B3B_Payment, Pay_Bank_name, Pay_Branch_name, Pay_AC_No, Pay_payment_Mode, Brok_Eff_Date, Inst_Trd_Brok, Inst_Del_Brok, Edit_By, Edit_on, SYSTEMDATE, Active_Date, CheckActiveClient, Deactive_Remarks, Deactive_value)
               SELECT Cl_Code, Exchange, Segment, Brok_Scheme, Trd_Brok, Del_Brok, Ser_Tax, Ser_Tax_Method, Credit_Limit, InActive_From, Print_Options, No_Of_Copies, Participant_Code, Custodian_Code, Inst_Contract, Round_Style, STP_Provider, STP_Rp_Style, Market_Type, Multiplier, Charged, Maintenance, Reqd_By_Exch, Reqd_By_Broker, Client_Rating, Debit_Balance, Inter_Sett, TRD_STT, Trd_Tran_Chrgs, Trd_Sebi_Fees, Trd_Stamp_Duty, Trd_Other_Chrgs, Trd_Eff_Dt, Del_Stt, Del_Tran_Chrgs, Del_SEBI_Fees, Del_Stamp_Duty, Del_Other_Chrgs, Del_Eff_Dt, Rounding_Method, Round_To_Digit, Round_To_Paise, Fut_Brok, Fut_Opt_Brok, Fut_Fut_Fin_Brok, Fut_Opt_Exc, Fut_Brok_Applicable, Fut_Stt, Fut_Tran_Chrgs, Fut_Sebi_Fees, Fut_Stamp_Duty, Fut_Other_Chrgs, Status, Modifiedon, Modifiedby, Imp_Status, Pay_B3B_Payment, Pay_Bank_name, Pay_Branch_name, Pay_AC_No, Pay_payment_Mode, Brok_Eff_Date, Inst_Trd_Brok, Inst_Del_Brok, 'E36024', GETDATE(), SYSTEMDATE, Active_Date, CheckActiveClient, Deactive_Remarks, Deactive_value
               FROM msajag.dbo.client_brok_details WITH (nolock)
               WHERE cl_code = @party_Code
                     AND Exchange IN('BSE', 'NSE', 'NSX', 'BSX', 'MCD', 'MCX', 'NCX')
               AND (Deactive_value NOT IN('C')
               OR Deactive_value IS NULL);


        UPDATE msajag.dbo.client_brok_details
         SET
             Deactive_Remarks = 'AS PER CLIENT CLOSURE REQUEST RECEIVED',
             InActive_From = GETDATE(),
             Deactive_value = 'C',
             Imp_Status = 0,
             Modifiedon = GETDATE(),
             Modifiedby = @empNo
        WHERE cl_code = @party_Code
              AND Exchange IN('BSE', 'NSE', 'NSX', 'BSX', 'MCD', 'MCX', 'NCX')
              AND (Deactive_value NOT IN('C')
                   OR Deactive_value IS NULL);

        SET @RowCount1 = 0;

        SELECT @RowCount1 = @@ROWCOUNT;

        IF(@RowCount1 > 0)
            BEGIN

                INSERT INTO mimansa.CRM.dbo.tbl_EKYC_AutoDeactivate_Log_AutoClosure(party_Code, segment, ActDeact, updatedOn, Processed, MailSent, Reprocess)
                       SELECT CAST(@party_Code AS VARCHAR(30)) AS party_code, CAST('ALL' AS VARCHAR(30)) AS segment, 'DEACTIVATE', GETDATE() AS updatedOn, 'Y' AS Processed, 'N', 'N';

                SELECT 'Successful Deactivate Update in BO: '+@party_Code+' '+@segment;
            END;
            ELSE

            BEGIN
                INSERT INTO mimansa.CRM.dbo.tbl_EKYC_AutoDeactivate_Log_AutoClosure(party_Code, segment, ActDeact, updatedOn, Processed, MailSent, Reprocess)
                       SELECT CAST(@party_Code AS VARCHAR(30)) AS party_code, CAST('ALL' AS VARCHAR(30)) AS segment, 'ALREADY DEACTIVATE', GETDATE() AS updatedOn, 'N' AS Processed, 'N', 'N';

                SELECT 'Successful Already Deactivated: '+@party_Code+' '+@segment;
            END;
    END;
END TRY
BEGIN CATCH

    PRINT 'catch';
    SELECT @ErrorFlag = ERROR_MESSAGE();

    PRINT @ErrorFlag;

    SET @Subject = 'Error: [anand1].msajag.dbo.USP_Closure_Process_B2C '+@party_Code;
    SET @tableHTML = ''+CAST(@ErrorFlag AS VARCHAR(8000))+'';
    EXEC msdb.dbo.sp_send_dbmail
         @recipients = 'Priyanka.Shrikant@angelbroking.com',
         @body_format = 'HTML',
         @subject = @Subject,
         @body = @tableHTML,
         @profile_name = 'MimansaTeam';
END CATCH; 
 
END

GO
