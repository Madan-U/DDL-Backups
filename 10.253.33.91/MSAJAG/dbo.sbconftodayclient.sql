-- Object: PROCEDURE dbo.sbconftodayclient
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbconftodayclient    Script Date: 3/17/01 9:56:06 PM ******/

/****** Object:  Stored Procedure dbo.sbconftodayclient    Script Date: 3/21/01 12:50:25 PM ******/

/****** Object:  Stored Procedure dbo.sbconftodayclient    Script Date: 20-Mar-01 11:39:05 PM ******/

/****** Object:  Stored Procedure dbo.sbconftodayclient    Script Date: 2/5/01 12:06:24 PM ******/

/****** Object:  Stored Procedure dbo.sbconftodayclient    Script Date: 12/27/00 8:58:59 PM ******/

/* report Confirmation
     File : Confirmationclients.asp
displays list of clients who have done trading today*/
CREATE PROCEDURE sbconftodayclient
@partycode varchar(10),
@subbroker varchar(15),
@name1 varchar(21),
@saudadate varchar(10)
AS
select distinct t.party_code,c1.short_name,c1.Cl_Code from Trade t, client1 c1,client2 c2 , subbrokers sb
where c1.cl_code = c2.cl_code and c2.party_code = t.party_code and t.party_code like ltrim(@partycode)+'%' 
and sb.sub_broker=c1.sub_broker and sb.sub_broker=@subbroker
and c1.short_name like ltrim(@name1) + '%' and convert(varchar,t.sauda_date,101)like ltrim(@saudadate) + '%'
union all 
select distinct s.party_code,c1.short_name,c1.Cl_Code from settlement s, client1 c1,client2 c2, subbrokers sb
 where c1.cl_code = c2.cl_code and c2.party_code = s.party_code and s.party_code like ltrim(@partycode)+'%' 
and sb.sub_broker=c1.sub_broker and sb.sub_broker=@subbroker
and c1.short_name like ltrim(@name1)+'%' and  convert(varchar,s.sauda_date,101)like ltrim(@saudadate)+'%' 
order by c1.short_name,t.party_code

GO
