-- Object: PROCEDURE citrus_usr.pr_ins_upd_reqdtls
-- Server: 10.253.78.187 | DB: DMAT
--------------------------------------------------


  
  
  
  
  
  
  
--select top 1 * from slip_issue_mstr    
/*    
create table Dis_req_Dtls_mak    
(id numeric identity(1,1)    
,req_slip_no varchar(100)    
,req_date datetime    
,Boid varchar(16)     
,Boname varchar(150)    
,sholder varchar(150)    
,tholder  varchar(150)    
,created_dt datetime    
,created_by varchar(100)    
,lst_upd_dt datetime    
,lst_upd_by varchar(100)    
,deleted_ind smallint)    
    
alter table Dis_req_Dtls_mak add  imagepath varchar(1000)    
alter table Dis_req_Dtls add imagepath varchar(1000)    
    
create table Dis_req_Dtls    
(id numeric identity(1,1)    
,req_slip_no varchar(100)    
,req_date datetime    
,Boid varchar(16)     
,Boname varchar(150)    
,sholder varchar(150)    
,tholder  varchar(150)    
,created_dt datetime    
,created_by varchar(100)    
,lst_upd_dt datetime    
,lst_upd_by varchar(100)    
,deleted_ind smallint)    
    
    
*/    
    
    
CREATE proc [citrus_usr].[pr_ins_upd_reqdtls](  
  @pa_id numeric    
, @pa_action varchar(50)    
, @pa_req_slip_no varchar(100)    
, @pa_req_date datetime    
, @pa_boid varchar(16)    
, @pa_boname varchar(1000)    
, @pa_sholder varchar(1000)    
, @pa_tholder varchar(1000)    
, @pa_login_name varchar(100)    
, @pa_chk_yn smallint    
, @pa_rmks varchar(300)    
, @pa_imagepath varchar(1000)   
, @pa_imagepath1 varchar(1000)   
, @pa_imagepath2 varchar(1000)   
, @pa_chk_rmks varchar(300)    
, @pa_slip_yn char(1)  
, @pa_type char(3)  
, @pa_imagepathBinary varbinary(max)
, @pa_imagepath1Binary varbinary(max)
, @pa_imagepath2Binary varbinary(max)
, @pa_error varchar(8000)  output    
)    
as    
begin    
  print 'ssd'
  /* for letter date sep 04 14*/  
