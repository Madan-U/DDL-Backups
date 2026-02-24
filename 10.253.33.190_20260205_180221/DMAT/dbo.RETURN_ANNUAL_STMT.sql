-- Object: TABLE dbo.RETURN_ANNUAL_STMT
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [dbo].[RETURN_ANNUAL_STMT]
(
    [CLIENT_CODE] NVARCHAR(255) NULL,
    [TRAN_DATE] VARCHAR(10) NOT NULL,
    [NO_TRANS] VARCHAR(15) NOT NULL,
    [NO_Hold] VARCHAR(10) NOT NULL,
    [fin_year] NVARCHAR(255) NULL
);

GO
