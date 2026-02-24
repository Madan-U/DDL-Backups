-- Object: PROCEDURE dbo.acc_opbal_HIS
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

CREATE procedure acc_opbal_HIS
@sdate varchar(11),            /* As mmm dd yyyy */  
@edate varchar(11),            /* As mmm dd yyyy */  
@fdate varchar(11),            /* As mmm dd yyyy */  
@tdate varchar(11),            /* As mmm dd yyyy */  
@fcode varchar(10),  
@tcode varchar(10),  
@statusId varchar(30),  
@statusname varchar(30),  
@branch varchar(10),  
@selectionby varchar(3),  
@GroupBy varchar(10),  
@Sortby varchar(50),  
@reportname varchar(30),  
@reportopt varchar(10),  
@fld1 varchar(10),  
@fld2 varchar(10),  
@fld3 varchar(10)  
  
as  
declare  
@@opendate   as varchar(11)  
  
/* -------------------------------------------------------------------------- */  
  
if @fdate =''  
begin  
   select @fdate = @sdate  
end  
  
if @tdate = ''  
begin  
   select @tdate = @edate  
end  
  
if @Reportname <> 'MarginLedger'  
begin  
/* Get Opendate from sdate, fdate received as parameter */  
   if upper(@selectionby) = 'VDT'  
      begin  
         select @@opendate = ( select left(convert(varchar,isnull(max(vdt),0),109),11) from ledger_HIS where vtyp = 18 and vdt <= @fdate )  
      end  
   else  
      begin  
         select @@opendate = ( select left(convert(varchar,isnull(max(edt),0),109),11) from ledger_HIS where vtyp = 18 and edt <= @fdate )  
   end  
  
Print @@opendate  
  
/* -------------------------------------------------------------------------- */       
   if rtrim(@branch) = '' or rtrim(@branch) = '%'   
      begin  
         if upper(@selectionby) = 'VDT'  
            begin  
               if @sdate = @fdate  
                  begin  
                     if @@opendate = @fdate   
                        begin  
                  select cltcode, opbal = sum( case when upper(drcr) = 'D' then vamt else -vamt end)  
                 from ledger_HIS   
                 where cltcode = @fcode and vdt like @@opendate + '%' and vtyp = 18  
                 group by cltcode  
   end  
                     else  
   begin  
                 select cltcode, opbal = sum( case when upper(drcr) = 'D' then vamt else -vamt end)  
                 from ledger_HIS   
                 where cltcode = @fcode and vdt >= @@opendate + ' 00:00:00' and vdt < @fdate   
                 group by cltcode  
   end  
                  end  
               else  
                  begin  
                select cltcode, opbal = sum( case when upper(drcr) = 'D' then vamt else -vamt end)  
                from ledger_HIS   
                where cltcode = @fcode and vdt >= @@opendate + ' 00:00:00' and vdt < @fdate   
                group by cltcode  
    end  
           end  
        else  
           begin  
              if @sdate = @fdate and @@opendate = @fdate  
                 begin  
                select cltcode, opbal = sum(balamt)  
                from ledger_HIS   
                where cltcode = @fcode and edt like @@opendate + '%' and vtyp = 18  
                group by cltcode  
                 end  
              else  
                 begin  
                 select cltcode, opbal=sum(opbal)  
                from  
                ( select cltcode, opbal = sum(balamt)  
                  from ledger_HIS   
                  where cltcode = @fcode and edt like @@opendate + '%' and vtyp = 18  
                  group by cltcode  
                  union all  
                  select cltcode, opbal = sum( case when upper(drcr) = 'D' then vamt else -vamt end)  
                  from ledger_HIS   
                  where cltcode = @fcode and edt >= @@opendate + ' 00:00:00' and edt < @fdate and vtyp <> 18  
                  group by cltcode ) t  
                group by cltcode  
                 end  
            end  
 end  
   else  
      begin  
