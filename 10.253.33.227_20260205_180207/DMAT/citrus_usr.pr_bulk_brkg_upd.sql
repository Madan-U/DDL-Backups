-- Object: PROCEDURE citrus_usr.pr_bulk_brkg_upd
-- Server: 10.253.33.227 | DB: DMAT
--------------------------------------------------

--
--pr_bulk_brkg_upd 'ALL','','3','4','dec 31 2008','jan 01 2009',0,''
--select * from brokerage_mstr
CREATE procedure [citrus_usr].[pr_bulk_brkg_upd](@pa_id                  varchar(8000)
                                 ,@pa_action             varchar(200)
                                 ,@pa_old_slab_no        varchar(20)
                                 ,@pa_new_slab_no        varchar(20)
                                 ,@pa_eff_to_dt_forold   datetime
                                 ,@pa_eff_from_dt_fornew datetime
                                 ,@pa_chk_yn             smallint
                                 ,@pa_out                varchar(8000) out)
as
begin
  if @pa_chk_yn = 0 
  begin
	if @pa_id ='ALL'
	begin

 		update clidb set clidb_eff_to_dt = @pa_eff_to_dt_forold 
        from client_dp_brkg clidb , dp_Acct_mstr 
        where clidb_dpam_id = dpam_id 
        and   clidb_brom_id   = @pa_old_slab_no

        insert into client_dp_brkg
		(CLIDB_DPAM_ID
		,CLIDB_BROM_ID
		,CLIDB_CREATED_BY
		,CLIDB_CREATED_DT
		,CLIDB_LST_UPD_BY
		,CLIDB_LST_UPD_DT
		,CLIDB_DELETED_IND
		,clidb_eff_from_dt
		,clidb_eff_to_dt)
        select  CLIDB_DPAM_ID
		,@pa_new_slab_no
        ,'MIG'
        ,getdate()
        ,'MIG'
        ,getdate()
        ,1
        ,@pa_eff_from_dt_fornew
        ,'dec 31 2009'
        from client_dp_brkg, dp_Acct_mstr 
        where clidb_dpam_id = dpam_id 
        and   clidb_brom_id   = @pa_old_slab_no
    
        
	end 
	else 
	begin
		print @pa_id 
	end
  end 
  else  if @pa_chk_yn = 2 
  begin
    if @pa_id ='ALL'
	begin
 		insert into clib_bulk_brkg
		(clidb_dpam_id
		,clidb_brom_id
		,clidb_eff_from_dt
		,clidb_eff_to_dt
		,clidb_created_by
		,clidb_created_dt
		,clidb_lst_upd_by
		,clidb_lst_upd_dt
		,clidb_deleted_ind) 
        select  CLIDB_DPAM_ID
		,@pa_OLD_slab_no
        ,clidb_eff_from_dt
        ,@pa_eff_to_dt_forold
        ,'MIG'
        ,getdate()
        ,'MIG'
        ,getdate()
        ,8
        from client_dp_brkg, dp_Acct_mstr 
        where clidb_dpam_id   = dpam_id 
        and   clidb_brom_id   = @pa_old_slab_no

        insert into clib_bulk_brkg
		(clidb_dpam_id
		,clidb_brom_id
		,clidb_eff_from_dt
		,clidb_eff_to_dt
		,clidb_created_by
		,clidb_created_dt
		,clidb_lst_upd_by
		,clidb_lst_upd_dt
		,clidb_deleted_ind) 
        select  CLIDB_DPAM_ID
		,@pa_NEW_slab_no
        ,@pa_eff_from_dt_fornew
        ,'DEC 31 2009'
        ,'MIG'
        ,getdate()
        ,'MIG'
        ,getdate()
        ,0
        from client_dp_brkg, dp_Acct_mstr 
        where clidb_dpam_id   = dpam_id 
        and   clidb_brom_id   = @pa_old_slab_no

	end 
	else 
	begin
		print @pa_id 
	end
  end  
  else  if @pa_chk_yn = 1 
  begin
    if @pa_id ='ALL'
	begin
 		update clidb set CLIDB.clidb_eff_to_dt = CLIBB.clidb_eff_to_dt 
        from client_dp_brkg clidb , dp_Acct_mstr , clib_bulk_brkg CLIBB
        where CLIDB.clidb_brom_id   = CLIBB.clidb_brom_id   
        AND   CLIDB.clidb_dpam_id = dpam_id 
        and   CLIDB.clidb_brom_id   = @pa_old_slab_no
        AND   CLIBB.CLIDB_DELETED_IND = 8

        INSERT INTO CLIB_MAK
        (clidb_dpam_id
		,clidb_brom_id
		,clidb_eff_from_dt
		,clidb_eff_to_dt
		,clidb_created_by
		,clidb_created_dt
		,clidb_lst_upd_by
		,clidb_lst_upd_dt
		,clidb_deleted_ind)
        SELECT clidb_dpam_id
		,clidb_brom_id
		,clidb_eff_from_dt
		,clidb_eff_to_dt
		,clidb_created_by
		,clidb_created_dt
		,clidb_lst_upd_by
		,clidb_lst_upd_dt
		,9 
         FROM clib_bulk_brkg CLIBB
         WHERE  CLIBB.CLIDB_DELETED_IND = 8 

        UPDATE CLIBB SET CLIBB.CLIDB_DELETED_IND = 9 FROM clib_bulk_brkg CLIBB 
        WHERE  CLIBB.CLIDB_DELETED_IND = 8 


        insert into client_dp_brkg
		(CLIDB_DPAM_ID
		,CLIDB_BROM_ID
		,CLIDB_CREATED_BY
		,CLIDB_CREATED_DT
		,CLIDB_LST_UPD_BY
		,CLIDB_LST_UPD_DT
		,CLIDB_DELETED_IND
		,clidb_eff_from_dt
		,clidb_eff_to_dt)
        select  CLIDB_DPAM_ID
		,clidb_brom_id
        ,'MIG'
        ,getdate()
        ,'MIG'
        ,getdate()
        ,1
        ,clidb_eff_from_dt
        ,'dec 31 2009'
        from  clib_bulk_brkg CLIBB,DP_ACCT_MSTR
        where clidb_dpam_id = dpam_id 
        AND   CLIBB.CLIDB_DELETED_IND  = 0  
  
          UPDATE CLIBB SET CLIBB.CLIDB_DELETED_IND = 1 FROM clib_bulk_brkg CLIBB 
        WHERE  CLIBB.CLIDB_DELETED_IND = 0 
 


	end 
	else 
	begin
		print @pa_id 
	end
  end  
end

GO
