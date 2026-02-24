-- Object: PROCEDURE dbo.acc_partybalanceTest
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------





/****** Object:  Stored Procedure dbo.acc_partybalanceTest    Script Date: 12/01/2004 18:54:22 ******/

/****** Object:  Stored Procedure dbo.acc_partybalanceTest    Script Date: 07/29/2004 21:15:15 ******/
/****** Object:  Stored Procedure dbo.acc_partybalance    Script Date: 05/13/2003 6:08:54 PM ******/
/* 
Exec acc_partybalance 'May 19 2003', 'vdt','Partywise','Normal','Apr 1 2003', 'Apr 1 2003', 1,'Apr 1 2003', 'BROKER', '%', 'vdt', 'A06075', 'A06075' 
*/
CREATE PROCEDURE [dbo].[acc_partybalanceTest]

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
@sortbydate varchar(3),          /* Whether report is based on VDT or EDT */
@fparty varchar(10),
@tparty varchar(10),
@extra varchar(1)

AS

declare
@@selectqury  as varchar(8000),
@@fromtables  as varchar(2000),
@@wherepart   as varchar(1000),
@@wherepart1  as varchar(500),
@@wherepart2  as varchar(500),
@@wherepart3  as varchar(500),
@@mwherepart1 as varchar(500),
@@mwherepart2 as varchar(500),
@@mwherepart3 as varchar(500),
@@addwhere    as varchar(200),
@@addwhere1   as varchar(200),
@@Groupby     as varchar(200),
@@sortby      as varchar(200),
@@costcode    as varchar(3)

if upper(@statusid) = 'BROKER'
begin
	select @@Groupby    = " group by l.Cltcode , a.acname, branchcode"
end
else
begin
	select @@Groupby    = " group by l.Cltcode , a.acname, branchcode"
end

if upper(@statusid) = 'BROKER'
begin
	if @flag = 'codewise'
	begin
	   select @@sortby = " order by  l.Cltcode, a.acname, branchcode"
	end
	else	
	begin	
	   select @@sortby = " order by  a.acname, l.Cltcode, branchcode"
	end
end
else
begin
	if @flag = 'codewise'
	begin
	   select @@sortby = " order by  l.Cltcode, a.acname, branchcode"
	end
	else	
	begin	
	   select @@sortby = " order by  a.acname, l.Cltcode, branchcode"
	end
end

if @viewoption = 'Partywise'  /* Only Party accounts to be displayed */
begin
   select @@addwhere  = "  and  a.accat in (4,104) and a.cltcode >= '" + @fparty + "' and a.cltcode <= '" + @tparty + "' "
   select @@addwhere1  = " and a.cltcode=c2.party_code and c1.cl_code=c2.cl_code "
end
else if @viewoption = 'GL'  /* Only Party accounts to be displayed */
     begin
        select @@addwhere  = " and a.accat not in (4,104) " 
     end
     else
     begin
        select @@addwhere  = " " 
     end

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
      select @@mwherepart2 = @@wherepart2 + " and l.vtyp = m.vtyp and l.booktype = m.booktype and l.vno = m.vno " 
      select @@mwherepart3 = @@wherepart3 + " and l.vtyp = m.vtyp and l.booktype = m.booktype and l.vno = m.vno " 
   end
end

 if @statusid = 'branch'
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
      select @@mwherepart2 = @@wherepart2 + " and l.vtyp = m.vtyp and l.booktype = m.booktype and l.vno = m.vno " 
      select @@mwherepart3 = @@wherepart3 + " and l.vtyp = m.vtyp and l.booktype = m.booktype and l.vno = m.vno " 
   end
end 

 if @statusid = 'subbroker'
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
      select @@mwherepart2 = @@wherepart2 + " and l.vtyp = m.vtyp and l.booktype = m.booktype and l.vno = m.vno " 
      select @@mwherepart3 = @@wherepart3 + " and l.vtyp = m.vtyp and l.booktype = m.booktype and l.vno = m.vno " 
   end
end 


 if @statusid = 'FAMILY'
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
      select @@mwherepart2 = @@wherepart2 + " and l.vtyp = m.vtyp and l.booktype = m.booktype and l.vno = m.vno " 
      select @@mwherepart3 = @@wherepart3 + " and l.vtyp = m.vtyp and l.booktype = m.booktype and l.vno = m.vno " 
   end
