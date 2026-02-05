-- Object: TABLE dbo.sb_trxn
-- Server: 10.253.33.190 | DB: inhouse
--------------------------------------------------

CREATE TABLE [dbo].[sb_trxn]
(
    [trxn_date] DATETIME NULL,
    [dis_number] VARCHAR(20) NULL,
    [sb_dpid] VARCHAR(20) NULL,
    [sbtag] VARCHAR(20) NULL,
    [sb name] VARCHAR(200) NULL,
    [sb_contact] VARCHAR(20) NULL,
    [client_contact] VARCHAR(40) NULL,
    [status] VARCHAR(150) NULL,
    [comments] VARCHAR(250) NULL,
    [Transaction_id] VARCHAR(20) NULL,
    [client_dpid] VARCHAR(20) NULL,
    [isin] VARCHAR(20) NULL,
    [qty] MONEY NULL,
    [Branch] VARCHAR(50) NULL,
    [Region] VARCHAR(20) NULL,
    [CreatedBy] VARCHAR(50) NULL,
    [CreatedOn] DATETIME NULL
);

GO
