-- Object: TABLE citrus_usr.DIY_Reprocess_log_e_dis_MF
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[DIY_Reprocess_log_e_dis_MF]
(
    [sett_no] VARCHAR(11) NULL,
    [sett_type] VARCHAR(2) NULL,
    [PARTY_CODE] VARCHAR(15) NULL,
    [SCRIP_CD] VARCHAR(20) NULL,
    [SERIES] VARCHAR(10) NULL,
    [SELLtradeqty] INT NULL,
    [sellRECQTY] INT NULL,
    [Sell_shortage] FLOAT NULL,
    [DP_ID] VARCHAR(20) NULL,
    [ISIN] VARCHAR(15) NULL,
    [PROCESS_DATE] DATETIME NULL,
    [PROCESS_FLAG] VARCHAR(15) NULL,
    [POA_FLAG] VARCHAR(15) NULL,
    [DP_HOLDING] FLOAT NULL,
    [DP_CONCERN] VARCHAR(1) NULL,
    [NO_CNT] INT NULL,
    [ADJ_QTY] FLOAT NULL,
    [Tranasction_id] INT NULL
);

GO