declare @l_letter_date datetime 
Set @l_letter_date = convert(datetime,citrus_usr.fn_splitval_by(@pa_rmks,2,'|*~|'),105)
set @pa_rmks  = citrus_usr.fn_splitval_by(@pa_rmks,1,'|*~|')
/* for letter date sep 04 14*/
    
  if @pa_chk_yn = 0     
  begin     
      
    if @pa_action ='INS'    
    begin    
    
      insert into Dis_req_Dtls    
      select @pa_req_slip_no    
      ,@pa_req_date    
      , @pa_boid     
      , ltrim(rtrim(@pa_boname))     
      , ltrim(rtrim(@pa_sholder))     
      , ltrim(rtrim(@pa_tholder))   
      , getdate()    
      , @pa_login_name     
      , getdate()    
      , @pa_login_name     
      ,1       
      ,NULL       
      ,@pa_rmks   
   ,@pa_imagepath   
   ,@pa_chk_rmks  
   ,@pa_slip_yn  
      ,NULL   
      ,@pa_imagepath1  
   ,@pa_imagepath2   
   --,0  
 ,(select max(isnull(gen_id ,0))+1  from Dis_req_Dtls )  
   ,@pa_imagepathBinary
  ,@pa_imagepath1Binary
  ,@pa_imagepath2Binary ,@l_letter_date,@pa_slip_yn
    
    end     
    if @pa_action ='EDT'    
    begin    
    
      update Dis_req_Dtls    
      set req_slip_no=@pa_req_slip_no    
      ,req_date=@pa_req_date    
      ,Boid=@pa_boid    
      ,Boname=ltrim(rtrim(@pa_boname))   
      ,sholder=ltrim(rtrim(@pa_sholder))    
      ,tholder = ltrim(rtrim(@pa_tholder))    
      ,remarks = @pa_rmks    
      ,lst_upd_dt = getdate()    
      ,lst_upd_by =@pa_login_name  
   , imagepath= @pa_imagepath    
   , imagepath1= @pa_imagepath1    
   , imagepath2= @pa_imagepath2     
   ,letter_date=@l_letter_date   
      where id = @pa_id     
      and deleted_ind = 1     
    
    
    end     
    if @pa_action ='DEL'    
    begin    
    
      update Dis_req_Dtls    
      set deleted_ind = 0     
      ,lst_upd_dt = getdate()    
      ,lst_upd_by =@pa_login_name    
      where id = @pa_id     
      and deleted_ind = 1     
    
    end     
    if @pa_action ='VALIDATESELECT'    
    begin    
      select SLIIM_DPAM_ACCT_NO,dpam_sba_NAME    
      , dpam_sba_no  , isnull(DPHD_SH_FNAME,'') + ' ' + isnull(DPHD_SH_MNAME,'') +' ' + isnull(DPHD_SH_LNAME,'') sh_holder    
       , isnull(DPHD_TH_FNAME,'') + ' ' + isnull(DPHD_TH_MNAME,'') +' ' + isnull(DPHD_TH_LNAME,'') th_holder    
      from slip_issue_mstr , dp_acct_mstr left outer join dp_holder_dtls on dphd_dpam_id = dpam_id     
       where SLIIM_SLIP_NO_TO = replace(@pa_req_slip_no ,SLIIM_SERIES_TYPE,'')and SLIIM_DPAM_ACCT_NO=DPAM_SBA_NO    
        and sliim_deleted_ind =1 and dpam_deleted_ind=1 and dpam_stam_cd='active'  and sliim_series_type<>'GENERAL'  
    end     
    if @pa_action ='SEARCH'    
    begin    
    
      select * from Dis_req_Dtls    
      where req_slip_no = @pa_req_slip_no    
      and deleted_ind =1     
                
    end     
        
   end     
      else if @pa_chk_yn = 1     
      begin     
          
          if @pa_action ='INS'    
    begin    
  
      --  if not exists(select req_slip_no from Dis_req_Dtls where id = @pa_id)   
     if @pa_slip_yn <> 'L'  
     begin    
   if not exists(select req_slip_no from Dis_req_Dtls_mak where req_slip_no = @pa_req_slip_no)    
      insert into Dis_req_Dtls_mak    
      select ltrim(rtrim(@pa_req_slip_no))    
      ,@pa_req_date    
      , @pa_boid     
      , ltrim(rtrim(@pa_boname))    
      , ltrim(rtrim(@pa_sholder))   
      , ltrim(rtrim(@pa_tholder))     
      , getdate()    
      , @pa_login_name     
      , getdate()    
      , @pa_login_name     
      ,0     
      , @pa_rmks       
   ,@pa_imagepath  
   ,@pa_chk_rmks  
   ,@pa_slip_yn   
   ,@pa_imagepath1  
      ,@pa_imagepath2    
   --,0     
