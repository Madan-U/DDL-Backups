-- Object: TABLE citrus_usr.client_checklist_cdsl
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[client_checklist_cdsl]
(
    [cch_dpintrefno] VARCHAR(10) NULL,
    [cch_cmcd] VARCHAR(16) NULL,
    [cch_check] CHAR(3) NULL,
    [mkrid] CHAR(8) NULL,
    [mkrdt] VARCHAR(11) NULL,
    [edittype] CHAR(1) NULL,
    [cmpltd] NUMERIC(18, 0) NULL
);

GO
