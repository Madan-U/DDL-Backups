-- Object: TABLE citrus_usr.tempdata_monthly
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[tempdata_monthly]
(
    [id] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [CLIC_TRANS_DT] DATETIME NULL,
    [clic_charge_name] VARCHAR(150) NULL,
    [clic_dpam_id] VARCHAR(25) NULL,
    [CHAM_CHARGE_TYPE] VARCHAR(6) NOT NULL,
    [CLIC_CHARGE_AMT] NUMERIC(18, 5) NULL
);

GO
