-- Object: TABLE dbo.TBL_GLOPBL
-- Server: 10.253.33.227 | DB: inhouse
--------------------------------------------------

CREATE TABLE [dbo].[TBL_GLOPBL]
(
    [GL_CODE] VARCHAR(10) NOT NULL,
    [GL_NAME] VARCHAR(60) NULL,
    [GROUP_CODE] VARCHAR(10) NULL,
    [ACC_TYPE] VARCHAR(10) NULL,
    [OPEN_BAL] VARCHAR(40) NULL,
    [SL_TAG] VARCHAR(1) NULL,
    [BANK_ACC_NO] VARCHAR(20) NULL
);

GO
