-- Object: TABLE citrus_usr.tblError_SQL
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[tblError_SQL]
(
    [sRefNo] NUMERIC(7, 0) IDENTITY(1,1) NOT NULL,
    [sServer] VARCHAR(15) NULL,
    [sModule] VARCHAR(50) NULL,
    [sTable] VARCHAR(100) NULL,
    [sSP] VARCHAR(100) NULL,
    [sLineNo] VARCHAR(10) NULL,
    [sRemarks] VARCHAR(100) NULL,
    [sLoginID] VARCHAR(50) NULL,
    [sDateTime] DATETIME NULL DEFAULT (getdate()),
    [sErrNo] VARCHAR(20) NULL,
    [sErrDescription] VARCHAR(1000) NULL,
    [sEmailSent] DATETIME NULL
);

GO
