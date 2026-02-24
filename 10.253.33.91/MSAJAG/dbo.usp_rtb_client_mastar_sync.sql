-- Object: PROCEDURE dbo.usp_rtb_client_mastar_sync
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

create proc [dbo].[usp_rtb_client_mastar_sync]
(@date as date)
as begin

--usp_rtb_client_mastar_sync '2022-12-06'

 select distinct party_code into #party from [172.31.18.249].msajag.dbo.settlement where cast(sauda_date as date) >=@date
 Create index #part on #party(party_code)
   
 select  a.* into #cl1 from msajag.dbo.client1 a
 join (select p.Party_Code from #party p left join (select cl_code from  [172.31.18.249].msajag.dbo.client1 ) c
 on party_code=c.Cl_Code
 where c.Cl_Code is null)b
 on a.Cl_Code=b.Party_Code
 
 Insert into [172.31.18.249].msajag.dbo.client1
 Select * from #cl1

 print ('Print 1')
select  a.* into #cl2 from msajag.dbo.client2 a
 join (select p.Party_Code from #party p left join (select cl_code from  [172.31.18.249].msajag.dbo.client2 ) c
 on party_code=c.Cl_Code
 where c.Cl_Code is null)b
 on a.Cl_Code=b.Party_Code

 
 Insert into [172.31.18.249].msajag.dbo.client2
 Select * from #cl2

  print ('Print 2')

select  a.* into #cl3 from msajag.dbo.client3 a
 join (select p.Party_Code from #party p left join (select cl_code from  [172.31.18.249].msajag.dbo.client3 ) c
 on party_code=c.Cl_Code
 where c.Cl_Code is null)b
 on a.Cl_Code=b.Party_Code

 Insert into [172.31.18.249].msajag.dbo.client3
 Select * from #cl3

  print ('Print 3')

select  a.* into #cl5 from msajag.dbo.client5 a
 join (select p.Party_Code from #party p left join (select cl_code from  [172.31.18.249].msajag.dbo.client5 ) c
 on party_code=c.Cl_Code
 where c.Cl_Code is null)b
 on a.Cl_Code=b.Party_Code

 Insert into [172.31.18.249].msajag.dbo.client5
 Select * from #cl5
   print ('Print 5')

   Select * into #ac  from Account.dbo.acmast With(Nolock) where cltcode in (
 Select * from #party (Nolock) where party_code not in (select cltcode from [172.31.18.249].Account.dbo.acmast))

 Insert into [172.31.18.249].Account.dbo.acmast
 Select * from #ac

 print ('Print 6')


 

end

GO
