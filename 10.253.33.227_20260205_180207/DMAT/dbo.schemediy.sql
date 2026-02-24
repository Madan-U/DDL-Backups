-- Object: TABLE dbo.schemediy
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [dbo].[schemediy]
(
    [pam_sba_no] NVARCHAR(255) NULL,
    [tradingid] NVARCHAR(255) NULL,
    [brom_desc] NVARCHAR(255) NULL,
    [charge_name] NVARCHAR(255) NULL,
    [amt] FLOAT NULL,
    [SGST] FLOAT NULL,
    [CGST] FLOAT NULL,
    [IGST] FLOAT NULL,
    [UGST] FLOAT NULL,
    [cdslcharge] FLOAT NULL,
    [activationdt] DATETIME NULL,
    [state] NVARCHAR(255) NULL
);

GO
