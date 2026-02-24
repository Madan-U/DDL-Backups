-- Object: PROCEDURE dbo.SB_RESG
-- Server: 10.253.33.91 | DB: MSAJAG
--------------------------------------------------

CREATE PROC [dbo].[SB_RESG]  
AS  
  
SELECT  SBTAG,BRANCH,TRADENAME,CONVERT(VARCHAR(10),TAGGENERATEDDATE,120) AS TAGGENERATEDDATE   
 INTO #DATA  
 FROM [MIS].SB_COMP.DBO.SB_BROKER WITH (NOLOCK)  
 WHERE ORGTYPE IN ('CO','I','P','PF')  
 AND  CONVERT(VARCHAR(10),TAGGENERATEDDATE,120)  >= CONVERT(VARCHAR(10),DATEADD(MONTH, -6, GETDATE()) ,120)  
  
  
  SELECT c,sub_broker INTO  #D FROM   
 (select count(1) AS c ,sub_broker from (  
 select distinct sub_broker,b.cl_code from Client_Details B WITH (NOLOCK),Client_brok_Details C WITH (NOLOCK)  
 Where  b.cl_code =c.Cl_Code  
 and sub_broker in (select SBTAG from #DATA WITH (NOLOCK))  
 and Active_Date >= CONVERT(VARCHAR(10),DATEADD(MONTH, -1, GETDATE()) ,120) and Active_Date <=  CONVERT(VARCHAR(10), GETDATE()-1 ,120)  
 and B.cl_code not like '05%' )a  
 group by sub_broker)A   
 WHERE c > 15  
  
 TRUNCATE  TABLE ATTACHEDDATA  
  
 -----------------attachment  
 INSERT INTO ATTACHEDDATA  
 select  DISTINCT CONVERT(varchar(10),TAGGeneratedDate,120) TAGGeneratedDate ,Branch,SBTAG,TradeName,B.cl_code,long_name,CONVERT(varchar(10),Active_Date,120) as cl_Active_Date,l_city AS Cl_city,l_state AS Cl_state  
 from [MIS].sb_comp.dbo.sb_broker A with (nolock),Client_Details B with (nolock),Client_brok_Details C with (nolock)  
 where orgtype in ('CO','I','P','PF')  
 AND SB_Broker_type is NULL   
 AND sub_broker  IN (SELECT sub_broker FROM #D WITH (NOLOCK))  
 AND  CONVERT(varchar(10),TAGGeneratedDate,120) >= CONVERT(varchar(10),getdate()-185,120)  
 AND Active_Date >= CONVERT(VARCHAR(10),DATEADD(MONTH, -1, GETDATE()) ,120) AND Active_Date <=  CONVERT(VARCHAR(10), GETDATE()-1 ,120)  
 AND  a.SBTAG = b.sub_broker  
 AND b.cl_code =c.Cl_Code  
 ORDER BY SBTAG,B.cl_code  
   
   
 select  SBTAG,Branch,TradeName,CONVERT(varchar(10),TAGGeneratedDate,120) as TAGGeneratedDate    
 INTO #REP  from [MIS].sb_comp.dbo.sb_broker WITH (NOLOCK)  
 where orgtype in ('CO','I','P','PF')  
 AND SB_Broker_type is NULL   
 AND  CONVERT(varchar(10),TAGGeneratedDate,120)  >= CONVERT(varchar(10),getdate()-185,120)  
 AND SBTAG  IN (SELECT sub_broker FROM #D)  
  
   
 --SELECT DISTINCT COUNT(A.cl_code)AS c ,MONTH(Active_Date)AS M,sub_broker FROM Client_Details A WITH (NOLOCK),CLIENT_BROK_DETAILS B wITH (NOLOCK)  
 --WHERE A.cl_code = B.Cl_Code  
 --AND sub_broker in (select sub_broker from #D WITH (NOLOCK))  
 --AND Active_Date >= CONVERT(VARCHAR(10),DATEADD(MONTH, -2, GETDATE()) ,120)   
 --AND Active_Date <=  CONVERT(VARCHAR(10), GETDATE()-1 ,120)  
 --GROUP BY MONTH(Active_Date),sub_broker   
 --ORDER BY sub_broker,MONTH(Active_Date) DESC  
   
 SELECT COUNT(sub_broker) C , MONTH(D) [MON],sub_broker  INTO #PIV FROM (  
 SELECT DISTINCT A.cl_code , sub_broker,MAX(CONVERT(VARCHAR(10), Active_Date,120)) AS D FROM   
 Client_Details A WITH (NOLOCK),CLIENT_BROK_DETAILS B wITH (NOLOCK)  
 WHERE A.cl_code = B.Cl_Code  
 AND sub_broker in (select sub_broker from #D WITH (NOLOCK))  
 AND Active_Date >= CONVERT(VARCHAR(10),DATEADD(MONTH, -3, GETDATE()) ,120)   
 AND Active_Date <=  CONVERT(VARCHAR(10), GETDATE()-1 ,120)  
 GROUP BY MONTH(Active_Date),sub_broker,A.cl_code )A  
 GROUP BY MONTH(D),sub_broker  
 ORDER BY  MONTH(D)  DESC  
  
 --SELECT SBTAG,Branch,TradeName,TAGGeneratedDate,C,MON  
 -- FROM #REP,#PIV  
 --WHERE sub_broker = SBTAG  
 --ORDER BY sub_broker,MON  
  
  
 SELECT SBTAG,Branch,TradeName,TAGGeneratedDate,C,  
 (CASE   
  WHEN MON = 1 THEN 'JAN'  
  WHEN MON = 2 THEN 'FEB'  
  WHEN MON = 3 THEN 'MAR'  
  WHEN MON = 4 THEN 'APR'  
  WHEN MON = 5 THEN 'MAY'  
  WHEN MON = 6 THEN 'JUN'  
  WHEN MON = 7 THEN 'JUL'  
  WHEN MON = 8 THEN 'AUG'  
  WHEN MON = 9 THEN 'SEP'  
  WHEN MON = 10 THEN 'OCT'  
  WHEN MON = 11 THEN 'NOV'  
  WHEN MON = 12 THEN 'DEC'   
 ELSE 'INVALID MONTH' END ) [MONTH]  
 into #GOT  
  FROM #REP,#PIV  
 WHERE sub_broker = SBTAG  
 ORDER BY sub_broker,MON  
  
  
 SELECT   
 SBTAG,Branch,TradeName,TAGGeneratedDate,[DEC],[NOV],[OCT],[SEP],[AUG],[JUL],[JUN],[MAY],[APR],[MAR],[FEB],[JAN]  
  INTO #DAT FROM #GOT  
  A   
 PIVOT  
 (  
 SUM(C)  
 FOR [MONTH]  
 IN ([DEC],[NOV],[OCT],[SEP],[AUG],[JUL],[JUN],[MAY],[APR],[MAR],[FEB],[JAN])  
 ) AS PIVOTTABLE  
 ORDER BY [DEC],[NOV],[OCT],[SEP],[AUG],[JUL],[JUN],[MAY],[APR],[MAR],[FEB],[JAN] DESC  
  
 --ALTER TABLE #DAT ADD FEB INT   
  
 DECLARE @JAN INT  
 DECLARE @FEB INT  
 DECLARE @MAR INT  
 DECLARE @APR INT  
 DECLARE @MAY INT  
 DECLARE @JUN INT  
 DECLARE @JUL INT  
 DECLARE @AUG INT  
 DECLARE @SEP INT  
 DECLARE @OCT INT  
 DECLARE @NOV INT  
 DECLARE @DEC INT  
   
 --ALTER TABLE #DAT  
 --ALTER COLUMN JAN INT  
 SELECT  @JAN = COUNT(JAN) FROM #DAT   
 SELECT  @FEB = COUNT(FEB) FROM #DAT   
 SELECT  @MAR = COUNT(MAR) FROM #DAT   
 SELECT  @APR = COUNT(APR) FROM #DAT   
 SELECT  @MAY = COUNT(MAY) FROM #DAT  
 SELECT  @JUN = COUNT(JUN) FROM #DAT  
 SELECT  @JUL = COUNT(JUL) FROM #DAT  
 SELECT  @AUG = COUNT(AUG) FROM #DAT  
 SELECT  @SEP = COUNT(SEP) FROM #DAT  
 SELECT  @OCT = COUNT(OCT) FROM #DAT  
 SELECT  @NOV = COUNT(NOV) FROM #DAT  
 SELECT  @DEC = COUNT(DEC) FROM #DAT  
   
IF  @JAN = 0  
  BEGIN   
    ALTER TABLE #DAT DROP COLUMN JAN  
   END  
   
IF  @FEB = 0  
  BEGIN   
    ALTER TABLE #DAT DROP COLUMN FEB  
   END  
    
IF  @MAR = 0  
  BEGIN   
    ALTER TABLE #DAT DROP COLUMN MAR  
   END  
    
IF  @APR = 0  
  BEGIN   
    ALTER TABLE #DAT DROP COLUMN APR  
   END  
    
IF  @MAY = 0  
  BEGIN   
    ALTER TABLE #DAT DROP COLUMN MAY  
   END  
   
IF  @JUN = 0  
  BEGIN   
    ALTER TABLE #DAT DROP COLUMN JUN  
   END  
   
IF  @JUL = 0  
  BEGIN   
    ALTER TABLE #DAT DROP COLUMN JUL  
   END  
    
IF  @AUG = 0  
  BEGIN   
    ALTER TABLE #DAT DROP COLUMN AUG  
   END  
   
IF  @SEP = 0  
  BEGIN   
    ALTER TABLE #DAT DROP COLUMN SEP  
   END  
   
IF  @OCT = 0  
  BEGIN   
    ALTER TABLE #DAT DROP COLUMN OCT  
   END  
   
IF  @NOV = 0  
  BEGIN   
    ALTER TABLE #DAT DROP COLUMN NOV  
   END  
                                      
IF  @DEC = 0  
  BEGIN   
    ALTER TABLE #DAT DROP COLUMN DEC  
   END  
         
   
 declare @a VARCHAR(10)  
   
 declare @b VARCHAR(10)  
 declare @c VARCHAR(10)  
  
 SELECT  @a = DATENAME (month,DATEADD(MONTH, -1, GETDATE()))  
 SELECT  @b = DATENAME (month,DATEADD(MONTH, -2, GETDATE()))  
 SELECT  @c = DATENAME (month,DATEADD(MONTH, -3, GETDATE()))  
  
  
--SELECT DATENAME(month, getdate())  
  
--DECLARE @intFlag INT  
  
  
 SELECT  TAGGeneratedDate,Branch,SBTAG,TradeName,ISNULL (CAST(JUN AS VARCHAR(10)),'-') AS JUN,ISNULL (CAST(MAY AS VARCHAR(10)),'-') AS MAY,  
 ISNULL (CAST(APR AS VARCHAR(10)),'-') AS APR INTO #FINAL  
 from #DAT   
  
DECLARE @BODYMSG NVARCHAR(MAX)      
DECLARE @SUBJECT NVARCHAR(MAX)      
DECLARE @TABLEHTML NVARCHAR(MAX)    
DECLARE @MIX NVARCHAR(MAX)   
  
  
SET @TABLEHTML =   '<b> Dear Audit Team</b> , <BR/><BR/>   
  
Below MIS generated with the condition of SB/AP Tag creation from last six month and KYC open in the month of'+' '+  @a +' '+ '2019 for count of 15 and above <BR/><BR/> '   
   
 +    
  
  
N'<STYLE TYPE="TEXT/CSS">     
#BOX-TABLE      
{      
FONT-FAMILY: "LUCIDA SANS UNICODE", "LUCIDA GRANDE", SANS-SERIF;      
FONT-SIZE: 12PX;      
TEXT-ALIGN: CENTER;      
BORDER-COLLAPSE: COLLAPSE;      
BORDER-TOP: 7PX SOLID #9BAFF1;      
BORDER-BOTTOM: 7PX SOLID #9BAFF1;      
}      
#BOX-TABLE TH      
{      
FONT-SIZE: 13PX;      
FONT-WEIGHT: NORMAL;      
BACKGROUND: #4286f4;      
BORDER-RIGHT: 2PX SOLID #9BAFF1;      
BORDER-LEFT: 2PX SOLID #9BAFF1;      
BORDER-BOTTOM: 2PX SOLID #9BAFF1;      
COLOR: #039;      
}      
#BOX-TABLE TD      
{      
BORDER-RIGHT: 1PX SOLID #AABCFE;      
BORDER-LEFT: 1PX SOLID #AABCFE;      
BORDER-BOTTOM: 1PX SOLID #AABCFE;      
COLOR: #669;      
}      
TR:NTH-CHILD(ODD) { BACKGROUND-COLOR:#EEE; }      
TR:NTH-CHILD(EVEN) { BACKGROUND-COLOR:#FFF; }       
</STYLE>'+      
N'<TABLE BORDER=1 >' +      
N'<TR><TH BGCOLOR = "#00bfff">DATE </TH>  
<TH BGCOLOR = "#00bfff"> SBTAG </TH>     
<TH BGCOLOR = "#00bfff"> Branch </TH>     
<TH BGCOLOR = "#00bfff"> Trade Name </TH>  
<TH BGCOLOR = "#00bfff"> '+@a+'</TH>      
<TH BGCOLOR = "#00bfff">'+@b+'</TH>  
<TH BGCOLOR = "#00bfff">'+@c+'</TH>   
<FONT COLOR="BLUE">           
</TR>' +   
  
CAST ( (     
     
select VDATE=(CONVERT(VARCHAR(20),TAGGeneratedDate)),' ',TD = [SBTAG],' ', TD = [Branch],' ', TD = [TradeName] ,' ',TD = [JUN],' ',TD = [MAY],' ',TD = [APR],' '  
 from #FINAL ORDER BY VDATE DESC  
  
 FOR XML PATH('TR'), TYPE       
  
) AS NVARCHAR(MAX) ) +    
N'</TABLE> <BR/> <BR/>' +  
  
'Regards,<BR/>  
  
Sub Brokerage Operation (System Generated) <BR/><BR/>' +  
  
'<FONT COLOR="BLUE"> <b> Coordinator : Hemant P Patel'  
  
  
  
 SET @MIX =  @TABLEHTML   
   
  
DECLARE @FILE VARCHAR(MAX),@PATH VARCHAR(MAX) = 'J:\BackOffice\Automation\SB_HEMENT\'                     
  
SET @FILE = @PATH + 'SB' + CONVERT(VARCHAR(11), GETDATE(), 112) + '.xls' --Folder Name   
  
DECLARE @D VARCHAR(200)  
SET @D = 'SB/AP creation from last six month with KYC FOR' + ' ' +  DATENAME (month,DATEADD(MONTH, -1, GETDATE())) + ' '+  DATENAME(YEAR, getdate())  
  
DECLARE @S VARCHAR(MAX)                            
  
SET @S = 'EXEC MASTER.DBO.XP_CMDSHELL ''BCP "SELECT ''''TAGGeneratedDate'''',''''Branch'''',''''SBTAG'''',''''TradeName'''',''''cl_code'''',''''LONG_NAME'''',''''cl_Active_Date'''',''''cl_CITY'''',''''cl_STATE'''''    --Column Name  
  
SET @S = @S + ' UNION ALL SELECT  cast([TAGGeneratedDate] as varchar), cast([Branch] as varchar),cast([SBTAG] as varchar),cast([TradeName] as varchar),cast([cl_code] as varchar),cast([LONG_NAME] as varchar),cast([cl_Active_Date] as varchar),cast([cl_CITY
] as varchar),cast([cl_STATE] as varchar)  FROM [MSAJAG].[dbo].[ATTACHEDDATA]   " QUERYOUT ' --Convert data type if required  
  
 +@file+ ' -c -SABVSNSECM.angelone.in -Uaolinhouse -Pe$$gnfDTVs2455GZAcc'''         
         
PRINT (@S)                                  
EXEC(@S)     
  
EXEC MSDB.DBO.SP_SEND_DBMAIL                                    
  
@PROFILE_NAME ='DBA',                                    
  
@RECIPIENTS ='int.sbaudit@angelbroking.com',   
  
--@RECIPIENTS ='punit.verma@angelbroking.com',   
  
@COPY_RECIPIENTS='',   
  
@blind_copy_recipients ='punit.verma@angelbroking.com;hemantp.patel@angelbroking.com',                                   
  
@FILE_ATTACHMENTS= @FILE,  
  
@BODY = @MIX,  
  
@BODY_FORMAT ='HTML',                                   
  
@SUBJECT = @D

GO
