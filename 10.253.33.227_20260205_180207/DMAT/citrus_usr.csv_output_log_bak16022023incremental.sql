-- Object: TABLE citrus_usr.csv_output_log_bak16022023incremental
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[csv_output_log_bak16022023incremental]
(
    [run_date] DATETIME NOT NULL,
    [FROMDT] DATETIME NULL,
    [TODT] DATETIME NULL,
    [CLTCODE] VARCHAR(100) NULL,
    [fina_acc_code] VARCHAR(100) NULL,
    [drcr] CHAR(1) NULL,
    [AMOUNT] NUMERIC(18, 2) NULL,
    [DPAM_SBA_NO] VARCHAR(20) NULL,
    [charge_name] VARCHAR(800) NULL,
    [charge_name_dt] DATETIME NULL
);

GO
