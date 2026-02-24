-- Object: PROCEDURE dbo.Rpt_finyearlist
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

Create Procedure  Rpt_finyearlist
As
Select Distinct  Smonth = Datename(Month, Sdtcur), Syear = Datename(Year, Sdtcur), Emonth = Datename(Month, Ldtcur), 
 Lyear = Datename(Year, Ldtcur) , Sdt = Convert(Varchar, Sdtcur, 103), 
Ldt = Convert(Varchar, Ldtcur, 103), Curyear From Account.Dbo.Parameter
Order By Curyear Desc

GO
