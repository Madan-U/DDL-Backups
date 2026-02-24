-- Object: PROCEDURE dbo.EditVoucher
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

/****** Object:  Stored Procedure dbo.EditVoucher    Script Date: 06/22/2001 3:37:54 PM ******/
/****** Object:  Stored Procedure dbo.EditVoucher    Script Date: 20-Mar-01 11:43:33 PM ******/
/* this procedure is used add a voucher entry   ,it has 14 parameters 22/03/2000 */
CREATE PROCEDURE EditVoucher  
@opt varchar(10),
@tdrcr  varchar(1),
@tname varchar(35),
@tcode  varchar(10),
/*@tvno  varchar(5),*/ /*Changed by sheetal on 23/04/2001 for datewise vno generation */
@tvno  numeric(12,0),
@tvno1  varchar(5),
@tvtyp  varchar(2),
@tedt  datetime,
@tvdt  datetime,
@tvamt  numeric(10,2),
@trefno   varchar(12),
@tnarr   varchar(230),
@tlinecnt integer,
@tbnkname    varchar(35) ='',
@tbrnname    varchar (20)  ='' ,
@tdd    char   (1)  ='',
@tddno    varchar   (15)='',
@tdddt    datetime,
@treldt    datetime,
@trelamt    money,
@treceiptno    int
as
 declare 
 @@tNodays numeric(4,0)    ,    @@tbalamt money
 select    @@tnodays =0 
 select   @@tbalamt= @tvamt
/*   if   @opt =   'first'
  begin
   update vmast1 set lvno = convert(integer,lvno) +1 ,todt =  getdate()
    where vtype = @tvtyp
  
   update ledger set vno1=convert(char,convert(integer,vno1)+1) where 
    vdt >@tvdt  and  vtyp=@tvtyp
select  isnull(max(naratno),0)+1 ,@tnarr ,  substring(@trefno,1,7)   from ledger3   
 
 end */
    if   @tnarr <> ''
                begin 
                /* update  ledger3   set   narr= @tnarr  where refno =  substring(@trefno,1,7)*/
 update  ledger3   set   narr= @tnarr  where vtyp = @tvtyp and vno = @tvno
                end
                  
  /* 'Editing the no of days of the previous record*/
   update ledger set nodays=abs(datediff(day,vdt , convert(datetime,@tvdt)))
   where vdt= (select distinct max(vdt) from ledger  where cltcode=  @tcode  and  vdt<= @tvdt )
     and cltcode= @tcode
   /* Calculate the balance amt of the client */
    select  @@tbalamt= balamt +@tvamt    from ledger   
 where vdt =  (select distinct max(vdt) from ledger  where cltcode=  @tcode  and  vdt<=@tvdt )
     and cltcode= @tcode
   /* Calculate the nodays  amt of the client */
   select  @@tNodays= abs(datediff(day,vdt , convert(datetime,@tvdt)))  from ledger   
   where  vdt =  (select distinct min(vdt) from ledger  where cltcode=  @tcode  and  vdt>@tvdt )
   and cltcode= @tcode
 /* 'insert into ledger1 */   
 if   @tddno <> "" 
  begin
    /*insert into ledger1 values (@tbnkname ,@tbrnname,@tdd ,@tddno,@tdddt ,@treldt ,abs(@trelamt) , @trefno,@treceiptno)*/
    insert into ledger1 values (@tbnkname ,@tbrnname,@tdd ,@tddno,@tdddt ,'' ,abs(@trelamt) , @trefno, @treceiptno,@tvtyp,@tvno,@tlinecnt,@tdrcr)
  end
 /* 'insert into ledger */
   insert into ledger values (@tvtyp,@tvno,@tedt,@tlinecnt,@tname,@tdrcr,abs(@tvamt),@tvdt ,@tvno1,@trefno ,@@tbalamt , @@tNodays ,getdate() ,@tcode)
 
   /*'updating the balamt of the records which are successive to the record just inserted */
   update ledger set balamt=balamt + @tvamt
   where  vdt >  @tvdt   and cltcode = @tcode

GO
