-- Object: TABLE dbo.HOLD301223
-- Server: 10.253.33.231 | DB: inhouse
--------------------------------------------------

CREATE TABLE [dbo].[HOLD301223]
(
    [DPAM_SBA_NO] VARCHAR(20) NOT NULL,
    [DPAM_BBO_CODE] VARCHAR(20) NULL,
    [DPHMC_ISIN] VARCHAR(20) NOT NULL,
    [DPHMC_CURR_QTY] NUMERIC(18, 3) NULL,
    [close_price] MONEY NULL,
    [total_amt] MONEY NULL
);

GO