,( select max(isnull(gen_id ,0)) + 1  from Dis_req_Dtls_mak )   
      ,@pa_imagepathBinary
      ,@pa_imagepath1Binary   
      ,@pa_imagepath2Binary,@l_letter_date
  end  
     else  
  begin  
  insert into Dis_req_Dtls_mak    
    select ltrim(rtrim(@pa_req_slip_no))    
    ,@pa_req_date    
    , @pa_boid     
    , ltrim(rtrim(@pa_boname))     
    , ltrim(rtrim(@pa_sholder))     
    , ltrim(rtrim(@pa_tholder))     
    , getdate()    
    , @pa_login_name     
    , getdate()    
    , @pa_login_name     
    ,0     
    , @pa_rmks       
    ,@pa_imagepath  
    ,@pa_chk_rmks  
    ,@pa_slip_yn   
    ,@pa_imagepath1  
    ,@pa_imagepath2    
   -- ,0     
 ,( select max(isnull(gen_id ,0)) + 1  from Dis_req_Dtls_mak ) 
 		  ,@pa_imagepathBinary
      ,@pa_imagepath1Binary   
      ,@pa_imagepath2Binary   ,@l_letter_date 
  end   
 
    end     
    select @pa_error = max(id)  from Dis_req_Dtls_mak where deleted_ind=0
    
    if @pa_action ='EDT'    
    begin    
        if not exists(select req_slip_no from Dis_req_Dtls where id = @pa_id and deleted_ind = 1)    
        begin     
       update Dis_req_Dtls_mak    
       set req_slip_no=ltrim(rtrim(@pa_req_slip_no))    
       ,req_date=@pa_req_date    
       ,Boid=@pa_boid    
       ,Boname=ltrim(rtrim(@pa_boname))    
       ,sholder=ltrim(rtrim(@pa_sholder))    
       ,tholder = ltrim(rtrim(@pa_tholder))    
       ,remarks = @pa_rmks    
       ,lst_upd_dt = getdate()    
       ,lst_upd_by =@pa_login_name  
    , imagepath=@pa_imagepath    
    , imagepath1=@pa_imagepath1    
  , imagepath2=@pa_imagepath2    
  		,imagepathbinary=@pa_imagepathBinary
      ,imagepath1binary=@pa_imagepath1Binary   
      ,imagepath2binary=@pa_imagepath2Binary 
       where id = @pa_id     
       and deleted_ind = 0     
      END   
        if exists(select req_slip_no from Dis_req_Dtls_mak where id = @pa_id and deleted_ind = 3)    
        begin    
          insert into Dis_req_Dtls_mak    
     select ltrim(rtrim(@pa_req_slip_no))    
     ,@pa_req_date    
     , @pa_boid     
     , ltrim(rtrim(@pa_boname))     
     , ltrim(rtrim(@pa_sholder))     
     , ltrim(rtrim(@pa_tholder))     
     , getdate()    
     , @pa_login_name     
     , getdate()    
     , @pa_login_name     
     , 0    
     , @pa_rmks,@pa_imagepath,@pa_chk_rmks,@pa_slip_yn, @pa_imagepath1,@pa_imagepath2,( select max(isnull(gen_id ,0)) + 1  from Dis_req_Dtls_mak )    
       		   ,@pa_imagepathBinary
      ,@pa_imagepath1Binary   
      ,@pa_imagepath2Binary ,@l_letter_date
     delete from dis_req_Dtls_mak where id = @pa_id and deleted_ind = 3  
         
        end     
      ELSE     
      BEGIN    
