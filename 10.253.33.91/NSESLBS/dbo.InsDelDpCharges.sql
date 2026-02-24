-- Object: PROCEDURE dbo.InsDelDpCharges
-- Server: 10.253.33.91 | DB: NSESLBS
--------------------------------------------------


CREATE Proc InsDelDpCharges
(
	@dtFromDate Varchar(11), 
	@dtToDate Varchar(11), 
	@ProcessFlag Varchar(2), 
	@UName Varchar(30)
)                
AS                
BEGIN
                
	Truncate Table tempDpChargeCalculation                 

	Delete From DeliveryDPChargesFinalAmount Where                 
	transdate >= @dtFromDate                
	and transdate <= @dtToDate                
	And InternalSlipType = @ProcessFlag                

	If @ProcessFlag = 'IS'  -- Inter Settlement                
	Begin                
		Insert into tempDpChargeCalculation                 
		select sett_no,sett_type,refno,trtype,party_code,scrip_cd,series,                
		Qty=Sum(qty),certno,dptype='',dpid='',cltdpid='',                
		dl.bdptype,dl.bdpid,dl.bcltdpid,TransDate=Left(Convert(Varchar,TransDate,109),11),  
		Cl_Rate=Convert(Numeric(18,4),0),ISett_No, ISett_Type,                
		'','',0,0,0,0,0,'','IS', Service_tax = 0                
		from deltrans dl,deliverydp dp where                 
		dp.dptype = dl.bdptype                 
		and dp.dpid = dl.bdpid                 
		and dp.dpcltno = dl.bcltdpid                 
		and transdate >= @dtFromDate                
		and transdate <= @dtToDate                
		and drcr = 'D'                   
		and party_code not in  ('BROKER','EXE')                 
		and trType <> '906'                  
		And Delivered In ('G','D')                 
		and filler2 = 1                 
		and trType in ('907','908')                 
		And CertNo Like 'IN%'                
		and description like '%POOL%'                
		Group By sett_no,sett_type,refno,trtype,party_code,scrip_cd,series,certno,dl.bdptype,                
		dl.bdpid,dl.bcltdpid,Left(Convert(Varchar,TransDate,109),11),ISett_No, ISett_Type                
		                
		Update tempDpChargeCalculation Set                 
		charge_scope = DP.charge_scope,                 
		charge_type = DP.charge_type,                
		depos_fixed_charges = DP.depos_fixed_charges,                
		flat_charge = DP.flat_charge,                
		min_charge = DP.min_charge,                
		percentage_charge = DP.percentage_charge,                
		SlipType = slip_type                
		from dpcharges DP where DP.charge_scope ='G'                
		and depos_cd = BDpType                
		and trans_type = 907                
		and slip_type = (Case When Sett_Type in ('N', 'W', 'A') And ISett_Type in ('N', 'W', 'A')   
		        Then 'IS'  
		        When Sett_Type in ('D', 'C', 'AD') And ISett_Type in ('D', 'C', 'AD')  
		        Then 'IS'   
		        Else 'CC'  
		   End)   
		AND TRANSDATE BETWEEN Effective_Datefrom AND Effective_Dateto          
		                
		Update tempDpChargeCalculation Set                 
		charge_scope = DP.charge_scope,                 
		charge_type = DP.charge_type,                
		depos_fixed_charges = DP.depos_fixed_charges,                
		flat_charge = DP.flat_charge,                
		min_charge = DP.min_charge,                
		percentage_charge = DP.percentage_charge,                
		SlipType = slip_type                
		from dpcharges DP where                 
		depos_cd = BDpType                
		and trans_type = 907                
		and slip_type = (Case When BDpType = 'NSDL' Then 'IS' Else 'IS' End)                
		AND TRANSDATE BETWEEN Effective_Datefrom AND Effective_Dateto          
		And DP.Party_Code = tempDpChargeCalculation.Party_Code                
	End                
	  
	If @ProcessFlag = 'PO'  -- POOL To Client Payout   
	Begin                
		Insert into tempDpChargeCalculation                 
		select sett_no='',sett_type='',refno,trtype,party_code,scrip_cd,series,                
		Qty=Sum(qty),certno,DL.dptype,DL.dpid,DL.cltdpid,                
		dl.bdptype,dl.bdpid,dl.bcltdpid,TransDate=Left(Convert(Varchar,TransDate,109),11),Cl_Rate=Convert(Numeric(18,4),0),'','',                
		'','',0,0,0,0,0,'','PO', Service_tax = 0                
		from deltrans dl,deliverydp dp where                 
		dp.dptype = dl.bdptype                 
		and dp.dpid = dl.bdpid                 
		and dp.dpcltno = dl.bcltdpid   
		and transdate >= @dtFromDate                
		and transdate <= @dtToDate                
		and drcr = 'D'                   
		and party_code not in  ('BROKER','EXE')                 
		and trType <> '906'                  
		And Delivered = 'D'                
		And HolderName Like 'PAY-OUT%'                
		and filler2 = 1                 
		and trType in ('904','905')                 
		And CertNo Like 'IN%'                
		and description like '%POOL%'                
		Group By refno,trtype,party_code,scrip_cd,series,certno,DL.dptype,DL.dpid,DL.cltdpid,                
		dl.bdptype,dl.bdpid,dl.bcltdpid,Left(Convert(Varchar,TransDate,109),11)                
		                
		Update tempDpChargeCalculation Set                 
		charge_scope = DP.charge_scope,                 
		charge_type = DP.charge_type,                
		depos_fixed_charges = DP.depos_fixed_charges,                
		flat_charge = DP.flat_charge,                
		min_charge = DP.min_charge,                
		percentage_charge = DP.percentage_charge,                
		SlipType = slip_type                
		from dpcharges DP where DP.charge_scope ='G'                
		and depos_cd = BDpType                
		and trans_type = 904                
		and slip_type = (Case When BDpType = 'NSDL' And DpType = 'NSDL'                 
		              Then 'PC'                 
		              When BDpType = 'NSDL' And DpType = 'CDSL'                 
		              Then 'PD'                 
		              When BDpType = 'CDSL' And DpType = 'NSDL'       
		              Then 'PD'                 
		              When BDpType = 'CDSL' And DpType = 'CDSL'                 
		              Then 'PC'                 
		          END)                
		AND TRANSDATE BETWEEN Effective_Datefrom AND Effective_Dateto          
		                
		Update tempDpChargeCalculation Set                 
		charge_scope = DP.charge_scope,                 
		charge_type = DP.charge_type,                
		depos_fixed_charges = DP.depos_fixed_charges,                
		flat_charge = DP.flat_charge,                
		min_charge = DP.min_charge,                
		percentage_charge = DP.percentage_charge,                
		SlipType = slip_type                
		from dpcharges DP where                 
		depos_cd = BDpType                
		and trans_type = 904                
		and slip_type = (Case When BDpType = 'NSDL' And DpType = 'NSDL'                 
		              Then 'PC'                 
		              When BDpType = 'NSDL' And DpType = 'CDSL'                 
		              Then 'PD'                 
		              When BDpType = 'CDSL' And DpType = 'NSDL'       
		              Then 'PD'                 
		              When BDpType = 'CDSL' And DpType = 'CDSL'                 
		              Then 'PC'                 
		          END)          
		AND TRANSDATE BETWEEN Effective_Datefrom AND Effective_Dateto          
		And DP.Party_Code = tempDpChargeCalculation.Party_Code                
	End                
	  
	If @ProcessFlag = 'PB'  -- POOL To Ben  
	Begin                
		Insert into tempDpChargeCalculation                 
		select sett_no='',sett_type='',refno,trtype,party_code,scrip_cd,series,                
		Qty=Sum(qty),certno,DL.dptype,DL.dpid,DL.cltdpid,                
		dl.bdptype,dl.bdpid,dl.bcltdpid,TransDate=Left(Convert(Varchar,TransDate,109),11),Cl_Rate=Convert(Numeric(18,4),0),'','',                
		'','',0,0,0,0,0,'','PB', Service_tax = 0                
		from deltrans dl,deliverydp dp where                 
		dp.dptype = dl.bdptype                 
		and dp.dpid = dl.bdpid                 
		and dp.dpcltno = dl.bcltdpid                 
		and transdate >= @dtFromDate                
		and transdate <= @dtToDate                
		and drcr = 'D'                   
		and party_code not in  ('BROKER','EXE')                 
		and trType <> '906'                  
		And Delivered = 'G'                
		and filler2 = 0                 
		and trType in ('904','905')                 
		And CertNo Like 'IN%'                
		and description like '%POOL%'                
		And HolderName Like 'Ben%'  
		Group By refno,trtype,party_code,scrip_cd,series,certno,DL.dptype,DL.dpid,DL.cltdpid,                
		dl.bdptype,dl.bdpid,dl.bcltdpid,Left(Convert(Varchar,TransDate,109),11)                
		                
		Update tempDpChargeCalculation Set                 
		charge_scope = DP.charge_scope,                 
		charge_type = DP.charge_type,                
		depos_fixed_charges = DP.depos_fixed_charges,                
		flat_charge = DP.flat_charge,                
		min_charge = DP.min_charge,                
		percentage_charge = DP.percentage_charge,                
		SlipType = slip_type                
		from dpcharges DP where DP.charge_scope ='G'                
		and depos_cd = BDpType                
		and trans_type = 904                
		and slip_type = 'DC'  
		AND TRANSDATE BETWEEN Effective_Datefrom AND Effective_Dateto          
		                
		Update tempDpChargeCalculation Set                 
		charge_scope = DP.charge_scope,                 
		charge_type = DP.charge_type,                
		depos_fixed_charges = DP.depos_fixed_charges,                
		flat_charge = DP.flat_charge,                
		min_charge = DP.min_charge,                
		percentage_charge = DP.percentage_charge,                
		SlipType = slip_type                
		from dpcharges DP where                 
		depos_cd = BDpType                
		and trans_type = 904                
		and slip_type = 'DC'  
		AND TRANSDATE BETWEEN Effective_Datefrom AND Effective_Dateto          
		And DP.Party_Code = tempDpChargeCalculation.Party_Code                
	End     
	                
	If  @ProcessFlag = 'BP'  -- Ben To Pool                
	Begin                
		Insert into tempDpChargeCalculation                 
		select isett_no,isett_type,refno,trtype,party_code,scrip_cd,series,                
		Qty=Sum(qty),certno,DL.dptype,DL.dpid,DL.cltdpid,                
		dl.bdptype,dl.bdpid,dl.bcltdpid,TransDate=Left(Convert(Varchar,TransDate,109),11),Cl_Rate=Convert(Numeric(18,4),0),'','',                
		'','',0,0,0,0,0,'','BP', Service_tax = 0                
		from deltrans dl,deliverydp dp where                 
		dp.dptype = dl.bdptype                 
		and dp.dpid = dl.bdpid                 
		and dp.dpcltno = dl.bcltdpid                 
		and transdate >= @dtFromDate                
		and transdate <= @dtToDate                
		and drcr = 'D'                   
		and party_code not in  ('BROKER','EXE')                 
		and trType <> '906'                  
		And Delivered In ('G','D')                 
		and filler2 = 1                 
		and trType in ('1000')                 
		And CertNo Like 'IN%'                
		and description Not  like '%POOL%'                
		Group By ISett_No, ISett_Type,refno,trtype,party_code,scrip_cd,series,certno,DL.dptype,DL.dpid,DL.cltdpid,                
		dl.bdptype,dl.bdpid,dl.bcltdpid,Left(Convert(Varchar,TransDate,109),11)                
		                
		Update tempDpChargeCalculation Set                 
		charge_scope = DP.charge_scope,                 
		charge_type = DP.charge_type,                
		depos_fixed_charges = DP.depos_fixed_charges,                
		flat_charge = DP.flat_charge,                
		min_charge = DP.min_charge,        percentage_charge = DP.percentage_charge,                
		SlipType = slip_type                
		from dpcharges DP where DP.charge_scope ='G'                
		and depos_cd = BDpType                
		and trans_type in (1000, 904)              
		and slip_type = (Case When BDpType = 'NSDL'               
		              Then 'DI'                 
		 When BDpType = 'CDSL'               
		              Then 'DI'                 
		          END)                
		AND TRANSDATE BETWEEN Effective_Datefrom AND Effective_Dateto       
		               
		Update tempDpChargeCalculation Set                 
		charge_scope = DP.charge_scope,                 
		charge_type = DP.charge_type,                
		depos_fixed_charges = DP.depos_fixed_charges,                
		flat_charge = DP.flat_charge,                
		min_charge = DP.min_charge,                
		percentage_charge = DP.percentage_charge,                
		SlipType = slip_type                
		from dpcharges DP where               
		depos_cd = BDpType                
		and trans_type in (1000, 904)              
		and slip_type = (Case When BDpType = 'NSDL'               
		              Then 'DI'                 
		              When BDpType = 'CDSL'               
		              Then 'DI'                 
		          END)                
		AND TRANSDATE BETWEEN Effective_Datefrom AND Effective_Dateto          
		And DP.Party_Code = tempDpChargeCalculation.Party_Code                
	End                
	         
	               
	If @ProcessFlag = 'OM'  -- Ben To Client Payout Off Market                
	Begin                
		Insert into tempDpChargeCalculation                 
		select sett_no='',sett_type='',refno,trtype,party_code,scrip_cd,series,                
		Qty=Sum(qty),certno,DL.dptype,DL.dpid,DL.cltdpid,                
		dl.bdptype,dl.bdpid,dl.bcltdpid,TransDate=Left(Convert(Varchar,TransDate,109),11),Cl_Rate=Convert(Numeric(18,4),0),'','',                
		'','',0,0,0,0,0,'','OM', Service_tax = 0                
		from deltrans dl,deliverydp dp where                 
		dp.dptype = dl.bdptype                 
		and dp.dpid = dl.bdpid                 
		and dp.dpcltno = dl.bcltdpid                 
		and transdate >= @dtFromDate                
		and transdate <= @dtToDate                
		and drcr = 'D'                   
		and party_code not in  ('BROKER','EXE')                 
		and trType <> '906'                  
		And Delivered = 'D'                
		And HolderName Like 'PAY-OUT%'                
		and filler2 = 1                 
		and trType in ('904','905')                 
		And CertNo Like 'IN%'                
		and description Not like '%POOL%'                
		Group By refno,trtype,party_code,scrip_cd,series,certno,DL.dptype,DL.dpid,DL.cltdpid,                
		dl.bdptype,dl.bdpid,dl.bcltdpid,Left(Convert(Varchar,TransDate,109),11)                
		                
		Update tempDpChargeCalculation Set                 
		charge_scope = DP.charge_scope,                 
		charge_type = DP.charge_type,                
		depos_fixed_charges = DP.depos_fixed_charges,                
		flat_charge = DP.flat_charge,                
		min_charge = DP.min_charge,                
		percentage_charge = DP.percentage_charge,                
		SlipType = slip_type                
		from dpcharges DP where DP.charge_scope ='G'                
		and depos_cd = BDpType                
		and trans_type = 904                
		and slip_type = (Case When BDpType = 'NSDL' And DpType = 'NSDL'                 
		              Then 'BC'                 
		              When BDpType = 'NSDL' And DpType = 'CDSL'                 
		              Then 'BD'                 
		              When BDpType = 'CDSL' And DpType = 'NSDL'       
		              Then 'BD'                 
		              When BDpType = 'CDSL' And DpType = 'CDSL'                 
		              Then 'BC'                 
		          END)                
		AND TRANSDATE BETWEEN Effective_Datefrom AND Effective_Dateto          
		                
		Update tempDpChargeCalculation Set                 
		charge_scope = DP.charge_scope,                 
		charge_type = DP.charge_type,                
		depos_fixed_charges = DP.depos_fixed_charges,                
		flat_charge = DP.flat_charge,                
		min_charge = DP.min_charge,                
		percentage_charge = DP.percentage_charge,                
		SlipType = slip_type                
		from dpcharges DP where                 
		depos_cd = BDpType                
		and trans_type = 904                
		and slip_type = (Case When BDpType = 'NSDL' And DpType = 'NSDL'                 
		              Then 'BC'                 
		              When BDpType = 'NSDL' And DpType = 'CDSL'                 
		              Then 'BD'                 
		              When BDpType = 'CDSL' And DpType = 'NSDL'                 
		              Then 'BD'                 
		              When BDpType = 'CDSL' And DpType = 'CDSL'                 
		              Then 'BC'            
		          END)                
		AND TRANSDATE BETWEEN Effective_Datefrom AND Effective_Dateto          
		And DP.Party_Code = tempDpChargeCalculation.Party_Code                
		                
	End                
	    
	                
	Update  tempDpChargeCalculation Set Cl_Rate = IsNull(C.Cl_Rate,0)                 
	from msajag.dbo.closing C                 
	where sysdate = (select max(sysdate) from msajag.dbo.closing C1                 
	             Where C1.scrip_cd = C.Scrip_Cd                
	           And C1.series = C.series                 
	           And SysDate <= Convert(DateTime,TransDate) + 1)                 
	and C.scrip_cd = tempDpChargeCalculation.Scrip_Cd                 
	and C.series = tempDpChargeCalculation.Series                 
	                
	Update  tempDpChargeCalculation                 
	Set Amount = (Case When charge_type = 'F'                 
	               Then depos_fixed_charges + flat_charge                 
	             Else (Case When min_charge > ( Qty * Cl_Rate ) * percentage_charge / 100                
	                                                   Then depos_fixed_charges + min_charge                 
	                 Else depos_fixed_charges + ( Qty * Cl_Rate ) * percentage_charge / 100                
	                End )                
	          End )                
	  
	Update tempDpChargeCalculation Set Service_Tax = Amount * G.Service_Tax / 100  
	From msajag.dbo.Globals G  
	Where TransDate Between Year_Start_Dt And Year_End_Dt  
	  
	Insert Into DeliveryDPChargesFinalAmount                
	Select sett_no,sett_type,refno,trtype,party_code,scrip_cd,series,qty,certno,dptype,                
	dpid,cltdpid,bdptype,bdpid,bcltdpid,0,transdate,charge_scope,charge_type,Depos_Fixed_Charges,                
	Flat_Charge,Min_Charge,Percentage_Charge,Cl_Rate,Amount,SlipType,                
	@UName,GetDate(),'N',Isett_no,Isett_type,InternalSlipType,  
	Service_Tax From tempDpChargeCalculation  
	  
END

GO
