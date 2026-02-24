-- Object: PROCEDURE dbo.acc_reports_HIS
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------





/****** Object:  Stored Procedure dbo.acc_reports    Script Date: 05/13/2003 6:08:54 PM ******/
/****** Object:  Stored Procedure dbo.acc_reports    Script Date: 04/13/2003 12:08:04 PM ******/
/****** Object:  Stored Procedure dbo.acc_reports    Script Date: 04/07/2003 6:22:43 PM ******/
/****** Object:  Stored Procedure dbo.acc_reports    Script Date: 02/18/2003 10:37:32 AM ******/
/****** Object:  Stored Procedure dbo.acc_reports    Script Date: Feb 03 2003 17:29:23 ******/
CREATE procedure acc_reports_HIS
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
@fld1 varchar(50),		/*  To be used for Sharedb in case of Party LEDGER_HIS */
@fld2 varchar(10),
@fld3 varchar(10)

as
declare
@@opendate   as varchar(11),         
@@selectqury as varchar(8000),
@@fromtables as varchar(2000),
@@wherepart  as varchar(8000),
@@Groupby    as varchar(200),
@@sortby     as varchar(200),
@@uall       as varchar(20),
@@Uselectqury as varchar(8000),
@@Ufromtables as varchar(2000),
@@Uwherepart  as varchar(8000),
@@UGroupby    as varchar(200),
@@Usortby     varchar(200),
@@datefilter as varchar(500),
@@ReportFrom as varchar(1)

/* -------------------------------------------------------------------------- */
if @fdate = " " 
begin
   select @fdate = @sdate
end

if @tdate = " "
begin
   select @tdate = @edate
end

/* Get filter condition on dates based on the value of @selectionby */

if @selectionby = 'vdt'
begin
   select @@datefilter = " Where l.vdt >= '" + @fdate + " 00:00:00' and l.vdt <= '" + @tdate +" 23:59:59'"
end
else if @selectionby = 'edt'
begin
   select @@datefilter = " Where l.edt >= '" + @fdate + " 00:00:00' and l.edt <= '" + @tdate +" 23:59:59'"
end
/* -------------------------------------------------------------------------- */     

