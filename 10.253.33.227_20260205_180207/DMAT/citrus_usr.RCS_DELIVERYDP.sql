-- Object: TABLE citrus_usr.RCS_DELIVERYDP
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[RCS_DELIVERYDP]
(
    [SNo] NUMERIC(18, 0) NOT NULL,
    [DpType] VARCHAR(4) NULL,
    [DpId] VARCHAR(16) NULL,
    [DpCltNo] VARCHAR(16) NULL,
    [Description] VARCHAR(50) NULL,
    [ACCOUNTTYPE] VARCHAR(4) NULL,
    [LICENCENO] VARCHAR(20) NULL,
    [EXCHANGE] VARCHAR(3) NULL,
    [SEGMENT] VARCHAR(7) NULL,
    [DIVACNO] VARCHAR(10) NULL,
    [STATUS_FLAG] VARCHAR(1) NULL
);

GO
