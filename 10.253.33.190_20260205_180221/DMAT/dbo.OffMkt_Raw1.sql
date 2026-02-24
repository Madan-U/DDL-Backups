-- Object: TABLE dbo.OffMkt_Raw1
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [dbo].[OffMkt_Raw1]
(
    [party_code] VARCHAR(20) NULL,
    [trans_date] SMALLDATETIME NULL,
    [isin] VARCHAR(12) NULL,
    [bse_code] INT NULL,
    [nse_symbol] VARCHAR(200) NULL,
    [NSESeries] VARCHAR(10) NULL,
    [trn_qty] MONEY NULL,
    [dr_cr] VARCHAR(1) NULL,
    [mkt_rate] DECIMAL(18, 4) NULL,
    [TD_DESCRIPTION] VARCHAR(100) NULL,
    [TD_AC_CODE] VARCHAR(16) NULL,
    [TD_BENEFICIERY] VARCHAR(16) NULL,
    [TD_COUNTERDP] VARCHAR(16) NULL,
    [sl_angel_code] INT NULL,
    [UpdDate] DATETIME NOT NULL,
    [CoCode] VARCHAR(20) NULL,
    [OffMktId] VARCHAR(32) NULL
);

GO
