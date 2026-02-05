-- Object: TABLE dbo.dp_kra_data
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [dbo].[dp_kra_data]
(
    [NISE_PARTY_CODE] VARCHAR(10) NULL,
    [CLIENT_CODE] VARCHAR(16) NULL,
    [ACTIVE_DATE] DATETIME NULL,
    [FIRST_HOLD_NAME] VARCHAR(100) NULL,
    [FIRST_HOLD_PAN] VARCHAR(25) NULL,
    [SECOND_HOLD_ITPAN] VARCHAR(25) NULL,
    [THIRD_HOLD_ITPAN] VARCHAR(25) NULL
);

GO
