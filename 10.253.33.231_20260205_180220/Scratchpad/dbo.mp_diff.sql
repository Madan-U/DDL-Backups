-- Object: TABLE dbo.mp_diff
-- Server: 10.253.33.231 | DB: Scratchpad
--------------------------------------------------

CREATE TABLE [dbo].[mp_diff]
(
    [party_code] VARCHAR(10) NOT NULL,
    [cltdpid] VARCHAR(16) NULL,
    [certno] VARCHAR(16) NULL,
    [tcode] NUMERIC(18, 0) NOT NULL,
    [qty] NUMERIC(38, 0) NULL,
    [td_ac_code] VARCHAR(16) NULL,
    [TD_REFERENCE] VARCHAR(50) NULL,
    [TD_ISIN_CODE] VARCHAR(20) NULL,
    [TDQTY] NUMERIC(38, 5) NULL,
    [diff_qty] NUMERIC(18, 2) NULL,
    [hold_qty] NUMERIC(18, 2) NULL,
    [bo_hold_qty] NUMERIC(18, 2) NULL,
    [Hold_diff] NUMERIC(18, 2) NULL,
    [upd_qty] NUMERIC(18, 2) NULL
);

GO
