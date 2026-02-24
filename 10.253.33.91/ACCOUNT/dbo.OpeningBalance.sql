-- Object: PROCEDURE dbo.OpeningBalance
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


/****** Object:  Stored Procedure dbo.OpeningBalance    Script Date: 01/04/1980 1:40:38 AM ******/



/****** Object:  Stored Procedure dbo.OpeningBalance    Script Date: 11/28/2001 12:23:45 PM ******/

/****** Object:  Stored Procedure dbo.OpeningBalance    Script Date: 29-Sep-01 8:12:05 PM ******/

/****** Object:  Stored Procedure dbo.OpeningBalance    Script Date: 09/21/2001 2:39:21 AM ******/

/****** Object:  Stored Procedure dbo.OpeningBalance    Script Date: 08/29/2001 6:51:54 AM ******/
CREATE Procedure OpeningBalance
@cltcode varchar(10),
@sdtcur varchar(11),
@fromdate varchar(11),
@vdtedtflag tinyint

AS

Declare
	@@openbaldt varchar(11),
	@@openentry money,
	@@openingbal money,
	@@dramt money,
	@@cramt money,

	@@opendt cursor,
	@@openbalcursor cursor

If @vdtedtflag = 0
begin
	set @@opendt = cursor for
	select left(convert(varchar,isnull(max(vdt),0),109),11) from ledger
	where vtyp = 18 and cltcode = @cltcode
	and vdt < = @sdtcur  
	open @@opendt
 	fetch next from @@opendt into  @@openbaldt

	while @@fetch_status = 0
	begin
		
		/*Find the amount of the opening entry for the client if present else set to 0 */

		select @@dramt = 0
		select @@cramt = 0
		select @@openentry =0

		set @@openbalcursor = cursor  for 
		select 	dramt = isnull((case when drcr = 'd' then sum(vamt) else 0 end),0),
		cramt = isnull((case when drcr = 'c' then sum(vamt) else 0 end),0)
		from ledger where vtyp = 18 and vdt like @@openbaldt + '%'
    		and cltcode = @cltcode group by drcr
    		open @@openbalcursor
 		fetch next from @@openbalcursor into @@dramt,@@cramt
  
		while @@fetch_status = 0
		begin
			
			if @@dramt <> 0  
			begin
				select @@openentry = @@dramt
			end
			if @@cramt <> 0 
			begin
				select @@openentry = 0 - @@cramt
			end
			
			
			fetch next from @@openbalcursor into @@dramt,@@cramt	
		end
		
		close @@openbalcursor
		deallocate @@openbalcursor

		

		select @@dramt = 0
		select @@cramt = 0	
		select @@openingbal = 0

		set @@openbalcursor = cursor for 
		select drtotal=isnull((case drcr when 'd' then sum(vamt) end),0), 
		crtotal=isnull((case drcr when 'c' then sum(vamt) end),0) 
		from ledger where vdt > = @@openbaldt 
    		and vdt < @fromdate  and vtyp <> 18 and cltcode = @cltcode
    		group by drcr 
		open @@openbalcursor
 		fetch next from @@openbalcursor into @@dramt,@@cramt

  		while @@fetch_status = 0
		begin
			if @@dramt <> 0  
			begin
				select @@openingbal = @@openingbal + @@dramt
			end
			if @@cramt <> 0 
			begin
				select @@openingbal = @@openingbal - @@cramt
			end
			
			fetch next from @@openbalcursor into @@dramt,@@cramt					
		end

		select @@openingbal = @@openingbal + @@openentry

		close @@openbalcursor
		deallocate @@openbalcursor

		/*select @@openbaldt
		select @@openentry*/
		select @@openingbal
		fetch next from @@opendt into  @@openbaldt
	end	

	close @@opendt
	deallocate @@opendt
end
else if @vdtedtflag = 1
begin
	set @@opendt = cursor for
	select left(convert(varchar,isnull(max(vdt),0),109),11) from ledger
	where vtyp = 18 and cltcode = @cltcode and edt < = @sdtcur  
	open @@opendt
 	fetch next from @@opendt into  @@openbaldt
	
	while @@fetch_status = 0
	begin
		
		/*Find the amount of the opening entry for the client if present else set to 0 */

		select @@dramt = 0
		select @@cramt = 0
		select @@openentry =0
		
		set @@openbalcursor = cursor  for 
		select 	dramt = isnull((case when drcr = 'd' then sum(vamt) else 0 end),0),
		cramt = isnull((case when drcr = 'c' then sum(vamt) else 0 end),0)
		from ledger where vtyp = 18 and edt like @@openbaldt + '%'
    		and cltcode = @cltcode group by drcr
    		open @@openbalcursor
 		fetch next from @@openbalcursor into @@dramt,@@cramt
  
		
		while @@fetch_status = 0
		begin
			if @@dramt <> 0  
			begin
				select @@openentry = @@dramt
			end
			if @@cramt <> 0 
			begin
				select @@openentry = 0 - @@cramt
			end
			
			
			fetch next from @@openbalcursor into @@dramt,@@cramt	
		end
		
		close @@openbalcursor
		deallocate @@openbalcursor

		

		select @@dramt = 0
		select @@cramt = 0
		select @@openingbal = 0

		set @@openbalcursor = cursor for 
		select drtotal=isnull((case drcr when 'd' then sum(vamt) end),0), 
		crtotal=isnull((case drcr when 'c' then sum(vamt) end),0) 
		from ledger where edt > = @@openbaldt  and edt < @fromdate  
		and vtyp <> 18 and cltcode = @cltcode group by drcr 
		open @@openbalcursor
 		fetch next from @@openbalcursor into @@dramt,@@cramt
  		while @@fetch_status = 0
		begin
			if @@dramt <> 0  
			begin
				select @@openingbal = @@openingbal + @@dramt
			end
			if @@cramt <> 0 
			begin
				select @@openingbal = @@openingbal - @@cramt
			end
			
			fetch next from @@openbalcursor into @@dramt,@@cramt					
		end

		select @@openingbal = @@openingbal + @@openentry
		
		close @@openbalcursor
		deallocate @@openbalcursor

		/*select @@openbaldt
		select @@openentry*/
		select @@openingbal
		fetch next from @@opendt into  @@openbaldt
	end	

	close @@opendt
	deallocate @@opendt
end

GO