if @Reportname = 'Cash Book' 
begin

   if upper(@Sortby) = 'VDT'
         select @@sortby = " order by voudt, l.vtyp, l.vno"
   else if upper(@sortby) = 'EDT'
         select @@sortby = " order by effdt, l.vtyp, l.vno"
	   else if upper(@sortby) = 'VTYPE'
	         select @@sortby = " order by l.vtyp, l.vdt, l.vno"
		else if upper(@sortby) = 'ACCODE'
		     select @@sortby = " order by l.cltcode, l.vdt, l.vtyp, l.vno"
			else if upper(@sortby) = 'ACNAME'
			     select @@sortby = " order by l.acname, l.vdt, l.vtyp, l.vno"
			   else if upper(@sortby) = 'BOOKTYPE'
	        		 select @@sortby = " order by l.booktype, l.vdt, l.vtyp, l.vno"
				   else if upper(@sortby) = 'VNO'
		        		 select @@sortby = " order by l.vno, l.vdt, l.vtyp"
					   else if upper(@sortby) = 'DRCR'
	        				 select @@sortby = " order by l.drcr, l.vdt, l.vtyp, l.vno"
						   else if upper(@sortby) = 'AMOUNT'
	        					 select @@sortby = " order by l.vamt, l.vdt, l.vtyp, l.vno"



   if rtrim(@branch) = '' or rtrim(@branch) = '%' 
      begin
         select @@selectqury = "Select l.booktype, l.vtyp, l.vno, vdt=convert(varchar,vdt,103), Edt = convert(varchar,l.edt,103), cltcode, Acname=isnull(acname,''), voudt=l.vdt, effdt=l.edt, Debit = (Case When upper(l.DRCR) = 'C' Then  Vamt  Else  0 End), Credit = (Case When upper(l.DRCR) = 'D' Then  Vamt   Else  0 End), Narration = replace(replace(l.Narration,'''',''),'""','') , l.drcr"
         select @@fromtables = " From (select distinct vtyp, vno, booktype from LEDGER_HIS where cltcode = '" + @fcode + "') t, LEDGER_HIS l "
         select @@wherepart = @@datefilter + " and l.vtyp <> 18 and l.cltcode <> '" + @fcode + "' and l.vtyp = t.vtyp and l.vno = t.vno and l.booktype = t.booktype "
         select @@groupby = " "
      end
   else
      begin

         select @@selectqury = "Select l.booktype, l.vtyp, l.vno, vdt=convert(varchar,vdt,103), Edt = convert(varchar,l.edt,103), cltcode=l2.cltcode, Acname=isnull(l.acname,''),voudt=l.vdt, effdt=l.edt, Debit = (Case When upper(l2.DRCR) = 'C' Then  camt Else  0 End), Credit = (Case When upper(l2.DRCR) = 'D' Then  camt   Else  0 End),Narration = replace(replace(l.Narration,'''',''),'""','') , l2.drcr"
	 select @@fromtables = " From (select distinct vtyp, vno, booktype from LEDGER_HIS where cltcode = '" + @fcode + "') t, LEDGER_HIS2_HIS l2, costmast c, LEDGER_HIS l "
         select @@wherepart = @@datefilter + " and l.vtyp <> 18 and l.cltcode <> '" + @fcode + "' and l.vtyp = t.vtyp and l.vno = t.vno and l.booktype = t.booktype and l2.vtype = l.vtyp and l2.vno = l.vno and l2.lno = l.lno and l2.booktype = l.booktype and costname = rtrim('" + @branch + "') and l2.costcode = c.costcode and l2.cltcode =l.cltcode "
         select @@groupby = " " 


      end
end

if @Reportname = 'Bank Book' 
begin
   if upper(@Sortby) = 'VDT'
         select @@sortby = " order by voudt, l.vtyp, l.vno"
   else if upper(@sortby) = 'EDT'
         select @@sortby = " order by effdt, l.vtyp, l.vno"
	   else if upper(@sortby) = 'VTYPE'
	         select @@sortby = " order by l.vtyp, l.vdt, l.vno"
		else if upper(@sortby) = 'ACCODE'
		     select @@sortby = " order by l.cltcode, l.vdt, l.vtyp, l.vno"
			else if upper(@sortby) = 'ACNAME'
			     select @@sortby = " order by l.acname, l.vdt, l.vtyp, l.vno"
			   else if upper(@sortby) = 'BOOKTYPE'
	        		 select @@sortby = " order by l.booktype, l.vdt, l.vtyp, l.vno"
				   else if upper(@sortby) = 'VNO'
		        		 select @@sortby = " order by l.vno, l.vdt, l.vtyp"
					   else if upper(@sortby) = 'DRCR'
	        				 select @@sortby = " order by l.drcr, l.vdt, l.vtyp, l.vno"
						   else if upper(@sortby) = 'AMOUNT'
	        					 select @@sortby = " order by l.vamt, l.vdt, l.vtyp, l.vno"

   if rtrim(@branch) = '' or rtrim(@branch) = '%' 
      begin
         select @@selectqury = "SELECT l.booktype, Vdt = convert(varchar,l.vdt,103), effdt = l.edt, Edt = convert(varchar,l.edt,103), cltcode, acname, L.VNO, l.vtyp, voudt=l.vdt, ddno= isnull((select ddno from LEDGER1_HIS l1 where l1.vno=l.vno and l1.vtyp=l.vtyp and l1.booktype=l.booktype and l1.lno = l.lno),''), Debit = (Case When upper(l.DRCR) = 'C' Then  Vamt  Else  0 End), Credit = (Case When upper(l.DRCR) ='D' Then  Vamt   Else  0 End),Narration = replace(replace(l.Narration,'''',''),'""','')  "
         select @@fromtables = " From (select distinct vtyp, vno, booktype from LEDGER_HIS where cltcode = '" + @fcode + "') t, LEDGER_HIS l "
         select @@wherepart = @@datefilter + " and l.vtyp <> 18 and l.cltcode <> '" + @fcode + "' and l.vtyp = t.vtyp and l.vno = t.vno and l.booktype = t.booktype "
         select @@groupby = " "
      end
   else
      begin
