-- Object: PROCEDURE dbo.rpt_cmlistclient
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.rpt_cmlistclient    Script Date: 05/20/2002 5:36:55 PM ******/
CREATE PROCEDURE rpt_cmlistclient
@statusid varchar(15),
@statusname varchar(25)
AS
if @statusid='broker'
  begin
    select distinct  Family
    from settlement S,Client1 c1 ,Client2 c2 where c1.cl_code =  c2.cl_code and s.party_code = c2.party_Code 
	union 
    select distinct  Family
    from history  S,Client1 c1 ,Client2 c2 where c1.cl_code =  c2.cl_code and s.party_code = c2.party_Code 
    order by Family 
  end

if @statusid='branch'
  begin
    select distinct  Family
    from settlement S,client2 c2, client1 c1, branches b
    where S.Party_Code = c2.Party_code and 
	  ltrim(rtrim(b.short_name)) = ltrim(rtrim(c1.trader)) and
	  c1.cl_code = c2.cl_code and
	  ltrim(rtrim(b.branch_cd)) = ltrim(rtrim(@statusname))
	union 
    select distinct  Family
    from history S,client2 c2, client1 c1, branches b
    where S.Party_Code = c2.Party_code and 
	  ltrim(rtrim(b.short_name)) = ltrim(rtrim(c1.trader)) and
	  c1.cl_code = c2.cl_code and
	  ltrim(rtrim(b.branch_cd)) = ltrim(rtrim(@statusname))
    order by Family 
  end 	

if @statusid='subbroker'
  begin
    select distinct  Family
    from settlement S,client2 c2,client1 c1,subbrokers sb
    where S.Party_Code = c2.Party_code and 
	  c1.cl_code = c2.cl_code and
	  ltrim(rtrim(sb.sub_broker)) = ltrim(rtrim(@statusname)) and
	  ltrim(rtrim(sb.sub_broker)) = ltrim(rtrim(c1.sub_broker))
	union 
    select distinct  Family
    from history S,client2 c2,client1 c1,subbrokers sb
    where S.Party_Code = c2.Party_code and 
	  c1.cl_code = c2.cl_code and
	  ltrim(rtrim(sb.sub_broker)) = ltrim(rtrim(@statusname)) and
	  ltrim(rtrim(sb.sub_broker)) = ltrim(rtrim(c1.sub_broker))
	  order by Family 
  end  

if @statusid='trader'
  begin
    select distinct  Family
    from settlement S,client2 c2, client1 c1
    where S.Party_Code = c2.Party_code  and c1.cl_code = c2.cl_code and ltrim(rtrim(c1.trader))  = ltrim(rtrim(@statusname))
	union 
    select distinct  Family
    from history S,client2 c2, client1 c1
    where S.Party_Code = c2.Party_code and  c1.cl_code = c2.cl_code and ltrim(rtrim(c1.trader))  = ltrim(rtrim(@statusname))
    order by Family 
  end	

if @statusid='client'
  begin
    select distinct  Family
    from settlement S, client2 c2, client1 c1 
    where S.Party_Code = c2.Party_code and 
	  c1.cl_code=c2.cl_code and
	 c1.Family=@statusname 
	union 
    select distinct  Family
    from history S, client2 c2, client1 c1 
    where S.Party_Code = c2.Party_code and 
	  c1.cl_code=c2.cl_code and
	 c1.Family=@statusname 
	order by Family 
  end

if @statusid='family'
  begin
    select distinct  Family
    from settlement S,client2 c2, client1 c1
    where S.Party_Code = c2.Party_code and  c1.cl_code = c2.cl_code and ltrim(rtrim(c1.family))  = ltrim(rtrim(@statusname))
	union 
    select distinct  Family
    from history S,client2 c2, client1 c1
    where S.Party_Code = c2.Party_code and c1.cl_code = c2.cl_code and ltrim(rtrim(c1.family))  = ltrim(rtrim(@statusname))
    order by Family 
  end

GO
