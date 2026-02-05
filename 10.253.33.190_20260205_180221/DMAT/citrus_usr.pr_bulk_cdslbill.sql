-- Object: PROCEDURE citrus_usr.pr_bulk_cdslbill
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------


      
--exec [citrus_usr].[pr_bulk_cdslbill] 'tushar','12010900','1','bulk','nsccl','D:\BulkInsDbfolder\BLNG010924_BillingData_Jun12\10924NSCCL2012Jul01.txt','*|~*' ,'|*~|',''      
--exec [citrus_usr].[pr_bulk_cdslbill] 'tushar','12010900','1','bulk','off','D:\BulkInsDbfolder\BLNG010924_BillingData_Jun12\10924OffMkt Settlement Ann22012Jul01.txt','*|~*' ,'|*~|',''      
--exec [citrus_usr].[pr_bulk_cdslbill] 'tushar','12010900','1','bulk','on','D:\BulkInsDbfolder\BLNG010924_BillingData_Jun12\10924OnMkt Settlement2012Jul01.txt','*|~*' ,'|*~|',''      
--exec [citrus_usr].[pr_bulk_cdslbill] 'tushar','12010900','1','bulk','ep','C:\Documents and Settings\Administrator\Desktop\Tushar 07052012\24072012\BLNG010924_BillingData_Jun12\10924Early Payin2012Jul01.txt','*|~*' ,'|*~|',''      
--exec [citrus_usr].[pr_bulk_cdslbill] 'tushar','12010900','1','bulk','id','D:\BulkInsDbfolder\BLNG010924_BillingData_Jun12\10924OffMkt Settlement Ann12012Jul01.txt','*|~*' ,'|*~|',''      
      
CREATE proc [citrus_usr].[pr_bulk_cdslbill]      
(        
 @PA_LOGIN_NAME    VARCHAR(20)       
,@PA_DPMDPID       VARCHAR(20)          
,@PA_TASK_ID       NUMERIC      
,@PA_MODE          VARCHAR(10)                                          
,@pa_cdsl_bill     varchar(100)      
,@PA_DB_SOURCE     VARCHAR(250)          
,@ROWDELIMITER     CHAR(4) =     '*|~*'            
,@COLDELIMITER     CHAR(4) =     '|*~|'            
,@PA_ERRMSG        VARCHAR(8000) OUTPUT)      
      
as      
begin       
      
DECLARE @@SSQL VARCHAR(8000)        
set @@SSQL  = ''      
      
if @pa_cdsl_bill ='OFF'      
begin       
      
