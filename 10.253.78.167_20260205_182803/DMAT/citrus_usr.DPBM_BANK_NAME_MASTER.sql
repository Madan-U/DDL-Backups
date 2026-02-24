-- Object: TABLE citrus_usr.DPBM_BANK_NAME_MASTER
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[DPBM_BANK_NAME_MASTER]
(
    [ID] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [BANK_NAME] VARCHAR(500) NULL,
    [CREATED_DATE] DATETIME NULL DEFAULT (getdate()),
    [STATUS] BIT NULL DEFAULT ((1)),
    [MODIFIED_DATE] DATETIME NULL
);

GO