end 


 if @statusid = 'Client'
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
      select @@mwherepart2 = @@wherepart2 + " and l.vtyp = m.vtyp and l.booktype = m.booktype and l.vno = m.vno " 
      select @@mwherepart3 = @@wherepart3 + " and l.vtyp = m.vtyp and l.booktype = m.booktype and l.vno = m.vno " 
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
      select @@selectqury = "select l.cltcode , acname=isnull(a.acname,''), branchcode, Amount = sum(case when upper(drcr) = 'D' then vamt else -vamt end), unrealamt = sum(case when edt > CONVERT(DATETIME,LEFT(CONVERT(VARCHAR, GETDATE(),109),11) + ' 23:59:59')  then (case when upper(drcr) = 'D' then vamt else -vamt end)else 0 end), margin = isnull(( select sum(case when upper(drcr) = 'D' then amount else -amount end) from marginledger m "
      select @@fromtables = @@wherepart + " and m.party_code = l.cltcode ),0) " + "from ledger l left outer join acmast a on l.cltcode=  a.cltcode , mcdx.dbo.client1 c1  ,mcdx.dbo.client2 c2  " 
      select @@wherepart  = @@wherepart1 + @@addwhere + @@addwhere1
   end
   else if @openentryflag = 1  /* Opening entry ( vtyp = 18 ) found in Ledger for selected year */
   begin
      if @sortbydate = 'vdt'
         begin
            select @@selectqury = "select l.cltcode , acname=isnull(a.acname,''), branchcode, Amount = sum(case when upper(drcr) = 'D' then vamt else -vamt end), unrealamt = sum(case when edt > CONVERT(DATETIME,LEFT(CONVERT(VARCHAR, GETDATE(),109),11) + ' 23:59:59')  then ( case when upper(drcr) = 'D' then vamt else -vamt end)else 0 end), margin = isnull(( select sum(case when upper(m.drcr) = 'D' then amount else -amount end) from marginledger m "
            select @@fromtables = @@wherepart2 + " and m.party_code = l.cltcode ),0) " +" from ledger l left outer join acmast a on l.cltcode=  a.cltcode , mcdx.dbo.client1 c1  ,mcdx.dbo.client2 c2  " 
            select @@wherepart  = @@wherepart2 + @@addwhere +  @@addwhere1
         end
      else
         begin
	   select @@selectqury = "   select l.cltcode , acname=isnull(a.acname,''), branchcode, "
	   select @@selectqury = @@selectqury + " Amount = sum( case when l.vtyp = 18 then balamt else (case when upper(drcr) = 'D' then vamt else -vamt end) end)," 
	   select @@selectqury = @@selectqury + " unrealamt = sum(case when edt > CONVERT(DATETIME,LEFT(CONVERT(VARCHAR, GETDATE(),109),11) + ' 23:59:59')  then ( case when upper(drcr) = 'D' then vamt else -vamt end)else 0 end),"
	   select @@selectqury = @@selectqury + " margin = isnull(( select sum( case when m.vtyp = 18 then sett_no else (case when upper(m.drcr) = 'D' then amount else -amount end) end) "
	   select @@selectqury = @@selectqury + " from marginledger m, ledger l1  left outer join acmast a on l1.cltcode=  a.cltcode  "
	   select @@selectqury = @@selectqury + @@wherepart2 + @@addwhere
	   select @@selectqury = @@selectqury + " and l1.vtyp = m.vtyp and l1.booktype = m.booktype and l1.vno = m.vno and m.party_code = l1.cltcode and l.cltcode = l1.cltcode),0) "
	   select @@fromtables = " from ledger l left outer join acmast a on l.cltcode=  a.cltcode , mcdx.dbo.client1 c1  ,mcdx.dbo.client2 c2 "
           select @@wherepart  = @@wherepart2 + @@addwhere +   @@addwhere1
         end
   end
   else if @openentryflag = 2  /* Opening entry ( vtyp = 18 ) found in Ledger for earlier year */
   begin
      if @sortbydate = 'vdt'
         begin
            select @@selectqury = "select l.cltcode , acname=isnull(a.acname,''), branchcode, Amount = sum(case when upper(drcr) = 'D' then vamt else -vamt end), unrealamt = sum(case when edt > CONVERT(DATETIME,LEFT(CONVERT(VARCHAR, GETDATE(),109),11) + ' 23:59:59')  then ( case when upper(drcr) = 'D' then vamt else -vamt end)else 0 end), margin = isnull(( select sum(case when upper(m.drcr) = 'D' then amount else -amount end) from marginledger m "
            select @@fromtables = @@wherepart3 + " and m.party_code = l.cltcode ),0) " +" from ledger l left outer join acmast a on l.cltcode=  a.cltcode , mcdx.dbo.client1 c1  ,mcdx.dbo.client2 c2  " 
            select @@wherepart  = @@wherepart3 + @@addwhere + @@addwhere1
         end
      else
         begin
	   select @@selectqury = "  select cltcode, acname, branchcode, amount=sum(amount), unrealamt = sum(unrealamt), "
	   select @@selectqury = @@selectqury  + " margin=sum(margin) from ( select l.cltcode , acname=isnull(a.acname,''), branchcode, "
	   select @@selectqury = @@selectqury  + " Amount = sum(Case When DrCr = 'C' then -Vamt Else Vamt End), unrealamt = sum(case when l.edt > CONVERT(DATETIME,LEFT(CONVERT(VARCHAR, GETDATE(),109),11) + ' 23:59:59')  then ( case when upper(drcr) = 'D' "
	   select @@selectqury = @@selectqury  + " then vamt else -vamt end)else 0 end), margin = isnull(( select sum(case when upper(m.drcr) = 'D' "
	   select @@selectqury = @@selectqury  + " then amount else -amount end) from marginledger m "
	   select @@fromtables = @@mwherepart2 + " and m.party_code = l.cltcode ),0) " + "from ledger l left outer join acmast a on l.cltcode=  a.cltcode , mcdx.dbo.client1 c1  ,mcdx.dbo.client2 c2  " 
      	   select @@wherepart  = @@wherepart2 + @@addwhere + @@addwhere1
           select @@wherepart  = @@wherepart + " group by l.Cltcode , a.acname, branchcode , l.vno,l.vtyp,l.booktype,edt ) l "
