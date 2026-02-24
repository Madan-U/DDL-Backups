-- Object: TABLE dbo.Synergy_CLIENT_MASTER_AUDIT
-- Server: 10.253.33.190 | DB: inhouse
--------------------------------------------------

CREATE TABLE [dbo].[Synergy_CLIENT_MASTER_AUDIT]
(
    [Client_code] VARCHAR(40) NULL,
    [SEQ_NO] VARCHAR(40) NULL,
    [TABLE_NAME] VARCHAR(30) NULL,
    [COLUMN_TYPE] VARCHAR(1) NULL,
    [OLD_VALUE] VARCHAR(2000) NULL,
    [NEW_VALUE] VARCHAR(2000) NULL,
    [USER_ID] VARCHAR(30) NULL,
    [TERMINAL] VARCHAR(30) NULL,
    [DATE_TIME] DATETIME NULL,
    [column_name] VARCHAR(40) NULL
);

GO
