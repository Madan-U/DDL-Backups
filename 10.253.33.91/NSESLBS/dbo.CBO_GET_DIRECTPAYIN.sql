-- Object: PROCEDURE dbo.CBO_GET_DIRECTPAYIN
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------













CREATE     PROCEDURE [dbo].[CBO_GET_DIRECTPAYIN]
(
	@REPORTDATE VARCHAR(20),
	@EXECUTIONDATE VARCHAR(20),
   @SETTNO VARCHAR(20),
   @SETTTYPE VARCHAR(20)
	
 
	
)
AS
 
	select 
		Party_code,
		D.scrip_cd,
		D.series,
		D.Isin,
		SellQty,
		DirectpayQty,
		dpid,
		Cltdpid,
		locked,
		ScripName=Scrip_Cd ,
Pradnya.dbo.NUMBERTOWORDS(SellQty) as qty
	from 
		DelBseDirectPI D 
	where 
		 sett_no= @SETTNO
	and sett_type = @SETTTYPE
     






	select 
		scrip_cd,
		series 
	from 
		deliveryClt 
	where
 	sett_no=@SETTNO
and sett_type = @SETTTYPE
and inout ='I' 
and scrip_cd not in (select scrip_cd from multiisin where valid=1 and deliveryClt.series = multiisin.series)                           


	





	select 
		D.Party_Code,
		D.scrip_cd,
		D.series 
	from 
		DeliveryClt D, 
		MultiIsIn M 
	where 
		sett_no= @SETTNO
	and sett_type = @SETTTYPE
	and inout ='I' 
	And D.Scrip_cd = M.Scrip_cd 
	And Valid = 1 
	and D.series = M.Series 
	Group By 
		D.Party_Code,
		D.Scrip_cd,
		D.Series 
	Having Count(D.Scrip_Cd) > 1 

	





	select 
		M.Party_Code,
		DpId,CltDpNo 
	from 
		MultiCltId M 
	where 
		Def = 1 
		And DpType = 'CDSL' 
		And Party_Code in ( Select Distinct Party_Code From DeliveryClt D Where sett_no= @SETTNO and sett_type = @SETTTYPE and inout ='I'   And Party_Code = M.Party_Code ) 
	Group By 
		M.Party_Code,
		DpId,
		CltDpNo 
	Having Count(M.Party_Code) > 1 

	



	select distinct 
		d.Party_code,
		d.scrip_cd,
		d.series,
		d.qty as expected, 
		delivered=sum(Isnull(a.qty,0)),
		M.isin,
		bankid=C.dpid,
		Cltdpid=C.cltdpno,
		Scripname=d.Scrip_Cd,
		Pradnya.dbo.NUMBERTOWORDS(d.qty-sum(Isnull(a.qty,0))) as qty--
	from 
		multiisin m,MultiCltID C, deliveryclt d Left Outer Join deltrans a 
	ON (a.sett_no= d.sett_no and a.sett_type=d.sett_type and a.scrip_cd =d.scrip_cd and 
	a.series = d.series and a.filler2=1 and a.party_code =d.party_code and a.drcr='C')
	where d.sett_no=@SETTNO and d.sett_type=@SETTTYPE and d.scrip_cd =m.scrip_cd and d.series = m.series and m.valid=1
	and d.inout ='I' And
	c.party_code = d.party_code And c.def = 1 And C.DpType = 'CDSL' 
	group by d.sett_no,d.sett_type,d.Party_code,d.scriP_cd,d.series,m.isin,C.dpid,C.cltdpno,D.Qty
	Having D.Qty > 0

GO
