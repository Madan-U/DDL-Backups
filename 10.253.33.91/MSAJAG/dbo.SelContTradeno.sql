-- Object: PROCEDURE dbo.SelContTradeno
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

/*
Recent changes by vaishali on 5/1/2001 -- added partipant code.
*/
CREATE Proc SelContTradeno 
@Tdate varchar(10),
@ttradeno varchar(12), 
@tparty varchar(7), 
@tsett_type varchar(2),
@flag as smallint,
@memcode varchar(15),
@tmark varchar(1)
AS
	if @flag = 1
 	begin
   		select contractno from settlement 
   		where party_code = @tParty
          		and convert(varchar,sauda_date,3)= @TDate
          		and sett_type like @tsett_type
          		and billno = 0
          		and Partipantcode = @memcode
          		and Tmark like @tmark
  		order by contractno
 	end
	else if @flag = 2
 	begin 
  		select max(contractno) from settlement 
  		where convert(varchar,sauda_date,3)= @TDate
  		and sett_type like @tsett_type
 	end
	else if @flag = 3
 	begin
  		select trade_no from settlement where trade_no like @ttradeno
   		and convert(varchar,sauda_date,3)= @TDate
  		and sett_type like @tsett_type
 	end
	else if @flag = 4
 	begin
  		select isnull(max(contractno),0) from settlement where 
		convert(varchar,sauda_date,3)= @TDate
  		and sett_type like @tsett_type
 	end

GO
