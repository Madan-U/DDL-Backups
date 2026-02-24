-- Object: PROCEDURE dbo.Report_Rpt_NseDelScripLst
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------






CREATE Proc Report_Rpt_NseDelScripLst(@StatusId Varchar(15),@StatusName Varchar(25))
As 

SELECT DISTINCT scrip_cd from scrip2 order by scrip_cd

GO
