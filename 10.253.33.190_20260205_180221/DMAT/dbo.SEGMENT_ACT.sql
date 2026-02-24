-- Object: TABLE dbo.SEGMENT_ACT
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE TABLE [dbo].[SEGMENT_ACT]
(
    [RequestRefNo] BIGINT NOT NULL,
    [Party_code] VARCHAR(50) NULL,
    [PAN] VARCHAR(50) NULL,
    [Client_name] VARCHAR(100) NULL,
    [Category_Of_Client] VARCHAR(12) NOT NULL,
    [Date_of_receiving_Modification_Request] DATETIME NULL,
    [Modification_Type] VARCHAR(7) NOT NULL,
    [New_Details] VARCHAR(51) NOT NULL,
    [Date_of_uploading data_documents_on_KRA_System] DATETIME NULL,
    [Date_of_intimation] DATETIME NULL,
    [Mode_of_intimation] VARCHAR(9) NOT NULL,
    [Whether_Proof_of_Delivery_maintained] VARCHAR(3) NOT NULL
);

GO
