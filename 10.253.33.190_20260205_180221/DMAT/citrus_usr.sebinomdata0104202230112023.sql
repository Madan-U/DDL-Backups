-- Object: TABLE citrus_usr.sebinomdata0104202230112023
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[sebinomdata0104202230112023]
(
    [form_no] VARCHAR(20) NOT NULL,
    [client_id] VARCHAR(16) NULL,
    [client_name] VARCHAR(150) NULL,
    [Nominee Name] VARCHAR(142) NULL,
    [NAME_id] VARCHAR(20) NOT NULL,
    [SetupDate] VARCHAR(10) NULL,
    [Nom_Addr] VARCHAR(256) NOT NULL,
    [NOMGUARDNAME] VARCHAR(142) NULL,
    [Nom_Guard_Addr] VARCHAR(256) NOT NULL,
    [major_dt] DATETIME NULL,
    [Sec_flag] CHAR(1) NULL,
    [Nom_Sr_no] CHAR(2) NULL,
    [Nom_relation] VARCHAR(14) NULL,
    [Nom_Percentage] VARCHAR(5) NOT NULL,
    [Nom_Flag] VARCHAR(1) NOT NULL
);

GO
