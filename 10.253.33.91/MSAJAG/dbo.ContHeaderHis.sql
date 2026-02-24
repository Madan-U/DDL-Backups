-- Object: PROCEDURE dbo.ContHeaderHis
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.ContHeaderHis    Script Date: 3/17/01 9:55:49 PM ******/

/****** Object:  Stored Procedure dbo.ContHeaderHis    Script Date: 3/21/01 12:50:05 PM ******/

/****** Object:  Stored Procedure dbo.ContHeaderHis    Script Date: 20-Mar-01 11:38:48 PM ******/

/****** Object:  Stored Procedure dbo.ContHeaderHis    Script Date: 2/5/01 12:06:11 PM ******/

/****** Object:  Stored Procedure dbo.ContHeaderHis    Script Date: 12/27/00 8:58:48 PM ******/

CREATE proc ContHeaderHis (@Sdate varchar(12), @Sett_Type varchar(2), @ContNo varchar(6)) as
select distinct history.party_code,Partyname = client1.short_name,history.billno,history.contractno,sett_mst.sett_no,sett_mst.sett_type, 
sett_mst.start_date,sett_mst.end_date,client1.l_address1,client1.l_address2,client1.l_address3,client1.l_city,client1.l_zip,history.sauda_date
from history, client1,client2, sett_mst
where client1.cl_code = client2.cl_code 
and client2.party_code = client2.party_code
and history.party_code = client2.party_code
and history.sett_type = sett_mst.sett_Type
/* and history.sett_no = sett_mst.sett_no */
and history.sett_type = @sett_type
and convert(int,history.contractno) = @ContNo
and history.sauda_date LIKE @SDATE + '%'
and sett_mst.start_date <=HISTORY.SAUDA_DATE
and sett_mst.end_date >=  HISTORY.SAUDA_DATE
and history.tradeqty <> 0 and history.party_code not in ('30','40')

GO
