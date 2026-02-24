-- Object: PROCEDURE dbo.PAYOUTDATA_testp
-- Server: 10.253.33.91 | DB: ACCOUNT
--------------------------------------------------


--PAYOUTDATA_testp '25/04/2016','28/04/2016'   
               
CREATE proc PAYOUTDATA_testp (                        
                        
@FROMDATE varchar(11) ,                         
@TODATE   varchar(11)                         
)                  
AS                       
                    
IF LEN(@FROMDATE) = 10 AND CHARINDEX('/', @FROMDATE) > 0                      
                      
BEGIN                      
                      
      SET @FROMDATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @FROMDATE, 103), 109)                      
                      
END                      
                      
IF LEN(@TODATE) = 10 AND CHARINDEX('/', @TODATE) > 0                      
                      
BEGIN                      
                      
      SET @TODATE = CONVERT(VARCHAR(11), CONVERT(DATETIME, @TODATE, 103), 109)                      
                      
END                      
                      
                       
 print @FROMDATE                     
                      
BEGIN                         
 SELECT * INTO #TEMP FROM (                       
  SELECT                      
[CLTCODE]=CLTCODE,                        
[VDT]=L.VDT,                        
[vno]= L.VNO,                        
[NARRATION]=L.NARRATION,                        
[VAMT]=L.VAMT,                      
[DRCR]=L.DRCR,                        
[DDNO]=L1.ddno,                        
[vtyp]=L.VTYP,                        
[reldt]=L1.reldt,                       
[BOOKTYPE]=L.BOOKTYPE,                       
[EXCHANGE]='NSE'                        
                        
                        
FROM LEDGER L , LEDGER1 L1 (NOLOCK)                      
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                       
AND L.DRCR ='D' AND L.VTYP =3  AND L.vdt> =@FROMDATE                      
and L.vdt< = @TODATE + ' 23:59' and L1.reldt='1900-01-01 00:00:00.000'                      
UNION ALL                        
                      
SELECT CLTCODE,L.vdt,L.VNO,L.narration,L.vamt,L.DRCR,L1.ddno,                      
 L.vtyp,L1.reldt,L.BOOKTYPE,'NSE' AS EXCHANGE                      
 FROM LEDGER L, LEDGER1 L1 (NOLOCK)                      
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                       
AND L.DRCR ='C' AND L.VTYP =3  AND L.vdt> =@FROMDATE and L1.reldt='1900-01-01 00:00:00.000'                      
and L.vdt< = @TODATE + ' 23:59'                       
                      
-----NSE----                      
UNION ALL                      
  SELECT                      
[CLTCODE]=CLTCODE,                        
[VDT]=L.VDT,                        
[vno]= L.VNO,                        
[NARRATION]=L.NARRATION,                        
[VAMT]=L.VAMT,                      
[DRCR]=L.DRCR,                        
[DDNO]=L1.ddno,                        
[vtyp]=L.VTYP,                        
[reldt]=L1.reldt,                       
[BOOKTYPE]=L.BOOKTYPE,                       
[EXCHANGE]='BSE'                        
                        
                        
FROM ANAND.ACCOUNT_AB.DBO.LEDGER L (NOLOCK) , ANAND.ACCOUNT_AB.DBO.LEDGER1 L1 (NOLOCK)                    
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                       
AND L.DRCR ='D' AND L.VTYP =3  AND L.vdt> =@FROMDATE                      
and L.vdt< = @TODATE + ' 23:59' and L1.reldt='1900-01-01 00:00:00.000'                      
UNION ALL                        
                      
SELECT CLTCODE,L.vdt,L.VNO,L.narration,L.vamt,L.DRCR,L1.ddno,                      
 L.vtyp,L1.reldt,L.BOOKTYPE,'BSE' AS EXCHANGE                      
 FROM ANAND.ACCOUNT_AB.DBO.LEDGER L (NOLOCK) , ANAND.ACCOUNT_AB.DBO.LEDGER1 L1 (NOLOCK)                     
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                       
AND L.DRCR ='C' AND L.VTYP =3  AND L.vdt> =@FROMDATE and L1.reldt='1900-01-01 00:00:00.000'                      
and L.vdt< = @TODATE + ' 23:59'                       
                      