/*           select @@selectqury = @@selectqury + @@wherepart*/
            select @@fromtables = " "
            select @@wherepart  = " "
/*             select @@selectqury = "select l.cltcode , acname=isnull(l.acname,''), branchcode, Amount = sum(case when upper(drcr) = 'D' then vamt else -vamt end)"
            select @@fromtables = " from ledger l left outer join acmast a on l.cltcode=  a.cltcode " 
            select @@wherepart  = @@wherepart3 + @@addwhere + " and l.vtyp <> 18 "
*/
         end
   end
end
end
/*  -- FOR BRANCH SELECTION --  */
/* -------------
--------------- */

if @statusid = 'Branch'
begin
/*---- If user wants to
 see NORMAL trial balance ---*/
if @balance='normal'
begin
   if @openentryflag = 0   /* Opening entry ( vtyp = 18 ) not found in Ledger */
   begin
      select @@selectqury = "select l.cltcode , acname=isnull(a.acname,''), branchcode, Amount = sum(case when upper(drcr) = 'D' then vamt else -vamt end), unrealamt = sum(case when edt > CONVERT(DATETIME,LEFT(CONVERT(VARCHAR, GETDATE(),109),11) + ' 23:59:59')  then (case when upper(drcr) = 'D' then vamt else -vamt end)else 0 end), margin = isnull(( select sum(case when upper(drcr) = 'D' then amount else -amount end) from marginledger m "
      select @@fromtables = @@wherepart + " and m.party_code = l.cltcode ),0) " + "from ledger l left outer join acmast a on l.cltcode=  a.cltcode , mcdx.dbo.client1 c1  ,mcdx.dbo.client2 c2 " 
      select @@wherepart  = @@wherepart1 + @@addwhere +  @@addwhere1
   end
   else if @openentryflag = 1  /* Opening entry ( vtyp = 18 ) found in Ledger for selected year */
   begin
      if @sortbydate = 'vdt'
         begin
            select @@selectqury = "select l.cltcode , acname=isnull(a.acname,''), branchcode, Amount = sum(case when upper(drcr) = 'D' then vamt else -vamt end), unrealamt = sum(case when edt > CONVERT(DATETIME,LEFT(CONVERT(VARCHAR, GETDATE(),109),11) + ' 23:59:59')  then ( case when upper(drcr) = 'D' then vamt else -vamt end)else 0 end), margin = isnull(( select sum(case when upper(m.drcr) = 'D' then amount else -amount end) from marginledger m "
            select @@fromtables = @@wherepart2 + " and m.party_code = l.cltcode ),0) " +" from ledger l left outer join acmast a on l.cltcode=  a.cltcode , mcdx.dbo.client1 c1  ,mcdx.dbo.client2 c2 " 
            select @@wherepart  = @@wherepart2 + @@addwhere+  @@addwhere1
         end
      else         
         begin
           select @@selectqury = "  select cltcode, acname, branchcode, amount=sum(amount), unrealamt = sum(unrealamt), "
	   select @@selectqury = @@selectqury  + " margin=sum(margin) from ( select l.cltcode , acname=isnull(a.acname,''), branchcode, "
	   select @@selectqury = @@selectqury  + " Amount = sum(Case When DrCr = 'C' then -Vamt Else Vamt End), unrealamt = sum(case when l.edt > CONVERT(DATETIME,LEFT(CONVERT(VARCHAR, GETDATE(),109),11) + ' 23:59:59')  then ( case when upper(drcr) = 'D' "
	   select @@selectqury = @@selectqury  + " then vamt else -vamt end)else 0 end), margin = isnull(( select sum(case when upper(m.drcr) = 'D' "
	   select @@selectqury = @@selectqury  + " then amount else -amount end) from marginledger m "
	   select @@fromtables = @@mwherepart2 + " and m.party_code = l.cltcode ),0) " + "from ledger l left outer join acmast a on l.cltcode=  a.cltcode , mcdx.dbo.client1 c1  ,mcdx.dbo.client2 c2   " 
      	   select @@wherepart  = @@wherepart2 + @@addwhere+ @@addwhere1
           select @@wherepart  = @@wherepart + " group by l.Cltcode , a.acname, branchcode , l.vno,l.vtyp,l.booktype,edt ) l "
