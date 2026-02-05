-- Object: TABLE citrus_usr.Slip_issue_data_Nov2025
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[Slip_issue_data_Nov2025]
(
    [CLIENT ID] VARCHAR(21) NOT NULL,
    [CLIENT NAME] VARCHAR(150) NULL,
    [SLIP TYPE] VARCHAR(30) NULL,
    [ ISSUE DATE] VARCHAR(11) NULL,
    [ BOOK SERIES] VARCHAR(1) NOT NULL,
    [ FROM] VARCHAR(20) NULL,
    [ TO] VARCHAR(20) NULL,
    [ NO.OF SLIPS] INT NULL,
    [ SLIP BOOK NAME] VARCHAR(1) NOT NULL
);

GO