--       insert into Dis_req_Dtls_mak    
--       select @pa_req_slip_no    
--       ,@pa_req_date    
--       , @pa_boid     
--       , @pa_boname     
--       , @pa_sholder     
--       , @pa_tholder     
--       , getdate()    
--       , @pa_login_name     
--       , getdate()    
--       , @pa_login_name     
--       , 6     
--       , @pa_rmks,@pa_imagepath,@pa_chk_rmks,@pa_slip_yn    
  update Dis_req_Dtls_mak  
  set req_date =@pa_req_date,  
   Boid =@pa_boid,  
   Boname=ltrim(rtrim(@pa_boname)),  
   sholder=ltrim(rtrim(@pa_sholder)),  
   tholder=ltrim(rtrim(@pa_tholder)),  
   created_dt=getdate(),  
   created_by=@pa_login_name,  
   lst_upd_dt=getdate(),  
   lst_upd_by=@pa_login_name,  
   deleted_ind=6,  
   remarks=@pa_rmks,  
   imagepath=@pa_imagepath,  
   chk_remarks=@pa_chk_rmks,  
   slip_yn=@pa_slip_yn,  
   imagepath1=@pa_imagepath1,  
   imagepath2=@pa_imagepath2  
   			,imagepathbinary=@pa_imagepathBinary
      ,imagepath1binary=@pa_imagepath1Binary   
      ,imagepath2binary=@pa_imagepath2Binary 
  where case when isnull(req_slip_no,'')='' then boid else req_slip_no end = case when isnull(@pa_req_slip_no,'')='' then @pa_boid else @pa_req_slip_no end  
  and slip_yn = case when isnull(req_slip_no,'')='' then 'L' else 'S' end  
    
      END      
           
    
    
    end     
    if @pa_action ='DEL'    
    begin    
         if not exists(select req_slip_no from Dis_req_Dtls where id = @pa_id and deleted_ind = 1)    
         BEGIN    
             
       delete from  Dis_req_Dtls_mak    
       where id = @pa_id     
       and deleted_ind = 0     
           
      END     
      ELSE     
      BEGIN    
       insert into Dis_req_Dtls_mak    
       select ltrim(rtrim(@pa_req_slip_no))    
       ,@pa_req_date    
       , @pa_boid     
       , @pa_boname     
       , @pa_sholder     
       , @pa_tholder     
       , getdate()    
       , @pa_login_name     
       , getdate()    
       , @pa_login_name     
       ,4     
       ,@pa_rmks,@pa_imagepath,@pa_chk_rmks,@pa_slip_yn,@pa_imagepath1,@pa_imagepath2  ,( select max(isnull(gen_id ,0)) + 1  from Dis_req_Dtls_mak )    
              ,@pa_imagepathBinary
      ,@pa_imagepath1Binary   
      ,@pa_imagepath2Binary ,@l_letter_date
      END     
    
    end     
    if @pa_action ='APP'    
    begin    
        
      insert into Dis_req_Dtls    
      select ltrim(rtrim(req_slip_no))    
      ,req_date    
      ,boid     
      ,boname     
      ,sholder     
      ,tholder     
      ,created_dt    
      ,created_by    
      ,getdate()--,lst_upd_dt    
      ,@PA_LOGIN_NAME --,lst_upd_by    
      ,1     
      ,NULL    
      ,remarks  
   ,imagepath  
   ,chk_remarks  
   ,slip_yn   
   ,NULL  
   ,imagepath1  
   ,imagepath2  
   ,gen_id  
   	  ,imagepathbinary
,imagepath1binary
,imagepath2binary,letter_date,@pa_slip_yn
      from Dis_req_Dtls_mak    
      where id = @pa_id     
      and deleted_ind in (0,6)     
    
       
    
      update Dis_req_Dtls_mak     
      set deleted_ind = 1    
  , chk_remarks = @pa_chk_rmks  
  , lst_upd_dt = getdate()  
  , lst_upd_by = @PA_LOGIN_NAME  
      where id = @pa_id     
          
         update TBLMASTER    
       set TBLMASTER.req_slip_no=TBLMAK.req_slip_no    
       ,TBLMASTER.req_date=TBLMAK.req_date    
       ,TBLMASTER.Boid=TBLMAK.Boid    
       ,TBLMASTER.Boname=TBLMAK.Boname    
       ,TBLMASTER.sholder=TBLMAK.sholder    
       ,TBLMASTER.tholder = TBLMAK.tholder     
       ,TBLMASTER.lst_upd_dt = getdate()    
       ,TBLMASTER.lst_upd_by = @pa_login_name, TBLMASTER.imagepath= TBLMAK.imagepath ,TBLMASTER.imagepath1= TBLMAK.imagepath1  ,TBLMASTER.imagepath2= TBLMAK.imagepath2     
      from Dis_req_Dtls TBLMASTER ,Dis_req_Dtls_mak TBLMAK    
      where TBLMASTER.REQ_SLIP_NO = TBLMAK.REQ_SLIP_NO AND TBLMAK.id = @pa_id     
      and TBLMAK.deleted_ind = 6     
          
      DELETE TBLMASTER    
      from Dis_req_Dtls TBLMASTER ,Dis_req_Dtls_mak TBLMAK    
      where TBLMASTER.REQ_SLIP_NO = TBLMAK.REQ_SLIP_NO AND TBLMAK.id = @pa_id     
      and TBLMAK.deleted_ind = 4     
          
          
    end     
     
    if @pa_action ='REJ'    
    begin   
