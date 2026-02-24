-- Object: PROCEDURE dbo.Report_Rpt_NseDelInterBen
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



CREATE Proc Report_Rpt_NseDelInterBen (
@StatusId Varchar(15),@StatusName Varchar(25),@SettNo varchar(7),@ISett_Type Varchar(2),@ISettNo Varchar(7) )
AS

if @settno > '2005105'
begin
	If @statusid = 'broker'
	Begin	
	Set Transaction Isolation level read uncommitted
	select ISIN=d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd, d.SlipNo, 
	qty=sum(d.Qty), d.Delivered, D.ISett_No,D.ISett_Type from Deltrans_Report d, Client1_Report c1, Client2_Report c2 
	where c1.cl_code = c2.cl_code and c2.party_code = d.party_code and d.TrType = 1000 and d.drcr = 'D' 
	and Sett_no Like @settno and ISett_type = @Isett_type and ISett_No = @ISettNo 
	Group by d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd,d.series, d.SlipNo,d.Delivered, 
	D.ISett_No,D.ISett_Type order by d.party_code, d.Sett_No, d.Sett_type, d.scrip_cd, d.series 
	End
	If @statusid = 'branch'
	Begin	
	Set Transaction Isolation level read uncommitted
	select ISIN=d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd, d.SlipNo, 
	qty=sum(d.Qty), d.Delivered, D.ISett_No,D.ISett_Type from Deltrans_Report d, Client1_Report c1, Client2_Report c2 , branches br  
	where c1.cl_code = c2.cl_code and c2.party_code = d.party_code and d.TrType = 1000 and d.drcr = 'D' 
	and Sett_no Like @settno and ISett_type = @Isett_type and ISett_No = @ISettNo and br.short_name = c1.trader and br.branch_cd = @statusname
	Group by d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd,d.series, d.SlipNo,d.Delivered, 
	D.ISett_No,D.ISett_Type order by d.party_code, d.Sett_No, d.Sett_type, d.scrip_cd, d.series 
	End
	If @statusid = 'subbroker'
	Begin	
	Set Transaction Isolation level read uncommitted
	select ISIN=d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd, d.SlipNo, 
	qty=sum(d.Qty), d.Delivered, D.ISett_No,D.ISett_Type from Deltrans_Report d, Client1_Report c1, Client2_Report c2 , subbrokers sb
	where c1.cl_code = c2.cl_code and c2.party_code = d.party_code and d.TrType = 1000 and d.drcr = 'D' 
	and Sett_no Like @settno and ISett_type = @Isett_type and ISett_No = @ISettNo and sb.sub_broker = c1.sub_broker and sb.sub_broker = @statusname
	Group by d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd,d.series, d.SlipNo,d.Delivered, 
	D.ISett_No,D.ISett_Type order by d.party_code, d.Sett_No, d.Sett_type, d.scrip_cd, d.series 
	End
	If @statusid = 'trader'
	Begin	
	Set Transaction Isolation level read uncommitted
	select ISIN=d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd, d.SlipNo, 
	qty=sum(d.Qty), d.Delivered, D.ISett_No,D.ISett_Type from Deltrans_Report d, Client1_Report c1, Client2_Report c2 
	where c1.cl_code = c2.cl_code and c2.party_code = d.party_code and d.TrType = 1000 and d.drcr = 'D' 
	and Sett_no Like @settno and ISett_type = @Isett_type and ISett_No = @ISettNo and c1.trader = @statusname
	Group by d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd,d.series, d.SlipNo,d.Delivered, 
	D.ISett_No,D.ISett_Type order by d.party_code, d.Sett_No, d.Sett_type, d.scrip_cd, d.series 
	End
	If @statusid = 'client'
	Begin	
	Set Transaction Isolation level read uncommitted
	select ISIN=d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd, d.SlipNo, 
	qty=sum(d.Qty), d.Delivered, D.ISett_No,D.ISett_Type from Deltrans_Report d, Client1_Report c1, Client2_Report c2 
	where c1.cl_code = c2.cl_code and c2.party_code = d.party_code and d.TrType = 1000 and d.drcr = 'D' 
	and Sett_no Like @settno and ISett_type = @Isett_type and ISett_No = @ISettNo and c2.party_code = @statusname
	Group by d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd,d.series, d.SlipNo,d.Delivered, 
	D.ISett_No,D.ISett_Type order by d.party_code, d.Sett_No, d.Sett_type, d.scrip_cd, d.series 
	End
	If @statusid = 'family'
	Begin	
	Set Transaction Isolation level read uncommitted
	select ISIN=d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd, d.SlipNo, 
	qty=sum(d.Qty), d.Delivered, D.ISett_No,D.ISett_Type 
	from Deltrans_Report d, Client1_Report c1, Client2_Report c2 
	where c1.cl_code = c2.cl_code and c2.party_code = d.party_code and d.TrType = 1000 and d.drcr = 'D' 
	and Sett_no Like @settno and ISett_type = @Isett_type and ISett_No = @ISettNo and c1.family = @statusname
	Group by d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd,d.series, d.SlipNo,d.Delivered, 
	D.ISett_No,D.ISett_Type order by d.party_code, d.Sett_No, d.Sett_type, d.scrip_cd, d.series 
	End
