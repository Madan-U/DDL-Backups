-- Object: TABLE citrus_usr.client_brok_details
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[client_brok_details]
(
    [cl_code] VARCHAR(10) NOT NULL,
    [exchange] VARCHAR(10) NOT NULL,
    [segment] VARCHAR(10) NOT NULL,
    [profile_id] VARCHAR(20) NULL,
    [clibd_created_dt] DATETIME NOT NULL,
    [clibd_lst_upd_dt] DATETIME NOT NULL,
    [clibd_changed] CHAR(2) NOT NULL,
    [migrate_yn] INT NOT NULL,
    [status_flag] VARCHAR(20) NULL
);

GO