/*         select @@selectqury = "SELECT l.booktype, Vdt = convert(varchar,l.vdt,103), effdt = l.edt, Edt = convert(varchar,l.edt,103), l2.cltcode, acname, L.VNO, l.vtyp, voudt=l.vdt, ddno= isnull((select ddno from LEDGER1_HIS l1 where l1.vno=l.vno and l1.vty
p=l.vtyp and l1.booktype=l.booktype and l1.lno = l.lno),''), Debit = (Case When upper(l2.DRCR) = 'C' Then  camt  Else  0 End), Credit = (Case When upper(l2.DRCR) ='D' Then  camt   Else  0 End), l.Narration "
         select @@fromtables = " From (select distinct vtyp, vno, booktype from LEDGER_HIS where cltcode = '" + @fcode + "') t, LEDGER_HIS2_HIS l2, costmast c, LEDGER_HIS l " */
/*         select @@wherepart = @@datefilter + " and l.vtyp <> 18 and l.cltcode <> '" + @fcode + "' and l.vtyp = t.vtyp and l.vno = t.vno and l.booktype = t.booktype and l2.vtype = l.vtyp and l2.vno = l.vno and l2.lno = l.lno and l2.booktype = l.booktype 
and rtrim(costname) = rtrim('" + @branch + "') and l2.costcode = c.costcode and l2.cltcode not in ( select brcontrolac from branchaccounts ) " */
/*         select @@wherepart = @@datefilter + " and l.vtyp <> 18 and l.cltcode <> '" + @fcode + "' and l.vtyp = t.vtyp and l.vno = t.vno and l.booktype = t.booktype and l2.vtype = l.vtyp and l2.vno = l.vno and l2.lno = l.lno and l2.booktype = l.booktype 
and rtrim(costname) = rtrim('" + @branch + "') and l2.costcode = c.costcode and l2.cltcode =l.cltcode " 
         select @@groupby = " " */
         select @@selectqury = "SELECT l.booktype, Vdt = convert(varchar,l.vdt,103), effdt = l.edt, Edt = convert(varchar,l.edt,103), l2.cltcode, acname, L.VNO, l.vtyp, voudt=l.vdt, ddno= isnull((select ddno from LEDGER1_HIS l1 where l1.vno=l.vno and l1.vtyp=l.vtyp and l1.booktype=l.booktype and l1.lno = l.lno),''), Debit = (Case When upper(l2.DRCR) = 'C' Then  camt  Else  0 End), Credit = (Case When upper(l2.DRCR) ='D' Then  camt   Else  0 End), Narration = replace(replace(l.Narration,'''',''),'""','')  "
         select @@fromtables = " From (select distinct vtype, vno, booktype from LEDGER_HIS2_HIS where cltcode = '" + @fcode + "') t, LEDGER_HIS2_HIS l2, costmast c, LEDGER_HIS l " 
/*         select @@wherepart = @@datefilter + " and l.vtyp <> 18 and l.cltcode <> '" + @fcode + "' and l.vtyp = t.vtyp and l.vno = t.vno and l.booktype = t.booktype and l2.vtype = l.vtyp and l2.vno = l.vno and l2.lno = l.lno and l2.booktype = l.booktype 
and rtrim(costname) = rtrim('" + @branch + "') and l2.costcode = c.costcode and l2.cltcode not in ( select brcontrolac from branchaccounts ) " */
         select @@wherepart = @@datefilter + " and l.vtyp <> 18 and l2.cltcode <> '" + @fcode + "' and l.vtyp = t.vtype and l.vno = t.vno and l.booktype = t.booktype and l2.vtype = l.vtyp and l2.vno = l.vno and l2.lno = l.lno and l2.booktype = l.booktype and rtrim(costname) = rtrim('" + @branch + "') and l2.costcode = c.costcode " 
         select @@groupby = " " 
      end
