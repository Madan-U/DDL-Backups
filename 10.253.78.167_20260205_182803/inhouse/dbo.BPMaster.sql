-- Object: TABLE dbo.BPMaster
-- Server: 10.253.78.167 | DB: inhouse
--------------------------------------------------

CREATE TABLE [dbo].[BPMaster]
(
    [bp_id] CHAR(8) NULL,
    [bp_role] CHAR(2) NULL,
    [bp_add1] VARCHAR(36) NULL,
    [bp_add2] VARCHAR(36) NULL,
    [bp_add3] VARCHAR(36) NULL,
    [bp_add4] VARCHAR(36) NULL,
    [bp_pin] CHAR(7) NULL,
    [bp_phone] VARCHAR(24) NULL,
    [bp_fax] VARCHAR(24) NULL,
    [bp_assd_cc_id] CHAR(8) NULL,
    [bp_assd_dp_id] CHAR(8) NULL,
    [bp_assd_cc_cmid] VARCHAR(16) NULL,
    [bp_category] CHAR(2) NULL,
    [bp_name] VARCHAR(135) NULL,
    [bp_stat] CHAR(2) NULL
);

GO
