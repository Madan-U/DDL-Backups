-- Object: TABLE citrus_usr.bank_hst
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[bank_hst]
(
    [dpm_id] NUMERIC(18, 0) NOT NULL,
    [bankid] VARCHAR(16) NULL,
    [bankname] VARCHAR(60) NULL,
    [address1] VARCHAR(60) NULL,
    [address2] VARCHAR(60) NULL,
    [city] VARCHAR(40) NULL,
    [pincode] VARCHAR(20) NULL,
    [phone1] VARCHAR(20) NULL,
    [phone2] VARCHAR(20) NULL,
    [phone3] VARCHAR(20) NULL,
    [phone4] VARCHAR(20) NULL,
    [fax1] VARCHAR(40) NULL,
    [fax2] VARCHAR(20) NULL,
    [email] VARCHAR(50) NULL,
    [banktype] VARCHAR(5) NULL,
    [dpm_created_dt] DATETIME NOT NULL,
    [dpm_lst_upd_dt] DATETIME NOT NULL,
    [dpm_changed] CHAR(2) NOT NULL,
    [migrate_yn] CHAR(2) NOT NULL
);

GO
