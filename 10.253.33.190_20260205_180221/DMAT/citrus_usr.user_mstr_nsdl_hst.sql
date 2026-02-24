-- Object: TABLE citrus_usr.user_mstr_nsdl_hst
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[user_mstr_nsdl_hst]
(
    [um_user_id] CHAR(8) NULL,
    [um_passwd] CHAR(8) NULL,
    [um_group_id] CHAR(8) NULL,
    [um_user_name] VARCHAR(35) NULL,
    [um_add1] VARCHAR(35) NULL,
    [um_add2] VARCHAR(35) NULL,
    [um_add3] VARCHAR(35) NULL,
    [um_add4] VARCHAR(35) NULL,
    [um_pin] CHAR(7) NULL,
    [um_designation] VARCHAR(35) NULL,
    [um_dept] VARCHAR(25) NULL,
    [um_lastlogin] CHAR(8) NULL,
    [um_loginflag] CHAR(1) NULL,
    [um_valid_from] CHAR(8) NULL,
    [um_valid_to] CHAR(8) NULL,
    [um_status] CHAR(1) NULL,
    [mkrid] CHAR(8) NULL,
    [mkrdt] CHAR(8) NULL,
    [um_computername] VARCHAR(30) NULL,
    [um_brcode] VARCHAR(200) NULL,
    [um_email] VARCHAR(75) NULL,
    [um_special] CHAR(1) NULL,
    [um_logstat] CHAR(1) NULL,
    [um_resetpwddays] INT NULL,
    [um_lastresetday] CHAR(8) NULL,
    [um_Locked] CHAR(1) NULL,
    [um_loginaccessgroup] VARCHAR(8) NULL,
    [um_poaforpayin] CHAR(1) NULL,
    [um_edittype] CHAR(1) NULL,
    [um_cmpltd] NUMERIC(18, 0) NULL
);

GO
