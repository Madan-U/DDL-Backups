-- Object: TABLE citrus_usr.tempdataclient
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[tempdataclient]
(
    [Month] VARCHAR(8000) NULL,
    [BranchCode] VARCHAR(100) NULL,
    [Branchname] VARCHAR(100) NULL,
    [subbroker] VARCHAR(100) NOT NULL,
    [subbrokername] VARCHAR(100) NOT NULL,
    [dpam_sba_no] VARCHAR(20) NOT NULL,
    [TradingCode] VARCHAR(20) NOT NULL,
    [scheme] VARCHAR(200) NULL,
    [Bill amt] NUMERIC(38, 5) NULL,
    [Administraton Charges] NUMERIC(38, 5) NULL,
    [DP DOCUMENT] NUMERIC(38, 5) NULL,
    [AMC charge] NUMERIC(38, 5) NULL,
    [TransactionBilled] NUMERIC(38, 5) NULL,
    [DEMAT/REMAT (set up)] NUMERIC(38, 5) NULL,
    [DEMAT/REMAT (rejection)] NUMERIC(38, 5) NULL,
    [ServiceTax] NUMERIC(38, 5) NULL,
    [Total CDSL TRX Charge with service tax] NUMERIC(38, 3) NULL
);

GO
