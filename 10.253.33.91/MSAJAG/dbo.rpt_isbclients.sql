-- Object: PROCEDURE dbo.rpt_isbclients
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_isbclients    Script Date: 04/27/2001 4:32:43 PM ******/

/****** Object:  Stored Procedure dbo.rpt_isbclients    Script Date: 3/21/01 12:50:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_isbclients    Script Date: 20-Mar-01 11:38:59 PM ******/

/****** Object:  Stored Procedure dbo.rpt_isbclients    Script Date: 2/5/01 12:06:20 PM ******/

/****** Object:  Stored Procedure dbo.rpt_isbclients    Script Date: 12/27/00 8:59:12 PM ******/

/* institutional trades */
/* report : sbbroksett.asp
   file : clientlist.asp
*/
/* displays list of clients who have done trading from settlement and history */
CREATE PROCEDURE rpt_isbclients
@statusname varchar(15),
@settno varchar(7),
@settype varchar(3),
@pcode varchar(15)
AS
select c2.party_code,c1.short_name from client1 c1, client2 c2 , subbrokers sb, isettlement s where
c2.cl_code=c1.cl_code and c1.sub_broker=sb.sub_broker and 
sb.sub_broker=@statusname and s.party_code=c2.party_code
and s.sett_no=@settno and s.sett_type=@settype
and s.partipantcode like (@pcode)+'%'
union
select c2.party_code,c1.short_name from client1 c1, client2 c2 , subbrokers sb, ihistory s  where
c2.cl_code=c1.cl_code and c1.sub_broker=sb.sub_broker and sb.sub_broker=@statusname and s.party_code=c2.party_code
and s.sett_no=@settno and s.sett_type=@settype
and s.partipantcode like (@pcode)+'%'
order by c2.party_code

GO
