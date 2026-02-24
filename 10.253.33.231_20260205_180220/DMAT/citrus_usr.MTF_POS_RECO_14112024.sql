-- Object: TABLE citrus_usr.MTF_POS_RECO_14112024
-- Server: 10.253.33.231 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[MTF_POS_RECO_14112024]
(
    [party_code] VARCHAR(10) NOT NULL,
    [dpid] VARCHAR(10) NULL,
    [cltid] VARCHAR(20) NULL,
    [scrip_cd] VARCHAR(12) NOT NULL,
    [series] VARCHAR(3) NOT NULL,
    [isin] VARCHAR(12) NULL,
    [mtf_pos] INT NULL,
    [Cuspa_qty] NUMERIC(38, 0) NULL,
    [MTF_Pledge] NUMERIC(38, 0) NULL,
    [dp_free] NUMERIC(18, 5) NULL
);

GO
