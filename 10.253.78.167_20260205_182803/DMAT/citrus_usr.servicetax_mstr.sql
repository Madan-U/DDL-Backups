-- Object: TABLE citrus_usr.servicetax_mstr
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[servicetax_mstr]
(
    [amount] NUMERIC(18, 4) NULL,
    [from_dt] DATETIME NULL,
    [to_dt] DATETIME NULL,
    [created_by] VARCHAR(100) NULL,
    [created_dt] DATETIME NULL,
    [lst_upd_by] VARCHAR(100) NULL,
    [lst_upd_dt] DATETIME NULL,
    [deleted_ind] NUMERIC(18, 0) NULL,
    [TAX_DESC] VARCHAR(50) NULL,
    [SERM_ENTM_ID] VARCHAR(20) NULL
);

GO
