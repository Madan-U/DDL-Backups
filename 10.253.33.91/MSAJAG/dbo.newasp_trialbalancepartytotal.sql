-- Object: PROCEDURE dbo.newasp_trialbalancepartytotal
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.newasp_trialbalancepartytotal    Script Date: 12/04/2002 2:04:37 PM ******/
CREATE PROCEDURE  newasp_trialbalancepartytotal

/* report : consolidated trial balance        
file : trialbal.asp
displays consolidated trial balance */


@vdt varchar(11),               /* As on date entered by user */
@flag varchar(15),              /* sort order for report - Codewise or Namewise */
@viewoption varchar(10),        /* options for accounts selection - ALL, GL, PARTY */
@balance varchar(10),           /* Normal or Withopbal */
@stdate varchar(11),            /* Start date entered by user */
@curryrstdate varchar(11),	/* start date of financial year */
@openentryflag int,
@openingentrydate varchar(11),  /* O/p entry date ( vtyp = 18 ) fround from ledger for vdt <= last date entered by user */
@statusid varchar(20),          /* As Broker/Branch/Client etc. */
@statusname varchar(20),        /* In case of Branch login branchcode */
@sortbydate varchar(3)          /* Whether report is based on VDT or EDT */

AS

declare
@@selectqury  as varchar(8000),
@@fromtables  as varchar(2000),
@@wherepart   as varchar(1000),
@@wherepart1  as varchar(500),
@@wherepart2  as varchar(500),
@@wherepart3  as varchar(500),
@@addwhere    as varchar(200),
@@Groupby     as varchar(200),
@@sortby      as varchar(200),
@@costcode    as varchar(3)
/*
select @@Groupby = " group by l.drcr "
select @@sortby  = " order by  l.drcr "
*/

select @@Groupby = " "
select @@sortby  = " "

select @@addwhere  = " and a.accat = 4 " 

if @statusid = 'Broker'
begin
   if @sortbydate = 'vdt'
   begin
      select @@wherepart1 = " where vdt <= '" + @vdt + " 23:59:59' " 
      select @@wherepart2 = " where vdt >= '" + @curryrstdate + " 00:00:00' and vdt <= '" + @vdt + " 23:59:59'" 
      select @@wherepart3 = " where vdt >= '" + @openingentrydate + " 00:00:00' and vdt <= '" + @vdt + " 23:59:59'" 
   end
   else
   begin
      select @@wherepart1 = " where edt <= '" + @vdt + " 23:59:59' " 
      select @@wherepart2 = " where edt >= '" + @curryrstdate + " 00:00:00' and edt <= '" + @vdt + " 23:59:59'" 
      select @@wherepart3 = " where edt >= '" + @openingentrydate + " 00:00:00' and edt <= '" + @vdt + " 23:59:59'" 
   end
end
else if @statusid = 'branch'
begin
   select @@costcode = (select costcode from account.dbo.costmast c, account.dbo.category c2 where c2.category = 'BRANCH' and c.catcode = c2.catcode and costname = @statusname )
   if @sortbydate = 'vdt'
   begin
      select @@wherepart1 = " where l2.vtype = l.vtyp and l2.booktype = l.booktype and l2.vno = l.vno and l2.lno = l.lno and costcode = '" + @@costcode + "' and vdt <= '" + @vdt + " 23:59:59' " 
      select @@wherepart2 = " where l2.vtype = l.vtyp and l2.booktype = l.booktype and l2.vno = l.vno and l2.lno = l.lno and costcode = '" + @@costcode + "' and vdt >= '" + @curryrstdate + " 00:00:00' and vdt <= '" + @vdt + " 23:59:59'" 
      select @@wherepart3 = " where l2.vtype = l.vtyp and l2.booktype = l.booktype and l2.vno = l.vno and l2.lno = l.lno and costcode = '" + @@costcode + "' and vdt >= '" + @openingentrydate + " 00:00:00' and vdt <= '" + @vdt + " 23:59:59'" 
   end
   else
   begin
      select @@wherepart1 = " where l2.vtype = l.vtyp and l2.booktype = l.booktype and l2.vno = l.vno and l2.lno = l.lno and costcode = '" + @@costcode + "' and edt <= '" + @vdt + " 23:59:59' " 
      select @@wherepart2 = " where l2.vtype = l.vtyp and l2.booktype = l.booktype and l2.vno = l.vno and l2.lno = l.lno and costcode = '" + @@costcode + "' and edt >= '" + @curryrstdate + " 00:00:00' and edt <= '" + @vdt + " 23:59:59'" 
    select @@wherepart3 = " where l2.vtype = l.vtyp and l2.booktype = l.booktype and l2.vno = l.vno and l2.lno = l.lno and costcode = '" + @@costcode + "' and edt >= '" + @openingentrydate + " 00:00:00' and edt <= '" + @vdt + " 23:59:59'" 
   end
