-- Object: TABLE dbo.CDSL_Trxn
-- Server: 10.253.78.167 | DB: inhouse
--------------------------------------------------

CREATE TABLE [dbo].[CDSL_Trxn]
(
    [Transaction Type] NVARCHAR(255) NULL,
    [TransType] NVARCHAR(255) NULL,
    [DPId] NVARCHAR(255) NULL,
    [ACNum] NVARCHAR(255) NULL,
    [PAN] NVARCHAR(255) NULL,
    [ISIN] NVARCHAR(255) NULL,
    [CoName] NVARCHAR(255) NULL,
    [Series] NVARCHAR(255) NULL,
    [Date] DATETIME NULL,
    [DCInd] NVARCHAR(255) NULL,
    [Qty] MONEY NULL,
    [RefNum] INT NULL,
    [Rate] MONEY NULL,
    [Amt] MONEY NULL,
    [ScripID] FLOAT NULL,
    [ClntName] NVARCHAR(255) NULL,
    [CntrBOAcc] NVARCHAR(255) NULL,
    [CntrName] NVARCHAR(255) NULL,
    [CntrDPId] NVARCHAR(255) NULL,
    [CntrDPName] NVARCHAR(255) NULL,
    [SlipNo] NVARCHAR(255) NULL,
    [LastTransDt] DATETIME NULL,
    [Remark] NVARCHAR(255) NULL,
    [ScripCat] NVARCHAR(255) NULL
);

GO
