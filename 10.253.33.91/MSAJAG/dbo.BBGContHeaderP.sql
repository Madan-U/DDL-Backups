-- Object: PROCEDURE dbo.BBGContHeaderP
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE proc BBGContHeaderP (@Sdate varchar(12), @Sett_Type varchar(2), @ContNo varchar(6),@flag smallint,@Sett_no Varchar(10),@Party_code Varchar(15)) as
if @flag = 1
begin
 select distinct settlement.party_code,Partyname = client1.short_name,settlement.billno,settlement.contractno,sett_mst.sett_no,sett_mst.sett_type, 
 convert(varchar,sett_mst.start_date,103) as start_date ,convert(varchar,sett_mst.end_date,103) as end_date,client1.l_address1,
client1.l_address2,client1.l_address3,client1.l_city,client1.l_zip,convert(varchar,settlement.sauda_date,103) as sauda_date ,client1.email,client1.pan_gir_no
 from settlement, client1,client2, sett_mst
 where client1.cl_code = client2.cl_code 
 and client2.party_code = client2.party_code
 and settlement.party_code = client2.party_code
 and settlement.sett_type = @SETT_TYPE
and settlement.sett_no = sett_mst.sett_no
 and settlement.sett_Type = sett_mst.sett_Type
 and convert(int,settlement.contractno) = @CONTNO
 and settlement.sauda_datE LIKE @SDATE + '%'
 and sett_mst.start_date <= SETTLEMENT.SAUDA_DATE
 and sett_mst.end_date >=  SETTLEMENT.SAUDA_DATE
 And Settlement.Sett_no = @Sett_no
 And Settlement.Party_code = @Party_code
 and settlement.tradeqty <> 0 and client2.printf = 0
end 
if @flag =2
begin
 select distinct history.party_code,Partyname = client1.short_name,history.billno,history.contractno,sett_mst.sett_no,sett_mst.sett_type, 
 convert(varchar,sett_mst.start_date,103) as start_date,convert(varchar,sett_mst.end_date,103) as end_date,client1.l_address1,client1.l_address2,
client1.l_address3,client1.l_city,client1.l_zip,convert(varchar,history.sauda_date,103) as sauda_date,client1.email,client1.pan_gir_no
 from history, client1,client2, sett_mst
 where client1.cl_code = client2.cl_code 
 and client2.party_code = client2.party_code
 and history.party_code = client2.party_code
 and history.sett_type = sett_mst.sett_Type
 and history.sett_no = sett_mst.sett_no
 and history.sett_type = @sett_type
 and convert(int,history.contractno) = @ContNo
 and history.sauda_date LIKE @SDATE + '%'
 and sett_mst.start_date <=HISTORY.SAUDA_DATE
 and sett_mst.end_date >=  HISTORY.SAUDA_DATE
 and history.tradeqty <> 0  and client2.printf = 0
 And History.Sett_no = @Sett_no
 And History.Party_code = @Party_code

end

GO
