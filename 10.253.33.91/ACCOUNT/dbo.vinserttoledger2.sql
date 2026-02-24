-- Object: PROCEDURE dbo.vinserttoledger2
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

/****** Object:  Stored Procedure dbo.inserttoledger2    Script Date: 02/27/2003 11:46:46 AM ******/
/****** Object:  Stored Procedure dbo.inserttoledger2    Script Date: 01/27/2003 9:52:25 PM ******/

/****** Object:  Stored Procedure dbo.inserttoledger2    Script Date: 01/24/2003 8:56:09 PM ******/
/****** Object:  Stored Procedure dbo.inserttoledger2    Script Date: 12/27/2002 4:39:13 PM ******/

/****** Object:  Stored Procedure dbo.inserttoledger2    Script Date: 12/04/2002 1:48:26 PM ******/
/****** Object:  Stored Procedure dbo.inserttoledger2    Script Date: 10/12/2002 6:11:04 PM ******/
CREATE proc vinserttoledger2 
@sessionid varchar(15),
@vno varchar(12),
@branchflag tinyint,
@costcenterflag tinyint,
@costenable char(1),
@statusid as varchar(30),
@statusname as varchar(30)

as
declare

@@onlyall tinyint,
@@onebranch tinyint,
@@multibranch tinyint,
@@oneBranchAll tinyint,
@@MultiBranchall tinyint,
@@Allcount smallint,
@@Branchcount smallint,
@@OldBranch varchar(10),
@@vtype varchar(2),
@@party2 varchar(10),
@@costbreakup tinyint,
@@costcode1 tinyint,

/* Fields retrived from det2 */
@@category varchar(20),
@@branch varchar(25),
@@amt    money,
@@vtyp varchar(2),
@@vno  varchar(12),
@@lno  int,
@@drcr char(1),
@@costcode smallint,
@@booktype varchar(2),
@@sessionid varchar(25),
@@party_code varchar(10),
@@mainbr as varchar(10),   
@@rcursor as cursor,
@@brnachcnt as tinyint


if @branchflag = 1 and @costcenterflag  = 1
begin
/* 0 = True 
   1 = False
*/

select @@onlyall = 0               /* True */
select @@onebranch = 1             /* True */
select @@multibranch = 1           /* False */
select @@onebranchall = 1          /* False */
select @@Multibranchall = 1        /* False */

select @@allcount = 0
select @@Branchcount = 0
select @@OldBranch = ''

select @@brnachcnt = 0
select @@mainbr = (select BranchName from branchaccounts where DefaultAc = 1)

select @@vtype = (select distinct vtype from det2 
                  where rtrim(sessionid) = rtrim(@sessionid) and vno = @vno)
   
select @@costbreakup = (select count(*) from det2 
        where rtrim(sessionid) = rtrim(@sessionid) and category = 'BRANCH' 
        and vno = @vno and costflag = 'C')

/* if @@vtype = 8 and @@costbreakup > 0  */
if (@@vtype = 5  or @@vtype = 6 or @@vtype = 7 or @@vtype = 8 ) and @@costbreakup > 0
begin
    delete from det2 where rtrim(sessionid) = rtrim(@sessionid) and upper(rtrim(branch)) = 'ALL'
    and vno = @vno and costflag = 'A' 
    and party_code in ( select distinct party_code from det2 where rtrim(sessionid) = rtrim(@sessionid) and vno = @vno and costflag = 'C' )

/*    delete from det2 
    where rtrim(sessionid) = rtrim(@sessionid) and vno = @vno 
    and party_code in ( select distinct MainControlAc from branchaccounts )
*/
    update det2 set costflag = 'A'
    if @@vtype = 5 or @@vtype = 6 or @@vtype = 7 or @@vtype = 8 or @@vtype = 24
    begin
	    update det2 set branch = 'HO' where upper(rtrim(branch)) = 'ALL' and costflag = 'A'
    end
