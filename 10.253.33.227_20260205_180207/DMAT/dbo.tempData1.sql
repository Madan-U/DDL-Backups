-- Object: TABLE dbo.tempData1
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [dbo].[tempData1]
(
    [nise_party_code] VARCHAR(10) NULL,
    [client_code] VARCHAR(16) NULL,
    [ACTIVE_DATE] DATETIME NULL,
    [CLOSURE_DATE] DATETIME NULL,
    [ACTIVE_STATUS] VARCHAR(1) NOT NULL,
    [FIRST_HOLD_PAN] VARCHAR(25) NULL,
    [SECOND_HOLD_ITPAN] VARCHAR(25) NULL,
    [THIRD_HOLD_ITPAN] VARCHAR(25) NULL,
    [EMAIL_ADD] VARCHAR(50) NULL,
    [FIRST_HOLD_PHONE] VARCHAR(17) NULL,
    [Rank] BIGINT NULL
);

GO
