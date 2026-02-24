-- Object: PROCEDURE dbo.rpt_netTBSS
-- Server: 10.253.33.91 | DB: ACCOUNTSLBS
--------------------------------------------------


--*************************************************************

CREATE proc rpt_netTBSS        
@fromdt varchar(11),        
@todt varchar(11),        
@statusid varchar(15),        
@statusname varchar(25),
@Level smallint,
@MainGrp varchar(25),
@segment varchar(3)
     
as        
if @Level = 1        
if @MainGrp<>''    
begin    
	if @segment = 'NSE' 
	begin 
		select cltcode=substring(a.grpcode,1,1) , acname=grpname, Amount=isnull(sum(case when drcr = 'd' then vamt else -vamt end),0),  
		DrAmount=isnull(sum(case when drcr = 'd' then vamt else 0 end),0),  
		CrAmount=isnull(sum(case when drcr = 'c' then vamt else 0 end),0)        
		from ledger l, acmast a, grpmast g        
		where l.cltcode = a.cltcode and substring(a.grpcode,1,1) in (@MainGrp)    
		and vdt >= @fromdt + ' 00:00:00' and vdt <= @todt + ' 23:59:59'        
		and g.grpcode = substring(a.grpcode,1,1)+ '0000000000'         
		group by substring(a.grpcode,1,1), grpname        
		having abs(isnull(sum(case when drcr = 'd' then vamt else -vamt end),0)) > 0        
	end

	else if @segment = 'BSE' 
	begin
		select cltcode=substring(a.grpcode,1,1) , acname=grpname, Amount=isnull(sum(case when drcr = 'd' then vamt else -vamt end),0),  
		DrAmount=isnull(sum(case when drcr = 'd' then vamt else 0 end),0),  
		CrAmount=isnull(sum(case when drcr = 'c' then vamt else 0 end),0)        
		from accountbse.dbo.ledger l, accountbse.dbo.acmast a, accountbse.dbo.grpmast g        
		where l.cltcode = a.cltcode and substring(a.grpcode,1,1) in (@MainGrp)    
		and vdt >= @fromdt + ' 00:00:00' and vdt <= @todt + ' 23:59:59'        
		and g.grpcode = substring(a.grpcode,1,1)+ '0000000000'         
		group by substring(a.grpcode,1,1), grpname        
		having abs(isnull(sum(case when drcr = 'd' then vamt else -vamt end),0)) > 0        
	end

	else if @segment = 'FNO' 
	begin
		select cltcode=substring(a.grpcode,1,1) , acname=grpname, Amount=isnull(sum(case when drcr = 'd' then vamt else -vamt end),0),  
		DrAmount=isnull(sum(case when drcr = 'd' then vamt else 0 end),0),  
		CrAmount=isnull(sum(case when drcr = 'c' then vamt else 0 end),0)        
		from accountfo.dbo.ledger l, accountfo.dbo.acmast a, accountfo.dbo.grpmast g        
		where l.cltcode = a.cltcode and substring(a.grpcode,1,1) in (@MainGrp)    
		and vdt >= @fromdt + ' 00:00:00' and vdt <= @todt + ' 23:59:59'        
		and g.grpcode = substring(a.grpcode,1,1)+ '0000000000'         
		group by substring(a.grpcode,1,1), grpname        
		having abs(isnull(sum(case when drcr = 'd' then vamt else -vamt end),0)) > 0        
		order by cltcode, acname 	
	end
end    
 
