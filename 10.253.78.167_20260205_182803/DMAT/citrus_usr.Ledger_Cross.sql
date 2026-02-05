-- Object: TABLE citrus_usr.Ledger_Cross
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[Ledger_Cross]
(
    [ld_clientcd] CHAR(16) NOT NULL,
    [ld_dt] CHAR(8) NULL,
    [ld_amount] MONEY NOT NULL,
    [ld_particular] VARCHAR(200) NULL,
    [ld_chequeno] VARCHAR(8) NULL,
    [ld_debitflag] CHAR(1) NOT NULL,
    [ld_documenttype] CHAR(1) NOT NULL,
    [ld_documentno] VARCHAR(12) NOT NULL,
    [ld_entryno] NUMERIC(18, 0) NOT NULL,
    [ld_costcenter] CHAR(3) NULL,
    [mkrid] CHAR(8) NULL,
    [mkrdt] CHAR(8) NULL,
    [ld_accyear] CHAR(8) NOT NULL,
    [ld_dpid] CHAR(8) NOT NULL,
    [ld_commondt] CHAR(8) NULL,
    [ld_common] VARCHAR(35) NULL
);

GO
