-- Object: PROCEDURE citrus_usr.Pr_ValidateAccount_new_bak_14062012
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

--Pr_ValidateAccount  '3','1203330004587963',1,'12033300',''    
--Pr_ValidateAccount_new '3','57',1,'','' ,'' 

create Proc [citrus_usr].[Pr_ValidateAccount_new_bak_14062012]          
@pa_excsmid int,          
@pa_acct_no varchar(50),          
@pa_login_pr_entm_id numeric,       
@pa_login_entm_cd_chain varchar(8000),
@pa_dpm_dpid varchar(8),       
@pa_ref_cur varchar(8000) output        
        
as             
begin          
 declare @@dpmid int          
        ,@l_exch_cd varchar(10)      
		,@@sbano varchar(8000)
        ,@count  varchar(20) 
, @@l_child_entm_id numeric
set @@sbano ='' 
 select @@dpmid = dpm_id from dp_mstr where default_dp = @pa_excsmid and dpm_deleted_ind =1      
 select @l_exch_cd =  excsm_exch_cd from exch_seg_mstr where excsm_id = @pa_excsmid and excsm_deleted_ind =1                                                
--

return 

select @@l_child_entm_id    =  citrus_usr.fn_get_child(@pa_login_pr_entm_id , @pa_login_entm_cd_chain)
      
                  
CREATE TABLE #ACLIST(dpam_crn_no BIGINT,dpam_id BIGINT,dpam_sba_no VARCHAR(16),dpam_sba_name VARCHAR(150),eff_from DATETIME,eff_to DATETIME,group_cd bigint, dpam_stam_Cd varchar(20))  

if @pa_login_pr_entm_id = 1 
begin 

INSERT INTO #ACLIST(dpam_crn_no,dpam_id,dpam_sba_no,dpam_sba_name,eff_from,eff_to,dpam_stam_Cd)   
SELECT dpam_crn_no, DPAM_ID,dpam_sba_no,dpam_sba_name,ENTR_FROM_DT,ENTR_TO_DT   , dpam_stam_Cd
FROM dp_acct_mstr , entity_relationship 
where entr_sba = dpam_sba_no 
and dpam_dpm_id = @@dpmid
and entr_ho = @pa_login_pr_entm_id
and entr_deleted_ind = 1 
and dpam_deleted_ind = 1 
--and case when @pa_acct_no  ='' then '' else dpam_sba_no end like '%' + case when @pa_acct_no  ='' then '' else @pa_acct_no end  
and case when @pa_acct_no  ='' then '' else dpam_sba_no end = case when @pa_acct_no  ='' then '' else @pa_acct_no end  

  
end 
else 
begin 

INSERT INTO #ACLIST(dpam_crn_no,dpam_id,dpam_sba_no,dpam_sba_name,eff_from,eff_to,dpam_stam_Cd)   
SELECT dpam_crn_no, DPAM_ID,dpam_sba_no,dpam_sba_name,EFF_FROM,EFF_TO   , dpam_stam_Cd
FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id)    

end 

print 'dsdsdsds'
print len(@pa_acct_no)
if len(@pa_acct_no) in (2,3,4,5)
begin


    if exists(select dpam_sba_no from #ACLIST
   	where case when len(@pa_acct_no) = 3 then right(dpam_sba_no,3)
when len(@pa_acct_no) = 2 then right(dpam_sba_no,2)
when len(@pa_acct_no) = 4 then right(dpam_sba_no,4)
when len(@pa_acct_no) = 5 then right(dpam_sba_no,5)end = @pa_acct_no 
	and dpam_stam_cd = 'active' 
	--and dpam_excsm_id = @pa_excsmid
	--and dpam_deleted_ind = 1
)
	begin
		select @@sbano = @@sbano + dpam_sba_no + '|' from #ACLIST
   		where case when len(@pa_acct_no) = 3 then right(dpam_sba_no,3)
when len(@pa_acct_no) = 2 then right(dpam_sba_no,2)
when len(@pa_acct_no) = 4 then right(dpam_sba_no,4)
when len(@pa_acct_no) = 5 then right(dpam_sba_no,5)end  = @pa_acct_no 
		and dpam_stam_cd = 'active' 
		--and dpam_excsm_id = @pa_excsmid
		--and dpam_deleted_ind = 1

        select @count = count(dpam_sba_no) from #ACLIST
   		where case when len(@pa_acct_no) = 3 then right(dpam_sba_no,3)
		when len(@pa_acct_no) = 2 then right(dpam_sba_no,2)
		when len(@pa_acct_no) = 4 then right(dpam_sba_no,4)
		when len(@pa_acct_no) = 5 then right(dpam_sba_no,5)end = @pa_acct_no 
		and dpam_stam_cd = 'active' 
		--and dpam_excsm_id = @pa_excsmid
		--and dpam_deleted_ind = 1
        
		print @@sbano
       
		select isnull(@count + '|' + @@sbano,'') Msg		
	end
	else
	   begin
			select  'Account Does Not Exist' Msg			
       end
end 
--
else
begin    

--if @l_exch_cd  = 'CDSL'      
--     set @pa_acct_no = @pa_dpm_dpid + @pa_acct_no                      
        
  if exists(select top 1 dpam_id from dp_acct_mstr where dpam_sba_no = @pa_acct_no  and dpam_dpm_id = @@dpmid and dpam_deleted_ind = 1)          
  begin          
	if @pa_login_pr_entm_id <> 1 
	begin 
     if not exists(SELECT top 1 dpam_sba_no FROM citrus_usr.fn_acct_list(@@dpmid ,@pa_login_pr_entm_id,@@l_child_entm_id) where dpam_sba_no =@pa_acct_no)          
     begin          
     Select 'Account does not fall under your access heirarchy level' Msg          
     end          
	end 

  end          
  else          
  begin          
  Select 'Invalid Account - Account does not exist'  Msg        
  end          
end  
end

GO