else    
begin  
	if @segment = 'NSE' 
	begin
		Select cltcode=substring(a.grpcode,1,1) , acname=grpname, Amount=isnull(sum(case when drcr = 'd' then vamt else -vamt end),0),  
		DrAmount=isnull(sum(case when drcr = 'd' then vamt else 0 end),0),  
		CrAmount=isnull(sum(case when drcr = 'c' then vamt else 0 end),0)        
		from ledger l, acmast a, grpmast g
		where l.cltcode = a.cltcode and substring(a.grpcode,1,1) in ('A','L','X','N')
		and vdt >= @fromdt + ' 00:00:00' and vdt <= @todt + ' 23:59:59'        
		and g.grpcode = substring(a.grpcode,1,1)+ '0000000000'         
		group by substring(a.grpcode,1,1), grpname        
		having abs(isnull(sum(case when drcr = 'd' then vamt else -vamt end),0)) > 0        
	end

	else if @segment = 'BSE' 
	begin
		Select cltcode=substring(a.grpcode,1,1) , acname=grpname, Amount=isnull(sum(case when drcr = 'd' then vamt else -vamt end),0),  
		DrAmount=isnull(sum(case when drcr = 'd' then vamt else 0 end),0),  
		CrAmount=isnull(sum(case when drcr = 'c' then vamt else 0 end),0)        
		from accountbse.dbo.ledger l, accountbse.dbo.acmast a, accountbse.dbo.grpmast g
		where l.cltcode = a.cltcode and substring(a.grpcode,1,1) in ('A','L','X','N')
		and vdt >= @fromdt + ' 00:00:00' and vdt <= @todt + ' 23:59:59'        
		and g.grpcode = substring(a.grpcode,1,1)+ '0000000000'         
		group by substring(a.grpcode,1,1), grpname        
		having abs(isnull(sum(case when drcr = 'd' then vamt else -vamt end),0)) > 0        
	end

	else if @segment = 'FNO' 
	begin
		Select cltcode=substring(a.grpcode,1,1) , acname=grpname, Amount=isnull(sum(case when drcr = 'd' then vamt else -vamt end),0),  
		DrAmount=isnull(sum(case when drcr = 'd' then vamt else 0 end),0),  
		CrAmount=isnull(sum(case when drcr = 'c' then vamt else 0 end),0)        
		from accountfo.dbo.ledger l, accountfo.dbo.acmast a, accountfo.dbo.grpmast g
		where l.cltcode = a.cltcode and substring(a.grpcode,1,1) in ('A','L','X','N')
		and vdt >= @fromdt + ' 00:00:00' and vdt <= @todt + ' 23:59:59'        
		and g.grpcode = substring(a.grpcode,1,1)+ '0000000000'         
		group by substring(a.grpcode,1,1), grpname        
		having abs(isnull(sum(case when drcr = 'd' then vamt else -vamt end),0)) > 0        
		order by cltcode, acname 
	end
end    

else        
begin        
	if @segment = 'NSE' 
	begin
		select cltcode=substring(a.grpcode,1,3) , acname=grpname, Amount=isnull(sum(case when drcr = 'd' then vamt else -vamt end),0),  
		DrAmount=isnull(sum(case when drcr = 'd' then vamt else 0 end),0),  
		CrAmount=isnull(sum(case when drcr = 'c' then vamt else 0 end),0)        
		from ledger l, acmast a, grpmast g        
		where l.cltcode = a.cltcode and substring(a.grpcode,1,1) in (@MainGrp)        
		and vdt >= @fromdt + ' 00:00:00' and vdt <= @todt + ' 23:59:59'        
		and g.grpcode = substring(a.grpcode,1,3)+ '00000000' and a.cltcode <> '99999'        
		group by substring(a.grpcode,1,3), grpname        
		having abs(isnull(sum(case when drcr = 'd' then vamt else -vamt end),0)) > 0        
	end

	else if @segment = 'BSE' 
	begin
		select cltcode=substring(a.grpcode,1,3) , acname=grpname, Amount=isnull(sum(case when drcr = 'd' then vamt else -vamt end),0),  
		DrAmount=isnull(sum(case when drcr = 'd' then vamt else 0 end),0),  
		CrAmount=isnull(sum(case when drcr = 'c' then vamt else 0 end),0)        
		from accountbse.dbo.ledger l, accountbse.dbo.acmast a, accountbse.dbo.grpmast g        
		where l.cltcode = a.cltcode and substring(a.grpcode,1,1) in (@MainGrp)        
		and vdt >= @fromdt + ' 00:00:00' and vdt <= @todt + ' 23:59:59'        
		and g.grpcode = substring(a.grpcode,1,3)+ '00000000' and a.cltcode <> '99999'        
		group by substring(a.grpcode,1,3), grpname        
		having abs(isnull(sum(case when drcr = 'd' then vamt else -vamt end),0)) > 0       
	end

	else if @segment = 'FNO' 
	begin
		select cltcode=substring(a.grpcode,1,3) , acname=grpname, Amount=isnull(sum(case when drcr = 'd' then vamt else -vamt end),0),  
		DrAmount=isnull(sum(case when drcr = 'd' then vamt else 0 end),0),  
		CrAmount=isnull(sum(case when drcr = 'c' then vamt else 0 end),0)        
		from accountfo.dbo.ledger l, accountfo.dbo.acmast a, accountfo.dbo.grpmast g        
		where l.cltcode = a.cltcode and substring(a.grpcode,1,1) in (@MainGrp)        
		and vdt >= @fromdt + ' 00:00:00' and vdt <= @todt + ' 23:59:59'        
		and g.grpcode = substring(a.grpcode,1,3)+ '00000000' and a.cltcode <> '99999'        
		group by substring(a.grpcode,1,3), grpname        
		having abs(isnull(sum(case when drcr = 'd' then vamt else -vamt end),0)) > 0        
		order by cltcode, acname 
	end
end

GO
