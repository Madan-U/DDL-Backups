-- Object: TABLE citrus_usr.dp201
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[dp201]
(
    [boid] CHAR(16) NULL,
    [ACTIVATIONDATE] VARCHAR(20) NULL,
    [name] CHAR(100) NULL,
    [MiddleName] CHAR(20) NULL,
    [SearchName] CHAR(20) NULL,
    [STATUS] VARCHAR(100) NULL,
    [pangir] CHAR(25) NULL,
    [SECOND HOLDER NAME] CHAR(140) NOT NULL,
    [THIRD HOLDER NAME] CHAR(140) NOT NULL,
    [SECOND HOLDER PAN] CHAR(25) NULL,
    [Thrid HOLDER PAN ] CHAR(25) NULL,
    [Addr1] VARCHAR(55) NULL,
    [Addr2] VARCHAR(55) NULL,
    [Addr3] VARCHAR(55) NULL,
    [City] CHAR(25) NULL,
    [state] CHAR(25) NULL,
    [country] CHAR(25) NULL,
    [PinCode] CHAR(10) NULL,
    [SUBCM_dESC] VARCHAR(200) NULL
);

GO
