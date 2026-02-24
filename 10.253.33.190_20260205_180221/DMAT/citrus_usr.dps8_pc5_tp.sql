-- Object: TABLE citrus_usr.dps8_pc5_tp
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[dps8_pc5_tp]
(
    [PurposeCode5] VARCHAR(100) NULL,
    [TypeOfTrans] VARCHAR(100) NULL,
    [MasterPOAId] CHAR(16) NULL,
    [POARegNum] CHAR(16) NULL,
    [SetupDate] VARCHAR(20) NULL,
    [GPABPAFlg] CHAR(1) NULL,
    [EffFormDate] VARCHAR(20) NULL,
    [EffToDate] VARCHAR(20) NULL,
    [Remarks] CHAR(50) NULL,
    [HolderNum] VARCHAR(100) NULL,
    [POAStatus] CHAR(1) NULL,
    [BOId] CHAR(16) NULL,
    [TransSystemDate] VARCHAR(50) NULL,
    [VALID] VARCHAR(1) NULL DEFAULT ((0))
);

GO
