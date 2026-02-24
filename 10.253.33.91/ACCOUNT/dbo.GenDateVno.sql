-- Object: PROCEDURE dbo.GenDateVno
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

/****** Object:  Stored Procedure dbo.GenDateVno    Script Date: 6/20/01 9:42:43 AM ******/
CREATE PROCEDURE GenDateVno AS 
declare @@vno numeric (12,0),
	@@serialno integer,
	@@newserialno varchar(12),
	@@vtyp integer,	@@vdt varchar(11),
	@@tvdt varchar(11),
	@@tyear varchar (4),
	@@tmonth varchar (2),
	@@tday varchar (2), 
	@@tvno varchar(12),
	@@tvtyp integer,
	@@vtypcur cursor,
	@@datevno cursor


 set @@vtypcur = cursor for
 select distinct vtyp,left(convert(varchar,VDT,109),11), VNO FROM LEDGER 
 ORDER BY Vtyp,left(convert(varchar,VDT,109),11), VNO ASC
 open @@vtypcur
 fetch next  from @@vtypcur into  @@vtyp,@@vdt,@@vno
/*
 while 	@@fetch_status 	= 0 
 begin
	select @@serialno = 1		
	set @@datevno = cursor for 
	select distinct left(convert(varchar,VDT,109),11), VNO FROM aLEDGER 
	WHERE VTYP = @@VTYP order by left(convert(varchar,VDT,109),11),vno
                   open @@datevno
 	fetch next  from @@datevno into  @@vdt,@@vno
*/	
while @@fetch_status = 0
begin
	select @@tvtyp = @@Vtyp
	select @@tvdt = @@vdt
	select @@serialno = 1

	while @@fetch_status = 0 and @@Vtyp = @@TVtyp
	begin
		select @@tvdt = @@vdt
		select @@serialno = 1

		while @@fetch_status = 0 and @@tvdt = @@vdt  and @@Vtyp = @@TVtyp
		begin
			select @@tyear = year(@@vdt)
			select @@tmonth = month(@@vdt)
		
			select @@tmonth = (case when @@tmonth <10 
					then  "0"  + @@tmonth
					else @@tmonth
					end)

			select @@tday = day(@@vdt)

			select @@tday = (case when @@tday <10 
					then  "0"  + @@tday
					else @@tday	
					end)

			select @@newserialno = (case when @@serialno < 10 
					then "000" + convert(varchar,@@serialno)
			    			 else (case when @@serialno < 100 
						then "00" + convert(varchar,@@serialno)
			     	 	  		else (case when @@serialno < 1000	
					 		 then "0" + convert(varchar,@@serialno)
			     		 			else (case when @@serialno < 10000
								then convert(varchar,@@serialno)	 	
				   	     			       end)
							        end)
				   	 	     end)
			     		 end )

        			select 	@@tvno = @@tyear + @@tmonth + @@tday + @@newserialno
			

			update ledger set vno = @@tvno
			where vtyp = @@vtyp and vdt = @@vdt and vno = @@vno
			
			update ledger1 set vno = @@tvno
			where vtyp = @@vtyp and vno = @@vno
			
			update ledger3 set vno = @@tvno
			where vtyp = @@vtyp and vno = @@vno

			select @@serialno = @@serialno + 1	
			
			 fetch next  from @@vtypcur into  @@vtyp,@@vdt,@@vno
		end
	end
 end 	

close @@vtypcur
deallocate @@vtypcur

GO
