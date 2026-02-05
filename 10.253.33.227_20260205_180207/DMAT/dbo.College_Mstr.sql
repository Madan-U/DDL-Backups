-- Object: TABLE dbo.College_Mstr
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [dbo].[College_Mstr]
(
    [Cllg_Id] INT IDENTITY(1,1) NOT NULL,
    [Clg_Name] VARCHAR(200) NULL,
    [Clg_Address] VARCHAR(500) NULL,
    [Clg_Grade] VARCHAR(10) NULL,
    [Clg_Phone] VARCHAR(15) NULL,
    [Clg_Created_Date] DATETIME NULL,
    [Clg_Updated_Date] DATETIME NULL
);

GO
