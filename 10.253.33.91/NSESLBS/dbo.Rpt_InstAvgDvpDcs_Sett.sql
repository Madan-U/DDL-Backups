-- Object: PROCEDURE dbo.Rpt_InstAvgDvpDcs_Sett
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------

CREATE procedure Rpt_InstAvgDvpDcs_Sett              
@ofdate varchar(11),               
@fparty varchar(10),               
@tparty varchar(10),               
@fscrip varchar(10),               
@tscrip varchar(10),               
@ffamily varchar(10),               
@tfamily varchar(10),               
@orderby varchar(1)              
              
as              
          
if @fparty = '' Set @fparty = '0000000000'              
if @tparty = '' Set @tparty = 'ZZZZZZZZZZ'              
              
if @fscrip = '' Set @fscrip = '0000000000'              
if @tscrip = '' Set @tscrip = 'ZZZZZZZZZZ'              
          
if @ffamily = '' Set @ffamily = '0000000000'              
if @tfamily = '' Set @tfamily = 'ZZZZZZZZZZ'              
          
select           
      Case @orderby           
            When '0' Then s.contractno          
            When '1' Then s.Party_Code          
            When '2' Then s.scrip_cd          
      Else ''           
      End,            
      Case @orderby           
            When '0' Then (case when c1.cl_type = 'INS' then 'DVP' else 'REJ' end)           
            When '1' Then s.scrip_cd          
            When '2' Then s.Party_Code          
      Else ''           
      End,            
      Case @orderby           
            When '0' Then s.Party_Code          
      Else convert(varchar,sell_buy)           
      End,            
      Case @orderby           
            When '0' Then s.Scrip_Cd          
      Else s.contractno           
      End,            
      Case @orderby           
            When '0' Then convert(varchar,sell_buy)          
      Else (case when c1.cl_type = 'INS' then 'DVP' else 'REJ' end)           
      End,            
      s.series,           
      sauda_date = left(convert(varchar, sauda_date, 109), 11),           
      tradeqty = sum(tradeqty),               
      mktrate = sum(marketrate*tradeqty)/sum(tradeqty),           
      mktamt = round(sum(marketrate*tradeqty), 2),               
      brok = sum(nbrokapp * tradeqty) / sum(tradeqty),               
      netrate = sum(n_netrate*tradeqty)/sum(tradeqty),               
      STT = SUM(Case When Insurance_Chrg = 1 Then Ins_chrg Else 0 End),               
      netamt = round(sum( Case when  Sell_buy = 1 then n_netrate*tradeqty +  (Case When Insurance_Chrg = 1 Then Ins_chrg Else 0 End )  else  n_netrate*tradeqty -  (Case When Insurance_Chrg = 1 Then Ins_chrg Else 0 End ) end), 2),               
      avgrate = sum(s.dummy1*tradeqty)/sum(tradeqty), avgamt = round(sum(s.dummy1*tradeqty), 2),               
      scripname = left(s1.long_name, 20),           
      user_id,           
      sett_no,           
      sett_type,           
      c1.long_name,           
      c1.cl_type,           
      isin = isnull(I.ISIN,''),            
      stp_date = isnull(Creationdate,'-'),            
      C_Status = min(s.Dummy2)               
from           
      settlement s (nolock)          
      Left Outer Join           
      (          
            Select           
                  ContractNo,           
                  PartyCode,           
                  CreationDate = Min(CreationDate)          
            From           
                  Stp_Header_New (nolock)           
            Where           
                  CreationDate >= convert(varchar,convert(datetime,@ofdate),112)          
            Group By           
                  ContractNo, PartyCode          
      ) H          
      On          
      (          
            s.Contractno = H.Contractno              
            And s.Party_Code = H.Partycode              
      ),           
      scrip2 s2 (nolock)           
      Left Outer Join MultiIsin I  (nolock)           
      On          
      (          
            S2.Scrip_Cd = I.Scrip_Cd              
            And S2.Series = I.Series              
            And I.Valid = 1              
      ),          
      scrip1 s1 (nolock),           
      client1 c1 (nolock),           
      client2 c2 (nolock)               
