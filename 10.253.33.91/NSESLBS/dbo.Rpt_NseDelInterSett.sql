-- Object: PROCEDURE dbo.Rpt_NseDelInterSett
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc Rpt_NseDelInterSett (    
@StatusId Varchar(15),@StatusName Varchar(25),@SettNo varchar(7),@Sett_Type Varchar(2),@ISettNo Varchar(7),@Flag Varchar(1))    
AS    
If @Flag = 'P'     
Begin    
select ISIN=d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd, d.SlipNo,     
qty=sum(d.Qty), d.Delivered, D.ISett_No,D.ISett_Type,BDpId,BCltDpId, TransDate=Convert(Varchar,TransDate,103)    
from deltrans d, client1 c1, client2 c2     
where c1.cl_code = c2.cl_code and c2.party_code = d.party_code and d.TrType in( '907','908') and d.drcr = 'D'     
and Sett_no = @settno and Sett_type = @sett_type and ISett_No like @ISettNo     
And @StatusName = 
	  (case 
	        when @StatusId = 'BRANCH' then c1.branch_cd
	        when @StatusId = 'SUBBROKER' then c1.sub_broker
	        when @StatusId = 'Trader' then c1.Trader
	        when @StatusId = 'Family' then c1.Family
	        when @StatusId = 'Area' then c1.Area
	        when @StatusId = 'Region' then c1.Region
	        when @StatusId = 'Client' then c2.party_code
	  else 
	        'BROKER'
	  End)  
Group by d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd,d.series, d.SlipNo,d.Delivered,     
D.ISett_No,D.ISett_Type,BDpId,BCltDpId,Convert(Varchar,TransDate,103)     
order by d.party_code, d.Sett_No, d.Sett_type, d.scrip_cd, d.series,Convert(Varchar,TransDate,103)    
End    
Else    
Begin    
select ISIN=d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd, d.SlipNo,     
qty=sum(d.Qty), d.Delivered, D.ISett_No,D.ISett_Type,BDpId,BCltDpId, TransDate=Convert(Varchar,TransDate,103)    
from deltrans d, client1 c1, client2 c2     
where c1.cl_code = c2.cl_code and c2.party_code = d.party_code and d.TrType in( '907','908') and d.drcr = 'D'     
and Sett_no = @settno and Sett_type = @sett_type and ISett_No like @ISettNo     
And @StatusName = 
	  (case 
	        when @StatusId = 'BRANCH' then c1.branch_cd
	        when @StatusId = 'SUBBROKER' then c1.sub_broker
	        when @StatusId = 'Trader' then c1.Trader
	        when @StatusId = 'Family' then c1.Family
	        when @StatusId = 'Area' then c1.Area
	        when @StatusId = 'Region' then c1.Region
	        when @StatusId = 'Client' then c2.party_code
	  else 
	        'BROKER'
	  End)   
Group by d.CertNo,d.party_code,c1.short_name ,d.Sett_No, d.Sett_type,d.scrip_cd,d.series, d.SlipNo,d.Delivered,     
D.ISett_No,D.ISett_Type,BDpId,BCltDpId,Convert(Varchar,TransDate,103)     
order by d.scrip_cd, d.series,d.party_code, d.Sett_No, d.Sett_type, Convert(Varchar,TransDate,103)    
End

GO
