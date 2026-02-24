-- Object: TABLE citrus_usr.ytemp01092021
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[ytemp01092021]
(
    [DPAM_SBA_NO] VARCHAR(20) NOT NULL,
    [brom_desc] VARCHAR(200) NOT NULL,
    [charge_name] VARCHAR(8000) NOT NULL,
    [amt] NUMERIC(38, 5) NOT NULL,
    [service_tax_amt] NUMERIC(38, 6) NOT NULL,
    [sbt_amt] NUMERIC(38, 6) NOT NULL,
    [KKC_amt] NUMERIC(38, 6) NOT NULL,
    [SGST] NUMERIC(38, 6) NOT NULL,
    [CGST] NUMERIC(38, 6) NOT NULL,
    [IGST] NUMERIC(38, 6) NOT NULL,
    [UGST] NUMERIC(38, 6) NOT NULL,
    [dp_charge] NUMERIC(18, 3) NULL
);

GO
