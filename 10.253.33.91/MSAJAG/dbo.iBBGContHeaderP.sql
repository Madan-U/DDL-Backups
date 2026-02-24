-- Object: PROCEDURE dbo.iBBGContHeaderP
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE proc iBBGContHeaderP (@Sdate varchar(12), @Sett_Type varchar(2), @ContNo varchar(6),@flag smallint,@Sett_no Varchar(10),@Party_code Varchar(15)) as
if @flag = 1
begin
	 select distinct isettlement.party_code,Partyname = client1.short_name,isettlement.billno,isettlement.contractno,sett_mst.sett_no,sett_mst.sett_type, 
	 convert(varchar,sett_mst.start_date,103) as start_date ,convert(varchar,sett_mst.end_date,103) as end_date,client1.l_address1,
	 client1.l_address2,client1.l_address3,client1.l_city,client1.l_zip,convert(varchar,isettlement.sauda_date,103) as sauda_date ,client1.email
	 from isettlement, client1,client2, sett_mst
	 where client1.cl_code = client2.cl_code 
	 and client2.party_code = client2.party_code
	 and isettlement.party_code = client2.party_code
	 and isettlement.sett_type = @SETT_TYPE
	 and isettlement.sett_no = sett_mst.sett_no
	 and isettlement.sett_Type = sett_mst.sett_Type
	 and convert(int,isettlement.contractno) = @CONTNO
	 and isettlement.sauda_datE LIKE @SDATE + '%'
	 and sett_mst.start_date <= isettlement.SAUDA_DATE
	 and sett_mst.end_date >=  isettlement.SAUDA_DATE
	 And isettlement.Sett_no = @Sett_no
	 And isettlement.Party_code = @Party_code
	 and isettlement.tradeqty <> 0 and client2.printf = 0
end

GO
