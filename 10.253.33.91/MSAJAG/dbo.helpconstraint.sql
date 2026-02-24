-- Object: PROCEDURE dbo.helpconstraint
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.helpconstraint    Script Date: 3/17/01 9:55:53 PM ******/

/****** Object:  Stored Procedure dbo.helpconstraint    Script Date: 3/21/01 12:50:09 PM ******/

/****** Object:  Stored Procedure dbo.helpconstraint    Script Date: 20-Mar-01 11:38:51 PM ******/

/****** Object:  Stored Procedure dbo.helpconstraint    Script Date: 2/5/01 12:06:14 PM ******/

/****** Object:  Stored Procedure dbo.helpconstraint    Script Date: 12/27/00 8:58:51 PM ******/

/****** Object:  Stored Procedure dbo.helpconstraint    Script Date: 12/18/99 8:24:04 AM ******/
create procedure helpconstraint --1996/07/02 16:33
    @objname varchar(92)             -- the table to check for constraints
   ,@nomsg   varchar(5) = 'msg'      -- 'nomsg' supresses printing of TBName (sp_help)
as
set nocount on
declare @objid    int           -- the object id of the table
       ,@indid    int           -- the index id of an index
       ,@cnstdes  varchar(255)  -- string to build up index desc
       ,@cnstname varchar(30)   -- name of const. currently under consideration
       ,@tptr     varbinary(16) -- pointer for building text strings.
       ,@i          int
       ,@thiskey    varchar(32)
       ,@cnstid     int
       ,@cnststatus int
       ,@numkeys    int
       ,@rkeyid     int
       ,@fkeyid      int
       ,@dbname     varchar(30)
declare
         @fkey1  int ,@fkey2  int ,@fkey3  int ,@fkey4  int ,@fkey5  int
        ,@fkey6  int ,@fkey7  int ,@fkey8  int ,@fkey9  int ,@fkey10 int
        ,@fkey11 int ,@fkey12 int ,@fkey13 int ,       
         @fkey14 int ,@fkey15 int ,@fkey16 int
declare
         @rkey1  int ,@rkey2  int ,@rkey3  int ,@rkey4  int ,@rkey5  int
        ,@rkey6  int ,@rkey7  int ,@rkey8  int ,@rkey9  int ,@rkey10 int
        ,@rkey11 int ,@rkey12 int ,@rkey13 int ,@rkey14 int ,@rkey15 int
        ,@rkey16 int
declare
       @bitDisabled           integer
      ,@bitNotForReplication  integer
--------
select
       @bitDisabled           = 0x4000
      ,@bitNotForReplication  = 0x200000
---- Check to see that the object names are local to the current database.
if      @objname like '%.%.%'
   and  substring(@objname, 1, charindex('.', @objname) - 1) <> db_name()
   begin
   raiserror(15250,-1,-1)
   return (1)
   end
---- Check to  see if the table exists and initialize @objid.
select @objid = object_id(@objname)
---- Table does not exist so return.
if @objid is NULL
   begin
   select @dbname=db_name()
   raiserror(15009,-1,-1,@objname,@dbname)
   return (1)
       
   end
declare cnst_csr insensitive cursor for -- 15574 in 6.5 dynamic unless insensitive
     select   c.constid, c.status, o.name
        from  sysconstraints c, sysobjects o
        where c.id = @objid and o.id = c.constid
        for read only
