-- Object: PROCEDURE dbo.SpBillTransfer
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.SpBillTransfer    Script Date: 12/26/2002 12:12:27 PM ******/
/****** Object:  Stored Procedure dbo.SpBillTransfer    Script Date: 04/11/2002 7:26:34 PM ******/
/****** Object:  Stored Procedure dbo.SpBillTransfer    Script Date: 01/04/1980 1:40:43 AM ******/
/****** Object:  Stored Procedure dbo.SpBillTransfer    Script Date: 12/12/2001 6:42:36 PM ******/
/* This procedure is used BillPosting control   */
CREATE PROCEDURE  SpBillTransfer  
@tvtyp     varchar(2),
@tvno  	   varchar(12),
@booktype  varchar(2),
@tcode     varchar(10),
@tdrcr     varchar(1),
@tlno      integer,
@tedt  	   datetime,
@tvdt  	   datetime,
@tvamt     money,
@tempno    varchar(15),
@tnarr 	   varchar(234),
@enteredby varchar(35),
@checkedby varchar(35),
@pdt	   datetime	

AS
            
declare   
@@tname    varchar(35),  
@@tbalamt  money,
@@tNodays  numeric(4,0)
   

select @@tname = acname from acmast where cltcode = @tcode
select @@tbalamt = @tvamt 
select @@tnodays=0
           
/* Update the ledger record i.e set the no of days of the previous record */
/*
update ledger set nodays=abs(datediff(day,vdt , @tvdt))
where vdt= (select distinct max(vdt) from ledger  where cltcode=  @tcode  and  vdt<= @tvdt )
and cltcode= @tcode
*/
               
/*Calculate the balance amt of the client */
/*
select @@tbalamt= balamt + @tvamt from ledger   
where  vdt = (select distinct max(vdt) from ledger  where cltcode=  @tcode  and  vdt<=@tvdt )
and cltcode= @tcode
*/
  
/*Calculate the nodays  amt of the client */
/*
select   @@tNodays= abs(datediff(day,vdt , @tvdt))  from ledger   
where  vdt = (select distinct min(vdt) from ledger  where cltcode=  @tcode  and  vdt>@tvdt )
and cltcode= @tcode
*/
                      
/*vtyp   vno edt lno acname drcr vamt vdt vno1  refno balamt NoDays cdt  cltcode  BookType EnteredBy  pdt  CheckedBy  actnodays   */ 
/* 'insert into ledger */
insert into ledger values (@tvtyp,@tvno,@tedt,@tlno,@@tname,@tdrcr,abs(@tvamt),@tvdt , '','', @@tbalamt , @@tNodays ,getdate() ,@tcode,@booktype,@enteredby,@pdt,@checkedby,@@tNodays,@tnarr)
 
/*updating the balamt of the records which are successive to the record just inserted */

update ledger set balamt=balamt + @tvamt
where  vdt >  @tvdt   and cltcode = @tcode


/* inserting record in ledger1*/               
/*bnkname  brnname   dd   ddno  dddt  reldt  relamt refno  receiptno  vtyp   vno lno  drcr BookType MicrNo      */
insert into ledger1 values ( @tempno,'','b','',@tvdt, @tvdt ,abs(@tvamt) ,'','0',@tvtyp,@tvno,@tlno,@tdrcr,@booktype,0,0,'','',0,'') 


/* inserting record in ledger3 */
/*naratno     narr    refno vtyp   vno BookType */
insert into ledger3 values (@tlno,@tnarr,'', @tvtyp,@tvno,@booktype) 
if @tlno = 1 
begin
insert into ledger3 values (0,@tnarr,'', @tvtyp,@tvno,@booktype) 
end

GO
