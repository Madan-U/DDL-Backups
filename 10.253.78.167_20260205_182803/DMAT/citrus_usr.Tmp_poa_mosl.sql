-- Object: TABLE citrus_usr.Tmp_poa_mosl
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE TABLE [citrus_usr].[Tmp_poa_mosl]
(
    [cpd_poaid] VARCHAR(16) NOT NULL,
    [cpd_dpid] VARCHAR(10) NOT NULL,
    [cpd_boid] CHAR(16) NOT NULL,
    [cpd_holderno] INT NULL,
    [cpd_firstname] VARCHAR(100) NOT NULL,
    [cpd_middlename] VARCHAR(20) NULL,
    [cpd_searchname] VARCHAR(50) NULL,
    [cpd_poaregno] VARCHAR(16) NOT NULL,
    [cpd_operateaccount] VARCHAR(1) NOT NULL,
    [cpd_cacharfield] VARCHAR(50) NOT NULL,
    [cpd_effectivefrom] VARCHAR(8) NOT NULL,
    [cpd_effectiveto] VARCHAR(8) NOT NULL,
    [cpd_setupdate] VARCHAR(8) NOT NULL,
    [cpd_Remarks] VARCHAR(100) NOT NULL,
    [cpd_POAStatus] CHAR(1) NOT NULL
);

GO