end

/*
if @@vtype = 8 and @@costbreakup > 0 
begin
    delete from det2 where rtrim(sessionid) = rtrim(@sessionid) and upper(rtrim(branch)) = 'ALL'
    and vno = @vno and costflag = 'A' 
    and party_code in ( select distinct party_code from det2 where rtrim(sessionid) = rtrim(@sessionid) and vno = @vno and costflag = 'C' )

    insert into templedger4
    select category, branch, paidamt, vtype, vno, lno, drcr=(case when drcr='D' then 'C' else 'D' end), costcode,
    booktype, sessionid, party_code, costflag, rowid, BrControlAc
    from det2 left outer join branchaccounts b on upper(b.MainControlAc) = upper(party_code) and upper(b.branchname) = upper(branch)
    where sessionid = rtrim(@sessionid) and vno = @vno
    and party_code in ( select distinct MainControlAc from branchaccounts )

    update templedger4 set branch = b.branchname from branchaccounts b 
    where upper(b.BrControlAc) = upper(party_code) 

    update templedger4 set costcode = b.costcode from costmast b 
    where rtrim(upper(costname)) = rtrim(upper(branch)) 

    insert into det2 
    select category, branch, paidamt, vtype, vno, lno, drcr, costcode,
    booktype, sessionid, BrControlAc, costflag, rowid from templedger4

    truncate table templedger4
end
*/

set @@rcursor = cursor for
select category,branch,paidamt,vtype,vno,lno,drcr,costcode,booktype,sessionid,party_code 
from det2 where category = 'BRANCH' and rtrim(sessionid) = rtrim(@sessionid) and vno =@vno and costflag = 'A'
open @@rcursor
fetch next from @@rcursor 
into @@category, @@branch, @@amt, @@vtyp, @@vno, @@lno, @@drcr, @@costcode, @@booktype, @@sessionid , @@party_code 

while @@fetch_status = 0
begin
   if rtrim(@@branch) = 'ALL'
      begin
         select @@Allcount = @@Allcount + 1
      end
   else 
      if rtrim(@@branch) = @@OldBranch
         begin
            select @@OnlyAll = 1
         end
      else
         if @@OldBranch = ''
            begin
               select @@OnlyAll = 1
               select @@OldBranch = rtrim(@@branch)
               select @@Branchcount = @@Branchcount + 1
            end
         else 
            begin
               select @@OnlyAll = 1
               select @@Branchcount = @@Branchcount + 1
               select @@Multibranch = 0
               select @@OneBranch = 1            end

   fetch next from @@rcursor 
   into @@category, @@branch, @@amt, @@vtyp, @@vno, @@lno, @@drcr, @@costcode, @@booktype, @@sessionid , @@party_code 
end


close @@rcursor
deallocate @@rcursor

select 'AllCount = ' + convert(varchar,@@Allcount)
select 'BranchCount = ' + convert(varchar,@@BranchCount)

if @@onlyall = 1
begin
   if @@Allcount = 0
      begin
         if @@branchcount = 1
            begin
               select @@onebranch = 0
               select @@multibranch = 1
               select @@oneBranchAll = 1
               select @@MultiBranchall = 1
            end
         else
            begin
               select @@Multibranch = 0
               select @@onebranch = 1
               select @@oneBranchAll = 1
               select @@MultiBranchall = 1
         end
      end
   else
      begin
         if @@branchcount = 1
            begin
               select @@onebranchAll = 0
               select @@onebranch = 1
               select @@multibranch = 1
               select @@MultiBranchall = 1
            end
         else
            begin
               select @@MultibranchAll = 0
               select @@onebranch = 1
               select @@multibranch = 1
   select @@onebranchAll = 1
            end
      end
