-- Object: PROCEDURE dbo.get_login_info
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE procedure get_login_info(@status as varchar(50),@report as varchar(100),@brcode as varchar(10))
as
set nocount on

--set @report = replace(@report,'`','')

set transaction isolation level read uncommitted
select fldstname,fldusername,username=fldfirstname+' '+fldmiddlename+' '+fldlastname,fldcategory,a.fldadminauto,b.fldcategoryname,b.flddesc 
into #user
from tblPradnyausers a (nolock), tblcategory  b (nolock) where 
a.fldcategory = b.fldcategorycode and a.fldadminauto=b.fldadminauto 
and fldstname like @brcode
and pwd_expiry_date >= getdate()
and a.fldadminauto in
(select fldauto_admin from tbladmin (nolock) where fldstatus not in ('Subbroker','Family','Client','Trader') and fldstatus like @status
)
and a.fldadminauto in
(
select fldadminauto from tblcatmenu (nolock) where fldreportcode in 
(select fldreportcode from tblreports (nolock) where fldreportname like @report)
--fldpath like '%fotrade/newreport/index.asp%' --and fldstatus in ('All','broker','broker'))
)

set transaction isolation level read uncommitted
select username,last_Access_on=max(adddt) 
into #login
from V2_Report_Access_Log (nolock) where replace(reppath,'`','') in (select fldpath from tblreports where fldreportname like @report)
and username in (select fldusername from #user)
group by username 

set transaction isolation level read uncommitted
select a.*,access=(case when b.username is null then '-' else 'Yes' end),last_Access_on from #user a left outer join #login b on b.username=a.fldusername
order by fldusername

set nocount off

GO
