-- Object: TABLE citrus_usr.region
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[region]
(
    [re_id] NUMERIC(18, 0) NOT NULL,
    [regioncode] VARCHAR(10) NULL,
    [description] VARCHAR(50) NULL,
    [branch_code] VARCHAR(10) NULL,
    [re_created_dt] DATETIME NOT NULL,
    [re_lst_upd_dt] DATETIME NOT NULL,
    [re_changed] CHAR(2) NOT NULL,
    [migrate_yn] CHAR(2) NOT NULL
);

GO
