-- Object: TABLE citrus_usr.tbl_filter_criteria
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[tbl_filter_criteria]
(
    [id] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [filter_desc] VARCHAR(1000) NULL,
    [formula] VARCHAR(3000) NULL
);

GO
