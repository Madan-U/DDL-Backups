-- Object: PROCEDURE citrus_usr.pr_calculate_subdt
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--PR_CALCULATE_SUBDT 0,'sub_DT','N','HY',''

CREATE proc [citrus_usr].[pr_calculate_subdt](@pa_id numeric,@pa_action varchar(10),@pa_nor_marg char(1),@pa_y_hy char(2),@pa_out varchar(1000) out)
as
begin

if @pa_nor_marg ='N'
begin
 if @pa_action ='SUB_DT'
 begin 
  select case when @pa_y_hy ='HY' and getdate() > 'SEP 30 ' + convert(varchar,year(getdate())) then 'SEP 30 ' + convert(varchar,year(getdate()))
			  when @pa_y_hy ='Y' then 'Mar 31 ' + convert(varchar,year(getdate())) else 'NA' end

   
 end 
 if @pa_action ='DUE_DT'
 begin 
  select case when @pa_y_hy ='HY' and getdate() > 'SEP 30 ' + convert(varchar,year(getdate())) then 'Dec 31 ' + convert(varchar,year(getdate()))
			  when @pa_y_hy ='Y' then 'oct 31 ' + convert(varchar,year(getdate())) else 'NA' end

   
 end 
 
end 

end

GO
