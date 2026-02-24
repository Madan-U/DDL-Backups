-- Object: TABLE citrus_usr.augamc2021
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[augamc2021]
(
    [FROMDT] VARCHAR(1) NOT NULL,
    [TODT] VARCHAR(1) NOT NULL,
    [CLTCODE] VARCHAR(20) NOT NULL,
    [fina_acc_code] VARCHAR(25) NULL,
    [DRCR] VARCHAR(1) NOT NULL,
    [AMOUNT] NUMERIC(38, 5) NULL,
    [DPAM_SBA_NO] VARCHAR(20) NOT NULL,
    [FINA_ACC_NAME] VARCHAR(59) NULL,
    [CLIC_TRANS_DT] DATETIME NULL,
    [DPAM_ID] NUMERIC(10, 0) NOT NULL
);

GO