/*           select @@selectqury = @@selectqury + @@wherepart*/
           select @@fromtables = " "
           select @@wherepart  = " "
         end
   end
   else if @openentryflag = 2  /* Opening entry ( vtyp = 18 ) found in Ledger for earlier year */
   begin
      if @sortbydate = 'vdt'
         begin
            select @@selectqury = "select l.cltcode , acname=isnull(a.acname,''), branchcode, Amount = sum(case when upper(drcr) = 'D' then vamt else -vamt end), unrealamt = sum(case when edt > CONVERT(DATETIME,LEFT(CONVERT(VARCHAR, GETDATE(),109),11) + ' 23:59:59')  then ( case when upper(drcr) = 'D' then vamt else -vamt end)else 0 end), margin = isnull(( select sum(case when upper(m.drcr) = 'D' then amount else -amount end) from marginledger m "
            select @@fromtables = @@wherepart3 + " and m.party_code = l.cltcode ),0) " +" from ledger l left outer join acmast a on l.cltcode=  a.cltcode, mcdx.dbo.client1 c1  ,mcdx.dbo.client2 c2  " 
            select @@wherepart  = @@wherepart3 + @@addwhere+ @@addwhere1
         end
      else
         begin
           select @@selectqury = "  select cltcode, acname, branchcode, amount=sum(amount), unrealamt = sum(unrealamt), "
	   select @@selectqury = @@selectqury  + " margin=sum(margin) from ( select l.cltcode , acname=isnull(a.acname,''), branchcode, "
	   select @@selectqury = @@selectqury  + " Amount = sum(Case When DrCr = 'C' then -Vamt Else Vamt End), unrealamt = sum(case when l.edt > CONVERT(DATETIME,LEFT(CONVERT(VARCHAR, GETDATE(),109),11) + ' 23:59:59')  then ( case when upper(drcr) = 'D' "
	   select @@selectqury = @@selectqury  + " then vamt else -vamt end)else 0 end), margin = isnull(( select sum(case when upper(m.drcr) = 'D' "
	   select @@selectqury = @@selectqury  + " then amount else -amount end) from marginledger m "
	   select @@fromtables = @@mwherepart2 + " and m.party_code = l.cltcode ),0) " + "from ledger l left outer join acmast a on l.cltcode=  a.cltcode , mcdx.dbo.client1 c1  ,mcdx.dbo.client2 c2  " 
      	   select @@wherepart  = @@wherepart2 + @@addwhere+ @@addwhere1
           select @@wherepart  = @@wherepart + " group by l.Cltcode , a.acname, branchcode , l.vno,l.vtyp,l.booktype,edt ) l "

/*           select @@selectqury = @@selectqury + @@wherepart*/
            select @@fromtables = " "
            select @@wherepart  = " "
         end
   end
end
end


if @statusid = 'SubBroker'
begin
/*---- If user wants to
 see NORMAL trial balance ---*/
