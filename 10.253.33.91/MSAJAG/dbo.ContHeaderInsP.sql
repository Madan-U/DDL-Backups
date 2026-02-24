-- Object: PROCEDURE dbo.ContHeaderInsP
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.ContHeaderInsP    Script Date: 3/17/01 9:55:49 PM ******/

/****** Object:  Stored Procedure dbo.ContHeaderInsP    Script Date: 3/21/01 12:50:05 PM ******/

/****** Object:  Stored Procedure dbo.ContHeaderInsP    Script Date: 20-Mar-01 11:38:48 PM ******/

/****** Object:  Stored Procedure dbo.ContHeaderInsP    Script Date: 2/5/01 12:06:11 PM ******/

/****** Object:  Stored Procedure dbo.ContHeaderInsP    Script Date: 12/27/00 8:59:06 PM ******/

CREATE proc ContHeaderInsP (@Sdate varchar(12), @Sett_Type varchar(2), @ContNo varchar(6),@flag smallint) as
if @flag = 1
begin
 select distinct isettlement.party_code,Partyname = client1.short_name,isettlement.billno,isettlement.contractno,sett_mst.sett_no,sett_mst.sett_type, 
 sett_mst.start_date,sett_mst.end_date,client1.l_address1,client1.l_address2,client1.l_address3,client1.l_city,client1.l_zip,isettlement.sauda_date
 from isettlement, client1,client2, sett_mst
 where client1.cl_code = client2.cl_code 
 and client2.party_code = client2.party_code
 and isettlement.party_code = client2.party_code
 and isettlement.sett_type = @SETT_TYPE
 /*and isettlement.sett_no = sett_mst.sett_no */
 and isettlement.sett_Type = sett_mst.sett_Type
 and convert(int,isettlement.contractno) = @CONTNO
 and isettlement.sauda_datE LIKE @SDATE + '%'
 and sett_mst.start_date <= isettlement.SAUDA_DATE
 and sett_mst.end_date >=  isettlement.SAUDA_DATE
 and isettlement.tradeqty <> 0 and client2.printf = 0
end 
if @flag =2
begin
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
 and history.tradeqty <> 0  and client2.printf = 0
end

GO
