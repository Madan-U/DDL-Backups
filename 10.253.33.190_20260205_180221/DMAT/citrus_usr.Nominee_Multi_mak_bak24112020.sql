-- Object: TABLE citrus_usr.Nominee_Multi_mak_bak24112020
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[Nominee_Multi_mak_bak24112020]
(
    [nom_id] NUMERIC(18, 0) NULL,
    [Nom_dpam_id] NUMERIC(18, 0) NULL,
    [Nom_DPAM_SBA_NO] VARCHAR(100) NULL,
    [nom_srno] NUMERIC(2, 0) NULL,
    [nom_fname] VARCHAR(100) NULL,
    [nom_mname] VARCHAR(20) NULL,
    [nom_tname] VARCHAR(20) NULL,
    [nom_fthname] VARCHAR(50) NULL,
    [nom_dob] DATETIME NULL,
    [nom_adr1] VARCHAR(55) NULL,
    [nom_adr2] VARCHAR(55) NULL,
    [nom_adr3] VARCHAR(55) NULL,
    [nom_city] VARCHAR(25) NULL,
    [nom_state] VARCHAR(25) NULL,
    [nom_country] VARCHAR(25) NULL,
    [nom_zip] VARCHAR(10) NULL,
    [nom_phone1_ind] CHAR(6) NULL,
    [nom_phone1] VARCHAR(17) NULL,
    [nom_phone2_ind] CHAR(1) NULL,
    [nom_phone2] VARCHAR(1) NULL,
    [nom_Addphone] VARCHAR(50) NULL,
    [nom_fax] VARCHAR(17) NULL,
    [nom_pan] VARCHAR(10) NULL,
    [nom_Uid] VARCHAR(15) NULL,
    [nom_email] VARCHAR(50) NULL,
    [nom_relation] VARCHAR(100) NULL,
    [nom_percentage] NUMERIC(5, 2) NULL,
    [nom_res_sec_flag] CHAR(1) NULL,
    [NOm_CREATED_BY] VARCHAR(100) NULL,
    [NOm_CREATED_DT] DATETIME NULL,
    [NOm_LST_UPD_BY] VARCHAR(100) NULL,
    [Nom_LST_UPD_DT] DATETIME NULL,
    [Nom_DELETED_IND] SMALLINT NULL
);

GO
