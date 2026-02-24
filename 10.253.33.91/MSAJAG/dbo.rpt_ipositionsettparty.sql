-- Object: PROCEDURE dbo.rpt_ipositionsettparty
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_ipositionsettparty    Script Date: 04/27/2001 4:32:43 PM ******/

/****** Object:  Stored Procedure dbo.rpt_ipositionsettparty    Script Date: 3/21/01 12:50:18 PM ******/

/****** Object:  Stored Procedure dbo.rpt_ipositionsettparty    Script Date: 20-Mar-01 11:38:59 PM ******/

/****** Object:  Stored Procedure dbo.rpt_ipositionsettparty    Script Date: 2/5/01 12:06:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_ipositionsettparty    Script Date: 12/27/00 8:59:12 PM ******/

/*isettlement trading*/
/* report : position report 
   file : clientposition.asp */
/* displays list of party codes who have  traded in a particular settlement */
CREATE PROCEDURE rpt_ipositionsettparty
@statusid varchar(15),
@statusname varchar(25),
@partycode varchar(6),
@partyname varchar(21),
@settno varchar(7),
@settype varchar(3),
@trader varchar(15),
@scripcd varchar(12),
@pcode varchar(15)
AS
if @statusid = "broker" 
begin
select distinct s.party_code,c1.short_Name,s.sett_no,s.sett_type from 
isettlement s,client1 c1, client2 c2 
where s.party_code = c2.party_code and 
c1.Cl_code= c2.cl_code and s.party_code like ltrim(@partycode)+'%' and c1.short_name like ltrim(@partyname)+'%' 
and s.sett_no like ltrim(@settno)+'%' and s.sett_type like ltrim(@settype)+'%' and c1.trader like ltrim(@trader)+'%' 
and s.scrip_cd like ltrim(@scripcd)+'%'
and partipantcode like ltrim(@pcode)+'%'
order by c1.short_name,s.party_code,s.sett_no,s.sett_type 
end
if @statusid = "branch" 
begin
select distinct s.party_code,c1.short_Name,s.sett_no,s.sett_type 
from isettlement s,client1 c1, client2 c2 , branches b
where s.party_code = c2.party_code and c1.Cl_code= c2.cl_code and 
s.party_code like ltrim(@partycode)+'%' and c1.short_name like ltrim(@partyname)+'%' and 
s.sett_no like ltrim(@settno)+'%' and s.sett_type like ltrim(@settype)+'%' and 
c1.trader like ltrim(@trader)+'%' and s.scrip_cd like ltrim(@scripcd)+'%' and
b.branch_cd=@statusname and b.short_name=c1.trader  
and partipantcode like ltrim(@pcode)+'%'
order by c1.short_name,s.party_code,s.sett_no,s.sett_type 
end
if @statusid = "trader" 
begin
select distinct s.party_code,c1.short_Name,s.sett_no,s.sett_type from 
isettlement s,client1 c1, client2 c2 
where s.party_code = c2.party_code and 
c1.Cl_code= c2.cl_code and s.party_code like ltrim(@partycode)+'%' and c1.short_name like ltrim(@partyname)+'%' 
and s.sett_no like ltrim(@settno)+'%' and s.sett_type like ltrim(@settype)+'%' and c1.trader = @statusname
and s.scrip_cd like ltrim(@scripcd)+'%'
and partipantcode like ltrim(@pcode)+'%'
order by c1.short_name,s.party_code,s.sett_no,s.sett_type 
end 
if @statusid = "subbroker" 
begin
select distinct s.party_code,c1.short_Name,s.sett_no,s.sett_type 
from isettlement s,client1 c1, client2 c2 , subbrokers sb
where s.party_code = c2.party_code and c1.Cl_code= c2.cl_code and 
s.party_code like ltrim(@partycode)+'%' and c1.short_name like ltrim(@partyname)+'%' and 
s.sett_no like ltrim(@settno)+'%' and s.sett_type like ltrim(@settype)+'%' and 
c1.trader like ltrim(@trader)+'%' and s.scrip_cd like ltrim(@scripcd)+'%' and
sb.sub_broker=@statusname and sb.sub_broker=c1.sub_broker  
and partipantcode like ltrim(@pcode)+'%' 
order by c1.short_name,s.party_code,s.sett_no,s.sett_type 
end 
if @statusid = "client"
begin
select distinct s.party_code,c1.short_Name,s.sett_no,s.sett_type 
from isettlement s,client1 c1, client2 c2 
where s.party_code = c2.party_code and c1.Cl_code= c2.cl_code and 
s.party_code =@statusname  and 
s.sett_no like ltrim(@settno)+'%' and s.sett_type like  ltrim(@settype)+'%' 
and s.scrip_cd like  ltrim(@scripcd)+'%' 
and partipantcode like ltrim(@pcode)+'%'
order by c1.short_name,s.party_code,s.sett_no,s.sett_type 
end

GO
