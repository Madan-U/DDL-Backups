-- Object: TABLE citrus_usr.branch
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[branch]
(
    [br_id] NUMERIC(18, 0) NOT NULL,
    [branch_code] VARCHAR(20) NOT NULL,
    [branch] VARCHAR(80) NULL,
    [long_name] VARCHAR(100) NULL,
    [address1] VARCHAR(100) NULL,
    [address2] VARCHAR(100) NULL,
    [city] VARCHAR(40) NULL,
    [state] VARCHAR(30) NULL,
    [nation] VARCHAR(30) NULL,
    [zip] VARCHAR(30) NULL,
    [phone1] VARCHAR(30) NULL,
    [phone2] VARCHAR(30) NULL,
    [fax] VARCHAR(30) NULL,
    [email] VARCHAR(100) NULL,
    [contact_person] VARCHAR(100) NULL,
    [prefix] VARCHAR(3) NULL,
    [br_created_dt] DATETIME NOT NULL,
    [br_lst_upd_dt] DATETIME NOT NULL,
    [br_changed] CHAR(2) NOT NULL,
    [migrate_yn] CHAR(2) NOT NULL
);

GO
