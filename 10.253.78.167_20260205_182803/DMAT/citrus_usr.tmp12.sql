-- Object: TABLE citrus_usr.tmp12
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[tmp12]
(
    [logn_pswd] VARCHAR(8000) NULL,
    [logn_ent_id] NUMERIC(10, 0) NOT NULL,
    [enttm_cd] VARCHAR(20) NOT NULL,
    [logn_short_name] VARCHAR(50) NOT NULL,
    [entro_rol_id] NUMERIC(10, 0) NOT NULL,
    [logn_from_dt] DATETIME NOT NULL,
    [logn_to_dt] DATETIME NOT NULL,
    [logn_total_att] NUMERIC(10, 0) NOT NULL,
    [logn_no_of_att] NUMERIC(10, 0) NOT NULL,
    [logn_status] CHAR(1) NOT NULL,
    [logn_menu_pref] CHAR(1) NOT NULL,
    [logn_usr_ip] VARCHAR(100) NOT NULL,
    [curr_dt] DATETIME NOT NULL,
    [logn_sbum_id] NUMERIC(10, 0) NULL,
    [logn_usr_email] VARCHAR(50) NOT NULL,
    [vno] VARCHAR(3) NOT NULL
);

GO
