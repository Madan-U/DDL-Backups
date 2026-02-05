-- Object: TABLE dbo.mtfBOok_new
-- Server: 10.253.33.231 | DB: Scratchpad
--------------------------------------------------

CREATE TABLE [dbo].[mtfBOok_new]
(
    [party_code] VARCHAR(10) NOT NULL,
    [scrip_cd] VARCHAR(12) NULL,
    [isin] VARCHAR(12) NULL,
    [series] VARCHAR(3) NULL,
    [MTF_Book] INT NULL,
    [Pledge] INT NULL,
    [Cuspa] INT NULL,
    [MTF_Closure] INT NULL,
    [tday_sell] INT NULL,
    [dp_free] INT NULL,
    [excess_payin] INT NULL,
    [net_mtf] INT NULL,
    [diff_qty] INT NULL,
    [cuspa_release] INT NULL,
    [mtf_file_qty] INT NULL
);

GO
