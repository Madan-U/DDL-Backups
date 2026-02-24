-- Object: TABLE citrus_usr.CMR_dtls_mstr
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[CMR_dtls_mstr]
(
    [CMR_id] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [CMR_boid] VARCHAR(16) NOT NULL,
    [CMR_reqdt] DATETIME NOT NULL,
    [CMR_reqstat] CHAR(1) NULL,
    [CMR_reportpath] VARCHAR(1000) NULL,
    [CMR_created_by] VARCHAR(50) NOT NULL,
    [CMR_created_dt] DATETIME NOT NULL,
    [CMR_lst_upd_by] VARCHAR(50) NOT NULL,
    [CMR_lst_upd_dt] DATETIME NOT NULL,
    [CMR_deleted_ind] VARCHAR(5) NOT NULL,
    [CMR_excsm_id] INT NULL
);

GO
