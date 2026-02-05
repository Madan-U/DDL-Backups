-- Object: TABLE citrus_usr.classremmaster
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[classremmaster]
(
    [ssubbrokername] VARCHAR(35) NULL,
    [BO_SubBroker] VARCHAR(14) NULL,
    [BO_Branch] VARCHAR(10) NULL,
    [BO_Region] VARCHAR(15) NULL,
    [entm_id] NUMERIC(10, 0) NOT NULL,
    [entm_enttm_cd] VARCHAR(20) NOT NULL,
    [entm_short_name] VARCHAR(100) NULL
);

GO
