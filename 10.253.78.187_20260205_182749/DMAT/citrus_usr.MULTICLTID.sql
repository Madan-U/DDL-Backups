-- Object: TABLE citrus_usr.MULTICLTID
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[MULTICLTID]
(
    [Party_Code] VARCHAR(10) NOT NULL,
    [Cltdpno] VARCHAR(16) NOT NULL,
    [Dpid] VARCHAR(16) NOT NULL,
    [Introducer] VARCHAR(100) NULL,
    [Dptype] VARCHAR(4) NULL,
    [poatype] VARCHAR(4) NULL,
    [Def] INT NULL,
    [clidpa_created_dt] DATETIME NOT NULL,
    [clidpa_lst_upd_dt] DATETIME NOT NULL,
    [clidpa_changed] CHAR(2) NOT NULL,
    [migrate_yn] INT NOT NULL
);

GO
