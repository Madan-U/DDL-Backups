-- Object: PROCEDURE dbo.Transfer_Count
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


Create proc Transfer_Count
as
set transaction isolation level read uncommitted
select count(1),'INSERT' from donotdelete_insert
set transaction isolation level read uncommitted
select count(1),'UPDATE' from donotdelete_Update
set transaction isolation level read uncommitted
select count(1),'DELETE' from donotdelete_Delete
set transaction isolation level read uncommitted
Select FLDLASTINS, FLDLASTDEL, FLDLASTUPDT,FLDUPDTDATE, getdate() from tblglobalparams

GO
