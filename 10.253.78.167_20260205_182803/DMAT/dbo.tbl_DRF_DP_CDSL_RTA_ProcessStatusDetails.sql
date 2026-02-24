-- Object: TABLE dbo.tbl_DRF_DP_CDSL_RTA_ProcessStatusDetails
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [dbo].[tbl_DRF_DP_CDSL_RTA_ProcessStatusDetails]
(
    [DRFNo] VARCHAR(35) NULL,
    [DEMRM_ID] VARCHAR(35) NULL,
    [CurrentStatus] VARCHAR(455) NULL,
    [MakerProcessStatus] VARCHAR(255) NULL,
    [IsMakerProcess] BIT NULL,
    [MakerProcessDate] DATETIME NULL,
    [MakerBy] VARCHAR(35) NULL,
    [IsCheckerProcess] BIT NULL,
    [IsCheckerRejected] BIT NULL,
    [CheckerProcessStatus] VARCHAR(355) NULL,
    [CheckerProcessRemarks] VARCHAR(455) NULL,
    [CheckerProcessDate] DATETIME NULL,
    [CheckerBy] VARCHAR(35) NULL,
    [BatchUploadInCDSL] BIT NULL,
    [BatchNo] VARCHAR(55) NULL,
    [DRNNo] VARCHAR(35) NULL,
    [IsCDSLProcess] BIT NULL,
    [IsCDSLRejected] BIT NULL,
    [CDSLStatus] VARCHAR(335) NULL,
    [CDSLRemarks] VARCHAR(455) NULL,
    [CDSLProcessDate] DATETIME NULL,
    [RTALetterGenerate] BIT NULL,
    [DispatchDate] DATETIME NULL,
    [IsRTAProcess] BIT NULL,
    [RTAProcessDate] DATETIME NULL,
    [RTAStatus] VARCHAR(55) NULL,
    [RTARemarks] VARCHAR(455) NULL
);

GO
