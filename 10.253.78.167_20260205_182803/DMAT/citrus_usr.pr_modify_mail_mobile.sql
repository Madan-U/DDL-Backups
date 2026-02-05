-- Object: PROCEDURE citrus_usr.pr_modify_mail_mobile
-- Server: 10.253.78.167 | DB: DMAT
--------------------------------------------------

--begin tran
--pr_modify_mail_mobile '4','EDT','358211|*~|8|*~|00001111|*~|2323231111|*~|a00@a00.a00|*~|a11@a11.a11|*~|a00@a00.a00|*~|a22@a22.com|*~|*|~*	', '', '','','',''					
--exec valid_count_mobile   '9820580206' ,''
--exec valid_count_email    'BHAVIN.SHAH@MKTTECHNOLOGIES.COM' ,''
--pr_modify_mail_mobile '1','SELECT','','jul 01 2009','jul 31 2009','1','9999999999999999',''
--pr_modify_mail_mobile '1','EDT','355471|*~|123456|*~|9820580206|*~|1111111111|*~|BHAVIN.SHAH@MKTTECHNOLOGIES.COM|*~|tushar.patel.sw1@gmail.com|*~|*|~*','','','','',''
--rollback
CREATE procedure [citrus_usr].[pr_modify_mail_mobile](@pa_id numeric
,@pa_action varchar(20)
,@pa_values varchar(8000)
,@pa_from_dt datetime
,@pa_to_dt datetime
,@pa_from_no varchar(100)
,@pa_to_no varchar(100)
,@pa_out varchar(1000) out
)
as
begin
SET NOCOUNT ON   
	IF @pa_from_no = ''                    
	BEGIN                    
		SET @pa_from_no = '0'                    
		SET @pa_to_no = '99999999999999999'                    
	END                    
	IF @pa_to_no = ''                    
	BEGIN                
		SET @pa_to_no = @pa_from_no                    
	END  

	if @pa_action = 'SELECT'
	begin
	select dpam_id, dpam_crn_no, dpam_acct_no 
	,  dpam_sba_name 
	,  isnull(citrus_usr.fn_conc_value(dpam_crn_no , 'MOBILE1'),'') Mobile 
	,  isnull(citrus_usr.fn_conc_value(dpam_crn_no , 'EMAIL1'),'')  Mail
    ,  isnull(citrus_usr.fn_conc_value(dpam_crn_no , 'EMAIL2'),'')  Mail2
	from dp_acct_mstr where isnull(dpam_batch_no,'0') = '0' 
    and  dpam_acct_no between @pa_from_no and @pa_to_no 
    and  dpam_created_dt between @pa_from_dt and @pa_to_dt
	end 
	if @pa_action = 'EDT'
	begin

	create table #temp_client_conc_dtls(dpam_crn_no numeric, dp_acct_no varchar(100),old_mobile varchar(25),new_mobile varchar(25),old_email varchar(100),new_email varchar(100),old_email2 varchar(100),new_email2 varchar(100))

	declare @l_count numeric
	, @l_counter numeric


    declare @c_dpam_crn_no numeric, @c_dp_acct_no varchar(100),@c_old_mobile varchar(25),@c_new_mobile varchar(25),@c_old_email varchar(100),@c_new_email varchar(100),@c_old_email2 varchar(100),@c_new_email2 varchar(100)

	set @l_counter = 1

	set @l_count = citrus_usr.ufn_countstring(@pa_values,'*|~*')

		while @l_counter <= @l_count
		begin

		insert into #temp_client_conc_dtls
		select citrus_usr.fn_splitval(citrus_usr.fn_splitval_row(@pa_values,@l_counter),1)
		,citrus_usr.fn_splitval(citrus_usr.fn_splitval_row(@pa_values,@l_counter),2)
		,citrus_usr.fn_splitval(citrus_usr.fn_splitval_row(@pa_values,@l_counter),3)
        ,citrus_usr.fn_splitval(citrus_usr.fn_splitval_row(@pa_values,@l_counter),4)
     	,citrus_usr.fn_splitval(citrus_usr.fn_splitval_row(@pa_values,@l_counter),5)
        ,citrus_usr.fn_splitval(citrus_usr.fn_splitval_row(@pa_values,@l_counter),6)
        ,citrus_usr.fn_splitval(citrus_usr.fn_splitval_row(@pa_values,@l_counter),7)
        ,citrus_usr.fn_splitval(citrus_usr.fn_splitval_row(@pa_values,@l_counter),8)


		set @l_counter  =  @l_counter  +  1

		end  
       
        declare @c_cli_dtls cursor

        declare @L_CONC varchar(8000)
        set @L_CONC  = '' 
        set    @c_cli_dtls = CURSOR FAST_FORWARD FOR   
        select * from   #temp_client_conc_dtls  

        OPEN @c_cli_dtls 
    
        fetch next from @c_cli_dtls
        into @c_dpam_crn_no 
            ,@c_dp_acct_no 
            ,@c_old_mobile  
            ,@c_new_mobile 
            ,@c_old_email 
            ,@c_new_email 
			,@c_old_email2
			,@c_new_email2

	   while @@fetch_status = 0    
	   begin     

        
        if 1 < (select count(distinct entac_ent_id) from entity_adr_conc , contact_channels where entac_adr_conc_id = conc_id and conc_value  = @c_old_email and ENTAC_CONCM_CD = 'EMAIL1' and conc_value <> '')
        begin
           print 'NO ACTION'
        end 
        else if 1 =  (select count(distinct entac_ent_id) from entity_adr_conc , contact_channels where entac_adr_conc_id = conc_id and conc_value  = @c_old_email and ENTAC_CONCM_CD = 'EMAIL1' and conc_value <> '')
        begin
