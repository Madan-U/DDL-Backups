-- Object: TABLE dbo.Student_Mstr
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [dbo].[Student_Mstr]
(
    [Stud_Id] INT IDENTITY(1,1) NOT NULL,
    [Stud_FirstName] VARCHAR(50) NULL,
    [Stud_MiddelName] VARCHAR(50) NULL,
    [Stud_LastName] VARCHAR(50) NULL,
    [Stud_Permanant_Add] VARCHAR(500) NULL,
    [Stud_Temp_Add] VARCHAR(500) NULL,
    [Stud_Prev_Clg] INT NULL,
    [Stud_Current_Clg] INT NULL,
    [Stud_Mobile] INT NULL,
    [Stud_Cast] VARCHAR(100) NULL,
    [Stud_Created_Date] DATETIME NULL,
    [Stud_Update_Date] DATETIME NULL
);

GO
