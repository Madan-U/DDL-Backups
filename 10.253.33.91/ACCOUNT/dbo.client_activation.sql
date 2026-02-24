-- Object: PROCEDURE dbo.client_activation
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------

--client_activation '20/04/2016','20/04/2016'                           
create PROC [dbo].[client_activation] (@FROMDATE VARCHAR(11), 
                                                 @TODATE   VARCHAR(11)) 
AS 
    IF Len(@FROMDATE) = 10 
       AND Charindex('/', @FROMDATE) > 0 
      BEGIN 
          SET @FROMDATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @FROMDATE, 103) 
                          , 
                          109) 
      END 

    IF Len(@TODATE) = 10 
       AND Charindex('/', @TODATE) > 0 
      BEGIN 
          SET @TODATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @TODATE, 103), 
                        109) 
      END 

    PRINT @FROMDATE 

  BEGIN 
      SELECT * 
      INTO   #temp 
      FROM   (SELECT  [cl_code]=[L1].cl_code, 
                     [long_name] =L.long_name, 
                     [branch_cd] =L.branch_cd, 
                     [sub_broker] =L.sub_broker, 
                     [region] =L.region, 
                     --[exchange] =L1.exchange, 
                     --[segment]=L1.segment, 
                     [email] =L.email, 
                     [mobile_pager] =L.mobile_pager
                     --[active_date] =L1.active_date, 
                     --[inactive_from] =L1.inactive_from                      
                    
              FROM   msajag..Client_Details L (nolock), 
                     msajag..client_brok_details L1 (nolock) 
              WHERE  L1.cl_code=L.CL_CODE
              AND L1.Active_Date>=@FROMDATE AND L1.Active_Date<=@TODATE + ' 23:59')A
              
              
              SELECT  DISTINCT * FROM #TEMP ORDER BY CL_CODE
              
      --        CREATE CLUSTERED INDEX idx_cl 
      --  ON #temp ( CL_CODE  ) 

      --SELECT [CL_CODE]=Replace(Ltrim(Rtrim(A.CL_CODE)), ' ', ''), 
      --       [long_name]=Replace(Ltrim(Rtrim(A.long_name)), ' ', ''),
      --       [BRANCH_CD]=Replace(Ltrim(Rtrim(B.branch_cd)), ' ', ''), 
      --       [SUB_BROKER]=Replace(Ltrim(Rtrim(B.sub_broker)), ' ', ''), 
      --       [REGION]=Replace(Ltrim(Rtrim(B.region)), ' ', ''), 
      --       [EXCHANGE]=Replace(Ltrim(Rtrim(A.exchange)), ' ', ''), 
      --       [segment]=Replace(Ltrim(Rtrim(A.segment)), ' ', ''), 
      --       [email]=Replace(Ltrim(Rtrim(A.email)), ' ', ''), 
      --       [mobile_pager]=Replace(Ltrim(Rtrim(A.mobile_pager)), ' ', ''), 
      --       CONVERT(VARCHAR(11), CONVERT(DATETIME, A.active_date, 103), 103)   AS active_date,
      --       CONVERT(VARCHAR(11), CONVERT(DATETIME, A.inactive_from, 103), 103)   AS inactive_from,
      --       [deactive_remarks]=Replace(Ltrim(Rtrim(A.deactive_remarks)), ' ', ''), 
      --       [deactive_value]=Replace(Ltrim(Rtrim(A.deactive_value)), ' ', '')
            
      --FROM   #temp AS A 
      --       LEFT OUTER JOIN client_details AS B 
      --                    ON A.cl_code = B.cl_code 
      --ORDER  BY a.cl_code 
                     
  END

GO
