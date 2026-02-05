-- Object: TABLE dbo.StatementRequests_Master
-- Server: 10.253.78.187 | DB: inhouse
--------------------------------------------------

CREATE TABLE [dbo].[StatementRequests_Master]
(
    [ClientCode] VARCHAR(10) NULL,
    [BOID] VARCHAR(16) NULL,
    [Status] VARCHAR(40) NULL,
    [SubType] VARCHAR(40) NULL,
    [Scheme] VARCHAR(21) NULL,
    [Branch] VARCHAR(6) NULL,
    [Name] VARCHAR(100) NULL,
    [Address1] VARCHAR(30) NOT NULL,
    [Address2] VARCHAR(30) NOT NULL,
    [Address3] VARCHAR(30) NOT NULL,
    [Address4] VARCHAR(36) NOT NULL,
    [PAN] VARCHAR(25) NOT NULL,
    [Email] VARCHAR(50) NOT NULL,
    [Phone] VARCHAR(17) NOT NULL,
    [ReportType] VARCHAR(50) NOT NULL,
    [EmailStatus] CHAR(1) NULL DEFAULT 'N',
    [Remark] VARCHAR(800) NULL DEFAULT ''
);

GO
