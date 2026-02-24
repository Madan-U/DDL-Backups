-- Object: PROCEDURE dbo.SelectVoucherDetails
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------



/****** Object:  Stored Procedure dbo.SelectVoucherDetails    Script Date: 18/04/2006 13:14:48 ******/


/****** Object:  Stored Procedure dbo.SelectVoucherDetails    Script Date: 12/16/2003 12:59:31 PM ******/

/****** Object:  Stored Procedure dbo.SelectVoucherDetails    Script Date: 04/07/2003 12:28:25 PM ******/
CREATE Proc SelectVoucherDetails

@Vtyp 		varchar(2),
@BookType 	varchar(2),
@FromDate 	varchar(12),
@Todate 	varchar(12),
@VnoFrom 	varchar(12),
@VnoTo 		varchar(12),
@BankCode 	varchar(12) 

as

Declare
@@selectqury 	as varchar(8000),
@@fromtables 	as varchar(2000),
@@wherepart  	as varchar(8000),
@@sortby     	as varchar(200)

 
if @VnoFrom <> '' and @VnoTo <> '' 
   begin 
 	 select @@wherepart = " where  l.Vtyp = '" + @Vtyp + "' and l.vno >= '" + @VnoFrom + "'  and l.vno <= '" + @VnoTo + "' and  l.vdt >= '" + @FromDate + " 00:00:00' and l.vdt <= '" + @ToDate +" 23:59:59' "
   end
else
   begin
	 select @@wherepart = " where  l.Vtyp = '" + @Vtyp + "' and  l.vdt >= '" + @FromDate + " 00:00:00' and l.vdt <= '" + @ToDate +" 23:59:59' "
   end							

if @Vtyp = '2'  or @Vtyp = '3' or @Vtyp = '5'  or @Vtyp = '16'  or @Vtyp = '17'  or @Vtyp =  '20'  or @Vtyp = '19' or  @Vtyp = '1' or  @Vtyp = '4' or  @Vtyp = '22' or  @Vtyp = '23'  
   begin
	select @@fromtables = " from Ledger l left outer join  ledger1 l1  on l.vtyp = l1.vtyp and l.booktype = l1.booktype and l.vno = l1.vno and l.lno = l1.lno, ( select distinct vtyp, booktype, vno from ledger where  cltcode = '" + @BankCode + "' 	and vtyp = '" + @vtyp + "' and vdt >= '" + @Fromdate + " 00:00:00' and vdt <= '" + @Todate + " 23:59:59' ) t "
	select @@wherepart = @@wherepart + " and l.vtyp = t.vtyp and l.booktype = t.booktype and l.vno = t.vno and  cltcode <> '" + @BankCode + "'" 
	select @@wherepart = @@wherepart + "  and l.booktype = '" + @Booktype + "'"
   end
else
   begin
	select @@wherepart = @@wherepart + "  and l.booktype = '" + @Booktype + "'"
	select @@fromtables = " from Ledger l left outer join  ledger1 l1  on l.vtyp = l1.vtyp and l.booktype = l1.booktype and l.vno = l1.vno and l.lno = l1.lno "
   end 

select @@wherepart = @@wherepart 

select @@selectqury = " select distinct l.vno,isnull(dd,'') dd  ,isnull(ddno,'') ddno,Vamt = isnull(l.vamt,0), l.drcr,cltcode = isnull((case when l.vtyp = 19 or l.vtyp = 20 then (select party_code from marginledger m where vtyp = l.vtyp and m.vno = l.vno and lno = l.lno and booktype = l.booktype ) else l.cltcode end) ,0), acname = isnull((case when l.vtyp = 19 or l.vtyp = 20 then (select acname from marginledger m where vtyp = l.vtyp and m.vno = l.vno and lno = l.lno and booktype = l.booktype and party_code = cltcode) else l.acname end ),0), ChequeInName = isnull(chequeinname,''), l.narration ,PrintedFlag = isnull(Chqprinted,0) , micrno ,l.booktype"

select @@sortby = " order by l.vno "
				
print  (@@selectqury + @@fromtables + @@wherepart + @@sortby ) 
exec (@@selectqury + @@fromtables + @@wherepart + @@sortby )

GO
