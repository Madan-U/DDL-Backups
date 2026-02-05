-- Object: TABLE citrus_usr.monthlytransdetails
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[monthlytransdetails]
(
    [DPCode] VARCHAR(16) NULL,
    [ISIN] VARCHAR(20) NULL,
    [Security] VARCHAR(140) NULL,
    [Date] VARCHAR(11) NULL,
    [Reference] VARCHAR(50) NULL,
    [Particulars] VARCHAR(200) NULL,
    [DEBIT] NUMERIC(18, 5) NULL,
    [Credit] NUMERIC(18, 5) NULL,
    [Opening] NUMERIC(18, 5) NOT NULL,
    [Balance] NUMERIC(18, 5) NOT NULL,
    [HoldingDate] VARCHAR(8) NULL
);

GO
