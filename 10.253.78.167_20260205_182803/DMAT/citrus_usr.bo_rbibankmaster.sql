-- Object: TABLE citrus_usr.bo_rbibankmaster
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[bo_rbibankmaster]
(
    [RBI_BANKID] BIGINT NOT NULL,
    [BANK_NAME] VARCHAR(100) NULL,
    [IFSC_CODE] VARCHAR(25) NULL,
    [MICR_CODE] VARCHAR(25) NULL,
    [BRANCH_NAME] VARCHAR(150) NULL,
    [ADDRESS] VARCHAR(255) NULL,
    [CONTACT] VARCHAR(255) NULL,
    [CENTRE] VARCHAR(255) NULL,
    [DISTRICT] VARCHAR(255) NULL,
    [STATE] VARCHAR(255) NULL
);

GO
