-- Object: FUNCTION citrus_usr.Fn_toSliptype
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

 

create  function [citrus_usr].[Fn_toSliptype]  

(@pa_slip_no varchar(30),@filler1 varchar(30),@filler2 varchar(30))  

  

returns varchar(30)  

as  

begin  

declare @l_rt varchar(50)  

if @filler1='P' 

begin

select @l_rt = SLIIM_LOOSE_Y_N  from slip_issue_mstr_poa where convert(numeric,@pa_slip_no) 

between SLIIM_SLIP_NO_FR and SLIIM_SLIP_NO_TO  and SLIIM_DPAM_ACCT_NO=@filler2

end

else

begin

select @l_rt = SLIIM_LOOSE_Y_N  from slip_issue_mstr where convert(numeric,@pa_slip_no) 

between SLIIM_SLIP_NO_FR and SLIIM_SLIP_NO_TO  and SLIIM_DPAM_ACCT_NO=@filler2

end

return @l_rt  

end

GO
