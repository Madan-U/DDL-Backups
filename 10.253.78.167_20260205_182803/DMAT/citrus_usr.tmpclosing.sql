-- Object: TABLE citrus_usr.tmpclosing
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[tmpclosing]
(
    [accp_value] DATETIME NULL,
    [dpam_id] NUMERIC(10, 0) NOT NULL,
    [dpam_sba_no] VARCHAR(20) NOT NULL,
    [dpam_sba_name] VARCHAR(150) NULL,
    [close_dt] DATETIME NULL,
    [dpm_dpid] VARCHAR(50) NOT NULL,
    [DPAM_BBO_CODE] VARCHAR(20) NULL
);

GO