truncate table tmp_cdslbill_off       
        
        
         
  SET @@SSQL ='BULK INSERT tmp_cdslbill_off FROM ''' + @PA_DB_SOURCE + ''' WITH         
  (        
  FIELDTERMINATOR = ''~'',        
  ROWTERMINATOR = ''\n''        
      
  )'        
      
  EXEC(@@SSQL)      
      
delete a from cdslbill_off a where  billmonth in(select distinct month(convert(datetime,ctr_bo_id,103))  from tmp_cdslbill_off )      
and billyear in (select distinct year(convert(datetime,ctr_bo_id,103))  from tmp_cdslbill_off )
and exists(select boid from tmp_cdslbill_off b where a.boid = b.boid)      
      
insert into cdslbill_off      
select*  ,month(convert(datetime,ctr_bo_id,103)),year(convert(datetime,ctr_bo_id,103)), @PA_LOGIN_NAME
, getdate(),@PA_LOGIN_NAME, getdate(),1 from tmp_cdslbill_off      
      
select ctr_bo_id [date of trx],boid [Dp account],isin [ISIN],isin_name [ISIN Name], quantity [Qty]       
,bill_amount [CDSLCharge]      
,'' [mosl_charge]      
,isnull(entm_name1,'') [branch code]      
from tmp_cdslbill_off left outer join  entity_relationship on entr_sba =  boid       
and ctr_bo_id  between ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2100')      
left outer join  entity_mstr       
on    (entr_br = entm_id or entr_sb = entm_id )     

--delete a from cdslbill_off a where  billmonth in(select distinct month(convert(datetime,exe_dt,103))  from tmp_cdslbill_off )      
--and billyear in (select distinct year(convert(datetime,exe_dt,103))  from tmp_cdslbill_off )
--and exists(select boid from tmp_cdslbill_off b where a.boid = b.boid)      
--      
--insert into cdslbill_off      
--select*  ,month(convert(datetime,exe_dt,103)),year(convert(datetime,exe_dt,103)), @PA_LOGIN_NAME
--, getdate(),@PA_LOGIN_NAME, getdate(),1 from tmp_cdslbill_off      
--      
--select ctr_bo_id [date of trx],boid [Dp account],isin [ISIN],isin_name [ISIN Name], quantity [Qty]       
--,bill_amount [CDSLCharge]      
--,'' [mosl_charge]      
--,isnull(entm_name1,'') [branch code]      
--from tmp_cdslbill_off left outer join  entity_relationship on entr_sba =  boid       
--and exe_dt  between ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2100')      
--left outer join  entity_mstr       
--on    (entr_br = entm_id or entr_sb = entm_id )   
      
      
end
if @pa_cdsl_bill ='OFF2'      
begin       
      
truncate table tmp_cdslbill_off2       
        
        
         
  SET @@SSQL ='BULK INSERT tmp_cdslbill_off2 FROM ''' + @PA_DB_SOURCE + ''' WITH         
  (        
  FIELDTERMINATOR = ''~'',        
  ROWTERMINATOR = ''\n''        
      
  )'        
      
  EXEC(@@SSQL)      
      
delete a from cdslbill_off2 a  where  billmonth in(select distinct month(convert(datetime,exe_dt,103))  
from tmp_cdslbill_off2 )      
and billyear in (select distinct year(convert(datetime,exe_dt,103))  from tmp_cdslbill_off2 )      
 and exists(select boid  from tmp_cdslbill_off2 b where a.boid = b.boid)      
     
insert into cdslbill_off2      
select*  ,month(convert(datetime,exe_dt,103)),year(convert(datetime,exe_dt,103))
, @PA_LOGIN_NAME, getdate(),@PA_LOGIN_NAME, getdate(),1 from tmp_cdslbill_off2      
      
select exe_dt [date of trx],boid [Dp account],isin [ISIN],isin_name [ISIN Name], quantity [Qty]       
,bill_amount [CDSLCharge]      
,'' [mosl_charge]      
,isnull(entm_name1,'') [branch code]      
from tmp_cdslbill_off2 left outer join  entity_relationship on entr_sba =  boid       
and exe_dt  between ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2100')      
left outer join  entity_mstr       
on    (entr_br = entm_id or entr_sb = entm_id )      
      
      
end       
else if @pa_cdsl_bill ='EP'      
begin      
      
truncate table tmp_cdslbill_ep       
        
        
         
  SET @@SSQL ='BULK INSERT tmp_cdslbill_ep FROM ''' + @PA_DB_SOURCE + ''' WITH         
  (        
  FIELDTERMINATOR = ''~'',        
  ROWTERMINATOR = ''\n''        
      
  )'        
      
  EXEC(@@SSQL)       
      
delete a from cdslbill_ep a where  billmonth in(select distinct month(convert(datetime,exec_dt,103))  from tmp_cdslbill_ep )      
and billyear in (select distinct year(convert(datetime,exec_dt,103))  from tmp_cdslbill_ep )      
and exists(select fr_bo_id  from tmp_cdslbill_ep b where a.fr_bo_id = b.fr_bo_id)      

     
insert into cdslbill_ep      
select*  ,month(convert(datetime,exec_dt,103)),year(convert(datetime,exec_dt,103)), @PA_LOGIN_NAME, getdate(),@PA_LOGIN_NAME, getdate(),1 from tmp_cdslbill_ep      
      
select exec_dt [date of trx],fr_bo_id [Dp account],isin [ISIN],isin_name [ISIN Name], quantity [Qty]       
,bill_amt [CDSLCharge]      
,'' [mosl_charge]      
,isnull(entm_name1,'') [branch code] from tmp_cdslbill_ep      
left outer join  entity_relationship  on  entr_sba =  fr_bo_id and exec_dt between ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2100')       
left outer join  entity_mstr on    (entr_br = entm_id or entr_sb = entm_id )      
where bill_amt <> '0'  
      
      
       
      
end       
else if @pa_cdsl_bill ='on'      
begin      
      
truncate table tmp_cdslbill_on       
        
        
         
  SET @@SSQL ='BULK INSERT tmp_cdslbill_on FROM ''' + @PA_DB_SOURCE + ''' WITH         
  (        
  FIELDTERMINATOR = ''~'',        
  ROWTERMINATOR = ''\n''        
      
  )'        
      
  EXEC(@@SSQL)       
      
delete a from cdslbill_on a where  billmonth in(select distinct month(convert(datetime,exec_dt,103)) from tmp_cdslbill_on )      
and billyear in (select distinct year(convert(datetime,exec_dt,103))  from tmp_cdslbill_on )      
and exists(select boid  from tmp_cdslbill_on b where a.boid = b.boid)      
      
insert into cdslbill_on      
select*  ,month(convert(datetime,exec_dt,103)),year(convert(datetime,exec_dt,103)), @PA_LOGIN_NAME, getdate(),@PA_LOGIN_NAME, getdate(),1 from tmp_cdslbill_on      
      
select exec_dt [date of trx],boid [Dp account],isin [ISIN],isin_name [ISIN Name], qty [Qty]       
,bill_amount [CDSLCharge]      
,'' [mosl_charge]      
,isnull(entm_name1,'') [branch code]  from tmp_cdslbill_on      
left outer join  entity_relationship on entr_sba =  boid and  exec_dt  between ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2100')      
left outer join entity_mstr       
on    (entr_br = entm_id or entr_sb = entm_id )      
      
end       
else if @pa_cdsl_bill ='id'      
begin      
      
      
truncate table tmp_cdslbill_id       
        
        
         
  SET @@SSQL ='BULK INSERT tmp_cdslbill_id FROM ''' + @PA_DB_SOURCE + ''' WITH         
  (        
  FIELDTERMINATOR = ''~'',        
  ROWTERMINATOR = ''\n''        
      
  )'        
      
  EXEC(@@SSQL)       
      
delete a from cdslbill_id a where  billmonth in(select distinct month(convert(datetime,exe_date,103))  from tmp_cdslbill_id )      
and billyear in (select distinct year(convert(datetime,exe_date,103))  from tmp_cdslbill_id )      
 and exists(select boid from tmp_cdslbill_id b where a.boid = b.boid)      
     
      
insert into cdslbill_id      
select*  ,month(convert(datetime,exe_date,103)),year(convert(datetime,exe_date,103)), @PA_LOGIN_NAME, getdate(),@PA_LOGIN_NAME, getdate(),1 from tmp_cdslbill_id      
      
      
select exe_date [date of trx],boid [Dp account],isin [ISIN],isin_name [ISIN Name], qty [Qty]       
,bill_Amt [CDSLCharge]      
,'' [mosl_charge]      
,entm_name1 [branch code]  from tmp_cdslbill_id      
left outer join  entity_relationship on entr_sba =  boid       
and exe_date  between ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2100')      
left outer join  entity_mstr       
on    (entr_br = entm_id or entr_sb = entm_id )      
      
end       
else if @pa_cdsl_bill ='nsccl'      
begin      
      
      
      
      
truncate table tmp_cdslbill_nsccl       
        
        
         
  SET @@SSQL ='BULK INSERT tmp_cdslbill_nsccl FROM ''' +@PA_DB_SOURCE + ''' WITH         
  (        
  FIELDTERMINATOR = ''~'',        
  ROWTERMINATOR = ''\n''        
      
  )'        
      
  EXEC(@@SSQL)      
      
delete a from cdslbill_nsccl a where  billmonth in(select distinct month(convert(datetime,exe_date,103))  from tmp_cdslbill_nsccl )      
and billyear in (select distinct year(convert(datetime,exe_date,103))  from tmp_cdslbill_nsccl)      
  and exists(select bo_id  from tmp_cdslbill_nsccl b where a.bo_id = b.bo_id)      
     
       
insert into cdslbill_nsccl      
select*  ,month(convert(datetime,exe_date,103)),year(convert(datetime,exe_date,103)), @PA_LOGIN_NAME, getdate(),@PA_LOGIN_NAME, getdate(),1 from tmp_cdslbill_nsccl      
      
select exe_date [date of trx],bo_id [Dp account],isin [ISIN],isin_name [ISIN Name], qty [Qty]       
,bill_amount [CDSLCharge]      
,'' [mosl_charge]      
,entm_name1 [branch code]  from tmp_cdslbill_nsccl      
left outer join  entity_relationship on entr_sba =  bo_id       
and exe_date  between ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2100')      
left outer join  entity_mstr       
on    (entr_br = entm_id or entr_sb = entm_id )      
      
end       
      
      
else if @pa_cdsl_bill ='remat'      
begin      
      
      
      
      
truncate table tmp_cdslbill_remat       
        
        
         
  SET @@SSQL ='BULK INSERT tmp_cdslbill_remat FROM ''' + @PA_DB_SOURCE + ''' WITH         
  (        
  FIELDTERMINATOR = ''~'',       
  ROWTERMINATOR = ''\n''        
      
  )'        
      
  EXEC(@@SSQL)       
      
delete a from cdslbill_remat a  where  billmonth in(select distinct month(convert(datetime,execute_date,103))  from tmp_cdslbill_remat )      
and billyear in (select distinct year(convert(datetime,execute_date,103))  from tmp_cdslbill_remat)      
    and exists(select bo_id  from tmp_cdslbill_remat b where a.bo_id = b.bo_id)      
    
      
insert into cdslbill_remat      
select*  ,month(convert(datetime,execute_date,103)),year(convert(datetime,execute_date,103)), @PA_LOGIN_NAME, getdate(),@PA_LOGIN_NAME, getdate(),1 from tmp_cdslbill_remat      
      
select execute_date [date of trx],bo_id [Dp account],isin [ISIN],isin_name [ISIN Name], quantity [Qty]       
,bill_amount [CDSLCharge]      
,'' [mosl_charge]      
,entm_name1 [branch code]  from tmp_cdslbill_remat      
left outer join  entity_relationship on entr_sba =  bo_id       
and execute_date between ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2100')      
left outer join  entity_mstr       
on    (entr_br = entm_id or entr_sb = entm_id )      
      
end       
      
else if @pa_cdsl_bill ='cisa_closing_bal'      
begin      
      
      
      
      
truncate table tmp_cdslbill_cisa_clos_bal       
        
        
         
  SET @@SSQL ='BULK INSERT tmp_cdslbill_cisa_clos_bal FROM ''' + @PA_DB_SOURCE + ''' WITH         
  (        
  FIELDTERMINATOR = ''~'',        
  ROWTERMINATOR = ''\n''        
      
  )'        
      
  EXEC(@@SSQL)       
      
delete a from cdslbill_cisa_clos_bal a where  billmonth in(select distinct month(convert(datetime,exe_dt,103))  from tmp_cdslbill_cisa_clos_bal)      
and billyear in (select distinct year(convert(datetime,exe_dt,103))  from tmp_cdslbill_cisa_clos_bal)      
      and exists(select boid  from tmp_cdslbill_cisa_clos_bal b where a.boid = b.boid)      
    
      
insert into cdslbill_cisa_clos_bal      
select*  ,month(convert(datetime,exe_dt,103)),year(convert(datetime,exe_dt,103)), @PA_LOGIN_NAME, getdate(),@PA_LOGIN_NAME, getdate(),1 from tmp_cdslbill_cisa_clos_bal      
      
select exe_dt [date of trx],boid [Dp account],isin [ISIN],isin_name [ISIN Name], quantity [Qty]       
,bill_amt [CDSLCharge]      
,'' [mosl_charge]      
,isnull(entm_name1 ,'') [branch code]  from tmp_cdslbill_cisa_clos_bal      
left outer join  entity_relationship on entr_sba =  boid       
and exe_dt between ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2100')      
left outer join  entity_mstr       
on    (entr_br = entm_id or entr_sb = entm_id )      
      
end       
else if @pa_cdsl_bill ='cisa_ovrd_cr'      
begin      
      
      
      
      
truncate table tmp_cdslbill_cisa_ovrd_cr       
        
        
         
  SET @@SSQL ='BULK INSERT tmp_cdslbill_cisa_ovrd_cr FROM ''' + @PA_DB_SOURCE + ''' WITH         
  (        
  FIELDTERMINATOR = ''~'',        
  ROWTERMINATOR = ''\n''        
      
  )'        
      
  EXEC(@@SSQL)       
      
      
delete a  from cdslbill_cisa_ovrd_cr a  where  billmonth in(select distinct month(convert(datetime,dr_cr,103))  from tmp_cdslbill_cisa_ovrd_cr)      
and billyear in (select distinct year(convert(datetime,dr_cr,103))  from tmp_cdslbill_cisa_ovrd_cr)      
       and exists(select boid  from tmp_cdslbill_cisa_ovrd_cr b where a.boid = b.boid)      
     



      
insert into cdslbill_cisa_ovrd_cr      
select boid
,cm_id
,prod_no
,isin
,isin_name
,qty
,dr_cr
,dr_cr
,ctr_bo_prod_no
,isin_rate
,trans_value
,charge_rate
,bill_amt  ,month(convert(datetime,dr_cr,103))
,year(convert(datetime,dr_cr,103)), @PA_LOGIN_NAME
, getdate(),@PA_LOGIN_NAME, getdate(),1 
from tmp_cdslbill_cisa_ovrd_cr      
       

      
select dr_cr [date of trx],boid [Dp account],isin [ISIN],isin_name [ISIN Name], qty [Qty]       
,bill_amt [CDSLCharge]      
,'' [mosl_charge]      
,isnull(entm_name1 ,'')  [branch code]  from tmp_cdslbill_cisa_ovrd_cr      
left outer join  entity_relationship on entr_sba =  boid       
and dr_cr  between ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2100')      
left outer join  entity_mstr       
on    (entr_br = entm_id or entr_sb = entm_id )      
      
end       
else if @pa_cdsl_bill ='plg_setup_pledgor'      
begin      
      
      
      
      
truncate table tmp_cdslbill_pldg_setup_pledgor       
        
        
         
  SET @@SSQL ='BULK INSERT tmp_cdslbill_pldg_setup_pledgor FROM ''' + @PA_DB_SOURCE + ''' WITH         
  (        
  FIELDTERMINATOR = ''~'',        
  ROWTERMINATOR = ''\n''        
      
  )'        
      
  EXEC(@@SSQL)       
      
delete a from cdslbill_pldg_setup_pledgor a  where  billmonth in(select distinct month(convert(datetime,execute_date,103))  from tmp_cdslbill_pldg_setup_pledgor)      
and billyear in (select distinct year(convert(datetime,execute_date,103))  from tmp_cdslbill_pldg_setup_pledgor)      
       and exists(select pledgor_bo_id from  tmp_cdslbill_pldg_setup_pledgor b where a.pledgor_bo_id = b.pledgor_bo_id)      
      

      
insert into cdslbill_pldg_setup_pledgor      
select*  ,month(convert(datetime,execute_date,103)),year(convert(datetime,execute_date,103)), @PA_LOGIN_NAME, getdate(),@PA_LOGIN_NAME, getdate(),1 from tmp_cdslbill_pldg_setup_pledgor      
      
select execute_date [date of trx],pledgee_bo_id [Dp account],isin [ISIN],isin_name [ISIN Name], quantity [Qty]       
,pledgee_bill_amt [pledgeeCDSLCharge]      
,pledgor_bill_amt [pledgorCDSLCharge]      
,'' [mosl_charge]      
,isnull(entm_name1 ,'')  [branch code]  from tmp_cdslbill_pldg_setup_pledgor      
left outer join  entity_relationship on entr_sba =  pledgee_bo_id       
and execute_date between ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2100')      
left outer join  entity_mstr       
on    (entr_br = entm_id or entr_sb = entm_id )      
      
end       
else if @pa_cdsl_bill ='pldg_setup_pledgee'      
begin      
      
      
      
      
truncate table tmp_cdslbill_pldg_setup_pledgee       
        
        
         
  SET @@SSQL ='BULK INSERT tmp_cdslbill_pldg_setup_pledgee FROM ''' + @PA_DB_SOURCE + ''' WITH         
  (        
  FIELDTERMINATOR = ''~'',        
  ROWTERMINATOR = ''\n''        
      
  )'        
      
  EXEC(@@SSQL)       
       
delete a from cdslbill_pldg_setup_pledgee a where  billmonth in(select distinct month(convert(datetime,execute_date,103))  from tmp_cdslbill_pldg_setup_pledgee)      
and billyear in (select distinct year(convert(datetime,execute_date,103))  from tmp_cdslbill_pldg_setup_pledgee)      
        and exists(select pledgor_bo_id from  tmp_cdslbill_pldg_setup_pledgee b where a.pledgor_bo_id = b.pledgor_bo_id)      
     

      
insert into cdslbill_pldg_setup_pledgee      
select*  ,month(convert(datetime,execute_date,103)),year(convert(datetime,execute_date,103)), @PA_LOGIN_NAME, getdate(),@PA_LOGIN_NAME, getdate(),1 from tmp_cdslbill_pldg_setup_pledgee      
      
select execute_date [date of trx],pledgee_bo_id [Dp account],isin [ISIN],isin_name [ISIN Name], quantity [Qty]       
,pledgee_bill_amt [pledgeeCDSLCharge]      
,pledgor_bill_amt [pledgorCDSLCharge]      
,'' [mosl_charge]      
,isnull(entm_name1 ,'')  [branch code]  from tmp_cdslbill_pldg_setup_pledgee      
left outer join  entity_relationship on entr_sba =  pledgee_bo_id       
and execute_date  between ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2100')      
left outer join  entity_mstr       
on    (entr_br = entm_id or entr_sb = entm_id )      
      
      
end       
      
else if @pa_cdsl_bill ='pldg_inv_pledgor'      
begin      
      
      
      
      
truncate table tmp_cdslbill_pldg_inv_pledgor       
        
        
         
  SET @@SSQL ='BULK INSERT tmp_cdslbill_pldg_inv_pledgor FROM ''' + @PA_DB_SOURCE + ''' WITH         
  (        
  FIELDTERMINATOR = ''~'',        
  ROWTERMINATOR = ''\n''        
      
  )'        
      
  EXEC(@@SSQL)       
      
delete a from cdslbill_pldg_inv_pledgor a  where  billmonth in(select distinct month(convert(datetime,execute_date,103))  from tmp_cdslbill_pldg_inv_pledgor)      
and billyear in (select distinct year(convert(datetime,execute_date,103))  from tmp_cdslbill_pldg_inv_pledgor)      
         and exists(select pledgor_bo_id from  tmp_cdslbill_pldg_inv_pledgor b where a.pledgor_bo_id = b.pledgor_bo_id)      
     

      
insert into cdslbill_pldg_inv_pledgor      
select*  ,month(convert(datetime,execute_date,103)),year(convert(datetime,execute_date,103)), @PA_LOGIN_NAME, getdate(),@PA_LOGIN_NAME, getdate(),1 from tmp_cdslbill_pldg_inv_pledgor      
      
select execute_date [date of trx],pledgee_bo_id [Dp account],isin [ISIN],isin_name [ISIN Name], quantity [Qty]       
,pledgee_bill_amt [pledgeeCDSLCharge]      
,pledgor_bill_amt [pledgorCDSLCharge]      
,'' [mosl_charge]      
,isnull(entm_name1 ,'')  [branch code]  from tmp_cdslbill_pldg_inv_pledgor      
left outer join  entity_relationship on entr_sba =  pledgee_bo_id       
and execute_date  between ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2100')      
left outer join  entity_mstr       
on    (entr_br = entm_id or entr_sb = entm_id )      
      
end       
else if @pa_cdsl_bill ='pldg_inv_pledgee'      
begin      
      
      
      
      
truncate table tmp_cdslbill_pldg_inv_pledgee       
        
        
         
  SET @@SSQL ='BULK INSERT tmp_cdslbill_pldg_inv_pledgee FROM ''' + @PA_DB_SOURCE + ''' WITH         
  (        
  FIELDTERMINATOR = ''~'',        
  ROWTERMINATOR = ''\n''        
      
  )'        
      
  EXEC(@@SSQL)       
      
delete a from cdslbill_pldg_inv_pledgee a where  billmonth in(select distinct month(convert(datetime,execute_date,103))  from tmp_cdslbill_pldg_inv_pledgee)      
and billyear in (select distinct year(convert(datetime,execute_date,103))  from tmp_cdslbill_pldg_inv_pledgee)      
          and exists(select pledgee_bo_id from  tmp_cdslbill_pldg_inv_pledgee b where a.pledgee_bo_id = b.pledgee_bo_id)      
     
      
insert into cdslbill_pldg_inv_pledgee      
select*  ,month(convert(datetime,execute_date,103)),year(convert(datetime,execute_date,103)), @PA_LOGIN_NAME, getdate(),@PA_LOGIN_NAME, getdate(),1 from tmp_cdslbill_pldg_inv_pledgee      
      
select execute_date [date of trx],pledgee_bo_id [Dp account],isin [ISIN],isin_name [ISIN Name], quantity [Qty]       
,pledgee_bill_amt [pledgeeCDSLCharge]      
,pledgor_bill_amt [pledgorCDSLCharge]      
,'' [mosl_charge]      
,isnull(entm_name1 ,'')  [branch code]  from tmp_cdslbill_pldg_inv_pledgee      
left outer join  entity_relationship on entr_sba =  pledgee_bo_id       
and execute_date  between ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2100')      
left outer join  entity_mstr       
on    (entr_br = entm_id or entr_sb = entm_id )      
      
end       
else if @pa_cdsl_bill ='unpldg'      
begin      
      
      
      
      
truncate table tmp_cdslbill_unpldg       
        
        
         
  SET @@SSQL ='BULK INSERT tmp_cdslbill_unpldg FROM ''' + @PA_DB_SOURCE + ''' WITH         
  (        
  FIELDTERMINATOR = ''~'',        
  ROWTERMINATOR = ''\n''        
      
  )'        
      
  EXEC(@@SSQL)       

print @@SSQL
      
delete a from cdslbill_unpldg  a where  billmonth in(select distinct month(convert(datetime,execute_date,103))  from tmp_cdslbill_unpldg)      
and billyear in (select distinct year(convert(datetime,execute_date,103))  from tmp_cdslbill_unpldg)      
            and exists(select pledgor_bo_id from  tmp_cdslbill_unpldg b where a.pledgor_bo_id = b.pledgor_bo_id)      
    
      
insert into cdslbill_unpldg      
select*  ,month(convert(datetime,execute_date,103)),year(convert(datetime,execute_date,103)), @PA_LOGIN_NAME, getdate(),@PA_LOGIN_NAME, getdate(),1 from tmp_cdslbill_unpldg      
      
select execute_date [date of trx],pledgee_bo_id [Dp account],isin [ISIN],isin_name [ISIN Name], quantity [Qty]       
,pledgee_bill_amt [pledgeeCDSLCharge]      
,pledgor_bill_amt [pledgorCDSLCharge]      
,'' [mosl_charge]      
,isnull(entm_name1 ,'')  [branch code]  from tmp_cdslbill_unpldg      
left outer join  entity_relationship on entr_sba =  pledgee_bo_id       
and execute_date  between ENTR_FROM_DT and isnull(ENTR_TO_DT,'dec 31 2100')      
left outer join  entity_mstr       
on    (entr_br = entm_id or entr_sb = entm_id )      
      
end       
      
      
       
      
end

GO
