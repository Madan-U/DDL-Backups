-- Object: PROCEDURE dbo.rpt_NSEDelScripClients
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

-- sp_helptext Rpt_NseDelScripClients    
    
CREATE PROCEDURE rpt_NSEDelScripClients    
@StatusId Varchar(15),@StatusName Varchar(25),    
@dematid varchar(2),    
@settno varchar(7),    
@settype varchar(3),    
@scripcd varchar(20),    
@series varchar(3)    
AS    
   
select d.sett_no,d.sett_type,d.party_code,c1.short_name,d.Scrip_cd,d.Series,d.inout,d.Qty,    
RecQty = (Case When D.Sett_Type ='W' Then     
   (Case When InOut ='I' Then Sum((Case When DrCr = 'C' Then IsNull(De.Qty,0) Else 0 End)) Else 0 End)    
   Else Sum((Case When DrCr = 'C' Then IsNull(De.Qty,0) Else 0 End)) End),    
GivenQty = (Case When D.Sett_Type ='W' Then     
   (Case When InOut ='O' Then Sum((Case When DrCr = 'D' Then IsNull(De.Qty,0) Else 0 End)) Else 0 End)    
   Else Sum((Case When DrCr = 'D' Then IsNull(De.Qty,0) Else 0 End)) End)    
from client1 c1,client2 c2, deliveryclt d Left Outer Join DelTrans De    
On ( De.Sett_no = D.Sett_No And D.sett_Type = De.SetT_Type and D.Scrip_CD = De.Scrip_CD    
And De.Party_Code = D.Party_Code And De.Filler2 = 1 And De.Series = D.Series )     
 where  D.party_code = c2.party_code and c1.cl_code =c2.cl_code    
 and d.sett_no = @settno and d.sett_type = @settype and d.scrip_cd like @scripcd     
 and d.series like @series     
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
 group by d.sett_no,d.sett_type,d.scrip_cd,d.series,c1.short_name,d.party_code,d.inout,D.Qty    
Union All    
select d.sett_no,d.sett_type,d.party_code,c1.short_name,d.Scrip_cd,d.Series,inout='I',Qty=0,    
RecQty = Sum((Case When DrCr = 'C' Then IsNull(D.Qty,0) Else 0 End)),    
GivenQty = Sum((Case When DrCr = 'D' Then IsNull(D.Qty,0) Else 0 End))    
from client1 c1,client2 c2,DelTrans D    
where  D.party_code = c2.party_code and c1.cl_code =c2.cl_code    
and d.sett_no = @settno and d.sett_type = @settype and d.scrip_cd like @scripcd     
and d.series like @series And Filler2 = 1    
And d.Party_code Not In ( Select Party_Code From DeliveryClt De Where De.Sett_no = D.Sett_No And D.sett_Type = De.SetT_Type and D.Scrip_CD = De.Scrip_CD    
And De.Party_Code = D.Party_Code And De.Series = D.Series )  
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
group by d.sett_no,d.sett_type,d.scrip_cd,d.series,c1.short_name,d.party_code    
order by d.sett_no,d.sett_type,D.scrip_cd,d.series,c1.short_name,d.party_code

GO
