-- Object: TABLE citrus_usr.MOSL_EDP_Client_modification
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[MOSL_EDP_Client_modification]
(
    [ca_cmcd] CHAR(16) NOT NULL,
    [ca_field] VARCHAR(50) NOT NULL,
    [ca_oldvalue] VARCHAR(75) NOT NULL,
    [ca_newvalue] VARCHAR(75) NOT NULL,
    [mkrid] CHAR(8) NOT NULL,
    [mkrdt] CHAR(8) NOT NULL,
    [ca_computername] VARCHAR(15) NOT NULL,
    [ca_time] CHAR(11) NOT NULL,
    [ca_allow] CHAR(1) NOT NULL,
    [ca_brcode] CHAR(1) NOT NULL,
    [ca_authid] VARCHAR(8) NOT NULL,
    [ca_authdt] VARCHAR(8) NULL,
    [ca_batchno] NUMERIC(18, 0) NOT NULL,
    [ca_fdesc] VARCHAR(75) NOT NULL,
    [ca_refno] VARCHAR(20) NOT NULL,
    [ca_refdt] CHAR(8) NOT NULL,
    [ca_inwardno] VARCHAR(20) NOT NULL,
    [ca_flag] CHAR(1) NOT NULL,
    [ca_trxtype] CHAR(1) NOT NULL,
    [ca_closure] CHAR(1) NOT NULL,
    [ca_closurereason] VARCHAR(100) NOT NULL,
    [ca_rembal] CHAR(1) NOT NULL,
    [ca_newboid] CHAR(16) NOT NULL,
    [ca_remarks] VARCHAR(100) NOT NULL,
    [ca_reqintref] CHAR(16) NOT NULL,
    [ca_destroyslip] CHAR(1) NOT NULL,
    [ca_check] CHAR(1) NOT NULL
);

GO
