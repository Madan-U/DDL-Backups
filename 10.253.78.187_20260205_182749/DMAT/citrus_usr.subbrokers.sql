-- Object: TABLE citrus_usr.subbrokers
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[subbrokers]
(
    [sb_id] NUMERIC(18, 0) NOT NULL,
    [sub_broker] VARCHAR(10) NOT NULL,
    [name] VARCHAR(50) NULL,
    [address1] CHAR(25) NULL,
    [address2] CHAR(25) NULL,
    [city] CHAR(20) NULL,
    [state] CHAR(15) NULL,
    [nation] CHAR(15) NULL,
    [zip] CHAR(10) NULL,
    [fax] CHAR(15) NULL,
    [phone1] CHAR(15) NULL,
    [phone2] CHAR(15) NULL,
    [reg_no] CHAR(30) NULL,
    [registered] BIT NULL,
    [email] CHAR(50) NULL,
    [contact_person] VARCHAR(100) NULL,
    [branch_code] VARCHAR(10) NULL,
    [sb_created_dt] DATETIME NOT NULL,
    [sb_lst_upd_dt] DATETIME NOT NULL,
    [sb_changed] CHAR(2) NOT NULL,
    [migrate_yn] CHAR(2) NOT NULL
);

GO
