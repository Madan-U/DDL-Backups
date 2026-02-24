-- Object: TABLE citrus_usr.area_hst
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[area_hst]
(
    [ar_id] NUMERIC(18, 0) NOT NULL,
    [areacode] VARCHAR(25) NULL,
    [description] VARCHAR(50) NULL,
    [branch_code] VARCHAR(10) NULL,
    [ar_created_dt] DATETIME NOT NULL,
    [ar_lst_upd_dt] DATETIME NOT NULL,
    [ar_changed] CHAR(2) NOT NULL,
    [migrate_yn] CHAR(2) NOT NULL
);

GO
