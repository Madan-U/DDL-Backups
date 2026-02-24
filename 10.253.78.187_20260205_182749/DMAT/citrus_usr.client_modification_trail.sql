-- Object: TABLE citrus_usr.client_modification_trail
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[client_modification_trail]
(
    [id] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [crn_no] NUMERIC(18, 0) NULL,
    [Remarks] VARCHAR(8000) NULL,
    [created_dt] DATETIME NULL,
    [created_by] VARCHAR(100) NULL,
    [lst_upd_dt] DATETIME NULL,
    [lst_upd_by] VARCHAR(100) NULL,
    [deleted_ind] SMALLINT NULL
);

GO