---NSEFO---             
UNION all                      
 SELECT                      
[CLTCODE]=CLTCODE,                        
[VDT]=L.VDT,                        
[vno]= L.VNO,        
[NARRATION]=L.NARRATION,                        
[VAMT]=L.VAMT,                      
[DRCR]=L.DRCR,                        
[DDNO]=L1.ddno,                        
[vtyp]=L.VTYP,                        
[reldt]=L1.reldt,                       
[BOOKTYPE]=L.BOOKTYPE,                       
[EXCHANGE]='NSEFO'                        
                        
                        
FROM [ANGELFO].ACCOUNTFO.DBO.LEDGER L , [ANGELFO].ACCOUNTFO.DBO.LEDGER1 L1 (NOLOCK)                      
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                       
AND L.DRCR ='D' AND L.VTYP =3  AND L.vdt> =@FROMDATE                      
and L.vdt< = @TODATE + ' 23:59' and L1.reldt='1900-01-01 00:00:00.000'                      
UNION ALL                        
                      
SELECT CLTCODE,L.vdt,L.VNO,L.narration,L.vamt,L.DRCR,L1.ddno,                      
 L.vtyp,L1.reldt,L.BOOKTYPE,'NSEFO' AS EXCHANGE                      
 FROM [ANGELFO].ACCOUNTFO.DBO.LEDGER L, [ANGELFO].ACCOUNTFO.DBO.LEDGER1 L1 (NOLOCK)                      
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                       
AND L.DRCR ='C' AND L.VTYP =3  AND L.vdt> =@FROMDATE and L1.reldt='1900-01-01 00:00:00.000'                      
and L.vdt< = @TODATE + ' 23:59'                       
                      
---NSECURFO---                      
UNION all                      
 SELECT                      
[CLTCODE]=CLTCODE,                        
[VDT]=L.VDT,                        
[vno]= L.VNO,                        
[NARRATION]=L.NARRATION,                        
[VAMT]=L.VAMT,                      
[DRCR]=L.DRCR,                        
[DDNO]=L1.ddno,                        
[vtyp]=L.VTYP,                        
[reldt]=L1.reldt,                       
[BOOKTYPE]=L.BOOKTYPE,                       
[EXCHANGE]='NSECURFO'                        
                        
                        
FROM [ANGELFO].ACCOUNTCURFO.DBO.LEDGER L , [ANGELFO].ACCOUNTCURFO.DBO.LEDGER1 L1 (NOLOCK)                      
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                       
AND L.DRCR ='D' AND L.VTYP =3  AND L.vdt> =@FROMDATE                      
and L.vdt< = @TODATE + ' 23:59' and L1.reldt='1900-01-01 00:00:00.000'                      
UNION ALL                        
                      
SELECT CLTCODE,L.vdt,L.VNO,L.narration,L.vamt,L.DRCR,L1.ddno,                      
 L.vtyp,L1.reldt,L.BOOKTYPE,'NSECURFO' AS EXCHANGE                      
 FROM [ANGELFO].ACCOUNTCURFO.DBO.LEDGER L, [ANGELFO].ACCOUNTCURFO.DBO.LEDGER1 L1 (NOLOCK)                      
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                       
AND L.DRCR ='C' AND L.VTYP =3  AND L.vdt> =@FROMDATE and L1.reldt='1900-01-01 00:00:00.000'                      
and L.vdt< = @TODATE + ' 23:59'                       
                      
---MCDX---                      
                      
UNION all                      
 SELECT                      
