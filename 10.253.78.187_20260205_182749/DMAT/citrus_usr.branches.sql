-- Object: TABLE citrus_usr.branches
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[branches]
(
    [dl_id] NUMERIC(18, 0) NOT NULL,
    [branch_cd] VARCHAR(50) NOT NULL,
    [short_name] VARCHAR(20) NOT NULL,
    [long_name] VARCHAR(50) NULL,
    [address1] VARCHAR(25) NULL,
    [address2] VARCHAR(25) NULL,
    [city] VARCHAR(20) NULL,
    [state] CHAR(15) NULL,
    [nation] CHAR(15) NULL,
    [zip] CHAR(15) NULL,
    [phone1] CHAR(15) NULL,
    [phone2] CHAR(15) NULL,
    [fax] CHAR(15) NULL,
    [email] CHAR(50) NULL,
    [contact_person] CHAR(25) NULL,
    [terminal_id] VARCHAR(10) NULL,
    [dl_created_dt] DATETIME NOT NULL,
    [dl_lst_upd_dt] DATETIME NOT NULL,
    [dl_changed] CHAR(2) NOT NULL,
    [migrate_yn] CHAR(2) NOT NULL
);

GO
