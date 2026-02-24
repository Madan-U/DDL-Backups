-- Object: TABLE dbo.PAY_IN_DP_NOT_MAPPED_Report
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [dbo].[PAY_IN_DP_NOT_MAPPED_Report]
(
    [cl_code] VARCHAR(10) NOT NULL,
    [pan_gir_no] VARCHAR(50) NULL,
    [client_code] VARCHAR(16) NULL,
    [poa_name] VARCHAR(100) NULL,
    [type] VARCHAR(40) NULL,
    [SUB_TYPE] VARCHAR(40) NULL,
    [nise_party_code] VARCHAR(10) NULL,
    [First_hold_pan] VARCHAR(25) NULL,
    [first_hold_name] VARCHAR(100) NULL,
    [status] VARCHAR(40) NULL,
    [PAY_IN_DP] VARCHAR(10) NOT NULL,
    [Create_Date] DATETIME NOT NULL
);

GO
