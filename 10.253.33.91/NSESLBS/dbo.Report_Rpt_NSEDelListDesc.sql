-- Object: PROCEDURE dbo.Report_Rpt_NSEDelListDesc
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------







/****** Object:  Stored Proc Report_dbo.Rpt_NSEDelListDesc    Script Date: 12/16/2003 2:31:23 PM ******/

CREATE Proc Report_Rpt_NSEDelListDesc (@StatusId Varchar(15),@StatusName Varchar(25),@SettNo varchar(7),@Sett_Type Varchar(2),@Party_Code Varchar(10) )
as 
If @statusid = 'broker'
Begin	
	select distinct d.party_code,c1.short_name from DeliveryClt_Report d,Client1_Report c1,Client2_Report c2  
	where d.party_code = c2.party_code and c1.cl_code = c2.cl_code 
	and d.sett_no = @settno and d.sett_type = @Sett_Type 
	order by D.Party_Code DESC
End
If @statusid = 'branch'
Begin	
	select distinct d.party_code,c1.short_name from DeliveryClt_Report d,Client1_Report c1,Client2_Report c2, branches br  
	where d.party_code = c2.party_code and c1.cl_code = c2.cl_code 
	and d.sett_no = @settno and d.sett_type = @Sett_Type 
	and br.short_name = c1.trader and br.branch_cd = @statusname
	order by D.Party_Code DESC
End
If @statusid = 'subbroker'
Begin	
	select distinct d.party_code,c1.short_name from DeliveryClt_Report d,Client1_Report c1,Client2_Report c2, subbrokers sb
	where d.party_code = c2.party_code and c1.cl_code = c2.cl_code 
	and d.sett_no = @settno and d.sett_type = @Sett_Type 
	and sb.sub_broker = c1.sub_broker and sb.sub_broker = @statusname
	order by D.Party_Code DESC
End
If @statusid = 'trader'
Begin	
	select distinct d.party_code,c1.short_name from DeliveryClt_Report d,Client1_Report c1,Client2_Report c2
	where d.party_code = c2.party_code and c1.cl_code = c2.cl_code 
	and d.sett_no = @settno and d.sett_type = @Sett_Type 
	and c1.trader = @statusname
	order by D.Party_Code DESC
End
If @statusid = 'client'
Begin	
	select distinct d.party_code,c1.short_name from DeliveryClt_Report d,Client1_Report c1,Client2_Report c2
	where d.party_code = c2.party_code and c1.cl_code = c2.cl_code 
	and d.sett_no = @settno and d.sett_type = @Sett_Type 
	and c2.party_code = @statusname
	order by D.Party_Code DESC
End
If @statusid = 'family'
Begin	
	select distinct d.party_code,c1.short_name from DeliveryClt_Report d,Client1_Report c1,Client2_Report c2
	where d.party_code = c2.party_code and c1.cl_code = c2.cl_code 
	and d.sett_no = @settno and d.sett_type = @Sett_Type 
	and c1.family = @statusname
	order by D.Party_Code DESC
End

GO
