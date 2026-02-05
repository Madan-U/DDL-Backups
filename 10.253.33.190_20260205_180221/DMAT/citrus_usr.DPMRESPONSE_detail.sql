-- Object: TABLE citrus_usr.DPMRESPONSE_detail
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[DPMRESPONSE_detail]
(
    [Batch_No] INT NULL,
    [Record_Type] INT NULL,
    [Line_Number] INT NULL,
    [Instruction_Type] INT NULL,
    [DIS_Instruction_Id] CHAR(12) NULL,
    [Transaction_Type] INT NULL,
    [Acceptance_Rejection_Flag] CHAR(1) NULL,
    [Filler1] CHAR(7) NULL,
    [DIS_Format_flag] CHAR(1) NULL,
    [DIS_Slip_No_from] CHAR(12) NULL,
    [DIS_Slip_No_To] CHAR(12) NULL,
    [Filler2] CHAR(6) NULL,
    [DIS_Issuance_Date] DATETIME NULL,
    [Error_code1] CHAR(6) NULL,
    [Error_code2] CHAR(6) NULL,
    [Error_code3] CHAR(6) NULL,
    [Filler3] CHAR(12) NULL
);

GO
