-- Object: TABLE citrus_usr.dmat_dispatch_remat
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[dmat_dispatch_remat]
(
    [DISPR_ID] NUMERIC(18, 0) NULL,
    [DISPR_REMRM_ID] NUMERIC(18, 0) NULL,
    [DISPR_TYPE] VARCHAR(25) NULL,
    [DISPR_TO] VARCHAR(25) NULL,
    [DISPR_DT] DATETIME NULL,
    [DISPR_DOC_ID] NUMERIC(18, 0) NULL,
    [DISPR_NAME] VARCHAR(250) NULL,
    [DISPR_CONF_RECD] CHAR(5) NULL,
    [dispr_rta_cd] VARCHAR(15) NULL,
    [dispr_cons_no] VARCHAR(25) NULL,
    [dispr_reminder] NUMERIC(10, 0) NULL DEFAULT ((0))
);

GO
