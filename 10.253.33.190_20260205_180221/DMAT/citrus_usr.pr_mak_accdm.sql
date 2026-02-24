-- Object: PROCEDURE citrus_usr.pr_mak_accdm
-- Server: 10.253.33.190 | DB: DMAT
--------------------------------------------------

CREATE PROCEDURE [citrus_usr].[pr_mak_accdm](@pa_id               VARCHAR(8000)
                              ,@pa_action          VARCHAR(20)
                              ,@pa_login_name      VARCHAR(20)
                              ,@pa_accpm_prop_id   VARCHAR(20)
                              ,@pa_accdm_cd        VARCHAR(20)
                              ,@pa_accdm_rmks      VARCHAR(200)
                              ,@pa_accdm_desc      VARCHAR(100)
                              ,@pa_accdm_datatype  VARCHAR(5)
                              ,@pa_accdm_mdty      smallint   
                              ,@pa_chk_yn          INT
                              ,@rowdelimiter       CHAR(4) =  '*|~*'
                              ,@coldelimiter       CHAR(4) = '|*~|'
                              ,@pa_errmsg          VARCHAR(8000) OUTPUT
                            )
as
/*
*********************************************************************************
 system         : CITRUS
 module name    : pr_mak_accpdm
 description    : this procedure will contain the maker checker facility for account_property_dtls_mstr
 copyright(c)   : marketplace technologies pvt ltd.
 version history: 1.0
 vers.  author            date         reason
 -----  -------------     ----------   -------------------------------------------------
 1.0    Tushar patel      12-07-2007   initial version.
-----------------------------------------------------------------------------------*/
--
begin
--
set nocount on
--
declare @@t_errorstr        varchar(8000)
      , @l_saccdm_id        bigint
      , @l_accdm_id         bigint
      , @@l_error           bigint
      , @delimeter          varchar(10)
      , @@remainingstring   varchar(8000)
      , @@currstring        varchar(8000)
      , @@foundat           integer
      , @@delimeterlength   int

