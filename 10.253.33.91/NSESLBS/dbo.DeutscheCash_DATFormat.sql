-- Object: PROCEDURE dbo.DeutscheCash_DATFormat
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE PROC DeutscheCash_DATFormat    
(    
	@FROMDATE Varchar(11),@FROMFAMILY VARCHAR(15),@TOFAMILY VARCHAR(15),
	@FROMPARTYCODE varchar(20),@TOPARTYCODE varchar(20))    
    
AS  


if @FROMFAMILY = '' begin set @FROMFAMILY = '0'  end
if @TOFAMILY = '' begin set @TOFAMILY = 'zzzzzz' end
if @FROMPARTYCODE = '' begin set @FROMPARTYCODE = '0'  end
if @TOPARTYCODE = '' begin set @TOPARTYCODE = 'zzzzzz' end  
    
SELECT o.memberCode,     
o.company,  
--s.Contractno,    
convert(varchar,getdate(),112) as today,     
s.sett_type,     
s.series,
s.sett_no,     
s.party_code,    
convert(varchar,sm.Sec_Payin,112) as Start_Date,     
s.scrip_cd,    
s1.long_name as scripname,     
convert(varchar,s.sauda_date,112) as sauda_date,     
s.sell_buy,    
sum(s.tradeqty) as tradeqty,     
--convert(varchar,convert(numeric(18,2),round((sum(marketrate*tradeqty)/sum(tradeqty)),2))) as marketrate,    
(sum(marketrate*tradeqty)/sum(tradeqty)) as marketrate,
convert(varchar,convert(numeric(18,2),round((sum(marketrate*tradeqty)/sum(tradeqty))*sum(tradeqty),2))) as marketamount,     
convert(varchar,convert(numeric(18,2),round(sum(Brokapplied*TradeQty),2))) as brokerageamt,     
convert(varchar,convert(numeric(18,4),round(sum(netrate*tradeqty)/sum(tradeqty),4))) as netrate,    
convert(varchar,convert(numeric(18,2),round((sum(netrate*tradeqty)/sum(tradeqty)) * sum(tradeqty),2))) as netamount,     
c1.long_name,     
c1.off_phone1,     
c1.fax,     
Replace(convert(varchar,sm.Funds_Payin,110),'-','/') as payindate,     
m.isin,     
Ric=IsNull(Ric,''),     
Year(sm.Sec_Payin) SecPayInYear ,Month(sm.Sec_PayIn) SecPayInMonth,    
s2.exchange,     
Ins_Chrg = sum(Case When Insurance_Chrg = 1 Then Ins_chrg Else 0 End),     
Broker_chrg = sum(case when BrokerNote = 1 then Broker_chrg else 0 end),     
TransactionSource = 'MOTI-'+ c1.SHORT_NAME       
FROM owner o, client1 c1, client2 c2, sett_mst sm, multiisin m,     
scrip1 s1, scrip2 s2, isettlement s left outer join CMRicCodeMaster R on ( R.Scrip_Cd = S.Scrip_CD ) /* left outer join CMRicCodeMaster R on ( R.Scrip_Cd = S.Scrip_CD )*/     
where s.sauda_date like @FROMDATE + '%'  
and family between @FROMFAMILY and @TOFAMILY 
and c2.party_code=c1.cl_code
and c1.Cl_Code between @FROMPARTYCODE and @TOPARTYCODE  
And c1.cl_code = c2.cl_code     
--and s.party_code = @PARTYCODE     
--and End_date >= @FROMDATE
--and Start_date <= @FROMDATE +' 23:59'      
and c1.cl_code = c2.cl_code     
--and c2.party_code = @PARTYCODE     
and s.party_code =c2.party_code     
and s.sett_no = sm.sett_no     
and s.sett_type = sm.sett_type     
and s.tradeqty > 0     
and s.scrip_cd = m.scrip_cd     
and s.series = m.series     
and valid = 1     
and s.scrip_cd = s2.scrip_cd     
and s.series = s2.series     
and s1.co_code = s2.co_code     
and s1.series= s2.series     
    
