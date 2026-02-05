-- Object: TABLE citrus_usr.BROKERFILE_DIGISIGN
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[BROKERFILE_DIGISIGN]
(
    [FILE_ID] BIGINT IDENTITY(1,1) NOT NULL,
    [Batch_no] VARCHAR(50) NULL,
    [FILE_NAME] VARCHAR(150) NULL,
    [FILES] VARBINARY(8000) NULL,
    [FILE_PWD] VARCHAR(50) NULL,
    [CREATED_DT] DATETIME NULL,
    [CREATED_BY] VARCHAR(25) NULL,
    [dpm_dpid] VARCHAR(10) NULL
);

GO
