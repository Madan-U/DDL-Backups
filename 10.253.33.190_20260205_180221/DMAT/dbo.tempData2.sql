-- Object: TABLE dbo.tempData2
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [dbo].[tempData2]
(
    [cl_code] VARCHAR(10) NOT NULL,
    [active_date] DATETIME NULL,
    [InActive_From] DATETIME NULL,
    [exchange] VARCHAR(3) NOT NULL,
    [segment] VARCHAR(7) NOT NULL,
    [pan_gir_no] VARCHAR(50) NULL,
    [email] VARCHAR(50) NULL,
    [mobile_pager] VARCHAR(40) NULL,
    [Rank] BIGINT NULL
);

GO
