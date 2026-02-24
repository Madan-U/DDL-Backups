-- Object: TABLE citrus_usr.MISMATCHMALEFEMALE
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[MISMATCHMALEFEMALE]
(
    [SYNMALEFEMALE] VARCHAR(1) NOT NULL,
    [DMATMALEFEMALE] VARCHAR(1) NOT NULL,
    [dpam_acct_no] VARCHAR(20) NOT NULL,
    [dpam_sba_no] VARCHAR(20) NOT NULL,
    [dp_internal_ref] VARCHAR(10) NULL
);

GO
