-- Object: PROCEDURE dbo.CltShortDetls
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.CltShortDetls    Script Date: 3/17/01 9:55:49 PM ******/

/****** Object:  Stored Procedure dbo.CltShortDetls    Script Date: 3/21/01 12:50:04 PM ******/

/****** Object:  Stored Procedure dbo.CltShortDetls    Script Date: 20-Mar-01 11:38:47 PM ******/

/****** Object:  Stored Procedure dbo.CltShortDetls    Script Date: 2/5/01 12:06:10 PM ******/

/****** Object:  Stored Procedure dbo.CltShortDetls    Script Date: 12/27/00 8:58:47 PM ******/

Create Procedure CltShortDetls ( @SettNo varchar(7), @SettType varchar(2),@scrip_cd Varchar(12)) As
select * from deliveryclt where party_code not in ( select d.party_code from deliveryclt d, certinfo c 
where d.sett_no = @SettNo and d.sett_Type = @SettType and d.inout = 'o' and d.scrip_cd like @Scrip_Cd
and d.sett_no = c.sett_no and d.sett_Type = c.sett_type and d.scrip_Cd = c.scrip_cd and c.targetparty = d.party_code
group by d.party_code,d.qty,c.targetparty,d.scrip_Cd
having sum(c.qty) = d.qty ) 
and sett_no = @SettNo and sett_Type = @SettType
and inout = 'O' and scrip_cd like @SCrip_Cd
Order by Party_code

GO
