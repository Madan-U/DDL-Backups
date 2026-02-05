-- Object: TABLE citrus_usr.bak_tmp03072023
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[bak_tmp03072023]
(
    [BOID] CHAR(16) NULL,
    [Client_name] VARCHAR(150) NOT NULL,
    [Holding_Valuation] NUMERIC(18, 2) NULL,
    [BBOcode] VARCHAR(20) NOT NULL,
    [Current_tariff] VARCHAR(200) NOT NULL,
    [Tariff_to_be_changed] VARCHAR(200) NOT NULL,
    [REMARKS] VARCHAR(21) NOT NULL,
    [BROM_ID] VARCHAR(20) NULL
);

GO
