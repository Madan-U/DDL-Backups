-- Object: VIEW citrus_usr.VW_deactivation_details
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------


CREATE VIEW [citrus_usr].[VW_deactivation_details] as 
select EMP_NO, SEPARATIONDATE  from  INTRANET.RISK.DBO.EMP_INFO

GO
