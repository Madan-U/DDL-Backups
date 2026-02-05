-- Object: TABLE dbo.PAY_IN_PAY_OUT_DP_FREEZD_IN_CDSL_Report
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [dbo].[PAY_IN_PAY_OUT_DP_FREEZD_IN_CDSL_Report]
(
    [BOID] BIGINT NULL,
    [freezeid] BIGINT NULL,
    [FreezeIniDt] DATETIME NULL,
    [FreezeIniBy] VARCHAR(255) NULL,
    [FreezeStatus] VARCHAR(50) NULL,
    [FreezeRmks] VARCHAR(255) NULL,
    [nise_party_code] VARCHAR(50) NULL,
    [FIRST_HOLD_PAN] VARCHAR(20) NULL,
    [SECOND_HOLD_ITPAN] VARCHAR(20) NULL,
    [THIRD_HOLD_ITPAN] VARCHAR(20) NULL,
    [Freezed_ID_CDSL] VARCHAR(8000) NULL,
    [FreezeRmks_CDSL] VARCHAR(8000) NULL,
    [Create_Date] DATETIME NOT NULL
);

GO
