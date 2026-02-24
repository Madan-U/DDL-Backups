-- Object: TABLE citrus_usr.tblStudents
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[tblStudents]
(
    [StudentID] INT IDENTITY(1,1) NOT NULL,
    [StudentName] VARCHAR(100) NULL,
    [CollegeName] VARCHAR(100) NULL,
    [JoinedOn] DATETIME NULL
);

GO
