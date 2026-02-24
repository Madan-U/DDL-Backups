-- Object: TABLE citrus_usr.DIY_SRNO
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[DIY_SRNO]
(
    [SRNO] INT IDENTITY(1,1) NOT NULL,
    [CL_cODE] VARCHAR(10) NULL,
    [EXCHANGE] VARCHAR(10) NULL,
    [ISIN] VARCHAR(25) NULL,
    [CREATE_dT] DATETIME NULL
);

GO
