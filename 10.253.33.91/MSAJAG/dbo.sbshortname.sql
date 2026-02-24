-- Object: PROCEDURE dbo.sbshortname
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sbshortname    Script Date: 3/17/01 9:56:09 PM ******/

/****** Object:  Stored Procedure dbo.sbshortname    Script Date: 3/21/01 12:50:28 PM ******/

/****** Object:  Stored Procedure dbo.sbshortname    Script Date: 20-Mar-01 11:39:07 PM ******/

/****** Object:  Stored Procedure dbo.sbshortname    Script Date: 2/5/01 12:06:26 PM ******/

/****** Object:  Stored Procedure dbo.sbshortname    Script Date: 12/27/00 8:59:01 PM ******/

/*** file :positionreport.asp
     report :client position 
displays details of asettlement for a particular client
**/
/* displays total buy and sell (qty and amt) of a particular subbroker till today */
CREATE PROCEDURE sbshortname
@subbroker varchar (15)
 AS
select distinct s.party_code,c1.short_name,s.sett_no,s.sett_type,sb.sub_broker
from Settlement s, client1 c1,client2 c2, sett_mst st,subbrokers sb where
c1.cl_code = c2.cl_code and c2.party_code = s.party_code and 
start_date <= getdate() and end_date >= getdate() and 
c1.sub_broker=sb.sub_broker and sb.sub_broker =@subbroker and s.sett_no = st.sett_no and s.sett_Type = st.sett_type
order by c1.short_name , s.party_code

GO