group by o.memberCode,o.company,/*s.Contractno,*/s2.exchange,s.party_code, convert(varchar,s.sauda_date,112),s.sett_type,     
s.series,s.sett_no,s.sell_buy,convert(varchar,sm.Sec_Payin,112), c1.long_name, c1.off_phone1, c1.fax,     
Replace(convert(varchar,sm.Funds_Payin,110),'-','/'), m.isin,s.scrip_cd,s1.long_name,sm.Sec_Payin,Ric,     
'MOTI-'+ c1.SHORT_NAME      
 UNION    
    
SELECT o.memberCode,     
o.company,  
--s.Contractno,    
convert(varchar,getdate(),112) as today,     
s.sett_type,
s.series,     
s.sett_no,     
s.party_code,    
convert(varchar,sm.Sec_Payin,112) as Start_Date,     
s.scrip_cd,    
s1.long_name as scripname,     
convert(varchar,s.sauda_date,112) as sauda_date,     
s.sell_buy,    
sum(s.tradeqty) as tradeqty,     
--convert(varchar,convert(numeric(18,2),round((sum(marketrate*tradeqty)/sum(tradeqty)),2))) as marketrate,    
(sum(marketrate*tradeqty)/sum(tradeqty)) as marketrate,
convert(varchar,convert(numeric(18,2),round((sum(marketrate*tradeqty)/sum(tradeqty))*sum(tradeqty),2))) as marketamount,     
convert(varchar,convert(numeric(18,2),round(sum(Brokapplied*TradeQty),2))) as brokerageamt,     
convert(varchar,convert(numeric(18,4),round(sum(netrate*tradeqty)/sum(tradeqty),4))) as netrate,    
convert(varchar,convert(numeric(18,2),round((sum(netrate*tradeqty)/sum(tradeqty)) * sum(tradeqty),2))) as netamount,     
c1.long_name,     
c1.off_phone1,     
c1.fax,     
Replace(convert(varchar,sm.Funds_Payin,110),'-','/') as payindate,     
m.isin,     
Ric=IsNull(Ric,''),     
Year(sm.Sec_Payin) SecPayInYear ,Month(sm.Sec_PayIn) SecPayInMonth, 
s2.exchange,     
Ins_Chrg = sum(Case When Insurance_Chrg = 1 Then Ins_chrg Else 0 End),     
Broker_chrg = sum(case when BrokerNote = 1 then Broker_chrg else 0 end),     
TransactionSource = 'MOTI-'+ c1.SHORT_NAME      
FROM owner o, client1 c1, client2 c2, sett_mst sm, multiisin m,     
scrip1 s1, scrip2 s2, settlement s left outer join CMRicCodeMaster R on ( R.Scrip_Cd = S.Scrip_CD ) /* left outer join CMRicCodeMaster R on ( R.Scrip_Cd = S.Scrip_CD )*/     
where s.sauda_date like @FROMDATE + '%'   
and family between @FROMFAMILY and @TOFAMILY 
and c2.party_code=c1.cl_code
and c1.Cl_Code between @FROMPARTYCODE and @TOPARTYCODE  
And c1.cl_code = c2.cl_code       
--and s.party_code = @PARTYCODE
--and End_date >= @FROMDATE
--and Start_date <= @FROMDATE +' 23:59'         
and c1.cl_code = c2.cl_code     
--and c2.party_code = @PARTYCODE     
and s.party_code =c2.party_code     
and s.sett_no = sm.sett_no     
and s.sett_type = sm.sett_type     
and s.tradeqty > 0     
and s.scrip_cd = m.scrip_cd     
and s.series = m.series     
and valid = 1     
and s.scrip_cd = s2.scrip_cd     
and s.series = s2.series     
and s1.co_code = s2.co_code     
and s1.series= s2.series     
    
group by o.memberCode,o.company,/*s.Contractno,*/s2.exchange,s.party_code, convert(varchar,s.sauda_date,112),s.sett_type,     
s.series,s.sett_no,s.sell_buy,convert(varchar,sm.Sec_Payin,112), c1.long_name, c1.off_phone1, c1.fax,     
Replace(convert(varchar,sm.Funds_Payin,110),'-','/'), m.isin,s.scrip_cd,s1.long_name,sm.Sec_Payin,Ric,     
'MOTI-'+ c1.SHORT_NAME  
 UNION    
    
