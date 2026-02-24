-- Object: PROCEDURE dbo.rpt_settwise
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.rpt_settwise    Script Date: 04/27/2001 4:32:50 PM ******/

/****** Object:  Stored Procedure dbo.rpt_settwise    Script Date: 3/21/01 12:50:23 PM ******/

/****** Object:  Stored Procedure dbo.rpt_settwise    Script Date: 20-Mar-01 11:39:03 PM ******/

/****** Object:  Stored Procedure dbo.rpt_settwise    Script Date: 2/5/01 12:06:23 PM ******/

/****** Object:  Stored Procedure dbo.rpt_settwise    Script Date: 12/27/00 8:58:58 PM ******/

/* report : subbroker turnover
   file :settwise.asp
*/
/*select  settlement numbers in which trading is done by clients of a particular subbroker
*/
CREATE PROCEDURE rpt_settwise
@subbroker varchar(50),
@settype varchar(3)
AS
select distinct s.sett_no, end_date from settlement s, subbrokers sb, client1 c1, client2 c2, sett_mst st
where s.party_code=c2.party_code and c2.cl_code=c1.cl_code and
c1.sub_broker=sb.sub_broker and sb.sub_broker=@subbroker
and s.sett_type=@settype
and s.sett_no=st.sett_no and s.sett_type=st.sett_type
union
select distinct s.sett_no , end_date from history s, subbrokers sb, client1 c1, client2 c2, sett_mst st
where s.party_code=c2.party_code and c2.cl_code=c1.cl_code and
c1.sub_broker=sb.sub_broker and sb.sub_broker=@subbroker
and s.sett_type=@settype
and s.sett_no=st.sett_no and s.sett_type=st.sett_type
order by end_date desc

GO
