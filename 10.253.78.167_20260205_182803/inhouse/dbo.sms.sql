-- Object: TABLE dbo.sms
-- Server: 10.253.78.167 | DB: inhouse
--------------------------------------------------

CREATE TABLE [dbo].[sms]
(
    [to_no] VARCHAR(50) NOT NULL,
    [message] VARCHAR(500) NULL,
    [date] VARCHAR(20) NULL,
    [time] VARCHAR(20) NULL,
    [flag] VARCHAR(2) NULL,
    [ampm] VARCHAR(3) NULL,
    [purpose] VARCHAR(100) NULL
);

GO
