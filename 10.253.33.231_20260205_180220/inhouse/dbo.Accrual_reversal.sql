-- Object: TABLE dbo.Accrual_reversal
-- Server: 10.253.33.231 | DB: inhouse
--------------------------------------------------

CREATE TABLE [dbo].[Accrual_reversal]
(
    [Client_Code] VARCHAR(20) NULL,
    [party_code] VARCHAR(10) NULL,
    [amt] MONEY NULL,
    [adjust_from_date] DATETIME NULL,
    [adjust_to_date] DATETIME NULL
);

GO