SELECT o.memberCode,     
o.company,  
--s.Contractno,    
convert(varchar,getdate(),112) as today,     
s.sett_type,
series='',     
s.sett_no,     
s.party_code,    
convert(varchar,sm.Sec_Payin,112) as Start_Date,     
s.scrip_cd,    
s1.long_name as scripname,     
convert(varchar,s.sauda_date,112) as sauda_date,     
s.sell_buy,    
sum(s.tradeqty) as tradeqty,     
--convert(varchar,convert(numeric(18,2),round((sum(marketrate*tradeqty)/sum(tradeqty)),2))) as marketrate,    
(sum(marketrate*tradeqty)/sum(tradeqty)) as marketrate,
convert(varchar,convert(numeric(18,2),round((sum(marketrate*tradeqty)/sum(tradeqty))*sum(tradeqty),2))) as marketamount,     
convert(varchar,convert(numeric(18,2),round(sum(Brokapplied*TradeQty),2))) as brokerageamt,     
convert(varchar,convert(numeric(18,4),round(sum(netrate*tradeqty)/sum(tradeqty),4))) as netrate,    
convert(varchar,convert(numeric(18,2),round((sum(netrate*tradeqty)/sum(tradeqty)) * sum(tradeqty),2))) as netamount,     
c1.long_name,     
c1.off_phone1,     
c1.fax,     
Replace(convert(varchar,sm.Funds_Payin,110),'-','/') as payindate,     
m.isin,     
Ric=IsNull(Ric,''),     
Year(sm.Sec_Payin) SecPayInYear ,Month(sm.Sec_PayIn) SecPayInMonth,    
s2.exchange,     
Ins_Chrg = sum(Case When Insurance_Chrg = 1 Then Ins_chrg Else 0 End),     
Broker_chrg = sum(case when BrokerNote = 1 then Broker_chrg else 0 end),     
TransactionSource = 'MOTI-'+ c1.SHORT_NAME      
FROM bsedb.dbo.owner o, bsedb.dbo.client1 c1, bsedb.dbo.client2 c2, bsedb.dbo.sett_mst sm, bsedb.dbo.multiisin m,     
bsedb.dbo.scrip1 s1, bsedb.dbo.scrip2 s2, bsedb.dbo.settlement s left outer join bsedb.dbo.CMRicCodeMaster R on ( R.Scrip_Cd = S.Scrip_CD ) /* left outer join CMRicCodeMaster R on ( R.Scrip_Cd = S.Scrip_CD )*/     
where s.sauda_date like @FROMDATE + '%' 
and family between @FROMFAMILY and @TOFAMILY 
and c2.party_code=c1.cl_code
and c1.Cl_Code between @FROMPARTYCODE and @TOPARTYCODE  
And c1.cl_code = c2.cl_code         
--and s.party_code = @PARTYCODE
--and End_date >= @FROMDATE
--and Start_date <= @FROMDATE +' 23:59'           
and c1.cl_code = c2.cl_code     
--and c2.party_code = @PARTYCODE     
and s.party_code =c2.party_code     
and s.sett_no = sm.sett_no     
and s.sett_type = sm.sett_type     
and s.tradeqty > 0     
and s.scrip_cd = m.scrip_cd     
and s.series = m.series     
and valid = 1     
and s.scrip_cd = s2.bsecode     
and s1.co_code = s2.co_code     
and s1.series= s2.series     
    
group by o.memberCode,o.company,/*s.Contractno,*/s2.exchange,s.party_code, convert(varchar,s.sauda_date,112),s.sett_type,     
/*s.series,*/s.sett_no,s.sell_buy,convert(varchar,sm.Sec_Payin,112), c1.long_name, c1.off_phone1, c1.fax,     
Replace(convert(varchar,sm.Funds_Payin,110),'-','/'), m.isin,s.scrip_cd,s1.long_name,sm.Sec_Payin,Ric,     
'MOTI-'+ c1.SHORT_NAME  

 UNION    
    
