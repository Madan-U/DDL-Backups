-- Object: PROCEDURE dbo.SpBillTransfer
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.SpBillTransfer    Script Date: 3/17/01 9:56:11 PM ******/

/****** Object:  Stored Procedure dbo.SpBillTransfer    Script Date: 3/21/01 12:50:31 PM ******/

/****** Object:  Stored Procedure dbo.SpBillTransfer    Script Date: 20-Mar-01 11:39:10 PM ******/

/****** Object:  Stored Procedure dbo.SpBillTransfer    Script Date: 2/5/01 12:06:28 PM ******/

/****** Object:  Stored Procedure dbo.SpBillTransfer    Script Date: 12/27/00 8:59:04 PM ******/

/* this procedure is used add a voucher entry   ,it has 15 parameters */
CREATE PROCEDURE  SpBillTransfer  @tdrcr  varchar(1)
,@tcode  varchar(15)
,@tvno  varchar(5) 
,@tvno1  varchar(5)
,@tvtyp  varchar(2)
,@tedt  datetime 
,@tvdt  datetime
,@tvamt  money
,@trefno   varchar(12)
,@tempno varchar(15)
,@tlinecnt   integer
 AS
            
declare   @@tname varchar(35) ,  @@tbalamt  numeric(19,2)   ,@@tNodays numeric(4,0)
          /*  'get the A/c name for the selected client*/
            select   @@tname=acname from acmast where cltcode = @tcode
            
          /* 'update the ledger record i.e set the noof days of the previous record*/
              /* 'Editing the no of days of the previous record*/
  update ledger set nodays=abs(datediff(day,vdt , @tvdt))
  where vdt=
   (select distinct max(vdt) from ledger  where cltcode=  @tcode  and  vdt<= @tvdt )
    and cltcode= @tcode
                   /* Calculate the balance amt of the client */
   select    @@tbalamt= balamt +@tvamt    from ledger   where
   vdt =  (select distinct max(vdt) from ledger  where cltcode=  @tcode  and  vdt<=@tvdt )
    and cltcode= @tcode
  /* Calculate the nodays  amt of the client */
  select   @@tNodays= abs(datediff(day,vdt , @tvdt))  from ledger   
  where  vdt =  (select distinct min(vdt) from ledger  where cltcode=  @tcode  and  vdt>@tvdt )
  and cltcode= @tcode
                       
  /* 'insert into ledger */
  insert into ledger values (@tvtyp,@tvno,@tedt,@tlinecnt,@@tname,@tdrcr,abs(@tvamt),@tvdt , 
                                                                  @tvno1,@trefno ,  @@tbalamt , @@tNodays ,getdate() ,@tcode)
 /*'updating the balamt of the records which are successive to the record just inserted */
 /*     'update the remaining vouchers*/
                
  update ledger set balamt=balamt + @tvamt
  where  vdt >  @tvdt   and cltcode = @tcode
              /*  'insert into ledger1 */
      insert into ledger1 values (  @tempno,' ' ,'b','' ,     @tvdt ,  @tvdt ,abs(@tvamt) , @trefno  ,'0')

GO
