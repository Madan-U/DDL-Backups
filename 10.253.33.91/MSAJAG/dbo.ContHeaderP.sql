-- Object: PROCEDURE dbo.ContHeaderP
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------








/****** Object:  Stored Procedure dbo.ContHeaderP    Script Date: 09/07/2001 11:08:52 PM ******/

/****** Object:  Stored Procedure dbo.ContHeaderP    Script Date: 7/1/01 2:26:22 PM ******/

/****** Object:  Stored Procedure dbo.ContHeaderP    Script Date: 06/26/2001 8:47:50 PM ******/

/****** Object:  Stored Procedure dbo.ContHeaderP    Script Date: 3/17/01 9:55:49 PM ******/

/****** Object:  Stored Procedure dbo.ContHeaderP    Script Date: 3/21/01 12:50:05 PM ******/

/****** Object:  Stored Procedure dbo.ContHeaderP    Script Date: 20-Mar-01 11:38:48 PM ******/

/****** Object:  Stored Procedure dbo.ContHeaderP    Script Date: 2/5/01 12:06:11 PM ******/

/****** Object:  Stored Procedure dbo.ContHeaderP    Script Date: 12/27/00 8:58:48 PM ******/

CREATE proc ContHeaderP (@Sdate varchar(12), @Sett_Type varchar(2), @ContNo varchar(6),@flag smallint) as
if @flag = 1
begin
 select distinct settlement.party_code,Partyname = client1.short_name,settlement.billno,settlement.contractno,sett_mst.sett_no,sett_mst.sett_type, 
 convert(varchar,sett_mst.start_date,103) as start_date ,convert(varchar,sett_mst.end_date,103) as end_date,client1.l_address1,
client1.l_address2,client1.l_address3,client1.l_city,client1.l_zip,convert(varchar,settlement.sauda_date,103) as sauda_date ,client1.email
 from settlement, client1,client2, sett_mst
 where client1.cl_code = client2.cl_code 
 and client2.party_code = client2.party_code
 and settlement.party_code = client2.party_code
 and settlement.sett_type = @SETT_TYPE
/*and settlement.sett_no = sett_mst.sett_no */
 and settlement.sett_Type = sett_mst.sett_Type
 and convert(int,settlement.contractno) = @CONTNO
 and settlement.sauda_datE LIKE @SDATE + '%'
 and sett_mst.start_date <= SETTLEMENT.SAUDA_DATE
 and sett_mst.end_date >=  SETTLEMENT.SAUDA_DATE
 and settlement.tradeqty <> 0 and client2.printf = 0
end 
if @flag =2
begin
 select distinct history.party_code,Partyname = client1.short_name,history.billno,history.contractno,sett_mst.sett_no,sett_mst.sett_type, 
 convert(varchar,sett_mst.start_date,103) as start_date,convert(varchar,sett_mst.end_date,103) as end_date,client1.l_address1,client1.l_address2,
client1.l_address3,client1.l_city,client1.l_zip,convert(varchar,history.sauda_date,103) as sauda_date,client1.email
 from history, client1,client2, sett_mst
 where client1.cl_code = client2.cl_code 
 and client2.party_code = client2.party_code
 and history.party_code = client2.party_code
 and history.sett_type = sett_mst.sett_Type
 /*and history.sett_no = sett_mst.sett_no*/
 and history.sett_type = @sett_type
 and convert(int,history.contractno) = @ContNo
 and history.sauda_date LIKE @SDATE + '%'
 and sett_mst.start_date <=HISTORY.SAUDA_DATE
 and sett_mst.end_date >=  HISTORY.SAUDA_DATE
 and history.tradeqty <> 0  and client2.printf = 0
end

GO
