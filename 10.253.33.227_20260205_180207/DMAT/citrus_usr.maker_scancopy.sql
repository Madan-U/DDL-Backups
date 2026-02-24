-- Object: TABLE citrus_usr.maker_scancopy
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[maker_scancopy]
(
    [id] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [ref_no] VARCHAR(50) NULL,
    [slip_no] VARCHAR(100) NULL,
    [client_id] VARCHAR(16) NULL,
    [entity] VARCHAR(100) NULL,
    [entity_name] VARCHAR(250) NULL,
    [scanimage] IMAGE NULL,
    [recon_flag] CHAR(1) NULL,
    [recon_datetime] DATETIME NULL,
    [created_by] VARCHAR(50) NULL,
    [created_dt] DATETIME NULL,
    [llst_upd_by] VARCHAR(50) NULL,
    [lst_upd_dt] DATETIME NULL,
    [deleted_ind] SMALLINT NULL,
    [remarks] VARCHAR(100) NULL,
    [preappflg] CHAR(2) NULL,
    [scanimagebinary] VARBINARY(MAX) NULL,
    [scanimage_Annx1] IMAGE NULL,
    [scanimage_Annx2] IMAGE NULL,
    [scanimage_Annx3] IMAGE NULL,
    [scanimage_Annx4] IMAGE NULL,
    [scanimage_Annx5] IMAGE NULL
);

GO
