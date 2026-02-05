-- Object: TABLE citrus_usr.OFF_MARKETDATA
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[OFF_MARKETDATA]
(
    [party_code] VARCHAR(20) NULL,
    [trans_date] DATETIME NULL,
    [isin] VARCHAR(20) NULL,
    [bse_code] INT NULL,
    [nse_symbol] VARCHAR(200) NULL,
    [NSESeries] VARCHAR(10) NULL,
    [trn_qty] NUMERIC(20, 5) NULL,
    [dr_cr] VARCHAR(1) NOT NULL,
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
