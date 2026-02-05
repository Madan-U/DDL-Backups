-- Object: PROCEDURE citrus_usr.Pr_Jvlogic_Incr_DataDel
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--Exec Pr_Jvlogic_Incr_DataDel '','Select'
CREATE procedure Pr_Jvlogic_Incr_DataDel
(@pa_loginnames varchar(50)
,@pa_action varchar(20)
)
as
begin

declare @l_maxrundate varchar(25)
select top 1 @l_maxrundate= convert(varchar(11),run_date,109)  
from csv_output_log order by run_date desc --2021-10-06 00:19:40.663
print @l_maxrundate

if @pa_action='Select'
begin
select *  from csv_output_log , last_EXPORTED_DATA a
where fina_acc_code = dpamid and  FINA_ACC_NAME = charge_name 
and Last_Exported_dt = charge_name_dt 
and convert(varchar(11),run_date,109)=@l_maxrundate
end

if @pa_action='Delete'
begin
delete a  from csv_output_log , last_EXPORTED_DATA a
where fina_acc_code = dpamid and  FINA_ACC_NAME = charge_name 
and Last_Exported_dt = charge_name_dt 
and convert(varchar(11),run_date,109)=@l_maxrundate
end

end

GO
