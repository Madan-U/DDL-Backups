-- Object: PROCEDURE dbo.rpt_sbclients
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_sbclients    Script Date: 04/27/2001 4:32:48 PM ******/

/****** Object:  Stored Procedure dbo.rpt_sbclients    Script Date: 3/21/01 12:50:23 PM ******/

/****** Object:  Stored Procedure dbo.rpt_sbclients    Script Date: 20-Mar-01 11:39:02 PM ******/

/****** Object:  Stored Procedure dbo.rpt_sbclients    Script Date: 2/5/01 12:06:22 PM ******/

/****** Object:  Stored Procedure dbo.rpt_sbclients    Script Date: 12/27/00 8:58:57 PM ******/

/* report : sbbroksett.asp
   file : clientlist.asp
*/
/* displays list of clients who have done trading from settlement and history */
CREATE PROCEDURE rpt_sbclients
@statusname varchar(15),
@settno varchar(7),
@settype varchar(3)
AS
select c2.party_code,c1.short_name from client1 c1, client2 c2 , subbrokers sb, settlement s where
c2.cl_code=c1.cl_code and c1.sub_broker=sb.sub_broker and 
sb.sub_broker=@statusname and s.party_code=c2.party_code
and s.sett_no=@settno and s.sett_type=@settype
union
select c2.party_code,c1.short_name from client1 c1, client2 c2 , subbrokers sb, history s  where
c2.cl_code=c1.cl_code and c1.sub_broker=sb.sub_broker and sb.sub_broker=@statusname and s.party_code=c2.party_code
and s.sett_no=@settno and s.sett_type=@settype
order by c2.party_code

GO
