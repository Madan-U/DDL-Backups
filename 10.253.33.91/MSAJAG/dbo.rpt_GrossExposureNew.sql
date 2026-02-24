-- Object: PROCEDURE dbo.rpt_GrossExposureNew
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------


CREATE PROCEDURE rpt_GrossExposureNew
@fromparty varchar(10),
@toparty varchar(10),
@fromdate varchar(11),
@todate varchar(11),
@settlementtype varchar(3),
@Branch_Cd varchar(10),
@Sub_broker varchar(10)
as
declare
@@fromsettlementno varchar (12),
@@tosettlementno varchar (12),
@@sauda_date varchar(12),
@@settlementtype varchar(3),
@@fromsettno varchar(13),
@@tosettno varchar(13),
@@settype varchar(3),
@@settypeani varchar(3),
@@fromdate varchar(11),
@@dummyfromdate varchar(11),
@@scripcd varchar (12),
@@buyvalue money,
@@sellvalue money,
@@branchid varchar (12),
@@Series Varchar(2),
@@DummySeries Varchar(2),
@@dummyscrip varchar (12),
@@dummybranchid varchar(12),
@@netvalue money,
@@rate money,
@@varmargin money,
@@gross money,
@@totnetval money,
@@newsellvalue money,
@@newbuyvalue money,
@@resvarmargin money,
@@totvarmargin money,
@@restotvarmargin money,
@@grosstot money,
@@resgrosstot money	

