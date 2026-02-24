-- Object: TABLE citrus_usr.multibankid_hst
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[multibankid_hst]
(
    [Accno] VARCHAR(16) NOT NULL,
    [Acctype] VARCHAR(7) NOT NULL,
    [Chequename] VARCHAR(100) NOT NULL,
    [Defaultbank] CHAR(1) NOT NULL,
    [banm_name] VARCHAR(50) NOT NULL,
    [banm_branch] VARCHAR(40) NOT NULL,
    [cltcd] VARCHAR(25) NOT NULL,
    [cliba_created_dt] DATETIME NOT NULL,
    [cliba_lst_upd_dt] DATETIME NOT NULL,
    [cliba_changed] CHAR(2) NOT NULL,
    [migrate_yn] INT NOT NULL
);

GO