print 'Direct Update'
		   update contact_channels 
		   set conc_value = @c_new_email
           from entity_adr_conc , contact_channels 
           where conc_id       = entac_adr_conc_id 
           and  entac_concm_cd = 'EMAIL1'
           and  entac_ent_id   = @c_dpam_crn_no
           and  conc_value     = @c_old_email
        end    
        else 
        begin
print 'procedure Update'
            if  @c_new_email <> ''
            SELECT @L_CONC = 'EMAIL1|*~|'+@c_new_email+'*|~*' if  @c_new_email <> ''
            if @L_CONC <> ''
            EXEC pr_ins_upd_conc @c_dpam_crn_no,'EDT','MIG',@c_dpam_crn_no,'',@L_CONC,0,'*|~*','|*~|',''    

            set @L_CONC =''
        end 
  
        if 1 < (select count(distinct entac_ent_id) from entity_adr_conc , contact_channels where entac_adr_conc_id = conc_id and conc_value  = @c_old_email2 and ENTAC_CONCM_CD = 'EMAIL2' and conc_value <> '')
        begin
           print 'NO ACTION'
        end 
        else if 1 =  (select count(distinct entac_ent_id) from entity_adr_conc , contact_channels where entac_adr_conc_id = conc_id and conc_value  = @c_old_email2 and ENTAC_CONCM_CD = 'EMAIL2' and conc_value <> '')
        begin
print 'direct Update 2'
		   update contact_channels 
		   set conc_value = @c_new_email2
           from entity_adr_conc , contact_channels 
           where conc_id       = entac_adr_conc_id 
           and  entac_concm_cd = 'EMAIL2'
           and  entac_ent_id   = @c_dpam_crn_no
           and  conc_value     = @c_old_email2
        end    
        else 
        begin
print 'procedure Update 2'
            if  @c_new_email2 <> ''
            SELECT @L_CONC = 'EMAIL2|*~|'+@c_new_email2+'*|~*' if  @c_new_email2 <> ''
            if @L_CONC <> ''
            EXEC pr_ins_upd_conc @c_dpam_crn_no,'EDT','MIG',@c_dpam_crn_no,'',@L_CONC,0,'*|~*','|*~|',''    

            set @L_CONC =''
        end   

        if 1 < (select count(distinct entac_ent_id) from entity_adr_conc , contact_channels where entac_adr_conc_id = conc_id and conc_value  = @c_old_email and ENTAC_CONCM_CD = 'MOBILE1' and conc_value <> '')
        begin
           print 'NO ACTION'
        end 
        else if 1 =  (select count(distinct entac_ent_id) from entity_adr_conc , contact_channels where entac_adr_conc_id = conc_id and conc_value  = @c_old_email and ENTAC_CONCM_CD = 'MOBILE1' and conc_value <> '')
        begin
		   update contact_channels 
		   set conc_value = @c_new_mobile
           from entity_adr_conc , contact_channels 
           where conc_id       = entac_adr_conc_id 
           and  entac_concm_cd = 'MOBILE1'
           and  entac_ent_id   = @c_dpam_crn_no
           and  conc_value     = @c_old_mobile
        end    
        else 
        begin
           if  @c_new_mobile <> ''
            SELECT @L_CONC = 'MOBILE1|*~|'+@c_new_mobile+'*|~*' if  @c_new_mobile <> ''
            if @L_CONC <> ''
            EXEC pr_ins_upd_conc @c_dpam_crn_no,'EDT','MIG',@c_dpam_crn_no,'',@L_CONC,0,'*|~*','|*~|',''    

            set @L_CONC = ''
        end    


        fetch next from @c_cli_dtls
        into @c_dpam_crn_no 
            ,@c_dp_acct_no 
            ,@c_old_mobile  
            ,@c_new_mobile 
            ,@c_old_email 
            ,@c_new_email 
            ,@c_old_email2
			,@c_new_email2
   
       end  

	end 

end

GO
