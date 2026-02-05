-- Object: TABLE citrus_usr.login_limit_mapping
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[login_limit_mapping]
(
    [iim_id] BIGINT IDENTITY(1,1) NOT NULL,
    [llm_login_name] VARCHAR(750) NULL,
    [llm_RANGENAME] VARCHAR(1000) NULL,
    [llm_created_by] VARCHAR(100) NULL,
    [llm_created_dt] DATETIME NULL,
    [llm_lst_upd_by] VARCHAR(100) NULL,
    [llm_lst_upd_dt] DATETIME NULL,
    [llm_deleted_ind] SMALLINT NULL
);

GO
