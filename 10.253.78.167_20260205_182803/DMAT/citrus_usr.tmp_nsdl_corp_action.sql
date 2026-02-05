-- Object: TABLE citrus_usr.tmp_nsdl_corp_action
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[tmp_nsdl_corp_action]
(
    [Record_Type] INT NULL,
    [Line_Number] BIGINT NULL,
    [DM_Order_No] NUMERIC(10, 0) NULL,
    [Entitlement_Ind] CHAR(1) NULL,
    [Credit_Debit_Ind] CHAR(1) NULL,
    [CA_Status] INT NULL,
    [ISIN] CHAR(12) NULL,
    [Filler1] CHAR(15) NULL,
    [Exec_Date] DATETIME NULL,
    [CA_Desc] CHAR(35) NULL,
    [Filler2] CHAR(50) NULL
);

GO