if @balance='normal'
begin
   if @openentryflag = 0   /* Opening entry ( vtyp = 18 ) not found in Ledger */
   begin
      select @@selectqury = "select l.cltcode , acname=isnull(a.acname,''), branchcode, Amount = sum(case when upper(drcr) = 'D' then vamt else -vamt end), unrealamt = sum(case when edt > CONVERT(DATETIME,LEFT(CONVERT(VARCHAR, GETDATE(),109),11) + ' 23:59:59')  then (case when upper(drcr) = 'D' then vamt else -vamt end)else 0 end), margin = isnull(( select sum(case when upper(drcr) = 'D' then amount else -amount end) from marginledger m "
      select @@fromtables = @@wherepart + " and m.party_code = l.cltcode ),0) " + "from ledger l left outer join acmast a on l.cltcode=  a.cltcode , mcdx.dbo.client1 c1  ,mcdx.dbo.client2 c2 " 
      select @@wherepart  = @@wherepart1 + @@addwhere +  @@addwhere1
   end
   else if @openentryflag = 1  /* Opening entry ( vtyp = 18 ) found in Ledger for selected year */
   begin
      if @sortbydate = 'vdt'
         begin
            select @@selectqury = "select l.cltcode , acname=isnull(a.acname,''), branchcode, Amount = sum(case when upper(drcr) = 'D' then vamt else -vamt end), unrealamt = sum(case when edt > CONVERT(DATETIME,LEFT(CONVERT(VARCHAR, GETDATE(),109),11) + ' 23:59:59')  then ( case when upper(drcr) = 'D' then vamt else -vamt end)else 0 end), margin = isnull(( select sum(case when upper(m.drcr) = 'D' then amount else -amount end) from marginledger m "
            select @@fromtables = @@wherepart2 + " and m.party_code = l.cltcode ),0) " +" from ledger l left outer join acmast a on l.cltcode=  a.cltcode , mcdx.dbo.client1 c1  ,mcdx.dbo.client2 c2 " 
            select @@wherepart  = @@wherepart2 + @@addwhere+  @@addwhere1
         end
      else         
         begin
           select @@selectqury = "  select cltcode, acname, branchcode, amount=sum(amount), unrealamt = sum(unrealamt), "
	   select @@selectqury = @@selectqury  + " margin=sum(margin) from ( select l.cltcode , acname=isnull(a.acname,''), branchcode, "
	   select @@selectqury = @@selectqury  + " Amount = sum(Case When DrCr = 'C' then -Vamt Else Vamt End), unrealamt = sum(case when l.edt > CONVERT(DATETIME,LEFT(CONVERT(VARCHAR, GETDATE(),109),11) + ' 23:59:59')  then ( case when upper(drcr) = 'D' "
	   select @@selectqury = @@selectqury  + " then vamt else -vamt end)else 0 end), margin = isnull(( select sum(case when upper(m.drcr) = 'D' "
	   select @@selectqury = @@selectqury  + " then amount else -amount end) from marginledger m "
	   select @@fromtables = @@mwherepart2 + " and m.party_code = l.cltcode ),0) " + "from ledger l left outer join acmast a on l.cltcode=  a.cltcode , mcdx.dbo.client1 c1  ,mcdx.dbo.client2 c2   " 
      	   select @@wherepart  = @@wherepart2 + @@addwhere+ @@addwhere1
           select @@wherepart  = @@wherepart + " group by l.Cltcode , a.acname, branchcode , l.vno,l.vtyp,l.booktype,edt ) l "
/*           select @@selectqury = @@selectqury + @@wherepart*/
           select @@fromtables = " "
           select @@wherepart  = " "
         end
   end
   else if @openentryflag = 2  /* Opening entry ( vtyp = 18 ) found in Ledger for earlier year */
   begin
      if @sortbydate = 'vdt'
         begin
            select @@selectqury = "select l.cltcode , acname=isnull(a.acname,''), branchcode, Amount = sum(case when upper(drcr) = 'D' then vamt else -vamt end), unrealamt = sum(case when edt > CONVERT(DATETIME,LEFT(CONVERT(VARCHAR, GETDATE(),109),11) + ' 23:59:59')  then ( case when upper(drcr) = 'D' then vamt else -vamt end)else 0 end), margin = isnull(( select sum(case when upper(m.drcr) = 'D' then amount else -amount end) from marginledger m "
            select @@fromtables = @@wherepart3 + " and m.party_code = l.cltcode ),0) " +" from ledger l left outer join acmast a on l.cltcode=  a.cltcode, mcdx.dbo.client1 c1  ,mcdx.dbo.client2 c2  " 
            select @@wherepart  = @@wherepart3 + @@addwhere+ @@addwhere1
         end
      else
         begin
           select @@selectqury = "  select cltcode, acname, branchcode, amount=sum(amount), unrealamt = sum(unrealamt), "
	   select @@selectqury = @@selectqury  + " margin=sum(margin) from ( select l.cltcode , acname=isnull(a.acname,''), branchcode, "
	   select @@selectqury = @@selectqury  + " Amount = sum(Case When DrCr = 'C' then -Vamt Else Vamt End), unrealamt = sum(case when l.edt > CONVERT(DATETIME,LEFT(CONVERT(VARCHAR, GETDATE(),109),11) + ' 23:59:59')  then ( case when upper(drcr) = 'D' "
	   select @@selectqury = @@selectqury  + " then vamt else -vamt end)else 0 end), margin = isnull(( select sum(case when upper(m.drcr) = 'D' "
	   select @@selectqury = @@selectqury  + " then amount else -amount end) from marginledger m "
	   select @@fromtables = @@mwherepart2 + " and m.party_code = l.cltcode ),0) " + "from ledger l left outer join acmast a on l.cltcode=  a.cltcode , mcdx.dbo.client1 c1  ,mcdx.dbo.client2 c2  " 
      	   select @@wherepart  = @@wherepart2 + @@addwhere+ @@addwhere1
           select @@wherepart  = @@wherepart + " group by l.Cltcode , a.acname, branchcode , l.vno,l.vtyp,l.booktype,edt ) l "