[CLTCODE]=CLTCODE,                        
[VDT]=L.VDT,                        
[vno]= L.VNO,                        
[NARRATION]=L.NARRATION,                        
[VAMT]=L.VAMT,                      
[DRCR]=L.DRCR,                        
[DDNO]=L1.ddno,                        
[vtyp]=L.VTYP,                        
[reldt]=L1.reldt,                       
[BOOKTYPE]=L.BOOKTYPE,                       
[EXCHANGE]='MCDX'                        
                        
                        
FROM [ANGELCOMMODITY].ACCOUNTMCDX.DBO.LEDGER L , [ANGELCOMMODITY].ACCOUNTMCDX.DBO.LEDGER1 L1 (NOLOCK)                      
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                       
AND L.DRCR ='D' AND L.VTYP =3  AND L.vdt> =@FROMDATE                      
and L.vdt< = @TODATE + ' 23:59' and L1.reldt='1900-01-01 00:00:00.000'                   
UNION ALL                        
                      
SELECT CLTCODE,L.vdt,L.VNO,L.narration,L.vamt,L.DRCR,L1.ddno,                      
 L.vtyp,L1.reldt,L.BOOKTYPE,'MCDX' AS EXCHANGE                      
 FROM [ANGELCOMMODITY].ACCOUNTMCDX.DBO.LEDGER L, [ANGELCOMMODITY].ACCOUNTMCDX.DBO.LEDGER1 L1 (NOLOCK)                      
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                       
AND L.DRCR ='C' AND L.VTYP =3  AND L.vdt> =@FROMDATE and L1.reldt='1900-01-01 00:00:00.000'                      
and L.vdt< = @TODATE + ' 23:59'                       
                      
---MCDXCDS--                      
UNION all                      
 SELECT                  
[CLTCODE]=CLTCODE,                        
[VDT]=L.VDT,                        
[vno]= L.VNO,                        
[NARRATION]=L.NARRATION,                        
[VAMT]=L.VAMT,                      
[DRCR]=L.DRCR,                        
[DDNO]=L1.ddno,                        
[vtyp]=L.VTYP,                        
[reldt]=L1.reldt,                       
[BOOKTYPE]=L.BOOKTYPE,                       
[EXCHANGE]='MCDXCDS'                        
                        
                        
FROM [ANGELCOMMODITY].ACCOUNTMCDXCDS.DBO.LEDGER L , [ANGELCOMMODITY].ACCOUNTMCDXCDS.DBO.LEDGER1 L1 (NOLOCK)                      
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                       
AND L.DRCR ='D' AND L.VTYP =3  AND L.vdt> =@FROMDATE                      
and L.vdt< = @TODATE + ' 23:59' and L1.reldt='1900-01-01 00:00:00.000'                      
UNION ALL                        
                      
SELECT CLTCODE,L.vdt,L.VNO,L.narration,L.vamt,L.DRCR,L1.ddno,                      
 L.vtyp,L1.reldt,L.BOOKTYPE,'MCDXCDS' AS EXCHANGE                      
 FROM [ANGELCOMMODITY].ACCOUNTMCDXCDS.DBO.LEDGER L, [ANGELCOMMODITY].ACCOUNTMCDXCDS.DBO.LEDGER1 L1 (NOLOCK)                      
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                       
AND L.DRCR ='C' AND L.VTYP =3  AND L.vdt> =@FROMDATE and L1.reldt='1900-01-01 00:00:00.000'                      
and L.vdt< = @TODATE + ' 23:59'                       
                      
---NCDX--                      
                      
UNION all                      
 SELECT                      
[CLTCODE]=CLTCODE,                        
[VDT]=L.VDT,                        
[vno]= L.VNO,                        
[NARRATION]=L.NARRATION,                        
[VAMT]=L.VAMT,                      
[DRCR]=L.DRCR,                       
[DDNO]=L1.ddno,                        
[vtyp]=L.VTYP,                        
[reldt]=L1.reldt,                       
[BOOKTYPE]=L.BOOKTYPE,                       
[EXCHANGE]='NCDX'                        
                        
                        
FROM [ANGELCOMMODITY].ACCOUNTNCDX.DBO.LEDGER L , [ANGELCOMMODITY].ACCOUNTNCDX.DBO.LEDGER1 L1 (NOLOCK)                      
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                       
AND L.DRCR ='D' AND L.VTYP =3  AND L.vdt> =@FROMDATE                      
and L.vdt< = @TODATE + ' 23:59' and L1.reldt='1900-01-01 00:00:00.000'                      
UNION ALL                        
                      
