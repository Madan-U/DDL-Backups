-- Object: TABLE dbo.MOD_DP
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [dbo].[MOD_DP]
(
    [BO_PARTYCODE] VARCHAR(10) NULL,
    [pan_gir_no] VARCHAR(50) NULL,
    [long_name] VARCHAR(100) NULL,
    [cl_status] VARCHAR(3) NOT NULL,
    [Modification_Type] VARCHAR(100) NULL,
    [Request__NO] BIGINT NOT NULL,
    [Date_of_intimation] DATETIME NULL,
    [Mode_of_intimation] VARCHAR(1) NOT NULL,
    [Whether_Proof_of_Delivery_maintained] VARCHAR(1) NOT NULL
);

GO
