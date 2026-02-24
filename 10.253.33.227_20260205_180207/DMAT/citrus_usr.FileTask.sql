-- Object: TABLE citrus_usr.FileTask
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[FileTask]
(
    [TASK_NAME] VARCHAR(200) NULL,
    [TASK_START_DT] DATETIME NOT NULL,
    [TASK_END_DATE] DATETIME NULL,
    [STATUS] VARCHAR(20) NULL,
    [LOGN_NAME] VARCHAR(20) NOT NULL,
    [TASK_ID] BIGINT NULL,
    [ERRMSG] VARCHAR(500) NULL,
    [usermsg] VARCHAR(8000) NULL,
    [TASK_FILEDATE] DATETIME NULL,
    [uploadfilename] VARCHAR(3000) NULL
);

GO
