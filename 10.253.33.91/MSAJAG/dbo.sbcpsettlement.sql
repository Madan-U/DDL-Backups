-- Object: PROCEDURE dbo.sbcpsettlement
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbcpsettlement    Script Date: 3/17/01 9:56:06 PM ******/

/****** Object:  Stored Procedure dbo.sbcpsettlement    Script Date: 3/21/01 12:50:25 PM ******/

/****** Object:  Stored Procedure dbo.sbcpsettlement    Script Date: 20-Mar-01 11:39:05 PM ******/

/****** Object:  Stored Procedure dbo.sbcpsettlement    Script Date: 2/5/01 12:06:24 PM ******/

/****** Object:  Stored Procedure dbo.sbcpsettlement    Script Date: 12/27/00 8:58:59 PM ******/

/***  file :clientposition.asp
 report :client position   **/
CREATE PROCEDURE sbcpsettlement
@subbroker varchar(15),
@partycode varchar (10),
@partyname varchar(21),
@settno varchar(7),
@settype varchar(3),
@scripname varchar(10)
 AS
select distinct s.party_code,c1.short_Name,s.sett_no,s.sett_type from settlement s,client1 c1, client2 c2 ,subbrokers sb
where s.party_code = c2.party_code and c1.Cl_code= c2.cl_code and c1.sub_broker=sb.sub_broker and sb.sub_broker=@subbroker  and
s.party_code like ltrim(@partycode)+ '%' and
 c1.short_name like ltrim(@partyname)+ '%' and s.sett_no = @settno and s.sett_type =@settype and 
s.scrip_cd like ltrim(@scripname)+ '%' 
order by c1.short_name,s.party_code,s.sett_no,s.sett_type

GO
