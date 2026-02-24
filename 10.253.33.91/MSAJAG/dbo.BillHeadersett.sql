-- Object: PROCEDURE dbo.BillHeadersett
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.BillHeadersett    Script Date: 3/17/01 9:55:44 PM ******/

/****** Object:  Stored Procedure dbo.BillHeadersett    Script Date: 3/21/01 12:50:00 PM ******/

/****** Object:  Stored Procedure dbo.BillHeadersett    Script Date: 20-Mar-01 11:38:43 PM ******/

/****** Object:  Stored Procedure dbo.BillHeadersett    Script Date: 2/5/01 12:06:07 PM ******/

/****** Object:  Stored Procedure dbo.BillHeadersett    Script Date: 12/27/00 8:58:43 PM ******/

/* created billheadersett  to minimise unions between data from sett and history */
/* BY bbg 28 Aug 2000 */
/* Used in control   PrintRepCtl */
/* to be tested for final incorporation by Amit */
CREATE proc BillHeadersett  (@Sett_No varchar(10), @Sett_Type varchar(2), @BillNo varchar(6)) as
select distinct settlement.party_code,client1.short_name,settlement.billno,settlement.contractno,settlement.sett_no,settlement.sett_type, 
sett_mst.start_date,sett_mst.end_date,client1.l_address1,client1.l_address2,client1.l_address3,client1.l_city,client1.l_zip
from settlement, client1,client2, sett_mst
where client1.cl_code = client2.cl_code 
and client2.party_code = client2.party_code
and settlement.party_code = client2.party_code
and settlement.sett_no = sett_mst.sett_no
and settlement.sett_type = sett_mst.sett_Type
and settlement.sett_no = @Sett_No
and settlement.sett_type = @Sett_Type
and settlement.billno = @BillNo

GO