/*           select @@selectqury = @@selectqury + @@wherepart*/
            select @@fromtables = " "
            select @@wherepart  = " "
         end
   end
end
end



if @statusid = 'FAMILY'
begin
/*---- If user wants to
 see NORMAL trial balance ---*/
if @balance='normal'
begin
   if @openentryflag = 0   /* Opening entry ( vtyp = 18 ) not found in Ledger */
   begin
      select @@selectqury = "select l.cltcode , acname=isnull(a.acname,''), branchcode, Amount = sum(case when upper(drcr) = 'D' then vamt else -vamt end), unrealamt = sum(case when edt > CONVERT(DATETIME,LEFT(CONVERT(VARCHAR, GETDATE(),109),11) + ' 23:59:59')  then (case when upper(drcr) = 'D' then vamt else -vamt end)else 0 end), margin = isnull(( select sum(case when upper(drcr) = 'D' then amount else -amount end) from marginledger m "
      select @@fromtables = @@wherepart + " and m.party_code = l.cltcode ),0) " + "from ledger l left outer join acmast a on l.cltcode=  a.cltcode , mcdx.dbo.client1 c1  ,mcdx.dbo.client2 c2 " 
      select @@wherepart  = @@wherepart1 + @@addwhere +  @@addwhere1
   end
   else if @openentryflag = 1  /* Opening entry ( vtyp = 18 ) found in Ledger for selected year */
   begin
      if @sortbydate = 'vdt'
         begin
            select @@selectqury = "select l.cltcode , acname=isnull(a.acname,''), branchcode, Amount = sum(case when upper(drcr) = 'D' then vamt else -vamt end), unrealamt = sum(case when edt > CONVERT(DATETIME,LEFT(CONVERT(VARCHAR, GETDATE(),109),11) + ' 23:59:59')  then ( case when upper(drcr) = 'D' then vamt else -vamt end)else 0 end), margin = isnull(( select sum(case when upper(m.drcr) = 'D' then amount else -amount end) from marginledger m "
            select @@fromtables = @@wherepart2 + " and m.party_code = l.cltcode ),0) " +" from ledger l left outer join acmast a on l.cltcode=  a.cltcode , mcdx.dbo.client1 c1  ,mcdx.dbo.client2 c2 " 
            select @@wherepart  = @@wherepart2 + @@addwhere+  @@addwhere1
         end
      else         
         begin
           select @@selectqury = "  select cltcode, acname, branchcode, amount=sum(amount), unrealamt = sum(unrealamt), "
	   select @@selectqury = @@selectqury  + " margin=sum(margin) from ( select l.cltcode , acname=isnull(a.acname,''), branchcode, "
	   select @@selectqury = @@selectqury  + " Amount = sum(Case When DrCr = 'C' then -Vamt Else Vamt End), unrealamt = sum(case when l.edt > CONVERT(DATETIME,LEFT(CONVERT(VARCHAR, GETDATE(),109),11) + ' 23:59:59')  then ( case when upper(drcr) = 'D' "
	   select @@selectqury = @@selectqury  + " then vamt else -vamt end)else 0 end), margin = isnull(( select sum(case when upper(m.drcr) = 'D' "
	   select @@selectqury = @@selectqury  + " then amount else -amount end) from marginledger m "
	   select @@fromtables = @@mwherepart2 + " and m.party_code = l.cltcode ),0) " + "from ledger l left outer join acmast a on l.cltcode=  a.cltcode , mcdx.dbo.client1 c1  ,mcdx.dbo.client2 c2   " 
      	   select @@wherepart  = @@wherepart2 + @@addwhere+ @@addwhere1
           select @@wherepart  = @@wherepart + " group by l.Cltcode , a.acname, family , l.vno,l.vtyp,l.booktype,edt ) l "
