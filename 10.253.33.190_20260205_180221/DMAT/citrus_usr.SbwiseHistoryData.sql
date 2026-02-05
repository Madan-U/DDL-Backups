-- Object: TABLE citrus_usr.SbwiseHistoryData
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[SbwiseHistoryData]
(
    [Month] VARCHAR(8000) NULL,
    [BranchCode] VARCHAR(100) NULL,
    [Branchname] VARCHAR(100) NULL,
    [subbCode] VARCHAR(100) NOT NULL,
    [subname] VARCHAR(100) NOT NULL,
    [TradingCode] VARCHAR(1) NOT NULL,
    [AccountOpnedinMonth] INT NOT NULL,
    [ClosedDuringmonth] INT NOT NULL,
    [CorporateAccountopenedduringthemonth] INT NOT NULL,
    [Cost] NUMERIC(38, 3) NULL,
    [TotalCost] NUMERIC(38, 3) NULL,
    [TotalRev] NUMERIC(38, 5) NULL,
    [AMCBilled] NUMERIC(38, 5) NULL,
    [LIfetimeamc] NUMERIC(38, 5) NULL,
    [AccountOpeingCharge+Document] NUMERIC(38, 5) NULL,
    [TransactionBilled] NUMERIC(38, 5) NULL,
    [DematcouirerChargeBilled] NUMERIC(38, 5) NULL,
    [DematRejection] NUMERIC(38, 5) NULL,
    [CorporateAMC] NUMERIC(38, 5) NULL,
    [AdministrationCharge+Cdslcorporateamccharges] NUMERIC(38, 5) NULL,
    [ServiceTax] NUMERIC(38, 5) NULL,
    [DematOursharing] NUMERIC(38, 3) NULL,
    [FR-Sharing] NUMERIC(38, 3) NULL,
    [OurSharing] NUMERIC(38, 3) NULL,
    [AmconclosedA/c] NUMERIC(38, 3) NULL,
    [TotalChargesTODEBITEDIN1200A/C] NUMERIC(38, 5) NULL,
    [Franchiseesharing] NUMERIC(38, 5) NULL,
    [Tdsonfrincome] NUMERIC(38, 6) NULL,
    [FRAMCSHARING] NUMERIC(38, 3) NULL
);

GO
