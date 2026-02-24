-- Object: PROCEDURE dbo.Rpt_NSEDelClientList
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE Proc Rpt_NSEDelClientList (@StatusId Varchar(15),@StatusName Varchar(25),@SettNo varchar(7),@Sett_Type Varchar(2),@Party_Code Varchar(10) )  
as   
 select distinct d.party_code,c1.short_name from deliveryclt d,client1 c1,client2 c2    
 where d.party_code = c2.party_code and c1.cl_code = c2.cl_code   
 and d.sett_no like @settno and d.sett_type like @Sett_Type 
 and d.party_code like @Party_Code + '%'  
And @StatusName = 
	  (case 
	        when @StatusId = 'BRANCH' then c1.branch_cd
	        when @StatusId = 'SUBBROKER' then c1.sub_broker
	        when @StatusId = 'Trader' then c1.Trader
	        when @StatusId = 'Family' then c1.Family
	        when @StatusId = 'Area' then c1.Area
	        when @StatusId = 'Region' then c1.Region
	        when @StatusId = 'Client' then c2.party_code
	  else 
	        'BROKER'
	  End) 
 order by c1.short_name

GO
