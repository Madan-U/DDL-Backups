-- Object: TABLE citrus_usr.SSIS_DATA_SUB_BROKER
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[SSIS_DATA_SUB_BROKER]
(
    [cl_Code] VARCHAR(10) NOT NULL,
    [branch_cd] VARCHAR(10) NULL,
    [sub_broker] VARCHAR(10) NOT NULL,
    [region] VARCHAR(50) NULL,
    [b2b_b2c] VARCHAR(3) NOT NULL
);

GO
