-- Object: TABLE dbo.acc_current
-- Server: 10.253.33.231 | DB: Scratchpad
--------------------------------------------------

CREATE TABLE [dbo].[acc_current]
(
    [PARTY_CODE] VARCHAR(20) NULL,
    [CLIENT_CODE] VARCHAR(20) NOT NULL,
    [Actual_amount] MONEY NULL,
    [Accrual_bal] NUMERIC(38, 5) NULL,
    [Branch_Code] VARCHAR(1) NOT NULL
);

GO
