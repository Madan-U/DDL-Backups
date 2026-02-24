-- Object: PROCEDURE dbo.Report_Rpt_NseDelInterSett
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------








CREATE Proc Report_Rpt_NseDelInterSett (
@StatusId Varchar(15),@StatusName Varchar(25),@SettNo varchar(7),@Sett_Type Varchar(2),@ISettNo Varchar(7),@Flag Varchar(1))
AS
If @Flag = 'P' 
Begin
select ISIN=d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd, d.SlipNo, 
qty=sum(d.Qty), d.Delivered, D.ISett_No,D.ISett_Type,BDpId,BCltDpId, TransDate=Convert(Varchar,TransDate,103)
from Deltrans_Report d, Client1_Report c1, Client2_Report c2 
where c1.cl_code = c2.cl_code and c2.party_code = d.party_code and d.TrType in( '907','908') and d.drcr = 'D' 
and Sett_no = @settno and Sett_type = @sett_type and ISett_No like @ISettNo 
And C1.Branch_CD Like (Case When @StatusId = 'branch' Then @StatusName Else '%' End)
And C1.Sub_Broker Like (Case When @StatusId = 'subbroker' Then @StatusName Else '%' End)
And C1.Trader Like (Case When @StatusId = 'trader' Then @StatusName Else '%' End)
And C1.Family Like (Case When @StatusId = 'family' Then @StatusName Else '%' End)
And C2.Party_Code Like (Case When @StatusId = 'client' Then @StatusName Else '%' End)
Group by d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd,d.series, d.SlipNo,d.Delivered, 
D.ISett_No,D.ISett_Type,BDpId,BCltDpId,Convert(Varchar,TransDate,103) 
order by d.party_code, d.Sett_No, d.Sett_type, d.scrip_cd, d.series,Convert(Varchar,TransDate,103)
End
Else
Begin
select ISIN=d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd, d.SlipNo, 
qty=sum(d.Qty), d.Delivered, D.ISett_No,D.ISett_Type,BDpId,BCltDpId, TransDate=Convert(Varchar,TransDate,103)
from Deltrans_Report d, Client1_Report c1, Client2_Report c2 
where c1.cl_code = c2.cl_code and c2.party_code = d.party_code and d.TrType in( '907','908') and d.drcr = 'D' 
and Sett_no = @settno and Sett_type = @sett_type and ISett_No like @ISettNo 
And C1.Branch_CD Like (Case When @StatusId = 'branch' Then @StatusName Else '%' End)
And C1.Sub_Broker Like (Case When @StatusId = 'subbroker' Then @StatusName Else '%' End)
And C1.Trader Like (Case When @StatusId = 'trader' Then @StatusName Else '%' End)
And C1.Family Like (Case When @StatusId = 'family' Then @StatusName Else '%' End)
And C2.Party_Code Like (Case When @StatusId = 'client' Then @StatusName Else '%' End)
Group by d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd,d.series, d.SlipNo,d.Delivered, 
D.ISett_No,D.ISett_Type,BDpId,BCltDpId,Convert(Varchar,TransDate,103) 
order by d.scrip_cd, d.series,d.party_code, d.Sett_No, d.Sett_type, Convert(Varchar,TransDate,103)
End

GO
