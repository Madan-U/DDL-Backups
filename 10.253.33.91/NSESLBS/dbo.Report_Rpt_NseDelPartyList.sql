-- Object: PROCEDURE dbo.Report_Rpt_NseDelPartyList
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------






CREATE Proc Report_Rpt_NseDelPartyList (@StatusId Varchar(15),@StatusName Varchar(25))
As 

SELECT PARTY_CODE from Client2_Report C2, Client1_Report C1 
WHERE C1.CL_CODE = C2.CL_CODE
AND C1.BRANCH_CD LIKE (CASE WHEN @statusid = 'branch' THEN @StatusName else '%' end)
AND C1.SUB_BROKER LIKE (CASE WHEN @statusid = 'subbroker' THEN @StatusName else '%' end)
AND C1.TRADER LIKE (CASE WHEN @statusid = 'trader' THEN @StatusName else '%' end)
AND C1.FAMILY LIKE (CASE WHEN @statusid = 'family' THEN @StatusName else '%' end)
AND C2.PARTY_CODE LIKE (CASE WHEN @statusid = 'client' THEN @StatusName else '%' end)
order by PARTY_CODE

GO
