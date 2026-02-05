-- Object: TABLE dbo.EMAIL1_ONOFF_Final
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [dbo].[EMAIL1_ONOFF_Final]
(
    [CRN_NO] BIGINT NOT NULL,
    [BO_PARTYCODE] VARCHAR(10) NULL,
    [dp_batch_no] NUMERIC(18, 0) NULL,
    [CREATED_DT] DATETIME NULL,
    [DOCUMENT_TYPE] VARCHAR(5) NOT NULL,
    [NEW_EMAIL] VARCHAR(100) NULL,
    [NEW_MOB_NO] VARCHAR(40) NULL,
    [DP_ID] VARCHAR(16) NULL,
    [BO_UPD] VARCHAR(1) NULL,
    [DP_UPD] VARCHAR(1) NULL,
    [DP_Status] VARCHAR(40) NULL,
    [Migration_Status] VARCHAR(28) NOT NULL,
    [Create_Date] DATETIME NOT NULL
);

GO
