-- Object: TABLE citrus_usr.clientstatus
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[clientstatus]
(
    [cls_id] NUMERIC(18, 0) NOT NULL,
    [cl_status] VARCHAR(20) NOT NULL,
    [description] VARCHAR(200) NULL,
    [cl_created_dt] DATETIME NOT NULL,
    [cl_lst_upd_dt] DATETIME NOT NULL,
    [cl_changed] CHAR(2) NOT NULL,
    [migrate_yn] CHAR(2) NOT NULL
);

GO
