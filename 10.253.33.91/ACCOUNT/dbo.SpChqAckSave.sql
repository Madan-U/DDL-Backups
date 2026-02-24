-- Object: PROCEDURE dbo.SpChqAckSave
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.SpChqAckSave    Script Date: 08/19/2001 1:01:03 AM ******/

/****** Object:  Stored Procedure dbo.SpChqAckSave    Script Date: 08/13/2001 6:17:06 AM ******/


/****** Object:  Stored Procedure dbo.SpChqAckSave    Script Date: 7/1/01 2:19:47 PM ******/

/****** Object:  Stored Procedure dbo.SpChqAckSave    Script Date: 6/30/01 11:53:30 PM ******/

/****** Object:  Stored Procedure dbo.SpChqAckSave    Script Date: 06/28/2001 5:44:54 PM ******/
/*@tvno  varchar(5),*/ /*Changed by sheetal on 23/04/2001 for datewise vno generation */
/* this procedure is used add a voucher entry   ,it has 15 parameters  called in chqackprint*/
CREATE PROCEDURE    SpChqAckSave      
@vnoflag int,
@tdrcr  varchar(1),
@tvno  numeric(14,0),
@tname varchar(35) ,
@tcode  varchar(10),
@tvno1  numeric(12,0),
@tvtyp  smallint,
@tedt  datetime ,
@tvdt  datetime,
@tvamt  numeric(10,2),
@tbalamt  numeric(10,2),
@trefno   varchar(12),
@tnarr   varchar(230),
@tchqno varchar(15),
@tchqdd varchar(1),
@tlinecnt integer,
@BnkName  varchar(35),
@BrnName  varchar(15),
@trctno int,
@tbnkdt datetime
AS
declare
@@tNodays numeric(4,0)

select   @@tnodays=0
select   @tbalamt= @tvamt

if @tdrcr = 'c'
begin
	update vmast1 set lvno = convert(integer,lvno) +1 ,todt =  getdate()
	where vtype = @tvtyp
  	
	if @vnoflag = 0
	begin
		update ledger set vno1=vno1+1 where  vdt >@tvdt  and  vtyp=@tvtyp
	end
  
	/*if  not( @tnarr =' ')
                  begin*/ 
		/*insert into ledger3  select isnull(max(naratno),0)+1 ,@tnarr ,  substring(@trefno,1,7)   from ledger3 */
		/*insert into ledger3  select isnull(max(naratno),0)+1 ,@tnarr , ' ' ,@tvtyp,@tvno   from ledger3 */
	/*end*/
 
                  /* insert into ledger 1*/
                
  	/* insert into ledger1 values (@BnkName ,@brnname , @tchqdd  ,  @tchqno ,    @tbnkdt  ,' '  ,abs(@tvamt) , @trefno  ,@trctno)*/
  	insert into ledger1 values (@BnkName ,@brnname , @tchqdd  ,  @tchqno ,    @tbnkdt  ,' '  ,abs(@tvamt) , ' '  ,@trctno,@tvtyp,@tvno,@tlinecnt,@tdrcr)
 end
               
                  
 	 /* 'Editing the no of days of the previous record*/
   	update ledger set nodays=abs(datediff(day,vdt , convert(datetime,@tvdt)))
  	 where vdt=     (select distinct max(vdt) from ledger  where cltcode=  @tcode  and  vdt<= @tvdt )
     	and cltcode= @tcode
               
 	 /* Calculate the balance amt of the client */
    	select  @tbalamt= balamt +@tvamt    from ledger   
	 where vdt =  (select distinct max(vdt) from ledger  where cltcode=  @tcode  and  vdt<=@tvdt )
     	and cltcode= @tcode
   	
	/* Calculate the nodays  amt of the client */
   	select  @@tNodays= abs(datediff(day,vdt , convert(datetime,@tvdt)))  from ledger   
  	 where  vdt =  (select distinct min(vdt) from ledger  where cltcode=  @tcode  and  vdt>@tvdt )
   	and cltcode= @tcode
   	
	/* 'insert into ledger */
   	insert into ledger values (@tvtyp,@tvno,@tedt,@tlinecnt,@tname,@tdrcr,abs(@tvamt),@tvdt , @tvno1,' ' ,@tbalamt , @@tNodays ,getdate() ,@tcode)
 
	insert into ledger3  values (@tlinecnt ,@tnarr , ' ' ,@tvtyp,@tvno)
   
	/*'updating the balamt of the records which are successive to the record just inserted */
   	update ledger set balamt=balamt + @tvamt
	 where  vdt >  @tvdt   and cltcode = @tcode

GO
