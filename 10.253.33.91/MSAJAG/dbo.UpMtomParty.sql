-- Object: PROCEDURE dbo.UpMtomParty
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


/****** Object:  Stored Procedure dbo.UpMtomParty    Script Date: 3/17/01 9:56:13 PM ******/

/****** Object:  Stored Procedure dbo.UpMtomParty    Script Date: 3/21/01 12:50:33 PM ******/

/****** Object:  Stored Procedure dbo.UpMtomParty    Script Date: 20-Mar-01 11:39:11 PM ******/

/****** Object:  Stored Procedure dbo.UpMtomParty    Script Date: 2/5/01 12:06:30 PM ******/

/****** Object:  Stored Procedure dbo.UpMtomParty    Script Date: 12/27/00 8:59:17 PM ******/

CREATE Proc UpMtomParty as 
Delete From MtomParty
insert into Closing 
select distinct 'NORMAL',A.scrip_cd , A.series,0,getdate() from settlement A 
where A.scrip_cd not in (select distinct s.scrip_cd from settlement s , closing  c 
          where s.scrip_cd = c.scrip_Cd and a.scrip_cd = c.scrip_cd and s.series = c.series and A.series = c.series ) 
insert into MtomParty
select party_code,Sum(Effnet),sum(Closing),sum(GrossExp) from mtompartyview
group by party_code

GO
