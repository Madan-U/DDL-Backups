-- Object: PROCEDURE dbo.insertledger
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.insertledger    Script Date: 01/04/1980 1:40:37 AM ******/



/****** Object:  Stored Procedure dbo.insertledger    Script Date: 11/28/2001 12:23:44 PM ******/

/****** Object:  Stored Procedure dbo.insertledger    Script Date: 11/09/2001 10:32:41 AM ******/

/****** Object:  Stored Procedure dbo.insertledger    Script Date: 29-Sep-01 8:12:04 PM ******/

/****** Object:  Stored Procedure dbo.insertledger    Script Date: 08/09/2001 11:35:26 PM ******/


/****** Object:  Stored Procedure dbo.insertledger    Script Date: 7/1/01 2:19:43 PM ******/

/****** Object:  Stored Procedure dbo.insertledger    Script Date: 6/30/01 11:53:29 PM ******/

/****** Object:  Stored Procedure dbo.insertledger    Script Date: 06/28/2001 5:44:43 PM ******/





/****** Object:  Stored Procedure dbo.insertledger    Script Date: 20-Mar-01 11:43:33 PM ******/
/*Changed by sheetal on 23/04/2001 for datewise vno generation changed the vno datatype from varchar to numeric */

/* this procedure is used add a voucher entry   ,it has 14 parameters 22/03/2000 */

CREATE PROCEDURE  insertledger 
@tdrcr  varchar(1),
@tname varchar(35) ,
@tcode  varchar(10),
@tvno  varchar(12),
@booktype char(2),
@tvtyp  varchar(2),
@tedt  datetime ,
@tvdt  datetime,
@tvamt money,
@tCnarr varchar(230),
@tnarr   varchar(230),
@tchqno varchar(15),
@tchqdd varchar(1),
@tlinecnt integer,
@BankName  varchar(35),
@branchname varchar(20),
@micrno integer,
@enteredby varchar(25),
@pdt datetime,
@checkedby varchar(25)
as

declare 
@@tNodays numeric(4,0),
@@tbalamt money

 select   @@tnodays =0 
 select   @@tbalamt= @tvamt


	if @tdrcr = 'd'
	begin
	
		update vmast1 set lvno = convert(numeric,lvno) +1 ,todt =  getdate() where vtype = @tvtyp
	
  		/*if @vnoflag = 0 
		begin
 			update ledger set vno1=convert(char,convert(numeric,vno1)+1) where 
    			vdt >@tvdt  and  vtyp=@tvtyp
  		end*/

		insert into ledger1 values (@BankName ,@branchname ,@tchqdd,@tchqno,@tvdt,' '  ,abs(@tvamt) ,' ','0',@tvtyp,@tvno,@tlinecnt,@tdrcr,@booktype,@micrno)
		
		/*Insert common narration*/
		insert into ledger3  values(0,@tCnarr ,'',@tvtyp,@tvno,@booktype)
	 end
                  
	 /* 'Editing the no of days of the previous record*/
	  update ledger set nodays=abs(datediff(day,vdt , convert(datetime,@tvdt)))
	  where vdt=   (select distinct max(vdt) from ledger  where cltcode=  @tcode  and  vdt<= @tvdt )
    	and cltcode= @tcode
	
	
                   /* Calculate the balance amt of the client */
	
	select  @@tbalamt= balamt +@tvamt    from ledger   where
	vdt =  (select distinct max(vdt) from ledger  where cltcode=  @tcode  and  vdt<=@tvdt )
	and cltcode= @tcode
                  
	 /* Calculate the nodays  amt of the client */
	/*  select  @tNodays= abs(datediff(day,vdt , convert(datetime,@tvdt)))  from ledger   
	  where  vdt =  (select distinct min(vdt) from ledger  where cltcode=  @tcode  and  vdt>@tvdt )
	  and cltcode= @tcode*/
	select  @@tNodays= abs(datediff(day,(case when (select distinct min(vdt) from ledger  where cltcode=  @tcode  and  vdt > @tvdt ) is not null  
		                                then (select distinct min(vdt) from ledger  where cltcode=  @tcode  and  vdt >@tvdt )	
 			                        else getdate()
			           	   end ), convert(datetime,@tvdt )))  from ledger   
	where cltcode= @tcode
	
	  /* 'insert into ledger */
	insert into ledger values (@tvtyp,@tvno,@tedt,@tlinecnt,@tname,@tdrcr,abs(@tvamt),@tvdt , @tvno,' ',@@tbalamt , @@tNodays ,getdate() ,@tcode,@booktype,@enteredby,@pdt,@checkedby,@@tNoDays)

	  /* 'insert linewise narration into ledger3 */
	insert into ledger3  values(@tlinecnt,@tnarr ,'',@tvtyp,@tvno,@booktype)
 
	 /*'updating the balamt of the records which are successive to the record just inserted */
	 update ledger set balamt=balamt + @tvamt   where  vdt >  @tvdt   and cltcode = @tcode

GO