SELECT o.memberCode,     
o.company,  
--s.Contractno,    
convert(varchar,getdate(),112) as today,     
s.sett_type,
series='',     
s.sett_no,     
s.party_code,    
convert(varchar,sm.Sec_Payin,112) as Start_Date,     
s.scrip_cd,    
s1.long_name as scripname,     
convert(varchar,s.sauda_date,112) as sauda_date,     
s.sell_buy,    
sum(s.tradeqty) as tradeqty,     
--convert(varchar,convert(numeric(18,2),round((sum(marketrate*tradeqty)/sum(tradeqty)),2))) as marketrate,    
(sum(marketrate*tradeqty)/sum(tradeqty)) as marketrate,
convert(varchar,convert(numeric(18,2),round((sum(marketrate*tradeqty)/sum(tradeqty))*sum(tradeqty),2))) as marketamount,     
convert(varchar,convert(numeric(18,2),round(sum(Brokapplied*TradeQty),2))) as brokerageamt,     
convert(varchar,convert(numeric(18,4),round(sum(netrate*tradeqty)/sum(tradeqty),4))) as netrate,    
convert(varchar,convert(numeric(18,2),round((sum(netrate*tradeqty)/sum(tradeqty)) * sum(tradeqty),2))) as netamount,     
c1.long_name,     
c1.off_phone1,     
c1.fax,     
Replace(convert(varchar,sm.Funds_Payin,110),'-','/') as payindate,     
m.isin,     
Ric=IsNull(Ric,''),     
Year(sm.Sec_Payin) SecPayInYear ,Month(sm.Sec_PayIn) SecPayInMonth,    
s2.exchange,     
Ins_Chrg = sum(Case When Insurance_Chrg = 1 Then Ins_chrg Else 0 End),     
Broker_chrg = sum(case when BrokerNote = 1 then Broker_chrg else 0 end),     
TransactionSource = 'MOTI-'+ c1.SHORT_NAME      
FROM bsedb.dbo.owner o, bsedb.dbo.client1 c1, bsedb.dbo.client2 c2, bsedb.dbo.sett_mst sm, bsedb.dbo.multiisin m,     
bsedb.dbo.scrip1 s1, bsedb.dbo.scrip2 s2, bsedb.dbo.isettlement s left outer join bsedb.dbo.CMRicCodeMaster R on ( R.Scrip_Cd = S.Scrip_CD ) /* left outer join CMRicCodeMaster R on ( R.Scrip_Cd = S.Scrip_CD )*/     
where s.sauda_date like @FROMDATE + '%' 
and family between @FROMFAMILY and @TOFAMILY 
and c2.party_code=c1.cl_code
and c1.Cl_Code between @FROMPARTYCODE and @TOPARTYCODE  
And c1.cl_code = c2.cl_code         
--and s.party_code = @PARTYCODE
--and End_date >= @FROMDATE
--and Start_date <= @FROMDATE +' 23:59'           
and c1.cl_code = c2.cl_code     
--and c2.party_code = @PARTYCODE     
and s.party_code =c2.party_code     
and s.sett_no = sm.sett_no     
and s.sett_type = sm.sett_type     
and s.tradeqty > 0     
and s.scrip_cd = m.scrip_cd     
and s.series = m.series     
and valid = 1     
and s.scrip_cd = s2.bsecode     
and s1.co_code = s2.co_code     
and s1.series= s2.series     
    
group by o.memberCode,o.company,/*s.Contractno,*/s2.exchange,s.party_code, convert(varchar,s.sauda_date,112),s.sett_type,     
/*s.series,*/s.sett_no,s.sell_buy,convert(varchar,sm.Sec_Payin,112), c1.long_name, c1.off_phone1, c1.fax,     
Replace(convert(varchar,sm.Funds_Payin,110),'-','/'), m.isin,s.scrip_cd,s1.long_name,sm.Sec_Payin,Ric,
'MOTI-'+ c1.SHORT_NAME      
Order By s.party_code,/*s.Contractno,*/m.isin,s.scrip_cd

GO
