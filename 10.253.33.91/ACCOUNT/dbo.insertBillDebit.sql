-- Object: PROCEDURE dbo.insertBillDebit
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.insertBillDebit    Script Date: 20-Mar-01 11:43:33 PM ******/

/* this procedure is used add a voucher entry   ,it has 15 parameters 22/03/2000 */
CREATE PROCEDURE  insertBillDebit  @tdrcr  varchar(1)
,@tname varchar(35) 
,@tcode  varchar(10)
,@tvno  varchar(5) 
,@tvno1  varchar(5)
,@tvtyp  varchar(2)
,@tedt  datetime 
,@tvdt  datetime
,@tvamt  money
,@trefno   varchar(12)
,@tnarr   varchar(50)
,@tlinecnt integer
, @settdtls  varchar(35)
, @saudadate datetime
as
declare 
@@tbalamt money
,@@tnodays integer
  if @tdrcr = 'c'
  begin
   update vmast1 set lvno = convert(integer,lvno) +1 ,todt =  getdate()
    where vtype = @tvtyp
  
   update ledger set vno1=convert(char,convert(integer,vno1)+1) where 
    vdt >@tvdt  and  vtyp=@tvtyp
  
   if  not( @tnarr =' ')
                    begin 
                    insert into ledger3  select isnull(max(naratno),0)+1 ,@tnarr ,  substring(@trefno,1,7),@tvtyp,@tvno  from ledger3 
                    end
 
                  /* isert into ledger */
 end
  insert into ledger1 values (@settdtls ,' ' , 'd'  , '' ,    @saudadate  ,' '  ,abs(@tvamt) , @trefno  ,'0' ,@tvtyp,@tvno,@tlinecnt,@tdrcr)                  
 /* 'Editing the no of days of the previous record*/
  update ledger set nodays=abs(datediff(day,vdt , convert(datetime,@tvdt)))
  where vdt=
   (select distinct max(vdt) from ledger  where cltcode=  @tcode  and  vdt<= @tvdt )
    and cltcode= @tcode
   select   @@tbalamt = @tvamt
                   /* Calculate the balance amt of the client */
   select  @@tbalamt= balamt +@tvamt    from ledger   where
   vdt =  (select distinct max(vdt) from ledger  where cltcode=  @tcode  and  vdt<=@tvdt )
   and cltcode= @tcode
  select   @@tnodays=0
  /* Calculate the nodays  amt of the client */
  select    @@tNodays= abs(datediff(day,vdt , convert(datetime,@tvdt)))  from ledger   
  where  vdt =  (select distinct min(vdt) from ledger  where cltcode=  @tcode  and  vdt>@tvdt )
  and cltcode= @tcode
  /* 'insert into ledger */
  insert into ledger values (@tvtyp,@tvno,@tedt,@tlinecnt,@tname,@tdrcr,abs(@tvamt),@tvdt , 
                                 @tvno1,@trefno , @@tbalamt , @@tNodays ,getdate() ,@tcode)
 
  /*'updating the balamt of the records which are successive to the record just inserted */
  update ledger set balamt=balamt + @tvamt
  where  vdt >  @tvdt   and cltcode = @tcode

GO
