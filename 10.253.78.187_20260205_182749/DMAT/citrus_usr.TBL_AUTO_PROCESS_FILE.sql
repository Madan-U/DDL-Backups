-- Object: TABLE citrus_usr.TBL_AUTO_PROCESS_FILE
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[TBL_AUTO_PROCESS_FILE]
(
    [SNO] INT IDENTITY(1,1) NOT NULL,
    [FLD_FILENAME] VARCHAR(200) NULL,
    [FLD_FILEDATE] DATETIME NULL,
    [PROCESS_ON] DATETIME NULL
);

GO