PRINT 'ABC'   
PRINT @pa_chk_rmks  
     update Dis_req_Dtls_mak    
     set deleted_ind = 3  
  , chk_remarks = @pa_chk_rmks    
     where id = @pa_id     
     and deleted_ind in (0,6)     
     and CREATED_BY <> @PA_LOGIN_NAME     
    end    
        
    if @pa_action ='VALIDATESELECT'    
    begin    
      select SLIIM_DPAM_ACCT_NO,dpam_sba_NAME    
      , dpam_sba_no  , isnull(DPHD_SH_FNAME,'') + ' ' + isnull(DPHD_SH_MNAME,'') +' ' + isnull(DPHD_SH_LNAME,'') sh_holder    
       , isnull(DPHD_TH_FNAME,'') + ' ' + isnull(DPHD_TH_MNAME,'') +' ' + isnull(DPHD_TH_LNAME,'') th_holder    
      from slip_issue_mstr , dp_acct_mstr left outer join dp_holder_dtls on dphd_dpam_id = dpam_id     
       where SLIIM_SLIP_NO_TO = replace(@pa_req_slip_no ,SLIIM_SERIES_TYPE,'') and SLIIM_DPAM_ACCT_NO=DPAM_SBA_NO    
        and sliim_deleted_ind =1 and dpam_deleted_ind=1 and dpam_stam_cd='active'   and sliim_series_type<>'GENERAL'  
    end     
    if @pa_action ='SEARCHCHK'    
    begin    
    
      IF @pa_tholder = 'P'    
      BEGIN    
    
       select id,req_slip_no,req_date,Boid,Boname,sholder,tholder,created_dt,created_by,lst_upd_dt,lst_upd_by,deleted_ind,  
    remarks,imagepath,chk_remarks,slip_yn,isnull(imagepath1,'') imagepath1,isnull(imagepath2,'') imagepath2,case when slip_yn = 'D' then 'DRF' 
     when slip_yn = 'L' then 'Letter' else 'DIS' end  slip_type   
    ,imagepathbinary,imagepath1binary,imagepath2binary,case when convert(varchar(11),letter_date,109)='Jan  1 1900' then '' else convert(varchar(11),letter_date,109) end letter_date
    from Dis_req_Dtls_MAK    
       where deleted_ind IN (0,4,6)    
       AND CREATED_BY <> @PA_LOGIN_NAME     
       AND req_slip_no LIKE CASE WHEN @pa_req_slip_no = '' THEN '%' ELSE @pa_req_slip_no END    
       AND Boid LIKE CASE WHEN @pa_boid = '' THEN '%' ELSE @pa_boid END    
       AND case when @pa_req_date  = '' then '01/01/1900' else req_date end =  case when @pa_req_date  = '' then '01/01/1900' else CONVERT(DATETIME,@pa_req_date,109)  end    
       and slip_yn in  (select  case when @pa_type = 'DRF' then 'D' else 'S' end  
      union   
      select  case when @pa_type = 'DRF' then 'D' else 'L' end)  
      END    
       
      IF @pa_tholder = 'R'    
      BEGIN    
       select id,req_slip_no,req_date,Boid,Boname,sholder,tholder,created_dt,created_by,lst_upd_dt,lst_upd_by,deleted_ind,  
    remarks,imagepath,chk_remarks,slip_yn,isnull(imagepath1,'') imagepath1,isnull(imagepath2,'') imagepath2
    ,case when slip_yn = 'D' then 'DRF' 
     when slip_yn = 'L' then 'Letter' else 'DIS' end  slip_type   ,case when convert(varchar(11),letter_date,109)='Jan  1 1900' then '' else convert(varchar(11),letter_date,109) end letter_date
       from Dis_req_Dtls_MAK    
       where deleted_ind = 3    
       AND req_slip_no LIKE CASE WHEN @pa_req_slip_no = '' THEN '%' ELSE @pa_req_slip_no END    
       AND Boid LIKE CASE WHEN @pa_boid = '' THEN '%' ELSE @pa_boid END    
       AND case when @pa_req_date  = '' then '01/01/1900' else req_date end =  case when @pa_req_date  = '' then '01/01/1900' else CONVERT(DATETIME,@pa_req_date,109)  end    
  and slip_yn in  (select  case when @pa_type = 'DRF' then 'D' else 'S' end  
      union   
      select  case when @pa_type = 'DRF' then 'D' else 'L' end)  
      END    
    
      IF @pa_tholder = 'A'    
      BEGIN    
       select id,req_slip_no,req_date,Boid,Boname,sholder,tholder,created_dt,created_by,lst_upd_dt,lst_upd_by,deleted_ind,  
    remarks,imagepath,chk_remarks,slip_yn,isnull(imagepath1,'') imagepath1,isnull(imagepath2,'') imagepath2,
    case when slip_yn = 'D' then 'DRF' 
     when slip_yn = 'L' then 'Letter' else 'DIS' end  slip_type  ,case when convert(varchar(11),letter_date,109)='Jan  1 1900' then '' else convert(varchar(11),letter_date,109) end letter_date
    from Dis_req_Dtls    
       where deleted_ind = 1    
       AND req_slip_no LIKE CASE WHEN @pa_req_slip_no = '' THEN '%' ELSE @pa_req_slip_no END    
       AND Boid LIKE CASE WHEN @pa_boid = '' THEN '%' ELSE @pa_boid END    
       AND case when @pa_req_date  = '' then '01/01/1900' else req_date end =  case when @pa_req_date  = '' then '01/01/1900' else CONVERT(DATETIME,@pa_req_date,109)  end    
  and slip_yn in  (select  case when @pa_type = 'DRF' then 'D' else 'S' end  
      union   
      select  case when @pa_type = 'DRF' then 'D' else 'L' end)  
            END    
    end     
    if @pa_action ='SEARCHMAK'    
    begin    
    
      select * from Dis_req_Dtls_MAK    
      where deleted_ind IN (0,4,6)    
      AND CREATED_BY = @PA_LOGIN_NAME     
        
          
    end     
    if @pa_action ='REPORTSEL'    
    begin    
    
 if @pa_slip_yn = 'D'  
 begin  
      select id  
   ,req_slip_no  
   ,convert(varchar(11),req_date,103) req_date  
   ,Boid  
   ,Boname  
   ,sholder  
   ,tholder  
   ,created_dt  
   ,created_by,lst_upd_dt  
   ,lst_upd_by,deleted_ind  
   ,remarks  
   ,imagepath  
            ,chk_remarks  
   ,slip_yn  
   ,imagepath1  
   ,imagepath2 ,letter_date 
      from Dis_req_Dtls_MAK    
      where deleted_ind in(0,3,6,1)    
      AND CREATED_BY = @PA_LOGIN_NAME    
   AND Boid LIKE CASE WHEN @pa_boid = '' THEN '%' ELSE @pa_boid END    
      AND case when @pa_req_date  = '' then '01/01/1900' else req_date end =  case when @pa_req_date  = '' 
      then '01/01/1900' else CONVERT(DATETIME,@pa_req_date,109)  end                 
      and slip_yn = 'D'  
  end  
  else if @pa_slip_yn = 'S'  
  begin  

  select id  
   ,req_slip_no  
   ,convert(varchar(11),req_date,103) req_date  
   ,Boid  
   ,Boname  
   ,sholder  
   ,tholder  
   ,created_dt  
   ,created_by,lst_upd_dt  
   ,lst_upd_by,deleted_ind  
   ,remarks  
   ,imagepath  
            ,chk_remarks  
   ,slip_yn  
