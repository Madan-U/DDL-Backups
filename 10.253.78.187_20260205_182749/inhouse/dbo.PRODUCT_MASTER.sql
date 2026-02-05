-- Object: TABLE dbo.PRODUCT_MASTER
-- Server: 10.253.78.187 | DB: inhouse
--------------------------------------------------

CREATE TABLE [dbo].[PRODUCT_MASTER]
(
    [FIELD_CODE] VARCHAR(5) NULL,
    [BO_HELP_VALUE] VARCHAR(40) NULL,
    [BO_HELP_DESC] VARCHAR(50) NULL,
    [BO_TYPE_CODE] NUMERIC(10, 0) NULL,
    [BO_TYPE] NUMERIC(5, 0) NULL,
    [FLAG] CHAR(1) NULL
);

GO
