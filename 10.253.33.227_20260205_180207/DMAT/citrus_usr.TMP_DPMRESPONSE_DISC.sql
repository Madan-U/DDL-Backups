-- Object: TABLE citrus_usr.TMP_DPMRESPONSE_DISC
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[TMP_DPMRESPONSE_DISC]
(
    [Batch_No] INT NULL,
    [Record_Type] INT NULL,
    [Branch_Code] CHAR(6) NULL,
    [DPID] CHAR(8) NULL,
    [DP_Role] INT NULL,
    [Accepted_Flag] CHAR(1) NULL,
    [Total_Records] INT NULL,
    [Accepted_records] INT NULL,
    [Date] DATETIME NULL,
    [User_Id] CHAR(8) NULL,
    [Filler] CHAR(9) NULL
);

GO
