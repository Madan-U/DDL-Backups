-- Object: TABLE dbo.tbl_pledgedata_holding
-- Server: 10.253.33.231 | DB: DMAT
--------------------------------------------------

CREATE TABLE [dbo].[tbl_pledgedata_holding]
(
    [party_code] VARCHAR(100) NULL,
    [BOID] VARCHAR(20) NOT NULL,
    [isin] VARCHAR(20) NULL,
    [Free_Qty] NUMERIC(18, 5) NOT NULL,
    [pledge_qty] NUMERIC(18, 5) NOT NULL,
    [datetimestamp] DATETIME NOT NULL,
    [poa_status] VARCHAR(20) NULL,
    [email_Add] VARCHAR(100) NULL,
    [FIRST_HOLD_MOBILE] VARCHAR(100) NULL
);

GO