end

/*  -- FOR BROKER --  */
/* ------------------ */

if @statusid = 'Broker'
begin
/*---- If user wants to see NORMAL trial balance ---*/
if @balance='normal'
begin
   if @openentryflag = 0   /* Opening entry ( vtyp = 18 ) not found in Ledger */
   begin
      select @@selectqury = "select Amount = sum(case when drcr = 'd' then vamt else -vamt end)"
      select @@fromtables = " from account.dbo.ledger l left outer join account.dbo.acmast a on l.cltcode=  a.cltcode " 
      select @@wherepart  = @@wherepart1 + @@addwhere
   end
   else if @openentryflag = 1  /* Opening entry ( vtyp = 18 ) found in Ledger for selected year */
   begin
      select @@selectqury = "select Amount = sum(case when drcr = 'd' then vamt else -vamt end)"
      select @@fromtables = " from account.dbo.ledger l left outer join account.dbo.acmast a on l.cltcode=  a.cltcode " 
      select @@wherepart  = @@wherepart2 + @@addwhere
   end
   else if @openentryflag = 2  /* Opening entry ( vtyp = 18 ) found in Ledger for earlier year */
   begin
      select @@selectqury = "select Amount = sum(case when drcr = 'd' then vamt else -vamt end)"
      select @@fromtables = " from account.dbo.ledger l left outer join account.dbo.acmast a on l.cltcode=  a.cltcode " 
      select @@wherepart  = @@wherepart3 + @@addwhere
   end
