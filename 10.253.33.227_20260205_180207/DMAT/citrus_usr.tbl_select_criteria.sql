-- Object: TABLE citrus_usr.tbl_select_criteria
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[tbl_select_criteria]
(
    [id] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [select_desc] VARCHAR(1000) NULL,
    [ord_by] NUMERIC(10, 0) NULL,
    [formula] VARCHAR(3000) NULL,
    [dps8_formula] VARCHAR(8000) NULL
);

GO
