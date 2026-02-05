-- Object: TABLE citrus_usr.TEMPPOADATE
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[TEMPPOADATE]
(
    [DPPD_FNAME] VARCHAR(100) NULL,
    [DPPD_MNAME] VARCHAR(50) NULL,
    [DPPD_LNAME] VARCHAR(50) NULL,
    [DPPD_DOB] DATETIME NULL,
    [DPPD_PAN_NO] VARCHAR(20) NULL,
    [dppd_poa_id] VARCHAR(16) NULL,
    [dppd_master_id] VARCHAR(25) NULL,
    [dppd_poa_type] VARCHAR(20) NULL,
    [dppd_setup] DATETIME NULL,
    [dppd_eff_fr_dt] DATETIME NULL,
    [dppd_eff_to_dt] DATETIME NULL,
    [POA_STATUS] VARCHAR(6) NOT NULL,
    [DPPD_HLD] VARCHAR(20) NOT NULL
);

GO