end

if @Reportname = 'GL' 
begin

/* Assign From and To account codes. */
   if @fcode = "" 
      begin
         select @fcode = (select min(cltcode) from acmast where accat <> 4)
      end

   if @tcode = "" 
      begin
         select @tcode = (select max(cltcode) from acmast where accat <> 4)
   end

   if rtrim(@branch) = '' or rtrim(@branch) = '%' 
      begin
        select @@selectqury = "select l.booktype, voudt=l.vdt, effdt=l.edt, isnull(shortdesc,'') shortdesc, dramt=(case when upper(l.drcr) = 'D' then vamt else 0 end),  cramt=(case when upper(l.drcr) = 'C' then vamt else 0 end), l.vno, Narration = replace(replace(l.Narration,'''',''),'""','') , ddno=isnull((select ddno from LEDGER1_HIS where vtyp = l.vtyp and vno = l.vno and booktype = l.booktype and lno = l.lno),''), l.cltcode , a.longname,vdt, l.vtyp, l.booktype, vdt = convert(varchar,l.vdt,103), edt = convert(varchar,l.edt,103), accat "
        select @@fromtables = " from LEDGER_HIS l left outer join acmast a on l.cltcode = a.cltcode ,vmast v "
        select @@wherepart = @@datefilter + " and l.vtyp <> 18 and l.cltcode >= '" + @fcode + "' and l.cltcode <= '" + @tcode + "' And vtyp = vtype and a.cltcode = l.cltcode and a.accat <> '4' "
        select @@groupby = " "
        select @@sortby = " order by l.cltcode, voudt, l.vtyp desc, l.vno"  
      end
   else
      begin

        select @@selectqury = "select l.booktype, voudt=l.vdt, effdt=l.edt, isnull(shortdesc,'') shortdesc, dramt=(case when upper(l2.drcr) = 'D' then camt else 0 end),  cramt=(case when upper(l2.drcr) = 'C' then camt else 0 end), l.vno,Narration = replace(replace(l.Narration,'''',''),'""','') , ddno=isnull((select ddno from LEDGER1_HIS where vtyp = l.vtyp and vno = l.vno and booktype = l.booktype and lno = l.lno),''), l2.cltcode , a.longname,vdt, l.vtyp, l.booktype, vdt = convert(varchar,l.vdt,103), edt = convert(varchar,l.edt,103), accat "
        select @@fromtables = " from LEDGER_HIS l ,vmast v, LEDGER_HIS2_HIS l2 left outer join acmast a on l2.cltcode = a.cltcode, costmast c  "
        select @@wherepart = @@datefilter + " and l2.vtype <> 18 and l2.cltcode >= '" + @fcode + "' and l2.cltcode <= '" + @tcode + "' And l.vtyp = v.vtype and a.cltcode = l2.cltcode and a.accat <> '4' and l.vtyp = l2.vtype and l.booktype = l2.booktype and l.vno = l2.vno and l.lno = l2.lno and costname = rtrim('" + @branch + "') and l2.costcode = c.costcode "
        select @@groupby = " "

        select @@sortby = " order by l2.cltcode, voudt, l.vtyp desc, l.vno"  

      end
end