/*           select @@selectqury = @@selectqury + @@wherepart*/
           select @@fromtables = " "
           select @@wherepart  = " "
         end
   end
   else if @openentryflag = 2  /* Opening entry ( vtyp = 18 ) found in Ledger for earlier year */
   begin
      if @sortbydate = 'vdt'
         begin
            select @@selectqury = "select l.cltcode , acname=isnull(a.acname,''), branchcode, Amount = sum(case when upper(drcr) = 'D' then vamt else -vamt end), unrealamt = sum(case when edt > CONVERT(DATETIME,LEFT(CONVERT(VARCHAR, GETDATE(),109),11) + ' 23:59:59')  then ( case when upper(drcr) = 'D' then vamt else -vamt end)else 0 end), margin = isnull(( select sum(case when upper(m.drcr) = 'D' then amount else -amount end) from marginledger m "
            select @@fromtables = @@wherepart3 + " and m.party_code = l.cltcode ),0) " +" from ledger l left outer join acmast a on l.cltcode=  a.cltcode, mcdx.dbo.client1 c1  ,mcdx.dbo.client2 c2  " 
            select @@wherepart  = @@wherepart3 + @@addwhere+ @@addwhere1
         end
      else
         begin
           select @@selectqury = "  select cltcode, acname, branchcode, amount=sum(amount), unrealamt = sum(unrealamt), "
	   select @@selectqury = @@selectqury  + " margin=sum(margin) from ( select l.cltcode , acname=isnull(a.acname,''), branchcode, "
	   select @@selectqury = @@selectqury  + " Amount = sum(Case When DrCr = 'C' then -Vamt Else Vamt End), unrealamt = sum(case when l.edt > CONVERT(DATETIME,LEFT(CONVERT(VARCHAR, GETDATE(),109),11) + ' 23:59:59')  then ( case when upper(drcr) = 'D' "
	   select @@selectqury = @@selectqury  + " then vamt else -vamt end)else 0 end), margin = isnull(( select sum(case when upper(m.drcr) = 'D' "
	   select @@selectqury = @@selectqury  + " then amount else -amount end) from marginledger m "
	   select @@fromtables = @@mwherepart2 + " and m.party_code = l.cltcode ),0) " + "from ledger l left outer join acmast a on l.cltcode=  a.cltcode , mcdx.dbo.client1 c1  ,mcdx.dbo.client2 c2  " 
      	   select @@wherepart  = @@wherepart2 + @@addwhere+ @@addwhere1
           select @@wherepart  = @@wherepart + " group by l.Cltcode , a.acname, branchcode , l.vno,l.vtyp,l.booktype,edt ) l "

/*           select @@selectqury = @@selectqury + @@wherepart*/
            select @@fromtables = " "
            select @@wherepart  = " "
         end
   end
end
end




if @statusid = 'Client'
begin
/*---- If user wants to
 see NORMAL trial balance ---*/
if @balance='normal'
begin
   if @openentryflag = 0   /* Opening entry ( vtyp = 18 ) not found in Ledger */
   begin
      select @@selectqury = "select l.cltcode , acname=isnull(a.acname,''), branchcode, Amount = sum(case when upper(drcr) = 'D' then vamt else -vamt end), unrealamt = sum(case when edt > CONVERT(DATETIME,LEFT(CONVERT(VARCHAR, GETDATE(),109),11) + ' 23:59:59')  then (case when upper(drcr) = 'D' then vamt else -vamt end)else 0 end), margin = isnull(( select sum(case when upper(drcr) = 'D' then amount else -amount end) from marginledger m "
      select @@fromtables = @@wherepart + " and m.party_code = l.cltcode ),0) " + "from ledger l left outer join acmast a on l.cltcode=  a.cltcode , mcdx.dbo.client1 c1  ,mcdx.dbo.client2 c2 " 
      select @@wherepart  = @@wherepart1 + @@addwhere+ @@addwhere1
   end
   else if @openentryflag = 1  /* Opening entry ( vtyp = 18 ) found in Ledger for selected year */
   begin
      if @sortbydate = 'vdt'
         begin
            select @@selectqury = "select l.cltcode , acname=isnull(a.acname,''), branchcode, Amount = sum(case when upper(drcr) = 'D' then vamt else -vamt end), unrealamt = sum(case when edt > CONVERT(DATETIME,LEFT(CONVERT(VARCHAR, GETDATE(),109),11) + ' 23:59:59')  then ( case when upper(drcr) = 'D' then vamt else -vamt end)else 0 end), margin = isnull(( select sum(case when upper(m.drcr) = 'D' then amount else -amount end) from marginledger m "
            select @@fromtables = @@wherepart2 + " and m.party_code = l.cltcode ),0) " +" from ledger l left outer join acmast a on l.cltcode=  a.cltcode , mcdx.dbo.client1 c1  ,mcdx.dbo.client2 c2 " 
            select @@wherepart  = @@wherepart2 + @@addwhere  + @@addwhere1
         end
      else         
         begin
           select @@selectqury = "  select cltcode, acname, branchcode, amount=sum(amount), unrealamt = sum(unrealamt), "
	   select @@selectqury = @@selectqury  + " margin=sum(margin) from ( select l.cltcode , acname=isnull(a.acname,''), branchcode, "
	   select @@selectqury = @@selectqury  + " Amount = sum(Case When DrCr = 'C' then -Vamt Else Vamt End), unrealamt = sum(case when l.edt > CONVERT(DATETIME,LEFT(CONVERT(VARCHAR, GETDATE(),109),11) + ' 23:59:59')  then ( case when upper(drcr) = 'D' "
	   select @@selectqury = @@selectqury  + " then vamt else -vamt end)else 0 end), margin = isnull(( select sum(case when upper(m.drcr) = 'D' "
	   select @@selectqury = @@selectqury  + " then amount else -amount end) from marginledger m "
	   select @@fromtables = @@mwherepart2 + " and m.party_code = l.cltcode ),0) " + "from ledger l left outer join acmast a on l.cltcode=  a.cltcode , mcdx.dbo.client1 c1  ,mcdx.dbo.client2 c2   " 
      	   select @@wherepart  = @@wherepart2 + @@addwhere+ @@addwhere1
           select @@wherepart  = @@wherepart + " group by l.Cltcode , a.acname, branchcode , l.vno,l.vtyp,l.booktype,edt ) l "
