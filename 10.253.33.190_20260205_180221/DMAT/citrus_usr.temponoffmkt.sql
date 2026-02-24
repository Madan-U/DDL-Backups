-- Object: TABLE citrus_usr.temponoffmkt
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[temponoffmkt]
(
    [FROMDT] VARCHAR(12) NOT NULL,
    [TODT] VARCHAR(11) NOT NULL,
    [CLTCODE] VARCHAR(20) NOT NULL,
    [fina_acc_code] VARCHAR(25) NULL,
    [DRCR] VARCHAR(1) NOT NULL,
    [AMOUNT] NUMERIC(38, 5) NULL,
    [DPAM_SBA_NO] VARCHAR(20) NOT NULL,
    [FINA_ACC_NAME] VARCHAR(88) NULL,
    [dd] VARCHAR(1) NOT NULL
);

GO
