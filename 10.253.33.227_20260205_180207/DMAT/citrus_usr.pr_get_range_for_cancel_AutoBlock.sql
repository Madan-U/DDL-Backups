-- Object: PROCEDURE citrus_usr.pr_get_range_for_cancel_AutoBlock
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------







--select * from SLIP_ISSUE_MSTR
--select * from used_slip where uses_slip_no ='11'
--exec pr_get_range_for_cancel '' , '1','25','1201090000022523','N' 
CREATE proc [citrus_usr].[pr_get_range_for_cancel_AutoBlock](@pa_series varchar(100),@pa_from_slip numeric,@pa_to_slip numeric,@pa_acct_no varchar(16)
,@pa_auto_flg char(1),@pa_values varchar(1000))
as
begin 
declare @l_slip_list table (slipno numeric)
declare @l_slip_list_cancel table (slipno numeric)

declare @l_from_slip_no numeric
, @l_to_slip_no numeric
, @l_from_range numeric
, @l_to_range numeric


declare @l_from_slip_no_cancel numeric
, @l_to_slip_no_cancel numeric

,@l_counter numeric
,@l_counter1 numeric

set @l_counter  = 1 
set @l_counter1 =  1

--if (@pa_auto_flg='N')
--begin
--if exists (
--select uses_id from used_slip_block  where uses_deleted_ind = 1 and uses_dpam_acct_no = @pa_acct_no
--and uses_id not in (select slibd_sliim_id from sliim_batch_dtls where slibd_deleted_ind=1)
--)
--begin
--select '' rangeslip
--return
--end

--end

Declare @pa_acct_no_type varchar(30)

if @pa_auto_flg='N' 
begin
set @pa_acct_no_type=citrus_usr.fn_splitval_by(@pa_acct_no,2,'|*~|')

set @pa_acct_no=ltrim(rtrim(citrus_usr.fn_splitval_by(@pa_acct_no,1,'|*~|')))

if @pa_acct_no_type='DRF'  
begin
Select '' RangeSlip
Return
end

end


declare @l_slip_list_final table (from_slipno numeric,to_slipno numeric)

declare @@c_access_cursor cursor 
declare @@c_access_cursor_1 cursor 

select uses_slip_no into #tmp_usedslipdata from used_slip where 
--USES_SERIES_TYPE =@pa_series  and 
USES_DPAM_ACCT_NO = @pa_acct_no
--AND USES_SLIP_NO BETWEEN @pa_from_slip and @pa_to_slip


SET @@c_access_cursor_1 =  CURSOR fast_forward FOR            
select  USES_SLIP_NO, USES_SLIP_NO_to 
from USED_SLIP_BLOCK 
where 
--USES_SLIP_NO between  @pa_from_slip and @pa_to_slip
--and USES_SLIP_NO_to between  @pa_from_slip and @pa_to_slip
--and USES_SERIES_TYPE = @pa_series and
USES_DPAM_ACCT_NO = @pa_acct_no
and USES_DELETED_IND  = 1

OPEN @@c_access_cursor_1            
FETCH NEXT FROM @@c_access_cursor_1 INTO @l_from_slip_no_cancel , @l_to_slip_no_cancel            
--            
WHILE @@fetch_status = 0            
BEGIN            
--            
print getdate()

		WHILE @l_from_slip_no_cancel < =    @l_to_slip_no_cancel    
		BEGIN            

		insert into @l_slip_list_cancel 
		select @l_from_slip_no_cancel 

		SET @L_FROM_SLIP_NO_CANCEL = @L_FROM_SLIP_NO_CANCEL + 1


		END 
    FETCH NEXT FROM @@c_access_cursor_1 INTO @l_from_slip_no_cancel , @l_to_slip_no_cancel  

                    
--
END  
CLOSE      @@c_access_cursor_1            
DEALLOCATE @@c_access_cursor_1

--select * from @l_slip_list_cancel

  

--SET @@c_access_cursor =  CURSOR fast_forward FOR 
declare @l_min_id numeric
declare @l_min_id_to numeric
set @l_min_id = 0
set @l_min_id_to = 0 

select @l_min_id = min(sliim_id)
from slip_issue_mstr 
where  SLIIM_DPAM_ACCT_NO = @pa_acct_no and sliim_tratm_id=454
and not exists  (select slibd_sliim_id from sliim_batch_dtls where slibd_deleted_ind=1 and slibd_sliim_id = sliim_id )

select @l_min_id_to = max(sliim_id)
from slip_issue_mstr 
where  SLIIM_DPAM_ACCT_NO = @pa_acct_no and sliim_tratm_id=454
and not exists  (select slibd_sliim_id from sliim_batch_dtls where slibd_deleted_ind=1 and slibd_sliim_id = sliim_id )