end
/*
select "Onlyall = " + convert(varchar,@@onlyall)
select "OneBranch = " + convert(varchar,@@onebranch)
select "MultiBranch = " + convert(varchar,@@multibranch)
select "OneBranchall = " + convert(varchar,@@onebranchall)
select "MultiBranchall = " + convert(varchar,@@Multibranchall)
*/

if @@Onlyall = 0 
begin

   select @@vtype = (select distinct vtype from det2 
                  where rtrim(sessionid) = rtrim(@sessionid) and vno = @vno)
   
   select @@party2 = (select distinct party_code from det2 
             where rtrim(sessionid) = rtrim(@sessionid) and upper(rtrim(branch)) = 'ALL'
             and vno = @vno and costflag = 'A' and lno = 1)

   select @@costbreakup = (select count(*) from det2 
        where rtrim(sessionid) = rtrim(@sessionid) and category = 'BRANCH' 
        and vno = @vno and costflag = 'C')

/* print "costbreakup= " + str(@@costbreakup,2)  */

   if @@costbreakup > 0 and (@@vtype = '3' or @@vtype = '4') 
      begin
        delete from det2 
        where rtrim(sessionid) = rtrim(@sessionid) and category = 'BRANCH' and upper(branch) = 'ALL'
        and vno = @vno and costflag = 'A'

        delete from det2 	  where rtrim(sessionid) = rtrim(@sessionid) and category = 'BRANCH' and upper(drcr) = 'C'
        and vno = @vno and costflag = 'C'

        insert into det2
         select category, branch, paidamt, vtype, vno, 1, ( case when drcr = 'D' then 'C' else 'D' end), costcode,
             booktype, sessionid, @@party2, costflag, 1 from det2
             where rtrim(sessionid) = rtrim(@sessionid) and category = 'BRANCH' 
             and vno = @vno
	update det2 set costflag = 'A' 
        where rtrim(sessionid) = rtrim(@sessionid) and category = 'BRANCH' 
        and vno = @vno

      end

   if @@costbreakup > 0 and (@@vtype = '1' or @@vtype = '2' )
      begin
        delete from det2 
        where rtrim(sessionid) = rtrim(@sessionid) and category = 'BRANCH' and upper(branch) = 'ALL'
        and vno = @vno and costflag = 'A'

        delete from det2 
        where rtrim(sessionid) = rtrim(@sessionid) and category = 'BRANCH' and upper(drcr) = 'D'
        and vno = @vno and costflag = 'C'

        insert into det2
        select category, branch, paidamt, vtype, vno, 1, ( case when drcr = 'D' then 'C' else 'D' end), costcode,
             booktype, sessionid, @@party2, costflag, 1 from det2
             where rtrim(sessionid) = rtrim(@sessionid) and category = 'BRANCH' 
             and vno = @vno

	update det2 set costflag = 'A' 
        where rtrim(sessionid) = rtrim(@sessionid) and category = 'BRANCH' 
        and vno = @vno

      end
end


if @@Onlyall = 0 
   begin
     if @statusid = 'BRANCH' 
        begin
         insert into vledger2
         select vtype, vno, lno, drcr, paidamt, c.costcode, BookType,upper(party_code)
         from det2 t, costmast c
         where rtrim(sessionid) = rtrim(@sessionid) and rtrim(costname) = rtrim(@statusname)
         and category = 'BRANCH' and vno =@vno and costflag = 'A'
        end
     else
        begin

	select @@brnachcnt = (select count(branch) from det2 
         where rtrim(sessionid) = rtrim(@sessionid) and vno = @vno and upper(branch) <> 'ALL' )
         

	if @@brnachcnt > 0 
         	begin
			insert into vledger2
         		select vtype, vno, lno, drcr, paidamt, c.costcode, BookType,upper(party_code)
         		from det2 t, costmast c
         		where rtrim(sessionid) = rtrim(@sessionid) and t.branch=c.costname
         		and category = 'BRANCH' and vno =@vno and costflag = 'A'
        	end
     	else
        	begin

	        	insert into vledger2
        		select vtype, vno, lno, drcr, paidamt, c.costcode, BookType,upper(party_code)
         		from det2 t, Branchaccounts b, costmast c
         		where rtrim(sessionid) = rtrim(@sessionid) and DefaultAc = 1 and rtrim(BranchName) = rtrim(costname)
         		and category = 'BRANCH' and vno =@vno and costflag = 'A'

        	end
        end 
   end
