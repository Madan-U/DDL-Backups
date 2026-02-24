-- Object: TABLE citrus_usr.account_group_mapping
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[account_group_mapping]
(
    [dpam_id] NUMERIC(18, 0) NULL,
    [Group_cd] VARCHAR(10) NULL,
    [Created_dt] DATETIME NULL,
    [created_by] VARCHAR(20) NULL,
    [lst_upd_dt] DATETIME NULL,
    [lst_upd_by] VARCHAR(20) NULL,
    [deleted_ind] INT NULL
);

GO
