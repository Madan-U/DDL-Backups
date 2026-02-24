-- Object: TABLE citrus_usr.rcs_nonpoa
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[rcs_nonpoa]
(
    [party] VARCHAR(10) NULL,
    [scrip] VARCHAR(10) NULL,
    [isin] VARCHAR(16) NULL,
    [qty] INT NULL,
    [dp_id] VARCHAR(16) NULL,
    [TD_QTY] NUMERIC(20, 5) NULL,
    [TD_BENEFICIERY] VARCHAR(16) NULL,
    [PLEDGE_QTY] NUMERIC(18, 5) NULL,
    [FREE_QTY] NUMERIC(18, 5) NULL,
    [poa_ver] VARCHAR(1) NULL
);

GO
