-- Object: TABLE citrus_usr.Excess_payin_2024214
-- Server: 10.253.33.231 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[Excess_payin_2024214]
(
    [party_code] VARCHAR(10) NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [sold_qty] INT NOT NULL,
    [REcd_qty] NUMERIC(38, 0) NOT NULL,
    [isin] VARCHAR(12) NULL
);

GO
