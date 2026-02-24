-- Object: PROCEDURE dbo.sp_getclosebal
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

create procedure sp_getclosebal
@cltcode 	varchar(10),
@fromdate	varchar(11)

as

Declare
@@openbaldt 	 varchar(11),
@@openentry 	 money,
@@openingbal 	 money,
@@dramt 	 money,
@@cramt 	 money,
@@partycode	 varchar(20),
@@opendt 	  cursor,
@@openbalcursor cursor

		set @@opendt = cursor for
		select left(convert(varchar,isnull(max(vdt),0),109),11) from account.dbo.ledger l
		where vtyp = 18 and cltcode like @cltcode
		and vdt < = @fromdate  
		open @@opendt
 		fetch next from @@opendt into  @@openbaldt
	
		while @@fetch_status = 0
		begin	
	
			/*Find the amount of the opening entry for the client if present else set to 0 */
			select @@dramt = 0
			select @@cramt = 0
			select @@openentry =0

			set @@openbalcursor = cursor  for 
			select cltcode,dramt = isnull((case when drcr = 'd' then sum(vamt) else 0 end),0),
			cramt = isnull((case when drcr = 'c' then sum(vamt) else 0 end),0)
			from account.dbo.ledger where vtyp = 18 and vdt like @@openbaldt + '%'
    			and cltcode like @cltcode
			group by drcr,cltcode
    			open @@openbalcursor

 			fetch next from @@openbalcursor into @@partycode,@@dramt,@@cramt
  
			while @@fetch_status = 0
			begin
				if @@dramt <> 0  
				begin
					select @@openentry = 0 - @@dramt
				end
				if @@cramt <> 0 
				begin
					select @@openentry = @@cramt
				end			
				fetch next from @@openbalcursor into @@partycode,@@dramt,@@cramt	
			end
			
			close @@openbalcursor
			deallocate @@openbalcursor

			select @@dramt = 0
			select @@cramt = 0
			select @@openingbal = 0
			
			set @@openbalcursor = cursor for 
			select cltcode,drtotal=isnull((case drcr when 'd' then sum(vamt) end),0), 
			crtotal=isnull((case drcr when 'c' then sum(vamt) end),0) 
			from account.dbo.ledger where vdt > = @@openbaldt 
    			and vdt <= @fromdate + ' 23:59:59' and vtyp <> 18 and cltcode like @cltcode
    			group by drcr,cltcode 
			open @@openbalcursor
 			fetch next from @@openbalcursor into @@partycode,@@dramt,@@cramt
			
			while @@fetch_status = 0
			begin
				if @@dramt <> 0  
				begin
					select @@openingbal = @@openingbal - @@dramt
				end
				if @@cramt <> 0 
				begin
					select @@openingbal = @@openingbal + @@cramt
				end
			
				fetch next from @@openbalcursor into @@partycode,@@dramt,@@cramt					
			end
			
			select @@openingbal = @@openingbal + @@openentry

			close @@openbalcursor
			deallocate @@openbalcursor

			select @fromdate,@cltcode,@@openingbal as amount
			fetch next from @@opendt into  @@openbaldt
		end	

		close @@opendt
		deallocate @@opendt

GO
