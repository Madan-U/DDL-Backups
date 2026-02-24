-- Object: TABLE citrus_usr.tempdatatocheck1
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[tempdatatocheck1]
(
    [dphmcd_holding_dt] DATETIME NULL,
    [dpam_sba_no] VARCHAR(20) NOT NULL,
    [entm_short_name] VARCHAR(8000) NULL,
    [isin] VARCHAR(20) NULL,
    [valuation] NUMERIC(38, 9) NULL,
    [pledge_valuation] NUMERIC(38, 9) NULL,
    [lockin_valuation] NUMERIC(38, 9) NULL,
    [demat_valuation] NUMERIC(38, 9) NULL
);

GO
