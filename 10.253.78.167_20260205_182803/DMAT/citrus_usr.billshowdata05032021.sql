-- Object: TABLE citrus_usr.billshowdata05032021
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[billshowdata05032021]
(
    [account_id] NUMERIC(10, 0) NULL,
    [fina_acc_code] VARCHAR(50) NULL,
    [fina_acc_name] VARCHAR(8000) NULL,
    [dr_amount] MONEY NULL,
    [cr_amount] MONEY NULL,
    [acct_type] CHAR(1) NULL,
    [fina_branch_id] INT NOT NULL,
    [Post_type] VARCHAR(2) NULL
);

GO
