-- Object: PROCEDURE dbo.ANGEL_LEVIES_DATA
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROC ANGEL_LEVIES_DATA
AS

select cl_code,'PRO CLIENT                     ' AS CL INTO #T from client_details (nolock) where cl_type = 'pro' 

INSERT INTO #T select ' ',' '

INSERT INTO #T
Select a.Cl_code as BSE,'BSE WRONG LEVIES CODE' as LEVIES  from Client_Brok_details a inner join Client_details b on a.Cl_code = b.Cl_code
where Exchange = 'BSE' and Segment = 'CAPITAL' and b.Cl_type <> 'INS'  and Inactive_from > getdate()
and ( a.Ser_tax <> 0 or a.Trd_STT <> 0.025 or a.Del_STT <> 0.125 or a.Trd_Sebi_Fees <> 0 or a.Del_Sebi_Fees <> 0
or a.Trd_Tran_Chrgs <> 0.0035  or a.Del_Tran_Chrgs <> 0.0035 or a.Trd_Stamp_Duty <> 0.002 or a.Del_Stamp_Duty <> 0.01
or a.Trd_Other_Chrgs <> 0 or a.Del_Other_Chrgs <> 0 or Round_To_Digit <> 4)


INSERT INTO #T select ' ',' '

INSERT INTO #T
Select a.Cl_code as NSE,'NSE WRONG LEVIES CODE' as LEVIES from Client_Brok_details a inner join Client_details b on a.Cl_code = b.Cl_code
where Exchange = 'NSE' and Segment = 'CAPITAL' and b.Cl_type <> 'INS' and Inactive_from > getdate()  and 
( a.Ser_tax <> 0 or a.Trd_STT <> 0.025 or a.Del_STT <> 0.125 or a.Trd_Sebi_Fees <> 0.0002 or a.Del_Sebi_Fees <> 0.0002
or a.Trd_Tran_Chrgs <> 0.0035  or a.Del_Tran_Chrgs <> 0.0035 or a.Trd_Stamp_Duty <> 0.002 or a.Del_Stamp_Duty <> 0.01
or a.Trd_Other_Chrgs <> 0 or a.Del_Other_Chrgs <> 0 or Round_To_Digit <> 4)

SELECT * FROM #T

GO
