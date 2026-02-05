-- Object: TABLE citrus_usr.bo_bill_inv_mapping_Log
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[bo_bill_inv_mapping_Log]
(
    [billmonth] INT NULL,
    [billyear] INT NULL,
    [boid] VARCHAR(16) NULL,
    [inv_no] VARCHAR(50) NULL,
    [CN_FLG] VARCHAR(1) NOT NULL,
    [Return_flg] VARCHAR(1) NOT NULL,
    [Created_by] VARCHAR(16) NULL,
    [created_dt] DATETIME NOT NULL,
    [lst_upd_by] VARCHAR(16) NULL,
    [lst_upd_dt] DATETIME NOT NULL,
    [deleted_ind] INT NOT NULL,
    [dpm_id] NUMERIC(18, 0) NULL,
    [inv_action] CHAR(1) NULL
);

GO