Truncate Table TblGrossExp
Insert Into TblGrossExp	
select sett_type ,sett_no,Convert(DateTime,Left(Convert(Varchar,s.sauda_date,109),11)),branch_id='0',
buyval=Sum(Case when Sell_Buy = 1 then  tradeqty * MarketRate Else 0 End ) , 
Sellval=Sum(Case when Sell_Buy = 2 then  tradeqty * MarketRate Else 0 End ) , 
scrip_Cd,S.Party_code,s.series,Trade_no='0',rate=0,Family,Branch_Cd=Ltrim(Branch_Cd),Sub_Broker
from settlement s, Client2 C2, Client1 C1 
Where tradeqty > 0 
and C1.Cl_Code = C2.Cl_Code and C2.Party_Code = S.Party_Code 
And sauda_date >= convert(datetime,@fromdate) - 2  and sauda_date <= @todate + ' 23:59:59'
And Sett_Type = @settlementtype 
And S.Party_Code >= @fromparty And S.Party_Code <= @Toparty
Group By sett_type ,sett_no,Convert(DateTime,Left(Convert(Varchar,s.sauda_date,109),11)),
scrip_Cd,S.Party_code,s.series,Family,Branch_Cd,Sub_Broker
Having Sum(Case When Sell_Buy = 1 Then TradeQty Else -TradeQty End) <> 0

	select @@settlementtype = @settlementtype
	truncate table TempGrossExp
	truncate table GrpExpDate
	Insert into GrpExpDate
	select distinct  start_date = left(convert(varchar,sauda_date,109),11) from TblGrossExp 
	where sauda_date >= @fromdate and sauda_date <= @todate + ' 23:59:59'

	declare getsaudadate cursor for 	
		select distinct  start_date from GrpExpDate
	open getsaudadate
	fetch next from getsaudadate into @@sauda_date
	while @@fetch_status = 0 
	begin	
		select @@settlementtype = @settlementtype
		declare opensettno scroll cursor for 
			select sett_no from sett_mst 
			where sec_payin > @@sauda_date and start_date <= @@sauda_date
			and sett_type = @@settlementtype
			group by sett_type , start_date, sett_no , left(convert(varchar,sec_payin,109),11) 
			order by sett_type,sett_no 
		open opensettno
		if @@settlementtype = 'N'
		begin
			FETCH ABSOLUTE 2 FROM opensettno into @@fromsettlementno
			fetch last from opensettno into @@tosettlementno	
			insert into TempGrossExp values(@@fromsettlementno,@@tosettlementno,@@settlementtype,@@sauda_date,0,0)
		end 	
		else
		if @@settlementtype = 'W'
		begin
			fetch next from opensettno into @@fromsettlementno
			fetch last from opensettno into @@tosettlementno	
			insert into TempGrossExp values(@@fromsettlementno,@@tosettlementno,@@settlementtype,@@sauda_date,0,0)
		end 
		CLOSE opensettno
		DEALLOCATE opensettno
		if @@settlementtype = '%'
		begin
			select @@settlementtype = 'N'
			declare opensettno1 scroll cursor for 
				select sett_no from sett_mst 
				where sec_payin > @@sauda_date and start_date <= @@sauda_date
				and sett_type = @@settlementtype 
				group by sett_type , start_date, sett_no , left(convert(varchar,sec_payin,109),11) 
				order by sett_type,sett_no 
			open opensettno1
			if @@settlementtype = 'N'
			begin
				FETCH ABSOLUTE 2 FROM opensettno1 into @@fromsettlementno
				fetch last from opensettno1 into @@tosettlementno	
				insert into TempGrossExp values(@@fromsettlementno,@@tosettlementno,@@settlementtype,@@sauda_date,0,0)
			end 
			CLOSE opensettno1
			DEALLOCATE opensettno1

			select @@settlementtype = 'W'
			declare opensettno2 scroll cursor for 
				select sett_no from sett_mst 
				where sec_payin > @@sauda_date and start_date <= @@sauda_date
				and sett_type = @@settlementtype 
				group by sett_type , start_date, sett_no , left(convert(varchar,sec_payin,109),11) 
				order by sett_type,sett_no  
				open opensettno2
			if @@settlementtype = 'W'
			begin
				fetch next from opensettno2 into @@fromsettlementno
				fetch last from opensettno2 into @@tosettlementno	
				insert into TempGrossExp values(@@fromsettlementno,@@tosettlementno,@@settlementtype,@@sauda_date,0,0)
			end 
			CLOSE opensettno2
			DEALLOCATE opensettno2
		end /* End of All*/
	fetch next from getsaudadate into @@sauda_date
	end /*end of fetch status*/
	CLOSE getsaudadate
	DEALLOCATE getsaudadate
	Truncate Table TblGrossExpNew
	insert into TblGrossExpNew
	select s.scrip_cd,
	buyvalue = isnull(sum(buyval),0),
	sellvalue = isnull(sum(sellval),0),
	s.branch_id,s.series,fromsettno,tosettno,t.sett_type,saudadate,varmargin,grossexp,Rate=0.00,Party_Code,Family,Branch_Cd,Sub_Broker
	from TempGrossExp T, TblGrossExp  s
	where s.Family >= @fromparty and s.Family <= @toparty
	and s.sett_no >= t.fromsettno and s.sett_no <= t.tosettno
	And S.Sauda_Date Like Left(Convert(Varchar,SaudaDate,109),11) + '%'
	and s.sett_type = t.sett_Type and Branch_Cd like @Branch_Cd and Sub_broker like @Sub_broker 
	group by s.scrip_cd ,s.sett_type , s.series, s.branch_id,fromsettno,tosettno,t.sett_type,saudadate,varmargin,grossexp,Party_Code,Family,Branch_Cd,Sub_Broker

	insert into TblGrossExpNew
	select  s.scrip_cd,
	buyvalue = isnull(sum(buyval),0),
	sellvalue = isnull(sum(sellval),0),
	s.branch_id,s.series,fromsettno,tosettno,t.sett_type,saudadate,varmargin,grossexp,Rate=0.00,Party_Code,Family,Branch_Cd,Sub_Broker
	from sett_mst st, TempGrossExp T, TblGrossExp  s where sec_payin > T.SaudaDate
	and sauda_date <= left(convert(varchar,T.SaudaDate,109),11) + ' 23:59:59'
	and st.sett_no=s.sett_no and st.sett_type=s.sett_type
	and s.Family >= @fromparty and  s.Family <= @toparty and
	s.sett_no >= t.fromsettno and s.sett_no < = t.tosettno
	And S.Sauda_Date Like Left(Convert(Varchar,SaudaDate,109),11) + '%'
	and st.sett_type = t.sett_Type and Branch_Cd like @Branch_Cd and Sub_broker like @Sub_broker and 
	s.sett_no = (select distinct settled_in from nodel n where n.scrip_cd=s.scrip_cd and n.series=s.series and n.sett_type=s.sett_type and s.sett_no=n.settled_in )
	group by s.scrip_cd ,s.sett_type , s.series, s.branch_id,fromsettno,tosettno,t.sett_type,saudadate,varmargin,grossexp,Party_Code,Family,Branch_Cd,Sub_Broker

	Update TblGrossExpNew Set Rate = isnull(VarMarginRate,0)  from VARDETAIL v, varcontrol c 
	Where V.scrip_cd = TblGrossExpNew.Scrip_cd and v.DetailKey = c.DetailKey 
	and recdate like Left(Convert(Varchar,saudadate,109),11) + '%'

	Update TblGrossExpNew Set grossexp = (case When Sett_Type = 'N' Then Abs(BuyValue-SellValue) Else Abs(BuyValue+SellValue) End )	

	Update TblGrossExpNew Set varmargin = Abs(grossexp*Rate/100)

Delete From TblGrossExpNewDetail Where RunDate Like @FromDate + '%'  
And Party_Code Between @FromParty And @ToParty and sett_type = @settlementtype

Insert into TblGrossExpNewDetail 
Select *,@FromDate From TblGrossExpNew

GO
