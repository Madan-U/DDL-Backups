-- Object: PROCEDURE dbo.CBO_BulkDealReport
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------



CREATE PROC CBO_BulkDealReport
(				
				@PartyOption VARCHAR(10),
				@saudadate VARCHAR(15),
				@FromPartyCode VARCHAR(20),
				@ToPartyCode VARCHAR(20),
				@FromScripCode VARCHAR(20),
				@ToScripCode VARCHAR(20),
				@Group VARCHAR(10), 
				@strpaid VARCHAR(10)
)
AS
BEGIN				
	  IF @PartyOption='PARTY' 
				   SELECT  
							membercode,
							Party_code = S.Party_code, 
							Trade_Date=CONVERT(VARCHAR,S.Sauda_date,103), 
							Scrip_Cd = S.Scrip_Cd , 
							S.Series,
							S2.NoofIssuedshares,
							Partyname = c1.Long_name,
							trade_price=SUM(s.tradeqty*s.MarketRate)/SUM(s.tradeqty),
							type=CASE Sell_Buy WHEN '2' THEN 'S' ELSE 'P' END, 
							ScripName = S1.Short_Name,
							Sell_Buy, 
							qty=SUM(s.tradeqty) 
				
					FROM 
						  	 owner,
							 Settlement S, 
							 Scrip1 S1, 
							 Scrip2 S2, 
							 client1 c1, 
							 client2 c2,
							 Sett_Mst M  
					WHERE 
							 S2.Series = S1.Series 
							 And S2.Scrip_Cd = S.Scrip_CD 
							 And S2.Series = S.Series 
							 and c1.cl_code = c2.cl_code 
							 And S.Sett_No = M.Sett_No 
							 And S.Sett_Type = M.Sett_Type 
							 and s.party_code = c2.party_code 
							 And S1.Co_Code = S2.Co_Code 
							 and S2.NoofIssuedshares > 0 
					      AND CONVERT(Varchar(11),s.Sauda_Date,109)=Convert(varchar(11), convert(datetime, @saudadate,103), 109)
							AND SELL_BUY LIKE CASE @Group WHEN 'SELL' THEN '2' WHEN 'BUY' THEN '1' ELSE '%' END
					      AND S.Scrip_CD BETWEEN @FromScripCode AND @ToScripCode 
							AND S.Party_Code BETWEEN @FromPartyCode AND @ToPartyCode 
				
					GROUP BY S.Party_code, 
								CONVERT(VARCHAR,S.Sauda_date,103),
								S.Scrip_Cd, 
								S.Series,
								S2.NoofIssuedshares,
								S1.Short_Name, 
								Sell_Buy,membercode,
								c1.Long_name,C1.Family 
					HAVING SUM(s.tradeqty)*100/S2.NoofIssuedshares >  CONVERT(Decimal,@strpaid)
				UNION ALL
					SELECT  
							membercode,
							Party_code = S.Party_code, 
							Trade_Date=CONVERT(VARCHAR,S.Sauda_date,103), 
							Scrip_Cd = S.Scrip_Cd , 
							S.Series,
							S2.NoofIssuedshares,
							Partyname = c1.Long_name,
							trade_price=SUM(s.tradeqty*s.MarketRate)/SUM(s.tradeqty),
							type=CASE Sell_Buy WHEN '2' THEN 'S' ELSE 'P' END, 
							ScripName = S1.Short_Name,
							Sell_Buy, 
							qty=SUM(s.tradeqty) 
				
					FROM 
				    	  	owner,
						   ISettlement S, 
						   Scrip1 S1, 
				    		Scrip2 S2, 
				   	   client1 c1, 
				   	   client2 c2,
				   		Sett_Mst M  
				
					WHERE 
						 S2.Series = S1.Series 
						 And S2.Scrip_Cd = S.Scrip_CD 
						 And S2.Series = S.Series 
						 and c1.cl_code = c2.cl_code 
						 And S.Sett_No = M.Sett_No 
						 And S.Sett_Type = M.Sett_Type 
						 and s.party_code = c2.party_code 
						 And S1.Co_Code = S2.Co_Code 
						 and S2.NoofIssuedshares > 0 
					         and CONVERT(Varchar(11),s.Sauda_Date,109)=Convert(varchar(11), convert(datetime, @saudadate,103), 109)
				    	 		AND SELL_BUY LIKE CASE @Group WHEN 'SELL' THEN '2' WHEN 'BUY' THEN '1' ELSE '%' END	
					         AND S.Scrip_CD between @FromScripCode And  @ToScripCode 
				 	  		   AND S.Party_Code BETWEEN @FromPartyCode AND @ToPartyCode 
				
					GROUP BY S.Party_code, 
								CONVERT(VARCHAR,S.Sauda_date,103),
								S.Scrip_Cd, 
								S.Series,
								S2.NoofIssuedshares,
								S1.Short_Name, 
								Sell_Buy,membercode,
								c1.Long_name,C1.Family 
				   HAVING SUM(s.tradeqty)*100/S2.NoofIssuedshares >  CONVERT(Decimal,@strpaid)
				
				ELSE IF @PartyOption='FAMILY' 	
				   SELECT  
								membercode,
								Party_code = c1.Family , 
								Trade_Date=CONVERT(Varchar,S.Sauda_date,103), 
								Scrip_Cd = S.Scrip_Cd, 
								S.Series,
								S2.NoofIssuedshares,
								Partyname = c1.Long_name,
								trade_price=SUM(s.tradeqty*s.MarketRate)/SUM(s.tradeqty),
								type=CASE Sell_Buy WHEN '2' THEN 'S' ELSE 'P' END, 
								ScripName = S1.Short_Name,
								Sell_Buy, 
								qty=SUM(s.tradeqty) 
					FROM 
								owner,
								Settlement S, 
								Scrip1 S1, 
								Scrip2 S2, 
								client1 c1, 
								client2 c2,
								Sett_Mst M  
					WHERE 
								S2.Series = S1.Series 
								And S2.Scrip_Cd = S.Scrip_CD 
								And S2.Series = S.Series 
								and c1.cl_code = c2.cl_code 
								And S.Sett_No = M.Sett_No 
								And S.Sett_Type = M.Sett_Type 
								and s.party_code = c2.party_code 
								And S1.Co_Code = S2.Co_Code 
								and S2.NoofIssuedshares > 0 
								   and CONVERT(Varchar(11),s.Sauda_Date,109)=Convert(varchar(11), convert(datetime, @saudadate,103), 109)
									AND SELL_BUY LIKE CASE @Group WHEN 'SELL' THEN '2' WHEN 'BUY' THEN '1' ELSE '%' END	
								   AND S.Scrip_CD between @FromScripCode And  @ToScripCode 
									AND C1.Family BETWEEN @FromPartyCode AND @ToPartyCode 
					GROUP BY 
								C1.Family, 
								CONVERT(VARCHAR,S.Sauda_date,103), 
								S.Scrip_Cd, 
								S.Series,S2.NoofIssuedshares, 
								S1.Short_Name, 
								Sell_Buy,membercode ,
								c1.Long_name
					HAVING SUM(s.tradeqty)*100/S2.NoofIssuedshares >  CONVERT(Decimal,@strpaid)
				UNION ALL
				  SELECT  
								membercode,
								Party_code = c1.Family , 
								Trade_Date=CONVERT(VARCHAR,S.Sauda_date,103), 
								Scrip_Cd = S.Scrip_Cd, 
								S.Series,
								S2.NoofIssuedshares,
								Partyname = c1.Long_name,
								trade_price=SUM(s.tradeqty*s.MarketRate)/SUM(s.tradeqty),
								type=CASE Sell_Buy WHEN '2' THEN 'S' ELSE 'P' END, 
								ScripName = S1.Short_Name,
								Sell_Buy, 
								qty=SUM(s.tradeqty) 
					FROM 
						  	 owner,
							 ISettlement S, 
							 Scrip1 S1, 
							 Scrip2 S2, 
							 client1 c1, 
							 client2 c2,
							 Sett_Mst M  
					WHERE 
							S2.Series = S1.Series 
							And S2.Scrip_Cd = S.Scrip_CD 
							And S2.Series = S.Series 
							and c1.cl_code = c2.cl_code 
							And S.Sett_No = M.Sett_No 
							And S.Sett_Type = M.Sett_Type 
							and s.party_code = c2.party_code 
							And S1.Co_Code = S2.Co_Code 
							and S2.NoofIssuedshares > 0 
							   and CONVERT(VARCHAR(11),s.Sauda_Date,109)=Convert(varchar(11), convert(datetime, @saudadate,103), 109)
								AND SELL_BUY LIKE CASE @Group WHEN 'SELL' THEN '2' WHEN 'BUY' THEN '1' ELSE '%' END	
							   AND S.Scrip_CD between @FromScripCode And  @ToScripCode 
								AND C1.Family BETWEEN @FromPartyCode AND @ToPartyCode 
						
					GROUP BY 
							C1.Family, 
							CONVERT(VARCHAR,S.Sauda_date,103), 
							S.Scrip_Cd, 
							S.Series,S2.NoofIssuedshares, 
							S1.Short_Name, 
							Sell_Buy,membercode,
							c1.Long_name 
					HAVING SUM(s.tradeqty)*100/S2.NoofIssuedshares > CONVERT(Decimal,@strpaid)

END

GO
