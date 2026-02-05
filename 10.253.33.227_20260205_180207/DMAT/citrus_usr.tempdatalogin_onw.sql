-- Object: TABLE citrus_usr.tempdatalogin_onw
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[tempdatalogin_onw]
(
    [id] NUMERIC(18, 0) IDENTITY(1,1) NOT NULL,
    [Login id] NVARCHAR(255) NULL,
    [psw] VARCHAR(44) NOT NULL,
    [enttm_id] NUMERIC(10, 0) NOT NULL,
    [entm_id] NUMERIC(10, 0) NOT NULL,
    [entm_short_name] VARCHAR(100) NULL
);

GO
