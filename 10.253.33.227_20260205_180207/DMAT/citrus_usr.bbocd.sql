-- Object: TABLE citrus_usr.bbocd
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[bbocd]
(
    [id] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [dpam_id] NUMERIC(10, 0) NOT NULL,
    [dpam_sba_no] VARCHAR(20) NOT NULL,
    [acct_type] VARCHAR(1) NOT NULL,
    [propcd] VARCHAR(8) NOT NULL,
    [propid] VARCHAR(2) NOT NULL,
    [DPAM_BBO_CODE] VARCHAR(20) NULL,
    [cb] VARCHAR(3) NOT NULL,
    [cd] DATETIME NOT NULL,
    [lb] VARCHAR(3) NOT NULL,
    [ld] DATETIME NOT NULL,
    [delind] INT NOT NULL
);

GO
