-- Object: PROCEDURE dbo.Rpt_NseDelInterSett
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Proc Rpt_NseDelInterSett (
@StatusId Varchar(15),@StatusName Varchar(25),@SettNo varchar(7),@Sett_Type Varchar(2),@ISettNo Varchar(7) )
AS
If @statusid = 'broker'
Begin	
select ISIN=d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd, d.SlipNo, 
qty=sum(d.Qty), d.Delivered, D.ISett_No,D.ISett_Type,BDpId,BCltDpId from deltrans d, client1 c1, client2 c2 
where c1.cl_code = c2.cl_code and c2.party_code = d.party_code and d.TrType in( '907','908') and d.drcr = 'D' 
and Sett_no = @settno and Sett_type = @sett_type and ISett_No like @ISettNo 
Group by d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd,d.series, d.SlipNo,d.Delivered, 
D.ISett_No,D.ISett_Type,BDpId,BCltDpId order by d.party_code, d.Sett_No, d.Sett_type, d.scrip_cd, d.series 
End
If @statusid = 'branch'
Begin	
select ISIN=d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd, d.SlipNo, 
qty=sum(d.Qty), d.Delivered, D.ISett_No,D.ISett_Type,BDpId,BCltDpId from deltrans d, client1 c1, client2 c2 , branches br  
where c1.cl_code = c2.cl_code and c2.party_code = d.party_code and d.TrType in( '907','908') and d.drcr = 'D' 
and Sett_no = @settno and Sett_type = @sett_type and ISett_No like @ISettNo and br.short_name = c1.trader and br.branch_cd = @statusname
Group by d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd,d.series, d.SlipNo,d.Delivered, 
D.ISett_No,D.ISett_Type,BDpId,BCltDpId order by d.party_code, d.Sett_No, d.Sett_type, d.scrip_cd, d.series 
End
If @statusid = 'subbroker'
Begin	
select ISIN=d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd, d.SlipNo, 
qty=sum(d.Qty), d.Delivered, D.ISett_No,D.ISett_Type,BDpId,BCltDpId from deltrans d, client1 c1, client2 c2 , subbrokers sb
where c1.cl_code = c2.cl_code and c2.party_code = d.party_code and d.TrType in( '907','908') and d.drcr = 'D' 
and Sett_no = @settno and Sett_type = @sett_type and ISett_No like @ISettNo and sb.sub_broker = c1.sub_broker and sb.sub_broker = @statusname
Group by d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd,d.series, d.SlipNo,d.Delivered, 
D.ISett_No,D.ISett_Type,BDpId,BCltDpId order by d.party_code, d.Sett_No, d.Sett_type, d.scrip_cd, d.series 
End
If @statusid = 'trader'
Begin	
select ISIN=d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd, d.SlipNo, 
qty=sum(d.Qty), d.Delivered, D.ISett_No,D.ISett_Type,BDpId,BCltDpId from deltrans d, client1 c1, client2 c2 
where c1.cl_code = c2.cl_code and c2.party_code = d.party_code and d.TrType in( '907','908') and d.drcr = 'D' 
and Sett_no = @settno and Sett_type = @sett_type and ISett_No like @ISettNo and c1.trader = @statusname
Group by d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd,d.series, d.SlipNo,d.Delivered, 
D.ISett_No,D.ISett_Type,BDpId,BCltDpId order by d.party_code, d.Sett_No, d.Sett_type, d.scrip_cd, d.series 
End
If @statusid = 'client'
Begin	
select ISIN=d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd, d.SlipNo, 
qty=sum(d.Qty), d.Delivered, D.ISett_No,D.ISett_Type,BDpId,BCltDpId from deltrans d, client1 c1, client2 c2 
where c1.cl_code = c2.cl_code and c2.party_code = d.party_code and d.TrType in( '907','908') and d.drcr = 'D' 
and Sett_no = @settno and Sett_type = @sett_type and ISett_No like @ISettNo and c2.party_code = @statusname
Group by d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd,d.series, d.SlipNo,d.Delivered, 
D.ISett_No,D.ISett_Type,BDpId,BCltDpId order by d.party_code, d.Sett_No, d.Sett_type, d.scrip_cd, d.series 
End
If @statusid = 'family'
Begin	
select ISIN=d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd, d.SlipNo, 
qty=sum(d.Qty), d.Delivered, D.ISett_No,D.ISett_Type,BDpId,BCltDpId from deltrans d, client1 c1, client2 c2 
where c1.cl_code = c2.cl_code and c2.party_code = d.party_code and d.TrType in( '907','908') and d.drcr = 'D' 
and Sett_no = @settno and Sett_type = @sett_type and ISett_No like @ISettNo and c1.family = @statusname
Group by d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd,d.series, d.SlipNo,d.Delivered, 

D.ISett_No,D.ISett_Type,BDpId,BCltDpId order by d.party_code, d.Sett_No, d.Sett_type, d.scrip_cd, d.series 
End

GO
