-- Object: PROCEDURE dbo.rpt_isetttypewise
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_isetttypewise    Script Date: 04/27/2001 4:32:44 PM ******/

/****** Object:  Stored Procedure dbo.rpt_isetttypewise    Script Date: 3/21/01 12:50:19 PM ******/

/****** Object:  Stored Procedure dbo.rpt_isetttypewise    Script Date: 20-Mar-01 11:38:59 PM ******/

/****** Object:  Stored Procedure dbo.rpt_isetttypewise    Script Date: 2/5/01 12:06:20 PM ******/

/****** Object:  Stored Procedure dbo.rpt_isetttypewise    Script Date: 12/27/00 8:59:12 PM ******/

/* report : sbbroksett  
   file : settwise.asp
*/
/* displays settlement types of settlement in which a particular subbroker has done trading */
CREATE PROCEDURE rpt_isetttypewise
@subbroker varchar(50)
AS
select distinct sett_type from isettlement s, subbrokers sb, client1 c1, client2 c2
where s.party_code=c2.party_code and c2.cl_code=c1.cl_code and
c1.sub_broker=sb.sub_broker and sb.sub_broker=@subbroker
union
select distinct sett_type from ihistory s, subbrokers sb, client1 c1, client2 c2
where s.party_code=c2.party_code and c2.cl_code=c1.cl_code and
c1.sub_broker=sb.sub_broker and sb.sub_broker=@subbroker
order by sett_type

GO
