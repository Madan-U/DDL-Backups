-- Object: TABLE dbo.nominee_infomine_19062023
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [dbo].[nominee_infomine_19062023]
(
    [client_code] VARCHAR(50) NULL,
    [nominee_name] VARCHAR(150) NULL,
    [nominee_dob] VARCHAR(100) NULL,
    [nominee_relation] VARCHAR(100) NULL,
    [nominee_pan] VARCHAR(20) NULL,
    [nominee_share] MONEY NULL,
    [added_on] VARCHAR(30) NULL,
    [PdfPath] VARCHAR(542) NULL,
    [application_no] VARCHAR(100) NULL,
    [FIRST_HOLD_PAN] VARCHAR(25) NULL,
    [BO_DOB] VARCHAR(11) NULL,
    [DPID] VARCHAR(16) NULL,
    [STATUS] VARCHAR(40) NULL,
    [Nominee] VARCHAR(3) NOT NULL
);

GO