SELECT CLTCODE,L.vdt,L.VNO,L.narration,L.vamt,L.DRCR,L1.ddno,                      
 L.vtyp,L1.reldt,L.BOOKTYPE,'NCDX' AS EXCHANGE                      
 FROM [ANGELCOMMODITY].ACCOUNTNCDX.DBO.LEDGER L, [ANGELCOMMODITY].ACCOUNTNCDX.DBO.LEDGER1 L1 (NOLOCK)                      
WHERE L.VNO=L1.VNO AND L.VTYP=L1.VTYP AND L.BOOKTYPE=L1.BOOKTYPE                       
AND L.DRCR ='C' AND L.VTYP =3  AND L.vdt> =@FROMDATE and L1.reldt='1900-01-01 00:00:00.000'                      
and L.vdt< = @TODATE + ' 23:59'                       
                      
                      
) A                        
                      
  UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,'/','')                      
where narration like '%/%'                      
UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,'|','')                      
where narration like '%|%'                      
UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,':','')                      
where narration like '%:%'                      
UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,'.','')                      
where narration like '%.%'                      
                      
UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,'_',' ')                      
where narration like '%_%'                      
                      
UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,'-',' ')                      
where narration like '%-%'                      
                      
UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,')',' ')                      
where narration like '%)%'                      
                      
UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,'(',' ')                      
where narration like '%(%'                      
                      
UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,'&',' ')                  
where narration like '%&%'                      
                    
UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,'#',' ')                      
where narration like '%#%'                      
                  
UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,',',' ')                      
where narration like '%,%'                    
                  
UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,':-',' ')                      
where narration like '%:-%'                    
                  
UPDATE #TEMP SET NARRATION = REPLACE(NARRATION,'"',' ')                      
where narration like '%"%'                    
                      
