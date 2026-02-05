-- Object: TABLE citrus_usr.tmp_clientwise_holval
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[tmp_clientwise_holval]
(
    [CLIENT_ID] VARCHAR(20) NOT NULL,
    [ISIN] VARCHAR(20) NOT NULL,
    [QTY] VARCHAR(8000) NULL,
    [ISIN_NAME] VARCHAR(282) NULL,
    [dptdc_trans_no] VARCHAR(1) NOT NULL,
    [status] VARCHAR(1) NOT NULL,
    [ISIN NAME] VARCHAR(282) NULL,
    [qtydesc] VARCHAR(1) NOT NULL,
    [dptdc_id] VARCHAR(1) NOT NULL,
    [dptdc_qty] VARCHAR(8000) NULL,
    [dptdc_isin] VARCHAR(20) NOT NULL,
    [valuation] MONEY NULL
);

GO
