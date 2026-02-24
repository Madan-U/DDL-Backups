-- Object: TABLE dbo.Vw_Template_Charges
-- Server: 10.253.78.167 | DB: inhouse
--------------------------------------------------

CREATE TABLE [dbo].[Vw_Template_Charges]
(
    [TEMPLATE_CODE] VARCHAR(10) NOT NULL,
    [CHARGES_CODE] VARCHAR(10) NOT NULL,
    [SLAB_CODE] VARCHAR(10) NULL,
    [MINIMUM_CHARGES] MONEY NULL,
    [MAXIMUM_CHARGES] MONEY NULL,
    [MAILING_CHARGES] MONEY NULL
);

GO