where           
left(convert(varchar,Sauda_date,109),11) = @ofdate           
and s.Party_Code Between @fparty and @tparty          
and s.Scrip_Cd Between @fscrip and @tscrip           
and s.scrip_cd = s2.scrip_cd           
and s2.co_code = s1.co_code           
and s2.series = s1.series           
and s.party_code = c2.party_code           
and c2.cl_code = c1.cl_code           
and c1.Family Between @ffamily and @tfamily           
and tradeqty <> 0               
and left(auctionpart,1) not in ('F','A')           
and (s.dummy1 <> marketrate OR c1.cl_type = 'INS')     
and s.series = s2.series              
group by           
      s2.scrip_cd, s.scrip_cd, s.series, s.party_code, sell_buy, left(convert(varchar, sauda_date, 109), 11),               
      user_id, partipantcode, sett_no, sett_type, c1.long_name, c1.cl_type, s.contractno, Insurance_Chrg,  s1.long_name,               
      I.ISIN, Creationdate          
          
union all              
          
select           
      Case @orderby           
            When '0' Then s.contractno          
            When '1' Then s.Party_Code          
            When '2' Then s.scrip_cd          
      Else ''           
      End,            
      Case @orderby           
            When '0' Then 'DCS'            
            When '1' Then s.scrip_cd          
            When '2' Then s.Party_Code          
      Else ''           
      End,            
      Case @orderby           
            When '0' Then s.Party_Code          
      Else convert(varchar,sell_buy)           
      End,            
      Case @orderby           
            When '0' Then s.Scrip_Cd          
      Else s.contractno           
      End,            
      Case @orderby           
            When '0' Then convert(varchar,sell_buy)          
      Else 'DCS'            
      End,            
      s.series,           
      sauda_date = left(convert(varchar, sauda_date, 109), 11),           
      tradeqty = sum(tradeqty),               
      mktrate = sum(marketrate*tradeqty)/sum(tradeqty), mktamt = round(sum(marketrate*tradeqty), 2),               
      brok = sum(nbrokapp * tradeqty) / sum(tradeqty),               
      netrate = sum(n_netrate*tradeqty)/sum(tradeqty),               
      STT = SUM(Case When Insurance_Chrg = 1 Then Ins_chrg Else 0 End),           
      netamt = round(sum( Case when  Sell_buy = 1 then n_netrate*tradeqty +  (Case When Insurance_Chrg = 1 Then Ins_chrg Else 0 End ) else  n_netrate*tradeqty -  (Case When Insurance_Chrg = 1 Then Ins_chrg Else 0 End ) end), 2),               
      avgrate = sum(s.dummy1*tradeqty)/sum(tradeqty),           
      avgamt = round(sum(s.dummy1*tradeqty), 2),               
      scripname = left(s1.long_name, 20),           
      user_id,           
      sett_no,           
      sett_type,           
      c1.long_name,           
      c1.cl_type,           
      isin = isnull(I.ISIN,''),            
      stp_date = isnull(Creationdate,'-'),            
      C_Status = min(s.Dummy2)              
from           
      isettlement s with(index(stt_index),nolock)           
      Left Outer Join           
      (          
            Select           
                  ContractNo,           
                  PartyCode,           
                  CreationDate = Min(CreationDate)          
            From           
                  Stp_Header_New (nolock)           
            Where           
                  CreationDate >= convert(varchar,convert(datetime,@ofdate),112)          
            Group By           
                  ContractNo, PartyCode          
      ) H          
      On          
      (          
            s.Contractno = H.Contractno              
            And s.Party_Code = H.Partycode              
      ),           
      scrip2 s2 (nolock)           
      Left Outer Join MultiIsin I  (nolock)           
      On          
      (          
            S2.Scrip_Cd = I.Scrip_Cd              
            And S2.Series = I.Series            
    And I.Valid = 1              
      ),          
      scrip1 s1 (nolock),            
      client1 c1 (nolock),           
      client2 c2 (nolock)               
where           
left(convert(varchar,Sauda_date,109),11) = @ofdate           
and s.Party_Code Between @fparty and @tparty          
and s.Scrip_Cd Between @fscrip and @tscrip           
and s.scrip_cd = s2.scrip_cd           
and s2.co_code = s1.co_code           
and s2.series = s1.series           
and s.party_code = c2.party_code           
and c2.cl_code = c1.cl_code           
and c1.Family Between @ffamily and @tfamily           
and tradeqty <> 0               
and s.series = s2.series              
group by           
      s2.scrip_cd, s.scrip_cd, s.series, s.party_code, sell_buy, left(convert(varchar, sauda_date, 109), 11),               
      user_id, partipantcode, sett_no, sett_type, c1.long_name, c1.cl_type, s.contractno, Insurance_Chrg,  s1.long_name,           
      I.ISIN, Creationdate  
Order by           
      1,2,3,4,5

GO
