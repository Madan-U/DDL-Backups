-- Object: TABLE dbo.bal_rectification
-- Server: 10.253.33.231 | DB: Scratchpad
--------------------------------------------------

CREATE TABLE [dbo].[bal_rectification]
(
    [party_code] VARCHAR(20) NULL,
    [client_code] VARCHAR(20) NOT NULL,
    [wrong_bal] MONEY NULL,
    [correct_bal] MONEY NULL,
    [reversal_bal] MONEY NULL
);

GO
