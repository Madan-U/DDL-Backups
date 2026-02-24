-- Object: PROCEDURE dbo.multi1
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------

--multi1 '0','z','1'

create proc multi1  
@partyfrom varchar(20),  
@partyto varchar(20),  
@sortby varchar(20)  
  
as  

if @partyfrom = '' or @partyto = ''
begin
        
	
        if @sortby = '1'
	begin 
		select   
		 m.Cltcode,m.Chequename,m.Acctype,m.Accno,m.Defaultbank,p.Bank_Name,p.Branch_Name  
		from   
		 account..multibankid m,msajag..pobank p  
		where   
		 m.Bankid=p.Bankid and cltcode between '' and 'zzzzz' 
		order by m.cltcode	
	end
	
	if @sortby = '2'
	begin
		select   
		 m.Cltcode,m.Chequename,m.Acctype,m.Accno,m.Defaultbank,p.Bank_Name,p.Branch_Name  
		from   
		 account..multibankid m,msajag..pobank p  
		where   
		 m.Bankid=p.Bankid and cltcode between '' and 'zzzzz' 
		order by m.Chequename
	
        end
        
        if @sortby = '3'
        begin
                select   
		 m.Cltcode,m.Chequename,m.Acctype,m.Accno,m.Defaultbank,p.Bank_Name,p.Branch_Name  
		from   
		 account..multibankid m,msajag..pobank p  
		where   
		 m.Bankid=p.Bankid and cltcode between '' and 'zzzzz' 
		order by p.Bank_Name
	end
        
        if @sortby = '4'
        begin
                select   
		 m.Cltcode,m.Chequename,m.Acctype,m.Accno,m.Defaultbank,p.Bank_Name,p.Branch_Name  
		from   
		 account..multibankid m,msajag..pobank p  
		where   
		 m.Bankid=p.Bankid and cltcode between '' and 'zzzzz' 
		order by p.Branch_Name
	end
end 
else
begin
        if @sortby = '1'
	begin
	        select   
		 	m.Cltcode,m.Chequename,m.Acctype,m.Accno,m.Defaultbank,p.Bank_Name,p.Branch_Name  
		from   
		 	account..multibankid m,msajag..pobank p  
		where   
			m.Bankid=p.Bankid and cltcode between @partyfrom and @partyto
                order by m.cltcode
        end
   
        if @sortby = '2'
	begin
                select   
		 	m.Cltcode,m.Chequename,m.Acctype,m.Accno,m.Defaultbank,p.Bank_Name,p.Branch_Name  
		from   
		 	account..multibankid m,msajag..pobank p  
		where   
			m.Bankid=p.Bankid and cltcode between @partyfrom and @partyto 
	        order by m.Chequename
        end
     
        if @sortby = '3'
	begin
                select   
		 	m.Cltcode,m.Chequename,m.Acctype,m.Accno,m.Defaultbank,p.Bank_Name,p.Branch_Name  
		from   
		 	account..multibankid m,msajag..pobank p  
		where   
			m.Bankid=p.Bankid and cltcode between @partyfrom and @partyto 
	        order by p.Bank_Name
        end

        if @sortby = '4'
	begin
                select   
		 	m.Cltcode,m.Chequename,m.Acctype,m.Accno,m.Defaultbank,p.Bank_Name,p.Branch_Name  
		from   
		 	account..multibankid m,msajag..pobank p  
		where   
			m.Bankid=p.Bankid and cltcode between @partyfrom and @partyto 
	        order by p.Branch_Name
        end

end

GO
