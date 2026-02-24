-- Object: PROCEDURE citrus_usr.pr_fetch_issued_slips
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------

--exec pr_fetch_issued_slips '1201200000009023',''

CREATE procedure [citrus_usr].[pr_fetch_issued_slips]
( @pa_action varchar(10),
  @pa_acct_no varchar(16),
  @pa_from_slip numeric  ,
  @pa_to_slip numeric,
  @pa_out varchar(1000) out
)
as
begin

select @pa_from_slip = case when @pa_from_slip = 0  then  0  else @pa_from_slip end 
select @pa_to_slip = case when @pa_to_slip = 0  then  9999999999  else @pa_to_slip end 

if @pa_action = 'INSERT'
begin

declare @t table
(
FromKey bigint,
ToKey bigint,
value  varchar(50),
trastm_cd varchar(20)
)
declare @final  table
(
FromKey bigint,
value  varchar(50),
trastm_cd varchar(20)
)
--
--select SLIIM_SLIP_NO_FR ,SLIIM_SLIP_NO_TO , SLIIM_SERIES_TYPE
--from slip_issue_mstr 
--where sliim_dpam_acct_no ='1234567800000041' 
--and SLIIM_SERIES_TYPE =''  
--order by 1 

insert into @t 
select SLIIM_SLIP_NO_FR ,SLIIM_SLIP_NO_TO , SLIIM_SERIES_TYPE,TRASTM_CD
from slip_issue_mstr ,transaction_sub_type_mstr
where sliim_dpam_acct_no = @pa_acct_no 
and SLIIM_TRATM_ID = TRASTM_ID
union
select SLIIM_SLIP_NO_FR ,SLIIM_SLIP_NO_TO , SLIIM_SERIES_TYPE,TRASTM_CD
from slip_issue_mstr_poa ,transaction_sub_type_mstr
where sliim_dpam_acct_no = @pa_acct_no 
and SLIIM_TRATM_ID = TRASTM_ID
order by 1 
 
 
 

 
select Identity(numeric,1,1) id , * into #l_id from @t

declare @l_counter numeric
declare @l_count numeric
set @l_counter = 1 
set @l_count = 0 
select @l_count = COUNT(id) from #l_id


declare @l_from numeric
declare @l_to  numeric
declare @l_cd varchar(100)
declare @l_value  varchar(100)




while @l_counter <=  @l_count
begin 

   select @l_from = FromKey from #l_id where id = @l_counter
   select @l_to = ToKey from #l_id where id = @l_counter
   select @l_cd = trastm_cd  from #l_id where id = @l_counter
   select @l_value = value  from #l_id where id = @l_counter
		
	while @l_from < = @l_to
	begin 
	
	 insert into @final
	 select @l_from,@l_value,@l_cd
	 
	 set @l_from =  @l_from+ 1
	end 


   set @l_counter = @l_counter +  1 
   
end  

--with tab as 
--( 
-- select FromKey , ToKey,  Value,trastm_cd from @t 
-- union all 
-- select FromKey + 1, ToKey, Value ,trastm_cd
-- from tab where FromKey < ToKey 
--) 

select FromKey, Value,trastm_cd from @final where 
not exists (select USES_SLIP_NO from used_slip where uses_deleted_ind = 1 and convert(varchar,FromKey ) = USES_SLIP_NO)
and FromKey between @pa_from_slip and  @pa_to_slip 
order by 2,1

--create index ix_uses_slip_no on used_slip(uses_slip_no)

end
else
if @pa_action = 'SEARCH'
begin
	select USES_SERIES_TYPE Value  ,USES_SLIP_NO FromKey ,USES_id trastm_cd
	from used_slip 
	where USES_DPAM_ACCT_NO = @pa_acct_no and uses_used_destr in ('B','D')
	and uses_deleted_ind = 1
	and uses_slip_no between  @pa_from_slip  and   @pa_to_slip 
	order by USES_SLIP_NO,USES_SERIES_TYPE
end 

end

GO