end
/*--- If user wants to see Trial balance With Opening Balances ---*/
else if @balance='withopbal'
begin
   if @openentryflag = 0   /* Opening entry ( vtyp = 18 ) not found in Ledger */
   begin
      if @curryrstdate = @stdate 
         begin
            select @@selectqury = "select drtot = sum(case when drcr = 'd' then vamt else 0 end), crtot = sum(case when drcr = 'c' then vamt else 0 end),opbal = 0 "
            select @@fromtables = " from account.dbo.ledger l left outer join account.dbo.acmast a on l.cltcode=  a.cltcode " 
            select @@wherepart  = @@wherepart1 + @@addwhere
         end
      else
         begin
           select @@selectqury = "select drtot = sum(case when vtyp <> 18 and vdt >= '" + @stdate + "' then ( case when drcr = 'd' then vamt else 0 end) else 0 end), crtot = sum(case when vtyp <> 18 and  vdt >= '" + @stdate + "' then ( case when drcr = 'c' then vamt else 0 end) else 0 end), opbal = sum(case when vdt < '" + @stdate + "' then ( case when drcr = 'd' then vamt else -vamt end) else 0 end) "
           select @@fromtables = " from account.dbo.ledger l left outer join account.dbo.acmast a on l.cltcode=  a.cltcode " 
           select @@wherepart  = @@wherepart1 + @@addwhere
         end
   end
   else if @openentryflag = 1  /* Opening entry ( vtyp = 18 ) found in Ledger for selected year */
   begin
      if @curryrstdate = @stdate 
         begin
            select @@selectqury = "select drtot = sum(case when vtyp <> 18 and vdt >= '" + @stdate + "' then ( case when drcr = 'd' then vamt else 0 end) else 0 end), crtot = sum(case when vtyp <> 18 and vdt >= '" + @stdate + "' then ( case when drcr = 'c' then vamt else 0 end) else 0 end), opbal = sum(case when vtyp = 18 then ( case when drcr = 'd' then vamt else -vamt end) else 0 end)"
            select @@fromtables = " from account.dbo.ledger l left outer join account.dbo.acmast a on l.cltcode=  a.cltcode " 
            select @@wherepart  = @@wherepart2 + @@addwhere
         end
      else
         begin
           select @@selectqury = "select drtot = sum(case when vtyp <> 18 and vdt >= '" + @stdate + "' then ( case when drcr = 'd' then vamt else 0 end) else 0 end), crtot = sum(case when vtyp <> 18 and vdt >= '" + @stdate + "' then ( case when drcr = 'c' then vamt else 0 end) else 0 end), opbal = sum(case when vdt < '" + @stdate + "' then ( case when drcr = 'd' then vamt else -vamt end) else 0 end) "
           select @@fromtables = " from account.dbo.ledger l left outer join account.dbo.acmast a on l.cltcode=  a.cltcode " 
           select @@wherepart  = @@wherepart2 + @@addwhere
         end
   end
   else if @openentryflag = 2  /* Opening entry ( vtyp = 18 ) found in Ledger for earlier year */
   begin
      select @@selectqury = "select drtot = sum(case when vtyp <> 18 and vdt >= '" + @stdate + "' then ( case when drcr = 'd' then vamt else 0 end) else 0 end), crtot = sum(case when vtyp <> 18 and vdt >= '" + @stdate + "' then ( case when drcr = 'c' then vamt else 0 end) else 0 end), opbal = sum(case when vdt < '" + @stdate + "' then ( case when drcr = 'd' then vamt else -vamt end) else 0 end) "
      select @@fromtables = " from account.dbo.ledger l left outer join account.dbo.acmast a on l.cltcode=  a.cltcode " 
      select @@wherepart  = @@wherepart3 + @@addwhere
   end
end
end    /* End og Statusid = 'Broker'  */


/*  -- FOR BRANCH SELECTION --  */
/* ---------------------------- */

if @statusid = 'Branch'
begin
/*---- If user wants to see NORMAL trial balance ---*/
if @balance='normal'
begin
   if @openentryflag = 0   /* Opening entry ( vtyp = 18 ) not found in Ledger */
   begin
      select @@selectqury = " select Amount = sum(case when l2.drcr = 'd' then camt else -camt end)"
      select @@fromtables = " from account.dbo.ledger2 l2, account.dbo.ledger l left outer join account.dbo.acmast a on l.cltcode=  a.cltcode  " 
      select @@wherepart  = @@wherepart1 + @@addwhere
   end
   else if @openentryflag = 1  /* Opening entry ( vtyp = 18 ) found in Ledger for selected year */
   begin
      select @@selectqury = " select Amount = sum(case when l2.drcr = 'd' then camt else -camt end)"
      select @@fromtables = " from account.dbo.ledger2 l2, account.dbo.ledger l left outer join account.dbo.acmast a on l.cltcode=  a.cltcode  " 
      select @@wherepart  = @@wherepart2 + @@addwhere
   end
   else if @openentryflag = 2  /* Opening entry ( vtyp = 18 ) found in Ledger for earlier year */
   begin
      select @@selectqury = " select Amount = sum(case when l2.drcr = 'd' then camt else -camt end)"
      select @@fromtables = " from account.dbo.ledger2 l2, account.dbo.ledger l left outer join account.dbo.acmast a on l.cltcode=  a.cltcode  " 
      select @@wherepart  = @@wherepart3 + @@addwhere
   end
