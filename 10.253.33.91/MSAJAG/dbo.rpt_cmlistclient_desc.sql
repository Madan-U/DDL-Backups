-- Object: PROCEDURE dbo.rpt_cmlistclient_desc
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROCEDURE rpt_cmlistclient_desc
@statusid varchar(15),
@statusname varchar(25)
AS
if @statusid='broker'
  begin
    select distinct "<option value="+rtrim(party_code)+">"+rtrim(party_code)+"</option>" , party_code
    from settlement
	union all
    select distinct "<option value="+rtrim(party_code)+">"+rtrim(party_code)+"</option>" , party_code
    from history
    order by party_code desc
  end

if @statusid='branch'
  begin
    select distinct "<option value="+rtrim(fo.Party_Code)+">"+rtrim(fo.Party_Code)+"</option>" , fo.Party_Code
    from settlement fo,client2 c2, client1 c1, branches b
    where fo.Party_Code = c2.party_code and 
	  ltrim(rtrim(b.short_name)) = ltrim(rtrim(c1.trader)) and
	  c1.cl_code = c2.cl_code and
	  ltrim(rtrim(b.branch_cd)) = ltrim(rtrim(@statusname))
	union all
    select distinct "<option value="+rtrim(fo.Party_Code)+">"+rtrim(fo.Party_Code)+"</option>" , fo.Party_Code
    from history fo,client2 c2, client1 c1, branches b
    where fo.Party_Code = c2.party_code and 
	  ltrim(rtrim(b.short_name)) = ltrim(rtrim(c1.trader)) and
	  c1.cl_code = c2.cl_code and
	  ltrim(rtrim(b.branch_cd)) = ltrim(rtrim(@statusname))
    order by fo.Party_Code desc
  end 	

if @statusid='subbroker'
  begin
    select distinct "<option value="+rtrim(fo.Party_Code)+">"+rtrim(fo.Party_Code)+"</option>" , fo.Party_Code
    from settlement fo,client2 c2,client1 c1,subbrokers sb
    where fo.Party_Code = c2.party_code and 
	  c1.cl_code = c2.cl_code and
	  ltrim(rtrim(sb.sub_broker)) = ltrim(rtrim(@statusname)) and
	  ltrim(rtrim(sb.sub_broker)) = ltrim(rtrim(c1.sub_broker))
	union all
    select distinct "<option value="+rtrim(fo.Party_Code)+">"+rtrim(fo.Party_Code)+"</option>" , fo.Party_Code
    from history fo,client2 c2,client1 c1,subbrokers sb
    where fo.Party_Code = c2.party_code and 
	  c1.cl_code = c2.cl_code and
	  ltrim(rtrim(sb.sub_broker)) = ltrim(rtrim(@statusname)) and
	  ltrim(rtrim(sb.sub_broker)) = ltrim(rtrim(c1.sub_broker))
	  order by fo.Party_Code desc
  end  

if @statusid='trader'
  begin
    select distinct "<option value="+rtrim(fo.Party_Code)+">"+rtrim(fo.Party_Code)+"</option>" , fo.Party_Code
    from settlement fo,client2 c2, client1 c1
    where fo.Party_Code = c2.party_code and c1.cl_code = c2.cl_code and ltrim(rtrim(c1.trader))  = ltrim(rtrim(@statusname))
	union all
    select distinct "<option value="+rtrim(fo.Party_Code)+">"+rtrim(fo.Party_Code)+"</option>" , fo.Party_Code
    from history fo,client2 c2, client1 c1
    where fo.Party_Code = c2.party_code and c1.cl_code = c2.cl_code and ltrim(rtrim(c1.trader))  = ltrim(rtrim(@statusname))
    order by fo.Party_Code desc
  end	

if @statusid='client'
  begin
    select distinct "<option value="+rtrim(fo.Party_Code)+">"+rtrim(fo.Party_Code)+"</option>" , fo.Party_Code
    from settlement fo, client2 c2, client1 c1 
    where fo.Party_Code=c2.party_code and
	  c1.cl_code=c2.cl_code and
	 c2.party_code=@statusname 
	union all
    select distinct "<option value="+rtrim(fo.Party_Code)+">"+rtrim(fo.Party_Code)+"</option>" , fo.Party_Code
    from history fo, client2 c2, client1 c1 
    where fo.Party_Code=c2.party_code and
	  c1.cl_code=c2.cl_code and
	 c2.party_code=@statusname 
	order by fo.Party_Code desc
  end

if @statusid='family'
  begin
    select distinct "<option value="+rtrim(fo.Party_Code)+">"+rtrim(fo.Party_Code)+"</option>" , fo.Party_Code
    from settlement fo,client2 c2, client1 c1
    where fo.Party_Code = c2.party_code and c1.cl_code = c2.cl_code and ltrim(rtrim(c1.family))  = ltrim(rtrim(@statusname))
	union all
    select distinct "<option value="+rtrim(fo.Party_Code)+">"+rtrim(fo.Party_Code)+"</option>" , fo.Party_Code
    from history fo,client2 c2, client1 c1
    where fo.Party_Code = c2.party_code and c1.cl_code = c2.cl_code and ltrim(rtrim(c1.family))  = ltrim(rtrim(@statusname))
    order by fo.Party_Code desc
  end

GO
