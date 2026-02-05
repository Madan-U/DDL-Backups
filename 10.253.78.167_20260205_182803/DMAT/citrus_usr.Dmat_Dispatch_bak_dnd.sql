-- Object: TABLE citrus_usr.Dmat_Dispatch_bak_dnd
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[Dmat_Dispatch_bak_dnd]
(
    [DISP_ID] NUMERIC(10, 0) NULL,
    [DISP_DEMRM_ID] NUMERIC(10, 0) NULL,
    [DISP_TYPE] VARCHAR(25) NULL,
    [DISP_TO] VARCHAR(25) NULL,
    [DISP_DT] DATETIME NULL,
    [DISP_DOC_ID] NUMERIC(10, 0) NULL,
    [DISP_NAME] VARCHAR(250) NULL,
    [DISP_CONF_RECD] CHAR(5) NULL,
    [disp_rta_cd] VARCHAR(15) NULL,
    [disp_cons_no] VARCHAR(25) NULL,
    [disp_reminder] NUMERIC(10, 0) NULL,
    [type] VARCHAR(82) NOT NULL,
    [dt] DATETIME NOT NULL
);

GO
