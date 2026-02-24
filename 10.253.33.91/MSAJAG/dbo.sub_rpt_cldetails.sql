-- Object: PROCEDURE dbo.sub_rpt_cldetails
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.sub_rpt_cldetails    Script Date: 3/17/01 9:56:12 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_cldetails    Script Date: 3/21/01 12:50:32 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_cldetails    Script Date: 20-Mar-01 11:39:10 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_cldetails    Script Date: 2/5/01 12:06:29 PM ******/

/****** Object:  Stored Procedure dbo.sub_rpt_cldetails    Script Date: 12/27/00 8:59:17 PM ******/




/* report bill report
   file walbmbill.asp
  finds details of party
*/
	
CREATE PROCEDURE sub_rpt_cldetails
@membercode varchar(15),
@settno varchar(7)
AS
select h.BillNo,h.PartipantCode,
h.NSerTax,st.start_date,st.end_date,h.sett_type, h.sett_no
from trdbackup h,multibroker m,sett_mst st 
where h.partipantcode=@membercode and h.sett_no=@settno 
and st.sett_no=h.sett_no and
st.sett_type=h.sett_type
and m.cltcode = h.partipantcode

GO
