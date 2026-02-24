-- Object: TABLE citrus_usr.name_change_reason_cd
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[name_change_reason_cd]
(
    [nmcrcd_id] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [nmcrcd_crn_no] NUMERIC(18, 0) NULL,
    [nmcrcd_sba_no] NUMERIC(16, 0) NULL,
    [nmcrcd_reason_cd] CHAR(2) NULL,
    [nmcrd_reason_desc] VARCHAR(200) NULL,
    [nmcrcd_created_dt] DATETIME NULL,
    [nmcrcd_created_by] VARCHAR(50) NULL,
    [nmcrcd_lst_upd_dt] DATETIME NULL,
    [nmcrcd_lst_upd_by] VARCHAR(50) NULL,
    [nmcrcd_deleted_ind] NUMERIC(1, 0) NULL,
    [nmcrcd_holder_type] VARCHAR(20) NULL
);

GO