while @l_min_id  < =   @l_min_id_to 
begin          
select @l_from_slip_no = SLIIM_SLIP_NO_FR, @l_to_slip_no = SLIIM_SLIP_NO_TO 
from slip_issue_mstr 
where 
 SLIIM_DPAM_ACCT_NO = @pa_acct_no and sliim_tratm_id=454
and sliim_id = @l_min_id  



WHILE @l_from_slip_no < =    @l_to_slip_no    
BEGIN            

insert into @l_slip_list 
select @l_from_slip_no 

set @l_from_slip_no = @l_from_slip_no + 1


END            

select @l_min_id   = min(sliim_id) from slip_issue_mstr 
where  SLIIM_DPAM_ACCT_NO = @pa_acct_no and sliim_tratm_id=454
and sliim_id > @l_min_id   

end 

delete from @l_slip_list where slipno in (select uses_slip_no from #tmp_usedslipdata )
delete from @l_slip_list where slipno in (select slipno from @l_slip_list_cancel )



select identity(numeric,1,1) id , * into #tempdata_final from @l_slip_list  order by slipno

declare @l_last_id numeric 
set @l_last_id  = 1 



    

SET @@c_access_cursor =  CURSOR fast_forward FOR            
select a.slipno fromrange , b.slipno torange from #tempdata_final a
, #tempdata_final b
where a.id  +1 = b.id 
and b.slipno-a.slipno <> 1
    
        --            
        OPEN @@c_access_cursor            
        FETCH NEXT FROM @@c_access_cursor INTO @l_from_range , @l_to_range            
        --            
        WHILE @@fetch_status = 0            
        BEGIN            
        --            
		 
          if @l_counter  = '1'
          begin 
          insert into @l_slip_list_final
          select min(slipno ),max(slipno) from #tempdata_final where slipno <= @l_from_range 
          end 
          else 
          begin 
          print @l_to_range
          insert into @l_slip_list_final
          select min(slipno ),max(slipno) from #tempdata_final where slipno <= @l_from_range  and slipno >= @l_last_id 
          end 
          
          set @l_last_id =   @l_to_range
           
          --          
          
          set @l_counter = @l_counter + 1 
            
          FETCH NEXT FROM @@c_access_cursor INTO @l_from_range , @l_to_range    
        --            
        END            
        
        
        CLOSE      @@c_access_cursor            
        DEALLOCATE @@c_access_cursor


insert into @l_slip_list_final
select min(slipno ),max(slipno) from #tempdata_final where slipno >= @l_last_id 
          
          



if @pa_auto_flg ='N'
begin 

--declare @l_used_slip_list varchar(8000)
--set @l_used_slip_list  ='' 
--select @l_used_slip_list   = @l_used_slip_list   + uses_slip_no + ';' from #tmp_usedslipdata 

--select 'Following Slip are used : '   + case when len(@l_used_slip_list) > 0 then substring(@l_used_slip_list,1,len(@l_used_slip_list)-1)  else @l_used_slip_list end as UsedSlip
--where @l_used_slip_list <>''

--declare @l_used_slip_list_block varchar(8000)
--set @l_used_slip_list_block  ='' 
--select @l_used_slip_list_block   = @l_used_slip_list_block   + convert(varchar,slipno )+ ';' from @l_slip_list_cancel 

--select 'Following Slip are blocked : '   + case when len(@l_used_slip_list_block)>0 
--then  substring(@l_used_slip_list_block,1,len(@l_used_slip_list_block)-1) else @l_used_slip_list_block end as BlockedSlip
--where @l_used_slip_list_block <>''

 
declare @l_cancel_slip_list varchar(8000)
set @l_cancel_slip_list ='' 
select @l_cancel_slip_list   = @l_cancel_slip_list   +  ' <BR> From Slip : '  
+ convert(varchar,from_slipno ) + ' To ' +  convert(varchar,to_slipno  )+ ';' 
from @l_slip_list_final 

SELECT 'FOLLOWING RANGE SLIP FOUND TO BE UNUSED , DO YOU WANT TO BLOCK THESE SLIP BEFORE ASSIGNING NEW ONE? CLICK ON OK FOR BLOCK AND APPROVE OR CLICK ON CANCEL TO CANCEL PROCESS: ' + CASE WHEN LEN( @L_CANCEL_SLIP_LIST ) > 0 
THEN SUBSTRING(@L_CANCEL_SLIP_LIST,1,LEN(@L_CANCEL_SLIP_LIST)-1)
 ELSE @L_CANCEL_SLIP_LIST END AS RANGESLIP WHERE @L_CANCEL_SLIP_LIST <> '' 
 
end 
else if @pa_auto_flg ='Y'
begin 

declare @@c_access_cursor_save cursor 
declare @l_from_slip_no_cancel_save numeric
, @l_to_slip_no_cancel_save numeric

select from_slipno ,to_slipno  
from @l_slip_list_final


SET @@c_access_cursor_save =  CURSOR fast_forward FOR            
select from_slipno ,to_slipno  
from @l_slip_list_final



OPEN @@c_access_cursor_save             
FETCH NEXT FROM @@c_access_cursor_save  INTO @l_from_slip_no_cancel_save , @l_to_slip_no_cancel_save            
--            
WHILE @@fetch_status = 0            
BEGIN            
--         
print @l_from_slip_no_cancel_save
declare @l_EXCSM_ID NUMERIC,
	@l_ACTION VARCHAR(50),
	@l_TRXINIT_FLG VARCHAR(5),
	@l_CANCEL_REASON VARCHAR(100),
	@l_CANCEL_DT DATETIME,
	@l_BOOK_NO VARCHAR(100),
	@l_FROM_SLIP VARCHAR(30),
	@l_TO_SLIP VARCHAR(30),
	@l_REMARKS VARCHAR(500),
	@l_LOGIN_NAME VARCHAR(150),
	@l_TRXTYPE VARCHAR(50), 
	@l_SERIES_TYPE VARCHAR(50),
	@l_USES_ID NUMERIC,
	@l_ACCOUNT_ID VARCHAR(16),
	@l_AUTO_FLG VARCHAR(1),
	@l_ERRMSG VARCHAR(8000)
	--print 'rerere	'
	--print @l_FROM_SLIP
	--print @l_TO_SLIP
	--select top 1 slibm_book_name from slip_book_mstr 
	--where @l_FROM_SLIP between SLIBM_FROM_NO and SLIBM_to_NO
	--and @l_TO_SLIP between SLIBM_FROM_NO and SLIBM_to_NO
	   
	print @pa_values
	set @l_EXCSM_ID = citrus_usr.fn_splitval_by(@pa_values,1,'|')
	set @l_ACTION ='INS'
	set @l_TRXINIT_FLG  = citrus_usr.fn_splitval_by(@pa_values,2,'|')
	set @l_CANCEL_REASON = citrus_usr.fn_splitval_by(@pa_values,3,'|')
	set @l_CANCEL_DT = convert(varchar(11),convert(datetime,citrus_usr.fn_splitval_by(@pa_values,4,'|'),103),109)
	select top 1 @l_BOOK_NO  = slibm_book_name from slip_book_mstr 
	where @l_from_slip_no_cancel_save between SLIBM_FROM_NO and SLIBM_to_NO
	and @l_to_slip_no_cancel_save between SLIBM_FROM_NO and SLIBM_to_NO
	set @l_FROM_SLIP =@l_from_slip_no_cancel_save
	set @l_TO_SLIP =@l_to_slip_no_cancel_save
	set @l_REMARKS =citrus_usr.fn_splitval_by(@pa_values,6,'|')
	set @l_LOGIN_NAME =citrus_usr.fn_splitval_by(@pa_values,7,'|')
	set @l_TRXTYPE =citrus_usr.fn_splitval_by(@pa_values,8,'|')
	set @l_SERIES_TYPE =citrus_usr.fn_splitval_by(@pa_values,9,'|')
	set @l_USES_ID =citrus_usr.fn_splitval_by(@pa_values,10,'|')
	set @l_ACCOUNT_ID =citrus_usr.fn_splitval_by(@pa_values,11,'|')
	set @l_AUTO_FLG  =''
	set @l_ERRMSG = ''
	
	print @l_BOOK_NO
print @l_FROM_SLIP
print @l_TO_SLIP
	
	 exec  [PR_INS_UPD_DIS_CANCELLATION]  @l_EXCSM_ID ,
	@l_ACTION ,
	@l_TRXINIT_FLG ,
	@l_CANCEL_REASON ,
	@l_CANCEL_DT ,
	@l_BOOK_NO ,
	@l_FROM_SLIP ,
	@l_TO_SLIP ,
	@l_REMARKS ,
	@l_LOGIN_NAME ,
	@l_TRXTYPE , 
	@l_SERIES_TYPE ,
	@l_USES_ID ,
	@l_ACCOUNT_ID ,
	@l_AUTO_FLG ,
	@l_ERRMSG 
	

 
    
        FETCH NEXT FROM @@c_access_cursor_save  INTO @l_from_slip_no_cancel_save , @l_to_slip_no_cancel_save                
--
END  

CLOSE      @@c_access_cursor_save             
DEALLOCATE @@c_access_cursor_save 




end 


drop table #tmp_usedslipdata
drop table #tempdata_final


end

GO
