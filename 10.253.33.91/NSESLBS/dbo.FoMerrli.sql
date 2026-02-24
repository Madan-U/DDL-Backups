-- Object: PROCEDURE dbo.FoMerrli
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE proc [dbo].[FoMerrli]             
 (@sdate varchar(11),@party_code varchar(10))            
As            
            
Select fo.membercode,            
 --f.party_code,            
 party_code=c2.bankid,    
 f.symbol,            
 expirydate=Replace(left(convert(varchar,F.expirydate,113),11),' ','-'),            
 expirydate1=left(convert(varchar,F.expirydate,109),11),            
 expirydate2=left(convert(varchar,F.expirydate,101),11),            
 F.strike_price,            
 F.inst_type,            
 F.option_type,            
 sauda_date=left(convert(varchar,sauda_date,101),11),            
 sell_buy,            
 scripname=f.sec_name,--s1.long_name as scripname,            
 c1.long_name as clientname,            
 exchange='NSE', --s2.exchange,            
 ContRef=f.contractno, --Off_Phone1+'/'+Off_Phone2,            
 --CPCode=CltDpNo,            
 CPCode=c2.bankid,    
 CallPut=F.option_type,            
 ContractValue=sum(price*tradeqty),            
 tradeqty=sum(tradeqty),            
 price=sum(price*tradeqty)/sum(tradeqty),          
 ScripCode=ms.MerrylCode,    
 c2.dummy1, 
 c_Regular_lot = (Case When c_Regular_lot='' Or c_Regular_lot=0 Then 1 Else c_Regular_lot End),     
 brokapplied =sum(isnull(((brokapplied*tradeqty) + (case when c2.service_chrg=1 then             
    isnull(f.SERVICE_TAX/tradeqty,0) Else 0 end )),0)),            
 service_tax = sum(CASE WHEN c2.service_chrg=0 THEN (f.service_tax*tradeqty) ELSE            
                  (CASE WHEN c2.service_chrg=1  THEN 0 ELSE            
                   (cASE WHEN c2.service_chrg=2 THEN  0            
                       END) END) END),          
Ins_Chrg = sum(Case When Insurance_Chrg = 1 Then (f.Ins_chrg) Else 0 End)            
            
From fosettlement f Left Outer Join Merryl_ScripMaster ms on (ms.symbol = f.symbol),
client1 c1, client2 c2,foOwner fo, foscrip2 fs2
            
Where c1.cl_code = c2.cl_code                    
 and f.party_code = c2.party_code                     
 --and f.symbol = s2.scrip_cd                     
 --and f.series = s2.series                
 --and s1.co_code = s2.co_code                     
 --and s1.series= s2.series    
 and fs2.SYMBOL = F.SYMBOL AND F.EXPIRYDATE LIKE LEFT(CONVERT(VARCHAR,fs2.EXPIRYDATE,109),11) + '%'   
 and F.Inst_Type=fs2.Inst_Type And F.Strike_Price=fs2.Strike_Price And F.Option_Type=fs2.Option_Type   
 --and ms.symbol = f.symbol                      
 and f.tradeqty > 0             
 and f.party_code = @party_code                    
 and f.sauda_date like @sdate +'%'               
            
Group By            
contractno,f.party_code,f.symbol,Replace(left(convert(varchar,F.expirydate,113),11),' ','-'),F.strike_price,            
F.inst_type,F.option_type,left(convert(varchar,sauda_date,101),11),left(convert(varchar,F.expirydate,101),11),sell_buy,f.sec_name,            
c1.long_name,f.Expirydate,membercode,ms.MerrylCode,c2.bankid,c2.dummy1,c_Regular_lot
 --Insurance_Chrg,Off_Phone1,Off_Phone2,CltDpNo,membercode,fo.phone,s2.exchange,s1.long_name,          
        
            
Order By f.symbol,sell_buy,f.party_code

GO
