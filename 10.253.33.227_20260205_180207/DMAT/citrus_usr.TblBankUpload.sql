-- Object: TABLE citrus_usr.TblBankUpload
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[TblBankUpload]
(
    [TxnSrlNo] VARCHAR(50) NULL,
    [TranID] VARCHAR(50) NULL,
    [TxnDate] CHAR(11) NULL,
    [CheckNo] VARCHAR(50) NULL,
    [Descripton] VARCHAR(100) NULL,
    [CrDr] VARCHAR(50) NULL,
    [Amount] VARCHAR(50) NULL,
    [Balance] VARCHAR(50) NULL,
    [OrgAmt] VARCHAR(50) NULL,
    [OrgCur] VARCHAR(50) NULL,
    [ConvRate] VARCHAR(50) NULL,
    [Category] VARCHAR(50) NULL,
    [PstDate] CHAR(11) NULL,
    [ValueDate] CHAR(11) NULL
);

GO
