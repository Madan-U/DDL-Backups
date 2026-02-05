-- Object: TABLE citrus_usr.BBR
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[BBR]
(
    [dpam_sba_no] VARCHAR(21) NOT NULL,
    [tradingid] VARCHAR(20) NULL,
    [brom_desc] VARCHAR(200) NOT NULL,
    [charge_name] VARCHAR(8000) NOT NULL,
    [amt] NUMERIC(38, 3) NULL,
    [SGST] NUMERIC(38, 6) NULL,
    [CGST] NUMERIC(38, 6) NULL,
    [IGST] NUMERIC(38, 6) NULL,
    [UGST] NUMERIC(38, 6) NULL,
    [cdslcharge] NUMERIC(18, 3) NULL,
    [activationdt] VARCHAR(10) NULL,
    [state] CHAR(25) NULL
);

GO
