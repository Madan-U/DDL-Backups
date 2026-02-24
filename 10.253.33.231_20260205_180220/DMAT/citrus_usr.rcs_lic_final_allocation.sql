-- Object: TABLE citrus_usr.rcs_lic_final_allocation
-- Server: 10.253.33.231 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[rcs_lic_final_allocation]
(
    [TD_CURDATE] DATETIME NULL,
    [TD_AC_CODE] VARCHAR(16) NULL,
    [TD_ISIN_CODE] VARCHAR(20) NULL,
    [td_qty] NUMERIC(20, 5) NULL,
    [TD_DESCRIPTION] VARCHAR(100) NULL,
    [TD_NARRATION] VARCHAR(20) NULL,
    [TD_RATE] INT NOT NULL,
    [party_code] VARCHAR(10) NOT NULL,
    [Sr_No] INT IDENTITY(1,1) NOT NULL
);

GO
