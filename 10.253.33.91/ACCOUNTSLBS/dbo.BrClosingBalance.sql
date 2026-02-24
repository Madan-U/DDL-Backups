-- Object: PROCEDURE dbo.BrClosingBalance
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------


/****** Object:  Stored Procedure dbo.BrClosingBalance    Script Date: 05/10/2004 5:10:46 PM ******/  
  
/****** Object:  Stored Procedure dbo.BrClosingBalance    Script Date: 12/03/2002 4:11:29 PM ******/  
  
/****** Object:  Stored Procedure dbo.BrClosingBalance    Script Date: 06/05/2002 12:03:46 PM ******/  
/****** Object:  Stored Procedure dbo.BrClosingBalance    Script Date: 05/04/2002 12:57:05 PM ******/  
  
/****** Object:  Stored Procedure dbo.BrClosingBalance    Script Date: 05/02/2002 2:28:13 PM ******/  
/****** Object:  Stored Procedure dbo.BrClosingBalance    Script Date: 01/28/2002 3:46:43 PM ******/  
  
/****** Object:  Stored Procedure dbo.BrClosingBalance    Script Date: 01/24/2002 12:11:47 PM ******/  
/**************************************************************************************************************************************************************************************************  
THIS SP  IS USED TO FIND THE CLOSING BALANCE OF A PARTICULAR A/C CODE   
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  
Copy of BrOpeningbalance with change in condition.  
  
Added two new parameters viz: @flag and @costcode.   
These are used to display the bank transactions either for all the branches or for a particular branch   
Depending on the @flag value   
If @flag = 0  then show bank transaction for all the branches  
If @flag = 1 then show bank transaction for a selected branch (i.e for the passed costcode )  
  
***************************************************************************************************************************************************************************************************/  
  
CREATE  Procedure BrClosingBalance  
@cltcode  varchar(10),  
@sdtcur  varchar(11),  
@fromdate varchar(11),  
@vdtedtflag tinyint,  
@flag   smallint,  
@costcode  smallint  
  
AS  
  
Declare  
@@openbaldt   varchar(11),  
@@openentry   money,  
@@openingbal   money,  
@@dramt   money,  
@@cramt   money,  
  
@@opendt    cursor,  
@@openbalcursor cursor  
  
  
  
If @vdtedtflag = 0  
begin  
 /*If the login is not branch and the user has selected the option 'ALL' as branches, so the user can view the transactions for all branches */  
  
 if @flag = 0   
 begin  
  set @@opendt = cursor for  
  select left(convert(varchar,isnull(max(vdt),0),109),11) from ledger l  
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
   select dramt = isnull((case when drcr = 'd' then sum(vamt) else 0 end),0),  
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
       and vdt < @fromdate+' 23:59:59'  and vtyp <> 18 and cltcode = @cltcode  
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
                                        Select @@Openingbal   
   close @@openbalcursor  
   deallocate @@openbalcursor  
  
   fetch next from @@opendt into  @@openbaldt  
  end   
  
  close @@opendt  
  deallocate @@opendt  
 end  
 /*IF THE LOGIN = BRANCH THE ONLY THE ENTRIES FOR THAT BRANCH ARE RETRIEVED*/  
 else if @flag = 1    
 begin   
  set @@opendt = cursor for  
  select left(convert(varchar,isnull(max(vdt),0),109),11) from ledger l , ledger2 l2   
  where l.vtyp = l2.vtype and l.vno = l2.vno and l.lno = l2.lno  and vtyp = 18  
   and l.cltcode = @cltcode and vdt < = @sdtcur   and costcode = @costcode  
  open @@opendt  
   fetch next from @@opendt into  @@openbaldt  
   
  while @@fetch_status = 0  
  begin  
   /*Find the amount of the opening entry for the client if present else set to 0 */  
   select @@dramt = 0  
   select @@cramt = 0  
   select @@openentry =0  
  
   set @@openbalcursor = cursor  for   
   select dramt = isnull((case when l.drcr = 'd' then sum(vamt) else 0 end),0),  
   cramt = isnull((case when l.drcr = 'c' then sum(vamt) else 0 end),0)  
   from ledger  l , ledger2 l2  
   where l.vtyp = l2.vtype and l.vno = l2.vno and l.lno = l2.lno  and vtyp = 18   
   and vdt like @@openbaldt + '%'  and l.cltcode = @cltcode  and costcode = @costcode  
   group by l.drcr  
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
   select drtotal=isnull((case l.drcr when 'd' then sum(vamt) end),0),   
   crtotal=isnull((case l.drcr when 'c' then sum(vamt) end),0)   
   from ledger l,ledger2 l2  
   where l.vtyp = l2.vtype and l.vno = l2.vno and l.lno = l2.lno and vtyp <> 18   
   and vdt > = @@openbaldt   and vdt < @fromdate+' 23:59:59'  and l.cltcode = @cltcode and costcode = @costcode  
       group by l.drcr   
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
  
   select @@openingbal  
   fetch next from @@opendt into  @@openbaldt  
  end   
  
  close @@opendt  
  deallocate @@opendt  
 end  
  
