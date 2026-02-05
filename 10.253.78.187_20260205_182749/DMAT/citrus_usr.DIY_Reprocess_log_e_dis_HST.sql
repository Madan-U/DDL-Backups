-- Object: TABLE citrus_usr.DIY_Reprocess_log_e_dis_HST
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[DIY_Reprocess_log_e_dis_HST]
(
    [sett_no] VARCHAR(11) NULL,
    [sett_type] VARCHAR(2) NULL,
    [PARTY_CODE] VARCHAR(15) NULL,
    [SCRIP_CD] VARCHAR(15) NULL,
    [SERIES] VARCHAR(10) NULL,
    [SELLtradeqty] INT NULL,
    [sellRECQTY] INT NULL,
    [Sell_shortage] INT NULL,
    [DP_ID] VARCHAR(20) NULL,
    [ISIN] VARCHAR(15) NULL,
    [PROCESS_DATE] DATETIME NULL,
    [PROCESS_FLAG] VARCHAR(15) NULL,
    [POA_FLAG] VARCHAR(15) NULL,
    [DP_HOLDING] INT NULL,
    [DP_CONCERN] VARCHAR(1) NULL,
    [NO_CNT] INT NULL,
    [ADJ_QTY] INT NULL
);

GO
