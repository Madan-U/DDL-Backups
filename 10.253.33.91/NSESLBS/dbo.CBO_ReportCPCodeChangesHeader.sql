-- Object: PROCEDURE dbo.CBO_ReportCPCodeChangesHeader
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE
proc

	CBO_ReportCPCodeChangesHeader
	(
		@statusid varchar(20),
		@statusname varchar(25)
	)

as

set @statusid = ltrim(rtrim(@statusid))
set @statusname = ltrim(rtrim(@statusname))

if (len(@statusid) > 0) and (len(@statusname) > 0)
begin
	select
		'01' as record_type,
		'M' as member_type,
		upper(ltrim(rtrim(membercode))) as member_code,
		replace(convert(varchar, getdate(), 103), '/', '') as batch_date
		/*batch number COMES FROM rpt_proc_cp_code_changes_get_batch_no*/
		/*total number of records COMES FROM rpt_proc_cp_code_changes_details*/
	from
		owner
end
else
begin
	select 'invalid login'
end

GO
