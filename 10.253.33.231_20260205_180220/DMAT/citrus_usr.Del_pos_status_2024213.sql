-- Object: TABLE citrus_usr.Del_pos_status_2024213
-- Server: 10.253.33.231 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[Del_pos_status_2024213]
(
    [Sett_no] VARCHAR(7) NOT NULL,
    [Sett_Type] VARCHAR(2) NOT NULL,
    [scrip_cd] VARCHAR(12) NOT NULL,
    [series] VARCHAR(3) NOT NULL,
    [Party_code] VARCHAR(10) NOT NULL,
    [Qty] INT NOT NULL,
    [Inout] VARCHAR(2) NOT NULL,
    [Branch_Cd] VARCHAR(10) NULL,
    [PartipantCode] VARCHAR(10) NULL,
    [I_ISIN] VARCHAR(12) NULL,
    [pos_recd] NUMERIC(18, 4) NULL,
    [cuspa_qty] NUMERIC(18, 4) NULL,
    [mtf_qty] NUMERIC(18, 4) NULL,
    [DP_Free_qty] NUMERIC(18, 4) NULL,
    [Shortage_214] NUMERIC(18, 4) NULL,
    [Pos_recd_12] NUMERIC(18, 4) NULL,
    [POOL_QTY] NUMERIC(18, 4) NULL,
    [cl_rate] MONEY NULL
);

GO