/*           select @@selectqury = @@selectqury + @@wherepart*/
           select @@fromtables = " "
           select @@wherepart  = " "
         end
   end
   else if @openentryflag = 2  /* Opening entry ( vtyp = 18 ) found in Ledger for earlier year */
   begin
      if @sortbydate = 'vdt'
         begin
            select @@selectqury = "select l.cltcode , acname=isnull(a.acname,''), branchcode, Amount = sum(case when upper(drcr) = 'D' then vamt else -vamt end), unrealamt = sum(case when edt > CONVERT(DATETIME,LEFT(CONVERT(VARCHAR, GETDATE(),109),11) + ' 23:59:59')  then ( case when upper(drcr) = 'D' then vamt else -vamt end)else 0 end), margin = isnull(( select sum(case when upper(m.drcr) = 'D' then amount else -amount end) from marginledger m "
            select @@fromtables = @@wherepart3 + " and m.party_code = l.cltcode ),0) " +" from ledger l left outer join acmast a on l.cltcode=  a.cltcode, mcdx.dbo.client1 c1  ,mcdx.dbo.client2 c2  " 
            select @@wherepart  = @@wherepart3 + @@addwhere  + @@addwhere1  
         end
      else
        begin
           select @@selectqury = "  select cltcode, acname, branchcode, amount=sum(amount), unrealamt = sum(unrealamt), "
	   select @@selectqury = @@selectqury  + " margin=sum(margin) from ( select l.cltcode , acname=isnull(a.acname,''), branchcode, "
	   select @@selectqury = @@selectqury  + " Amount = sum(Case When DrCr = 'C' then -Vamt Else Vamt End), unrealamt = sum(case when l.edt >  CONVERT(DATETIME,LEFT(CONVERT(VARCHAR, GETDATE(),109),11) + ' 23:59:59')   then ( case when upper(drcr) = 'D' "
	   select @@selectqury = @@selectqury  + " then vamt else -vamt end)else 0 end), margin = isnull(( select sum(case when upper(m.drcr) = 'D' "
	   select @@selectqury = @@selectqury  + " then amount else -amount end) from marginledger m "
	   select @@fromtables = @@mwherepart2 + " and m.party_code = l.cltcode ),0) " + "from ledger l left outer join acmast a on l.cltcode=  a.cltcode , mcdx.dbo.client1 c1  ,mcdx.dbo.client2 c2  " 
      	   select @@wherepart  = @@wherepart2 + @@addwhere +  @@addwhere1 
           select @@wherepart  = @@wherepart + " group by l.Cltcode , a.acname, branchcode , l.vno,l.vtyp,l.booktype,edt ) l "

/*           select @@selectqury = @@selectqury + @@wherepart*/
            select @@fromtables = " "
            select @@wherepart  = " "
         end
   end
end
end


/*Set @@wherepart = @@wherepart + " and region LIKE (Case When '" + @StatusID + "' = 'region' Then '" + @StatusName + "' Else '%' End) AND "*/
Set @@wherepart = @@wherepart + " and branch_cd LIKE (Case When '" + @StatusID + "' = 'branch' Then '" + @StatusName + "' Else '%' End) AND "
Set @@wherepart= @@wherepart + "sub_broker LIKE (Case When '" + @StatusID + "' = 'subbroker' Then '" + @StatusName + "' Else '%' End) AND "
Set @@wherepart = @@wherepart + "trader LIKE (Case When '" + @StatusID + "' = 'trader' Then '" + @StatusName + "' Else '%' End) AND "
Set @@wherepart = @@wherepart + "family LIKE (Case When '" + @StatusID + "' = 'family' Then '" + @StatusName + "' Else '%' End) AND "
Set @@wherepart = @@wherepart + "party_code LIKE (Case When '" + @StatusID + "' = 'client' Then '" + @StatusName + "' Else '%' End) "


Print (@@selectqury + @@fromtables + @@wherepart + @@groupby + @@sortby) 

exec (@@selectqury + @@fromtables + @@wherepart + @@groupby + @@sortby)

GO