end
else
begin
	If @statusid = 'broker'
	Begin	
	Set Transaction Isolation level read uncommitted
	select ISIN=d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd, d.SlipNo, 
	qty=sum(d.Qty), d.Delivered, D.ISett_No,D.ISett_Type from deltrans_report d, Client1_Report c1, Client2_Report c2 
	where c1.cl_code = c2.cl_code and c2.party_code = d.party_code and d.TrType = 1000 and d.drcr = 'D' 
	and Sett_no Like @settno and ISett_type = @Isett_type and ISett_No = @ISettNo 
	Group by d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd,d.series, d.SlipNo,d.Delivered, 
	D.ISett_No,D.ISett_Type order by d.party_code, d.Sett_No, d.Sett_type, d.scrip_cd, d.series 
	End
	If @statusid = 'branch'
	Begin	
	Set Transaction Isolation level read uncommitted
	select ISIN=d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd, d.SlipNo, 
	qty=sum(d.Qty), d.Delivered, D.ISett_No,D.ISett_Type from deltrans_report d, Client1_Report c1, Client2_Report c2 , branches br  
	where c1.cl_code = c2.cl_code and c2.party_code = d.party_code and d.TrType = 1000 and d.drcr = 'D' 
	and Sett_no Like @settno and ISett_type = @Isett_type and ISett_No = @ISettNo and br.short_name = c1.trader and br.branch_cd = @statusname
	Group by d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd,d.series, d.SlipNo,d.Delivered, 
	D.ISett_No,D.ISett_Type order by d.party_code, d.Sett_No, d.Sett_type, d.scrip_cd, d.series 
	End
	If @statusid = 'subbroker'
	Begin	
	Set Transaction Isolation level read uncommitted
	select ISIN=d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd, d.SlipNo, 
	qty=sum(d.Qty), d.Delivered, D.ISett_No,D.ISett_Type from deltrans_report d, Client1_Report c1, Client2_Report c2 , subbrokers sb
	where c1.cl_code = c2.cl_code and c2.party_code = d.party_code and d.TrType = 1000 and d.drcr = 'D' 
	and Sett_no Like @settno and ISett_type = @Isett_type and ISett_No = @ISettNo and sb.sub_broker = c1.sub_broker and sb.sub_broker = @statusname
	Group by d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd,d.series, d.SlipNo,d.Delivered, 
	D.ISett_No,D.ISett_Type order by d.party_code, d.Sett_No, d.Sett_type, d.scrip_cd, d.series 
	End
	If @statusid = 'trader'
	Begin	
	Set Transaction Isolation level read uncommitted
	select ISIN=d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd, d.SlipNo, 
	qty=sum(d.Qty), d.Delivered, D.ISett_No,D.ISett_Type from deltrans_report d, Client1_Report c1, Client2_Report c2 
	where c1.cl_code = c2.cl_code and c2.party_code = d.party_code and d.TrType = 1000 and d.drcr = 'D' 
	and Sett_no Like @settno and ISett_type = @Isett_type and ISett_No = @ISettNo and c1.trader = @statusname
	Group by d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd,d.series, d.SlipNo,d.Delivered, 
	D.ISett_No,D.ISett_Type order by d.party_code, d.Sett_No, d.Sett_type, d.scrip_cd, d.series 
	End
	If @statusid = 'client'
	Begin	
	Set Transaction Isolation level read uncommitted
	select ISIN=d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd, d.SlipNo, 
	qty=sum(d.Qty), d.Delivered, D.ISett_No,D.ISett_Type from deltrans_report d, Client1_Report c1, Client2_Report c2 
	where c1.cl_code = c2.cl_code and c2.party_code = d.party_code and d.TrType = 1000 and d.drcr = 'D' 
	and Sett_no Like @settno and ISett_type = @Isett_type and ISett_No = @ISettNo and c2.party_code = @statusname
	Group by d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd,d.series, d.SlipNo,d.Delivered, 
	D.ISett_No,D.ISett_Type order by d.party_code, d.Sett_No, d.Sett_type, d.scrip_cd, d.series 
	End
	If @statusid = 'family'
	Begin	
	Set Transaction Isolation level read uncommitted
	select ISIN=d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd, d.SlipNo, 
	qty=sum(d.Qty), d.Delivered, D.ISett_No,D.ISett_Type 
	from deltrans_report d, Client1_Report c1, Client2_Report c2 
	where c1.cl_code = c2.cl_code and c2.party_code = d.party_code and d.TrType = 1000 and d.drcr = 'D' 
	and Sett_no Like @settno and ISett_type = @Isett_type and ISett_No = @ISettNo and c1.family = @statusname
	Group by d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd,d.series, d.SlipNo,d.Delivered, 
	D.ISett_No,D.ISett_Type order by d.party_code, d.Sett_No, d.Sett_type, d.scrip_cd, d.series 
	End

end

GO
