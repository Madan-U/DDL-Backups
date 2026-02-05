-- Object: TABLE citrus_usr.Standard_value_list
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[Standard_value_list]
(
    [SR] NVARCHAR(50) NOT NULL,
    [Field_Description] NVARCHAR(1000) NOT NULL,
    [ISO_Tags] NVARCHAR(500) NOT NULL,
    [Standard_Value] NVARCHAR(500) NOT NULL,
    [Meaning] NVARCHAR(1000) NOT NULL,
    [Notes_Comments] NVARCHAR(1500) NULL,
    [CDSL_Old_Values] NVARCHAR(500) NULL
);

GO
