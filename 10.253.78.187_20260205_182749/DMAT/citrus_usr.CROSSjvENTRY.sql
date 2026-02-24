-- Object: TABLE citrus_usr.CROSSjvENTRY
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[CROSSjvENTRY]
(
    [ID] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [dpam_dpm_id] NUMERIC(10, 0) NULL,
    [vtype] VARCHAR(1) NOT NULL,
    [booktypecd] VARCHAR(2) NOT NULL,
    [vno] NUMERIC(18, 0) NULL,
    [ld_entryno] NUMERIC(18, 0) NOT NULL,
    [ldgrefno] VARCHAR(6) NOT NULL,
    [vdate] DATETIME NULL,
    [dpam_id] NUMERIC(10, 0) NOT NULL,
    [actype] VARCHAR(1) NOT NULL,
    [amount] MONEY NULL,
    [ld_particular] VARCHAR(200) NULL,
    [bankid] INT NULL,
    [acno] INT NULL,
    [ld_chequeno] VARCHAR(8) NULL,
    [cldate] INT NULL,
    [cost] INT NULL,
    [bill] INT NULL,
    [trn] VARCHAR(1) NOT NULL,
    [status] VARCHAR(1) NOT NULL,
    [cb] VARCHAR(3) NOT NULL,
    [cd] DATETIME NOT NULL,
    [lb] VARCHAR(3) NOT NULL,
    [ld] DATETIME NOT NULL,
    [delind] INT NOT NULL,
    [branch] INT NOT NULL
);

GO
