-- Object: TABLE citrus_usr.tmp_rbimaster
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[tmp_rbimaster]
(
    [BANK_NAME] VARCHAR(100) NULL,
    [IFSC_CODE] VARCHAR(25) NULL,
    [MICR_CODE] VARCHAR(25) NULL,
    [BRANCH_NAME] VARCHAR(150) NULL,
    [ADDRESS] VARCHAR(255) NULL,
    [CONTACT] VARCHAR(255) NULL,
    [CENTRE] VARCHAR(255) NULL,
    [DISTRICT] VARCHAR(255) NULL,
    [STATE] VARCHAR(255) NULL,
    [RBI_BANKID] INT NOT NULL
);

GO
