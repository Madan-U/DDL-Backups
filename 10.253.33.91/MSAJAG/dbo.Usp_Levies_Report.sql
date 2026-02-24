-- Object: PROCEDURE dbo.Usp_Levies_Report
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE Proc Usp_Levies_Report  
as  
  
Select Cl_code,Branch_cd from Client_details where cl_type = 'PRO'  
order by Branch_cd  
  
Select a.Cl_code,'BSE' as Segment from Client_Brok_details a inner join Client_details b on a.Cl_code = b.Cl_code  
where Exchange = 'BSE' and Segment = 'CAPITAL' and b.Cl_type <> 'INS'  and Inactive_from > getdate()and   
( a.Ser_tax <> 0 or a.Trd_STT <> 0.025 or a.Del_STT <> 0.125 or a.Trd_Sebi_Fees <> 0.0001 or a.Del_Sebi_Fees <> 0.0001  
or a.Trd_Tran_Chrgs <> 0.0035  or a.Del_Tran_Chrgs <> 0.0035 or a.Trd_Stamp_Duty <> 0.002 or a.Del_Stamp_Duty <> 0.01  
or a.Trd_Other_Chrgs <> 0 or a.Del_Other_Chrgs <> 0 or Round_To_Digit <> 4)  
union all  
Select a.Cl_code,'NSE' as Segment from Client_Brok_details a inner join Client_details b on a.Cl_code = b.Cl_code  
where Exchange = 'NSE' and Segment = 'CAPITAL' and b.Cl_type <> 'INS' and Inactive_from > getdate()  and   
( a.Ser_tax <> 0 or a.Trd_STT <> 0.025 or a.Del_STT <> 0.125 or a.Trd_Sebi_Fees <> 0.0001 or a.Del_Sebi_Fees <> 0.0001  
or a.Trd_Tran_Chrgs <> 0.0035  or a.Del_Tran_Chrgs <> 0.0035 or a.Trd_Stamp_Duty <> 0.002 or a.Del_Stamp_Duty <> 0.01  
or a.Trd_Other_Chrgs <> 0 or a.Del_Other_Chrgs <> 0 or Round_To_Digit <> 4)  
union all  
Select Cl_code,'NSEFO' as Segment from Client_Brok_details   
where Exchange = 'NSE'   
and Segment = 'Futures'  and Inactive_from > getdate() and ( Ser_tax <> 0 or Fut_stt <> 1 or Fut_Sebi_Fees <> 1   
or Fut_Tran_Chrgs <> 1 or Fut_Stamp_Duty <> 1 or Fut_Other_Chrgs <> 0)  
order by Segment

GO
