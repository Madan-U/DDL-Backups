-- Object: PROCEDURE citrus_usr.pr_valid_date
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE proc pr_valid_date(@pa_from_dt datetime, @pa_to_dt datetime)
as
begin 
declare @l_valid varchar(1000)
set @l_valid = ''

if @pa_from_dt < 'NOV 01 2014'
set @l_valid  = 'The DP sharing report is available only from NOV 01 2014 onwards'

else if month(@pa_from_dt ) <> month(@pa_to_dt) or year(@pa_from_dt) <> year(@pa_to_dt)
set @l_valid  = 'Month and Year should be same for selected date range'

else if @pa_from_dt <> CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(@pa_from_dt)-1),@pa_from_dt),101) 
set @l_valid  = 'From Date Should be first day of month'

else if @pa_to_dt <>  CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,@pa_to_dt))),DATEADD(mm,1,@pa_to_dt)),101)
set @l_valid  = 'The DP sharing report for previous month is available only after 5th day of current month'

else if convert(datetime,convert(varchar(11),getdate(),109),109) < = dateadd(dd,4,dateadd(m,1,@pa_from_dt ))
set @l_valid  = 'Data not processed at HO For Selected Date Period'


select @l_valid


end

GO
