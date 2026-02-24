-- Object: TABLE citrus_usr.V2_Table_Structures
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[V2_Table_Structures]
(
    [Table_Name] NVARCHAR(776) NOT NULL,
    [Column_name] NVARCHAR(128) NOT NULL,
    [Type] NVARCHAR(128) NULL,
    [Computed] VARCHAR(35) NULL,
    [Length] INT NULL,
    [Prec] CHAR(5) NULL,
    [Scale] CHAR(5) NULL,
    [Nullable] VARCHAR(35) NULL
);

GO
