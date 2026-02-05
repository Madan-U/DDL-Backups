-- Object: TABLE citrus_usr.Dis_req_Dtls_mak
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[Dis_req_Dtls_mak]
(
    [id] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [req_slip_no] VARCHAR(100) NULL,
    [req_date] DATETIME NULL,
    [Boid] VARCHAR(16) NULL,
    [Boname] VARCHAR(150) NULL,
    [sholder] VARCHAR(150) NULL,
    [tholder] VARCHAR(150) NULL,
    [created_dt] DATETIME NULL,
    [created_by] VARCHAR(100) NULL,
    [lst_upd_dt] DATETIME NULL,
    [lst_upd_by] VARCHAR(100) NULL,
    [deleted_ind] SMALLINT NULL,
    [remarks] VARCHAR(500) NULL,
    [imagepath] VARCHAR(1000) NULL,
    [chk_remarks] VARCHAR(300) NULL,
    [slip_yn] CHAR(1) NULL,
    [imagepath1] VARCHAR(1000) NULL,
    [imagepath2] VARCHAR(1000) NULL,
    [gen_id] NUMERIC(18, 0) NULL,
    [imagepathbinary] VARBINARY(MAX) NULL,
    [imagepath1binary] VARBINARY(MAX) NULL,
    [imagepath2binary] VARBINARY(MAX) NULL,
    [LETTER_DATE] DATETIME NULL
);

GO
