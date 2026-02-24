-- Object: TABLE citrus_usr.inward_slip_reg_bk_14102019
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[inward_slip_reg_bk_14102019]
(
    [INWSR_ID] NUMERIC(10, 0) NOT NULL,
    [INWSR_SLIP_NO] VARCHAR(50) NULL,
    [INWSR_DPM_ID] NUMERIC(10, 0) NULL,
    [INWSR_DPAM_ID] NUMERIC(10, 0) NULL,
    [INWSR_RECD_DT] DATETIME NULL,
    [INWSR_EXEC_DT] DATETIME NULL,
    [INWSR_NO_OF_TRANS] INT NULL,
    [INWSR_RECEIVED_MODE] VARCHAR(200) NULL,
    [INWSR_CREATED_BY] VARCHAR(25) NULL,
    [INWSR_CREATED_DT] DATETIME NULL,
    [INWSR_LST_UPD_BY] VARCHAR(25) NULL,
    [INWSR_LST_UPD_DT] DATETIME NULL,
    [INWSR_DELETED_IND] SMALLINT NULL,
    [INWSR_RMKS] VARCHAR(250) NULL,
    [inwsr_trastm_cd] VARCHAR(10) NULL,
    [inwsr_transubtype_cd] VARCHAR(10) NULL,
    [inwsr_ufcharge_collected] NUMERIC(18, 2) NULL,
    [inwsr_PAY_MODE] VARCHAR(10) NULL,
    [inwsr_cheque_no] VARCHAR(20) NULL,
    [inwsr_clibank_accno] VARCHAR(20) NULL,
    [inwsr_bankid] NUMERIC(18, 0) NULL,
    [inwsr_doc_path] VARCHAR(8000) NULL,
    [inwsr_clibank_name] VARCHAR(1000) NULL,
    [inwsr_cheque_dt] DATETIME NULL,
    [inwsr_bank_branch] VARCHAR(500) NULL,
    [inwsr_fax_scan_status] VARCHAR(20) NULL,
    [INWSR_NO_OF_IMAGES] INT NULL,
    [INWSR_IMAGE_FLG] CHAR(1) NULL
);

GO
