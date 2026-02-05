-- Object: PROCEDURE citrus_usr.pr_ShowBillCycle_FOR_MONTHLY
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

CREATE proc [citrus_usr].[pr_ShowBillCycle_FOR_MONTHLY]    
(@dpmid varchar(16)    
,@foryear char(4)    
)    
as    
begin    
 declare @lastbilldate datetime,    
 @billfrmdate datetime,    
 @billtodate datetime,    
 @billinterval char(1),    
 @billperiod int,    
 @l_dpm_id int    ,
 @l_bill_due_days int,
 @l_bill_post_days int,
 @l_due_date datetime,
 @l_post_date datetime
 SET @lastbilldate = ''    
     
 select @l_dpm_id  = dpm_id from dp_mstr where dpm_dpid = @dpmid and dpm_Deleted_ind = 1    
     
 select @lastbilldate=max(billc_to_dt) from bill_cycle where billc_dpm_id = @l_dpm_id    
    
 IF (ISNULL(@lastbilldate,'') = '')    
 BEGIN    
  select @lastbilldate=bills_start_dt,@billinterval=Bills_interval,@billperiod=Bills_period,@l_bill_due_days=isnull(BILLS_DUE_DT_DAY,0),@l_bill_post_days=isnull(BILLS_POSTING_DT_DAY,0) from bill_setting where bills_dpm_id = @l_dpm_id    
 END    
 else    
 begin    
  select @billinterval=Bills_interval,@billperiod= Bills_period,@l_bill_due_days=isnull(BILLS_DUE_DT_DAY,0),@l_bill_post_days=isnull(BILLS_POSTING_DT_DAY,0) from bill_setting where bills_dpm_id = @l_dpm_id    
 end    
    
    
 while @lastbilldate <= getdate()    
 begin    
  set @billfrmdate = dateadd(d,1,@lastbilldate)    
      
  if @billinterval = 'D'    
  begin    
  --    
    set @billtodate = dateadd(d,-1,dateadd(d,@billperiod,@billfrmdate))    
    set @lastbilldate = @billtodate    
  --    
  end    
  else    
  begin    
  --    
    set @billtodate =dateadd(d,-1,dateadd(m,@billperiod,@billfrmdate))    
    set @lastbilldate = @billtodate    
  --    
  end    
    
    
  set @l_due_date =  dateadd(day,@l_bill_due_days,@billtodate)  
  set @l_post_date =  dateadd(day,@l_bill_post_days,@billtodate)  
  insert into Bill_cycle(billc_Dpm_id,billc_from_dt,billc_to_dt,billc_flg,billc_posted_flg ,billc_created_by,billc_created_dt,billc_lst_upd_by,billc_lst_upd_dt,billc_deleted_ind,billc_due_date,billc_lockunlock_flg,billc_posting_dt)    
  values(@l_dpm_id,@billfrmdate,@billtodate,'N','N','USER',getdate(),'USER',getdate(),1,@l_due_date,null,@l_post_date)    
      
 end    
 if @foryear = ''    
 begin    
  select billc_Dpm_id,convert(varchar(11),billc_from_dt,103) billc_from_dt,convert(varchar(11),billc_to_dt,103) billc_to_dt,billc_flg,billc_posted_flg ,convert(varchar(11),billc_from_dt,103) +'-'+ convert(varchar(11),billc_to_dt,103) billperoid,ord_dt=billc_to_dt,isnull(billc_lockunlock_flg,'')  billc_lockunlock_flg
  from Bill_cycle where billc_dpm_id = @l_dpm_id order by 7 desc    
 end    
 else    
 begin    
  select billc_Dpm_id,convert(varchar(11),billc_from_dt,103) billc_from_dt  ,convert(varchar(11),billc_to_dt,103) billc_to_dt,billc_flg,billc_posted_flg,convert(varchar(11),billc_from_dt,103) +'-'+ convert(varchar(11),billc_to_dt,103) billperoid,ord_dt=billc_to_dt ,isnull(billc_lockunlock_flg,'')  billc_lockunlock_flg
  from Bill_cycle where convert(varchar,year(billc_to_dt)) = @foryear  and  billc_dpm_id = @l_dpm_id
  order by 7 desc    
 end    
    
end

GO
