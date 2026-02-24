-- Object: FUNCTION citrus_usr.fn_isclientApproved_II
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

CREATE function [citrus_usr].[fn_isclientApproved_II](@clim_crn_no bigint) returns bigint
begin
	declare @@retval bigint
	set @@retval =0
   if exists (select dpam_crn_no from dp_acct_mstr where dpam_crn_no=@clim_crn_no and dpam_deleted_ind=1 )
		begin
		select top 1 @@retval =isnull(clim_crn_no,0) from client_mstr where clim_crn_no = @clim_crn_no
		end
	else
	begin
		if exists (select clisba_crn_no from client_sub_accts where clisba_crn_no=@clim_crn_no)
			begin
			select top 1 @@retval =isnull(clim_crn_no,0) from client_mstr where clim_crn_no = @clim_crn_no
			end 
		else
			begin
			set @@retval =0
			end
	end
	return @@retval
	
end

GO
