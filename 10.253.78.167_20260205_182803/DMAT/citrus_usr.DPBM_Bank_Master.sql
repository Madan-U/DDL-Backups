-- Object: TABLE citrus_usr.DPBM_Bank_Master
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[DPBM_Bank_Master]
(
    [bk_id] CHAR(2) NULL,
    [bk_micr] VARCHAR(12) NOT NULL,
    [bk_branch] VARCHAR(12) NOT NULL,
    [bk_name] VARCHAR(100) NULL,
    [bk_add1] VARCHAR(30) NULL,
    [bk_add2] VARCHAR(30) NULL,
    [bk_add3] VARCHAR(30) NULL,
    [bk_city] VARCHAR(25) NULL,
    [bk_state] VARCHAR(25) NULL,
    [bk_country] VARCHAR(25) NULL,
    [bk_pin] VARCHAR(10) NULL,
    [bk_tele1] VARCHAR(17) NULL,
    [bk_tele2] VARCHAR(17) NULL,
    [bk_fax] VARCHAR(17) NULL,
    [bk_email] VARCHAR(80) NULL,
    [bk_conname] VARCHAR(100) NULL,
    [bk_condesg] VARCHAR(40) NULL
);

GO
