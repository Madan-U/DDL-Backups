-- Object: PROCEDURE dbo.Rpt_FinOb
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------



/****** Object:  Stored Procedure dbo.Rpt_FinOb    Script Date: 04/27/2001 4:32:38 PM ******/

/****** Object:  Stored Procedure dbo.Rpt_FinOb    Script Date: 3/21/01 12:50:14 PM ******/

/****** Object:  Stored Procedure dbo.Rpt_FinOb    Script Date: 20-Mar-01 11:38:55 PM ******/

/****** Object:  Stored Procedure dbo.Rpt_FinOb    Script Date: 2/5/01 12:06:16 PM ******/

/****** Object:  Stored Procedure dbo.Rpt_FinOb    Script Date: 12/27/00 8:59:08 PM ******/

CREATE proc Rpt_FinOb As
delete finobrpt
insert into finobrpt
select Sett_no,Sett_Type,PAmt=Sum(PAmt),SAmt=Sum(SAmt),NAmt=Sum(PAmt)-Sum(Samt)  from FinObNormal where  sett_Type <> 'L'
group by sett_no,sett_Type
union all
select Sett_no,Sett_Type,PAmt=Isnull(Sum(PAmt),0),SAmt=IsNull(Sum(Samt),0),NAmt=Isnull(Sum(PAmt),0)-IsNull(Sum(Samt),0) from oppalbmscrip where  sett_Type <> 'L'
group by sett_no,sett_Type
union all
select Sett_no,Sett_Type,PAmt=Sum(PAmt),SAmt=Sum(SAmt),NAmt=Sum(PAmt)-Sum(Samt)  from FinObPlusOneAlbm where  sett_Type <> 'L'
group by sett_no,sett_Type
select S.Sett_no,S.Sett_Type,DPamt=sum(S.PAmt),APamt=F.Pamt,DSamt=sum(S.SAmt),ASAmt=F.Samt,DNAmt=sum(S.NAmt),ANAmt=f.PAmt-f.Samt from finobrpt S,FinOb F
where S.Sett_no = f.sett_no and s.sett_Type = f.sett_Type 
group by s.sett_no,s.sett_type,f.sett_no,f.sett_type,F.Pamt,F.samt
order by s.sett_no,s.sett_type

GO
