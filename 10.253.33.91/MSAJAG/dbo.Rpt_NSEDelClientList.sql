-- Object: PROCEDURE dbo.Rpt_NSEDelClientList
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE Proc Rpt_NSEDelClientList (@StatusId Varchar(15),@StatusName Varchar(25),@SettNo varchar(7),@Sett_Type Varchar(2),@Party_Code Varchar(10) )
as 
If @statusid = 'broker'
Begin	
	select distinct d.party_code,c1.short_name from deliveryclt d,client1 c1,client2 c2  
	where d.party_code = c2.party_code and c1.cl_code = c2.cl_code 
	and d.sett_no like @settno and d.sett_type like @Sett_Type and d.party_code like @Party_Code + '%'
	order by c1.short_name 
End
If @statusid = 'branch'
Begin	
	select distinct d.party_code,c1.short_name from deliveryclt d,client1 c1,client2 c2, branches br  
	where d.party_code = c2.party_code and c1.cl_code = c2.cl_code 
	and d.sett_no like @settno and d.sett_type like @Sett_Type and d.party_code like @Party_Code + '%'
	and br.short_name = c1.trader and br.branch_cd = @statusname
	order by c1.short_name 
End
If @statusid = 'subbroker'
Begin	
	select distinct d.party_code,c1.short_name from deliveryclt d,client1 c1,client2 c2, subbrokers sb
	where d.party_code = c2.party_code and c1.cl_code = c2.cl_code 
	and d.sett_no like @settno and d.sett_type like @Sett_Type and d.party_code like @Party_Code + '%'
	and sb.sub_broker = c1.sub_broker and sb.sub_broker = @statusname
	order by c1.short_name 
End
If @statusid = 'trader'
Begin	
	select distinct d.party_code,c1.short_name from deliveryclt d,client1 c1,client2 c2
	where d.party_code = c2.party_code and c1.cl_code = c2.cl_code 
	and d.sett_no like @settno and d.sett_type like @Sett_Type and d.party_code like @Party_Code + '%'
	and c1.trader = @statusname
	order by c1.short_name 
End
If @statusid = 'client'
Begin	
	select distinct d.party_code,c1.short_name from deliveryclt d,client1 c1,client2 c2
	where d.party_code = c2.party_code and c1.cl_code = c2.cl_code 
	and d.sett_no like @settno and d.sett_type like @Sett_Type and d.party_code like @Party_Code + '%'
	and c2.party_code = @statusname
	order by c1.short_name 
End
If @statusid = 'family'
Begin	
	select distinct d.party_code,c1.short_name from deliveryclt d,client1 c1,client2 c2
	where d.party_code = c2.party_code and c1.cl_code = c2.cl_code 
	and d.sett_no like @settno and d.sett_type like @Sett_Type and d.party_code like @Party_Code + '%'
	and c1.family = @statusname
	order by c1.short_name 
End

GO
