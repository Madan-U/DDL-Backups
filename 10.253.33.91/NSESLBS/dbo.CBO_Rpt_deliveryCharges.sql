-- Object: PROCEDURE dbo.CBO_Rpt_deliveryCharges
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE PROC  CBO_Rpt_deliveryCharges
			(          
					@StatusId VARCHAR(15),          
					@StatusName VARCHAR(25),          
					@fromDate VARCHAR(11),           
					@toDate VARCHAR(11),           
					@SlipType VARCHAR(2),          
					@Branch VARCHAR(10) 
			)          
			AS          

			SET @fromDate = CONVERT(CHAR(11), CONVERT(DateTime, @fromDate, 103), 109)
			SET @toDate = CONVERT(CHAR(11), CONVERT(DateTime, @toDate, 103), 109)


			IF @Branch = 'All' OR LEN(@BRANCH) = 0   
				SELECT @Branch = '%'          
			          
			SELECT 
			sett_type,
			sett_no,details =(CASE WHEN trtype = 907  THEN isett_no + '-' + ISett_Type  WHEN trtype in (904,905) THEN (CASE WHEN dpid Like 'IN%' THEN dpid + cltdpid  ELSE cltdpid END) ELSE '' END),        
			dp.Party_Code, 
			scrip_cd, 
			TransDate = CONVERT(VARCHAR,TransDate,103), charge_scope, charge_type,           
			Qty, 
			scrip_closing_rate, 
			Depos_fixed_charges,
			Flat_charge, 
			min_charge, 
			percentage_charge, 
			totalcharges,           
			InternalSlipType = (CASE  WHEN InternalSlipType = 'IS' THEN 'Inter Settlement'           
							              WHEN InternalSlipType = 'PO' THEN 'Pay Out'           
							              WHEN InternalSlipType = 'BP' THEN 'Bene to Pool'           
							              WHEN InternalSlipType = 'PB' THEN 'Pool to Bene'           
							              WHEN InternalSlipType = 'OM' THEN 'Off Market'           
							              ELSE 'NONE' END ),          
							        
			Service_Tax          
			FROM 
					DeliveryDPChargesFinalAmount dp,
					client1 c1,
					client2 c2           
			WHERE 
					c1.cl_code = c2.cl_code and c2.party_code = dp.party_code           
					and dp.transdate >= @FromDate And dp.transdate <= @ToDate           
					And C1.Branch_Cd Like (CASE WHEN @StatusId = 'branch' THEN @statusname ELSE '%' END)          
					And C1.Sub_broker Like (CASE WHEN @StatusId = 'subbroker' THEN @statusname ELSE '%' END)          
					And C1.Trader Like (CASE WHEN @StatusId = 'trader' THEN @statusname ELSE '%' END)          
					And C1.Family Like (CASE WHEN @StatusId = 'family' THEN @statusname ELSE '%' END)          
					And C2.Party_Code Like (CASE WHEN @StatusId = 'client' THEN @statusname ELSE '%' END)          
					And C1.Branch_Cd Like @Branch          
					And InternalSlipType Like @SlipType          
			ORDER BY 
					dp.party_code,
					InternalSlipType,
					YEAR(TransDate),
					MONTH(TransDate),
					DAY(TransDate),
					Sett_No, 
					Sett_Type

GO
