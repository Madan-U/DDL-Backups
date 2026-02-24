-- Object: TABLE citrus_usr.accrual_31032018_beforeamclogic
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[accrual_31032018_beforeamclogic]
(
    [PARTY_CODE] VARCHAR(20) NULL,
    [CLIENT_CODE] VARCHAR(20) NOT NULL,
    [Actual_amount] MONEY NULL,
    [Accrual_bal] NUMERIC(38, 5) NULL,
    [Branch_Code] VARCHAR(1) NOT NULL
);

GO
