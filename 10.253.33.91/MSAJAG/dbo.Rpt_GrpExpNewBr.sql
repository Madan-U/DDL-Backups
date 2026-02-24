-- Object: PROCEDURE dbo.Rpt_GrpExpNewBr
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.Rpt_GrpExpNewBr    Script Date: 05/20/2002 5:24:33 PM ******/
CREATE proc Rpt_GrpExpNewBr

@statusid varchar(10),
@statusname varchar(25),
@sett_no varchar(7),
@sett_type varchar(2),
@fcode varchar(10),
@tcode varchar(10) 

as

if @statusid = 'broker'
begin
	delete from RptGrpExpNew 
	insert into RptGrpExpNew 
	select sett_no,sett_type,s.Party_code,c1.short_name,Family,scrip_cd,series,sell_buy,Pqty,Pamt,Sqty,samt,Branch_Cd,Sub_Broker
	from tempsettsumExp s, client1 c1, client2 c2 where sett_no like @sett_no+'%' and sett_type like @sett_type+'%' 
	and Branch_Cd >= @fcode  and Branch_Cd <= @tcode and C1.Cl_Code = C2.Cl_Code and C2.Party_Code = S.Party_Code
	union all
	select sett_no,sett_type,s.party_code,c1.short_name,family,scrip_cd,series,sell_buy,Pqty,Pamt,Sqty,samt,Branch_Cd,Sub_Broker
	from oppalbmExp s, client1 c1, client2 c2 where sett_no like @sett_no +'%'  and sett_type like @sett_type+'%' 
	and Branch_Cd >= @fcode  and Branch_Cd <= @tcode and C1.Cl_Code = C2.Cl_Code and C2.Party_Code = S.Party_Code
	union all
	select sett_no,sett_type,s.Party_code,c1.short_name,Family,scrip_cd,series,sell_buy,Pqty,Pamt,Sqty,samt,Branch_Cd,Sub_Broker
	from PlusOneAlbmExp s, client1 c1, client2 c2 where sett_no like @sett_no + '%' and sett_type like @sett_Type+'%' 
	and Branch_Cd >= @fcode  and Branch_Cd <= @tcode and C1.Cl_Code = C2.Cl_Code and C2.Party_Code = S.Party_Code
	order by Branch_Cd 
end 

if @statusid = 'branch'
begin
	delete from RptGrpExpNew 
	insert into RptGrpExpNew 
	select sett_no,sett_type,s.party_code,c1.short_name,Family,scrip_cd,series,sell_buy,Pqty,Pamt,Sqty,samt,c1.Branch_Cd,c1.Sub_Broker
	from tempsettsumExp s, client1 c1, client2 c2, branches br
	where sett_no like @sett_no+'%' and sett_type like @sett_type+'%' 
	and C1.Branch_Cd >= @fcode  and C1.Branch_Cd <= @tcode
	and c1.cl_code = c2.cl_code and c2.party_code = S.Party_Code  
	and br.short_name = c1.trader and br.branch_cd = @statusname
	union all
	select sett_no,sett_type,s.party_code,c1.short_name,Family,scrip_cd,series,sell_buy,Pqty,Pamt,Sqty,samt,c1.Branch_Cd,c1.Sub_Broker
	from oppalbmExp s, client1 c1, client2 c2, branches br
	where sett_no like @sett_no +'%'  and sett_type like @sett_type+'%' 
	and C1.Branch_Cd >= @fcode  and C1.Branch_Cd <= @tcode
	and c1.cl_code = c2.cl_code and c2.party_code = S.Party_Code   
	and br.short_name = c1.trader and br.branch_cd = @statusname
	union all
	select sett_no,sett_type,s.party_code,c1.short_name,Family,scrip_cd,series,sell_buy,Pqty,Pamt,Sqty,samt,C1.Branch_Cd,Sub_Broker
	from PlusOneAlbmExp s, client1 c1, client2 c2, branches br
	where sett_no like @sett_no + '%' and sett_type like @sett_Type+'%' 
	and C1.Branch_Cd >= @fcode  and C1.Branch_Cd <= @tcode
	and c1.cl_code = c2.cl_code and c2.party_code = S.Party_Code   
	and br.short_name = c1.trader and br.branch_cd = @statusname
	order by C1.Branch_Cd 
end 

if @statusid = 'subbroker'
begin
	delete from RptGrpExpNew 
	insert into RptGrpExpNew 
	select sett_no,sett_type,s.party_code,c1.short_name,Family,scrip_cd,series,sell_buy,Pqty,Pamt,Sqty,samt,Branch_Cd,c1.Sub_Broker
	from tempsettsumExp s, client1 c1, client2 c2, subbrokers sb
	where sett_no like @sett_no+'%' and sett_type like @sett_type+'%' 
	and Branch_Cd >= @fcode  and Branch_Cd <= @tcode
	and c1.cl_code = c2.cl_code and c2.party_code = S.Party_Code   
	and sb.sub_broker = c1.sub_broker and sb.sub_broker= @statusname
	union all
	select sett_no,sett_type,s.party_code,c1.short_name,Family,scrip_cd,series,sell_buy,Pqty,Pamt,Sqty,samt,Branch_Cd,c1.Sub_Broker
	from oppalbmExp s, client1 c1, client2 c2, subbrokers sb
	where sett_no like @sett_no +'%'  and sett_type like @sett_type+'%' 
	and Branch_Cd >= @fcode  and Branch_Cd <= @tcode
	and c1.cl_code = c2.cl_code and c2.party_code = S.Party_Code   
	and sb.sub_broker = c1.sub_broker and sb.sub_broker= @statusname
	union all
	select sett_no,sett_type,s.party_code,c1.short_name,Family,scrip_cd,series,sell_buy,Pqty,Pamt,Sqty,samt,Branch_Cd,C1.Sub_Broker
	from PlusOneAlbmExp s, client1 c1, client2 c2, subbrokers sb
	where sett_no like @sett_no + '%' and sett_type like @sett_Type+'%' 
	and Branch_Cd >= @fcode  and Branch_Cd <= @tcode
	and c1.cl_code = c2.cl_code and c2.party_code = S.Party_Code   
	and sb.sub_broker = c1.sub_broker and sb.sub_broker= @statusname
	order by Branch_Cd 