else
   if @@OneBranch = 0
      begin
         insert into vledger2
         select vtype, vno, lno, drcr, paidamt, c.costcode, BookType, upper(party_code )
         from det2 t, costmast c
         where rtrim(sessionid) = rtrim(@sessionid) and rtrim(branch) = rtrim(costname)
        and category = 'BRANCH' and vno =@vno and costflag = 'A'
      end
   else
      if @@MultiBranch = 0
         Begin
            insert into vledger2
            select vtype, vno, lno, drcr, paidamt, c.costcode, BookType, upper(party_code)
            from det2 t, costmast c
            where rtrim(sessionid) = rtrim(@sessionid) and rtrim(branch) = rtrim(costname)
            and category = 'BRANCH' and vno =@vno and costflag = 'A'

            insert into vledger2
            select vtype, vno, lno, drcr, paidamt, 
            costcode= ( select costcode from costmast c, branchaccounts b where DefaultAc = 1 and rtrim(branchname) = rtrim(costname)),
            BookType, upper(BrControlAc)
            from det2 t, branchaccounts b
            where rtrim(sessionid) = rtrim(@sessionid) and rtrim(branch) = rtrim(branchname)
            and category = 'BRANCH' and vno =@vno and costflag = 'A' and rtrim(branch) <> rtrim(@@mainbr)

            insert into vledger2
            select vtype, vno, lno, ( case when drcr= 'd' or drcr = 'D' then 'C' else 'D' end),
                   paidamt, c.costcode, BookType, upper(MainControlAc)
            from det2 t, costmast c, branchaccounts b
            where rtrim(sessionid) = rtrim(@sessionid) and rtrim(branch) = rtrim(costname)
            and rtrim(BranchName) = rtrim(branch) and category = 'BRANCH' and vno =@vno and costflag = 'A'
   and rtrim(branch) <> rtrim(@@mainbr)
         end
      else
     if @@OneBranchAll = 0 
            begin
               set @@rcursor = cursor for
    select branch from det2 where category = 'BRANCH' and rtrim(sessionid) = rtrim(@sessionid)
               and vno = @vno and branch <> 'ALL' and costflag = 'A' order by branch
               open @@rcursor
               fetch next from @@rcursor into @@branch 
               while @@fetch_status = 0
                  begin
                     select @@costcode1 = ( select costcode from costmast where rtrim(@@branch) = rtrim(costname))
                     fetch next from @@rcursor into @@branch 
                  end
               close @@rcursor
               deallocate @@rcursor

               insert into vledger2
               select vtype, vno, lno, drcr, paidamt, c.costcode, BookType, upper(party_code)
               from det2 t, costmast c
               where rtrim(sessionid) = rtrim(@sessionid) and rtrim(branch) = rtrim(costname)
              and category = 'BRANCH' and vno =@vno and costflag = 'A'

               insert into vledger2
               select vtype, vno, lno, drcr, paidamt, @@costcode1, BookType, upper(party_code)
               from det2 t
               where rtrim(sessionid) = rtrim(@sessionid) and rtrim(branch) = 'ALL'
               and category = 'BRANCH' and vno =@vno and costflag = 'A'
            end
end

if @costcenterflag  = 1
begin
insert into vledger2
select vtype, @vno, lno, drcr, paidamt, costcode, BookType,upper(party_code )
from det2 t
where rtrim(sessionid) = rtrim(@sessionid) and /* category <> 'BRANCH' and */ vno = @vno and costflag = 'C'
end

GO
