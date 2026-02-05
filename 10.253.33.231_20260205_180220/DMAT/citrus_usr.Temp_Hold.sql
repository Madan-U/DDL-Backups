-- Object: TABLE citrus_usr.Temp_Hold
-- Server: 10.253.33.231 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[Temp_Hold]
(
    [Client_Code] VARCHAR(16) NULL,
    [Active_date] DATETIME NULL,
    [nise_party_code] VARCHAR(10) NULL,
    [Fin_Year] VARCHAR(9) NOT NULL,
    [Hold_Val_2021] MONEY NULL,
    [Hold_Val_2122] MONEY NULL,
    [Hold_Val_2223] MONEY NULL,
    [Hold_Val_23] MONEY NULL
);

GO