---- Now check out each constraint, figure out its type and keys and
---- save the info in a temporary table that we'll print out at the end.
create table  spcnsttab
(
    rowid               int           NOT NULL  identity
   ,cnst_type           varchar(48)   NOT NULL   -- 30 for name + text for DEFAULT
   ,cnst_name           varchar(30)   NOT NULL
   ,cnst_nonblank_name  varchar(30)   NOT NULL
   ,cnst_status         integer           NULL
   ,cnst_keys           text              NULL
)
create table  spcnstkeys
(
    cnst_colid int NOT NULL
)
open cnst_csr
fetch cnst_csr into @cnstid, @cnststatus, @cnstname
while @@fetch_status >= 0
   begin
   if ((@cnststatus & 0xf) in (1,2)) -- primary key, unique       
      begin
      if ((@cnststatus & 0xf) = 1)
         select @cnstdes = 'PRIMARY KEY'
      else
         select @cnstdes = 'UNIQUE'
      select   @indid = indid
         from  sysindexes
         where sysindexes.name = OBJECT_NAME(@cnstid)
        and sysindexes.id = @objid
      if (@indid > 1)
         select @cnstdes = @cnstdes + ' (non-clustered)'
      else
         select @cnstdes = @cnstdes + ' (clustered)'
      ---- First we'll figure out what the keys are.
         
    select @i = 1
      while (@i <= 16)
         begin
         select @thiskey = index_col(@objname, @indid, @i)
         if @thiskey is NULL
            goto keysdone
         if @i=1
            begin
            insert into  spcnsttab 
 (cnst_type,cnst_name,cnst_nonblank_name,cnst_keys)
               values (@cnstdes, @cnstname,@cnstname, @thiskey)
            select @tptr = textptr(cnst_keys) from  spcnsttab
            end
         else
            begin
            select @thiskey = ', ' + @thiskey
            if @tptr is not null
               updatetext  spcnsttab.cnst_keys @tptr null null @thiskey
            end
         select @i = @i + 1
         end --loop 16
         ---- When we get here we now  have all the keys.