end  
else if @vdtedtflag = 1  
begin  
 /*If the login is not branch and the user has selected the option 'ALL' as branches, so the user can view the transactions for all branches */  
  
 if @flag = 0   
 begin  
  set @@opendt = cursor for  
  select left(convert(varchar,isnull(min(vdt),0),109),11) from ledger  
  where cltcode = @cltcode and edt <= @sdtcur    
  open @@opendt  
   fetch next from @@opendt into  @@openbaldt  
    
  while @@fetch_status = 0  
  begin   
  
   /*Find the amount of the opening entry for the client if present else set to 0 */  
   select @@dramt = 0  
   select @@cramt = 0  
   select @@openentry =0  
     
   set @@openbalcursor = cursor  for   
   select  dramt = isnull((case when drcr = 'd' then sum(vamt) else 0 end),0),  
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
   from ledger where vtyp <> '18' and edt < @fromdate +' 23:59:59'  
   and cltcode = @cltcode group by drcr   
  
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
  
   select @@openingbal  
   fetch next from @@opendt into  @@openbaldt  
  end   
  close @@opendt  
  deallocate @@opendt  
  
 end   
 /*IF THE LOGIN = BRANCH THE ONLY THE ENTRIES FOR THAT BRANCH ARE RETRIEVED*/  
 else if @flag = 1    
 begin   
  set @@opendt = cursor for  
  select left(convert(varchar,isnull(max(vdt),0),109),11) from ledger l ,ledger2 l2  
  where l.vtyp = l2.vtype and l.vno = l2.vno and l.lno = l2.lno and vtyp = 18   
  and l.cltcode = @cltcode and edt < = @sdtcur  and costcode = @costcode  
  open @@opendt  
   fetch next from @@opendt into  @@openbaldt  
    
  while @@fetch_status = 0  
  begin  
   /*Find the amount of the opening entry for the client if present else set to 0 */  
   select @@dramt = 0  
   select @@cramt = 0  
   select @@openentry =0  
     
   set @@openbalcursor = cursor  for   
   select dramt = isnull((case when l.drcr = 'd' then sum(vamt) else 0 end),0),  
                cramt  = isnull((case when l.drcr = 'c' then sum(vamt) else 0 end),0)  
   from ledger l ,ledger2 l2  
    where l.vtyp = l2.vtype and l.vno = l2.vno and l.lno = l2.lno and vtyp = 18    
   and edt like @@openbaldt + '%' and l.cltcode = @cltcode and costcode = @costcode  
   group by l.drcr  
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
   select drtotal=isnull((case l.drcr when 'd' then sum(vamt) end),0),   
                crtotal=isnull((case l.drcr when 'c' then sum(vamt) end),0)   
   from ledger l,ledger2 l2  
   where  l.vtyp = l2.vtype and l.vno = l2.vno and l.lno = l2.lno and vtyp <> 18  
   and edt > = @@openbaldt  and edt < @fromdate+' 23:59:59' and l.cltcode = @cltcode and costcode = @costcode  
   group by l.drcr   
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
  
   select @@openingbal  
   fetch next from @@opendt into  @@openbaldt  
  end   
  close @@opendt  
  deallocate @@opendt  
 end   
end

GO