end
else if @balance='withopbal'
begin
   if @openentryflag = 0   /* Opening entry ( vtyp = 18 ) not found in Ledger */
   begin
      if @curryrstdate = @stdate 
         begin
            select @@selectqury = "select drtot = sum(case when l2.drcr = 'd' then camt else 0 end), crtot = sum(case when l2.drcr = 'c' then camt else 0 end),opbal = 0 "
            select @@fromtables = " from account.dbo.ledger2 l2, account.dbo.ledger l left outer join account.dbo.acmast a on l.cltcode=  a.cltcode  " 
            select @@wherepart  = @@wherepart1 + @@addwhere
         end
      else
         begin
           select @@selectqury = "select drtot = sum(case when l.vtyp <> 18 and l.vdt >= '" + @stdate + "' then ( case when l2.drcr = 'd' then camt else 0 end) else 0 end), crtot = sum(case when l.vtyp <> 18 and l.vdt >= '" + @stdate + "' then ( case when l2.drcr = 'c' then camt else 0 end) else 0 end), opbal = sum(case when l.vdt < '" + @stdate + "' then ( case when l2.drcr = 'd' then camt else -camt end) else 0 end) "
           select @@fromtables = " from account.dbo.ledger2 l2, account.dbo.ledger l left outer join account.dbo.acmast a on l.cltcode=  a.cltcode  " 
           select @@wherepart  = @@wherepart1 + @@addwhere
         end
   end
   else if @openentryflag = 1  /* Opening entry ( vtyp = 18 ) found in Ledger for selected year */
   begin
      if @curryrstdate = @stdate 
         begin
            select @@selectqury = "select drtot = sum(case when l.vtyp <> 18 and l.vdt >= '" + @stdate + "' then ( case when l2.drcr = 'd' then camt else 0 end) else 0 end), crtot = sum(case when l.vtyp <> 18 and l.vdt >= '" + @stdate + "' then ( case when l2.drcr = 'c' then camt else 0 end) else 0 end), opbal = sum(case when l.vtyp = 18 then ( case when l2.drcr = 'd' then camt else -camt end) else 0 end)"
            select @@fromtables = " from account.dbo.ledger2 l2, account.dbo.ledger l left outer join account.dbo.acmast a on l.cltcode=  a.cltcode  " 
            select @@wherepart  = @@wherepart2 + @@addwhere
         end
      else
         begin
           select @@selectqury = "select drtot = sum(case when l.vtyp <> 18 and l.vdt >= '" + @stdate + "' then ( case when l2.drcr = 'd' then camt else 0 end) else 0 end), crtot = sum(case when l.vtyp <> 18 and l.vdt >= '" + @stdate + "' then ( case when l2.drcr = 'c' then camt else 0 end) else 0 end), opbal = sum(case when l.vdt < '" + @stdate + "' then ( case when l2.drcr = 'd' then camt else -camt end) else 0 end) "
           select @@fromtables = " from account.dbo.ledger2 l2, account.dbo.ledger l left outer join account.dbo.acmast a on l.cltcode=  a.cltcode  " 
           select @@wherepart  = @@wherepart2 + @@addwhere
         end
   end
   else if @openentryflag = 2  /* Opening entry ( vtyp = 18 ) found in Ledger for earlier year */
   begin
      select @@selectqury = "select drtot = sum(case when l.vtyp <> 18 and l.vdt >= '" + @stdate + "' then ( case when l2.drcr = 'd' then camt else 0 end) else 0 end), crtot = sum(case when l.vtyp <> 18 and l.vdt >= '" + @stdate + "' then ( case when drcr = 'c' then camt else 0 end) else 0 end), opbal = sum(case when l.vdt < '" + @stdate + "' then ( case when l2.drcr = 'd' then camt else -camt end) else 0 end) "
      select @@fromtables = " from account.dbo.ledger2 l2, account.dbo.ledger l left outer join account.dbo.acmast a on l.cltcode=  a.cltcode  " 
      select @@wherepart  = @@wherepart3 + @@addwhere
   end
end
end /* End of Branch login or Branch selection from Broker login */

/*  print @@selectqury + @@fromtables + @@wherepart + @@groupby + @@sortby   */

exec (@@selectqury + @@fromtables + @@wherepart + @@groupby + @@sortby )

GO
