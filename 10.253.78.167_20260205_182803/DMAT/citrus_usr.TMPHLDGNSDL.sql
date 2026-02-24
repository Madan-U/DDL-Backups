-- Object: TABLE citrus_usr.TMPHLDGNSDL
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[TMPHLDGNSDL]
(
    [DPAM_ID] INT NULL,
    [AcctName] VARCHAR(150) NULL,
    [AcctNo] VARCHAR(8) NULL,
    [BEN_TYPE] VARCHAR(117) NULL,
    [ISINCD] VARCHAR(12) NULL,
    [isin_name] VARCHAR(8000) NULL,
    [Qty] NUMERIC(18, 3) NULL,
    [Valuation] NUMERIC(18, 3) NULL,
    [LockFlg] VARCHAR(5) NOT NULL,
    [holding_dt] VARCHAR(11) NULL,
    [cmp] NUMERIC(18, 4) NOT NULL,
    [DPDHM_BENF_ACCT_TYP] VARCHAR(50) NULL
);

GO