keysdone:
      end
   else   -- not pkey,ukey
      if ((@cnststatus & 0xf) = 3) /* foreign key */
         begin
         select @cnstdes = 'FOREIGN KEY'
         select
                @fkeyid = fkeyid, @rkeyid = rkeyid,
                @fkey1=fkey1, @fkey2=fkey2, @fkey3=fkey3,
                @fkey4=fkey4, @fkey5=fkey5, @fkey6=fkey6,
                @fkey7=fkey7, @fkey8=fkey8, @fkey9=fkey9,
                @fkey10=fkey10, @fkey11=fkey11,
                @fkey12=fkey12, @fkey13=fkey13,
                @fkey14=fkey14, @fkey15=fkey15,
                @fkey16=fkey16,
                @rkey1=rkey1, @rkey2=rkey2, @rkey3=rkey3,
                @rkey4=rkey4, @rkey5=rkey5, @rkey6=rkey6,
                @rkey7=rkey7, @rkey8=rkey8, @rkey9=rkey9,
                @rkey10=rkey10, @rkey11=rkey11,
                @rkey12=rkey12, @rkey13=rkey13,
                @rkey14=rkey14, @rkey15=rkey15,
                @rkey16=rkey16
            from  sysreferences
   
          where constid = @cnstid
         insert into  spcnstkeys values(@fkey1)
         insert into  spcnstkeys values(@fkey2)
         insert into  spcnstkeys values(@fkey3)
         insert into  spcnstkeys values(@fkey4)
         insert into  spcnstkeys values(@fkey5)
         insert into  spcnstkeys values(@fkey6)
         insert into  spcnstkeys values(@fkey7)
         insert into  spcnstkeys values(@fkey8)
         insert into  spcnstkeys values(@fkey9)
         insert into  spcnstkeys values(@fkey10)
         insert into  spcnstkeys values(@fkey11)
         insert into  spcnstkeys values(@fkey12)
         insert into  spcnstkeys values(@fkey13)
         insert into  spcnstkeys values(@fkey14)
         insert into  spcnstkeys values(@fkey15)
         insert into  spcnstkeys values(@fkey16)
         delete from  spcnstkeys where cnst_colid = 0
         ---- Need a unique index so we can use a cursor.
         create unique index ind1 on  spcnstkeys(cnst_colid) 
         execute('declare fkey_curs cursor for
                     select cnst_colid from  spcnstkeys
                     for read only')
         open fkey_curs
         fetch fkey_curs into @i
         select @numkeys=1
              
  while @@fetch_status >= 0
            begin
            select @thiskey = col_name(@fkeyid, @i)
            ---- No comma for fist key column.
            if @numkeys = 1
               begin
               insert into  spcnsttab (cnst_type,cnst_name,cnst_nonblank_name,cnst_keys)
                  values (@cnstdes, @cnstname,@cnstname, @thiskey)
               select @tptr = textptr(cnst_keys) from  spcnsttab
               end
            else
               begin
                     
 select @thiskey = ', ' + @thiskey
               if @tptr is not null
                  updatetext  spcnsttab.cnst_keys @tptr null null @thiskey
               end
            select @numkeys=@numkeys+1
            fetch fkey_curs into @i
    
         end --loop key fetch
         ---- When we get here we now have all the keys.
         truncate table  spcnstkeys
         drop index  spcnstkeys.ind1
         deallocate fkey_curs
         insert into  spcnstkeys values(@rkey1)
         insert into  spcnstkeys values(@rkey2)
         insert into  spcnstkeys values(@rkey3)
         insert into  spcnstkeys values(@rkey4)
         insert into  spcnstkeys values(@rkey5)
         insert into  spcnstkeys values(@rkey6)
    
      insert into  spcnstkeys values(@rkey7)
         insert into  spcnstkeys values(@rkey8)
         insert into  spcnstkeys values(@rkey9)
         insert into  spcnstkeys values(@rkey10)
         insert into  spcnstkeys values(@rkey11)
            
    insert into  spcnstkeys values(@rkey12)
         insert into  spcnstkeys values(@rkey13)
         insert into  spcnstkeys values(@rkey14)
         insert into  spcnstkeys values(@rkey15)
         insert into  spcnstkeys values(@rkey16)
         
 delete from  spcnstkeys where cnst_colid = 0
         ---- Need a unique index so we can use a cursor.
         create unique index ind1 on  spcnstkeys(cnst_colid)
         insert into  spcnsttab (cnst_type,cnst_name,cnst_nonblank_name,cnst_keys)
            select  ' ' ,' ' ,@cnstname
                     ,'REFERENCES ' + rtrim(db_name(rkeydbid))
                           + '.' + rtrim(
                  (select user_name(uid) from sysobjects where id = @rkeyid
 
                  )
                                        )
                           + '.'+object_name(@rkeyid) + ' ('
               from  sysreferences
               where constid = @cnstid
         select @tptr = textptr(cnst_keys) from  spcnsttab
         execute('declare rkey_curs cursor for
                     select cnst_colid from  spcnstkeys
                     for read only')
         open rkey_curs
         fetch rkey_curs into @i
         select @numkeys=1
 
         while @@fetch_status >= 0
            begin
            select @thiskey = col_name(@rkeyid, @i)
            ---- No comma for first key column.
            if @numkeys <> 1
               select @thiskey = ', ' + @thiskey
            
       if @tptr is not null
               updatetext  spcnsttab.cnst_keys @tptr null null @thiskey
            select @numkeys=@numkeys+1
            fetch rkey_curs into @i
            end --loop
         ---- When we get here we now have all the keys.
         if @tptr is not null
            updatetext  spcnsttab.cnst_keys @tptr null null ')'
         truncate table  spcnstkeys
         drop index  spcnstkeys.ind1
         deallocate rkey_curs
         end
      else
       
         if ((@cnststatus & 0xf) = 4)    -- check constraint
            begin
            select @i = 1
            select @cnstdes = text from syscomments
               where id = @cnstid and colid = @i
            while @cnstdes is not null
 
               begin
               if @i=1
                  begin
                  -- Get Table Check constraint
                  insert into  spcnsttab (cnst_type,cnst_name,cnst_nonblank_name,cnst_keys)
                     select   'CHECK Table Level ',@cnstname,@cnstname,' '
                        from  sysconstraints
                        where colid = 0 and constid = @cnstid
                  -- Column Level Check
                  insert into  spcnsttab (cnst_type,cnst_name,cnst_nonblank_name,cnst_keys)
                     select 'CHECK on column ' + col_name(id, colid)
                           ,@cnstname,@cnstname,' '
                        from  sysconstraints
                        where colid > 0 and constid = @cnstid
                  select @tptr = textptr(cnst_keys) from  spcnsttab
                  if @tptr is not null
                  updatetext  spcnsttab.cnst_keys @tptr 0 null null
                  end
               else
              
     begin
                  if @tptr is not null
                     updatetext  spcnsttab.cnst_keys @tptr null null @cnstdes
                  end
               select @cnstdes = null
               select @cnstdes = text from syscomments
                  where id = @cnstid and colid = @i
               select @i = @i + 1
               end
            end
         else
            if ((@cnststatus & 0xf) = 5)    -- default
               begin
               select @i = 1
 
               select @cnstdes = text from syscomments
                  where id = @cnstid and colid = @i
               while @cnstdes is not null
                  begin
                  if @i=1
                     begin
                 
           insert into  spcnsttab (cnst_type,cnst_name,cnst_nonblank_name,cnst_keys)
                        select 'DEFAULT on column ' + col_name(id, colid)
                              ,@cnstname,@cnstname,' '
                           from  sysconstraints
                           where colid > 0 and constid = @cnstid
                     select @tptr = textptr(cnst_keys) from  spcnsttab
                     if @tptr is not null
                        updatetext  spcnsttab.cnst_keys @tptr 0 null null
                     end
                  else
                     begin
                     if @tptr is not null
                        updatetext  spcnsttab.cnst_keys @tptr null null @cnstdes
                     end
   
                select @cnstdes = null
                  select @cnstdes = text from syscomments
                     where id = @cnstid and colid = @i
                  select @i = @i + 1
                  end
               end
                
   else
               insert into  spcnsttab (cnst_type,cnst_name,cnst_nonblank_name,cnst_keys)
                  values
                     ('*** INVALID TYPE FOUND IN SYSCONSTRAINTS ***'
                     ,'ERROR','ERROR','ERROR')
           
  fetch cnst_csr into @cnstid, @cnststatus, @cnstname
        end --of major loop
        ---- Find any rules or defaults bound by the sp_bind... method.
        insert into  spcnsttab (cnst_type,cnst_name,cnst_nonblank_name,cnst_keys)
          
        select 'RULE (bound with sp_bindrule)'
                 ,object_name(c.domain),object_name(c.domain)
                 ,text
              from  syscolumns c,syscomments m
              where c.id = @objid
                and m.id = c.domain
 
                and c.domain not in
                        (select constid from sysconstraints)
        insert into  spcnsttab (cnst_type,cnst_name,cnst_nonblank_name,cnst_keys)
           select 'DEFAULT (bound with sp_bindefault)'
                
        ,object_name(c.cdefault),object_name(c.cdefault)
                 ,text
              from syscolumns c,syscomments m
              where c.id = @objid
                and m.id = c.cdefault
                and c.cdefault not in
              
           (select constid from sysconstraints)
        ---- constraint status (type included)
       update  spcnsttab
                set   cnst_status = cs.status
                from   spcnsttab tt1 ,sysconstraints cs
                       
where cs.constid = OBJECT_ID( tt1.cnst_name)
        update  spcnsttab
                set   cnst_status = 0
                where cnst_status is null
        if @nomsg <> 'nomsg'
           begin
           select 'Object Name' = @objname
   
         print ''
           end
        ---- Now print out the contents of the temporary index table.
        if (select count(*) from  spcnsttab) <> 0
           select
                   'constraint_type' = cnst_type,'constraint_name' = cnst_name
                  ,'status_enabled'      = -- 3=fkey ,4=check
                     CASE
                        When cnst_name = ' ' Then ' '
                        When cnst_status & 0xf in (3,4) and
             
                 cnst_status & @bitDisabled > 0 and
                             cnst_name <> ' '
                           Then    'Disabled'
                        When cnst_status & 0xf in (3,4) and
                             cnst_status & @bitDisabled = 0 and
                             cnst_name <> ' '
                           Then    'Enabled'
                        Else       '(n/a)'
                     END
                  ,'status_for_replication'  =
                   
   CASE
                        When cnst_name = ' ' Then ' '
                        When cnst_status & 0xf in (3,4) and
                             cnst_status & @bitNotForReplication > 0 and
                             cnst_name <> ' '
          
                        Then    'Not_For_Replication'
                        When cnst_status & 0xf in (3,4) and
                             cnst_status & @bitNotForReplication = 0 and
                             cnst_name <> ' '
                   
         Then    'Is_For_Replication'
                        Else       '(n/a)'
                     END
                  ,'constraint_keys' = cnst_keys
                from       spcnsttab
                order by  cnst_nonblank_name ,cnst_name     
        else
           print 'No constraints have been defined for this object.'
        print ''
        if (select count(*) from sysreferences where rkeyid = @objid) <> 0
           select
                   'Table is referenced by ' =
                        db_name(r.fkeydbid) + '.'
                     +  rtrim(
               (select user_name(o.uid) from sysobjects o
                  where o.id = r.fkeyid
               )
                             )
             
               + '.' + object_name(r.fkeyid)
                     + ': ' + object_name(r.constid)
               from      sysreferences r
               where     r.rkeyid = @objid
               order by  1
        else
           print 'No foreign keys reference this table.'
deallocate cnst_csr
return (0)

GO
