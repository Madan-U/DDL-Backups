-- Object: TABLE dbo.Name_ONOFF_Final
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [dbo].[Name_ONOFF_Final]
(
    [CRN_NO] BIGINT NOT NULL,
    [BO_PARTYCODE] VARCHAR(10) NULL,
    [CREATED_DT] DATETIME NULL,
    [DOCUMENT_TYPE] VARCHAR(5) NOT NULL,
    [CREATED_BY] VARCHAR(50) NULL,
    [dp_batch_no] NUMERIC(18, 0) NULL,
    [NEW_F_Name] VARCHAR(105) NULL,
    [NEW_M_Name] VARCHAR(100) NULL,
    [NEW_L_Name] VARCHAR(100) NULL,
    [Father_Name] VARCHAR(105) NULL,
    [DP_ID] VARCHAR(16) NULL,
    [BO_UPD] VARCHAR(1) NULL,
    [DP_UPD] VARCHAR(1) NULL,
    [DP_ACTIVE] VARCHAR(20) NULL,
    [DP_Status] VARCHAR(40) NULL,
    [Modification_Status] VARCHAR(20) NOT NULL,
    [Migration_Status] VARCHAR(28) NOT NULL,
    [Create_Date] DATETIME NOT NULL
);

GO
