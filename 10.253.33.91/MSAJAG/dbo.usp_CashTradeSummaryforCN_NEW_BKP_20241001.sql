-- Object: PROCEDURE dbo.usp_CashTradeSummaryforCN_NEW_BKP_20241001
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------






/* =============================================
 Author:		SIVA KUMAR
 Create date: MAY 11, 2022
 Description:	Trade summary data fetch


 exec usp_CashTradeSummaryforCN 'M127841','M127841','Mar 06 2019','Mar 06 2019'
 exec usp_CashTradeSummaryforCN 'A100031','A100031','Apr 08 2019','Apr 08 2019'
 exec usp_CashTradeSummaryforCN 'AGRA4918','AGRA4918','Apr 08 2019','Apr 08 2019'

 =============================================*/

CREATE PROCEDURE [dbo].[usp_CashTradeSummaryforCN_NEW_BKP_20241001] 
				@Frompartycode varchar(20), @Topartycode varchar(20), @FromDate varchar(20), @ToDate varchar(20)
AS
	BEGIN

		DECLARE @Date varchar(50);

		SET @Date = LEFT(LTRIM(RTRIM(CAST(@FromDate AS datetime))), 11);


		CREATE TABLE #Temp
		( 
					 Trade_Type varchar(20) NOT NULL, EXCHANGE varchar(10) NOT NULL, SETT_NO varchar(20) NULL, PARTY_CODE varchar(10) NULL,
					 SAUDA_DATE date NULL, TRD_DT varchar(11) NULL, SCRIP_CD varchar(8000) NULL, SCRIPName varchar(8000) NULL, Buy_qty int NULL, 
					 BuyMarketRate money NULL, Sell_qty int NULL, SellMarketRate money NULL, BROKERAGE money NULL, STT money NULL, Other_charges money NULL,
					 TO_TAX money NULL, SEBI_TAX money NULL, STAMPDUTY money NULL, SER_TAX money NULL, BILLFLAG int NOT NULL, Grand_Total money NULL,
					 Long_Name varchar(8000), Address varchar(8000), Branch_Cd varchar(800), pan_gir_no varchar(80), Period varchar(800), ReportDate varchar(80),
					 OrderPriority bigint
		);



		INSERT INTO #Temp( Trade_Type, EXCHANGE, SETT_NO, PARTY_CODE, SAUDA_DATE, TRD_DT, SCRIP_CD, SCRIPName, Buy_qty, BuyMarketRate, Sell_qty, SellMarketRate, BROKERAGE, STT, Other_charges, TO_TAX, SEBI_TAX, STAMPDUTY, SER_TAX, BILLFLAG, Grand_Total )
			   SELECT Trade_Type, EXCHANGE, SETT_NO, PARTY_CODE, SAUDA_DATE, TRD_DT, SCRIP_CD, SCRIPName, Buy_qty, BuyMarketRate, Sell_qty, SellMarketRate, BROKERAGE, STT, Other_charges, TO_TAX, SEBI_TAX, STAMPDUTY, SER_TAX, BILLFLAG, Grand_Total
			   FROM vw_NSESauda
			   WHERE PARTY_CODE >= @Frompartycode AND 
					 PARTY_CODE <= @Topartycode AND 
					 SAUDA_DATE = @Date;

		INSERT INTO #Temp( Trade_Type, EXCHANGE, SETT_NO, PARTY_CODE, SAUDA_DATE, TRD_DT, SCRIP_CD, SCRIPName, Buy_qty, BuyMarketRate, Sell_qty, SellMarketRate, BROKERAGE, STT, Other_charges, TO_TAX, SEBI_TAX, STAMPDUTY, SER_TAX, BILLFLAG, Grand_Total )
			   SELECT Trade_Type, EXCHANGE, SETT_NO, PARTY_CODE, SAUDA_DATE, TRD_DT, SCRIP_CD, SCRIPName, Buy_qty, BuyMarketRate, Sell_qty, SellMarketRate, BROKERAGE, STT, Other_charges, TO_TAX, SEBI_TAX, STAMPDUTY, SER_TAX, BILLFLAG, Grand_Total
			   FROM AngelBSECM.BSEDB_AB.DBO.vw_BSESauda
			   WHERE PARTY_CODE >= @Frompartycode AND 
					 PARTY_CODE <= @Topartycode AND 
					 SAUDA_DATE = @Date;

		UPDATE #temp
		  SET SCRIPName = m.SCRIPName
		FROM #temp, mimansa.angelcs.dbo.angelscrip m WITH(NOLOCK)
		WHERE #temp.SCRIP_CD = m.SCRIP_CD AND 
			  EXCHANGE = 'BSECM';

		UPDATE #temp
		  SET SCRIPName = m.SCRIPName
		FROM #temp, mimansa.angelcs.dbo.angelscrip m WITH(NOLOCK)
		WHERE #temp.SCRIP_CD = m.nsescrip_cd AND 
			  M.NseSeries = 'EQ' AND 
			  EXCHANGE = 'NSECM';

		UPDATE #temp
		  SET SCRIPName = SCRIP_CD
		WHERE ISNULL(SCRIPName, '') = '';

		UPDATE #temp
		  SET OrderPriority = 0;



		UPDATE #temp
		  SET SCRIPName = CASE
						  WHEN Trade_Type = 'Trading' THEN SCRIPName+' ('+Trade_Type+')'
						  WHEN Trade_Type = 'Delivery' THEN SCRIPName+' ('+Trade_Type+')'
						  WHEN Trade_Type = 'Auction' THEN SCRIPName+' ('+Trade_Type+')'
						  WHEN Trade_Type = 'S' THEN SCRIPName+' (Delivery)'
						  ELSE SCRIPName
						  END;


		
/* Added below 1st update by dinesh jadhav to update Additional brokerage of scrip_cd type BRKSCR */
		UPDATE #temp SET SCRIP_CD = 'BROKERAGE'
		WHERE SCRIP_CD = 'BRKSCR';


		UPDATE #temp
		  SET SCRIPName = '**Additional Brokerage**', OrderPriority = 1
		WHERE SCRIP_CD = 'BROKERAGE';



		UPDATE #temp
		  SET Period = UPPER(@Date+' To '+@Date);

		UPDATE #temp
		  SET ReportDate = @Date;

		UPDATE #temp
		  SET #Temp.Long_Name = c.Long_Name, #Temp.Address = c.L_Address1+', '+c.L_Address2+', '+c.L_Address3+', '+c.L_City+', '+c.L_Zip+' '+c.L_State+', '+c.L_Nation, #Temp.Branch_Cd = c.Branch_Cd, #Temp.pan_gir_no = c.pan_gir_no
		FROM client_details  c
		WHERE #temp.Party_code = C.Party_code;

		/* Below Delete logic added By dinesh on 03 Mar 2020 as suggested by Siva Sir showing Auction trade and charges zero*/
		DELETE FROM #temp where buymarketrate=0 and SellMarketRate=0 and SCRIPName not like '%Additional Brokerage%'
		and BROKERAGE=0 and STT=0 and Other_charges=0 and Grand_Total=0



		Truncate table Tbl_CashTradeSummaryforCN
	    insert into Tbl_CashTradeSummaryforCN

		SELECT * FROM #temp ORDER BY EXCHANGE,OrderPriority, SCRIPName


	
	

	END;

GO
