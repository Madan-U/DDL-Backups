-- Object: TABLE citrus_usr.client_main_properties
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[client_main_properties]
(
    [BOid] CHAR(16) NULL,
    [PurposeCode] VARCHAR(50) NULL,
    [rgss_flag] CHAR(1) NULL,
    [bsda_flag] CHAR(1) NULL,
    [mobile_no] CHAR(11) NULL,
    [SmsEmailId] CHAR(100) NULL,
    [Pri_PhInd] CHAR(1) NULL,
    [Pri_PhNum] CHAR(17) NULL,
    [Alt_PhInd] CHAR(1) NULL,
    [Alt_PhNum] CHAR(17) NULL,
    [Add_Ph] CHAR(100) NULL,
    [Fax] CHAR(17) NULL,
    [EMail_Id] CHAR(50) NULL
);

GO
