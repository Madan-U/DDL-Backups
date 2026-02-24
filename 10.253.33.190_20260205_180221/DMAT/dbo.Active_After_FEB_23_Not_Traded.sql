-- Object: TABLE dbo.Active_After_FEB_23_Not_Traded
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [dbo].[Active_After_FEB_23_Not_Traded]
(
    [Cl_Code] VARCHAR(10) NOT NULL,
    [Trading_Status] VARCHAR(10) NOT NULL,
    [active_date] DATETIME NULL,
    [inactive_from] DATETIME NULL,
    [BO_Status] VARCHAR(8) NOT NULL
);

GO