--select NARRATION from #temp                      
--where narration like '%%'                      
----where narration like '%:/.?=_-$(){}~&%'                      
--return                      
                    
                    
SELECT                         
[EXCHANGE]   = A.EXCHANGE,                     
[SHORT_NAME] = B.SHORT_NAME,                                          
[REGION]     = B.REGION,                                          
[BRANCH_CD]  = B.BRANCH_CD,                                       
[SUB_BROKER] = B.SUB_BROKER,           
[BANK_NAME]  = B.BANK_NAME,                                          
[AC_NUM]     = B.AC_NUM,                                        
[CLTCODE]    = A.CLTCODE,                              
[VDT]        = A.vdt,                                               
[VNO]        = A.vno,    
LEFT(REPLACE(REPLACE(REPLACE(A.NARRATION,'''',''),'""',''),'"',''),100) AS NARRATION,                                          
--[NARRATION]  = left(REPLACE(A.narration , '"', ''),100),                                                       
[VAMT]       = A.vamt,                                            
[DRCR]   = A.DRCR,                          
[DDNO]   = A.ddno,                                                     
[VTYP]   = A.vtyp,                             
[RELDT]   = A.reldt,                                             
[BOOKTYPE]  = A.BOOKTYPE                                                                           
FROM #TEMP AS A LEFT OUTER JOIN                                          
MSAJAG.DBO.CLIENT_DETAILS AS B ON A.CLTCODE = B.CL_CODE 
where [EXCHANGE] IN ('MCDX','NCDX','MCDXCDS') AND a.cltcode in ('S157105',
'G16316',
'D46323',
'P75594',
'V58412',
'R88572',
'M91437',
'M91430',
'A94531',
'J12434',
'P74783',
'M70915',
'J16150',
'J42978',
'S121500',
'K65612',
'M88024',
'M91814',
'N47688',
'R91213',
'A86576',
'R89854',
'S150397',
'D52724',
'N24971',
'R62167',
'S145906',
'DELL2591',
'S144142',
'JLND2580',
'FRD1397',
'A97052',
'P67714',
'BRLY1888',
'NEHR4980',
'M80626',
'M65830',
'G14255',
'B12152',
'V56746',
'V41526',
'AGRA2120',
'V28043',
'D44195',
'M77688',
'P67214',
'DELP3732',
'AND4611',
'AMRT1438',
'ALWR1900',
'M60146',
'P70022',
'D36117',
'S74531',
'I7151',
'S148933',
'BKNR3042',
'AGRA2733',
'D13181',
'D49189',
'SGNL137',
'G23195',
'S156724',
'JOD17312',
'A70141',
'G27811',
'M84043',
'JLND1270',
'JLND1269',
'R48419',
'Z2669',
'MSGH144',
'S116695',
'AJMR2891',
'H34303',
'H34888',
'KNPR6199',
'JAIP14515',
'A94843',
'S152595',
'H35126',
'D45502',
'PTA10161',
'S141092',
'JAIP19179',
'J15666',
'A98571',
'JOD13645',
'G17709',
'B45246',
'A93868',
'M56880',
'S121454',
'P55246',
'K54893',
'P50071',
'JL1597',
'A94600',
'M87348',
'P64478',
'S113116',
'B42563',
'S156964',
'P70505',
'P72574',
'JAIP20882',
'V35634',
'S157226',
'A12764',
'D13220',
'AFSR004',
'S126593',
'R67449',
'V41466',
'UPO012',
'V28080',
'V55295',
'S123617',
'S71484',
'M89987',
'KNPSK1426',
'M89591',
'D52622',
'N50500',
'A12002',
'M87202',
'P66335',
'R79126',
'A81344',
'A98315',
'S153149',
'P37825',
'L11023',
'A17546',
'P74612',
'R50091',
'P54286',
'A80909',
'H30496',
'B41907',
'DHRADN2083',
'P69837',
'MMTR010',
'R85219',
'M80468',
'A83987',
'P67063',
'S157283',
'D38976',
'KNPSK1564',
'M90273',
'R88480',
'AJMR2925',
'R90785',
'Z2666',
'N25922',
'S153439',
'FRD268',
'R85093',
'T8780',
'PTA16410',
'T14673',
'D38264',
'M84956',
'NOD495',
'J12922',
'S155808',
'V58965',
'C19844',
'S133222',
'F2080',
'A90944',
'A91019',
'J37059',
'Q1143',
'S157540',
'J41286',
'R82764',
'R88420',
'H17581',
'D41190',
'A90779',
'P60925',
'P68444',
'H20860',
'D44669',
'M85478',
'SBHS039',
'KLGP1612',
'K55751',
'V56262',
'AGRA2741',
'P62671',
'M84697',
'PTA16381',
'R90482',
'JAIP19724',
'S157656',
'ALWR1931',
'K61461',
'AJTS016',
'B5336',
'AAIS006',
'R77955',
'S108815',
'P73833',
'FRD743',
'JNNN003',
'JNNN017',
'G29278',
'M69078',
'S149122',
'S156722',
'B28969',
'A84081',
'GG189',
'K65229',
'DELL3836',
'R66494',
'M88246',
'PTM5038',
'N45917',
'ARAA032',
'A98123',
'L6009',
'POONB071',
'M85837',
'P70677',
'N45736',
'JAIP20847',
'K66180',
'SRKH011',
'JOD15731',
'SRKH006',
'LOKU005',
'VRN2495',
'K50267',
'T14107',
'R46477',
'E1194',
'E1615',
'K61974',
'R88323',
'S109069',
'D13096',
'BTBN015',
'POONB051',
'D10348',
'D51407',
'SMRM003',
'J42866',
'DELP2844',
'K66053',
'M91475',
'P74686',
'ALWR1828',
'N50596',
'P68181',
'V46698',
'DELP4784',
'GRGN4381',
'AMRT2096',
'S122665',
'A80286',
'MGNI071',
'N48682',
'ALWR1940',
'R82259',
'JAIP19674',
'NOD1723',
'PTA13913',
'PTA13915',
'PTA13910',
'PTA13922',
'PTA13905',
'PTA13900',
'PTA13924',
'PTA13911',
'A85138',
'KNPR6168',
'KNPR6172',
'JLND2910',
'JOD16595',
'JANAK3147',
'Y9082',
'INDP006',
'S158021',
'P40831',
'VKE057',
'ANKT038',
'AJTS013',
'P73693',
'AMBCT1614',
'B44752',
'N49574',
'NEHR5725',
'S156997',
'UMV072',
'UMV659',
'DYVM105',
'AMBCT1116',
'S53824',
'Y8590',
'S157847',
'JLND2655',
'M87964',
'A46216',
'JAIP20769',
'CP6231',
'N49500',
'MNPN028',
'P71932',
'YYSO012',
'K20898',
'UPO047',
'NOD883',
'L12159',
'J10069',
'D13383',
'AJMR2837',
'KNPR3360',
'M89564',
'P27465',
'U10800',
'G29077',
'R91566',
'NAB60',
'Y9098',
'S127835',
'S122923',
'S30734',
'NEHR5876',
'K66103',
'S156293',
'C22838',
'S157058',
'P61086',
'A98372',
'G29207',
'N16031',
'P69652',
'V57726',
'A87422',
'A75542',
'NEHR4475',
'DELL4140',
'A98300',
'N51891',
'KOLK17191',
'K65552',
'KNPR5001',
'RYV075',
'LUDH1868',
'L10149',
'DARKA2053',
'AGRA2181',
'JAIP20884',
'AGRA2723',
'B36163',
'A90562',
'MMRJ057',
'B41776',
'A85328',
'A52416',
'P64527',
'J24286',
'K65995',
'R91295',
'B43829',
'L11889',
'J43261',
'D52110',
'N8943',
'K66167',
'R61125',
'B15049',
'A94235',
'P75455',
'CHND4111',
'U9371',
'S156959',
'RAPU002',
'D50943',
'I6466',
'C19537',
'P69636',
'D13102',
'LUCK5865',
'V19751',
'L11034',
'BKNR1626',
'K56917',
'D51778',
'PTA17133',
'HNAP002',
'L12459',
'M69635',
'S148716',
'GRGN4765',
'M87710',
'S3999',
'B41534',
'H32962',
'K51897',
'J39952',
'D52935',
'D50297',
'G12169',
'R52646',
'S157774',
'KGCL009',
'BUND068',
'K61990',
'A98736',
'P68072',
'D50677',
'CHEN10302',
'D13157',
'H15453',
'S152956',
'K65939',
'BKNR2804',
'JAIP20787',
'P32810',
'G17696',
'J26605',
'Y7805',
'S84738',
'WANT009',
'WANT064',
'P34374',
'MYB070',
'KKAI005',
'KLGP1631',
'S151539',
'B24017',
'S128805',
'JLND2654',
'PTM5027',
'JAIP18658',
'P64313',
'C23071',
'MYS082',
'B45055',
'E1963',
'T14571',
'N51733',
'M90914',
'MMDK003',
'S137366',
'A94020',
'CHND3699',
'N49423',
'C12173',
'R88180',
'P70092',
'WALT017',
'NHPL392',
'JNNN019',
'V24515',
'K63652',
'MANS808',
'SNAH041',
'P10015',
'R63919',
'JANAK4653',
'A82176',
'BRLY1508',
'Y8790',
'R87454',
'S123549',
'S146598',
'C21740',
'N54065',
'SBD4740',
'J42931',
'M90778',
'DARKA2567',
'S157493',
'AGRA2737',
'D52760',
'SBHS040',
'P34294',
'A38719',
'ALHA1809',
'S150927',
'V59005',
'RJPR1126',
'R84361',
'S154851',
'MVD6767',
'E2004',
'S155957',
'ARCN053',
'M90989',
'C15226',
'M91061',
'M91356',
'R91202',
'ALHA1800',
'H17057',
'DDHJ004',
'B23684',
'Y640',
'C17186',
'S155316',
'S140944',
'DARKA1556',
'DLH007',
'R88944',
'S155432',
'S110936',
'NLKU019',
'S148314',
'V49824',
'S133607',
'P71264',
'R90899',
'S118731',
'NLKU016',
'K61396',
'C18867',
'D39747',
'A97892',
'M84720',
'AND5619',
'P75584',
'AJMR2950',
'K65447',
'C22939',
'S140048',
'J35596',
'P70227',
'P58027',
'S146209',
'JAIP11148',
'JAIP12325',
'J44011',
'JAIP10654',
'SCHA026',
'V30123',
'P71657',
'S103900',
'NOD1626',
'S35673',
'T12356',
'SBD4490',
'P17014',
'R90913',
'MSGH146',
'JAIP19775',
'H18093',
'S67255',
'N26465',
'G28016',
'P73534',
'B42186',
'D13492',
'K66041',
'A97194',
'P62206',
'M91802',
'S153267',
'JOGN040',
'M86183',
'PTM4486',
'R90925',
'S127143',
'S135448',
'P70841',
'GEA040',
'NEHR594',
'JOD17103',
'U10054',
'GRGN6524',
'AJMR1336',
'N41126',
'A85182',
'V56896',
'AL4444',
'S104894',
'JAIP19218',
'P57570',
'J2081',
'A97365',
'P74954',
'V46138',
'PTM5914',
'D51479',
'CHEN7385',
'R90760',
'A91302',
'BKNR2535',
'P74371',
'JAIP20837',
'VBR148',
'K61169',
'SBD695',
'I5826',
'K50436',
'CHND4173',
'JOD16176',
'K27416',
'U4577',
'ILA285',
'AMBCT1564',
'VKAH002',
'M80650',
'S139362',
'H35239',
'AND5478',
'Y1427',
'KLGP1364',
'N26363',
'JAIP16609',
'C21302',
'S157391',
'JOD16381',
'R6352',
'P60218',
'T12244',
'C20407',
'N31666',
'S117453',
'NIHI079',
'B43343',
'N52377',
'S109804',
'SGNL100',
'P17401',
'S156269',
'S130821',
'ANEP005',
'S133559',
'JAIP17986',
'R90407',
'JAIP20295',
'R90523',
'A50630',
'A70422',
'S155632',
'S29582',
'GJ3642',
'A83804',
'S131474',
'S156386',
'R83664',
'B39349',
'A24401',
'N49927',
'D25532',
'H24383',
'R18571',
'R33389',
'SRNR009',
'R78739',
'R78314',
'DDPD013',
'G29289',
'BKNR1927',
'PTA23300',
'S147026',
'P74330',
'H34304',
'A95843',
'SAKY006',
'A92001',
'L9609',
'A98374',
'M90058',
'S108851',
'B44442',
'DELL4201',
'M90574',
'Y8814',
'R67650',
'P46660',
'M78139',
'M89109',
'D51271',
'P70903',
'D13195',
'K60372',
'N38721',
'A87033',
'P67238',
'V37554',
'G22501',
'MLD156',
'B43378',
'SBD4349',
'A61449',
'JAIP18479',
'N47708',
'W547',
'N34493',
'K63406',
'SGMA012',
'JANAK4206',
'J43774',
'L12112',
'PTM5221',
'C23182')                 
ORDER BY EXCHANGE                        
                      
--SELECT b.short_name,b.region,b.branch_cd,b.sub_broker,b.Bank_Name,b.AC_Num, A.* FROM #TEMP A                      
--LEFT OUTER JOIN                      
--msajag.dbo.client_details B on a.cltcode = b.cl_code ORDER BY EXCHANGE                      
                      
                        
END

GO
