-- Object: PROCEDURE dbo.AdjNextBalCursor
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.AdjNextBalCursor    Script Date: 01/04/1980 1:40:35 AM ******/


/* This procedure is used to adjust the balance amount of  all the parties according to the dates 
   After 
*/
CREATE PROCEDURE AdjNextBalCursor    
@code varchar(10),
@sdtcur datetime
 AS
declare @@tbalamt numeric(17,4)   ,
@@tdrcr varchar(1),
@@vtyp as smallint,
@@vno as numeric(12,0),
@@tvdt datetime  ,
@@tvamt numeric(17,4),
@@tcur cursor    
                 
	select @@tbalamt=0
        	set @@tcur = cursor for 
	
	/*Get balance amount of the opening entry*/	
	select  isnull(balamt,0) from ledger 
	where cltcode= @code and vdt >= @sdtcur  
	and vtyp = 18
	open @@tcur
	fetch next  from @@tcur into   @@tbalamt
	if @@fetch_status <> 0 
	begin
		select @@tbalamt=0
	end	

	close @@tcur
	deallocate @@tcur
	
	
	/*get all the accounts transactions except opening entry*/
	
	set @@tcur = cursor for 
	select drcr,vamt ,vtyp,vno, vdt  from ledger 
        	where cltcode= @code and vdt >= @sdtcur 
	and vtyp <> 18
	order by vdt,vtyp, vno
	open @@tcur
	fetch next  from @@tcur into   @@tdrcr ,@@tvamt  , @@vtyp,@@vno ,@@tvdt
	

	while   @@fetch_status =0
	begin
                		
		if  @@tdrcr='c' 
                		begin
                			select  @@tvamt  = 0  -   @@tvamt
                		end
                		Select   @@tbalamt =   @@tbalamt   +   @@tvamt 
           		
		
           		update ledger set balamt =   @@tbalamt   
	 	where  vtyp = @@vtyp and vno = @@vno and drcr = @@tdrcr  AND VDT = @@tvdt and cltcode = @code/*current of  @@tcur*/

   		fetch next  from @@tcur into   @@tdrcr ,@@tvamt  ,@@vtyp,@@vno,  @@tvdt 

	end
	
	close @@tcur
	deallocate @@tcur

GO
