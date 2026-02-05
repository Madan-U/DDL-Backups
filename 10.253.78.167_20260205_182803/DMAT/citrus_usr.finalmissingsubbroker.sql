-- Object: TABLE citrus_usr.finalmissingsubbroker
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[finalmissingsubbroker]
(
    [id] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [ssubbrokername] VARCHAR(35) NULL,
    [bo_subbroker] VARCHAR(14) NULL,
    [entm_id] NUMERIC(10, 0) NOT NULL
);

GO
