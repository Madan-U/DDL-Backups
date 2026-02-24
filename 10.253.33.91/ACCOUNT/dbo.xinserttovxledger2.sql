-- Object: PROCEDURE dbo.xinserttovxledger2
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

/****** Object:  Stored Procedure dbo.inserttovxledger2    Script Date: 12/27/2002 4:39:13 PM ******/

/****** Object:  Stored Procedure dbo.inserttovxledger2    Script Date: 12/04/2002 1:48:26 PM ******/
/****** Object:  Stored Procedure dbo.inserttovxledger2    Script Date: 10/12/2002 6:11:04 PM ******/
CREATE proc xinserttovxledger2
@sessionid varchar(15),
@vno varchar(12),
@branchflag tinyint,
@costcenterflag tinyint,
@costenable char(1)


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

@@costcode1 tinyint,

/* Fields retrived from Tempvxledger2 */
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
   
@@rcursor as cursor

if @costcenterflag  = 1
begin
insert into vxledger2
select vtype, @vno, lno, drcr, paidamt, costcode, BookType,upper(party_code )
from vtled2 t
where rtrim(sessionid) = rtrim(@sessionid) and /* category <> 'BRANCH' and */ vno = @vno and costflag = 'C'
end 

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

set @@rcursor = cursor for
select category,branch,paidamt,vtype,vno,lno,drcr,costcode,booktype,sessionid,party_code 
from vtled2 where category = 'BRANCH' and rtrim(sessionid) = rtrim(@sessionid) and vno =@vno and costflag = 'A'
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

select "AllCount = " + convert(varchar,@@Allcount)
select "BranchCount = " + convert(varchar,@@BranchCount)

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

select "Onlyall = " + convert(varchar,@@onlyall)
select "OneBranch = " + convert(varchar,@@onebranch)
select "MultiBranch = " + convert(varchar,@@multibranch)
select "OneBranchall = " + convert(varchar,@@onebranchall)
select "MultiBranchall = " + convert(varchar,@@Multibranchall)


if @@Onlyall = 0 
   begin
         insert into vxledger2
         select vtype, vno, lno, drcr, paidamt, c.costcode, BookType,upper(party_code)
         from vtled2 t, Branchaccounts b, costmast c
         where rtrim(sessionid) = rtrim(@sessionid) and DefaultAc = 1 and rtrim(BranchName) = rtrim(costname)
         and category = 'BRANCH' and vno =@vno and costflag = 'A'
   end
else
   if @@OneBranch = 0
      begin
         insert into vxledger2
         select vtype, vno, lno, drcr, paidamt, c.costcode, BookType, upper(party_code )
         from vtled2 t, costmast c
         where rtrim(sessionid) = rtrim(@sessionid) and rtrim(branch) = rtrim(costname)
        and category = 'BRANCH' and vno =@vno and costflag = 'A'
      end
   else
      if @@MultiBranch = 0
         Begin
            insert into vxledger2
            select vtype, vno, lno, drcr, paidamt, c.costcode, BookType, upper(party_code)
            from vtled2 t, costmast c
            where rtrim(sessionid) = rtrim(@sessionid) and rtrim(branch) = rtrim(costname)
            and category = 'BRANCH' and vno =@vno and costflag = 'A'

            insert into vxledger2
            select vtype, vno, lno, drcr, paidamt, 
            costcode= ( select costcode from costmast c, branchaccounts b where DefaultAc = 1 and rtrim(branchname) = rtrim(costname)),
            BookType, upper(BrControlAc)
            from vtled2 t, branchaccounts b
            where rtrim(sessionid) = rtrim(@sessionid) and rtrim(branch) = rtrim(branchname)
            and category = 'BRANCH' and vno =@vno and costflag = 'A'

            insert into vxledger2
            select vtype, vno, lno, ( case when drcr= 'd' or drcr = 'D' then 'C' else 'D' end),
                   paidamt, c.costcode, BookType, upper(MainControlAc)
            from vtled2 t, costmast c, branchaccounts b
            where rtrim(sessionid) = rtrim(@sessionid) and rtrim(branch) = rtrim(costname)
            and rtrim(BranchName) = rtrim(branch) and category = 'BRANCH' and vno =@vno and costflag = 'A'
         end
      else
         if @@OneBranchAll = 0 
            begin
               set @@rcursor = cursor for
               select branch from vtled2 where category = 'BRANCH' and rtrim(sessionid) = rtrim(@sessionid)
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

               insert into vxledger2
               select vtype, vno, lno, drcr, paidamt, c.costcode, BookType, upper(party_code)
               from vtled2 t, costmast c
               where rtrim(sessionid) = rtrim(@sessionid) and rtrim(branch) = rtrim(costname)
              and category = 'BRANCH' and vno =@vno and costflag = 'A'

               insert into vxledger2
               select vtype, vno, lno, drcr, paidamt, @@costcode1, BookType, upper(party_code)
               from vtled2 t
               where rtrim(sessionid) = rtrim(@sessionid) and rtrim(branch) = 'ALL'
               and category = 'BRANCH' and vno =@vno and costflag = 'A'
            end
end

GO
