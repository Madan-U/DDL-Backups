-- Object: PROCEDURE dbo.insertVouchernew
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.insertVouchernew    Script Date: 01/04/1980 1:40:38 AM ******/



/****** Object:  Stored Procedure dbo.insertVouchernew    Script Date: 11/28/2001 12:23:44 PM ******/

/****** Object:  Stored Procedure dbo.insertVouchernew    Script Date: 11/09/2001 10:30:45 AM ******/

/****** Object:  Stored Procedure dbo.insertVouchernew    Script Date: 10/18/2001 2:26:46 AM ******/
/****** Object:  Stored Procedure dbo.insertVouchernew    Script Date: 20-Mar-01 11:43:33 PM ******/

/*Changed by sheetal on 23/04/2001 for datewise vno generation changed the vno datatype from varchar to numeric */
/*Changed by sheetal on 11/04/2001 from @tvamt  numeric(10,2) to money */ 
/*Changes made by sheetal on 17/01/2001 for the refno.Refno is not used anymore instead vtyp,vno,lno,drcr is used in all conditions*/
/* this procedure is used add a voucher entry   ,it has 14 parameters 22/03/2000 */
/*The fields vtyp,vno,lno,drcr are added in ledger1 table for comparison of the enteries*/
/*Similary vtyp and vno field is added in ledger3 for mapping the narration with the respective enteries in ledger */
CREATE PROCEDURE  insertVouchernew  
@opt varchar(10),
@vnoflag int,
@tdrcr  varchar(1),
@tname varchar(35),
@tcode  varchar(10),
@tvno  varchar(12),
@booktype char(2),
@tvtyp  varchar(2),
@tedt  datetime,
@tvdt  datetime,
@tvamt money,
@tCNarr   varchar(230),
@tnarr   varchar(230),
@tlinecnt integer,
@enteredby varchar(25),
@pdt datetime,
@checkedby varchar(25),
@tbnkname    varchar(35) ='',
@tbrnname    varchar (20)  ='' ,
@tdd    char   (1)  ='',
@tddno    varchar   (15)='',
@tdddt    datetime,
@treldt    datetime,
@trelamt    money,
@micrno  int

as
declare 
@@tNodays numeric(4,0),
@@tbalamt money,
@@receiptno integer,
@@reldt datetime
 
 select   @@receiptno = 0
 select   @@tnodays =0 
 select   @@tbalamt= @tvamt

	if   @opt =   '1'
	begin
		/*update vmast1 set lvno = convert(integer,lvno) +1  ,todt =  getdate()
     		where vtype = @tvtyp*/
	
  		/*if @vnoflag = 0 
		begin
     			update ledger set vno1=convert(char,convert(numeric,vno1)+1) 
 			 where vdt >@tvdt  and  vtyp=@tvtyp
  		end*/
		
		insert into ledger3  values(0,@tCnarr,'',@tvtyp,@tvno,@booktype) 
	end

	if @tvtyp = '2' or @tvtyp = '19'
	begin
		select @@receiptno = isnull(max(receiptno),0) + 1 from ledger1
		/*select @treceiptno = @@receiptno*/
			
	end

	
	 /* 'Editing the no of days of the previous record*/
   	update ledger set nodays=abs(datediff(day,vdt , convert(datetime,@tvdt)))
   	where vdt= (select distinct max(vdt) from ledger  where cltcode=  @tcode  and  vdt<= @tvdt )
     	and cltcode= @tcode
               
 	 /* Calculate the balance amt of the client */
  	select  @@tbalamt= balamt +@tvamt    from ledger   
 	where  vdt =  (select distinct max(vdt) from ledger  where cltcode=  @tcode  and  vdt<=@tvdt )
     	and cltcode= @tcode
  
	 /* Calculate the nodays   of the client  for the current entry */
   	/*select  @@tNodays= abs(datediff(day,vdt , convert(datetime, @tvdt )))  from ledger   
   	where  vdt =  (select distinct min(vdt) from ledger  where cltcode=  @tcode  and  vdt>@tvdt )
   	and cltcode= @tcode */

	select @@tNodays= abs(datediff(day,(case when (select distinct min(vdt) from ledger  where cltcode=  @tcode  and  vdt > @tvdt ) is not null  
		                                then (select distinct min(vdt) from ledger  where cltcode=  @tcode  and  vdt >@tvdt )	
 			                        else getdate()
			           	   end )	
	, convert(datetime,@tvdt )))  from ledger   
	where cltcode= @tcode
  
	 /* 'insert into ledger */
   	/*insert into ledger values (@tvtyp,@tvno,@tedt,@tlinecnt,@tname,@tdrcr,abs(@tvamt),@tvdt , @tvno1,@trefno ,@@tbalamt , @@tNodays ,getdate() ,@tcode,@@booktype)*/
   	insert into ledger values (@tvtyp,@tvno,@tedt,@tlinecnt,@tname,@tdrcr,abs(@tvamt),@tvdt , @tvno, '' ,@@tbalamt , @@tNodays ,getdate() ,@tcode,@booktype,@enteredby,@pdt,@checkedby,@@tNodays)
	
	if @tdd = 'd' or @tdd = 'D' or @tdd = 'C' or @tdd = 'c'
	begin
		Select @@reldt = ''
	end
	else
	begin
		
		select @@reldt = @tdddt
	end

	If @tbnkname <> ""  
	begin
		/*insert into ledger1 values (@tbnkname ,@tbrnname,@tdd ,@tddno,@tdddt ,'' ,abs(@trelamt) , @trefno, @treceiptno,@tvtyp,@tvno,@tlinecnt,@tdrcr,@booktype)*/
		insert into ledger1 values (@tbnkname ,@tbrnname,@tdd ,@tddno,@tdddt ,@@reldt ,abs(@trelamt) , '', @@receiptno,@tvtyp,@tvno,@tlinecnt,@tdrcr,@booktype,@micrno)
	end                  
	else IF @tddno <> ""
	begin
		/*insert into ledger1 values (@tbnkname ,@tbrnname,@tdd ,@tddno,@tdddt ,'' ,abs(@trelamt) , @trefno, @treceiptno,@tvtyp,@tvno,@tlinecnt,@tdrcr,@booktype)*/
		insert into ledger1 values (@tbnkname ,@tbrnname,@tdd ,@tddno,@tdddt ,@@reldt ,abs(@trelamt) , '', @@receiptno,@tvtyp,@tvno,@tlinecnt,@tdrcr,@booktype,@micrno)
	end
 
	insert into ledger3  values(@tlinecnt,@tnarr,'',@tvtyp,@tvno,@booktype) 

   	
	/*'updating the balamt of the records which are successive to the record just inserted */
   	update ledger set balamt=balamt + @tvamt
   	where  vdt >  @tvdt   and cltcode = @tcode

GO
