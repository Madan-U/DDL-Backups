-- Object: TABLE dbo.DPPOA_status_AZURE
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [dbo].[DPPOA_status_AZURE]
(
    [PARTY_CODE] VARCHAR(10) NULL,
    [dPID] VARCHAR(16) NULL,
    [POA] VARCHAR(8) NOT NULL,
    [ACCOUNT_STATUS] VARCHAR(6) NOT NULL,
    [HOLDING] VARCHAR(1) NOT NULL
);

GO
