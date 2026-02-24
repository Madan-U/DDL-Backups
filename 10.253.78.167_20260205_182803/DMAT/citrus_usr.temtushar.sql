-- Object: TABLE citrus_usr.temtushar
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[temtushar]
(
    [DPAM_SBA_NO] VARCHAR(20) NOT NULL,
    [brom_desc] VARCHAR(200) NOT NULL,
    [charge_name] VARCHAR(8000) NOT NULL,
    [amt] NUMERIC(38, 5) NOT NULL,
    [service_tax_amt] NUMERIC(38, 6) NOT NULL,
    [dp_charge] VARCHAR(1) NOT NULL
);

GO