if @Reportname = 'PartyLEDGER'
begin

 select @@sortby = " voudt, l.vtyp desc, l.vno" 
 if upper(@Sortby) = 'VDT'
    select @@sortby = " voudt, l.vtyp desc, l.vno" 
   else if upper(@sortby) = 'EDT'
           select @@sortby = " effdt, l.vtyp desc, l.vno" 

 if rtrim(@branch) = '' or rtrim(@branch) = '%' 
	select @@sortby = " l.cltcode," + @@sortby
 else
	select @@sortby = " l2.cltcode," + @@sortby

 if upper(rtrim(@groupby)) = 'FAMILY'
    select @@sortby = " order by cm.family, " + @@sortby
 else if upper(rtrim(@groupby)) = 'SUBBROKER'
       select @@sortby = " order by c1.Sub_Broker, " + @@sortby

 if left(@@sortby,6) <> ' order' 
    select @@sortby = " order by " + @@sortby
      
   if upper(rtrim(@groupby)) = 'FAMILY'
   begin
      if rtrim(@branch) = '' or rtrim(@branch) = '%' 
         begin
            select @@selectqury = "select l.booktype, voudt=l.vdt, effdt=l.edt, isnull(shortdesc,'') shortdesc, dramt=(case when upper(l.drcr) = 'D' then vamt else 0 end),  cramt=(case when upper(l.drcr) = 'C' then vamt else 0 end), l.vno,ddno= isnull((select ddno from LEDGER1_HIS l1 where l1.vno=l.vno and l1.vtyp=l.vtyp and l1.booktype=l.booktype and l1.lno = l.lno),''), Narration = replace(replace(l.Narration,'''',''),'""','') , l.cltcode, a.longname, vtyp, l.booktype, convert(varchar,l.vdt,103) vdt, convert(varchar,l.edt,103) edt, l.Acname, ediff=datediff(d,l.edt,getdate()) "
            select @@fromtables = " from LEDGER_HIS l left outer join acmast a on l.cltcode = a.cltcode , vmast, msajag.dbo.clientmaster cm " 
            select @@wherepart = @@datefilter + " and l.vtyp <> 18 and l.cltcode = a.cltcode and accat = '4' and l.cltcode >= '" + @fcode + "' And L.CLTCODE <= '" + @tcode + "' and l.vtyp = vtype and l.cltcode = cm.party_code"
            select @@groupby = " "
         end
      else
         begin

            select @@selectqury = "select l.booktype, voudt=l.vdt, effdt=l.edt, isnull(shortdesc,'') shortdesc, dramt=(case when upper(l.drcr) = 'D' then vamt else 0 end),  cramt=(case when upper(l.drcr) = 'C' then vamt else 0 end), l.vno,ddno= isnull((select ddno from LEDGER1_HIS l1 where l1.vno=l.vno and l1.vtyp=l.vtyp and l1.booktype=l.booktype and l1.lno = l.lno),''),Narration = replace(replace(l.Narration,'''',''),'""','') , l.cltcode, a.longname, vtyp, l.booktype, convert(varchar,l.vdt,103) vdt, convert(varchar,l.edt,103) edt, l.Acname, ediff=datediff(d,l.edt,getdate()) "
            select @@fromtables = " from LEDGER_HIS l ,vmast v, LEDGER_HIS2_HIS l2 left outer join acmast a on l2.cltcode = a.cltcode, costmast c, msajag.dbo.clientmaster cm   "
            select @@wherepart = @@datefilter + " and l.vtyp <> 18 and l2.cltcode >= '" + @fcode + "' and l2.cltcode <= '" + @tcode + "' And l.vtyp = v.vtype and a.cltcode = l2.cltcode and a.accat = '4' and l.vtyp = l2.vtype and l.booktype = l2.booktype and l.vno = l2.vno and l.lno = l2.lno  and costname = rtrim('" + @branch + "') and l2.costcode = c.costcode and l2.cltcode = cm.party_code "
            select @@groupby = " " 

         end  
   end
   else if upper(rtrim(@groupby)) = 'SUBBROKER'
   begin
      if rtrim(@branch) = '' or rtrim(@branch) = '%' 
         begin
            select @@selectqury = "select l.booktype, voudt=l.vdt, effdt=l.edt, isnull(shortdesc,'') shortdesc, dramt=(case when upper(l.drcr) = 'D' then vamt else 0 end),  cramt=(case when upper(l.drcr) = 'C' then vamt else 0 end), l.vno,ddno= isnull((select ddno from LEDGER1_HIS l1 where l1.vno=l.vno and l1.vtyp=l.vtyp and l1.booktype=l.booktype and l1.lno = l.lno),''),Narration = replace(replace(l.Narration,'''',''),'""','') , l.cltcode, a.longname, vtyp, l.booktype, convert(varchar,l.vdt,103) vdt, convert(varchar,l.edt,103) edt, l.Acname, ediff=datediff(d,l.edt,getdate()) "
            select @@fromtables = " from LEDGER_HIS l left outer join acmast a on l.cltcode = a.cltcode , vmast, " + rtrim(@fld1) + ".dbo.client1 c1, " + rtrim(@fld1) + ".dbo.client2 c2 "
            select @@wherepart = @@datefilter + " and l.vtyp <> 18 and l.cltcode = a.cltcode and accat = '4' and l.cltcode >= '" + @fcode + "' And L.CLTCODE <= '" + @tcode + "' and l.vtyp = vtype and l.cltcode = c2.party_code and c2.cl_code = c1.cl_code "
            select @@groupby = " "
         end
      else
         begin
            select @@selectqury = "select l.booktype, voudt=l.vdt, effdt=l.edt, isnull(shortdesc,'') shortdesc, dramt=(case when upper(l.drcr) = 'D' then vamt else 0 end),  cramt=(case when upper(l.drcr) = 'C' then vamt else 0 end), l.vno,ddno= isnull((select ddno from LEDGER1_HIS l1 where l1.vno=l.vno and l1.vtyp=l.vtyp and l1.booktype=l.booktype and l1.lno = l.lno),''),Narration = replace(replace(l.Narration,'''',''),'""','') , l.cltcode, a.longname, vtyp, l.booktype, convert(varchar,l.vdt,103) vdt, convert(varchar,l.edt,103) edt, l.Acname, ediff=datediff(d,l.edt,getdate()) "
            select @@fromtables = " from LEDGER_HIS l ,vmast v, LEDGER_HIS2_HIS l2 left outer join acmast a on l2.cltcode = a.cltcode, costmast c,  " + rtrim(@fld1) + ".dbo.client1 c1, " + rtrim(@fld1) + ".dbo.client2 c2 "
            select @@wherepart = @@datefilter + " and l.vtyp <> 18 and l2.cltcode >= '" + @fcode + "' and l2.cltcode <= '" + @tcode + "' And l.vtyp = v.vtype and a.cltcode = l2.cltcode and a.accat = '4' and l.vtyp = l2.vtype and l.booktype = l2.booktype and l.vno = l2.vno and l.lno = l2.lno  and costname = rtrim('" + @branch + "') and l2.costcode = c.costcode and l2.cltcode = c2.party_code and c2.cl_code = c1.cl_code "
            select @@groupby = " "
         end  
   end
   else
   begin
   if upper(@statusid) = 'BROKER' or upper(@statusid) = 'BRANCH' 
   begin
      if rtrim(@branch) = '' or rtrim(@branch) = '%' 
         begin
         select @@selectqury = "select l.booktype, voudt=l.vdt, effdt=l.edt, isnull(shortdesc,'') shortdesc, dramt=(case when upper(l.drcr) = 'D' then vamt else 0 end),  cramt=(case when upper(l.drcr) = 'C' then vamt else 0 end), l.vno,ddno= isnull((select ddno from LEDGER1_HIS l1 where l1.vno=l.vno and l1.vtyp=l.vtyp and l1.booktype=l.booktype and l1.lno = l.lno),''),Narration = replace(replace(l.Narration,'''',''),'""','') , l.cltcode, a.longname, vtyp, l.booktype, convert(varchar,l.vdt,103) vdt, convert(varchar,l.edt,103) edt, l.Acname, ediff=datediff(d,l.edt,getdate()) "
            select @@fromtables = " from LEDGER_HIS l left outer join acmast a on l.cltcode = a.cltcode , vmast "
            select @@wherepart = @@datefilter + " and l.vtyp <> 18 and l.cltcode = a.cltcode and accat = '4' and l.cltcode >= '" + @fcode + "' And L.CLTCODE <= '" + @tcode + "' and l.vtyp = vtype "
            select @@groupby = " "
         end
      else
         begin

            select @@selectqury = "select l.booktype, voudt=l.vdt, effdt=l.edt, isnull(shortdesc,'') shortdesc, dramt=(case when upper(l.drcr) = 'D' then vamt else 0 end),  cramt=(case when upper(l.drcr) = 'C' then vamt else 0 end), l.vno,ddno= isnull((select ddno from LEDGER1_HIS l1 where l1.vno=l.vno and l1.vtyp=l.vtyp and l1.booktype=l.booktype and l1.lno = l.lno),''),Narration = replace(replace(l.Narration,'''',''),'""','') , l.cltcode, a.longname, vtyp, l.booktype, convert(varchar,l.vdt,103) vdt, convert(varchar,l.edt,103) edt, l.Acname, ediff=datediff(d,l.edt,getdate()) "
            select @@fromtables = " from LEDGER_HIS l ,vmast v, LEDGER_HIS2_HIS l2 left outer join acmast a on l2.cltcode = a.cltcode, costmast c  "
            select @@wherepart = @@datefilter + " and l.vtyp <> 18 and l2.cltcode >= '" + @fcode + "' and l2.cltcode <= '" + @tcode + "' And l.vtyp = v.vtype and a.cltcode = l2.cltcode and a.accat = '4' and l.vtyp = l2.vtype and l.booktype = l2.booktype and l.vno = l2.vno and l.lno = l2.lno  and costname = rtrim('" + @branch + "') and l2.costcode = c.costcode "
            select @@groupby = " "
            select @@sortby = " order by l2.cltcode, voudt, l.vtyp desc, l.vno"


         end
   end
   else
   if upper(@statusid) = 'SUBBROKER'
   begin
      select @@selectqury = "select l.booktype, voudt=l.vdt, effdt=l.edt, isnull(shortdesc,'') shortdesc, dramt=(case when upper(l.drcr) = 'D' then vamt else 0 end),  cramt=(case when upper(l.drcr) = 'C' then vamt else 0 end), l.vno,ddno= isnull((select ddno from LEDGER1_HIS l1 where l1.vno=l.vno and l1.vtyp=l.vtyp and l1.booktype=l.booktype and l1.lno = l.lno),''), l.Narration, l.cltcode, a.longname, vtyp, l.booktype, convert(varchar,l.vdt,103) vdt, convert(varchar,l.edt,103) edt, l.Acname, ediff=datediff(d,l.edt,getdate()) "
      select @@fromtables = " from LEDGER_HIS l left outer join acmast a on l.cltcode = a.cltcode , vmast, msajag.dbo.client1 c1, msajag.dbo.client2 c2 "
      select @@wherepart = @@datefilter + " and l.vtyp <> 18 and accat = '4' and l.cltcode >= '" + @fcode + "' And L.CLTCODE <= '" + @tcode + "' and l.cltcode = c2.party_code and c2.cl_code = c1.cl_code and upper(Sub_Broker) = upper(@statusname) and l.vtyp = vtype "
      select @@groupby = " "
   end
   else
   begin
      select @@selectqury = "select l.booktype, voudt=l.vdt, effdt=l.edt, isnull(shortdesc,'') shortdesc, dramt=(case when upper(l.drcr) = 'D' then vamt else 0 end),  cramt=(case when upper(l.drcr) = 'C' then vamt else 0 end), l.vno,ddno= isnull((select ddno from LEDGER1_HIS l1 where l1.vno=l.vno and l1.vtyp=l.vtyp and l1.booktype=l.booktype and l1.lno = l.lno),''), l.Narration, l.cltcode, a.longname, vtyp, l.booktype, convert(varchar,l.vdt,103) vdt, convert(varchar,l.edt,103) edt, l.Acname, ediff=datediff(d,l.edt,getdate()) "
      select @@fromtables = " from LEDGER_HIS l left outer join acmast a on l.cltcode = a.cltcode , vmast "
      select @@wherepart = @@datefilter + " and l.vtyp <> 18 and accat = '4' and l.cltcode >= '" + @fcode + "' And L.CLTCODE <= '" + @tcode + "' and l.vtyp = vtype "
      select @@groupby = " "
   end
   end
