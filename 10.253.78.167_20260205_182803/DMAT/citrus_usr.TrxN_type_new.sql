-- Object: TABLE citrus_usr.TrxN_type_new
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[TrxN_type_new]
(
    [TxnsType] NVARCHAR(500) NOT NULL,
    [TxnStatus] NVARCHAR(50) NOT NULL,
    [Trancode] NVARCHAR(500) NOT NULL,
    [HAR_Type] NVARCHAR(500) NOT NULL,
    [HARStatus] NVARCHAR(500) NOT NULL,
    [HARCod] NVARCHAR(500) NOT NULL
);

GO
