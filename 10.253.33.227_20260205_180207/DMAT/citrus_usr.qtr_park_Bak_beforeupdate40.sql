-- Object: TABLE citrus_usr.qtr_park_Bak_beforeupdate40
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[qtr_park_Bak_beforeupdate40]
(
    [trans_dt] DATETIME NULL,
    [dpam_id] NUMERIC(18, 0) NULL,
    [charge_name] VARCHAR(50) NULL,
    [charge_val] NUMERIC(18, 5) NULL,
    [post_toacct] NUMERIC(10, 0) NULL,
    [FLG] CHAR(1) NULL,
    [Q_FLG] INT NOT NULL,
    [Qtr] DATETIME NULL
);

GO
