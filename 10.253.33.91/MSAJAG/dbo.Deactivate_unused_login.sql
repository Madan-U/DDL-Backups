-- Object: PROCEDURE dbo.Deactivate_unused_login
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE procedure Deactivate_unused_login  
as  
set nocount on  
  
select userNAME,last_login_Date=max(adddt) into #file1 from V2_Login_Log (nolock) group by userNAME  
  
select fldusername,last_login_Date into #file2 from tblpradnyausers a (nolock)   
left outer join #file1 b on a.fldusername=b.userNAME  
--select * into TBLUSERCONTROLMASTER_02062008 from TBLUSERCONTROLMASTER   
  
  
-- deactivate Clients  
update TBLUSERCONTROLMASTER set  FLDSTATUS = 1
WHERE FLDUSERID in  
(  
select fldauto from tblpradnyausers where fldusername in (  
SELECT fldusername FROM #FILE2 where isnull(last_login_date,convert(Datetime,'Jan  1 1900')) <= getdate()-180 and   
fldusername in (select party_Code from intranet.risk.dbo.client_Details where first_Active_Date <= getdate()-180))  
)  
  
-- deactivate Non-Clients  
update TBLUSERCONTROLMASTER set  FLDSTATUS = 1
WHERE FLDUSERID in  
(  
select fldauto from tblpradnyausers where fldusername in (  
SELECT fldusername FROM #FILE2 where isnull(last_login_date,convert(Datetime,'Jan  1 1900')) <= getdate()-180 and   
fldusername not in (select party_Code from intranet.risk.dbo.client_Details ))  
)  
  
set nocount off

GO
