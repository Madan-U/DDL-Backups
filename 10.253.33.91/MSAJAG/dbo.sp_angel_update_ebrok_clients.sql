-- Object: PROCEDURE dbo.sp_angel_update_ebrok_clients
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE proc

	[dbo].[sp_angel_update_ebrok_clients]

as

/*
--	select top 1 * from tbladmin
--	select top 1 * from tblcategory
--	select top 1 * from tblpradnyausers
--
----drop table tblpradnyausers_temp
----select * into tblpradnyausers_temp from AngelBSECM.bsedb_ab.dbo.tblpradnyausers where ltrim(rtrim(fldusername)) in ( 'A088', 'A100', 'A10007' )
--
--	begin tran
--	sp_angel_update_ebrok_clients
--	rollback tran
*/

--select distinct party_code into #ebrok_clients from intranet.ctcl.dbo.ebrok_client1
select distinct party_code into #ebrok_clients from intranet.mis.dbo.ebrok_client1

begin tran

update
	tblpradnyausers
set
	pwd_expiry_date = 'Dec 31 2049 23:50'
from
	tbladmin a with (nolock),
	tblcategory c  with (nolock)
where
	a.fldauto_admin = c.fldadminauto
	and c.fldcategorycode = tblpradnyausers.fldcategory
	and a.fldauto_admin = tblpradnyausers.fldadminauto
	and a.fldstname = 'CLIENT'
	and ltrim(rtrim(fldusername)) in (select ltrim(rtrim(party_code)) from #ebrok_clients)

commit tran

GO
