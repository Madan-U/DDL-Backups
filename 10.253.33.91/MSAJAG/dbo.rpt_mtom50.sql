-- Object: PROCEDURE dbo.rpt_mtom50
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_mtom50    Script Date: 04/27/2001 4:32:45 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtom50    Script Date: 3/21/01 12:50:20 PM ******/

/****** Object:  Stored Procedure dbo.rpt_mtom50    Script Date: 20-Mar-01 11:39:00 PM ******/

/* report : newmtom
   file : mtom50
	changed by bhushan ghorpade added the exposure limit according to the limit
	Date 6 march 2001
*/
CREATE PROCEDURE rpt_mtom50
@statusid varchar(15),
@statusname varchar(25),
@selval varchar(6)
AS
if @statusid='broker' 
begin
select m.party_code, m.short_name, m.clsdiff, m.grossamt 
from tblmtomdetail m,client2 c2, client1 c1  
where m.party_code=c2.party_code  and c2.cl_code =c1.cl_code 
and (m.clsdiff < (@selval * convert(float,
                IsNull((Select (Margin*NoOfTimes) from Client3 Where Client3.Cl_Code = C2.Cl_code 
                and Client3.Party_code = C2.Party_code and markettype = 'CAPITAL' and Exchange = 'NSE'),
                c2.exposure_lim))))
and c2.exposure_lim <> 0  
order by m.clsdiff
end
if @statusid='branch' 
begin
select m.party_code, m.short_name, m.clsdiff, m.grossamt 
from tblmtomdetail m,client2 c2, client1 c1  , branches b
where m.party_code=c2.party_code  and c2.cl_code =c1.cl_code 
and (m.clsdiff < (@selval * convert(float,
                IsNull((Select (Margin*NoOfTimes) from Client3 Where Client3.Cl_Code = C2.Cl_code 
                and Client3.Party_code = C2.Party_code and markettype = 'CAPITAL' and Exchange = 'NSE'),
                c2.exposure_lim))))
and c2.exposure_lim <> 0  
and b.branch_cd=@statusname and b.short_name=c1.trader
order by m.clsdiff
end
if @statusid='subbroker' 
begin
select m.party_code, m.short_name, m.clsdiff, m.grossamt 
from tblmtomdetail m,client2 c2, client1 c1  , subbrokers sb
where m.party_code=c2.party_code  and c2.cl_code =c1.cl_code 
and (m.clsdiff < (@selval * convert(float,
                IsNull((Select (Margin*NoOfTimes) from Client3 Where Client3.Cl_Code = C2.Cl_code 
                and Client3.Party_code = C2.Party_code and markettype = 'CAPITAL' and Exchange = 'NSE'),
                c2.exposure_lim))))
and c2.exposure_lim <> 0  
and sb.sub_broker=@statusname and sb.sub_broker=c1.sub_broker
order by m.clsdiff
end
if @statusid='trader' 
begin
select m.party_code, m.short_name, m.clsdiff, m.grossamt 
from tblmtomdetail m,client2 c2, client1 c1
where m.party_code=c2.party_code  and c2.cl_code =c1.cl_code 
and (m.clsdiff < (@selval * convert(float,
                IsNull((Select (Margin*NoOfTimes) from Client3 Where Client3.Cl_Code = C2.Cl_code 
                and Client3.Party_code = C2.Party_code and markettype = 'CAPITAL' and Exchange = 'NSE'),
                c2.exposure_lim))))
and c2.exposure_lim <> 0  
and c1.trader=@statusname
order by m.clsdiff
end
if @statusid='client' 
begin
select m.party_code, m.short_name, m.clsdiff, m.grossamt 
from tblmtomdetail m,client2 c2, client1 c1  
where m.party_code=c2.party_code  and c2.cl_code =c1.cl_code 
and (m.clsdiff < (@selval * convert(float,
                IsNull((Select (Margin*NoOfTimes) from Client3 Where Client3.Cl_Code = C2.Cl_code 
                and Client3.Party_code = C2.Party_code and markettype = 'CAPITAL' and Exchange = 'NSE'),
                c2.exposure_lim))))
and c2.exposure_lim <> 0  
and m.party_code=@statusname
order by m.clsdiff
end

GO
