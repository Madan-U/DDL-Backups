-- Object: TABLE citrus_usr.holdingdddd
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[holdingdddd]
(
    [hld_hold_date] VARCHAR(8) NULL,
    [hld_ac_code] VARCHAR(20) NOT NULL,
    [hld_cat] VARCHAR(1) NOT NULL,
    [hld_isin_code] VARCHAR(20) NULL,
    [hld_ac_type] VARCHAR(1) NOT NULL,
    [FREE_QTY] NUMERIC(18, 5) NULL,
    [FREEZE_QTY] NUMERIC(18, 5) NULL,
    [PLEDGE_QTY] NUMERIC(18, 5) NULL,
    [DEMAT_PND_VER_QTY] NUMERIC(18, 5) NULL,
    [REMAT_PND_CONF_QTY] NUMERIC(18, 5) NULL,
    [DEMAT_PND_CONF_QTY] NUMERIC(18, 5) NULL,
    [SAFE_KEEPING_QTY] NUMERIC(18, 5) NULL,
    [LOCKIN_QTY] NUMERIC(18, 5) NULL,
    [ELIMINATION_QTY] NUMERIC(18, 5) NULL,
    [EARMARK_QTY] NUMERIC(18, 5) NULL,
    [AVAIL_LEND_QTY] NUMERIC(18, 5) NULL,
    [LEND_QTY] NUMERIC(18, 5) NULL,
    [BORROW_QTY] NUMERIC(18, 5) NULL,
    [netqty] NUMERIC(30, 5) NULL,
    [hld_ccid] VARCHAR(1) NOT NULL,
    [hld_market_type] VARCHAR(1) NOT NULL,
    [hld_settlement] VARCHAR(1) NOT NULL,
    [hld_blf] VARCHAR(1) NOT NULL,
    [hld_blc] VARCHAR(1) NOT NULL,
    [hld_lrd] VARCHAR(1) NOT NULL,
    [hld_pendingdt] VARCHAR(1) NOT NULL,
    [SecurityName] VARCHAR(282) NULL,
    [SecurityType] VARCHAR(250) NOT NULL,
    [Rate] NUMERIC(18, 4) NOT NULL,
    [Valuation] NUMERIC(38, 6) NULL,
    [HOLDINGDT] DATETIME NULL,
    [tradingid] VARCHAR(50) NULL
);

GO
