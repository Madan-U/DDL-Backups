-- Object: FUNCTION citrus_usr.GetNextWorkingDate
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[GetNextWorkingDate](@@currdate datetime,@excmid int) returns datetime
as
begin
declare @@retdate datetime
	if exists(select holm_excm_id from holiday_mstr where holm_excm_id = @excmid and holm_dt = dateadd(day,1,@@currdate))
	begin
		set @@retdate = citrus_usr.GetNextWorkingDate(dateadd(day,1,@@currdate),@excmid)
	end
	else
	begin
		set @@retdate = dateadd(day,1,@@currdate)
	end

	return @@retdate

end

GO