end 

if @statusid = 'trader'
begin
	delete from RptGrpExpNew 
	insert into RptGrpExpNew 
	select sett_no,sett_type,s.party_code,c1.short_name,Family,scrip_cd,series,sell_buy,Pqty,Pamt,Sqty,samt,Branch_Cd,Sub_Broker
	from tempsettsumExp s, client1 c1, client2 c2
	where sett_no like @sett_no+'%' and sett_type like @sett_type+'%' 
	and Branch_Cd >= @fcode  and Branch_Cd <= @tcode
	and c1.cl_code = c2.cl_code and c2.party_code = S.Party_Code  
	and c1.trader = @statusname
	union all
	select sett_no,sett_type,s.party_code,c1.short_name,Family,scrip_cd,series,sell_buy,Pqty,Pamt,Sqty,samt,Branch_Cd,Sub_Broker
	from oppalbmExp s, client1 c1, client2 c2 
	where sett_no like @sett_no +'%'  and sett_type like @sett_type+'%' 
	and Branch_Cd >= @fcode  and Branch_Cd <= @tcode
	and c1.cl_code = c2.cl_code and c2.party_code = S.Party_Code   
	and c1.trader = @statusname
	union all
	select sett_no,sett_type,s.party_code,c1.short_name,Family,scrip_cd,series,sell_buy,Pqty,Pamt,Sqty,samt,Branch_Cd,Sub_Broker
	from PlusOneAlbmExp s, client1 c1, client2 c2 
	where sett_no like @sett_no + '%' and sett_type like @sett_Type+'%' 
	and Branch_Cd >= @fcode  and Branch_Cd <= @tcode
	and c1.cl_code = c2.cl_code and c2.party_code = S.Party_Code   
	and c1.trader = @statusname
	order by Branch_Cd 
end 

if @statusid = 'client'
begin
	delete from RptGrpExpNew 
	insert into RptGrpExpNew 
	select sett_no,sett_type,s.party_code,c1.short_name,Family,scrip_cd,series,sell_buy,Pqty,Pamt,Sqty,samt,Branch_Cd,Sub_Broker
	from tempsettsumExp s, client1 c1, client2 c2
	where sett_no like @sett_no+'%' and sett_type like @sett_type+'%' 
	and c1.cl_code = c2.cl_code and c2.party_code = S.Party_Code   
	and c2.party_code = @statusname
	union all
	select sett_no,sett_type,s.party_code,c1.short_name,Family,scrip_cd,series,sell_buy,Pqty,Pamt,Sqty,samt,Branch_Cd,Sub_Broker
	from oppalbmExp s, client1 c1, client2 c2 
	where sett_no like @sett_no +'%'  and sett_type like @sett_type+'%' 
	and c1.cl_code = c2.cl_code and c2.party_code = S.Party_Code   
	and c2.party_code = @statusname
	union all
	select sett_no,sett_type,s.party_code,c1.short_name,Family,scrip_cd,series,sell_buy,Pqty,Pamt,Sqty,samt,Branch_Cd,Sub_Broker
	from PlusOneAlbmExp s, client1 c1, client2 c2 
	where sett_no like @sett_no + '%' and sett_type like @sett_Type+'%' 
	and c1.cl_code = c2.cl_code and c2.party_code = S.Party_Code   
	and c2.party_code = @statusname
	order by Branch_Cd 
end 


if @statusid = 'family'
begin
	delete from RptGrpExpNew 
	insert into RptGrpExpNew 
	select sett_no,sett_type,s.party_code,c1.short_name,Family,scrip_cd,series,sell_buy,Pqty,Pamt,Sqty,samt,Branch_Cd,Sub_Broker
	from tempsettsumExp s, client1 c1, client2 c2
	where sett_no like @sett_no+'%' and sett_type like @sett_type+'%' 
	and Branch_Cd >= @fcode  and Branch_Cd <= @tcode
	and c1.cl_code = c2.cl_code and c2.party_code = S.Party_Code   
	and c1.family = @statusname
	union all
	select sett_no,sett_type,s.party_code,c1.short_name,Family,scrip_cd,series,sell_buy,Pqty,Pamt,Sqty,samt,Branch_Cd,Sub_Broker
	from oppalbmExp s, client1 c1, client2 c2 
	where sett_no like @sett_no +'%'  and sett_type like @sett_type+'%' 
	and Branch_Cd >= @fcode  and Branch_Cd <= @tcode
	and c1.cl_code = c2.cl_code and c2.party_code = S.Party_Code   
	and c1.family = @statusname
	union all
	select sett_no,sett_type,s.party_code,c1.short_name,Family,scrip_cd,series,sell_buy,Pqty,Pamt,Sqty,samt,Branch_Cd,Sub_Broker
	from PlusOneAlbmExp s, client1 c1, client2 c2 
	where sett_no like @sett_no + '%' and sett_type like @sett_Type+'%' 
	and Branch_Cd >= @fcode  and Branch_Cd <= @tcode
	and c1.cl_code = c2.cl_code and c2.party_code = S.Party_Code   
	and c1.family = @statusname
	order by Branch_Cd 
end

GO
