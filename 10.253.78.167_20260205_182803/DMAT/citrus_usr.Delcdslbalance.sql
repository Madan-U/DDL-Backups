-- Object: TABLE citrus_usr.Delcdslbalance
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[Delcdslbalance]
(
    [Party_Code] VARCHAR(10) NULL,
    [Dpid] VARCHAR(8) NOT NULL,
    [Cltdpid] VARCHAR(16) NOT NULL,
    [Scrip_Cd] VARCHAR(12) NULL,
    [Series] VARCHAR(3) NULL,
    [Isin] VARCHAR(12) NOT NULL,
    [Freebal] INT NOT NULL,
    [Currbal] INT NOT NULL,
    [Freezebal] INT NOT NULL,
    [Lockinbal] INT NOT NULL,
    [Pledgebal] INT NOT NULL,
    [Dpvbal] INT NOT NULL,
    [Dpcbal] INT NOT NULL,
    [Rpcbal] CHAR(10) NOT NULL,
    [Elimbal] INT NOT NULL,
    [Earmarkbal] INT NOT NULL,
    [Remlockbal] INT NOT NULL,
    [Totalbalance] INT NOT NULL,
    [Trdate] DATETIME NOT NULL
);

GO
