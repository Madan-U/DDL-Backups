-- Object: TABLE citrus_usr.CLIM_SEQ_NO
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[CLIM_SEQ_NO]
(
    [CLIM_CRN_NO] NUMERIC(10, 0) NOT NULL,
    [CLIM_EXCH_SEG] VARCHAR(100) NULL,
    [CLIM_SEQ_NO] NUMERIC(10, 0) NOT NULL,
    [CLIM_IND] SMALLINT NOT NULL,
    [CLIM_CREATED_DT] DATETIME NOT NULL,
    [CLIM_LST_UPD_DT] DATETIME NOT NULL
);

GO