end

if @Reportname = 'MarginLedger'
begin
   if @selectionby = 'vdt'
      begin
         select @@sortby = " order by l.cltcode, voudt, l.vtyp desc, l.vno"
      end
   else
      begin
         select @@sortby = " order by l.cltcode, effdt, l.vtyp desc, l.vno"
      end
   if rtrim(@branch) = '' or rtrim(@branch) = '%' 
      begin
         select @@selectqury = "select m.booktype, voudt=m.vdt, effdt=l.edt, l.Acname, isnull(shortdesc,'') shortdesc, drMargin = (case when upper(m.drcr) = 'D' then amount else 0 end ), crMargin = (case when upper(m.drcr) = 'C' then amount else 0 end ), m.vno,ddno= isnull((select ddno from LEDGER1_HIS l1 where l1.vno=m.vno and l1.vtyp=m.vtyp and l1.booktype=m.booktype and l1.lno = m.lno),''), l.Narration, m.party_code, a.longname, m.vtyp, convert(varchar,l.vdt,103) vdt, convert(varchar,l.edt,103) edt "
         select @@fromtables = " from MarginLedger m left outer join LEDGER_HIS l on m.vtyp = l.vtyp and m.booktype = l.booktype and m.vno = l.vno and m.lno = l.lno left outer join acmast a on m.party_code = a.cltcode , vmast v "
         select @@wherepart = @@datefilter + " and m.party_code >= '" + @fcode + "' and m.party_code <= '" + @tcode + "' and m.vtyp <> 18 and accat = '4' and m.vtyp = v.vtype "
         select @@groupby = " "
         select @@sortby = " order by m.party_code, voudt, m.vtyp desc, m.vno"
      end
   else
      begin

         select @@selectqury = "select m.booktype, voudt=m.vdt, effdt=l.edt, l.Acname, isnull(shortdesc,'') shortdesc, drMargin = (case when upper(m.drcr) = 'D' then amount else 0 end ), crMargin = (case when upper(m.drcr) = 'C' then amount else 0 end ), m.vno, ddno= isnull((select ddno from LEDGER1_HIS l1 where l1.vno=m.vno and l1.vtyp=m.vtyp and l1.booktype=m.booktype and l1.lno = m.lno),''), l.Narration, m.party_code, a.longname, m.vtyp, convert(varchar,l.vdt,103) vdt, convert(varchar,l.edt,103) edt "
         select @@fromtables = " from LEDGER_HIS l, costmast c, MarginLedger m left outer join LEDGER_HIS2_HIS l2 on m.vtyp = l2.vtype and m.booktype = l2.booktype and m.vno = l2.vno and m.lno = l2.lno left outer join acmast a on m.party_code = a.cltcode , vmast  v "
         select @@wherepart = @@datefilter + " and m.party_code >= '" + @fcode + "' and m.party_code <= '" + @tcode + "' and m.vtyp <> 18 and accat = '4' and m.vtyp = v.vtype and m.vtyp = l.vtyp and m.booktype = l.booktype and m.vno = l.vno and m.lno = l.lno and costname = rtrim('" + @branch + "') and l2.costcode = c.costcode "
         select @@groupby = " "
         select @@sortby = " order by m.party_code, voudt, l.vtyp desc, l.vno"

          
      end
end

print  @Reportname

Print @@selectqury + @@fromtables + @@wherepart + @@groupby + @@sortby 


exec (@@selectqury + @@fromtables + @@wherepart + @@groupby + @@sortby )

GO
