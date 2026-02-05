-- Object: TABLE citrus_usr.dp_mstr_bak_05022025
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[dp_mstr_bak_05022025]
(
    [DPM_ID] NUMERIC(10, 0) NOT NULL,
    [DPM_NAME] VARCHAR(250) NULL,
    [DPM_DPID] VARCHAR(50) NOT NULL,
    [DPM_RMKS] VARCHAR(250) NULL,
    [DPM_CREATED_BY] VARCHAR(25) NOT NULL,
    [DPM_CREATED_DT] DATETIME NOT NULL,
    [DPM_LST_UPD_BY] VARCHAR(25) NOT NULL,
    [DPM_LST_UPD_DT] DATETIME NOT NULL,
    [DPM_DELETED_IND] SMALLINT NOT NULL,
    [dpm_short_name] VARCHAR(20) NULL,
    [default_dp] NUMERIC(10, 0) NULL,
    [dpm_excsm_id] NUMERIC(10, 0) NULL
);

GO
