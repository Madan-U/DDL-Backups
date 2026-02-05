-- Object: TABLE citrus_usr.client_otheraddress
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[client_otheraddress]
(
    [co_dpintrefno] VARCHAR(10) NULL,
    [co_cmcd] CHAR(16) NULL,
    [co_purposecd] INT NULL,
    [co_name] VARCHAR(100) NULL,
    [co_middlename] VARCHAR(20) NULL,
    [co_searchname] VARCHAR(20) NULL,
    [co_title] VARCHAR(10) NULL,
    [co_suffix] VARCHAR(10) NULL,
    [co_fhname] VARCHAR(50) NULL,
    [co_add1] VARCHAR(30) NULL,
    [co_add2] VARCHAR(30) NULL,
    [co_add3] VARCHAR(30) NULL,
    [co_city] VARCHAR(25) NULL,
    [co_state] VARCHAR(25) NULL,
    [co_country] VARCHAR(25) NULL,
    [co_pin] VARCHAR(10) NULL,
    [co_phind1] CHAR(1) NULL,
    [co_tele1] VARCHAR(17) NULL,
    [co_phind2] VARCHAR(1) NULL,
    [co_tele2] CHAR(17) NULL,
    [co_tele3] VARCHAR(100) NULL,
    [co_fax] CHAR(17) NULL,
    [co_panno] VARCHAR(25) NULL,
    [co_itcircle] VARCHAR(15) NULL,
    [co_email] VARCHAR(50) NULL,
    [co_usertext1] VARCHAR(50) NULL,
    [co_usertext2] VARCHAR(50) NULL,
    [co_userfield1] INT NULL,
    [co_userfield2] INT NULL,
    [co_userfield3] INT NULL,
    [co_cmpltd] INT NULL,
    [co_edittype] CHAR(1) NULL
);

GO