set @@l_error         = 0
set @@t_errorstr      = ''
set @delimeter        = '%'+ @rowdelimiter + '%'
set @@delimeterlength = len(@rowdelimiter)
set @@remainingstring = @pa_id
--
while @@remainingstring <> ''
begin
  --
  set @@foundat = 0
  set @@foundat = patindex('%'+@delimeter+'%',@@remainingstring)
  --
  if @@foundat > 0
  begin
    --
    set @@currstring      = substring(@@remainingstring, 0,@@foundat)
    set @@remainingstring = substring(@@remainingstring, @@foundat+@@delimeterlength, len(@@remainingstring)- @@foundat+@@delimeterlength)
    --
  end
  else
  begin
    --
    set @@currstring      = @@remainingstring
    set @@remainingstring = ''
    --
  end
  --
  if @@currstring <> ''
  begin
    --
    if @pa_action = 'INS'  --action type = ins begins here
    begin
      --
      if @pa_chk_yn = 0 -- if maker checker functionality is not reqd
      begin
        --
        begin transaction
        --
        select @l_accdm_id = isnull(max(accdm_id),0)+1
        from   accpm_dtls_mstr with (nolock)
        --
        insert into accpm_dtls_mstr
        (accdm_id
        ,accdm_accpm_prop_id
        ,accdm_cd
        ,accdm_desc
        ,accdm_rmks
        ,accdm_created_by
        ,accdm_created_dt
        ,accdm_lst_upd_by
        ,accdm_lst_upd_dt
        ,accdm_deleted_ind
        ,accdm_datatype
        ,accdm_mdty
        )
        values
        (@l_accdm_id
        ,@pa_accpm_prop_id
        ,@pa_accdm_cd
        ,@pa_accdm_desc
        ,@pa_accdm_rmks
        ,@pa_login_name
        ,getdate()
        ,@pa_login_name
        ,getdate()
        ,1
        ,@pa_accdm_datatype
        ,CONVERT(smallint, @pa_accdm_mdty)
        )
        --
        set @@l_error = @@error
        --
        if @@l_error > 0
        begin
        --
          rollback transaction
          --
          set @@t_errorstr = isnull(@@t_errorstr,'')+convert(varchar,@@currstring)+@coldelimiter+convert(varchar,@pa_accpm_prop_id)+@coldelimiter+@pa_accdm_cd+@coldelimiter+@pa_accdm_desc+@coldelimiter+isnull(@pa_accdm_rmks,'')+@coldelimiter+@pa_accdm_datatype+@coldelimiter+@coldelimiter+convert(varchar,@pa_accdm_mdty)+@coldelimiter+convert(varchar, @@l_error)+@rowdelimiter
        --
        end
        else
        begin
        --
          commit transaction
        --
        end
      --
      end
      --
      if @pa_chk_yn = 1 -- if maker is inserting
      begin
        --
        begin transaction
        --
        select @l_saccdm_id = isnull(max(sm.accdm_id),0) + 1
             , @l_accdm_id  = isnull(max(s.accdm_id),0) + 1
        from   accdm_mak       sm with (nolock)
             , accpm_dtls_mstr s      with (nolock)
        --
        if @l_saccdm_id > @l_accdm_id
        begin
          --
          set @l_accdm_id = @l_saccdm_id
          --
        end
        --
        insert into accdm_mak
        (accdm_id
        ,accdm_accpm_prop_id
        ,accdm_cd
        ,accdm_desc
        ,accdm_rmks
        ,accdm_created_by
        ,accdm_created_dt
        ,accdm_lst_upd_by
        ,accdm_lst_upd_dt
        ,accdm_deleted_ind
        ,accdm_datatype
        ,accdm_mdty
        )
        values
        (@l_accdm_id
        ,@pa_accpm_prop_id
        ,@pa_accdm_cd
        ,@pa_accdm_desc
        ,@pa_accdm_rmks
        ,@pa_login_name
        ,getdate()
        ,@pa_login_name
        ,getdate()
        ,0
        ,@pa_accdm_datatype
        ,convert(smallint, @pa_accdm_mdty)
        )
        --
        set @@l_error = @@error
        --
        if @@l_error > 0
        begin
        --
         set @@t_errorstr = isnull(@@t_errorstr,'')+convert(varchar,@@currstring)+@coldelimiter+convert(varchar,@pa_accpm_prop_id)+@coldelimiter+@pa_accdm_cd+@coldelimiter+@pa_accdm_desc+@coldelimiter+isnull(@pa_accdm_rmks,'')+@coldelimiter+@pa_accdm_datatype+@coldelimiter+convert(varchar,@pa_accdm_mdty)+@coldelimiter+convert(varchar, @@l_error)+@rowdelimiter
         --
         rollback transaction
        --
        end
        else
        begin
        --
          commit transaction
        --
        end
      --
      end
     --
    end

    if @pa_action = 'APP'
    begin
      --
      if exists(select accdm_id
                from   accpm_dtls_mstr  with (nolock)
                where  accdm_id = convert(int,@@currstring))
      begin
        --
        begin transaction
        --
        update accdm                       with (rowlock)
        set    accdm.accdm_accpm_prop_id = accdmm.accdm_accpm_prop_id
             , accdm.accdm_cd            = accdmm.accdm_cd
             , accdm.accdm_desc          = accdmm.accdm_desc
             , accdm.accdm_rmks          = accdmm.accdm_rmks
             , accdm_datatype            = accdmm.accdm_datatype
             , accdm.accdm_mdty          = accdmm.accdm_mdty
             , accdm.accdm_lst_upd_by    = @pa_login_name
             , accdm.accdm_lst_upd_dt    = getdate()
             , accdm.accdm_deleted_ind   = 1
        from   accpm_dtls_mstr accdm
             , accdm_mak       accdmm
        where  accdm.accdm_id            = convert(int,@@currstring)
        and    accdmm.accdm_deleted_ind  = 0
        and    accdmm.accdm_created_by  <> @pa_login_name
        --
        set @@l_error = @@error
        --
        if @@l_error > 0
        begin
        --
          select @@t_errorstr      = isnull(@@t_errorstr,'')+convert(varchar,@@currstring)+@coldelimiter+isnull(convert(varchar,accdm_accpm_prop_id),'')+@coldelimiter+isnull(accdm_cd,'')+@coldelimiter+isnull(accdm_desc,'')+@coldelimiter+isnull(accdm_rmks,'')+@coldelimiter+accdm_datatype+@coldelimiter+convert(varchar,accdm_mdty)+@coldelimiter+convert(varchar, @@l_error)+@rowdelimiter
          from   accdm_mak with (nolock)
          where  accdm_id          = @@currstring
          and    accdm_deleted_ind = 0
          --
          rollback transaction
        --
        end
        else
        begin
        --
          update accdm_mak  with (rowlock)
          set    accdm_deleted_ind = 1
                ,accdm_lst_upd_by  = @pa_login_name
                ,accdm_lst_upd_dt  = getdate()
          where  accdm_id          = convert(int,@@currstring)
          and    accdm_created_by <> @pa_login_name
          and    accdm_deleted_ind = 0
          --
          set @@l_error = @@error
          --
          if @@l_error > 0
          begin
          --
            select @@t_errorstr    = isnull(@@t_errorstr,'')+convert(varchar,@@currstring)+@coldelimiter+isnull(convert(varchar,accdm_accpm_prop_id),'')+@coldelimiter+isnull(accdm_cd,'')+@coldelimiter+isnull(accdm_desc,'')+@coldelimiter+isnull(accdm_rmks,'')+@coldelimiter+accdm_datatype+@coldelimiter+convert(varchar,accdm_mdty)+@coldelimiter+convert(varchar, @@l_error)+@rowdelimiter
            from  accdm_mak          with (nolock)
            where accdm_id         = convert(int,@@currstring)
            and   accdm_deleted_ind = 0
            --
            rollback transaction
          --
          end
          else
          begin
            --
            commit transaction
            --
          end
         --
        end
       --
      end     --if record exist ends
      else
      begin
        --
        begin transaction
        --
        insert into accpm_dtls_mstr
        (accdm_id
        ,accdm_accpm_prop_id
        ,accdm_cd
        ,accdm_desc
        ,accdm_rmks
        ,accdm_created_by
        ,accdm_created_dt
        ,accdm_lst_upd_by
        ,accdm_lst_upd_dt
        ,accdm_deleted_ind
        ,accdm_datatype
        ,accdm_mdty
        )
        select accdmm.accdm_id
             , accdmm.accdm_accpm_prop_id
             , accdmm.accdm_cd
             , accdmm.accdm_desc
             , accdmm.accdm_rmks
             , accdmm.accdm_created_by
             , accdmm.accdm_created_dt
             , @pa_login_name
             , getdate()
             , 1
             , accdmm.accdm_datatype
             , accdmm.accdm_mdty
        from   accdm_mak                  accdmm  with (nolock)
        where  accdmm.accdm_id          = convert(int,@@currstring)
        and    accdmm.accdm_created_by <> @pa_login_name
        and    accdmm.accdm_deleted_ind = 0
        --
        set @@l_error = @@error
        --
        if @@l_error > 0
        begin
          --
          select @@t_errorstr      = isnull(@@t_errorstr,'')+convert(varchar,@@currstring)+@coldelimiter+isnull(convert(varchar,accdm_accpm_prop_id),'')+@coldelimiter+isnull(accdm_cd,'')+@coldelimiter+isnull(accdm_desc,'')+@coldelimiter+isnull(accdm_rmks,'')+@coldelimiter+accdm_datatype+@coldelimiter+convert(varchar,accdm_mdty)+@coldelimiter+convert(varchar, @@l_error)+@rowdelimiter
          from   accdm_mak  with (nolock)
          where  accdm_id          = @@currstring
          and    accdm_deleted_ind = 0
          --
          rollback transaction
          --
        end
        else
        begin
          --
          update accdm_mak  with (rowlock)
          set    accdm_deleted_ind = 1
                ,accdm_lst_upd_by  = @pa_login_name
                ,accdm_lst_upd_dt  = getdate()
          where  accdm_id          = convert(int,@@currstring)
          and    accdm_created_by <> @pa_login_name
          and    accdm_deleted_ind = 0
          --
          set @@l_error = @@error
          --
          if @@l_error > 0
          begin
            --
            select @@t_errorstr    = isnull(@@t_errorstr,'')+convert(varchar,@@currstring)+@coldelimiter+isnull(convert(varchar,accdm_accpm_prop_id),'')+@coldelimiter+isnull(accdm_cd,'')+@coldelimiter+isnull(accdm_desc,'')+@coldelimiter+isnull(accdm_rmks,'')+@coldelimiter+accdm_datatype+@coldelimiter+convert(varchar,accdm_mdty)+@coldelimiter+convert(varchar, @@l_error)+@rowdelimiter
            from  accdm_mak  with (nolock)
            where accdm_id         = convert(int,@@currstring)
            and   accdm_deleted_ind = 0
            --
            rollback transaction
            --
          end
          else
          begin
            --
            commit transaction
            --
          end
          --
        end
        --
      end
      --
    end

    if @pa_action = 'REJ'  
    begin
      --
      if @pa_chk_yn = 1 -- if cheker is rejecting
      begin
        --
        begin transaction
        --
        update accdm_mak  with (rowlock)
        set    accdm_deleted_ind = 3
             , accdm_lst_upd_by  = @pa_login_name
             , accdm_lst_upd_dt  = getdate()
        where  accdm_id          = convert(int,@@currstring)
        and    accdm_deleted_ind = 0
        --
        set @@l_error = @@error
        --
        if @@l_error > 0
        begin
          --
          select @@t_errorstr   = isnull(@@t_errorstr,'')+convert(varchar,@@currstring)+@coldelimiter+isnull(convert(varchar,accdm_accpm_prop_id),'')+@coldelimiter+isnull(accdm_cd,'')+@coldelimiter+isnull(accdm_desc,'')+@coldelimiter+isnull(accdm_rmks,'')+@coldelimiter+accdm_datatype+@coldelimiter+convert(varchar,accdm_mdty)+@coldelimiter+convert(varchar, @@l_error)+@rowdelimiter
          from  accdm_mak  with (nolock)
          where accdm_id        = convert(int,@@currstring)
          and   accdm_deleted_ind = 0
          --
          rollback transaction
          --
        end
        else
        begin
          --
          commit transaction
          --
        end
      --
      end
    --
    end          --action type = rej ends here

    if @pa_action = 'del' 
    begin
      --
      begin transaction
      --
      update accpm_dtls_mstr with (rowlock)
      set    accdm_deleted_ind = 0
            ,accdm_lst_upd_by  = @pa_login_name
            ,accdm_lst_upd_dt  = getdate()
      where  accdm_id          = convert(int,@@currstring)
      --
      set @@l_error = @@error
      --
      if @@l_error > 0     --if any error reports then generate the error string
      begin
        --
        select @@t_errorstr    = isnull(@@t_errorstr,'')+convert(varchar,@@currstring)+@coldelimiter+isnull(convert(varchar,accdm_accpm_prop_id),'')+@coldelimiter+isnull(accdm_cd,'')+@coldelimiter+isnull(accdm_desc,'')+@coldelimiter+isnull(accdm_rmks,'')+@coldelimiter+accdm_datatype+@coldelimiter+convert(varchar,accdm_mdty)+@coldelimiter+convert(varchar, @@l_error)+@rowdelimiter
        from  accdm_mak with (nolock)
        where accdm_id         = convert(int,@@currstring)
        and   accdm_deleted_ind = 1
        --
        rollback  transaction
        --
      end
      else
      begin
        --
        commit transaction
        --
      end
    --
    end  --action type = del ends here

    if @pa_action = 'EDT'  --action type = edt begins here
    begin
      --
      if @pa_chk_yn = 0 -- if no maker checker
      begin
        --
        begin transaction
        --
        update accpm_dtls_mstr  with (rowlock)
        set    accdm_accpm_prop_id = @pa_accpm_prop_id
             , accdm_cd            = @pa_accdm_cd
             , accdm_desc          = @pa_accdm_desc
             , accdm_rmks          = @pa_accdm_rmks
             , accdm_lst_upd_by    = @pa_login_name
             , accdm_lst_upd_dt    = getdate()
             , accdm_datatype      = @pa_accdm_datatype 
             , accdm_mdty          = @pa_accdm_mdty
        where  accdm_id            = convert(int,@@currstring)
        and    accdm_deleted_ind   = 1
        --
        set @@l_error = @@error
        --
        if @@l_error > 0
        begin
          --
          set @@t_errorstr = isnull(@@t_errorstr,'')+convert(varchar,@@currstring)+@coldelimiter+convert(varchar,@pa_accpm_prop_id)+@coldelimiter+@pa_accdm_cd+@coldelimiter+@pa_accdm_desc+@coldelimiter+isnull(@pa_accdm_rmks,'')+@coldelimiter+@pa_accdm_datatype+@coldelimiter+convert(varchar,@pa_accdm_mdty)+@coldelimiter+convert(varchar, @@l_error)+@rowdelimiter
          --
          rollback transaction
          --
        end
        else
        begin
         --
         commit transaction
         --
        end
        --
      end

      if @pa_chk_yn = 1 -- if maker or cheker is editing
      begin
        --
        begin transaction
        --
        update accdm_mak  with (rowlock)
        set    accdm_deleted_ind = 2
             , accdm_lst_upd_by  = @pa_login_name
             , accdm_lst_upd_dt  = getdate()
        where  accdm_id          = convert(int,@@currstring)
        and    accdm_deleted_ind = 0
        --
        set @@l_error = @@error
        --
        if @@l_error > 0
        begin
          --
          set @@t_errorstr = isnull(@@t_errorstr,'')+convert(varchar,@@currstring)+@coldelimiter+convert(varchar,@pa_accpm_prop_id)+@coldelimiter+@pa_accdm_cd+@coldelimiter+@pa_accdm_desc+@coldelimiter+isnull(@pa_accdm_rmks,'')+@coldelimiter+@pa_accdm_datatype+@coldelimiter+convert(varchar,@pa_accdm_mdty)+@coldelimiter+convert(varchar, @@l_error)+@rowdelimiter
          --
          rollback transaction
          --
        end
        else
        begin
          --
          insert into accdm_mak
          (accdm_id
          ,accdm_accpm_prop_id
          ,accdm_cd
          ,accdm_desc
          ,accdm_rmks
          ,accdm_created_by
          ,accdm_created_dt
          ,accdm_lst_upd_by
          ,accdm_lst_upd_dt
          ,accdm_deleted_ind
          ,accdm_datatype
          ,accdm_mdty
          )
          values
          (convert(int, @@currstring)
          ,@pa_accpm_prop_id
          ,@pa_accdm_cd
          ,@pa_accdm_desc
          ,@pa_accdm_rmks
          ,@pa_login_name
          ,getdate()
          ,@pa_login_name
          ,getdate()
          ,0
          ,@pa_accdm_datatype
          ,@pa_accdm_mdty
          )
          --
          set @@l_error = @@error
          --
          if @@l_error > 0
          begin
          --
            set @@t_errorstr = isnull(@@t_errorstr,'')+convert(varchar,@@currstring)+@coldelimiter+convert(varchar,@pa_accpm_prop_id)+@coldelimiter+@pa_accdm_cd+@coldelimiter+@pa_accdm_desc+@coldelimiter+isnull(@pa_accdm_rmks,'')+@coldelimiter+@pa_accdm_datatype+@coldelimiter+convert(varchar,@pa_accdm_mdty)+@coldelimiter+convert(varchar, @@l_error)+@rowdelimiter
            --
            rollback transaction
          --
          end
          else
          begin
          --
            commit transaction
          --
          end
          --
         end
         --
      end
      --
    end  --action type = edt ends here
  --
  end  --endimg of the currstring
--
end --end of while
--
set @pa_errmsg = @@t_errorstr
--
end

GO
