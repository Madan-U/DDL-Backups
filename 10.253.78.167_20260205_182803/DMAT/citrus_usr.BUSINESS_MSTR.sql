-- Object: TABLE citrus_usr.BUSINESS_MSTR
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[BUSINESS_MSTR]
(
    [busm_id] NUMERIC(10, 0) NOT NULL,
    [busm_cd] VARCHAR(20) NOT NULL,
    [busm_desc] VARCHAR(200) NULL,
    [busm_rmks] VARCHAR(200) NULL,
    [busm_created_by] VARCHAR(50) NOT NULL,
    [busm_created_dt] DATETIME NOT NULL,
    [busm_lst_upd_by] VARCHAR(50) NOT NULL,
    [busm_lst_upd_dt] DATETIME NOT NULL,
    [busm_deleted_ind] NUMERIC(18, 0) NOT NULL
);

GO
