-- Object: PROCEDURE dbo.PostNseCMValan
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.PostNseCMValan    Script Date: 02/28/2003 2:55:47 PM ******/
CREATE PROCEDURE PostNseCMValan
@vtyp smallint,
@BookType char(2),
@vno varchar(12),
@vdt varchar(11),
@edtdr varchar(11),
@edtcr varchar(11),
@cdt datetime,
@pdt datetime,
@EnteredBy varchar(25), 
@CheckedBy varchar(25),
@sett_no  varchar(7),
@sett_type varchar(3),
@sessionid int

/*SlipNo,,ChequeInName,ChqPrinted*/
AS

declare
@@lno  as int,
@@vno1 as varchar(12),
@@refno char(12),
@@NoDays int,
@@actnodays int,
@@balamt money,
@@SlipNo smallint,
@@Slipdate datetime,
@@clearingmode char(2),
@@receiptno int,
@@ddno       as int,
@@vdt1 as datetime,
@@edt1 as datetime,
@@edt2 as datetime,
@@dddt1 as datetime,
@@reldt1     as datetime,
@@party_code as varchar(10), 
@@bill_no    as int, 
@@sell_buy    as char(1), 
@@sett_no    as varchar(7), 
@@sett_type  as varchar(3), 
@@amount     as money,  
@@branchcd   as varchar(10), 
@@vnarr      as varchar(234),
@@vnarr1     as varchar(234),
@@accat      as tinyint,
@@acname     as varchar(35),
@@bnkname    as varchar(20),
@@brnname    as varchar(20),
@@rcursor    as cursor

select @@vdt1 = convert(datetime,@vdt+' '+convert(varchar,getdate(),114))
select @@edt1 = convert(datetime,@edtdr+' '+convert(varchar,getdate(),114))
select @@edt2 = convert(datetime,@edtcr+' '+convert(varchar,getdate(),114))

select @@vno1 = @vno
select @@reldt1 = ''
select @@dddt1 = @vdt
select @@refno = ''
select @@nodays = 0
select @@actnodays  = 0
select @@balamt = 0
select @@slipno = 0
select @@slipdate =''
select @@ddno = 0
/*select @@clearingmode =' ' */
select @@receiptno = 0


/* --------------- Posting of Normal Valan ------------------ */
set @@rcursor = cursor for
select Party_Code, Bill_No, Sell_Buy, Sett_No, Sett_Type, Amount, BranchCd, Narration, accat, acname
from msajag.dbo.accbill b left outer join acmast a on b.party_code = a.cltcode
where sett_no = @sett_no and sett_type = @sett_type
open @@rcursor
fetch next from @@rcursor 
into @@party_code, @@bill_no, @@sell_buy, @@sett_no, @@sett_type, @@amount, @@branchcd, @@vnarr, @@accat, @@acname

select @@lno = 0
select @@vnarr1 = 'Settno=' + rtrim(@Sett_No) + 'NSECM' + rtrim(@Sett_type) + rtrim(@@vnarr)

while @@fetch_status = 0
begin

   if @@accat = 4 or @@branchcd = 'ZZZ'
   begin
      select @@bnkname = rtrim(@Sett_No) + 'NSECM' + rtrim(@Sett_type) + convert(varchar,@@bill_no,10)
      select @@brnname = ''
      select @@lno = @@lno + 1
   
      Insert into ledger(vtyp,vno,drcr,vamt,vdt,refno,cltcode,EnteredBy,lno,balamt,
                           Vno1,booktype,edt,cdt,pdt,NoDays,actnodays,CheckedBy,acname,narration) 
              values (@vtyp,@vno,(case when @@sell_buy = 1 then 'D' else 'C' end),@@amount,@@vdt1,@@refno,upper(@@party_code),@EnteredBy,@@lno,@@balamt,
                           @@Vno1,@booktype,(case when @@sell_buy = 1 then @@edt1 else @@edt2 end),@cdt,@pdt,@@NoDays,@@actnodays,@CheckedBy,@@acname,@@vnarr1)

      insert into  ledger1(lno,bnkname,brnname,dd,ddno,dddt,relamt,vtyp,vno,BookType,refno,reldt,micrno,SlipNo,Slipdate,Clear_mode,ChequeInName,ChqPrinted,receiptno,drcr)
                values (@@lno,@@bnkname,substring(@@brnname,1,20),'B',rtrim(@@ddno),@@dddt1,@@amount,@vtyp,@vno,@BookType,@@refno,@@reldt1,0,@@slipno,@@slipdate,'','',1,@@receiptno,(case when @@sell_buy = 1 then 'D' else 'C' end))

   end

   if @@accat = 4
   begin
	insert into billmatch(Exchange,Segment,Sett_type,Sett_No,BillNo,Date,Party_Code,Amount,DrCr,balamt,vtype,vno,lno,Branch,BookType)
                       values('NSE','CAPITAL',@@sett_type,@@sett_no,@@bill_no,@vdt,@@party_code,@@amount,(case when @@sell_buy = 1 then 'D' else 'C' end),@@amount,@vtyp,@vno,@@lno,@@branchcd,@booktype)
   end

   fetch next from @@rcursor 
   into @@party_code, @@bill_no, @@sell_buy, @@sett_no, @@sett_type, @@amount, @@branchcd, @@vnarr, @@accat, @@acname

end

Insert into ledger3
select lno,narration,refno,vtyp,vno,BookType 
from ledger 
where vtyp = @vtyp and booktype = @booktype and vno = @vno

Insert into ledger3
select 0,narration,refno,vtyp,vno,BookType 
from ledger 
where vtyp = @vtyp and booktype = @booktype and vno = @vno and lno = 1

insert into ledger2
select vtyp, vno, lno, (case when sell_buy = 1 then 'D' else 'C' end), amount, costcode, BookType, cltcode 
from ledger l, msajag.dbo.accbill b, costmast c
where l.vtyp = @vtyp and l.booktype = @booktype and l.vno = @vno and b.sett_no = @sett_no and b.sett_type = @sett_type
and l.cltcode = b.party_code and b.branchcd = c.costname

GO
