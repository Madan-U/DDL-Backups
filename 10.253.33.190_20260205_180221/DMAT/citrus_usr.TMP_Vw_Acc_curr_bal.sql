-- Object: TABLE citrus_usr.TMP_Vw_Acc_curr_bal
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[TMP_Vw_Acc_curr_bal]
(
    [PARTY_CODE] VARCHAR(20) NULL,
    [CLIENT_CODE] VARCHAR(20) NOT NULL,
    [Actual_amount] MONEY NULL,
    [Accrual_bal] NUMERIC(38, 5) NULL,
    [Branch_Code] VARCHAR(1) NOT NULL
);

GO