if upper(@selectionby) = 'VDT'  
            begin  
        if @sdate = @fdate  
           begin  
     if @@opendate = @fdate   
   begin  
                select l2.cltcode, opbal = sum( case when upper(l2.drcr) = 'D' then camt else -camt end)  
                from ledger2_HIS l2, ledger_HIS l, costmast cm  
                where l2.cltcode = @fcode and vdt like @@opendate + '%' and vtype = 18  
                       and l2.vtype = l.vtyp and l2.booktype = l.booktype and l2.vno = l.vno and l2.lno = l.lno  
   and l2.costcode = cm.costcode and upper(rtrim(cm.costname)) = upper(rtrim(@branch))  
                group by l2.cltcode  
  end  
  else  
  begin  
                select l2.cltcode, opbal = sum( case when upper(l2.drcr) = 'D' then camt else -camt end)  
                from ledger2_HIS l2, ledger_HIS l, costmast cm  
                where l2.cltcode = @fcode and vdt >= @@opendate + ' 00:00:00' and vdt < @fdate   
                       and l2.vtype = l.vtyp and l2.booktype = l.booktype and l2.vno = l.vno and l2.lno = l.lno  
   and l2.costcode = cm.costcode and upper(rtrim(cm.costname)) = upper(rtrim(@branch))  
                group by l2.cltcode  
  end  
            end  
         else  
            begin  
               select l2.cltcode, opbal = sum( case when upper(l2.drcr) = 'D' then camt else -camt end)  
               from ledger2_HIS l2, ledger_HIS l, costmast cm  
               where l2.cltcode = @fcode and vdt >= @@opendate + ' 00:00:00' and vdt < @fdate   
               and l2.vtype = l.vtyp and l2.booktype = l.booktype and l2.vno = l.vno and l2.lno = l.lno  
  and l2.costcode = cm.costcode and upper(rtrim(cm.costname)) = upper(rtrim(@branch))  
               group by l2.cltcode  
            end  
       end  
    else  
      begin  
         if @sdate = @fdate and @@opendate = @fdate  
            begin  
               select l2.cltcode, opbal = sum(camt)  
               from ledger2_HIS l2, ledger_HIS l, costmast cm  
               where l2.cltcode = @fcode and edt like @@opendate + '%' and vtype = 18  
               and l2.vtype = l.vtyp and l2.booktype = l.booktype and l2.vno = l.vno and l2.lno = l.lno  
  and l2.costcode = cm.costcode and upper(rtrim(cm.costname)) = upper(rtrim(@branch))  
               group by l2.cltcode  
            end  
         else  
            begin  
               select l2.cltcode, opbal=sum(opbal)  
               from  
               ( select l2.cltcode, opbal = sum(camt)  
                 from ledger2_HIS, ledeger_HIS l, costmast cm  
                 where l2.cltcode = @fcode and edt like @@opendate + '%' and vtype = 18  
                 and l2.vtype = l.vtyp and l2.booktype = l.booktype and l2.vno = l.vno and l2.lno = l.lno  
  and l2.costcode = cm.costcode and upper(rtrim(cm.costname)) = upper(rtrim(@branch))  
                 group by l2.cltcode  
                 union all  
                 select l2.cltcode, opbal = sum( case when upper(drcr) = 'D' then camt else -camt end)  
                 from ledger2_HIS l2, ledger_HIS l, costmast cm  
                 where l2.cltcode = @fcode and edt >= @@opendate + ' 00:00:00' and edt < @fdate and vtype <> 18  
                 and l2.vtype = l.vtyp and l2.booktype = l.booktype and l2.vno = l.vno and l2.lno = l.lno  
  and l2.costcode = cm.costcode and upper(rtrim(cm.costname)) = upper(rtrim(@branch))  
                 group by l2.cltcode ) t  
               group by l2.cltcode  
            end  
      end  
    end  
end  
  
  
if @Reportname = 'MarginLedger'  
begin  
/* Get Opendate from sdate, fdate received as parameter */  
   if upper(@selectionby) = 'VDT'  
      begin  
         select @@opendate = ( select left(convert(varchar,isnull(max(vdt),0),109),11) from marginledger where vtyp = 18 and vdt <= @fdate )  
      end  
   else  
      begin  
         select @@opendate = ( select left(convert(varchar,isnull(max(vdt),0),109),11) from marginledger where vtyp = 18 and vdt <= @fdate )  
   end  
  
/* -------------------------------------------------------------------------- */       
   if upper(@selectionby) = 'VDT'  
   begin  
         if @sdate = @fdate  
            begin  
  if @@opendate = @fdate   
  begin  
                select cltcode=party_code, opbal = sum( case when upper(drcr) = 'D' then amount else -amount end)  
                from marginledger   
                where party_code = @fcode and vdt like @@opendate + '%' and vtyp = 18  
                group by party_code  
  end  
  else  
  begin  
      select cltcode=party_code, opbal = sum( case when upper(drcr) = 'D' then amount else -amount end)  
                from marginledger   
                where party_code = @fcode and vdt >= @@opendate + ' 00:00:00' and vdt < @fdate   
                group by party_code  
  end  
            end  
         else  
            begin  
     select cltcode=party_code, opbal = sum( case when upper(drcr) = 'D' then amount else -amount end)  
               from marginledger   
               where party_code = @fcode and vdt >= @@opendate + ' 00:00:00' and vdt < @fdate   
               group by party_code  
            end  
      end  
   else  
      begin  
         if @sdate = @fdate and @@opendate = @fdate  
            begin  
               select cltcode=party_code, opbal = sum(sett_no)  
               from marginledger   
               where party_code = @fcode and vdt LIKE @@opendate + '%' and vtyp = 18  
               group by party_code  
            end  
         else  
            begin  
               select cltcode, opbal=sum(opbal)  
               from  
               ( select cltcode=party_code, opbal = sum(sett_no)  
                 from marginledger   
                 where party_code = @fcode and vdt LIKE @@opendate + '%' and vtyp = 18  
                 group by party_code  
                 union all  
                 select cltcode=party_code, opbal = sum( case when upper(drcr) = 'D' then amount else -amount end)  
                 from marginledger   
                 where party_code = @fcode and vdt >= @@opendate + ' 00:00:00' and vdt < @fdate and vtyp <> 18  
                 group by party_code) t  
               group by cltcode  
            end  
      end  
end

GO
