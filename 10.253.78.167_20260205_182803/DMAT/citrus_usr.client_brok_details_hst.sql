-- Object: TABLE citrus_usr.client_brok_details_hst
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[client_brok_details_hst]
(
    [cl_code] VARCHAR(10) NOT NULL,
    [exchange] VARCHAR(10) NOT NULL,
    [segment] VARCHAR(10) NOT NULL,
    [profile_id] VARCHAR(20) NULL,
    [clibd_created_dt] DATETIME NOT NULL,
    [clibd_lst_upd_dt] DATETIME NOT NULL,
    [clibd_changed] CHAR(2) NOT NULL,
    [migrate_yn] INT NOT NULL
);

GO
