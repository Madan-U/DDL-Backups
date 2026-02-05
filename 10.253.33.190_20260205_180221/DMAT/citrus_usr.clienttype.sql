-- Object: TABLE citrus_usr.clienttype
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[clienttype]
(
    [enttm_id] NUMERIC(18, 0) NOT NULL,
    [cl_type] CHAR(3) NOT NULL,
    [description] VARCHAR(25) NULL,
    [group_code] VARCHAR(10) NULL,
    [prefix] VARCHAR(3) NULL,
    [ct_created_dt] DATETIME NOT NULL,
    [ct_lst_upd_dt] DATETIME NOT NULL,
    [ct_changed] CHAR(2) NOT NULL,
    [migrate_yn] CHAR(2) NOT NULL
);

GO
