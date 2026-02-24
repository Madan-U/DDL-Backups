-- Object: TABLE citrus_usr.pobank_hst
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[pobank_hst]
(
    [banm_id] NUMERIC(18, 0) NOT NULL,
    [bank_name] VARCHAR(50) NOT NULL,
    [branch_name] VARCHAR(40) NULL,
    [address1] VARCHAR(50) NULL,
    [address2] VARCHAR(50) NULL,
    [city] VARCHAR(25) NULL,
    [state] VARCHAR(25) NULL,
    [nation] VARCHAR(25) NULL,
    [zip] VARCHAR(15) NULL,
    [phone1] VARCHAR(15) NULL,
    [phone2] VARCHAR(15) NULL,
    [fax] VARCHAR(15) NULL,
    [email] VARCHAR(50) NULL,
    [pob_created_dt] DATETIME NOT NULL,
    [pob_lst_upd_dt] DATETIME NOT NULL,
    [pob_changed] CHAR(2) NOT NULL,
    [migrate_yn] CHAR(2) NOT NULL
);

GO