,imagepath1  
,imagepath2  ,convert(varchar(11),letter_date,103) letter_date
      from Dis_req_Dtls_MAK    
      where deleted_ind in(0,3,6,1)    
      AND CREATED_BY like case when citrus_usr.fn_toget_logintype(@PA_LOGIN_NAME)='1' then '%' else @PA_LOGIN_NAME end --@PA_LOGIN_NAME    
   AND Boid LIKE CASE WHEN @pa_boid = '' THEN '%' ELSE @pa_boid END    
      AND case when @pa_req_date  = '' then '01/01/1900' else req_date end =  case when @pa_req_date  = '' then '01/01/1900' else CONVERT(DATETIME,@pa_req_date,109)  end                 
      and slip_yn in('S','L')  order by CREATED_dt desc
  end  
 else  
 begin  
  select id  
   ,req_slip_no  
   ,convert(varchar(11),req_date,103) req_date  
   ,Boid  
   ,Boname  
   ,sholder  
   ,tholder  
   ,created_dt  
   ,created_by,lst_upd_dt  
   ,lst_upd_by,deleted_ind  
   ,remarks  
   ,imagepath  
            ,chk_remarks  
   ,slip_yn  
,imagepath1  
,imagepath2  ,convert(varchar(11),letter_date,103) letter_date
      from Dis_req_Dtls_MAK    
      where deleted_ind in(0,3,6,1)    
      AND CREATED_BY = @PA_LOGIN_NAME    
   AND Boid LIKE CASE WHEN @pa_boid = '' THEN '%' ELSE @pa_boid END    
      AND case when @pa_req_date  = '' then '01/01/1900' else req_date end =  case when @pa_req_date  = '' then '01/01/1900' else CONVERT(DATETIME,@pa_req_date,109)  end                 
      and slip_yn in('S','L','D')  
 end  
    end    
    if @pa_action ='BOIDSEL'    
    begin    
      select dpam_sba_name fhname, ltrim(rtrim(DPHD_SH_FNAME)) + ' ' + ltrim(rtrim(DPHD_SH_MNAME)) + ' ' + ltrim(rtrim(DPHD_SH_LNAME))  shname, ltrim(rtrim(DPHD_TH_FNAME)) + ' ' + ltrim(rtrim(DPHD_TH_MNAME)) + ' ' + ltrim(rtrim(DPHD_TH_LNAME)) thname    
      from dp_acct_mstr,DP_HOLDER_DTLS    
      where DPHD_DPAM_SBA_NO = DPAM_SBA_NO    
      and convert(numeric,DPAM_SBA_NO) = @pa_boid              
      and dpam_deleted_ind = 1    
      and DPHD_DELETED_IND = 1    
    end     
      end    
      
if @pa_action='ValLetterdate'
Begin
			
if (@pa_rmks='A')
begin			
			if exists 
			(
			select id from dis_req_dtls where slip_yn='l' and boid=@pa_boid and letter_date=@pa_req_date 
			union all
			select id from dis_req_dtls_mak where deleted_ind in (0,4,6) and slip_yn='l' and boid=@pa_boid and letter_date=@pa_req_date 
			)
			begin
			Select 'Y' Flag
			end
			else
			begin
			Select 'N' Flag
			end
end			

if (@pa_rmks='E')
begin			
			if exists 
			(
			select id from dis_req_dtls where slip_yn='l' and boid=@pa_boid and letter_date=@pa_req_date 
			)
			begin
			Select 'Y' Flag
			end
			else
			begin
			Select 'N' Flag
			end
end

			
end  
    
end

GO
