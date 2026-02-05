-- Object: TABLE dbo.tbl_DPChargesAMCDataCurrentYear_94
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [dbo].[tbl_DPChargesAMCDataCurrentYear_94]
(
    [sDate] DATETIME NULL,
    [dpam_sba_no] VARCHAR(MAX) NULL,
    [tradingid] VARCHAR(50) NULL,
    [brom_desc] VARCHAR(MAX) NULL,
    [charge_name] VARCHAR(MAX) NULL,
    [amt] DECIMAL(18, 5) NULL,
    [SGST] DECIMAL(18, 5) NULL,
    [CGST] DECIMAL(18, 5) NULL,
    [IGST] DECIMAL(18, 5) NULL,
    [UGST] DECIMAL(18, 5) NULL,
    [cdslcharge] DECIMAL(18, 5) NULL,
    [activationdt] VARCHAR(50) NULL,
    [state] VARCHAR(50) NULL,
    [Duration_Type] VARCHAR(10) NULL
);

GO
