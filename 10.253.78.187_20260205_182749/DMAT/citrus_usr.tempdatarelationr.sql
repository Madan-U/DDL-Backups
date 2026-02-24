-- Object: TABLE citrus_usr.tempdatarelationr
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[tempdatarelationr]
(
    [dpam_crn_no] NUMERIC(10, 0) NOT NULL,
    [dpam_acct_no] VARCHAR(20) NOT NULL,
    [dpam_sba_no] VARCHAR(20) NOT NULL,
    [ho] VARCHAR(1) NOT NULL,
    [re] NUMERIC(10, 0) NULL,
    [ar] NUMERIC(10, 0) NULL,
    [br] NUMERIC(10, 0) NULL,
    [ba] NUMERIC(10, 0) NULL,
    [em] NUMERIC(10, 0) NULL,
    [onw] NUMERIC(10, 0) NULL,
    [efr] VARCHAR(11) NOT NULL,
    [eto] VARCHAR(11) NOT NULL,
    [cu] VARCHAR(6) NOT NULL,
    [cdt] DATETIME NOT NULL,
    [lu] VARCHAR(6) NOT NULL,
    [ldt] DATETIME NOT NULL,
    [del] INT NOT NULL,
    [excpm_id] NUMERIC(10, 0) NOT NULL
);

GO
